import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/search/search_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key key, this.isMenuTapped}) : super(key: key);
  final Function isMenuTapped;

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  var _isDarkMode;
  bool showbottomSheet = false;
  Product bottomSheetData;

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final ScrollController _scrollController = ScrollController();
    return Scaffold(
        backgroundColor: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
        body: showbottomSheet
            ? CartBottomSheet(
                product: bottomSheetData,
                callback: () {
                  showbottomSheet = false;
                  setState(() {});
                },

                /* callback: (CartModel cartModel) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(getTranslated('added_to_cart', context)),
                    backgroundColor: Colors.green));
              },*/
              )
            : SafeArea(
                child:
                    CustomScrollView(controller: _scrollController, slivers: [
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
                  backgroundColor: Color(
                      int.parse("#00A4A4".substring(1, 7), radix: 16) +
                          0xFF000000),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: [
                      StretchMode.zoomBackground,
                    ],
                    background: Container(
                      color:
                          _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.16,
                            decoration: BoxDecoration(
                              color: Color(int.parse("#00A4A4".substring(1, 7),
                                      radix: 16) +
                                  0xFF000000),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0)),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      top: (MediaQuery.of(context).size.height *
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
                                                    Color(0xffF5F5F5),
                                                fontSize: 16),
                                          ),
                                          SizedBox(width: 3),
                                          Consumer<LocationProvider>(
                                            builder: (context, locationProvider,
                                                    child) =>
                                                locationProvider.addressList !=
                                                            null &&
                                                        locationProvider
                                                            .addressList
                                                            .isNotEmpty
                                                    ? Text(
                                                        '${locationProvider.addressList[0].streetAddress ?? ''} ',
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color:
                                                                /*_isDarkMode
                                                      ?Color(0xff000000):*/
                                                                Color(
                                                                    0xffF5F5F5),
                                                            fontWeight:
                                                                FontWeight.w800,
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
                                                        color:
                                                            */ /*_isDarkMode
                                                      ?Color(0xff000000):*/
                                      /*
                                                            Color(0xffF5F5F5),
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
                                                            Color(0xffF5F5F5),
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
                                    top: (MediaQuery.of(context).size.height *
                                        0.03)),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    color:
                                        /*_isDarkMode
                                  ?Color(0xff000000):*/
                                        Color(0xffF5F5F5),
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
                                top:
                                    (MediaQuery.of(context).size.height * 0.1)),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SearchScreen()));
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * .67,
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
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              child: Icon(Icons.search,
                                                  color: _isDarkMode
                                                      ? Color(0xff000000)
                                                      : Colors.grey,
                                                  size: 25)),
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
                  child: _isLoggedIn
                      ? Consumer<WishListProvider>(
                          builder: (context, wishlistProvider, child) {
                            print("Datat is =" +
                                wishlistProvider.wishList.toString());
                            return wishlistProvider.wishList != null
                                ? wishlistProvider.wishIdList.length > 0
                                    ? RefreshIndicator(
                                        onRefresh: () async {
                                          await Provider.of<WishListProvider>(
                                                  context,
                                                  listen: false)
                                              .initWishList(context);
                                        },
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: StaggeredGridView.countBuilder(
                                            crossAxisCount: 4,
                                            primary: false,
                                            padding:
                                                EdgeInsets.only(bottom: 30),
                                            mainAxisSpacing: 4.0,
                                            crossAxisSpacing: 4.0,
                                            shrinkWrap: true,
                                            staggeredTileBuilder: (index) =>
                                                new StaggeredTile.fit(2),
                                            itemCount: wishlistProvider
                                                .wishIdList.length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              double _startingPrice;
                                              double _endingPrice;
                                              if (wishlistProvider
                                                      .wishList[index]
                                                      .choiceOptions
                                                      .length !=
                                                  0) {
                                                List<double> _priceList = [];
                                                wishlistProvider
                                                    .wishList[index].variations
                                                    .forEach((variation) =>
                                                        _priceList.add(
                                                            variation.price));
                                                _priceList.sort(
                                                    (a, b) => a.compareTo(b));
                                                _startingPrice = _priceList[0];
                                                if (_priceList[0] <
                                                    _priceList[
                                                        _priceList.length -
                                                            1]) {
                                                  _endingPrice = _priceList[
                                                      _priceList.length - 1];
                                                }
                                              } else {
                                                _startingPrice =
                                                    wishlistProvider
                                                        .wishList[index].price;
                                              }

                                              double _discountedPrice =
                                                  PriceConverter
                                                      .convertWithDiscount(
                                                          context,
                                                          wishlistProvider
                                                              .wishList[index]
                                                              .price,
                                                          wishlistProvider
                                                              .wishList[index]
                                                              .discount,
                                                          wishlistProvider
                                                              .wishList[index]
                                                              .discountType);

                                              DateTime _currentTime =
                                                  Provider.of<SplashProvider>(
                                                          context,
                                                          listen: false)
                                                      .currentTime;
                                              DateTime _start =
                                                  DateFormat('hh:mm:ss').parse(
                                                      wishlistProvider
                                                          .wishList[index]
                                                          .availableTimeStarts);
                                              DateTime _end =
                                                  DateFormat('hh:mm:ss').parse(
                                                      wishlistProvider
                                                          .wishList[index]
                                                          .availableTimeEnds);
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
                                              if (_endTime
                                                  .isBefore(_startTime)) {
                                                _endTime = _endTime
                                                    .add(Duration(days: 1));
                                              }
                                              bool _isAvailable = _currentTime
                                                      .isAfter(_startTime) &&
                                                  _currentTime
                                                      .isBefore(_endTime);
                                              return InkWell(
                                                onTap: () {
                                                  showbottomSheet = true;
                                                  bottomSheetData =
                                                      wishlistProvider
                                                          .wishList[index];
                                                  setState(() {});
                                                  // showModalBottomSheet(
                                                  //   context: context,
                                                  //   isScrollControlled: true,
                                                  //   backgroundColor:
                                                  //       Colors.transparent,
                                                  //   builder: (con) => CartBottomSheet(
                                                  //     product: wishlistProvider
                                                  //         .wishList[index],
                                                  //     callback:
                                                  //         (CartModel cartModel) {
                                                  //       ScaffoldMessenger.of(context)
                                                  //           .showSnackBar(SnackBar(
                                                  //               content: Text(
                                                  //                   getTranslated(
                                                  //                       'added_to_cart',
                                                  //                       context)),
                                                  //               backgroundColor:
                                                  //                   Colors.green));
                                                  //     },
                                                  //   ),
                                                  // );
                                                },
                                                child: Stack(children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.orange[300],
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        left: 4,
                                                        bottom: 4,
                                                        right: 4,
                                                        top: 4),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Stack(children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                                child: FadeInImage
                                                                    .assetNetwork(
                                                                  placeholder:
                                                                      Images
                                                                          .placeholder_image,
                                                                  image:
                                                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${wishlistProvider.wishList[index].image}',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .24,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .45,
                                                                ),
                                                              ),
                                                            ]),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  _isAvailable
                                                      ? SizedBox()
                                                      : Positioned.fill(
                                                          top: 0,
                                                          left: 0,
                                                          bottom: 0,
                                                          right: 0,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 4,
                                                                    bottom: 4,
                                                                    right: 4,
                                                                    top: 4),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.6)),
                                                            child: Text(
                                                                getTranslated(
                                                                    'not_available_now_break',
                                                                    context),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    rubikRegular
                                                                        .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 8,
                                                                )),
                                                          ),
                                                        ),
                                                  Positioned(
                                                    left: 0.0,
                                                    right: 0.0,
                                                    bottom: 0.0,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 4,
                                                            bottom: 4,
                                                            right: 4,
                                                            top: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(20),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  top: 8.0,
                                                                  bottom: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.4,
                                                                child: Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child: Text(
                                                                          wishlistProvider
                                                                              .wishList[
                                                                                  index]
                                                                              .name,
                                                                          style: TextStyle(
                                                                              fontFamily: 'Rubik',
                                                                              fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black),
                                                                          maxLines: 2,
                                                                          overflow: TextOverflow.ellipsis),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Container(
                                                                child: Center(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Flexible(
                                                                            child: Text(
                                                                                '${PriceConverter.convertPrice(context, _startingPrice, discount: wishlistProvider.wishList[index].discount, discountType: wishlistProvider.wishList[index].discountType, asFixed: 1)}'
                                                                                '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: wishlistProvider.wishList[index].discount, discountType: wishlistProvider.wishList[index].discountType, asFixed: 1)}' : ''}',
                                                                                style: TextStyle(fontFamily: 'Rubik', fontSize: Dimensions.FONT_SIZE_DEFAULT, fontWeight: FontWeight.w500, color: Colors.black) /*rubikMedium.copyWith(
                                                                            fontSize:
                                                                                Dimensions.FONT_SIZE_SMALL),*/
                                                                                ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              2),
                                                                      wishlistProvider.wishList[index].price >
                                                                              _discountedPrice
                                                                          ? Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                  Flexible(
                                                                                    child: Text(
                                                                                        '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                                                                                        '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                                                                                        style: TextStyle(fontFamily: 'Rubik', fontSize: Dimensions.FONT_SIZE_DEFAULT, fontWeight: FontWeight.w500, color: Colors.black) /*rubikMedium.copyWith(
                                                                                    color: ColorResources.COLOR_GREY,
                                                                                    decoration: TextDecoration.lineThrough,
                                                                                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                                                  )*/
                                                                                        ),
                                                                                  ),
                                                                                ])
                                                                          : SizedBox(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 120,
                                                    ),
                                                    child: Container(
                                                      height: 30,
                                                      width: 25,
                                                      margin: EdgeInsets.only(
                                                          left: 4,
                                                          bottom: 4,
                                                          right: 4,
                                                          top: 4),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          4),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          4))),
                                                      child: Center(
                                                        child: Consumer<
                                                                WishListProvider>(
                                                            builder: (context,
                                                                wishList,
                                                                child) {
                                                          return InkWell(
                                                            onTap: () {
                                                              wishList.wishIdList.contains(
                                                                      wishlistProvider
                                                                          .wishList[
                                                                              index]
                                                                          .id)
                                                                  ? wishList.removeFromWishList(
                                                                      wishlistProvider
                                                                              .wishList[
                                                                          index],
                                                                      (message) {})
                                                                  : wishList.addToWishList(
                                                                      wishlistProvider
                                                                              .wishList[
                                                                          index],
                                                                      (message) {});
                                                            },
                                                            child: Icon(
                                                              wishList.wishIdList.contains(
                                                                      wishlistProvider
                                                                          .wishList[
                                                                              index]
                                                                          .id)
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border,
                                                              color: wishList
                                                                      .wishIdList
                                                                      .contains(wishlistProvider
                                                                          .wishList[
                                                                              index]
                                                                          .id)
                                                                  ? Color(
                                                                      0xFFFC6A57)
                                                                  : ColorResources
                                                                      .COLOR_GREY,
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              );
                                            })
                                        // child: ListView.builder(
                                        //   itemCount: wishlistProvider.wishList.length,
                                        //   physics: NeverScrollableScrollPhysics(),
                                        //   shrinkWrap: true,
                                        //   padding: EdgeInsets.all(
                                        //       Dimensions.PADDING_SIZE_SMALL),
                                        //   itemBuilder: (context, index) {
                                        //     return ProductWidget(
                                        //         product:
                                        //             wishlistProvider.wishList[index]);
                                        //   },
                                        // ),
                                        )
                                    : NoDataScreen()
                                : Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                ColorResources.COLOR_PRIMARY)));
                          },
                        )
                      : NotLoggedInScreen(),
                )
              ])));
  }
}
