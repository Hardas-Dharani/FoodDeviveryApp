import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomCheckBoxGroup.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/language_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/language_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
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
      backgroundColor: _isDarkMode ? Color(0xff323232) : Colors.white,
      /*backgroundColor:
          Color(int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),*/
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                              color: Color(0xff00A4A4),
                              fontWeight: FontWeight.bold),
                        ),
                        _isLoggedIn
                            ? profileProvider.userInfoModel != null
                                ? Text(
                                    '${profileProvider.userInfoModel.fName ?? ''}',
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        color: Color(0xff00A4A4)),
                                  )
                                : Container(
                                    height: 15,
                                    width: 100,
                                    color: Color(0xff00A4A4))
                            : Text(
                                'Abdul Aziz',
                                style: TextStyle(
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                    color: Color(0xff00A4A4)),
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
                              color: Color(0xff00A4A4),
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
                              color: Color(0xff00A4A4),
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
                                          ChooseLanguageScreen(fromMenu: true)))
                              .then((value) {
                            setState(() {});
                          }),
                          child: Text(
                            getTranslated("menu_language", context),
                            style: TextStyle(
                              color: Color(0xff00A4A4),
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
                                  builder: (_) => AddressScreen())),
                          child: Text(
                            getTranslated("address", context),
                            style: TextStyle(
                              color: Color(0xff00A4A4),
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
                              color: Color(0xff00A4A4),
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
                          color: Color(0xff00A4A4),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => FeedBackScreen()));
                          },
                          child: Text(
                            getTranslated("feedback", context),
                            style: TextStyle(
                              color: Color(0xff00A4A4),
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
                                          pageName:
                                              getTranslated("faq", context),
                                          pageType: 2,
                                        )));
                          },
                          child: Text(
                            getTranslated("faq", context),
                            style: TextStyle(
                              color: Color(0xff00A4A4),
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
                                        pageName: getTranslated("t&c", context),
                                        pageType: 0,
                                      ))),
                          child: Text(
                            getTranslated("t&c", context),
                            style: TextStyle(
                              color: Color(0xff00A4A4),
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
                                          pageName:
                                              getTranslated("nut", context),
                                          pageType: 1,
                                        )));
                          },
                          child: Text(
                            getTranslated("nut", context),
                            style: TextStyle(
                              color: Color(0xff00A4A4),
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
                                          pageName: getTranslated(
                                              "about_us", context),
                                          pageType: 3,
                                        )));
                          },
                          child: Text(
                            getTranslated("about_us", context),
                            style: TextStyle(
                              color: Color(0xff00A4A4),
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
                          color: Color(0xff00A4A4),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SupportScreen())),
                          child: Text(
                            "Call Us",
                            style: TextStyle(
                              color: Color(0xff00A4A4),
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
                          child: Row(
                            children: [
                              // Icon(Icons.logout, color: Color(0xff00A4A4)),
                              // SizedBox(width: 12),
                              Text(
                                getTranslated("log_out", context),
                                style: TextStyle(
                                  color: Color(0xff00A4A4),
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  fontWeight: widget.selectedIndex == 2
                                      ? FontWeight.bold
                                      : FontWeight.bold,
                                ),
                              ),
                            ],
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
                                          color: Color(0xff00A4A4),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Switch.adaptive(
                                        value:
                                            Provider.of<ThemeProvider>(context)
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
                        ),
                        Container(
                          child: CustomRadioButton(
                            elevation: 0,
                            absoluteZeroSpacing: true,
                            unSelectedColor: Colors.grey,
                            buttonLables: [
                              'English',
                              'Arabic',
                            ],
                            buttonValues: [
                              0,
                              1,
                            ],
                            buttonTextStyle: ButtonTextStyle(
                                selectedColor: Colors.white,
                                unSelectedColor: Colors.white,
                                textStyle: TextStyle(fontSize: 16)),
                            radioButtonValue: (value) {
                              if (value == 0) {
                                AppConstants.selectedLanguage = "English";
                              } else {
                                AppConstants.selectedLanguage = "Arabic";
                              }
                              print(value);
                            },
                            defaultSelected: 0,
                            selectedColor: Color(0xFFEF8D30),
                          ),
                        ),
                        // Container(
                        //   width: 80,
                        //   child: Consumer<LanguageProvider>(
                        //       builder: (context, languageProvider, child) =>
                        //           ListView.builder(
                        //               itemCount:
                        //                   languageProvider.languages.length,
                        //               // physics: BouncingScrollPhysics(),
                        //               shrinkWrap: true,
                        //               scrollDirection: Axis.horizontal,
                        //               itemBuilder: (context, index) {
                        //                 return InkWell(
                        //                   onTap: () {
                        //                     languageProvider
                        //                         .setSelectIndex(index);
                        //                     if (index == 0) {
                        //                       AppConstants.selectedLanguage =
                        //                           "English";
                        //                     } else {
                        //                       AppConstants.selectedLanguage =
                        //                           "Arabic";
                        //                     }
                        //                   },
                        //                   child: Container(
                        //                     // padding: EdgeInsets.symmetric(
                        //                     //     horizontal: 20),
                        //                     decoration: BoxDecoration(
                        //                       color: languageProvider
                        //                                   .selectIndex ==
                        //                               index
                        //                           ? ColorResources.COLOR_WHITE
                        //                               .withOpacity(.15)
                        //                           : null,
                        //                       border: Border(
                        //                           top: BorderSide(
                        //                               width: 1.0,
                        //                               color: languageProvider
                        //                                           .selectIndex ==
                        //                                       index
                        //                                   ? ColorResources
                        //                                       .COLOR_WHITE
                        //                                   : Colors.transparent),
                        //                           bottom: BorderSide(
                        //                               width: 1.0,
                        //                               color: languageProvider
                        //                                           .selectIndex ==
                        //                                       index
                        //                                   ? ColorResources
                        //                                       .COLOR_WHITE
                        //                                   : Colors
                        //                                       .transparent)),
                        //                     ),
                        //                     child: Container(
                        //                       padding: EdgeInsets.symmetric(
                        //                           vertical: 15),
                        //                       decoration: BoxDecoration(
                        //                         border: Border(
                        //                             bottom: BorderSide(
                        //                                 width: 1.0,
                        //                                 color: languageProvider
                        //                                             .selectIndex ==
                        //                                         index
                        //                                     ? Colors.transparent
                        //                                     : ColorResources
                        //                                         .COLOR_GREY_CHATEAU
                        //                                         .withOpacity(
                        //                                             .3))),
                        //                       ),
                        //                       child: Row(
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment
                        //                                 .spaceBetween,
                        //                         children: [
                        //                           Row(
                        //                             children: [
                        //                               // Image.asset(languageModel.imageUrl, width: 34, height: 34),
                        //                               // SizedBox(width: 30),
                        //                               Text(
                        //                                 languageProvider
                        //                                     .languages[index]
                        //                                     .languageName,
                        //                                 style: Theme.of(context)
                        //                                     .textTheme
                        //                                     .headline2
                        //                                     .copyWith(
                        //                                         color: Theme.of(
                        //                                                 context)
                        //                                             .textTheme
                        //                                             .bodyText1
                        //                                             .color),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                           languageProvider
                        //                                       .selectIndex ==
                        //                                   index
                        //                               ? Image.asset(
                        //                                   Images.done,
                        //                                   width: 17,
                        //                                   height: 17,
                        //                                 )
                        //                               : SizedBox.shrink()
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 );
                        //               })),
                        // ),
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
                  // Image.asset(languageModel.imageUrl, width: 34, height: 34),
                  // SizedBox(width: 30),
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
