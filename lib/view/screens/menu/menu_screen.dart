
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/address/address_screen.dart';
import 'package:flutter_restaurant/view/screens/feedback/feedback.dart';
import 'package:flutter_restaurant/view/screens/language/choose_language_screen.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_restaurant/view/screens/notification/notification_screen.dart';
import 'package:flutter_restaurant/view/screens/order/order_screen.dart';
import 'package:flutter_restaurant/view/screens/profile/profile_screen.dart';
import 'package:flutter_restaurant/view/screens/static/static_menu_pages.dart';
import 'package:flutter_restaurant/view/screens/support/support_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MenuScreen extends StatefulWidget {
  final Function onTap;
  final Animation<Offset> slideAnimation;
  final Animation<double> menuAnimation;
  final int selectedIndex;
  final Function onMenuItemClicked;

  MenuScreen(
      {this.onTap,
      this.slideAnimation,
      this.menuAnimation,
      this.selectedIndex,
      this.onMenuItemClicked});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var _isDarkMode;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Scaffold(
      backgroundColor:_isDarkMode
          ?Color(0xff323232):Color(0xff00A4A4),
      /*backgroundColor:
          Color(int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),*/
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                //Container(
                //child:
                Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(children: [
                InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ProfileScreen())),
                  child: ClipOval(
                    child: _isLoggedIn
                        ? FadeInImage.assetNetwork(
                            placeholder: Images.placeholder_user,
                            image:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                                '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(Images.placeholder_user,
                            height: 50, width: 50, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 20),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  enabled: profileProvider.userInfoModel == null,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated("welcome_to_tazaj", context),
                          style: rubikRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        _isLoggedIn
                            ? profileProvider.userInfoModel != null
                                ? Text(
                                    '${profileProvider.userInfoModel.fName ?? ''}',
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        color: ColorResources.COLOR_WHITE),
                                  )
                                : Container(
                                    height: 15, width: 100, color: Colors.white)
                            : Text(
                                'Abdul Aziz',
                                style: TextStyle(
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                    color: Colors.white),
                              ),
                      ]),
                )
              ]),
            ),
            //),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            // ListView(
            //     padding: EdgeInsets.zero,
            //     physics: BouncingScrollPhysics(),
            //     children: [
            //       SwitchListTile(
            //         value: Provider.of<ThemeProvider>(context).darkTheme,
            //         onChanged: (bool isActive) =>
            //             Provider.of<ThemeProvider>(context, listen: false)
            //                 .toggleTheme(),
            //         title: Text(getTranslated('dark_theme', context),
            //             style: rubikMedium.copyWith(
            //                 fontSize: Dimensions.FONT_SIZE_LARGE)),
            //         activeColor: Theme.of(context).primaryColor,
            //       ),
            //       ListTile(
            //         onTap: () => onTap(2),
            //         leading: Image.asset(Images.order,
            //             width: 20,
            //             height: 20,
            //             color: Theme.of(context).textTheme.bodyText1.color),
            //         title: Text(getTranslated('my_order', context),
            //             style: rubikMedium.copyWith(
            //                 fontSize: Dimensions.FONT_SIZE_LARGE)),
            //       ),
            //       ListTile(
            //         onTap: () => Navigator.push(context,
            //             MaterialPageRoute(builder: (_) => ProfileScreen())),
            //         // leading: Image.asset(Images.profile,
            //         //     width: 20,
            //         //     height: 20,
            //         //     color: Theme.of(context).textTheme.bodyText1.color),
            //         title: Text(getTranslated('profile', context),
            //             style: rubikMedium.copyWith(
            //                 fontSize: Dimensions.FONT_SIZE_LARGE)),
            //       ),
            //       ListTile(
            //         onTap: () => Navigator.push(context,
            //             MaterialPageRoute(builder: (_) => AddressScreen())),
            //         leading: Image.asset(Images.location,
            //             width: 20,
            //             height: 20,
            //             color: Theme.of(context).textTheme.bodyText1.color),
            //         title: Text(getTranslated('address', context),
            //             style: rubikMedium.copyWith(
            //                 fontSize: Dimensions.FONT_SIZE_LARGE)),
            //       ),
            //       ListTile(
            //         onTap: () => Navigator.push(context,
            //             MaterialPageRoute(builder: (_) => ChatScreen())),
            //         leading: Image.asset(Images.message,
            //             width: 20,
            //             height: 20,
            //             color: Theme.of(context).textTheme.bodyText1.color),
            //         title: Text(getTranslated('message', context),
            //             style: rubikMedium.copyWith(
            //                 fontSize: Dimensions.FONT_SIZE_LARGE)),
            //       ),
            //       ListTile(
            //         onTap: () => Navigator.push(context,
            //             MaterialPageRoute(builder: (_) => CouponScreen())),
            //         leading: Image.asset(Images.coupon,
            //             width: 20,
            //             height: 20,
            //             color: Theme.of(context).textTheme.bodyText1.color),
            //         title: Text(getTranslated('coupon', context),
            //             style: rubikMedium.copyWith(
            //                 fontSize: Dimensions.FONT_SIZE_LARGE)),
            //       ),
            //       ListTile(
            //         onTap: () => Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (_) =>
            //                     ChooseLanguageScreen(fromMenu: true))),
            //         leading: Image.asset(Images.language,
            //             width: 20,
            //             height: 20,
            //             color: Theme.of(context).textTheme.bodyText1.color),
            //         title: Text(getTranslated('language', context),
            //             style: rubikMedium.copyWith(
            //                 fontSize: Dimensions.FONT_SIZE_LARGE)),
            //       ),
            //       ListTile(
            //         onTap: () => Navigator.push(context,
            //             MaterialPageRoute(builder: (_) => SupportScreen())),
            //         leading: Icon(Icons.contact_support,
            //             size: 20,
            //             color: Theme.of(context).textTheme.bodyText1.color),
            //         title: Text(getTranslated('help_and_support', context),
            //             style: rubikMedium.copyWith(
            //                 fontSize: Dimensions.FONT_SIZE_LARGE)),
            //       ),
            //       ListTile(
            //         onTap: () => Navigator.push(context,
            //             MaterialPageRoute(builder: (_) => TermsScreen())),
            //         leading: Icon(Icons.rule,
            //             size: 20,
            //             color: Theme.of(context).textTheme.bodyText1.color),
            //         title: Text(getTranslated('terms_and_condition', context),
            //             style: rubikMedium.copyWith(
            //                 fontSize: Dimensions.FONT_SIZE_LARGE)),
            //       ),
            //       ListTile(
            //         onTap: () {
            //           showDialog(
            //               context: context,
            //               builder: (context) => SignOutConfirmationDialog());
            //         },
            //         leading: Image.asset(Images.log_out,
            //             width: 20,
            //             height: 20,
            //             color: Theme.of(context).textTheme.bodyText1.color),
            //         title: Text(getTranslated('logout', context),
            //             style: rubikMedium.copyWith(
            //                 fontSize: Dimensions.FONT_SIZE_LARGE)),
            //       ),
            //     ]),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => OrderScreen(
                                        indexValue: 1,
                                      ))),
                          child: Text(
                            getTranslated("track_order", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => OrderScreen(
                                        indexValue: 2,
                                      ))),
                          child: Text(
                            getTranslated("order_his", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ChooseLanguageScreen(fromMenu: true))).then((value) {
                                   setState(() {

                                   });
                          }),
                          child: Text(
                            getTranslated("menu_language", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => AddressScreen())),
                          child: Text(
                            getTranslated("address", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => NotificationScreen())),
                          child: Text(
                            getTranslated("notification", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          // indent: 20,
                          endIndent: 250,
                          color: Colors.white,
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => FeedBackScreen()
                                ));
                          },
                          child: Text(
                            getTranslated("feedback", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => StaticPages(
                                          pageName: getTranslated("faq",context),
                                          pageType: 2,
                                        )));
                          },
                          child: Text(
                            getTranslated("faq", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 2
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => StaticPages(
                                        pageName: getTranslated("t&c",context),
                                        pageType: 0,
                                      ))),
                          child: Text(
                            getTranslated("t&c", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => StaticPages(
                                          pageName: getTranslated("nut",context),
                                          pageType: 1,
                                        )));
                          },
                          child: Text(
                            getTranslated("nut", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 2
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => StaticPages(
                                          pageName: getTranslated("about_us",context),
                                          pageType: 3,
                                        )));
                          },
                          child: Text(
                            getTranslated("about_us", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 2
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          // indent: 20,
                          endIndent: 250,
                          color: Colors.white,
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => SupportScreen())),
                          child: Text(
                            getTranslated("call_support", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 2
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    SignOutConfirmationDialog());
                          },
                          child: Text(
                            getTranslated("log_out", context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              fontWeight: widget.selectedIndex == 2
                                  ? FontWeight.bold
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          width: MediaQuery.of(context).size.width * .50,
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, bottom: 15.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: Text(
                                      getTranslated("dark_mode", context),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Switch.adaptive(
                                        value: Provider.of<ThemeProvider>(context)
                                            .darkTheme,
                                        onChanged: (bool isActive) =>
                                            Provider.of<ThemeProvider>(context,
                                                    listen: false)
                                                .toggleTheme(),
                                      )
                                    ])
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
