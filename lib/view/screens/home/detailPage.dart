import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/network_info.dart';
import 'package:flutter_restaurant/navigation_bloc/navigation_bloc.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/search/search_screen.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget with NavigationStates {
  final Product product;
  const DetailPage({
    Key key,
    this.isMenuTapped,
    @required this.product,
  }) : super(key: key);
  final Function isMenuTapped;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  var _isDarkMode;

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(0);
    print("dsd");
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
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
              backgroundColor:
                  _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
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
                          color: Color(
                              int.parse("#00A4A4".substring(1, 7), radix: 16) +
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
                                        locationProvider.addressList != null &&
                                                locationProvider
                                                    .addressList.isNotEmpty
                                            ? Text(
                                                '${locationProvider.addressList[0].streetAddress ?? ''} ',
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(0xffffffff),
                                                    fontWeight: FontWeight.w800,
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
                                                    fontWeight: FontWeight.w800,
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
                            /*Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchScreen()));*/
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .67,
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
                                          child: Icon(
                                            Icons.search,
                                            size: 25,
                                            color: Colors.grey,
                                          )),
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

  @override
  void initState() {
    super.initState();
    NetworkInfo.checkConnectivity(_scaffoldKey);
  }
}
