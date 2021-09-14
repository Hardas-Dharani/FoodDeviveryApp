import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/network_info.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/navigation_bloc/navigation_bloc.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/cart/cart_screen.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:flutter_restaurant/view/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';
import '../search/search_screen.dart';

class DashboardScreen extends StatefulWidget with NavigationStates {
  final Function isMenuTapped;
  final int getPageIndex;
  const DashboardScreen({
    Key key,
    this.isMenuTapped,
    this.getPageIndex,
  }) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  var isSelected = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(
        isMenuTapped: widget.isMenuTapped,
      ),
      CartScreen(
        isMenuTapped: widget.isMenuTapped,
        setPageInTabs: _setPage,
      ),
      // OrderScreen(),
      WishListScreen(
        isMenuTapped: widget.isMenuTapped,
      ),
      SearchScreen(isMenuTapped: widget.isMenuTapped),

      // MenuScreen(onTap: (int pageIndex) {
      //   _setPage(pageIndex);
      // }),
    ];
    print("page index is $_pageIndex widget is ${widget.getPageIndex}");
    // Future.delayed(Duration.zero, () {
    if (widget.getPageIndex != null && widget.getPageIndex > 0) {
      _pageIndex = widget.getPageIndex;
      _pageController = PageController(initialPage: _pageIndex);
      isSelected = _pageIndex;
      //_setPage(_pageIndex);
    } else {
      _pageController = PageController(initialPage: 0);
    }
    // });

    NetworkInfo.checkConnectivity(_scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    // _setPage(_pageIndex);
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        // bottomNavigationBar:
        backgroundColor:
            Color(int.parse("#F5F5F5".substring(1, 7), radix: 16) + 0xFF000000),
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
        //     Container(
        //   decoration: BoxDecoration(
        //       color: Color(
        //           int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),
        //       border: Border.all(
        //           color: Color(int.parse("#00A4A4".substring(1, 7), radix: 16) +
        //               0xFF000000),
        //           width: 1),
        //       borderRadius: BorderRadius.all(Radius.circular(16))),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: BottomNavigationBar(
        //       backgroundColor: Color(
        //           int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),
        //       selectedItemColor: Colors.white,
        //       unselectedItemColor: ColorResources.COLOR_GREY,
        //       showUnselectedLabels: true,
        //       currentIndex: _pageIndex,
        //       type: BottomNavigationBarType.fixed,
        //       items: [
        //         _barItem(
        //             Icons.home_outlined, getTranslated('home', context), 0),
        //         _barItem(Icons.shopping_cart_outlined,
        //             getTranslated('cart', context), 1),
        //         // _barItem(Icons.shopping_bag, getTranslated('order', context), 2),
        //         _barItem(Icons.favorite_border_outlined,
        //             getTranslated('favourite', context), 2),
        //         _barItem(
        //             Icons.search_outlined, getTranslated('menu', context), 3)
        //       ],
        //       onTap: (int index) {
        //         _setPage(index);
        //       },
        //     ),
        //   ),
        // ),
        appBar: Provider.of<SplashProvider>(context, listen: false)
                .isRestaurantClosed()
            ? AppBar(
                toolbarHeight: 40,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 1,
                automaticallyImplyLeading: false,
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: Image.asset(Images.closed, width: 25, height: 25)),
                  Text(
                    '${getTranslated('restaurant_is_close_now', context)} '
                    '${DateConverter.convertTimeToTime('${Provider.of<SplashProvider>(context, listen: false).configModel.restaurantOpenTime}:00')}',
                    style: rubikRegular.copyWith(
                        fontSize: 12, color: Colors.black),
                  ),
                ]),
              )
            : null,
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  Widget tabItem(var pos, {var icon, var name, dynamic onTapEvent}) {
    return GestureDetector(
      onTap: () {
        _setPage(pos);
        setState(() {
          _pageIndex = pos;
        });
        BlocProvider.of<NavigationBloc>(context).add(onTapEvent);
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: _pageIndex == pos ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  // BottomNavigationBarItem _barItem(IconData icon, String label, int index) {
  //   return BottomNavigationBarItem(
  //     icon: Stack(
  //       clipBehavior: Clip.none,
  //       children: [
  //         Icon(icon,
  //             color: index == _pageIndex
  //                 ? Colors.white
  //                 : ColorResources.COLOR_GREY,
  //             size: 25),
  //         index == 1
  //             ? Positioned(
  //                 top: -7,
  //                 right: -7,
  //                 child: Container(
  //                   padding: EdgeInsets.all(4),
  //                   alignment: Alignment.center,
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     color: Color(
  //                         int.parse("#00A4A4".substring(1, 7), radix: 16) +
  //                             0xFF000000),
  //                   ),
  //                   child: Text(
  //                     Provider.of<CartProvider>(context)
  //                         .cartList
  //                         .length
  //                         .toString(),
  //                     style: rubikMedium.copyWith(
  //                         color: ColorResources.COLOR_WHITE, fontSize: 8),
  //                   ),
  //                 ),
  //               )
  //             : SizedBox(),
  //       ],
  //     ),
  //     label: "",
  //   );
  // }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
