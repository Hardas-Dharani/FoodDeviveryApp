import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restaurant/helper/network_info.dart';
import 'package:flutter_restaurant/navigation_bloc/navigation_bloc.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget with NavigationStates {
  const PaymentPage({Key key, this.isMenuTapped}) : super(key: key);
  final Function isMenuTapped;
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  @override
  void initState() {
    super.initState();

    NetworkInfo.checkConnectivity(_scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final ScrollController _scrollController = ScrollController();
    return WillPopScope(
      onWillPop: () {
        BlocProvider.of<NavigationBloc>(context)
            .add(NavigationEvents.HomePageClickedEvent);
      },
      child: Scaffold(
        body: SafeArea(
            child: CustomScrollView(controller: _scrollController, slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.16,
            floating: false,
            stretch: true,
            elevation: 0,
            pinned: false,
            stretchTriggerOffset: 150.0,
            titleSpacing: 0,
            leading: Container(),
            backgroundColor: Color(
                int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [
                StretchMode.zoomBackground,
              ],
              background: Container(
                color: ColorResources.COLOR_WHITE,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(
                                top: (MediaQuery.of(context).size.height *
                                    0.025)),
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onTap: () {
                                    BlocProvider.of<NavigationBloc>(context)
                                        .add(NavigationEvents
                                            .HomePageClickedEvent);
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Payment Screen",
                                  style: rubikBold.copyWith(
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_LARGE,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(
                              top: (MediaQuery.of(context).size.height * 0.01)),
                          child: IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _isLoggedIn
                ? Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .32,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * .30,
                              width: MediaQuery.of(context).size.width * .6,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * .25,
                            width: MediaQuery.of(context).size.width * .6,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Add a new Card",
                              style: rubikMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Card Number",
                                  style: rubikBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 2, right: 8.0, bottom: 2),
                            child: TextField(
                              controller: _cardNumberController,
                              style: rubikRegular,
                              decoration: InputDecoration(
                                hintText: "Card Number",
                                hintStyle: rubikRegular.copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                                isDense: true,
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Expiry Date",
                                  style: rubikBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 2, right: 8.0, bottom: 2),
                            child: TextField(
                              controller: _expiryController,
                              style: rubikRegular,
                              decoration: InputDecoration(
                                hintText: "Expiry Date",
                                hintStyle: rubikRegular.copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                                isDense: true,
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Card Holders Name",
                                  style: rubikBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 2, right: 8.0, bottom: 2),
                            child: TextField(
                              controller: _holderNameController,
                              style: rubikRegular,
                              decoration: InputDecoration(
                                hintText: "Card Holders Name",
                                hintStyle: rubikRegular.copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                                isDense: true,
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "CVV",
                                  style: rubikBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 2, right: 8.0, bottom: 2),
                            child: TextField(
                              controller: _cvvController,
                              style: rubikRegular,
                              decoration: InputDecoration(
                                hintText: "CVV",
                                hintStyle: rubikRegular.copyWith(
                                    color:
                                        ColorResources.getHintColor(context)),
                                isDense: true,
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ])
                : NotLoggedInScreen(),
          )
        ])),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(5),
           height: MediaQuery.of(context).size.height * .06,
          decoration: BoxDecoration(
            color: Color(
                int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "Make Payment",
              style: rubikBold.copyWith(
                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
