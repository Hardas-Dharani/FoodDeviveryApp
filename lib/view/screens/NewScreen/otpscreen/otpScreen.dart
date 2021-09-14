import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/auth/signup_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/Menu_dash_board_layout.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter_restaurant/view/screens/language/choose_language_screen.dart';
import 'package:provider/provider.dart';

import 'package:pinput/pin_put/pin_put.dart';

class OtpScreen extends StatefulWidget {
  @override
  _NumberScreenState createState() => _NumberScreenState();
}

class _NumberScreenState extends State<OtpScreen> {
  FocusNode __numberFocus = FocusNode();
  TextEditingController _numberController;
  GlobalKey<FormState> _formKeyLogin;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _numberController = TextEditingController();

    _numberController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserNumber() ?? '';
  }

  @override
  void dispose() {
    _numberController.dispose();

    super.dispose();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => Form(
          key: _formKeyLogin,
          child: Stack(
            children: [
              // Container(
              //   child: Image.asset(
              //     Images.food_plate,
              //     height: MediaQuery.of(context).size.height,
              //     fit: BoxFit.cover,
              //     matchTextDirection: true,
              //   ),
              // ),
              Opacity(
                opacity: 0.8,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  // color: Color(int.parse("#00A4A4".substring(1, 7), radix: 16) +
                  //     0xFF000000),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.PADDING_SIZE_LARGE,
                        top: Dimensions.PADDING_SIZE_LARGE,
                        right: Dimensions.PADDING_SIZE_LARGE),
                    child: Container(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          //SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              Images.tazaj_english,
                              height: MediaQuery.of(context).size.height / 4.5,
                              fit: BoxFit.scaleDown,
                              matchTextDirection: true,
                            ),
                          ),
                          //SizedBox(height: 20),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 130.0, bottom: 20),
                            child: Text(
                              "60",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                          Text(
                            "Enter the SMS code that’s sent to your mobile number:",
                            style:
                                Theme.of(context).textTheme.headline3.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 100.0, top: 40),
                            child: Text(
                              "+966 50 123 4567",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.all(20.0),
                            padding: const EdgeInsets.all(20.0),
                            child: PinPut(
                              fieldsCount: 4,
                              // onSubmit: (String pin) =>
                              //     _showSnackBar(pin, context),
                              focusNode: _pinPutFocusNode,
                              controller: _pinPutController,
                              submittedFieldDecoration:
                                  _pinPutDecoration.copyWith(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              selectedFieldDecoration: _pinPutDecoration,
                              followingFieldDecoration:
                                  _pinPutDecoration.copyWith(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  color:
                                      Colors.deepPurpleAccent.withOpacity(.5),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          Row(
                            children: [
                              authProvider.loginErrorMessage.length > 0
                                  ? CircleAvatar(
                                      backgroundColor:
                                          ColorResources.getPrimaryColor(
                                              context),
                                      radius: 5)
                                  : SizedBox.shrink(),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.loginErrorMessage ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                        color: Color(int.parse(
                                                "#FFFFFF".substring(1, 7),
                                                radix: 16) +
                                            0xFF000000),
                                      ),
                                ),
                              )
                            ],
                          ),

                          // for remember me section

                          SizedBox(height: 22),
                          // Row(
                          //   children: [
                          //     authProvider.loginErrorMessage.length > 0
                          //         ? CircleAvatar(
                          //             backgroundColor:
                          //                 ColorResources.getPrimaryColor(
                          //                     context),
                          //             radius: 5)
                          //         : SizedBox.shrink(),
                          //     SizedBox(width: 8),
                          //     Expanded(
                          //       child: Text(
                          //         authProvider.loginErrorMessage ?? "",
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .headline2
                          //             .copyWith(
                          //               fontSize: Dimensions.FONT_SIZE_SMALL,
                          //               color: Color(int.parse(
                          //                       "#FFFFFF".substring(1, 7),
                          //                       radix: 16) +
                          //                   0xFF000000),
                          //             ),
                          //       ),
                          //     )
                          //   ],
                          // ),

                          // for login button
                          SizedBox(height: 10),
                          !authProvider.isLoading
                              ? CustomButton(
                                  btnTxt: "Verfiy",
                                  onTap: () {},
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      ColorResources.COLOR_PRIMARY),
                                )),

                          // for create an account
                          SizedBox(height: 30),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.of(context).push(MaterialPageRoute(
                          //         builder: (_) => NumberSignupScreen()));
                          //   },
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          //       Text(
                          //         "Create new account",
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .headline3
                          //             .copyWith(
                          //               fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          //               fontWeight: FontWeight.bold,
                          //               color: Color(0xFF00A4A4),
                          //             ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
