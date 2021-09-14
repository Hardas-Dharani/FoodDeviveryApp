import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/category/category_screen.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_restaurant/navigation_bloc/navigation_bloc.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/screens/home/widget/banner_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/detailPage.dart';

import '../../../helper/network_info.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/splash_provider.dart';

import '../../../utill/styles.dart';

class HomeScreen extends StatefulWidget {
  final Function isMenuTapped;

  const HomeScreen({
    Key key,
    this.isMenuTapped,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categoryModel;
  bool grid = false;
  int ind = 0;
  var _isDarkMode;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  //bool showbottomSheet = false;
  Product bottomSheetData;
  bool showbottomSheet = false;
  CategoryModel catData;
  bool showCatData = false;

  @override
  void initState() {
    super.initState();
    _loadDatatwo(context, false);
    print("home");

    // _screens = [
    //   HomeScreen(
    //     isMenuTapped: widget.isMenuTapped,
    //   ),
    //   CartScreen(
    //     isMenuTapped: widget.isMenuTapped,
    //   ),
    //   // OrderScreen(),
    //   WishListScreen(
    //     isMenuTapped: widget.isMenuTapped,
    //   ),
    //   SearchScreen(),
    //   // MenuScreen(onTap: (int pageIndex) {
    //   //   _setPage(pageIndex);
    //   // }),
    // ];

    NetworkInfo.checkConnectivity(_scaffoldKey);
  }

  Future<void> _loadDatatwo(BuildContext context, bool reload) async {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<ProfileProvider>(context, listen: false)
          .getUserInfo(context);
    }
    await Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(context, reload)
        .then((value) {
      categoryModel =
          Provider.of<CategoryProvider>(context, listen: false).categoryList;
      Provider.of<CategoryProvider>(context, listen: false)
          .getSubCategoryList(context, categoryModel[ind].id.toString());
    });
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<ProfileProvider>(context, listen: false)
          .getUserInfo(context);
    }
    await Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(context, reload);
    await Provider.of<SetMenuProvider>(context, listen: false)
        .getSetMenuList(context, reload);
    await Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(context, reload);
    Provider.of<LocationProvider>(context, listen: false)
        .initAddressList(context);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    GoogleMapController controller;
    Provider.of<LocationProvider>(context, listen: false)
        .getCurrentLocation(mapController: controller);
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    _loadData(context, false);
    //_loadDatatwo(context, false);
    Provider.of<LocationProvider>(context, listen: false)
        .initializeAllAddressType(context: context);
    Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(0);
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
      /*Color(int.parse("#F5F5F5".substring(1, 7), radix: 16) + 0xFF000000),*/
      // body: Stack(
      //   children: [
      //     MenuScreen(),
      //     AnimatedContainer(
      //       transform: Matrix4.translationValues(xOffset, yOffset, 0)
      //         ..scale(scaleFactor),
      //       duration: Duration(milliseconds: 250),
      //       decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.circular(isMenuOpened ? 40 : 0)),
      //       child: Container(
      //         padding: EdgeInsets.all(isMenuOpened ? 20 : 0),
      //         decoration: BoxDecoration(
      //           color: Provider.of<ThemeProvider>(context).darkTheme
      //               ? Color(0xFF343636)
      //               : Colors.white,
      //           borderRadius: BorderRadius.circular(isMenuOpened ? 40 : 0),
      //         ),
      //         //color: Colors.white,
      //         child: InkWell(
      //           onTap: () {
      //             setState(() {
      //               xOffset = 0;
      //               yOffset = 0;
      //               scaleFactor = 1;
      //               isMenuOpened = false;
      //             });
      //           },
      //           child: Scaffold(
      //             backgroundColor: Colors.white,
      // bottomNavigationBar: Container(
      //   margin: EdgeInsets.all(5),
      //   height: 70,
      //   decoration: BoxDecoration(
      //     color: Color(
      //         int.parse("#00A4A4".substring(1, 7), radix: 16) +
      //             0xFF000000),
      //     borderRadius: BorderRadius.all(Radius.circular(16)),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey[300],
      //         blurRadius: 2,
      //         spreadRadius: 1,
      //       ),
      //     ],
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: <Widget>[
      //       Flexible(
      //         child: tabItem(0, (Icons.home_outlined), "Home"),
      //         flex: 1,
      //       ),
      //       Flexible(
      //         child: tabItem(
      //             1, (Icons.shopping_cart_outlined), "Cart"),
      //         flex: 1,
      //       ),
      //       Flexible(
      //         child:
      //             tabItem(2, (Icons.favorite_outline), "Favorite"),
      //         flex: 1,
      //       ),
      //       Flexible(
      //         child: tabItem(3, (Icons.search_outlined), "Search"),
      //         flex: 1,
      //       ),
      //     ],
      //   ),
      // ),
      body: showbottomSheet
          ? CartBottomSheet(
              product: bottomSheetData,
              callback: () {
                showbottomSheet = false;
                setState(() {});
              },
            )
          : showCatData
              ? CategoryScreen(
                  categoryModel: catData,
                  callback: () {
                    showCatData = false;
                    setState(() {});
                  },
                )
              : SafeArea(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // App Bar
                      SliverAppBar(
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.38,
                        floating: false,
                        stretch: true,
                        elevation: 0,
                        pinned: false,
                        automaticallyImplyLeading: false,
                        stretchTriggerOffset: 150.0,
                        titleSpacing: 0,
                        backgroundColor: Color(
                            int.parse("#00A4A4".substring(1, 7), radix: 16) +
                                0xFF000000),
                        actionsIconTheme: IconThemeData(opacity: 0.0),
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
                                    // color: Color(int.parse(
                                    //         "#00A4A4".substring(1, 7),
                                    //         radix: 16) +
                                    //     0xFF000000),
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(20.0),
                                        bottomLeft: Radius.circular(20.0)),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       left: 16.0, right: 16),
                                    //   child: Container(
                                    //     alignment: Alignment.topLeft,
                                    //     margin: EdgeInsets.only(
                                    //         top: (MediaQuery.of(context)
                                    //                 .size
                                    //                 .height *
                                    //             0.03)),
                                    //     child: Column(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.start,
                                    //       children: [
                                    //         Row(
                                    //           children: [
                                    //             Text(
                                    //               getTranslated(
                                    //                   "deliveringto", context),
                                    //               style: TextStyle(
                                    //                   color:
                                    //                       /*_isDarkMode
                                    //             ?
                                    //             Color(0xff000000)
                                    //             :*/
                                    //                       Color(0xff000000),

                                    //                   // Color(0xffffffff),
                                    //                   fontSize: 16),
                                    //             ),
                                    //             SizedBox(width: 3),
                                    //             Consumer<LocationProvider>(
                                    //               builder: (context,
                                    //                       locationProvider,
                                    //                       child) =>
                                    //                   locationProvider.addressList !=
                                    //                               null &&
                                    //                           locationProvider
                                    //                               .addressList
                                    //                               .isNotEmpty
                                    //                       ? Text(
                                    //                           '${locationProvider.addressList[0].streetAddress ?? ''} ',
                                    //                           softWrap: true,
                                    //                           overflow:
                                    //                               TextOverflow
                                    //                                   .ellipsis,
                                    //                           style: TextStyle(
                                    //                               color: Color(
                                    //                                   0xff000000),
                                    //                               /*_isDarkMode
                                    //                     ?Color(0xff000000):*/
                                    //                               // Color(
                                    //                               //     0xffffffff),
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .w800,
                                    //                               fontSize: 16),
                                    //                         )
                                    //                       : SizedBox(),
                                    //             ),
                                    //             SizedBox(width: 3),
                                    //             // Container(
                                    //             //   child: Image.asset(
                                    //             //     Images.tazaj_english,
                                    //             //     height:
                                    //             //         MediaQuery.of(context)
                                    //             //                 .size
                                    //             //                 .height /
                                    //             //             12.5,
                                    //             //     fit: BoxFit.scaleDown,
                                    //             //     matchTextDirection: true,
                                    //             //   ),
                                    //             // ),
                                    //           ],
                                    //         ),
                                    //         SizedBox(height: 3),
                                    //         // Text(
                                    //         //   "Abdulaziz Street",
                                    //         //   style: TextStyle(
                                    //         //       color: Colors.white,
                                    //         //       fontWeight: FontWeight.w800,
                                    //         //       fontSize: 16),
                                    //         // ),
                                    //         /*Consumer<LocationProvider>(
                                    //       builder: (context, locationProvider,
                                    //               child) =>
                                    //           locationProvider.addressList !=
                                    //                       null &&
                                    //                   locationProvider
                                    //                       .addressList
                                    //                       .isNotEmpty
                                    //               ? Text(
                                    //                   '${locationProvider.addressList[0].streetAddress ?? ''} ',
                                    //                   softWrap: true,
                                    //                   overflow:
                                    //                       TextOverflow.ellipsis,
                                    //                   style: TextStyle(
                                    //                       color:
                                    //                           _isDarkMode
                                    //                     ?Color(0xff000000):*/
                                    //         /*
                                    //                           Color(0xffffffff),
                                    //                       fontWeight:
                                    //                           FontWeight.w800,
                                    //                       fontSize: 16),
                                    //                 )
                                    //               : SizedBox(),
                                    //     ),*/
                                    //         SizedBox(height: 2),
                                    //         Consumer<ProfileProvider>(
                                    //           builder: (context,
                                    //                   profileProvider, child) =>
                                    //               profileProvider
                                    //                           .userInfoModel !=
                                    //                       null
                                    //                   ? Text(
                                    //                       '${profileProvider.userInfoModel.fName ?? ''}',
                                    //                       style: TextStyle(
                                    //                           color:
                                    //                               /*_isDarkMode
                                    //                     ?Color(0xff000000):*/
                                    //                               Color(
                                    //                                   0xff000000),
                                    //                           // Color(
                                    //                           //     0xffffffff),
                                    //                           fontWeight:
                                    //                               FontWeight
                                    //                                   .w800,
                                    //                           fontSize: 16),
                                    //                     )
                                    //                   : SizedBox(),
                                    //         )
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(
                                          top: (MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03)),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.menu,
                                          color: Color(0xff000000),
                                          /*_isDarkMode
                                    ?Color(0xff000000):*/
                                          // Color(0xffffffff),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            // xOffset = 230;
                                            // yOffset = 150;
                                            // scaleFactor = 0.6;
                                            // isMenuOpened = true;
                                          });
                                          widget.isMenuTapped();
                                        },
                                      ),
                                    ),

                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 120),
                                      child: Container(
                                        // height: 20,
                                        alignment: Alignment.topCenter,
                                        child: Image.asset(
                                          Images.tazaj_english,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              8.5,
                                          fit: BoxFit.scaleDown,
                                          matchTextDirection: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  color: Colors.red,
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(
                                      top: (MediaQuery.of(context).size.height *
                                          0.120)),
                                  width: double.infinity,
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16),
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
                                                  ?
                                                  Color(0xff000000)
                                                  :*/
                                                      Colors.white,
                                                  // Color(0xff000000),

                                                  // Color(0xffffffff),
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              // Color(
                                                              //     0xff000000),
                                                              /*_isDarkMode
                                                          ?Color(0xff000000):*/
                                                              // Color(
                                                              //     0xffffffff),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 16),
                                                        )
                                                      : SizedBox(),
                                            ),
                                            SizedBox(width: 3),
                                            // Container(
                                            //   child: Image.asset(
                                            //     Images.tazaj_english,
                                            //     height:
                                            //         MediaQuery.of(context)
                                            //                 .size
                                            //                 .height /
                                            //             12.5,
                                            //     fit: BoxFit.scaleDown,
                                            //     matchTextDirection: true,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        // Text(
                                        //   "Abdulaziz Street",
                                        //   style: TextStyle(
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.w800,
                                        //       fontSize: 16),
                                        // ),
                                        /*Consumer<LocationProvider>(
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
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color:
                                                                _isDarkMode
                                                          ?Color(0xff000000):*/
                                        /*
                                                                Color(0xffffffff),
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 16),
                                                      )
                                                    : SizedBox(),
                                          ),*/
                                        SizedBox(height: 2),
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
                                                              // Color(0xff000000),
                                                              Colors.white,
                                                          // Color(
                                                          //     0xffffffff),
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
                                  alignment: Alignment.topCenter,
                                  margin: EdgeInsets.only(
                                      top: (MediaQuery.of(context).size.height *
                                          0.180)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Consumer<BannerProvider>(
                                      builder: (context, banner, child) {
                                        return banner.bannerList == null
                                            ? bannerViewWidget(context)
                                            : banner.bannerList.length == 0
                                                ? SizedBox()
                                                : bannerViewWidget(context);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Consumer<CategoryProvider>(
                              //   builder: (context, category, child) {
                              //     return category.categoryList == null
                              //         ? CategoryView()
                              //         : category.categoryList.length == 0
                              //             ? SizedBox()
                              //             : CategoryView();
                              //   },
                              // ),
                              // Consumer<SetMenuProvider>(
                              //   builder: (context, setMenu, child) {
                              //     return setMenu.setMenuList == null
                              //         ? SetMenuView()
                              //         : setMenu.setMenuList.length == 0
                              //             ? SizedBox()
                              //             : SetMenuView();
                              //   },
                              // ),

//Browsefull menu section is below..............................................
                              /*Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * .15,
                          child: GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //       color: Colors.grey[300],
                                      //       spreadRadius: 1,
                                      //       blurRadius: 5),
                                      // ],
                                      color: ColorResources.COLOR_WHITE,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.home_menu,
                                          image: Images.home_menu,
                                          height: 110,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .95,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 75.0, left: 20),
                                        child: Text(
                                          "Browse Full Menu",
                                          style: rubikBold.copyWith(
                                              color: _isDarkMode?Colors.white:Color(0xff00A4A4),
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              BlocProvider.of<NavigationBloc>(context).add(
                                  NavigationEvents.RestaurantCategoryClicked);
                            },
                          )),
                    ),*/
                              SizedBox(
                                height: 8,
                              ),
                              Consumer<CategoryProvider>(
                                builder: (context, category, child) {
                                  if (category.categoryList == null) {
                                    return Consumer<CategoryProvider>(
                                      builder: (context, category, child) {
                                        return Column(
                                          children: [
                                            Container(
                                              //height: 83,
                                              child: category.categoryList !=
                                                      null
                                                  ? category.categoryList
                                                              .length >
                                                          0
                                                      ? ListView.builder(
                                                          itemCount: category
                                                              .categoryList
                                                              .length,
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
                                                                        listen:
                                                                            false)
                                                                    .getSubCategoryList(
                                                                        context,
                                                                        category
                                                                            .categoryList[index]
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
                                                                      // ClipOval(
                                                                      //   child: FadeInImage
                                                                      //       .assetNetwork(
                                                                      //     placeholder:
                                                                      //         Images.placeholder_image,
                                                                      //     image:
                                                                      //         '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${category.categoryList[index].image}',
                                                                      //     width:
                                                                      //         65,
                                                                      //     height:
                                                                      //         65,
                                                                      //     fit: BoxFit
                                                                      //         .cover,
                                                                      //   ),
                                                                      // ),
                                                                      Text(
                                                                        category
                                                                            .categoryList[index]
                                                                            .name,
                                                                        style: rubikMedium
                                                                            .copyWith(
                                                                          fontSize:
                                                                              Dimensions.FONT_SIZE_SMALL,
                                                                          color: ind == index
                                                                              ? Colors.black
                                                                              : Color(int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),
                                                                        ),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
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
                                            builder:
                                                (context, category, child) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    // width: 100,
                                                    child: category
                                                                .categoryList !=
                                                            null
                                                        ? category.categoryList
                                                                    .length >
                                                                0
                                                            ? ListView.builder(
                                                                itemCount: category
                                                                    .categoryList
                                                                    .length,
                                                                padding: EdgeInsets.only(
                                                                    left: Dimensions
                                                                        .PADDING_SIZE_SMALL),
                                                                physics:
                                                                    BouncingScrollPhysics(),
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      Provider.of<CategoryProvider>(context, listen: false).getSubCategoryList(
                                                                          context,
                                                                          category
                                                                              .categoryList[index]
                                                                              .id
                                                                              .toString());
                                                                      setState(
                                                                          () {
                                                                        ind =
                                                                            index;
                                                                      });
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              Dimensions.PADDING_SIZE_SMALL),
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            80,
                                                                        color: ind ==
                                                                                index
                                                                            ? Color(0xFFEF8D30)
                                                                            : Color(0xFF00B9B2),
                                                                        child:
                                                                            Text(
                                                                          category
                                                                              .categoryList[index]
                                                                              .name,
                                                                          style: rubikMedium.copyWith(
                                                                              color: Colors.white,
                                                                              fontSize: Dimensions.FONT_SIZE_SMALL),
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                            : Center(
                                                                child: Text(
                                                                    getTranslated(
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
                                height: 10.0,
                              ),
                              Container(
                                height: 40,
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
                                      Radius.circular(8),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[300],
                                          blurRadius: 1,
                                          spreadRadius: 1)
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        getTranslated("sortby", context),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          child: Icon(
                                            Icons.menu,
                                            color: grid == false
                                                ? Color(int.parse(
                                                        "#00A4A4"
                                                            .substring(1, 7),
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
                                                          "#00A4A4"
                                                              .substring(1, 7),
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
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Transform.rotate(
                                        angle: 90 * pi / 180,
                                        child: Icon(
                                          Icons.swap_horiz,
                                          color: Color(int.parse(
                                                  "#00A4A4".substring(1, 7),
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
                                        ? category.categoryProductList.length >
                                                0
                                            ? grid == true
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: StaggeredGridView
                                                        .countBuilder(
                                                            crossAxisCount: 4,
                                                            primary: false,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 30),
                                                            mainAxisSpacing:
                                                                4.0,
                                                            crossAxisSpacing:
                                                                4.0,
                                                            shrinkWrap: true,
                                                            staggeredTileBuilder:
                                                                (index) =>
                                                                    new StaggeredTile
                                                                        .fit(2),
                                                            itemCount: category
                                                                .categoryProductList
                                                                .length,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              double
                                                                  _startingPrice;
                                                              double
                                                                  _endingPrice;
                                                              if (category
                                                                      .categoryProductList[
                                                                          index]
                                                                      .choiceOptions
                                                                      .length !=
                                                                  0) {
                                                                List<double>
                                                                    _priceList =
                                                                    [];
                                                                category
                                                                    .categoryProductList[
                                                                        index]
                                                                    .variations
                                                                    .forEach((variation) =>
                                                                        _priceList
                                                                            .add(variation.price));
                                                                _priceList.sort((a,
                                                                        b) =>
                                                                    a.compareTo(
                                                                        b));
                                                                _startingPrice =
                                                                    _priceList[
                                                                        0];
                                                                if (_priceList[
                                                                        0] <
                                                                    _priceList[
                                                                        _priceList.length -
                                                                            1]) {
                                                                  _endingPrice =
                                                                      _priceList[
                                                                          _priceList.length -
                                                                              1];
                                                                }
                                                              } else {
                                                                _startingPrice =
                                                                    category
                                                                        .categoryProductList[
                                                                            index]
                                                                        .price;
                                                              }

                                                              double _discountedPrice = PriceConverter.convertWithDiscount(
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

                                                              DateTime
                                                                  _currentTime =
                                                                  Provider.of<SplashProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .currentTime;
                                                              DateTime _start = DateFormat(
                                                                      'hh:mm:ss')
                                                                  .parse(category
                                                                      .categoryProductList[
                                                                          index]
                                                                      .availableTimeStarts);
                                                              DateTime _end = DateFormat(
                                                                      'hh:mm:ss')
                                                                  .parse(category
                                                                      .categoryProductList[
                                                                          index]
                                                                      .availableTimeEnds);
                                                              DateTime
                                                                  _startTime =
                                                                  DateTime(
                                                                      _currentTime
                                                                          .year,
                                                                      _currentTime
                                                                          .month,
                                                                      _currentTime
                                                                          .day,
                                                                      _start
                                                                          .hour,
                                                                      _start
                                                                          .minute,
                                                                      _start
                                                                          .second);
                                                              DateTime _endTime = DateTime(
                                                                  _currentTime
                                                                      .year,
                                                                  _currentTime
                                                                      .month,
                                                                  _currentTime
                                                                      .day,
                                                                  _end.hour,
                                                                  _end.minute,
                                                                  _end.second);
                                                              if (_endTime.isBefore(
                                                                  _startTime)) {
                                                                _endTime = _endTime
                                                                    .add(Duration(
                                                                        days:
                                                                            1));
                                                              }
                                                              bool _isAvailable = _currentTime
                                                                      .isAfter(
                                                                          _startTime) &&
                                                                  _currentTime
                                                                      .isBefore(
                                                                          _endTime);
                                                              return InkWell(
                                                                onTap: () {
                                                                  showbottomSheet =
                                                                      true;
                                                                  bottomSheetData =
                                                                      category.categoryProductList[
                                                                          index];
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Stack(
                                                                    children: [
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.orange[300],
                                                                          border:
                                                                              Border.all(color: Colors.white),
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(20),
                                                                          ),
                                                                        ),
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                4,
                                                                            bottom:
                                                                                4,
                                                                            right:
                                                                                4,
                                                                            top:
                                                                                4),
                                                                        alignment:
                                                                            Alignment.topLeft,
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(20),
                                                                          ),
                                                                          child:
                                                                              FadeInImage.assetNetwork(
                                                                            placeholder:
                                                                                Images.placeholder_image,
                                                                            image:
                                                                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${category.categoryProductList[index].image}',
                                                                            fit:
                                                                                BoxFit.cover,
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
                                                                                alignment: Alignment.center,
                                                                                margin: EdgeInsets.only(left: 4, bottom: 4, right: 4, top: 4),
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black.withOpacity(0.6)),
                                                                                child: Text(getTranslated('not_available_now_break', context),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: rubikRegular.copyWith(
                                                                                      color: Colors.white,
                                                                                      fontSize: 8,
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                      Positioned(
                                                                        left:
                                                                            0.0,
                                                                        bottom:
                                                                            0.0,
                                                                        right:
                                                                            0.0,
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.bottomCenter,
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.only(
                                                                                left: 4,
                                                                                bottom: 4,
                                                                                right: 4,
                                                                                top: 4),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.grey.shade400,
                                                                              border: Border.all(color: Colors.white),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(20),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    width: MediaQuery.of(context).size.width * 0.3,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Flexible(
                                                                                          child: Text(category.categoryProductList[index].name, style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
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
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Flexible(
                                                                                                child: Text(
                                                                                                  '${PriceConverter.convertPrice(context, _startingPrice, discount: category.categoryProductList[index].discount, discountType: category.categoryProductList[index].discountType, asFixed: 1)}'
                                                                                                  '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: category.categoryProductList[index].discount, discountType: category.categoryProductList[index].discountType, asFixed: 1)}' : ''}',
                                                                                                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(height: 2),
                                                                                          category.categoryProductList[index].price > _discountedPrice
                                                                                              ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                                                                          left:
                                                                              120,
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              30,
                                                                          width:
                                                                              25,
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
                                                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4))),
                                                                          child:
                                                                              Center(
                                                                            child: Consumer<WishListProvider>(builder: (context,
                                                                                wishList,
                                                                                child) {
                                                                              return InkWell(
                                                                                onTap: () {
                                                                                  wishList.wishIdList.contains(category.categoryProductList[index].id) ? wishList.removeFromWishList(category.categoryProductList[index], (message) {}) : wishList.addToWishList(category.categoryProductList[index], (message) {});
                                                                                },
                                                                                child: Icon(
                                                                                  wishList.wishIdList.contains(category.categoryProductList[index].id) ? Icons.favorite : Icons.favorite_border,
                                                                                  color: wishList.wishIdList.contains(category.categoryProductList[index].id) ? Color(0xFFFC6A57) : ColorResources.COLOR_GREY,
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
                                                    itemCount: category
                                                        .categoryProductList
                                                        .length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    padding: EdgeInsets.all(
                                                        Dimensions
                                                            .PADDING_SIZE_SMALL),
                                                    itemBuilder:
                                                        (context, index) {
                                                      double _startingPrice;
                                                      double _endingPrice;
                                                      if (category
                                                              .categoryProductList[
                                                                  index]
                                                              .choiceOptions
                                                              .length !=
                                                          0) {
                                                        List<double>
                                                            _priceList = [];
                                                        category
                                                            .categoryProductList[
                                                                index]
                                                            .variations
                                                            .forEach((variation) =>
                                                                _priceList.add(
                                                                    variation
                                                                        .price));
                                                        _priceList.sort(
                                                            (a, b) =>
                                                                a.compareTo(b));
                                                        _startingPrice =
                                                            _priceList[0];
                                                        if (_priceList[0] <
                                                            _priceList[_priceList
                                                                    .length -
                                                                1]) {
                                                          _endingPrice =
                                                              _priceList[_priceList
                                                                      .length -
                                                                  1];
                                                        }
                                                      } else {
                                                        _startingPrice = category
                                                            .categoryProductList[
                                                                index]
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
                                                      DateTime _start = DateFormat(
                                                              'hh:mm:ss')
                                                          .parse(category
                                                              .categoryProductList[
                                                                  index]
                                                              .availableTimeStarts);
                                                      DateTime _end = DateFormat(
                                                              'hh:mm:ss')
                                                          .parse(category
                                                              .categoryProductList[
                                                                  index]
                                                              .availableTimeEnds);
                                                      DateTime _startTime =
                                                          DateTime(
                                                              _currentTime.year,
                                                              _currentTime
                                                                  .month,
                                                              _currentTime.day,
                                                              _start.hour,
                                                              _start.minute,
                                                              _start.second);
                                                      DateTime _endTime =
                                                          DateTime(
                                                              _currentTime.year,
                                                              _currentTime
                                                                  .month,
                                                              _currentTime.day,
                                                              _end.hour,
                                                              _end.minute,
                                                              _end.second);
                                                      if (_endTime.isBefore(
                                                          _startTime)) {
                                                        _endTime = _endTime.add(
                                                            Duration(days: 1));
                                                      }
                                                      bool _isAvailable =
                                                          _currentTime.isAfter(
                                                                  _startTime) &&
                                                              _currentTime
                                                                  .isBefore(
                                                                      _endTime);
                                                      return InkWell(
                                                        onTap: () {
                                                          showbottomSheet =
                                                              true;
                                                          bottomSheetData =
                                                              category.categoryProductList[
                                                                  index];
                                                          setState(() {});
/*        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor:
          _isDarkMode?Colors.white:Colors.black,
          builder: (con) => CartBottomSheet(
            product: product,
            callback: (CartModel cartModel) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(getTranslated('added_to_cart', context)),
                  backgroundColor: Colors.green));
            },
          ),
        );*/
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            // padding: EdgeInsets.symmetric(
                                                            //     vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                                            //     horizontal: Dimensions.PADDING_SIZE_SMALL),
                                                            // margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey[Provider.of<ThemeProvider>(
                                                                              context)
                                                                          .darkTheme
                                                                      ? 700
                                                                      : 300],
                                                                  blurRadius: 5,
                                                                  spreadRadius:
                                                                      1,
                                                                )
                                                              ],
                                                            ),
                                                            child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                      width: Dimensions
                                                                          .PADDING_SIZE_SMALL),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0,
                                                                          bottom:
                                                                              8.0,
                                                                          right:
                                                                              5.0),
                                                                      child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment
                                                                              .start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            IntrinsicHeight(
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    width: MediaQuery.of(context).size.width * 0.22,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Flexible(
                                                                                          child: Text(category.categoryProductList[index].name, textAlign: TextAlign.justify, style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 5.0),
                                                                                    child: CircleAvatar(backgroundColor: Colors.black, radius: 3),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Container(
                                                                                    width: MediaQuery.of(context).size.width * 0.275,
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                      children: [
                                                                                        Flexible(
                                                                                          child: Text(
                                                                                            '${PriceConverter.convertPrice(context, _startingPrice, discount: category.categoryProductList[index].discount, discountType: category.categoryProductList[index].discountType, asFixed: 1)}'
                                                                                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: category.categoryProductList[index].discount, discountType: category.categoryProductList[index].discountType, asFixed: 1)}' : ''}',
                                                                                            style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(height: 2),
                                                                                        category.categoryProductList[index].price > _discountedPrice
                                                                                            ? Flexible(
                                                                                                child: Text(
                                                                                                    '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                                                                                                    '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                                                                                                    style: rubikRegular.copyWith(
                                                                                                      color: ColorResources.COLOR_GREY,
                                                                                                      decoration: TextDecoration.lineThrough,
                                                                                                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                                                                    )),
                                                                                              )
                                                                                            : SizedBox(),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Center(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 50, right: 50.0),
                                                                                child: Divider(
                                                                                  color: Colors.grey[500],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Center(
                                                                              child: Container(
                                                                                width: MediaQuery.of(context).size.width * .5,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Flexible(
                                                                                      child: Text(
                                                                                        '${category.categoryProductList[index].description}',
                                                                                        style: TextStyle(color: Colors.grey),
                                                                                        maxLines: 2,
                                                                                        textAlign: TextAlign.justify,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ]),
                                                                    ),
                                                                  ),

                                                                  Stack(
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          child:
                                                                              FadeInImage.assetNetwork(
                                                                            placeholder:
                                                                                Images.placeholder_image,
                                                                            image:
                                                                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${category.categoryProductList[index].image}',
                                                                            width:
                                                                                94,
                                                                            height:
                                                                                100,
                                                                            fit:
                                                                                BoxFit.cover,
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
                                                                                  alignment: Alignment.center,
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                                                                                  child: Text(getTranslated('not_available_now_break', context),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: rubikRegular.copyWith(
                                                                                        color: Colors.white,
                                                                                        fontSize: 8,
                                                                                      )),
                                                                                ),
                                                                              ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 50),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                25,
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                border: Border.all(
                                                                                  color: Colors.white,
                                                                                ),
                                                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4))),
                                                                            child:
                                                                                Center(
                                                                              child: Consumer<WishListProvider>(builder: (context, wishList, child) {
                                                                                return InkWell(
                                                                                  onTap: () {
                                                                                    wishList.wishIdList.contains(category.categoryProductList[index].id) ? wishList.removeFromWishList(category.categoryProductList[index], (message) {}) : wishList.addToWishList(category.categoryProductList[index], (message) {});
                                                                                  },
                                                                                  child: Icon(
                                                                                    wishList.wishIdList.contains(category.categoryProductList[index].id) ? Icons.favorite : Icons.favorite_border,
                                                                                    color: wishList.wishIdList.contains(category.categoryProductList[index].id) ? Color(0xFFFC6A57) : ColorResources.COLOR_GREY,
                                                                                  ),
                                                                                );
                                                                              }),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),

                                                                  // Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                                                  //   Icon(Icons.add),
                                                                  //   Expanded(child: SizedBox()),
                                                                  //   RatingBar(
                                                                  //       rating: product.rating.length > 0
                                                                  //           ? double.parse(product.rating[0].average)
                                                                  //           : 0.0,
                                                                  //       size: 10),
                                                                  // ]),
                                                                ]),
                                                          ),
                                                        ),
                                                      );
                                                      /*ProductWidget(
                                                      product: category
                                                              .categoryProductList[
                                                          index]);*/
                                                    },
                                                  )
                                            : NoDataScreen()
                                        : (grid == false
                                            ? ListView.builder(
                                                itemCount: 10,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.all(
                                                    Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                itemBuilder: (context, index) {
                                                  return ProductShimmer(
                                                      isEnabled: category
                                                              .categoryProductList ==
                                                          null);
                                                },
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[300],
                                                  highlightColor:
                                                      Colors.grey[100],
                                                  enabled: true,
                                                  child: StaggeredGridView
                                                      .countBuilder(
                                                    crossAxisCount: 4,
                                                    primary: false,
                                                    padding: EdgeInsets.only(
                                                        bottom: 30),
                                                    mainAxisSpacing: 4.0,
                                                    crossAxisSpacing: 4.0,
                                                    shrinkWrap: true,
                                                    staggeredTileBuilder:
                                                        (index) =>
                                                            new StaggeredTile
                                                                .fit(2),
                                                    itemCount: 6,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            Stack(children: [
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .2,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .45,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                                ),
                                                                boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                          .grey[
                                                                      300],
                                                                  blurRadius: 1,
                                                                  spreadRadius:
                                                                      1),
                                                            ]),
                                                        margin: EdgeInsets.only(
                                                            left: 4,
                                                            bottom: 4,
                                                            right: 4,
                                                            top: 4),
                                                        alignment:
                                                            Alignment.topLeft,
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                              ))
                                    : Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor)));
                              }),
//Three item list view is below.................................................
                              /*Consumer<SetMenuProvider>(
                      builder: (context, setMenu, child) {
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .19,
                              child: setMenu.setMenuList != null
                                  ? setMenu.setMenuList.length > 0
                                      ? ListView.builder(
                                          itemCount: setMenu.setMenuList.length,
                                          padding: EdgeInsets.only(
                                              left: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder:
                                                        (con) =>
                                                            CartBottomSheet(
                                                              product: setMenu
                                                                      .setMenuList[
                                                                  index],
                                                              fromSetMenu: true,
                                                              callback: (CartModel
                                                                  cartModel) {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                    content: Text(getTranslated(
                                                                        'added_to_cart',
                                                                        context)),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green));
                                                              },
                                                            ));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                child: Stack(children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .35,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors
                                                                .grey[300],
                                                            spreadRadius: 1,
                                                            blurRadius: 1),
                                                      ],
                                                      color: Colors.orange[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        placeholder: Images
                                                            .placeholder_image,
                                                        image:
                                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${setMenu.setMenuList[index].image}',
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .35,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .18,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 10.0),
                                                    child: Text(
                                                      setMenu.setMenuList[index]
                                                          .name,
                                                      style: rubikMedium.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: Text(getTranslated(
                                              'no_set_menu_available',
                                              context)))
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .18,
                                      child: ListView.builder(
                                        itemCount: 10,
                                        padding: EdgeInsets.only(
                                            left:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                right: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[300],
                                              highlightColor: Colors.grey[100],
                                              enabled:
                                                  Provider.of<CategoryProvider>(
                                                              context)
                                                          .categoryList ==
                                                      null,
                                              child: Stack(children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .35,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .18,
                                                  decoration: BoxDecoration(
                                                    color: ColorResources
                                                        .COLOR_WHITE,
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0,
                                                          left: 10.0),
                                                  child: Container(
                                                      height: 10,
                                                      width: 50,
                                                      color: ColorResources
                                                          .COLOR_WHITE),
                                                ),
                                              ]),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ],
                        );
                      },
                    ),*/
                              /*SizedBox(
                      height: 8,
                    ),*/
// popular item view is below
                              /*Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          */
                              /*"Popular Items"*/
                              /*"Menu",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),

                    ProductView(
                        productType: ProductType.POPULAR_PRODUCT,
                        scrollController: _scrollController),*/
                            ]),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget bannerViewWidget(BuildContext context) {
    List<T> map<T>(List list, Function handler) {
      List<T> result = [];
      for (var i = 0; i < list.length; i++) {
        result.add(handler(i, list[i]));
      }
      return result;
    }

    int _current = 0;
    return SizedBox(
      height: MediaQuery.of(context).size.height * .28,
      child: Consumer<BannerProvider>(
        builder: (context, banner, child) {
          return banner.bannerList != null
              ? banner.bannerList.length > 0
                  ? Stack(children: [
                      CarouselSlider.builder(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * .28,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          onPageChanged: (index, dsjkbg) {
                            setState(() {
                              _current = index;
                            });
                          },
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 500),
                          viewportFraction: 1,
                        ),
                        itemCount: banner.bannerList.length,
                        itemBuilder: (context, index, val) {
                          return InkWell(
                            onTap: () {
                              if (banner.bannerList[index].productId != null) {
                                Product product;
                                for (Product prod in banner.productList) {
                                  if (prod.id ==
                                      banner.bannerList[index].productId) {
                                    product = prod;
                                    break;
                                  }
                                }

                                showbottomSheet = true;
                                bottomSheetData = product;
                                setState(() {});
                                // showModalBottomSheet(
                                //   context: context,
                                //   isScrollControlled: true,
                                //   backgroundColor: Colors.transparent,
                                //   builder: (con) => CartBottomSheet(
                                //     product: product,
                                //     callback: (CartModel cartModel) {
                                //       ScaffoldMessenger.of(context)
                                //           .showSnackBar(SnackBar(
                                //         content: Text(getTranslated(
                                //             'added_to_cart', context)),
                                //         backgroundColor: Colors.green,
                                //       ));
                                //     },
                                //   ),
                                // );
                              } else if (banner.bannerList[index].categoryId !=
                                  null) {
                                CategoryModel category;
                                for (CategoryModel categoryModel
                                    in Provider.of<CategoryProvider>(context,
                                            listen: false)
                                        .categoryList) {
                                  if (categoryModel.id ==
                                      banner.bannerList[index].categoryId) {
                                    category = categoryModel;
                                    break;
                                  }
                                }
                                if (category != null) {
                                  setState(() {
                                    showCatData = true;
                                  });
                                  catData = category;
                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => CategoryScreen(
                                              categoryModel: category)));*/
                                }
                              }
                            },
                            child: Container(
                              height: 85,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  right: Dimensions.PADDING_SIZE_SMALL),
                              decoration: BoxDecoration(
                                color: ColorResources.COLOR_WHITE,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}/${banner.bannerList[index].image}',
                                  height: 85,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              map<Widget>(banner.bannerList, (index, url) {
                            return Container(
                              width: 10.0,
                              height: 10.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Color(int.parse("#00A4A4".substring(1, 7),
                                            radix: 16) +
                                        0xFF000000)
                                    : Color(int.parse("#FFFFFF".substring(1, 7),
                                            radix: 16) +
                                        0xFF000000),
                              ),
                            );
                          }),
                        ),
                      ),
                    ])
                  : Center(
                      child:
                          Text(getTranslated('no_banner_available', context)))
              : BannerShimmer();
        },
      ),
    );
  }

// var isSelected = 0;

// Widget tabItem(
//   var pos,
//   var icon,
//   var name,
// ) {
//   return GestureDetector(
//     onTap: () {
//       _setPage(pos);
//       setState(() {
//         isSelected = pos;
//       });
//     },
//     child: Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Center(
//         child: Icon(
//           icon,
//           size: 30,
//           color: isSelected == pos ? Colors.white : Colors.grey,
//         ),
//       ),
//     ),
//   );
// }

// void _setPage(int pageIndex) {
//   setState(() {
//     _pageController.jumpToPage(pageIndex);
//     _pageIndex = pageIndex;
//   });
// }
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

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled:
                  Provider.of<CategoryProvider>(context).categoryList == null,
              child: Column(children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: ColorResources.COLOR_WHITE,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                    height: 10, width: 50, color: ColorResources.COLOR_WHITE),
              ]),
            ),
          );
        },
      ),
    );
  }
}
