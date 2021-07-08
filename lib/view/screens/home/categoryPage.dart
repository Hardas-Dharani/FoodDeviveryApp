import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/navigation_bloc/navigation_bloc.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import '../../../helper/network_info.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/styles.dart';
import '../search/search_screen.dart';
import 'widget/category_view.dart';
import 'package:intl/intl.dart';

class CategoryPage extends StatefulWidget with NavigationStates {
  const CategoryPage({Key key, this.isMenuTapped}) : super(key: key);
  final Function isMenuTapped;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  List<CategoryModel> categoryModel;
  bool grid = true;
  int ind = 0;
  var _isDarkMode;
  @override
  void initState() {
    super.initState();

    NetworkInfo.checkConnectivity(_scaffoldKey);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    /*if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<ProfileProvider>(context, listen: false)
          .getUserInfo(context);
    }*/
    await Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(context, reload)
        .then((value) {
      categoryModel =
          Provider.of<CategoryProvider>(context, listen: false).categoryList;
      Provider.of<CategoryProvider>(context, listen: false)
          .getSubCategoryList(context, categoryModel[ind].id.toString());
    });
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    _loadData(context, false);

    return WillPopScope(
      onWillPop: () {
        BlocProvider.of<NavigationBloc>(context)
            .add(NavigationEvents.HomePageClickedEvent);
      },
      child: Scaffold(
        backgroundColor:_isDarkMode
            ?Color(0xff000000):Color(0xffF5F5F5),
        body: SafeArea(
          child: CustomScrollView(
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
                backgroundColor:_isDarkMode
                    ?Color(0xff000000):Color(0xffF5F5F5),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [
                    StretchMode.zoomBackground,
                  ],
                  background: Container(
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
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    top: (MediaQuery.of(context).size.height *
                                        0.03)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Delivering to",
                                      style: TextStyle(
                                          color: Color(0xffffffff), fontSize: 16),
                                    ),
                                    SizedBox(height: 5),
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
                                                      color: Color(0xffffffff),
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 16),
                                                )
                                              : SizedBox(),
                                    ),
                                    SizedBox(height: 5),
                                    Consumer<ProfileProvider>(
                                      builder: (context, profileProvider,
                                              child) =>
                                          profileProvider.userInfoModel != null
                                              ? Text(
                                                  '${profileProvider.userInfoModel.fName ?? ''} ',
                                                  style: TextStyle(
                                                      color: Color(0xffffffff),
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
                                  color: Color(0xffffffff),
                                ),
                                onPressed: () {
                                  // setState(() {
                                  //   // xOffset = 230;
                                  //   // yOffset = 150;
                                  //   // scaleFactor = 0.6;
                                  //   // isMenuOpened = true;
                                  // });
                                  widget.isMenuTapped();
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(
                              top: (MediaQuery.of(context).size.height * 0.1)),
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
                                      horizontal: Dimensions.PADDING_SIZE_SMALL,
                                      vertical: 2),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            child:
                                                Icon(Icons.search, size: 25,
                                                color: Colors.grey,)),
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
                child: Column(children: [
                  Consumer<CategoryProvider>(
                    builder: (context, category, child) {
                      if (category.categoryList == null) {
                        return Consumer<CategoryProvider>(
                          builder: (context, category, child) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 80,
                                  child: category.categoryList != null
                                      ? category.categoryList.length > 0
                                          ? ListView.builder(
                                              itemCount:
                                                  category.categoryList.length,
                                              padding: EdgeInsets.only(
                                                  left: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Provider.of<CategoryProvider>(
                                                            context,
                                                            listen: false)
                                                        .getSubCategoryList(
                                                            context,
                                                            category
                                                                .categoryList[
                                                                    index]
                                                                .id
                                                                .toString());
                                                    setState(() {
                                                      ind = index;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: Dimensions
                                                            .PADDING_SIZE_SMALL),
                                                    child: Column(children: [
                                                      ClipOval(
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder: Images
                                                              .placeholder_image,
                                                          image:
                                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${category.categoryList[index].image}',
                                                          width: 65,
                                                          height: 65,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Text(
                                                        category
                                                            .categoryList[index]
                                                            .name,
                                                        style: rubikMedium
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
                                                          color: ind == index
                                                              ? Colors.black
                                                              : Color(int.parse(
                                                                      "#00A4A4"
                                                                          .substring(
                                                                              1,
                                                                              7),
                                                                      radix:
                                                                          16) +
                                                                  0xFF000000),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ]),
                                                  ),
                                                );
                                              },
                                            )
                                          : Center(
                                              child: Text(getTranslated(
                                                  'no_category_available',
                                                  context)))
                                      : CategoryShimmer(),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return category.categoryList.length == 0
                            ? SizedBox()
                            : Consumer<CategoryProvider>(
                                builder: (context, category, child) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                        child: category.categoryList != null
                                            ? category.categoryList.length > 0
                                                ? ListView.builder(
                                                    itemCount: category
                                                        .categoryList.length,
                                                    padding: EdgeInsets.only(
                                                        left: Dimensions
                                                            .PADDING_SIZE_SMALL),
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          Provider.of<CategoryProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .getSubCategoryList(
                                                                  context,
                                                                  category
                                                                      .categoryList[
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                          setState(() {
                                                            ind = index;
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              right: Dimensions
                                                                  .PADDING_SIZE_SMALL),
                                                          child: Column(
                                                              children: [
                                                                ClipOval(
                                                                  child: FadeInImage
                                                                      .assetNetwork(
                                                                    placeholder:
                                                                        Images
                                                                            .placeholder_image,
                                                                    image:
                                                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${category.categoryList[index].image}',
                                                                    width: 65,
                                                                    height: 65,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  category
                                                                      .categoryList[
                                                                          index]
                                                                      .name,
                                                                  style: rubikMedium.copyWith(
                                                                      color: ind ==
                                                                              index
                                                                          ? Colors
                                                                              .grey
                                                                          : Color(int.parse("#00A4A4".substring(1, 7), radix: 16) +
                                                                              0xFF000000),
                                                                      fontSize:
                                                                          Dimensions
                                                                              .FONT_SIZE_SMALL),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ]),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : Center(
                                                    child: Text(getTranslated(
                                                        'no_category_available',
                                                        context)))
                                            : CategoryShimmer(),
                                      ),
                                    ],
                                  );
                                },
                              );
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(
                            int.parse("#FFFFFF".substring(1, 7), radix: 16) +
                                0xFF000000),
                        border: Border.all(
                          color: Color(
                              int.parse("#FFFFFF".substring(1, 7), radix: 16) +
                                  0xFF000000),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 1,
                              spreadRadius: 1)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            "Sort by",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(int.parse(
                                        "#00A4A4".substring(1, 7),
                                        radix: 16) +
                                    0xFF000000)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: Icon(
                                Icons.menu,
                                color: grid == false
                                    ? Color(int.parse("#00A4A4".substring(1, 7),
                                            radix: 16) +
                                        0xFF000000)
                                    : Colors.grey[300],
                                size: 30,
                              ),
                              onTap: () {
                                setState(() {
                                  grid = false;
                                });
                              },
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            GestureDetector(
                              child: Icon(Icons.grid_view,
                                  size: 22,
                                  color: grid == true
                                      ? Color(int.parse(
                                              "#00A4A4".substring(1, 7),
                                              radix: 16) +
                                          0xFF000000)
                                      : Colors.grey[300]),
                              onTap: () {
                                setState(() {
                                  grid = true;
                                });
                              },
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Transform.rotate(
                            angle: 90 * pi / 180,
                            child: Icon(
                              Icons.swap_horiz,
                              color: Color(int.parse("#00A4A4".substring(1, 7),
                                      radix: 16) +
                                  0xFF000000),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Consumer<CategoryProvider>(
                      builder: (context, category, child) {
                    return category.subCategoryList != null
                        ? category.categoryProductList != null
                            ? category.categoryProductList.length > 0
                                ? grid == true
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
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
                                            itemCount: category
                                                .categoryProductList.length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              double _startingPrice;
                                              double _endingPrice;
                                              if (category
                                                      .categoryProductList[
                                                          index]
                                                      .choiceOptions
                                                      .length !=
                                                  0) {
                                                List<double> _priceList = [];
                                                category
                                                    .categoryProductList[index]
                                                    .variations
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
                                                _startingPrice = category
                                                    .categoryProductList[index]
                                                    .price;
                                              }

                                              double _discountedPrice =
                                                  PriceConverter.convertWithDiscount(
                                                      context,
                                                      category
                                                          .categoryProductList[
                                                              index]
                                                          .price,
                                                      category
                                                          .categoryProductList[
                                                              index]
                                                          .discount,
                                                      category
                                                          .categoryProductList[
                                                              index]
                                                          .discountType);

                                              DateTime _currentTime =
                                                  Provider.of<SplashProvider>(
                                                          context,
                                                          listen: false)
                                                      .currentTime;
                                              DateTime _start =
                                                  DateFormat('hh:mm:ss').parse(
                                                      category
                                                          .categoryProductList[
                                                              index]
                                                          .availableTimeStarts);
                                              DateTime _end =
                                                  DateFormat('hh:mm:ss').parse(
                                                      category
                                                          .categoryProductList[
                                                              index]
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
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder: (con) =>
                                                        CartBottomSheet(
                                                      product: category
                                                              .categoryProductList[
                                                          index],
                                                      callback: (CartModel
                                                          cartModel) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    getTranslated(
                                                                        'added_to_cart',
                                                                        context)),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green));
                                                      },
                                                    ),
                                                  );
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
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        placeholder: Images
                                                            .placeholder_image,
                                                        image:
                                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${category.categoryProductList[index].image}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  _isAvailable
                                                      ? SizedBox()
                                                      : Positioned(
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
                                                    bottom: 0.0,
                                                    right: 0.0,
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
                                                          color: Colors.grey.shade400,
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
                                                                    0.3,
                                                                child: Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child: Text(
                                                                          category
                                                                              .categoryProductList[
                                                                                  index]
                                                                              .name,
                                                                          style:
                                                                              rubikMedium,
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
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
                                                                            child:
                                                                                Text(
                                                                              '${PriceConverter.convertPrice(context, _startingPrice, discount: category.categoryProductList[index].discount, discountType: category.categoryProductList[index].discountType, asFixed: 1)}'
                                                                              '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: category.categoryProductList[index].discount, discountType: category.categoryProductList[index].discountType, asFixed: 1)}' : ''}',
                                                                              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              2),
                                                                      category.categoryProductList[index].price >
                                                                              _discountedPrice
                                                                          ? Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                  Flexible(
                                                                                    child: Text(
                                                                                        '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                                                                                        '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                                                                                        style: rubikMedium.copyWith(
                                                                                          color: ColorResources.COLOR_GREY,
                                                                                          decoration: TextDecoration.lineThrough,
                                                                                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                                                        )),
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
                                                              wishList.wishIdList
                                                                      .contains(category
                                                                          .categoryProductList[
                                                                              index]
                                                                          .id)
                                                                  ? wishList.removeFromWishList(
                                                                      category.categoryProductList[
                                                                          index],
                                                                      (message) {})
                                                                  : wishList.addToWishList(
                                                                      category.categoryProductList[
                                                                          index],
                                                                      (message) {});
                                                            },
                                                            child: Icon(
                                                              wishList.wishIdList
                                                                      .contains(category
                                                                          .categoryProductList[
                                                                              index]
                                                                          .id)
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border,
                                                              color: wishList
                                                                      .wishIdList
                                                                      .contains(category
                                                                          .categoryProductList[
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
                                            }),
                                      )
                                    : ListView.builder(
                                        itemCount:
                                            category.categoryProductList.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_SMALL),
                                        itemBuilder: (context, index) {
                                          return ProductWidget(
                                              product: category
                                                  .categoryProductList[index]);
                                        },
                                      )
                                : NoDataScreen()
                            : (grid == false
                                ? ListView.builder(
                                    itemCount: 10,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    itemBuilder: (context, index) {
                                      return ProductShimmer(
                                          isEnabled:
                                              category.categoryProductList ==
                                                  null);
                                    },
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      enabled: true,
                                      child: StaggeredGridView.countBuilder(
                                        crossAxisCount: 4,
                                        primary: false,
                                        padding: EdgeInsets.only(bottom: 30),
                                        mainAxisSpacing: 4.0,
                                        crossAxisSpacing: 4.0,
                                        shrinkWrap: true,
                                        staggeredTileBuilder: (index) =>
                                            new StaggeredTile.fit(2),
                                        itemCount: 6,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Stack(children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .45,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey[300],
                                                      blurRadius: 1,
                                                      spreadRadius: 1),
                                                ]),
                                            margin: EdgeInsets.only(
                                                left: 4,
                                                bottom: 4,
                                                right: 4,
                                                top: 4),
                                            alignment: Alignment.topLeft,
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ))
                        : Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor)));
                  }),
                ]),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
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
        ),
      ),
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
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
