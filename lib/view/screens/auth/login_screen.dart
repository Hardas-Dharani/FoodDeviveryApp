import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/auth/signup_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/Menu_dash_board_layout.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter_restaurant/view/screens/language/choose_language_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _emailNumberFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserNumber() ?? '';
    _passwordController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserPassword() ??
            '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => Form(
          key: _formKeyLogin,
          child: Stack(
            children: [
              Container(
                child: Image.asset(
                  Images.food_plate,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                  matchTextDirection: true,
                ),
              ),
              Opacity(
                opacity: 0.8,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Color(int.parse("#00A4A4".substring(1, 7), radix: 16) +
                      0xFF000000),
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
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated('sign in', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(int.parse(
                                              "#FFFFFF".substring(1, 7),
                                              radix: 16) +
                                          0xFF000000),
                                    ),
                              ),
                              Text(
                                getTranslated(" to your account", context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: Color(int.parse(
                                              "#FFFFFF".substring(1, 7),
                                              radix: 16) +
                                          0xFF000000),
                                    ),
                              ),
                            ],
                          )),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            fillColor: Color(int.parse(
                                    "#FFFFFF".substring(1, 7),
                                    radix: 16) +
                                0xFF000000),
                            hintText: getTranslated('email', context),
                            isShowBorder: true,
                            focusNode: _emailNumberFocus,
                            nextFocus: _passwordFocus,
                            controller: _emailController,
                            inputType: TextInputType.emailAddress,
                          ),

                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: getTranslated("password", context),
                            fillColor: Color(int.parse(
                                    "#FFFFFF".substring(1, 7),
                                    radix: 16) +
                                0xFF000000),
                            isShowBorder: true,
                            isPassword: true,
                            isShowSuffixIcon: true,
                            focusNode: _passwordFocus,
                            controller: _passwordController,
                            inputAction: TextInputAction.done,
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ForgotPasswordScreen()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("Forgot password?", context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                            color: Color(int.parse(
                                                    "#FFFFFF".substring(1, 7),
                                                    radix: 16) +
                                                0xFF000000)),
                                  ),
                                ),
                              )
                            ],
                          ),

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
                              ? GestureDetector(
                                  child: Icon(Icons.arrow_forward_ios_rounded,
                                      color: Color(int.parse(
                                              "#FFFFFF".substring(1, 7),
                                              radix: 16) +
                                          0xFF000000),
                                      size: 40),
                                  onTap: () async {
                                    String _email =
                                        _emailController.text.trim();
                                    String _password =
                                        _passwordController.text.trim();
                                    if (_email.isEmpty) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_email_address', context),
                                          context);
                                    } else if (EmailChecker.isNotValid(
                                        _email)) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_valid_email', context),
                                          context);
                                    } else if (_password.isEmpty) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_password', context),
                                          context);
                                    } else if (_password.length < 6) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'password_should_be', context),
                                          context);
                                    } else {
                                      authProvider
                                          .login(_email, _password)
                                          .then((status) async {
                                        if (status.isSuccess) {
                                          if (authProvider.isActiveRememberMe) {
                                            authProvider
                                                .saveUserNumberAndPassword(
                                                    _email, _password);
                                          } else {
                                            authProvider
                                                .clearUserNumberAndPassword();
                                          }

                                          await Provider.of<WishListProvider>(
                                                  context,
                                                  listen: false)
                                              .initWishList(context);

                                          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                            Provider.of<AuthProvider>(context, listen: false).updateToken();
                                            await Provider.of<WishListProvider>(context, listen: false)
                                                .initWishList(context);
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ChooseLanguageScreen()),
                                                    (route) => false);
                                          }
                                          // Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
                                          // Provider.of<AuthProvider>(context, listen: false).updateToken();
                                          // Navigator.pushAndRemoveUntil(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (_) =>
                                          //             ChooseLanguageScreen()),
                                          //     (route) => false);
                                        }
                                      });
                                    }
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      ColorResources.COLOR_PRIMARY),
                                )),

                          // for create an account
                          SizedBox(height: 30),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => SignUpScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated("New User?", context),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.normal,
                                        color: Color(int.parse(
                                                "#FFFFFF".substring(1, 7),
                                                radix: 16) +
                                            0xFF000000),
                                      ),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                Text(
                                  getTranslated('signup', context),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.bold,
                                        color: Color(int.parse(
                                                "#FFFFFF".substring(1, 7),
                                                radix: 16) +
                                            0xFF000000),
                                      ),
                                ),
                              ],
                            ),
                          ),
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
