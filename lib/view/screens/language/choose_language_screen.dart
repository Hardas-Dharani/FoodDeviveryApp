import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/language_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/language_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/auth/login_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/Menu_dash_board_layout.dart';
import 'package:flutter_restaurant/view/screens/feedback/feedback.dart';
import 'package:flutter_restaurant/view/screens/home_delivery_home_pickup/HomeDeliveryHomePickupScreen.dart';
import 'package:provider/provider.dart';

class ChooseLanguageScreen extends StatefulWidget {
  final bool fromMenu;

  ChooseLanguageScreen({this.fromMenu = false});

  @override
  _ChooseLanguageScreenState createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  bool loading;
  var _isDarkMode;

  @override
  void initState() {
    super.initState();
    loading = false;
    bool _firstTime = true;
    _loadDatatwo(context,false);
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? SizedBox()
            : _globalKey.currentState.hideCurrentSnackBar();
        _globalKey.currentState.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', _globalKey.currentContext)
                : getTranslated('connected', _globalKey.currentContext),
            textAlign: TextAlign.center,
          ),
        ));
      }
      _firstTime = false;

    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
  }

  Future<void> _loadDatatwo(BuildContext context, bool reload) async {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<ProfileProvider>(context, listen: false)
          .getUserInfo(context);
    }

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Timer(Duration(seconds: 1), () async {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => DashBoardLayOut()));
      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
        Provider.of<AuthProvider>(context, listen: false).updateToken();
        await Provider.of<WishListProvider>(context, listen: false)
            .initWishList(context);
        setState(() {
          loading = true;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DashBoardLayOut()));
      } else {
        setState(() {
          loading = true;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DashBoardLayOut()));
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => LoginScreen()));
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (BuildContext context) => ChooseLanguageScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Provider.of<LanguageProvider>(context, listen: false)
        .initializeAllLanguages(context);

    return Scaffold(
      backgroundColor:
          _isDarkMode ? Color(0xff000000) : ColorResources.COLOR_PRIMARY,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: Dimensions.PADDING_SIZE_LARGE,
                //       top: Dimensions.PADDING_SIZE_LARGE),
                //   child: Text(
                //     Strings.choose_the_language,
                //     style: Theme.of(context).textTheme.headline3.copyWith(
                //         fontSize: 22,
                //         color: Theme.of(context).textTheme.bodyText1.color),
                //   ),
                // ),
                // SizedBox(height: 30),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: Dimensions.PADDING_SIZE_LARGE,
                //       right: Dimensions.PADDING_SIZE_LARGE),
                //   child: SearchWidget(),
                // ),
                // SizedBox(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      Images.tazaj_english,
                      height: MediaQuery.of(context).size.height / 4.5,
                      fit: BoxFit.scaleDown,
                      matchTextDirection: true,
                    ),
                  ),
                ]),
                Consumer<LanguageProvider>(
                    builder: (context, languageProvider, child) =>
                        ListView.builder(
                            itemCount: languageProvider.languages.length,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => _languageWidget(
                                context: context,
                                languageModel:
                                    languageProvider.languages[index],
                                languageProvider: languageProvider,
                                index: index))),
                SizedBox(
                  height: 20,
                ),
                commonButton(
                  "Branch Pickup",
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => HomeDeliveyAndHomePickupScreen(
                                  label: "Branch Pickup",
                                )));
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                commonButton(
                  "Home Delivery",
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => HomeDeliveyAndHomePickupScreen(
                                  label: "Home Delivery",
                                )));
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                commonButton(
                  "You are Heard",
                  () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FeedBackScreen()));
                  },
                ),
              ],
            ),
            // Positioned(
            //   bottom: 20,
            //   left: 0,
            //   right: 0,
            //   child: Consumer<LanguageProvider>(
            //     builder: (context, languageProvider, child) => Padding(
            //       padding: const EdgeInsets.only(
            //           left: Dimensions.PADDING_SIZE_LARGE,
            //           right: Dimensions.PADDING_SIZE_LARGE,
            //           bottom: Dimensions.PADDING_SIZE_LARGE),
            //       child: loading == false
            //           ? Center(
            //               child: GestureDetector(
            //                 child: Icon(Icons.arrow_forward_ios_rounded,
            //                     color: Colors.white, size: 40),
            //                 onTap: () {
            //                   print("LanguageClick");
            //                   loading = true;
            //                   if (languageProvider.languages.length > 0 &&
            //                       languageProvider.selectIndex != -1) {
            //                     Provider.of<LocalizationProvider>(context,
            //                             listen: false)
            //                         .setLanguage(Locale(
            //                       AppConstants
            //                           .languages[languageProvider.selectIndex]
            //                           .languageCode,
            //                       AppConstants
            //                           .languages[languageProvider.selectIndex]
            //                           .countryCode,
            //                     ));
            //                     if (widget.fromMenu) {
            //                       print("PopExecuted");
            //                       /*Navigator.of(context).pushReplacement(MaterialPageRoute(
            //                           builder: (BuildContext context) => DashBoardLayOut()));*/
            //
            //                       Navigator.pushAndRemoveUntil<void>(
            //                         context,
            //                         MaterialPageRoute<void>(
            //                             builder: (BuildContext context) =>
            //                                 DashBoardLayOut()),
            //                         ModalRoute.withName('/'),
            //                       );
            //                       // Navigator.pop(context);
            //                     } else {
            //                       print("ElseRouteExecuted");
            //                       _route();
            //                     }
            //                   } else {
            //                     showCustomSnackBar(
            //                         getTranslated('select_a_language', context),
            //                         context);
            //                   }
            //                 },
            //               ),
            //             )
            //           : Center(
            //               child: CircularProgressIndicator(
            //                 valueColor: new AlwaysStoppedAnimation<Color>(
            //                     ColorResources.COLOR_WHITE),
            //               ),
            //             ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget commonButton(
    String label,
    VoidCallback voidCallback,
  ) {
    return Center(
      child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          onPressed: voidCallback,
          color:
              !_isDarkMode ? Color(0xff000000) : ColorResources.COLOR_PRIMARY,
          splashColor: Colors.grey.withOpacity(0.5),
          child: Text(
            label,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          )),
    );
  }

  Widget _languageWidget(
      {BuildContext context,
      LanguageModel languageModel,
      LanguageProvider languageProvider,
      int index}) {
    return InkWell(
      onTap: () {
        languageProvider.setSelectIndex(index);
        if (index == 0) {
          AppConstants.selectedLanguage = "English";
        } else {
          AppConstants.selectedLanguage = "Arabic";
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: languageProvider.selectIndex == index
              ? ColorResources.COLOR_WHITE.withOpacity(.15)
              : null,
          border: Border(
              top: BorderSide(
                  width: 1.0,
                  color: languageProvider.selectIndex == index
                      ? ColorResources.COLOR_WHITE
                      : Colors.transparent),
              bottom: BorderSide(
                  width: 1.0,
                  color: languageProvider.selectIndex == index
                      ? ColorResources.COLOR_WHITE
                      : Colors.transparent)),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1.0,
                    color: languageProvider.selectIndex == index
                        ? Colors.transparent
                        : ColorResources.COLOR_GREY_CHATEAU.withOpacity(.3))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(languageModel.imageUrl, width: 34, height: 34),
                  SizedBox(width: 30),
                  Text(
                    languageModel.languageName,
                    style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                ],
              ),
              languageProvider.selectIndex == index
                  ? Image.asset(
                      Images.done,
                      width: 17,
                      height: 17,
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
