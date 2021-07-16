import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/navigation_bloc/navigation_bloc.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/search/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/payment_successful_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key key, this.isMenuTapped, this.setPageInTabs})
      : super(key: key);
  final Function isMenuTapped;
  final Function setPageInTabs;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isDarkMode;
  Razorpay _razorpay;
  List<Cart> carts = [];
  bool _takeaway = false;
  bool _cash = false;
  Product bottomSheetData;
  bool showbottomSheet = false;

  int selectedApperanceTile = 0;
  String _apperance = null;
  setSelectedApperanceTile(int val) {
    setState(() {
      selectedApperanceTile = val;
      if (selectedApperanceTile == 1) {
        setState(() {
          _takeaway = false;
          _cash = false;
        });
      } else if (selectedApperanceTile == 2) {
        setState(() {
          _cash = true;
          _takeaway = false;
        });
      } else if (selectedApperanceTile == 3) {
        setState(() {
          _takeaway = true;
          _cash = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(
      {dynamic totalPrice,
      String description,
      String userEmail,
      String userPhone}) async {
    var options = {
      'key': 'rzp_test_rLkToMYLuW8L79',
      'amount': totalPrice * 100,
      'name': 'Tazaz',
      'description': description,
      'prefill': {'contact': userPhone, 'email': userEmail},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("branchidshr");
    print("Payment successfull ${response.paymentId}");
    Provider.of<OrderProvider>(context, listen: false).placeOrder(
        PlaceOrderBody(
            cart: carts,
            couponDiscountAmount:
                Provider.of<CouponProvider>(context, listen: false).discount,
            couponDiscountTitle: '',
            deliveryAddressId: 0,
            orderAmount: 100,
            orderNote: '',
            orderType: "pay_online",
            paymentMethod: 'pay_online',
            couponCode:
                Provider.of<CouponProvider>(context, listen: false).coupon !=
                        null
                    ? Provider.of<CouponProvider>(context, listen: false)
                        .coupon
                        .code
                    : null,
            branchId: id),
        null);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessfulScreen(
          razorPaymentId: response.paymentId,
        ),
      ),
    ).then((value) {
      widget.setPageInTabs(0);
      BlocProvider.of<NavigationBloc>(context)
          .add(NavigationEvents.HomePageClickedEvent);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          getTranslated("pay_fail", context),
          style: TextStyle(color: Colors.white),
        )));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET:  ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false)
        .setOrderType('delivery', notify: false);
    final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
        GlobalKey<ScaffoldMessengerState>();
    final TextEditingController _couponController = TextEditingController();
    final ScrollController _scrollController = ScrollController();
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
      key: _scaffoldKey,
      // appBar: CustomAppBar(title: getTranslated('my_cart', context), isBackButtonExist: false),
      body: Scaffold(
        backgroundColor: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
        body: SafeArea(
          child: showbottomSheet
              ? CartBottomSheet(
                  product: bottomSheetData,
                  callback: () {
                    showbottomSheet = false;
                    setState(() {});
                  },
                )
              : CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height * 0.22,
                      floating: false,
                      stretch: true,
                      elevation: 0,
                      pinned: false,
                      stretchTriggerOffset: 150.0,
                      titleSpacing: 0,
                      leading: Container(),
                      flexibleSpace: FlexibleSpaceBar(
                        stretchModes: [
                          StretchMode.zoomBackground,
                        ],
                        background: Container(
                          color: _isDarkMode
                              ? Color(0xff000000)
                              : Color(0xffF5F5F5),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.16,
                                decoration: BoxDecoration(
                                  color: Color(int.parse(
                                          "#00A4A4".substring(1, 7),
                                          radix: 16) +
                                      0xFF000000),
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16),
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(
                                          top: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                getTranslated(
                                                    "deliveringto", context),
                                                style: TextStyle(
                                                    color:
                                                        /*_isDarkMode
                                                  ?Color(0xff000000):*/
                                                        Color(0xffffffff),
                                                    fontSize: 16),
                                              ),
                                              SizedBox(width: 3),
                                              Consumer<LocationProvider>(
                                                builder: (context,
                                                        locationProvider,
                                                        child) =>
                                                    locationProvider.addressList !=
                                                                null &&
                                                            locationProvider
                                                                .addressList
                                                                .isNotEmpty
                                                        ? Text(
                                                            '${locationProvider.addressList[0].streetAddress ?? ''} ',
                                                            softWrap: true,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                    /*_isDarkMode
                                                          ?Color(0xff000000):*/
                                                                    Color(
                                                                        0xffffffff),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 16),
                                                          )
                                                        : SizedBox(),
                                              ),
                                            ],
                                          ),
                                          /*SizedBox(height: 5),
                                    Consumer<LocationProvider>(
                                      builder: (context, locationProvider,
                                              child) =>
                                          locationProvider.addressList !=
                                                      null &&
                                                  locationProvider
                                                      .addressList.isNotEmpty
                                              ? Text(
                                                  '${locationProvider.addressList[0].streetAddress ?? ''} ',
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: */ /*_isDarkMode
                                                          ?Color(0xff000000):*/ /*Color(0xffffffff),
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 16),
                                                )
                                              : SizedBox(),
                                    ),*/
                                          SizedBox(height: 5),
                                          Consumer<ProfileProvider>(
                                            builder: (context, profileProvider,
                                                    child) =>
                                                profileProvider.userInfoModel !=
                                                        null
                                                    ? Text(
                                                        '${profileProvider.userInfoModel.fName ?? ''}',
                                                        style: TextStyle(
                                                            color:
                                                                /*_isDarkMode
                                                          ?Color(0xff000000):*/
                                                                Color(
                                                                    0xffffffff),
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 16),
                                                      )
                                                    : SizedBox(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    margin: EdgeInsets.only(
                                        top: (MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.03)),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.menu,
                                        color:
                                            /*_isDarkMode
                                      ?Color(0xff000000):*/
                                            Color(0xffffffff),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          // xOffset = 230;
                                          // yOffset = 150;
                                          // scaleFactor = 0.6;
                                          // isMenuOpened = true;
                                        });
                                        print("hello");
                                        widget.isMenuTapped();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(
                                    top: (MediaQuery.of(context).size.height *
                                        0.1)),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchScreen()));
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .67,
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(
                                                  "#FFFFFF".substring(1, 7),
                                                  radix: 16) +
                                              0xFF000000),
                                          border: Border.all(
                                            color: Color(int.parse(
                                                    "#FFFFFF".substring(1, 7),
                                                    radix: 16) +
                                                0xFF000000),
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.PADDING_SIZE_SMALL,
                                            vertical: 2),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                getTranslated(
                                                    "deliverytime", context),
                                                style: rubikRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_EXTRA_SMALL,
                                                    color: Colors.black),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          double deliveryCharge = 0;
                          Provider.of<OrderProvider>(context).orderType ==
                                  'delivery'
                              ? deliveryCharge = double.parse(
                                  Provider.of<SplashProvider>(context,
                                          listen: false)
                                      .configModel
                                      .deliveryCharge)
                              : deliveryCharge = 0;
                          List<List<AddOns>> _addOnsList = [];
                          List<bool> _availableList = [];
                          double _itemPrice = 0;
                          double _discount = 0;
                          double _tax = 0;
                          double _addOns = 0;
                          cart.cartList.forEach((cartModel) {
                            List<AddOns> _addOnList = [];
                            cartModel.addOnIds.forEach((addOnId) {
                              for (AddOns addOns in cartModel.product.addOns) {
                                if (addOns.id == addOnId.id) {
                                  _addOnList.add(addOns);
                                  break;
                                }
                              }
                              for (AddOns addOns in cartModel.product.addOns1) {
                                if (addOns.id == addOnId.id) {
                                  _addOnList.add(addOns);
                                  break;
                                }
                              }
                              for (AddOns addOns in cartModel.product.addOns2) {
                                if (addOns.id == addOnId.id) {
                                  _addOnList.add(addOns);
                                  break;
                                }
                              }
                            });

                            _addOnsList.add(_addOnList);
                            DateTime _currentTime = Provider.of<SplashProvider>(
                                    context,
                                    listen: false)
                                .currentTime;
                            DateTime _start = DateFormat('hh:mm:ss')
                                .parse(cartModel.product.availableTimeStarts);
                            DateTime _end = DateFormat('hh:mm:ss')
                                .parse(cartModel.product.availableTimeEnds);
                            DateTime _startTime = DateTime(
                                _currentTime.year,
                                _currentTime.month,
                                _currentTime.day,
                                _start.hour,
                                _start.minute,
                                _start.second);
                            DateTime _endTime = DateTime(
                                _currentTime.year,
                                _currentTime.month,
                                _currentTime.day,
                                _end.hour,
                                _end.minute,
                                _end.second);
                            if (_endTime.isBefore(_startTime)) {
                              _endTime = _endTime.add(Duration(days: 1));
                            }
                            bool _isAvailable =
                                _currentTime.isAfter(_startTime) &&
                                    _currentTime.isBefore(_endTime);
                            _availableList.add(_isAvailable);

                            for (int index = 0;
                                index < _addOnList.length;
                                index++) {
                              _addOns = _addOns +
                                  (_addOnList[index].price *
                                      cartModel.addOnIds[index].quantity);
                            }
                            _itemPrice = _itemPrice +
                                (cartModel.price * cartModel.quantity);
                            _discount = _discount +
                                (cartModel.discountAmount * cartModel.quantity);
                            _tax = _tax +
                                (cartModel.taxAmount * cartModel.quantity);
                          });
                          double _subTotal = _itemPrice + _tax + _addOns;
                          double _total = _subTotal -
                              _discount -
                              Provider.of<CouponProvider>(context).discount +
                              deliveryCharge;

                          // double _orderAmount = _itemPrice + _addOns;

                          return cart.cartList.length > 0
                              ? Column(children: [
                                  // Product
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cart.cartList.length,
                                    itemBuilder: (context, index) {
                                      return /*Container(
                                  margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
                                  decoration: BoxDecoration(
                                      color: Colors.red, borderRadius: BorderRadius.circular(10)),
                                  child: Stack(children: [
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child:
                                      Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
                                    ),
                                    Container(
                                      //padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[
                                            Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: FadeInImage.assetNetwork(
                                                    placeholder: Images.placeholder_image,
                                                    image:
                                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${cart.cartList[index].product.image}',
                                                    height: 100,
                                                    width: 85,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                _availableList[index]
                                                    ? SizedBox()
                                                    : Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  bottom: 0,
                                                  right: 0,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.black.withOpacity(0.6)),
                                                    child: Text(
                                                        getTranslated(
                                                            'not_available_now_break', context),
                                                        textAlign: TextAlign.center,
                                                        style: rubikRegular.copyWith(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width * .3,
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                              child: Text(cart.cartList[index].product.name,
                                                                  style: rubikBold,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5),
                                                        */ /*addOns.length > 0
                                ? SizedBox(
                                    height: 30,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      padding: EdgeInsets.only(
                                          top: Dimensions.PADDING_SIZE_SMALL),
                                      itemCount: addOns.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              right: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: Row(children: [
                                            InkWell(
                                              onTap: () {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .removeAddOn(
                                                        cartIndex, index);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2),
                                                child: Icon(Icons.remove_circle,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 18),
                                              ),
                                            ),
                                            Text(addOns[index].name,
                                                style: rubikRegular),
                                            SizedBox(width: 2),
                                            Text(
                                                PriceConverter.convertPrice(
                                                    context,
                                                    addOns[index].price),
                                                style: rubikMedium),
                                            SizedBox(width: 2),
                                            Text(
                                                '(${cart.addOnIds[index].quantity})',
                                                style: rubikRegular),
                                          ]),
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox(),*/ /*
                                                      ]),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                                right: 8.0,
                                                bottom: 8.0,
                                              ),
                                              child: Container(
                                                width: MediaQuery.of(context).size.width * .35,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        InkWell(
                                                          child: Stack(children: [
                                                            Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color: Color(0xFFFC6A57),
                                                                  ),
                                                                  borderRadius:
                                                                  BorderRadius.all(Radius.circular(4))),
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(left: 8, bottom: 4),
                                                              child: Icon(
                                                                Icons.mode_edit,
                                                                size: 22,
                                                                color: Color(0xFFFC6A57),
                                                              ),
                                                            ),
                                                          ]),
                                                          onTap: () {
                                                            showbottomSheet =
                                                            true;
                                                            bottomSheetData = cart.cartList[
                                                            index].product;
                                                            setState(() {});
*/ /*                                                            showModalBottomSheet(
                                                              context: context,
                                                              isScrollControlled: true,
                                                              backgroundColor: Colors.transparent,
                                                              builder: (con) => CartBottomSheet(
                                                                product: cart.cartList[
                                                                index].product,
                                                                cartIndex: index,
                                                                cart: cart.cartList[index],
                                                                callback: (CartModel cartModel) {
                                                                  ScaffoldMessenger.of(context)
                                                                      .showSnackBar(SnackBar(
                                                                      content: Text(getTranslated(
                                                                          'updated_in_cart', context)),
                                                                      backgroundColor: Colors.green));
                                                                },
                                                              ),
                                                            );*/ /*
                                                          },
                                                        ),
                                                        InkWell(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(
                                                                  left: 5.0, bottom: 4.0, right: 5.0),
                                                              child: Icon(
                                                                Icons.delete,
                                                                size: 28,
                                                                color: Color(0xFFFC6A57),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (context) => alert(context,cart.cartList[index]));
                                                            }),
                                                      ],
                                                    ),
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Flexible(
                                                            child: Text(cart.cartList[index].quantity.toString()+" * "+cart.cartList[index].discountedPrice.toString()+
                                                                */ /*PriceConverter.convertPrice(
                                      context, cart.discountedPrice)+*/ /*" = "+(cart.cartList[index].quantity*cart.cartList[index].discountedPrice).toString(),
                                                              style: TextStyle(
                                                                fontFamily: 'Rubik',
                                                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                                fontWeight: FontWeight.w800,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                          cart.cartList[index].discountAmount > 0
                                                              ? Flexible(
                                                            child: Text(
                                                                PriceConverter.convertPrice(
                                                                    context,
                                                                    cart.cartList[index].discountedPrice +
                                                                        cart.cartList[index].discountAmount),
                                                                style: rubikBold.copyWith(
                                                                  color: ColorResources.COLOR_GREY,
                                                                  fontSize:
                                                                  Dimensions.FONT_SIZE_SMALL,
                                                                  decoration:
                                                                  TextDecoration.lineThrough,
                                                                )),
                                                          )
                                                              : SizedBox(),
                                                        ]),
                                                  ],
                                                ),
                                              ),
                                            )
                                            // Container(
                                            //   decoration: BoxDecoration(
                                            //       color: ColorResources.getBackgroundColor(context),
                                            //       borderRadius: BorderRadius.circular(5)),
                                            //   child: Row(children: [
                                            //     InkWell(
                                            //       onTap: () {
                                            //         if (cart.quantity > 1) {
                                            //           Provider.of<CartProvider>(context, listen: false)
                                            //               .setQuantity(false, cart);
                                            //         }
                                            //       },
                                            //       child: Padding(
                                            //         padding: EdgeInsets.symmetric(
                                            //             horizontal: Dimensions.PADDING_SIZE_SMALL,
                                            //             vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                            //         child: Icon(Icons.remove, size: 20),
                                            //       ),
                                            //     ),
                                            //     Text(cart.quantity.toString(),
                                            //         style: rubikMedium.copyWith(
                                            //             fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                                            //     InkWell(
                                            //       onTap: () =>
                                            //           Provider.of<CartProvider>(context, listen: false)
                                            //               .setQuantity(true, cart),
                                            //       child: Padding(
                                            //         padding: EdgeInsets.symmetric(
                                            //             horizontal: Dimensions.PADDING_SIZE_SMALL,
                                            //             vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                            //         child: Icon(Icons.add, size: 20),
                                            //       ),
                                            //     ),
                                            //   ]),
                                            // ),
                                          ]),

                                          _addOnsList.length > 0 ?

                                          SizedBox(
                                            height: 30,
                                            child: ListView.builder(

                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                                              itemCount: _addOnsList.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                                  child: Row(children: [
                                                    */ /*InkWell(
                          onTap: () {
                            Provider.of<CartProvider>(context, listen: false).removeAddOn(cartIndex, index);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor, size: 18),
                          ),
                        ),*/ /*
                                                    Text(_addOnsList[index].elementAt(index).name, style: rubikRegular),
                                                    SizedBox(width: 2),
                                                    Text(PriceConverter.convertPrice(context, _addOnsList[index].elementAt(index).price), style: rubikMedium),
                                                    SizedBox(width: 2),
                                                    Text('(${cart.cartList[index].addOnIds[index].quantity})', style: rubikRegular),
                                                  ]),
                                                );
                                              },
                                            ),
                                          ) : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ]),
                                );*/
                                          CartProductWidget(
                                              cart: cart.cartList[index],
                                              cartIndex: index,
                                              addOns: _addOnsList[index],
                                              isAvailable:
                                                  _availableList[index]);
                                    },
                                  ),

                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_LARGE),

                                  // Order type
                                  // Text(getTranslated('delivery_option', context),
                                  //     style: rubikMedium.copyWith(
                                  //         fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  // DeliveryOptionButton(
                                  //     value: 'delivery',
                                  //     title: getTranslated('delivery', context)),
                                  // DeliveryOptionButton(
                                  //     value: 'take_away',
                                  //     title: getTranslated('take_away', context)),

                                  // Total
                                  Container(
                                    decoration: BoxDecoration(
                                      color: _isDarkMode
                                          ? Color(0xff000000)
                                          : Color(0xffF5F5F5),
                                      border: Border.all(
                                        color: Color(int.parse(
                                                "#FFFFFF".substring(1, 7),
                                                radix: 16) +
                                            0xFF000000),
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                getTranslated(
                                                    "billsummary", context),
                                                style: rubikBold.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_EXTRA_LARGE,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    getTranslated(
                                                        'items_price', context),
                                                    style: rubikRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                                Text(
                                                    PriceConverter.convertPrice(
                                                        context, _itemPrice),
                                                    style: rubikRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                              ]),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_EXTRA_LARGE),
                                            child: Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Visibility(
                                            visible: _tax > 0,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      getTranslated(
                                                          'tax', context),
                                                      style: rubikRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                  Text(
                                                      '(+) ${PriceConverter.convertPrice(context, _tax)}',
                                                      style: rubikRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                ]),
                                          ),
                                          Visibility(
                                            visible: _tax > 0,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .PADDING_SIZE_EXTRA_LARGE),
                                              child: Divider(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    getTranslated(
                                                        'addons', context),
                                                    style: rubikRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                                Text(
                                                    '(+) ${PriceConverter.convertPrice(context, _addOns)}',
                                                    style: rubikRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                              ]),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_EXTRA_LARGE),
                                            child: Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    getTranslated(
                                                        'subtotal', context),
                                                    style: rubikMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                                Text(
                                                    PriceConverter.convertPrice(
                                                        context, _subTotal),
                                                    style: rubikMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                              ]),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_EXTRA_LARGE),
                                            child: Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Visibility(
                                            visible: _discount > 0,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      getTranslated(
                                                          'discount', context),
                                                      style: rubikRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                  Text(
                                                      '(-) ${PriceConverter.convertPrice(context, _discount)}',
                                                      style: rubikRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                ]),
                                          ),
                                          Visibility(
                                            visible: _discount > 0,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .PADDING_SIZE_EXTRA_LARGE),
                                              child: Divider(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: _discount > 0,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      getTranslated(
                                                          'coupon_discount',
                                                          context),
                                                      style: rubikRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE)),
                                                  Text(
                                                    '(-) ${PriceConverter.convertPrice(context, Provider.of<CouponProvider>(context).discount)}',
                                                    style: rubikRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE),
                                                  ),
                                                ]),
                                          ),
                                          Visibility(
                                            visible: _discount > 0,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .PADDING_SIZE_EXTRA_LARGE),
                                              child: Divider(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    getTranslated(
                                                        'delivery_fee',
                                                        context),
                                                    style: rubikRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                                Text(
                                                    _takeaway
                                                        ? '(+)' + '000'
                                                        : '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                                    style: rubikRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE)),
                                              ]),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_EXTRA_LARGE),
                                            child: Divider(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Grand Total",
                                                    style: rubikMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_EXTRA_LARGE,
                                                      color: Colors.black,
                                                    )),
                                                Text(
                                                  _takeaway
                                                      ? PriceConverter
                                                          .convertPrice(context,
                                                              _subTotal)
                                                      : PriceConverter
                                                          .convertPrice(
                                                              context, _total),
                                                  style: rubikMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_EXTRA_LARGE,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ]),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                          Text(getTranslated(
                                              "allprices", context)),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_LARGE),
                                  // Coupon
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_LARGE),
                                    child: Consumer<CouponProvider>(
                                      builder: (context, coupon, child) {
                                        return Row(children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _couponController,
                                              style: rubikRegular,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Add Promo/Referral Code",
                                                hintStyle:
                                                    rubikRegular.copyWith(
                                                        color: ColorResources
                                                            .getHintColor(
                                                                context)),
                                                isDense: true,
                                                filled: true,
                                                enabled: coupon.discount == 0,
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(10)
                                                      // left: Radius.circular(
                                                      //     Provider.of<LocalizationProvider>(
                                                      //                 context,
                                                      //                 listen: false)
                                                      //             .isLtr
                                                      //         ? 10
                                                      //         : 0),
                                                      // right: Radius.circular(
                                                      //     Provider.of<LocalizationProvider>(
                                                      //                 context,
                                                      //                 listen: false)
                                                      //             .isLtr
                                                      //         ? 0
                                                      //         : 10),
                                                      ),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                              onSubmitted: (string) {
                                                if (_couponController
                                                        .text.isNotEmpty &&
                                                    !coupon.isLoading) {
                                                  if (coupon.discount < 1) {
                                                    coupon
                                                        .applyCoupon(
                                                            _couponController
                                                                .text,
                                                            _total)
                                                        .then((discount) {
                                                      if (discount > 0) {
                                                        _scaffoldKey
                                                            .currentState
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    'You got ${Provider.of<SplashProvider>(context, listen: false).configModel.currencySymbol}$discount discount'),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green));
                                                      } else {
                                                        _scaffoldKey
                                                            .currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              getTranslated(
                                                                  'invalid_code_or',
                                                                  context)),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ));
                                                      }
                                                    });
                                                  } else {
                                                    coupon
                                                        .removeCouponData(true);
                                                  }
                                                } else if (_couponController
                                                    .text.isEmpty) {
                                                  showCustomSnackBar(
                                                      getTranslated(
                                                          'enter_a_Coupon_code',
                                                          context),
                                                      context);
                                                }
                                              },
                                            ),
                                          ),
                                          // InkWell(
                                          //   onTap:
                                          //   child: Container(
                                          //     height: 50,
                                          //     width: 100,
                                          //     alignment: Alignment.center,
                                          //     decoration: BoxDecoration(
                                          //       color: Theme.of(context).primaryColor,
                                          //       borderRadius: BorderRadius.horizontal(
                                          //         left: Radius.circular(
                                          //             Provider.of<LocalizationProvider>(
                                          //                         context,
                                          //                         listen: false)
                                          //                     .isLtr
                                          //                 ? 0
                                          //                 : 10),
                                          //         right: Radius.circular(
                                          //             Provider.of<LocalizationProvider>(
                                          //                         context,
                                          //                         listen: false)
                                          //                     .isLtr
                                          //                 ? 10
                                          //                 : 0),
                                          //       ),
                                          //     ),
                                          //     child: coupon.discount <= 0
                                          //         ? !coupon.isLoading
                                          //             ? Text(
                                          //                 getTranslated(
                                          //                     'apply', context),
                                          //                 style: rubikMedium.copyWith(
                                          //                     color: Colors.white),
                                          //               )
                                          //             : CircularProgressIndicator(
                                          //                 valueColor:
                                          //                     AlwaysStoppedAnimation<
                                          //                         Color>(Colors.white))
                                          //         : Icon(Icons.clear,
                                          //             color: Colors.white),
                                          //   ),
                                          // ),
                                        ]);
                                      },
                                    ),
                                  ),
                                  Consumer<ProfileProvider>(
                                    builder: (context, profileProvider, child) {
                                      return GestureDetector(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          getTranslated(
                                                              "pay_method",
                                                              context),
                                                          style: rubikBold
                                                              .copyWith(
                                                            fontSize: Dimensions
                                                                .FONT_SIZE_EXTRA_LARGE,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: Row(
                                                          children: [
                                                            Wrap(
                                                              children: [
                                                                Container(
                                                                  //
                                                                  // width: MediaQuery.of(context).size.width * .25,
                                                                  decoration: BoxDecoration(
                                                                      color: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
                                                                      border: Border.all(
                                                                        color: Color(int.parse("#FFFFFF".substring(1, 7),
                                                                                radix: 16) +
                                                                            0xFF000000),
                                                                      ),
                                                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: Color(int.parse("#FFFFFF".substring(1, 7), radix: 16) +
                                                                                0xFF000000),
                                                                            blurRadius:
                                                                                1,
                                                                            spreadRadius:
                                                                                1)
                                                                      ]),
                                                                  height: 30,
                                                                  child: Center(
                                                                      child:
                                                                          Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          getTranslated(
                                                                              "pay",
                                                                              context),
                                                                          style:
                                                                              rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                                      SizedBox(
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      Radio(
                                                                        value:
                                                                            1,
                                                                        groupValue:
                                                                            selectedApperanceTile,
                                                                        activeColor:
                                                                            Color(0xff00A4A4),
                                                                        onChanged:
                                                                            (val) {
                                                                          print(
                                                                              "Radio $val");
                                                                          setSelectedApperanceTile(
                                                                              val);
                                                                        },
                                                                      ),
                                                                      /*Icon(
                                                        Icons
                                                            .radio_button_unchecked_outlined,
                                                        size: 20,
                                                        color: Color(int.parse(
                                                                "#00A4A4"
                                                                    .substring(
                                                                        1, 7),
                                                                radix: 16) +
                                                            0xFF000000),
                                                      )*/
                                                                    ],
                                                                  )),
                                                                ),
                                                              ],
                                                            ),
                                                            //Spacer(),
                                                            SizedBox(
                                                              width: 7,
                                                            ),
                                                            Wrap(
                                                              children: [
                                                                Container(
                                                                  //width: MediaQuery.of(context).size.width * .25,
                                                                  decoration: BoxDecoration(
                                                                      color: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
                                                                      border: Border.all(
                                                                        color: Color(int.parse("#FFFFFF".substring(1, 7),
                                                                                radix: 16) +
                                                                            0xFF000000),
                                                                      ),
                                                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: Color(int.parse("#FFFFFF".substring(1, 7), radix: 16) +
                                                                                0xFF000000),
                                                                            blurRadius:
                                                                                1,
                                                                            spreadRadius:
                                                                                1)
                                                                      ]),
                                                                  height: 30,
                                                                  child: Center(
                                                                      child:
                                                                          Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          getTranslated(
                                                                              "cash",
                                                                              context),
                                                                          style:
                                                                              rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                                      SizedBox(
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      /*Icon(
                                                            Icons
                                                                .radio_button_unchecked_outlined,
                                                            size: 20,
                                                            color: Color(int.parse(
                                                                "#00A4A4"
                                                                    .substring(
                                                                    1, 7),
                                                                radix: 16) +
                                                                0xFF000000),
                                                          )*/
                                                                      Radio(
                                                                        value:
                                                                            2,
                                                                        groupValue:
                                                                            selectedApperanceTile,
                                                                        activeColor:
                                                                            Color(0xff00A4A4),
                                                                        onChanged:
                                                                            (val) {
                                                                          print(
                                                                              "Radio $val");
                                                                          setSelectedApperanceTile(
                                                                              val);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  )),
                                                                ),
                                                              ],
                                                            ),
                                                            //Spacer(),
                                                            //SizedBox(width: 7,),
                                                            /*Wrap(
                                                     children: [
                                                       Container(
                                                         */ /*width: MediaQuery.of(context)
                                                             .size
                                                             .width *
                                                             .35,*/ /*
                                                         decoration: BoxDecoration(
                                                             color:_isDarkMode
                                                                 ?Color(0xff000000):Color(0xffF5F5F5),
                                                             border: Border.all(
                                                               color: Color(int.parse(
                                                                   "#FFFFFF"
                                                                       .substring(
                                                                       1, 7),
                                                                   radix: 16) +
                                                                   0xFF000000),
                                                             ),
                                                             borderRadius:
                                                             BorderRadius.all(
                                                                 Radius.circular(
                                                                     4)),
                                                             boxShadow: [
                                                               BoxShadow(
                                                                   color: Color(int.parse(
                                                                       "#FFFFFF"
                                                                           .substring(
                                                                           1,
                                                                           7),
                                                                       radix: 16) +
                                                                       0xFF000000),
                                                                   blurRadius: 1,
                                                                   spreadRadius: 1)
                                                             ]),
                                                         height: 30,
                                                         child: Center(
                                                             child: Row(
                                                               mainAxisAlignment:
                                                               MainAxisAlignment
                                                                   .center,
                                                               children: [
                                                                 Text(getTranslated("take_away", context),
                                                                     style: rubikBold.copyWith(
                                                                         fontSize: Dimensions
                                                                             .FONT_SIZE_LARGE)),
                                                                 SizedBox(
                                                                   width: 2,
                                                                 ),
                                                                 */ /*Icon(
                                                            Icons
                                                                .radio_button_unchecked_outlined,
                                                            size: 20,
                                                            color: Color(int.parse(
                                                                "#00A4A4"
                                                                    .substring(
                                                                    1, 7),
                                                                radix: 16) +
                                                                0xFF000000),
                                                          )*/ /*
                                                                 Radio(
                                                                   value: 3,
                                                                   groupValue: selectedApperanceTile,
                                                                   activeColor: Color(0xff00A4A4),
                                                                   onChanged: (val) {
                                                                     print("Radio $val");
                                                                     setSelectedApperanceTile(val);
                                                                   },
                                                                 ),
                                                               ],
                                                             )),
                                                       )
                                                     ],
                                                   )*/
                                                          ],
                                                        )),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .15,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Color(int.parse("#FFFFFF".substring(1, 7),
                                                                                radix: 16) +
                                                                            0xFF000000),
                                                                        border: Border.all(
                                                                          color:
                                                                              Color(int.parse("#FFFFFF".substring(1, 7), radix: 16) + 0xFF000000),
                                                                        ),
                                                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                        boxShadow: [
                                                                      BoxShadow(
                                                                          color: Colors.grey[
                                                                              300],
                                                                          blurRadius:
                                                                              1,
                                                                          spreadRadius:
                                                                              1)
                                                                    ]),
                                                                height: 30,
                                                                child: Center(
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/image/mada_card.png")),
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .15,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Color(int.parse("#FFFFFF".substring(1, 7),
                                                                                radix: 16) +
                                                                            0xFF000000),
                                                                        border: Border.all(
                                                                          color:
                                                                              Color(int.parse("#FFFFFF".substring(1, 7), radix: 16) + 0xFF000000),
                                                                        ),
                                                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                        boxShadow: [
                                                                      BoxShadow(
                                                                          color: Colors.grey[
                                                                              300],
                                                                          blurRadius:
                                                                              1,
                                                                          spreadRadius:
                                                                              1)
                                                                    ]),
                                                                height: 30,
                                                                child: Center(
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/image/visa_card.png")),
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .15,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Color(int.parse("#FFFFFF".substring(1, 7),
                                                                                radix: 16) +
                                                                            0xFF000000),
                                                                        border: Border.all(
                                                                          color:
                                                                              Color(int.parse("#FFFFFF".substring(1, 7), radix: 16) + 0xFF000000),
                                                                        ),
                                                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                        boxShadow: [
                                                                      BoxShadow(
                                                                          color: Colors.grey[
                                                                              300],
                                                                          blurRadius:
                                                                              1,
                                                                          spreadRadius:
                                                                              1)
                                                                    ]),
                                                                height: 30,
                                                                child: Center(
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/image/master_card.png")),
                                                              )
                                                            ],
                                                          ),
                                                          /*Row(
                                                      children: [
                                                        Container(
                                                          width:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  .15,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  int.parse(
                                                                          "#FFFFFF"
                                                                              .substring(
                                                                                  1,
                                                                                  7),
                                                                          radix: 16) +
                                                                      0xFF000000),
                                                              border: Border.all(
                                                                color: Color(int.parse(
                                                                        "#FFFFFF"
                                                                            .substring(
                                                                                1,
                                                                                7),
                                                                        radix: 16) +
                                                                    0xFF000000),
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .grey[300],
                                                                    blurRadius: 1,
                                                                    spreadRadius: 1)
                                                              ]),
                                                          height: 30,
                                                          child: Center(
                                                              child: Image.asset(
                                                                  "assets/image/apple_logo.png")),
                                                        )
                                                      ],
                                                    ),*/
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //proceed  button...............................................................
                                              SizedBox(
                                                height: 20,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  var id = prefs
                                                      .getInt("branchidshr");
                                                  if (_takeaway) {
                                                    print(_subTotal.toString());
                                                    /*Provider.of<CartProvider>(context, listen: false)
                                                  .clearCartList();*/
                                                    for (int index = 0;
                                                        index <
                                                            cart.cartList
                                                                .length;
                                                        index++) {
                                                      CartModel cartM =
                                                          cart.cartList[index];
                                                      List<int> _addOnIdList =
                                                          [];
                                                      List<int> _addOnQtyList =
                                                          [];
                                                      cartM.addOnIds
                                                          .forEach((addOn) {
                                                        _addOnIdList
                                                            .add(addOn.id);
                                                        _addOnQtyList.add(
                                                            addOn.quantity);
                                                      });
                                                      carts.add(Cart(
                                                        cartM.product.id
                                                            .toString(),
                                                        cartM.discountedPrice
                                                            .toString(),
                                                        '',
                                                        cartM.variation,
                                                        cartM.discountAmount,
                                                        cartM.quantity,
                                                        0.0,
                                                        _addOnIdList,
                                                        _addOnQtyList,
                                                      ));
                                                    }

                                                    Provider.of<OrderProvider>(context, listen: false).placeOrder(
                                                        PlaceOrderBody(
                                                            cart: carts,
                                                            couponDiscountAmount:
                                                                Provider.of<CouponProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .discount,
                                                            couponDiscountTitle:
                                                                '',
                                                            deliveryAddressId:
                                                                0,
                                                            orderAmount:
                                                                _subTotal,
                                                            orderNote: '',
                                                            orderType:
                                                                "take a way",
                                                            paymentMethod:
                                                                'take a way',
                                                            couponCode: Provider.of<CouponProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .coupon !=
                                                                    null
                                                                ? Provider.of<
                                                                            CouponProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .coupon
                                                                    .code
                                                                : null,
                                                            branchId: id),
                                                        null);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            PaymentSuccessfulScreen(
                                                          razorPaymentId:
                                                              "takeaway",
                                                        ),
                                                      ),
                                                    ).then((value) {
                                                      widget.setPageInTabs(0);
                                                      BlocProvider.of<
                                                                  NavigationBloc>(
                                                              context)
                                                          .add(NavigationEvents
                                                              .HomePageClickedEvent);
                                                    });
                                                  } else if (_cash) {
                                                    /* Provider.of<CartProvider>(context, listen: false)
                                                  .clearCartList();*/
                                                    for (int index = 0;
                                                        index <
                                                            cart.cartList
                                                                .length;
                                                        index++) {
                                                      CartModel cartM =
                                                          cart.cartList[index];
                                                      List<int> _addOnIdList =
                                                          [];
                                                      List<int> _addOnQtyList =
                                                          [];
                                                      cartM.addOnIds
                                                          .forEach((addOn) {
                                                        _addOnIdList
                                                            .add(addOn.id);
                                                        _addOnQtyList.add(
                                                            addOn.quantity);
                                                      });
                                                      carts.add(Cart(
                                                        cartM.product.id
                                                            .toString(),
                                                        cartM.discountedPrice
                                                            .toString(),
                                                        '',
                                                        cartM.variation,
                                                        cartM.discountAmount,
                                                        cartM.quantity,
                                                        0.0,
                                                        _addOnIdList,
                                                        _addOnQtyList,
                                                      ));
                                                    }
                                                    Provider.of<OrderProvider>(context, listen: false).placeOrder(
                                                        PlaceOrderBody(
                                                            cart: carts,
                                                            couponDiscountAmount:
                                                                Provider.of<CouponProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .discount,
                                                            couponDiscountTitle:
                                                                '',
                                                            deliveryAddressId:
                                                                0,
                                                            orderAmount: _total,
                                                            orderNote: '',
                                                            orderType: "Cash",
                                                            paymentMethod:
                                                                'Cash',
                                                            couponCode: Provider.of<CouponProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .coupon !=
                                                                    null
                                                                ? Provider.of<
                                                                            CouponProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .coupon
                                                                    .code
                                                                : null,
                                                            branchId: id),
                                                        null);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            PaymentSuccessfulScreen(
                                                          razorPaymentId:
                                                              "Cash",
                                                        ),
                                                      ),
                                                    ).then((value) {
                                                      widget.setPageInTabs(0);
                                                      BlocProvider.of<
                                                                  NavigationBloc>(
                                                              context)
                                                          .add(NavigationEvents
                                                              .HomePageClickedEvent);
                                                    });
                                                  } else {
                                                    List<CartModel>
                                                        cartModelList =
                                                        cart.cartList;
                                                    for (int index = 0;
                                                        index <
                                                            cartModelList
                                                                .length;
                                                        index++) {
                                                      CartModel cart =
                                                          cartModelList[index];
                                                      List<int> _addOnIdList =
                                                          [];
                                                      List<int> _addOnQtyList =
                                                          [];
                                                      cart.addOnIds
                                                          .forEach((addOn) {
                                                        _addOnIdList
                                                            .add(addOn.id);
                                                        _addOnQtyList.add(
                                                            addOn.quantity);
                                                      });
                                                      carts.add(Cart(
                                                        cart.product.id
                                                            .toString(),
                                                        cart.discountedPrice
                                                            .toString(),
                                                        '',
                                                        cart.variation,
                                                        cart.discountAmount,
                                                        cart.quantity,
                                                        cart.taxAmount,
                                                        _addOnIdList,
                                                        _addOnQtyList,
                                                      ));
                                                    }
                                                    openCheckout(
                                                        totalPrice: _total,
                                                        description:
                                                            "Tazaz food delivery payment",
                                                        userEmail:
                                                            profileProvider
                                                                .userInfoModel
                                                                .email,
                                                        userPhone:
                                                            profileProvider
                                                                .userInfoModel
                                                                .phone);
                                                  }
                                                },
                                                child: Container(
                                                  height: 45,
                                                  width: size.width - 70,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Color(0xff00A4A4)),
                                                  child: Center(
                                                    child: Text(
                                                      getTranslated(
                                                          "proceed", context),
                                                      style: TextStyle(
                                                          fontFamily: 'Rubik',
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_DEFAULT,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        /*onTap: () {
                                    List<CartModel> cartModelList =
                                        cart.cartList;
                                    for (int index = 0;
                                        index < cartModelList.length;
                                        index++) {
                                      CartModel cart = cartModelList[index];
                                      List<int> _addOnIdList = [];
                                      List<int> _addOnQtyList = [];
                                      cart.addOnIds.forEach((addOn) {
                                        _addOnIdList.add(addOn.id);
                                        _addOnQtyList.add(addOn.quantity);
                                      });
                                      carts.add(Cart(
                                        cart.product.id.toString(),
                                        cart.discountedPrice.toString(),
                                        '',
                                        cart.variation,
                                        cart.discountAmount,
                                        cart.quantity,
                                        cart.taxAmount,
                                        _addOnIdList,
                                        _addOnQtyList,
                                      ));
                                    }
                                    openCheckout(
                                        totalPrice: _cash?_subTotal:_total,
                                        description:
                                            "Tazaz food delivery payment",
                                        userEmail:
                                            profileProvider.userInfoModel.email,
                                        userPhone: profileProvider
                                            .userInfoModel.phone);
                                  },*/
                                      );
                                    },
                                  ),
                                ])
                              : NoDataScreen(isCart: true);
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget alert(BuildContext context, CartModel cart) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.contact_support, size: 50),
        ),
        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Text("Are you sure you want to remove?",
              style: rubikBold, textAlign: TextAlign.center),
        ),
        Divider(height: 0, color: ColorResources.getHintColor(context)),
        Row(children: [
          Expanded(
              child: InkWell(
            onTap: () {
              Provider.of<CartProvider>(context, listen: false)
                  .removeFromCart(cart);
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text(getTranslated('yes', context),
                  style:
                      rubikBold.copyWith(color: ColorResources.COLOR_PRIMARY)),
            ),
          )),
          Expanded(
              child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ColorResources.getPrimaryColor(context),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text(getTranslated('no', context),
                  style: rubikBold.copyWith(color: Colors.white)),
            ),
          )),
        ]),
      ]),
    );
  }
}
