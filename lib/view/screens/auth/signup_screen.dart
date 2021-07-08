import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/auth/login_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/verification_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FocusNode _nameFocus = FocusNode();
    FocusNode _emailNumberFocus = FocusNode();
    FocusNode _numberFocus = FocusNode();
    FocusNode _passwordFocus = FocusNode();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _numberController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    Provider.of<AuthProvider>(context, listen: false)
        .clearVerificationMessage();

    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => Stack(children: [
          Container(
            child: Image.asset(
              "assets/image/food_plate.png",
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
              matchTextDirection: true,
            ),
          ),
          Opacity(
            opacity: 0.8,
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Color(
                  int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: Dimensions.PADDING_SIZE_LARGE,
                    top: Dimensions.PADDING_SIZE_LARGE,
                    right: Dimensions.PADDING_SIZE_LARGE),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        Images.tazaj_english,
                        height: MediaQuery.of(context).size.height / 4.5,
                        fit: BoxFit.scaleDown,
                        matchTextDirection: true,
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated("signup",context),
                            style:
                                Theme.of(context).textTheme.headline3.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(int.parse(
                                              "#FFFFFF".substring(1, 7),
                                              radix: 16) +
                                          0xFF000000),
                                    ),
                          ),
                          Text(
                            getTranslated("for_a_new_account",context),
                            style:
                                Theme.of(context).textTheme.headline3.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal,
                                      color: Color(int.parse(
                                              "#FFFFFF".substring(1, 7),
                                              radix: 16) +
                                          0xFF000000),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      hintText: getTranslated("name",context),
                      fillColor: Color(
                          int.parse("#FFFFFF".substring(1, 7), radix: 16) +
                              0xFF000000),
                      isShowBorder: true,
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.name,
                      focusNode: _nameFocus,
                      nextFocus: _emailNumberFocus,
                      controller: _nameController,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      hintText: getTranslated("email",context),
                      fillColor: Color(
                          int.parse("#FFFFFF".substring(1, 7), radix: 16) +
                              0xFF000000),
                      isShowBorder: true,
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.emailAddress,
                      focusNode: _emailNumberFocus,
                      nextFocus: _numberFocus,
                      controller: _emailController,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Stack(
                      children: [
                        TextField(
                          maxLines: 1,
                          controller: _numberController,
                          focusNode: _numberFocus,
                          style: Theme.of(context).textTheme.headline2.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              fontSize: Dimensions.FONT_SIZE_LARGE),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.phone,
                          cursorColor: ColorResources.COLOR_PRIMARY,
                          autofocus: false,
                          //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
                          ],
                          decoration: InputDecoration(
                            hintText: getTranslated("number",context),
                            fillColor: Color(int.parse(
                                    "#FFFFFF".substring(1, 7),
                                    radix: 16) +
                                0xFF000000),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.COLOR_GREY_CHATEAU),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(style: BorderStyle.none, width: 0),
                            ),
                            isDense: true,
                          ),
                          onSubmitted: (text) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 16),
                          child: Row(
                            children: [
                              Text("+966"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // CustomTextField(
                    //   hintText: "Number",
                    //   isShowBorder: true,
                    //   inputAction: TextInputAction.done,
                    //   inputType: TextInputType.emailAddress,
                    //   focusNode: _numberFocus,
                    //   nextFocus: _passwordFocus,
                    //   controller: _numberController,
                    //   isShowPrefixIcon: true,
                    // ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      fillColor: Color(
                          int.parse("#FFFFFF".substring(1, 7), radix: 16) +
                              0xFF000000),
                      hintText: getTranslated("password",context),
                      isShowBorder: true,
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.emailAddress,
                      focusNode: _passwordFocus,
                      controller: _passwordController,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        authProvider.verificationMessage.length > 0
                            ? CircleAvatar(
                                backgroundColor:
                                    ColorResources.getPrimaryColor(context),
                                radius: 5)
                            : SizedBox.shrink(),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authProvider.verificationMessage ?? "",
                            style:
                                Theme.of(context).textTheme.headline2.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.bold,
                                      color: Color(int.parse(
                                              "#FFFFFF".substring(1, 7),
                                              radix: 16) +
                                          0xFF000000),
                                    ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        authProvider.registrationErrorMessage.length > 0
                            ? CircleAvatar(
                                backgroundColor:
                                    ColorResources.getPrimaryColor(context),
                                radius: 5)
                            : SizedBox.shrink(),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authProvider.registrationErrorMessage ?? "",
                            style:
                                Theme.of(context).textTheme.headline2.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.bold,
                                      color: Color(int.parse(
                                              "#FFFFFF".substring(1, 7),
                                              radix: 16) +
                                          0xFF000000),
                                    ),
                          ),
                        )
                      ],
                    ),
                    // for continue button
                    SizedBox(height: 12),
                    !authProvider.isPhoneNumberVerificationButtonLoading
                        ? GestureDetector(
                            child: Icon(Icons.arrow_forward_ios_rounded,
                                color: Color(int.parse(
                                        "#FFFFFF".substring(1, 7),
                                        radix: 16) +
                                    0xFF000000),
                                size: 40),
                            onTap: () {
                              String _email = _emailController.text.trim();
                              String _firstName = _nameController.text.trim();
                              String _number = _numberController.text.trim();
                              String _password =
                                  _passwordController.text.trim();
                              if (_email.isEmpty) {
                                showCustomSnackBar(
                                    getTranslated(
                                        'enter_email_address', context),
                                    context);
                              } else if (EmailChecker.isNotValid(_email)) {
                                showCustomSnackBar(
                                    getTranslated('enter_valid_email', context),
                                    context);
                              } else if (_firstName.isEmpty) {
                                showCustomSnackBar(
                                    getTranslated('enter_first_name', context),
                                    context);
                              } else if (_number.isEmpty) {
                                showCustomSnackBar(
                                    getTranslated(
                                        'enter_phone_number', context),
                                    context);
                              } else if (_password.isEmpty) {
                                showCustomSnackBar(
                                    getTranslated('enter_password', context),
                                    context);
                              } else if (_password.length < 6) {
                                showCustomSnackBar(
                                    getTranslated(
                                        'password_should_be', context),
                                    context);
                              } else {
                                authProvider
                                    .checkEmail(_email)
                                    .then((value) async {
                                  if (value.isSuccess) {
                                    authProvider.updateEmail(_email);
                                    if (value.message == 'active') {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  VerificationScreen(
                                                      emailAddress: _email,
                                                      fromSignUp: true)));
                                    } else {
                                      SignUpModel signUpModel = SignUpModel(
                                        fName: _firstName,
                                        lName: ".",
                                        email: authProvider.email,
                                        password: _password,
                                        phone: _number,
                                      );
                                      authProvider
                                          .registration(signUpModel)
                                          .then((status) async {
                                        if (status.isSuccess) {
                                          await Provider.of<WishListProvider>(
                                                  context,
                                                  listen: false)
                                              .initWishList(context);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      DashboardScreen()),
                                              (route) => false);
                                        }
                                      });
                                    }
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
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getTranslated("have_an_account?",context),
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
                              getTranslated("sign in",context),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
