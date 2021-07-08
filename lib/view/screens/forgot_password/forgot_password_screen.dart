import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/verification_screen.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();

    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return Stack(children: [
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
                color: Color(int.parse("#00A4A4".substring(1, 7), radix: 16) +
                    0xFF000000),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: Dimensions.PADDING_SIZE_LARGE,
                      top: Dimensions.PADDING_SIZE_LARGE,
                      right: Dimensions.PADDING_SIZE_LARGE),
                  child: Container(
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              child: Icon(
                                Icons.arrow_back_sharp,
                                color: Colors.white,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
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
                                getTranslated("forgot", context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                              ),
                              Text(
                                getTranslated("password?",context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        Padding(
                          padding: const EdgeInsets.all(
                              Dimensions.PADDING_SIZE_LARGE),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              CustomTextField(
                                hintText: getTranslated("email",context),
                                isShowBorder: true,
                                controller: _emailController,
                                inputType: TextInputType.emailAddress,
                                inputAction: TextInputAction.done,
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      getTranslated("forgotlink",context),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              !auth.isForgotPasswordLoading
                                  ? Center(
                                      child: GestureDetector(
                                        child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white,
                                            size: 40),
                                        onTap: () {
                                          if (_emailController.text.isEmpty) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'enter_email_address',
                                                    context),
                                                context);
                                          } else if (!_emailController.text
                                              .contains('@')) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'enter_valid_email',
                                                    context),
                                                context);
                                          } else {
                                            Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .forgetPassword(
                                                    _emailController.text)
                                                .then((value) {
                                              if (value.isSuccess) {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            VerificationScreen(
                                                                emailAddress:
                                                                    _emailController
                                                                        .text)));
                                              } else {
                                                showCustomSnackBar(
                                                    value.message, context);
                                              }
                                            });
                                          }
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              ColorResources.COLOR_PRIMARY))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]);
        },
      ),
    );
  }
}
