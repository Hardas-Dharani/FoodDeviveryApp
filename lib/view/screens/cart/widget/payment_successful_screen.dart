import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:provider/provider.dart';

class PaymentSuccessfulScreen extends StatefulWidget {
  final String razorPaymentId;

  const PaymentSuccessfulScreen({Key key, this.razorPaymentId});

  @override
  _PaymentSuccessfulScreenState createState() => _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: ColorResources.getPrimaryColor(context).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            color: ColorResources.getPrimaryColor(context),
            size: 80,
          ),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
        Text(
          getTranslated('order_placed_successfully', context),
          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('${getTranslated('order_id', context)}:',
              style:
                  rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text(widget.razorPaymentId,
              style:
                  rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
        ]),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: CustomButton(
              btnTxt: getTranslated('back_home', context),
              onTap: () {
                Navigator.of(context).pop();
              }),
        ),
      ]),
    );
  }

  @override
  void initState() {
    Provider.of<CartProvider>(context, listen: false)
        .clearCartList();
    super.initState();
  }
}
