import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/navigation_bloc/navigation_bloc.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/checkout/checkout_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/payment_screen.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBottomSheetC extends StatefulWidget {
  final Product product;
  final bool fromSetMenu;
  final Function callback;
  final CartModel cart;
  final int cartIndex;

  CartBottomSheetC(
      {@required this.product,
      this.fromSetMenu = false,
      this.callback,
      this.cart,
      this.cartIndex});

  @override
  _CartBottomSheetState createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheetC>
    with NavigationStates {
  final ScrollController _scrollController = ScrollController();
  var _isDarkMode;
  String radioItem1 = '';
  String radioItem2 = '';
  String radioItem3 = '';
  bool drink = true;
  bool upSize = false;
  bool addOn = false;
  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false)
        .initData(widget.product, widget.cart);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.product.addOns.toString());
    //print(widget.product.addOns2.length.toString());
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool fromCart = widget.cart != null;

    Variation _variation = Variation();

    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
      body: SafeArea(
        child: CustomScrollView(controller: _scrollController, slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * .45,
            floating: false,
            stretch: true,
            elevation: 0,
            pinned: false,
            title: Text(
              "${widget.product.name}",
              style: TextStyle(
                  color: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
                  fontSize: 17),
            ),
            centerTitle: true,
            stretchTriggerOffset: 150.0,
            titleSpacing: 0,
            automaticallyImplyLeading: true,
            backgroundColor:
                _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
            actionsIconTheme: IconThemeData(opacity: 0.0),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [
                StretchMode.zoomBackground,
              ],
              background: Container(
                color: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse("#00A4A4".substring(1, 7), radix: 16) +
                                0xFF000000),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0)),
                      ),
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(
                              top: (MediaQuery.of(context).size.height * 0.01)),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_outlined,
                              color:
                                  /*_isDarkMode
                                    ?Color(0xff000000):*/
                                  Color(0xffffffff),
                            ),
                            onPressed: widget.callback,
                          ),
                        ),
                        /*Padding(
                          padding: const EdgeInsets.only(left: 74.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                                top: (MediaQuery.of(context).size.height *
                                    0.05)),
                            child: Column(
                              children: [
                                Text(
                                  "${widget.product.name}",
                                  style: TextStyle(
                                      color: _isDarkMode
                                          ? Color(0xff000000)
                                          : Color(0xffF5F5F5),
                                      fontSize: 16),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),*/
                      ],
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      height: MediaQuery.of(context).size.height * 50,
                      margin: EdgeInsets.only(
                          top: (MediaQuery.of(context).size.height * 0.10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * .50,
                            child: ListView.builder(
                              itemCount: 1,
                              padding: EdgeInsets.only(
                                  left: Dimensions.PADDING_SIZE_SMALL),
                              //physics: BouncingScrollPhysics(),
                              //scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .95,
                                    height: MediaQuery.of(context).size.height *
                                        .28,
                                    margin: EdgeInsets.only(
                                        right: Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      color: ColorResources.COLOR_WHITE,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder_banner,
                                        image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${widget.product.image}',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .85,
                                        height: 85,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
              child: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: widget.product.addOns.length > 0,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  drink = true;
                                  upSize = false;
                                  addOn = false;
                                });
                              },
                              child: Text(
                                getTranslated("opt1", context),
                                style: TextStyle(
                                    color: drink ? Color(0xff00A4A4) : null,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Dimensions.FONT_SIZE_LARGE),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: widget.product.addOns2 != null,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  drink = false;
                                  upSize = true;
                                  addOn = false;
                                });
                              },
                              child: Text(getTranslated("upSize", context),
                                  style: TextStyle(
                                      color: upSize ? Color(0xff00A4A4) : null,
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.FONT_SIZE_LARGE)),
                            ),
                          ),
                          Visibility(
                            visible: widget.product.addOns1 != null,
                            child: TextButton(
                              child: Text(getTranslated("add_On", context),
                                  style: TextStyle(
                                    color: addOn ? Color(0xff00A4A4) : null,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onPressed: () {
                                setState(() {
                                  drink = false;
                                  upSize = false;
                                  addOn = true;
                                });
                              },
                            ),
                          ),
                          /*Container(
                                          decoration: BoxDecoration(
                                              color: Color(int.parse(
                                                  "#00A4A4"
                                                      .substring(
                                                      1,
                                                      7),
                                                  radix: 16) +
                                                  0xFF000000),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  5)),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(context,MaterialPageRoute(builder: (context)=>CheckoutScreen()));
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                  Dimensions
                                                      .PADDING_SIZE_SMALL,
                                                  vertical: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              child: Icon(
                                                  Icons.shopping_cart,
                                                  size: 20),
                                            ),
                                          ),
                                        ),*/
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      widget.product.addOns != null &&
                              widget.product.addOns.length > 0
                          ? Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: drink,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              widget.product.addOns.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: _isDarkMode
                                                    ? Color(0xff000000)
                                                    : Color(0xffFFFFFF),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        widget.product
                                                            .addOns[index].name,
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE,
                                                        )),
                                                    Spacer(),
                                                    /*Text(
                                                  widget.product
                                                      .addOns[index].price.toString(),),*/
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          //color: ColorResources.getBackgroundColor(context),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Row(children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: ColorResources
                                                                  .getBackgroundColor(
                                                                      context),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (productProvider
                                                                          .addOnQtyList[
                                                                      index] >
                                                                  0) {
                                                                productProvider
                                                                    .setAddOnQuantity(
                                                                        false,
                                                                        index);
                                                                if (productProvider
                                                                            .addOnQtyList[
                                                                        index] >
                                                                    1) {
                                                                  productProvider
                                                                      .setAddOnQuantity(
                                                                          false,
                                                                          index);
                                                                } else {
                                                                  productProvider
                                                                      .addAddOn(
                                                                          false,
                                                                          index);
                                                                }
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .PADDING_SIZE_SMALL,
                                                                  vertical:
                                                                      Dimensions
                                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                              child: Icon(
                                                                  Icons.remove,
                                                                  size: 20),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 16.0,
                                                        ),
                                                        Text(
                                                            productProvider
                                                                .addOnQtyList[
                                                                    index]
                                                                .toString(),
                                                            style: rubikMedium
                                                                .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .FONT_SIZE_EXTRA_LARGE)),
                                                        SizedBox(
                                                          width: 16.0,
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Color(int.parse(
                                                                      "#00A4A4"
                                                                          .substring(
                                                                              1,
                                                                              7),
                                                                      radix:
                                                                          16) +
                                                                  0xFF000000),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: InkWell(
                                                            onTap: () {
                                                              {
                                                                var sum = productProvider
                                                                    .addOnQtyList
                                                                    .reduce((value,
                                                                            element) =>
                                                                        value +
                                                                        element);
                                                                if (sum <
                                                                    productProvider
                                                                        .quantity) {
                                                                  print(
                                                                      "Adddddddd");
                                                                  productProvider
                                                                      .setAddOnQuantity(
                                                                          true,
                                                                          index);
                                                                  if (!productProvider
                                                                          .addOnActiveList[
                                                                      index]) {
                                                                    productProvider.addAddOn(
                                                                        true,
                                                                        widget
                                                                            .product
                                                                            .addOns
                                                                            .indexOf(widget.product.addOns[index]));
                                                                  } else if (productProvider
                                                                              .addOnQtyList[
                                                                          index] ==
                                                                      1) {
                                                                    productProvider
                                                                        .addAddOn(
                                                                            false,
                                                                            index);
                                                                  }
                                                                }
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .PADDING_SIZE_SMALL,
                                                                  vertical:
                                                                      Dimensions
                                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                              child: Icon(
                                                                Icons.add,
                                                                size: 20,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        //Spacer(),
                                                      ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ]),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      widget.product.addOns2 != null &&
                              widget.product.addOns2.length > 0
                          ? Visibility(
                              visible: upSize,
                              child: Container(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text(
                                          getTranslated("add_On", context),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE),
                                        ),
                                        Text(
                                            " (Select up to ${productProvider.quantity})",
                                            style: TextStyle(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                            )),
                                      ]),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              widget.product.addOns2.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: _isDarkMode
                                                    ? Color(0xff000000)
                                                    : Color(0xffFFFFFF),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        widget
                                                            .product
                                                            .addOns2[index]
                                                            .name,
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE,
                                                        )),
                                                    Spacer(),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          //color: ColorResources.getBackgroundColor(context),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Row(children: [
                                                        Text(
                                                            widget
                                                                .product
                                                                .addOns2[index]
                                                                .price
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: Dimensions
                                                                  .FONT_SIZE_LARGE,
                                                            )),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: ColorResources
                                                                  .getBackgroundColor(
                                                                      context),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (productProvider
                                                                          .addOn2QtyList2[
                                                                      index] >
                                                                  0) {
                                                                productProvider
                                                                    .setAddOn2Quantity(
                                                                        false,
                                                                        index);
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .PADDING_SIZE_SMALL,
                                                                  vertical:
                                                                      Dimensions
                                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                              child: Icon(
                                                                  Icons.remove,
                                                                  size: 20),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 16.0,
                                                        ),
                                                        Text(
                                                            productProvider
                                                                .addOn2QtyList2[
                                                                    index]
                                                                .toString(),
                                                            style: rubikMedium
                                                                .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .FONT_SIZE_EXTRA_LARGE)),
                                                        SizedBox(
                                                          width: 16.0,
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Color(int.parse(
                                                                      "#00A4A4"
                                                                          .substring(
                                                                              1,
                                                                              7),
                                                                      radix:
                                                                          16) +
                                                                  0xFF000000),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: InkWell(
                                                            onTap: () {
                                                              {
                                                                //if (productProvider.addOn2QtyList2[index] < productProvider.quantity) {
                                                                var sum = productProvider
                                                                    .addOn2QtyList2
                                                                    .reduce((value,
                                                                            element) =>
                                                                        value +
                                                                        element);
                                                                if (sum <
                                                                    productProvider
                                                                        .quantity) {
                                                                  productProvider
                                                                      .setAddOn2Quantity(
                                                                          true,
                                                                          index);
                                                                  productProvider.addAddOn2(
                                                                      true,
                                                                      index
                                                                      // .indexOf(widget
                                                                      //     .product
                                                                      //     .addOns2[index])
                                                                      );
                                                                }

                                                                /*if(!productProvider.addOnActiveList[index]) {
                                                                  productProvider.addAddOn(true, widget.product
                                                                      .addOns2.indexOf(widget.product
                                                                      .addOns2[index]));
                                                                }else if(productProvider.addOnQtyList[index] == 1) {
                                                                  productProvider.addAddOn(false, index);
                                                                }
                                                                }*/
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .PADDING_SIZE_SMALL,
                                                                  vertical:
                                                                      Dimensions
                                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                              child: Icon(
                                                                Icons.add,
                                                                size: 20,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        //Spacer(),
                                                      ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ]),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      widget.product.addOns1 != null &&
                              widget.product.addOns1.length > 0
                          ? Visibility(
                              visible: addOn,
                              child: Container(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text(
                                          getTranslated("add_On", context),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE),
                                        ),
                                        Text(
                                            " (Select up to ${productProvider.quantity})",
                                            style: TextStyle(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL,
                                            )),
                                      ]),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              widget.product.addOns1.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: _isDarkMode
                                                    ? Color(0xff000000)
                                                    : Color(0xffFFFFFF),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        widget
                                                            .product
                                                            .addOns1[index]
                                                            .name,
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_LARGE,
                                                        )),
                                                    Spacer(),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          //color: ColorResources.getBackgroundColor(context),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Row(children: [
                                                        Text(
                                                            widget
                                                                .product
                                                                .addOns1[index]
                                                                .price
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: Dimensions
                                                                  .FONT_SIZE_LARGE,
                                                            )),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: ColorResources
                                                                  .getBackgroundColor(
                                                                      context),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (productProvider
                                                                          .addOn1QtyList1[
                                                                      index] >
                                                                  0) {
                                                                productProvider
                                                                    .setAddOn1Quantity1(
                                                                        false,
                                                                        index);
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .PADDING_SIZE_SMALL,
                                                                  vertical:
                                                                      Dimensions
                                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                              child: Icon(
                                                                  Icons.remove,
                                                                  size: 20),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 16.0,
                                                        ),
                                                        Text(
                                                            productProvider
                                                                .addOn1QtyList1[
                                                                    index]
                                                                .toString(),
                                                            style: rubikMedium
                                                                .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .FONT_SIZE_EXTRA_LARGE)),
                                                        SizedBox(
                                                          width: 16.0,
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Color(int.parse(
                                                                      "#00A4A4"
                                                                          .substring(
                                                                              1,
                                                                              7),
                                                                      radix:
                                                                          16) +
                                                                  0xFF000000),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: InkWell(
                                                            onTap: () {
                                                              {
                                                                //if (productProvider.addOn2QtyList2[index] < productProvider.quantity) {
                                                                productProvider
                                                                    .setAddOn1Quantity1(
                                                                        true,
                                                                        index);
                                                                if (!productProvider
                                                                        .addOnActiveList1[
                                                                    index]) {
                                                                  productProvider
                                                                      .addAddOn1(
                                                                          true,
                                                                          index);
                                                                }
                                                                /*else if(productProvider.addOnQtyList[index] == 1) {
                                                                  productProvider.addAddOn(false, index);
                                                                }
                                                                }*/
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .PADDING_SIZE_SMALL,
                                                                  vertical:
                                                                      Dimensions
                                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                              child: Icon(
                                                                Icons.add,
                                                                size: 20,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        //Spacer(),
                                                      ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ]),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                );
              }),
            ),
          )
          // Container(
          //   padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).accentColor,
          //     borderRadius: BorderRadius.only(
          //         topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          //   ),
          //   child: Consumer<ProductProvider>(
          //     builder: (context, productProvider, child) {
          //       double _startingPrice;
          //       double _endingPrice;
          //       if (widget.product.choiceOptions.length != 0) {
          //         List<double> _priceList = [];
          //         widget.product.variations
          //             .forEach((variation) => _priceList.add(variation.price));
          //         _priceList.sort((a, b) => a.compareTo(b));
          //         _startingPrice = _priceList[0];
          //         if (_priceList[0] < _priceList[_priceList.length - 1]) {
          //           _endingPrice = _priceList[_priceList.length - 1];
          //         }
          //       } else {
          //         _startingPrice = widget.product.price;
          //       }

          //       List<String> _variationList = [];
          //       for (int index = 0;
          //           index < widget.product.choiceOptions.length;
          //           index++) {
          //         _variationList.add(widget.product.choiceOptions[index]
          //             .options[productProvider.variationIndex[index]]
          //             .replaceAll(' ', ''));
          //       }
          //       String variationType = '';
          //       bool isFirst = true;
          //       _variationList.forEach((variation) {
          //         if (isFirst) {
          //           variationType = '$variationType$variation';
          //           isFirst = false;
          //         } else {
          //           variationType = '$variationType-$variation';
          //         }
          //       });

          //       double price = widget.product.price;
          //       for (Variation variation in widget.product.variations) {
          //         if (variation.type == variationType) {
          //           price = variation.price;
          //           _variation = variation;
          //           break;
          //         }
          //       }
          //       double priceWithDiscount = PriceConverter.convertWithDiscount(
          //           context,
          //           price,
          //           widget.product.discount,
          //           widget.product.discountType);
          //       double priceWithQuantity =
          //           priceWithDiscount * productProvider.quantity;
          //       double addonsCost = 0;
          //       List<AddOn> _addOnIdList = [];
          //       for (int index = 0;
          //           index < widget.product.addOns.length;
          //           index++) {
          //         if (productProvider.addOnActiveList[index]) {
          //           addonsCost = addonsCost +
          //               (widget.product.addOns[index].price *
          //                   productProvider.addOnQtyList[index]);
          //           _addOnIdList.add(AddOn(
          //               id: widget.product.addOns[index].id,
          //               quantity: productProvider.addOnQtyList[index]));
          //         }
          //       }
          //       double priceWithAddons = priceWithQuantity + addonsCost;

          //       DateTime _currentTime =
          //           Provider.of<SplashProvider>(context, listen: false)
          //               .currentTime;
          //       DateTime _start = DateFormat('hh:mm:ss')
          //           .parse(widget.product.availableTimeStarts);
          //       DateTime _end = DateFormat('hh:mm:ss')
          //           .parse(widget.product.availableTimeEnds);
          //       DateTime _startTime = DateTime(
          //           _currentTime.year,
          //           _currentTime.month,
          //           _currentTime.day,
          //           _start.hour,
          //           _start.minute,
          //           _start.second);
          //       DateTime _endTime = DateTime(
          //           _currentTime.year,
          //           _currentTime.month,
          //           _currentTime.day,
          //           _end.hour,
          //           _end.minute,
          //           _end.second);
          //       if (_endTime.isBefore(_startTime)) {
          //         _endTime = _endTime.add(Duration(days: 1));
          //       }
          //       bool _isAvailable = _currentTime.isAfter(_startTime) &&
          //           _currentTime.isBefore(_endTime);

          //       CartModel _cartModel = CartModel(
          //         price,
          //         priceWithDiscount,
          //         [_variation],
          //         (price -
          //             PriceConverter.convertWithDiscount(
          //                 context,
          //                 price,
          //                 widget.product.discount,
          //                 widget.product.discountType)),
          //         productProvider.quantity,
          //         price -
          //             PriceConverter.convertWithDiscount(context, price,
          //                 widget.product.tax, widget.product.taxType),
          //         _addOnIdList,
          //         widget.product,
          //       );
          //       bool isExistInCart =
          //           Provider.of<CartProvider>(context, listen: false)
          //               .isExistInCart(_cartModel, fromCart, widget.cartIndex);

          //       return SingleChildScrollView(
          //         child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               //Product
          //               Row(children: [
          //                 ClipRRect(
          //                   borderRadius: BorderRadius.circular(10),
          //                   child: FadeInImage.assetNetwork(
          //                     placeholder: Images.placeholder_rectangle,
          //                     image:
          //                         '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${widget.product.image}',
          //                     width: 100,
          //                     height: 100,
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //                 SizedBox(width: 10),
          //                 Expanded(
          //                   child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                           widget.product.name,
          //                           maxLines: 2,
          //                           overflow: TextOverflow.ellipsis,
          //                           style: rubikMedium.copyWith(
          //                               fontSize: Dimensions.FONT_SIZE_LARGE),
          //                         ),
          //                         RatingBar(
          //                             rating: widget.product.rating.length > 0
          //                                 ? double.parse(
          //                                     widget.product.rating[0].average)
          //                                 : 0.0,
          //                             size: 15),
          //                         SizedBox(height: 10),
          //                         Row(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             Text(
          //                               '${PriceConverter.convertPrice(context, _startingPrice, discount: widget.product.discount, discountType: widget.product.discountType)}'
          //                               '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: widget.product.discount, discountType: widget.product.discountType)}' : ''}',
          //                               style: rubikMedium.copyWith(
          //                                   fontSize:
          //                                       Dimensions.FONT_SIZE_LARGE),
          //                             ),
          //                             price == priceWithDiscount
          //                                 ? Consumer<WishListProvider>(builder:
          //                                     (context, wishList, child) {
          //                                     return InkWell(
          //                                       onTap: () {
          //                                         wishList.wishIdList.contains(
          //                                                 widget.product.id)
          //                                             ? wishList
          //                                                 .removeFromWishList(
          //                                                     widget.product,
          //                                                     (message) {})
          //                                             : wishList.addToWishList(
          //                                                 widget.product,
          //                                                 (message) {});
          //                                       },
          //                                       child: Icon(
          //                                         wishList.wishIdList.contains(
          //                                                 widget.product.id)
          //                                             ? Icons.favorite
          //                                             : Icons.favorite_border,
          //                                         color: wishList.wishIdList
          //                                                 .contains(
          //                                                     widget.product.id)
          //                                             ? ColorResources
          //                                                 .COLOR_PRIMARY
          //                                             : ColorResources
          //                                                 .COLOR_GREY,
          //                                       ),
          //                                     );
          //                                   })
          //                                 : SizedBox(),
          //                           ],
          //                         ),
          //                         price > priceWithDiscount
          //                             ? Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.spaceBetween,
          //                                 children: [
          //                                     Text(
          //                                       '${PriceConverter.convertPrice(context, _startingPrice)}'
          //                                       '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
          //                                       style: rubikMedium.copyWith(
          //                                           color: ColorResources
          //                                               .COLOR_GREY,
          //                                           decoration: TextDecoration
          //                                               .lineThrough),
          //                                     ),
          //                                     Consumer<WishListProvider>(
          //                                         builder: (context, wishList,
          //                                             child) {
          //                                       return InkWell(
          //                                         onTap: () {
          //                                           wishList.wishIdList
          //                                                   .contains(widget
          //                                                       .product.id)
          //                                               ? wishList
          //                                                   .removeFromWishList(
          //                                                       widget.product,
          //                                                       (message) {})
          //                                               : wishList
          //                                                   .addToWishList(
          //                                                       widget.product,
          //                                                       (message) {});
          //                                         },
          //                                         child: Icon(
          //                                           wishList.wishIdList
          //                                                   .contains(widget
          //                                                       .product.id)
          //                                               ? Icons.favorite
          //                                               : Icons.favorite_border,
          //                                           color: wishList.wishIdList
          //                                                   .contains(widget
          //                                                       .product.id)
          //                                               ? ColorResources
          //                                                   .COLOR_PRIMARY
          //                                               : ColorResources
          //                                                   .COLOR_GREY,
          //                                         ),
          //                                       );
          //                                     }),
          //                                   ])
          //                             : SizedBox(),
          //                       ]),
          //                 ),
          //               ]),
          //               SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          //               // Quantity
          //               Row(children: [
          //                 Text(getTranslated('quantity', context),
          //                     style: rubikMedium.copyWith(
          //                         fontSize: Dimensions.FONT_SIZE_LARGE)),
          //                 Expanded(child: SizedBox()),
          //                 Container(
          //                   decoration: BoxDecoration(
          //                       color:
          //                           ColorResources.getBackgroundColor(context),
          //                       borderRadius: BorderRadius.circular(5)),
          //                   child: Row(children: [
          //                     InkWell(
          //                       onTap: () {
          //                         if (productProvider.quantity > 1) {
          //                           productProvider.setQuantity(false);
          //                         }
          //                       },
          //                       child: Padding(
          //                         padding: EdgeInsets.symmetric(
          //                             horizontal: Dimensions.PADDING_SIZE_SMALL,
          //                             vertical:
          //                                 Dimensions.PADDING_SIZE_EXTRA_SMALL),
          //                         child: Icon(Icons.remove, size: 20),
          //                       ),
          //                     ),
          //                     Text(productProvider.quantity.toString(),
          //                         style: rubikMedium.copyWith(
          //                             fontSize:
          //                                 Dimensions.FONT_SIZE_EXTRA_LARGE)),
          //                     InkWell(
          //                       onTap: () => productProvider.setQuantity(true),
          //                       child: Padding(
          //                         padding: EdgeInsets.symmetric(
          //                             horizontal: Dimensions.PADDING_SIZE_SMALL,
          //                             vertical:
          //                                 Dimensions.PADDING_SIZE_EXTRA_SMALL),
          //                         child: Icon(Icons.add, size: 20),
          //                       ),
          //                     ),
          //                   ]),
          //                 ),
          //               ]),
          //               SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          //               // Variation
          //               ListView.builder(
          //                 shrinkWrap: true,
          //                 itemCount: widget.product.choiceOptions.length,
          //                 physics: NeverScrollableScrollPhysics(),
          //                 itemBuilder: (context, index) {
          //                   return Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                             widget.product.choiceOptions[index].title,
          //                             style: rubikMedium.copyWith(
          //                                 fontSize:
          //                                     Dimensions.FONT_SIZE_LARGE)),
          //                         SizedBox(
          //                             height:
          //                                 Dimensions.PADDING_SIZE_EXTRA_SMALL),
          //                         GridView.builder(
          //                           gridDelegate:
          //                               SliverGridDelegateWithFixedCrossAxisCount(
          //                             crossAxisCount: 3,
          //                             crossAxisSpacing: 20,
          //                             mainAxisSpacing: 10,
          //                             childAspectRatio: (1 / 0.25),
          //                           ),
          //                           shrinkWrap: true,
          //                           physics: NeverScrollableScrollPhysics(),
          //                           itemCount: widget.product
          //                               .choiceOptions[index].options.length,
          //                           itemBuilder: (context, i) {
          //                             return InkWell(
          //                               onTap: () {
          //                                 productProvider.setCartVariationIndex(
          //                                     index, i);
          //                               },
          //                               child: Container(
          //                                 alignment: Alignment.center,
          //                                 padding: EdgeInsets.symmetric(
          //                                     horizontal: Dimensions
          //                                         .PADDING_SIZE_EXTRA_SMALL),
          //                                 decoration: BoxDecoration(
          //                                   color: productProvider
          //                                                   .variationIndex[
          //                                               index] !=
          //                                           i
          //                                       ? ColorResources
          //                                           .BACKGROUND_COLOR
          //                                       : ColorResources.COLOR_PRIMARY,
          //                                   borderRadius:
          //                                       BorderRadius.circular(5),
          //                                   border:
          //                                       productProvider.variationIndex[
          //                                                   index] !=
          //                                               i
          //                                           ? Border.all(
          //                                               color: ColorResources
          //                                                   .BORDER_COLOR,
          //                                               width: 2)
          //                                           : null,
          //                                 ),
          //                                 child: Text(
          //                                   widget.product.choiceOptions[index]
          //                                       .options[i]
          //                                       .trim(),
          //                                   maxLines: 1,
          //                                   overflow: TextOverflow.ellipsis,
          //                                   style: rubikRegular.copyWith(
          //                                     color: productProvider
          //                                                     .variationIndex[
          //                                                 index] !=
          //                                             i
          //                                         ? ColorResources.COLOR_BLACK
          //                                         : ColorResources.COLOR_WHITE,
          //                                   ),
          //                                 ),
          //                               ),
          //                             );
          //                           },
          //                         ),
          //                         SizedBox(
          //                             height: index !=
          //                                     widget.product.choiceOptions
          //                                             .length -
          //                                         1
          //                                 ? Dimensions.PADDING_SIZE_LARGE
          //                                 : 0),
          //                       ]);
          //                 },
          //               ),
          //               widget.product.choiceOptions.length > 0
          //                   ? SizedBox(height: Dimensions.PADDING_SIZE_LARGE)
          //                   : SizedBox(),

          //               widget.fromSetMenu
          //                   ? Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                           Text(getTranslated('description', context),
          //                               style: rubikMedium.copyWith(
          //                                   fontSize:
          //                                       Dimensions.FONT_SIZE_LARGE)),
          //                           SizedBox(
          //                               height: Dimensions
          //                                   .PADDING_SIZE_EXTRA_SMALL),
          //                           Text(widget.product.description ?? '',
          //                               style: rubikRegular),
          //                           SizedBox(
          //                               height: Dimensions.PADDING_SIZE_LARGE),
          //                         ])
          //                   : SizedBox(),

          //               // Addons
          //               widget.product.addOns.length > 0
          //                   ? Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                           Text(getTranslated('addons', context),
          //                               style: rubikMedium.copyWith(
          //                                   fontSize:
          //                                       Dimensions.FONT_SIZE_LARGE)),
          //                           SizedBox(
          //                               height: Dimensions
          //                                   .PADDING_SIZE_EXTRA_SMALL),
          //                           GridView.builder(
          //                             gridDelegate:
          //                                 SliverGridDelegateWithFixedCrossAxisCount(
          //                               crossAxisCount: 4,
          //                               crossAxisSpacing: 20,
          //                               mainAxisSpacing: 10,
          //                               childAspectRatio: (1 / 1.1),
          //                             ),
          //                             shrinkWrap: true,
          //                             physics: NeverScrollableScrollPhysics(),
          //                             itemCount: widget.product.addOns.length,
          //                             itemBuilder: (context, index) {
          //                               return InkWell(
          //                                 onTap: () {
          //                                   if (!productProvider
          //                                       .addOnActiveList[index]) {
          //                                     productProvider.addAddOn(
          //                                         true, index);
          //                                   } else if (productProvider
          //                                           .addOnQtyList[index] ==
          //                                       1) {
          //                                     productProvider.addAddOn(
          //                                         false, index);
          //                                   }
          //                                 },
          //                                 child: Container(
          //                                   alignment: Alignment.center,
          //                                   margin: EdgeInsets.only(
          //                                       bottom: productProvider
          //                                               .addOnActiveList[index]
          //                                           ? 2
          //                                           : 20),
          //                                   decoration: BoxDecoration(
          //                                     color: productProvider
          //                                             .addOnActiveList[index]
          //                                         ? ColorResources.COLOR_PRIMARY
          //                                         : ColorResources
          //                                             .BACKGROUND_COLOR,
          //                                     borderRadius:
          //                                         BorderRadius.circular(5),
          //                                     border: productProvider
          //                                             .addOnActiveList[index]
          //                                         ? null
          //                                         : Border.all(
          //                                             color: ColorResources
          //                                                 .BORDER_COLOR,
          //                                             width: 2),
          //                                     boxShadow: productProvider
          //                                             .addOnActiveList[index]
          //                                         ? [
          //                                             BoxShadow(
          //                                                 color: Colors
          //                                                     .grey[Provider.of<
          //                                                                 ThemeProvider>(
          //                                                             context)
          //                                                         .darkTheme
          //                                                     ? 700
          //                                                     : 300],
          //                                                 blurRadius: 5,
          //                                                 spreadRadius: 1)
          //                                           ]
          //                                         : null,
          //                                   ),
          //                                   child: Column(children: [
          //                                     Expanded(
          //                                         child: Column(
          //                                             mainAxisAlignment:
          //                                                 MainAxisAlignment
          //                                                     .center,
          //                                             children: [
          //                                           Text(
          //                                               widget.product
          //                                                   .addOns[index].name,
          //                                               maxLines: 2,
          //                                               overflow: TextOverflow
          //                                                   .ellipsis,
          //                                               textAlign:
          //                                                   TextAlign.center,
          //                                               style: rubikMedium
          //                                                   .copyWith(
          //                                                 color: productProvider.addOnActiveList[
          //                                                         index]
          //                                                     ? ColorResources
          //                                                         .COLOR_WHITE
          //                                                     : ColorResources
          //                                                         .COLOR_BLACK,
          //                                                 fontSize: Dimensions
          //                                                     .FONT_SIZE_SMALL,
          //                                               )),
          //                                           SizedBox(height: 5),
          //                                           Text(
          //                                             PriceConverter
          //                                                 .convertPrice(
          //                                                     context,
          //                                                     widget
          //                                                         .product
          //                                                         .addOns[index]
          //                                                         .price),
          //                                             maxLines: 1,
          //                                             overflow:
          //                                                 TextOverflow.ellipsis,
          //                                             style: rubikRegular.copyWith(
          //                                                 color: productProvider.addOnActiveList[
          //                                                         index]
          //                                                     ? ColorResources
          //                                                         .COLOR_WHITE
          //                                                     : ColorResources
          //                                                         .COLOR_BLACK,
          //                                                 fontSize: Dimensions
          //                                                     .FONT_SIZE_EXTRA_SMALL),
          //                                           ),
          //                                         ])),
          //                                     productProvider
          //                                             .addOnActiveList[index]
          //                                         ? Container(
          //                                             height: 25,
          //                                             decoration: BoxDecoration(
          //                                                 borderRadius:
          //                                                     BorderRadius
          //                                                         .circular(5),
          //                                                 color:
          //                                                     Theme.of(context)
          //                                                         .accentColor),
          //                                             child: Row(
          //                                                 mainAxisAlignment:
          //                                                     MainAxisAlignment
          //                                                         .center,
          //                                                 children: [
          //                                                   Expanded(
          //                                                     child: InkWell(
          //                                                       onTap: () {
          //                                                         if (productProvider
          //                                                                     .addOnQtyList[
          //                                                                 index] >
          //                                                             1) {
          //                                                           productProvider
          //                                                               .setAddOnQuantity(
          //                                                                   false,
          //                                                                   index);
          //                                                         } else {
          //                                                           productProvider
          //                                                               .addAddOn(
          //                                                                   false,
          //                                                                   index);
          //                                                         }
          //                                                       },
          //                                                       child: Center(
          //                                                           child: Icon(
          //                                                               Icons
          //                                                                   .remove,
          //                                                               size:
          //                                                                   15)),
          //                                                     ),
          //                                                   ),
          //                                                   Text(
          //                                                       productProvider
          //                                                           .addOnQtyList[
          //                                                               index]
          //                                                           .toString(),
          //                                                       style: rubikMedium
          //                                                           .copyWith(
          //                                                               fontSize:
          //                                                                   Dimensions.FONT_SIZE_SMALL)),
          //                                                   Expanded(
          //                                                     child: InkWell(
          //                                                       onTap: () =>
          //                                                           productProvider
          //                                                               .setAddOnQuantity(
          //                                                                   true,
          //                                                                   index),
          //                                                       child: Center(
          //                                                           child: Icon(
          //                                                               Icons
          //                                                                   .add,
          //                                                               size:
          //                                                                   15)),
          //                                                     ),
          //                                                   ),
          //                                                 ]),
          //                                           )
          //                                         : SizedBox(),
          //                                   ]),
          //                                 ),
          //                               );
          //                             },
          //                           ),
          //                           SizedBox(
          //                               height: Dimensions
          //                                   .PADDING_SIZE_EXTRA_SMALL),
          //                         ])
          //                   : SizedBox(),
        ]),
      ),
      bottomNavigationBar:
          Consumer<ProductProvider>(builder: (context, productProvider, child) {
        double _startingPrice;
        double _endingPrice;
        if (widget.product.choiceOptions.length != 0) {
          List<double> _priceList = [];
          widget.product.variations
              .forEach((variation) => _priceList.add(variation.price));
          _priceList.sort((a, b) => a.compareTo(b));
          _startingPrice = _priceList[0];
          if (_priceList[0] < _priceList[_priceList.length - 1]) {
            _endingPrice = _priceList[_priceList.length - 1];
          }
        } else {
          _startingPrice = widget.product.price;
        }

        List<String> _variationList = [];
        for (int index = 0;
            index < widget.product.choiceOptions.length;
            index++) {
          _variationList.add(widget.product.choiceOptions[index]
              .options[productProvider.variationIndex[index]]
              .replaceAll(' ', ''));
        }
        String variationType = '';
        bool isFirst = true;
        _variationList.forEach((variation) {
          if (isFirst) {
            variationType = '$variationType$variation';
            isFirst = false;
          } else {
            variationType = '$variationType-$variation';
          }
        });

        double price = widget.product.price;
        for (Variation variation in widget.product.variations) {
          if (variation.type == variationType) {
            price = variation.price;
            _variation = variation;
            break;
          }
        }
        double priceWithDiscount = PriceConverter.convertWithDiscount(context,
            price, widget.product.discount, widget.product.discountType);
        double priceWithQuantity = priceWithDiscount * productProvider.quantity;
        double addonsCost = 0;
        List<AddOn> _addOnIdList = [];
        int sumofall = widget.product.addOns.length +
            widget.product.addOns1.length +
            widget.product.addOns2.length;
        // for (int index = 0; index < sumofall; index++) {
        //   int addon2id = 0;
        //   int addon1id = 0;
        //   if (productProvider.addOnActiveList[index]) {
        //     bool containaddon = false;
        //     bool addon1 = true;
        //     bool addon2 = true;

        // for (var i = 0; i < widget.product.addOns.length; i++) {
        //   for (int indexs = 0; indexs < sumofall; indexs++) {
        //     if (productProvider.addOnActiveList[indexs]) {
        //       if (widget.product.addOns[i].id ==
        //           widget.product.addOns[indexs].id) {
        //         // containaddon = true;
        //         addonsCost = addonsCost +
        //             (widget.product.addOns[indexs].price *
        //                 productProvider.addOnQtyList[indexs]);
        //         _addOnIdList.add(AddOn(
        //             id: widget.product.addOns[indexs].id,
        //             quantity: productProvider.addOnQtyList[indexs]));
        //       }
        //     }
        //   }
        // }
        for (var i = 0; i < widget.product.addOns1.length; i++) {
          if (productProvider.addOnActiveList1[i]) {
            addonsCost = addonsCost +
                (widget.product.addOns1[i].price *
                    productProvider.addOn1QtyList1[i]);
            _addOnIdList.add(AddOn(
                id: widget.product.addOns1[i].id,
                quantity: productProvider.addOn1QtyList1[i]));
            // addon1id = i;
            // addon2 = false;
          }
        }
        for (var i = 0; i < widget.product.addOns.length; i++) {
          if (productProvider.addOnActiveList[i]) {
            addonsCost = addonsCost +
                (widget.product.addOns[i].price *
                    productProvider.addOnQtyList[i]);
            _addOnIdList.add(AddOn(
                id: widget.product.addOns[i].id,
                quantity: productProvider.addOnQtyList[i]));
            // addon1id = i;
            // addon2 = false;
          }
        }
        for (var i = 0; i < widget.product.addOns2.length; i++) {
          if (productProvider.addOnActiveList2[i]) {
            addonsCost = addonsCost +
                (widget.product.addOns2[i].price *
                    productProvider.addOn2QtyList2[i]);
            _addOnIdList.add(AddOn(
                id: widget.product.addOns2[i].id,
                quantity: productProvider.addOn2QtyList2[i]));
            // addon2id = i;
            // addon1 = false;

          }
        }

        // if (containaddon) {

        // } else if (widget.product.addOns1.asMap().containsKey(addon1id) &&
        //     addon1) {

        // } else if (widget.product.addOns2.asMap().containsKey(addon2id)) {

        // }
        //   }
        // }
        double priceWithAddons = priceWithQuantity + addonsCost;

        DateTime _currentTime =
            Provider.of<SplashProvider>(context, listen: false).currentTime;
        DateTime _start =
            DateFormat('hh:mm:ss').parse(widget.product.availableTimeStarts);
        DateTime _end =
            DateFormat('hh:mm:ss').parse(widget.product.availableTimeEnds);
        DateTime _startTime = DateTime(_currentTime.year, _currentTime.month,
            _currentTime.day, _start.hour, _start.minute, _start.second);
        DateTime _endTime = DateTime(_currentTime.year, _currentTime.month,
            _currentTime.day, _end.hour, _end.minute, _end.second);
        if (_endTime.isBefore(_startTime)) {
          _endTime = _endTime.add(Duration(days: 1));
        }
        bool _isAvailable =
            _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);

        CartModel _cartModel = CartModel(
          price,
          priceWithDiscount,
          [_variation],
          (price -
              PriceConverter.convertWithDiscount(context, price,
                  widget.product.discount, widget.product.discountType)),
          productProvider.quantity,
          price -
              PriceConverter.convertWithDiscount(
                  context, price, widget.product.tax, widget.product.taxType),
          _addOnIdList,
          widget.product,
        );
        bool isExistInCart = Provider.of<CartProvider>(context, listen: false)
            .isExistInCart(_cartModel, fromCart, widget.cartIndex);
        return Wrap(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              //height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            //color: ColorResources.getBackgroundColor(context),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(children: [
                          Container(
                            //margin: const EdgeInsets.only(right: 16.0),
                            decoration: BoxDecoration(
                                color:
                                    ColorResources.getBackgroundColor(context),
                                borderRadius: BorderRadius.circular(5)),
                            child: InkWell(
                              onTap: () {
                                var sum = productProvider.addOnQtyList.reduce(
                                    (value, element) => value + element);
                                if (productProvider.quantity > sum) {
                                  if (productProvider.quantity > 1) {
                                    productProvider.setQuantity(false);
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                                    vertical:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Icon(Icons.remove, size: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(productProvider.quantity.toString(),
                              style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            //margin: const EdgeInsets.only(left: 16.0),
                            decoration: BoxDecoration(
                                color: Color(int.parse(
                                        "#00A4A4".substring(1, 7),
                                        radix: 16) +
                                    0xFF000000),
                                borderRadius: BorderRadius.circular(5)),
                            child: InkWell(
                              onTap: () => productProvider.setQuantity(true),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                                    vertical:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          //Spacer(),
                        ]),
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(
                      //         top: 8.0, bottom: 8.0, left: 32),
                      //     child: SizedBox(
                      //       width: 200.0,
                      //       height: 90.0,
                      //       child: TextButton(
                      //           child: Column(
                      //             children: [
                      //               Row(children: [
                      //                 Text(" 23 SAR "),
                      //                 Text("Add To Cart",
                      //                     style: TextStyle(fontSize: 12)),
                      //               ]),
                      //               // Text(
                      //               //   "Inclusive of VAT",
                      //               //   style: TextStyle(
                      //               //       fontSize:
                      //               //           Dimensions.FONT_SIZE_EXTRA_SMALL),
                      //               // )
                      //             ],
                      //           ),
                      //           style: ButtonStyle(
                      //               padding:
                      //                   MaterialStateProperty.all<EdgeInsets>(
                      //                       EdgeInsets.all(15)),
                      //               foregroundColor:
                      //                   MaterialStateProperty.all<Color>(
                      //                       Colors.white),
                      //               backgroundColor:
                      //                   MaterialStateProperty.all<Color>(
                      //                 Color(int.parse("#00A4A4".substring(1, 7),
                      //                         radix: 16) +
                      //                     0xFF000000),
                      //               ),
                      //               shape: MaterialStateProperty.all<
                      //                       RoundedRectangleBorder>(
                      //                   RoundedRectangleBorder(
                      //                       borderRadius:
                      //                           BorderRadius.circular(8.0),
                      //                       side: BorderSide(
                      //                         color: Color(int.parse(
                      //                                 "#00A4A4".substring(1, 7),
                      //                                 radix: 16) +
                      //                             0xFF000000),
                      //                       )))),
                      //           onPressed: () => null),
                      //     ),
                      //   ),
                      // )
                      InkWell(
                        onTap: () {
                          if (_isAvailable && !isExistInCart) {
                            // if (!isExistInCart) {
                            // Navigator.pop(context);
                            var sum = productProvider.addOnQtyList
                                .reduce((value, element) => value + element);
                            if (sum == productProvider.quantity) {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addToCart(_cartModel, widget.cartIndex);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(getTranslated(
                                          'added_to_cart', context)),
                                      backgroundColor: Colors.green));
                              // widget.callback();
                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                        'Please Make ColdDrink Equal To quntity',
                                      ),
                                      backgroundColor: Colors.green));
                              setState(() {});
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 0),
                          //width: MediaQuery.of(context).size.width * .59,
                          decoration: BoxDecoration(
                              color: Color(int.parse("#00A4A4".substring(1, 7),
                                      radix: 16) +
                                  0xFF000000),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: _isAvailable
                                    ? !isExistInCart
                                        ? Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${PriceConverter.convertPrice(context, priceWithAddons)}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE),
                                                  ),
                                                  Text(
                                                    getTranslated(
                                                        "add_to_cart", context),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_EXTRA_LARGE),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                getTranslated(
                                                    "price_includes", context),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_SMALL),
                                              )
                                            ],
                                          )
                                        : Text(
                                            //"Already added in card",
                                            getTranslated(
                                                'added_to_cart', context),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: Dimensions
                                                    .FONT_SIZE_EXTRA_LARGE),
                                          )
                                    : Text(
                                        "Not Aavaible",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimensions
                                                .FONT_SIZE_EXTRA_LARGE),
                                      )),
                          ),
                        ),
                      )
                    ]),
              ),
            )
          ],
        );
      }),
      /*bottomNavigationBar: Container(
        margin: EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height * .068,
        decoration: BoxDecoration(
          color: Color(
              int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: tabItem(0,
                  icon: Icons.home_outlined,
                  name: "Home",
                  onTapEvent: NavigationEvents.HomePageClickedEvent),
              flex: 1,
            ),
            Flexible(
              child: tabItem(1,
                  icon: (Icons.shopping_cart_outlined),
                  name: "Cart",
                  onTapEvent: NavigationEvents.CartClickedEvent),
              flex: 1,
            ),
            Flexible(
              child: tabItem(2,
                  icon: (Icons.favorite_outline),
                  name: "Favorite",
                  onTapEvent: NavigationEvents.FavouritesClickedEvent),
              flex: 1,
            ),
            Flexible(
              child: tabItem(3,
                  icon: (Icons.search_outlined),
                  name: "Search",
                  onTapEvent: NavigationEvents.SerchClickedEvent),
              flex: 1,
            ),
          ],
        ),
      ),*/
    );
  }

  Widget tabItem(var pos, {var icon, var name, dynamic onTapEvent}) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<NavigationBloc>(context).add(onTapEvent);
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: pos == 0 ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
// Widget _buildRadioButton({String name, String subname, dynamic value}) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       Text("$name",
//           style: TextStyle(
//             fontSize: Dimensions.FONT_SIZE_LARGE,
//           )),
//       Spacer(),
//       Row(children: [
//         Text("$subname"),
//         Radio(
//           onChanged: (val) {
//             setState(() {
//               value = val;
//             });
//           },
//           groupValue: value,
//           value: value,
//           activeColor: Color(
//               int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),
//         ),
//       ]),
//     ],
//   );
// }

// Widget _buildOption2Widget(
//     {String heaing, dynamic values, String groupValue}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(children: [
//         Text(
//           "$heaing",
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: Dimensions.FONT_SIZE_LARGE),
//         ),
//         Text(" (Select up to 4)",
//             style: TextStyle(
//               fontSize: Dimensions.FONT_SIZE_SMALL,
//             )),
//       ]),
//       SizedBox(
//         height: 8,
//       ),
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(children: [
//             _buildRadioButton(
//                 name: "choice 1", subname: "SAR 14", value: radioItem2),
//             _buildRadioButton(name: "choice 2", subname: "SAR 09"),
//             _buildRadioButton(name: "choice 3", subname: "SAR 12"),
//             _buildRadioButton(name: "choice 4", subname: "SAR 03")
//           ]),
//         ),
//       ),
//       SizedBox(
//         height: 10,
//       ),
//     ],
//   );
// }
}
