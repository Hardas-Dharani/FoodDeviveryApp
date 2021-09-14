import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/map_widget.dart';
import 'package:flutter_restaurant/view/screens/checkout/payment_screen.dart';
import 'package:flutter_restaurant/view/screens/order/widget/change_method_dialog.dart';
import 'package:flutter_restaurant/view/screens/order/widget/order_cancel_dialog.dart';
import 'package:flutter_restaurant/view/screens/rare_review/rate_review_screen.dart';
import 'package:flutter_restaurant/view/screens/track/order_tracking_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel orderModel;
  final int orderId;
  OrderDetailsScreen({@required this.orderModel, @required this.orderId});

  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();
  String branchname = '';
  void _loadData(BuildContext context) async {
    await Provider.of<OrderProvider>(context, listen: false)
        .trackOrder(orderId.toString(), orderModel, context, false);
    if (orderModel == null) {
      await Provider.of<SplashProvider>(context, listen: false)
          .initConfig(_scaffold);
    }
    await Provider.of<LocationProvider>(context, listen: false)
        .initAddressList(context);
    Provider.of<OrderProvider>(context, listen: false)
        .getOrderDetails(orderId.toString(), context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branchname = prefs.getString("branchname");
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context);

    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(right: 80),
          child: Container(
            // height: 20,
            alignment: Alignment.topCenter,
            child: Image.asset(
              Images.tazaj_english,
              height: MediaQuery.of(context).size.height / 8.5,
              fit: BoxFit.scaleDown,
              matchTextDirection: true,
            ),
          ),
        ),
      ),
      // CustomAppBar(title: getTranslated('order_details', context)),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          double deliveryCharge = 0;
          double _itemsPrice = 0;
          String paymentstatus = "";
          double _discount = 0;
          double _tax = 0;
          double _addOns = 0;
          double _addOns1 = 0;
          double _addOns2 = 0;
          if (order.orderDetails != null) {
            if (order.trackModel.orderType == 'delivery') {
              deliveryCharge = order.trackModel.deliveryCharge;
            } else if (order.trackModel.deliveryCharge != null ||
                order.trackModel.deliveryCharge != 0) {
              deliveryCharge = order.trackModel.deliveryCharge;
            }
            if (order.trackModel.paymentMethod == "online") {
              paymentstatus = "paid";
            } else {
              paymentstatus = order.trackModel.paymentStatus;
            }
            for (OrderDetailsModel orderDetails in order.orderDetails) {
              int _index = 0;
              int _index1 = 0;
              int _index2 = 0;
              for (AddOns addOn in orderDetails.productDetails.addOns) {
                for (var item = 0;
                    item < orderDetails.addOnIds.length;
                    item++) {
                  if (orderDetails.addOnIds[item] == addOn.id) {
                    _addOns =
                        _addOns + (addOn.price * orderDetails.addOnQtys[item]);
                    _index++;
                  }
                }
              }
              for (AddOns addOn1 in orderDetails.productDetails.addOns1) {
                for (var item = 0;
                    item < orderDetails.addOnIds.length;
                    item++) {
                  if (orderDetails.addOnIds[item] == addOn1.id) {
                    _addOns1 = _addOns1 +
                        (addOn1.price * orderDetails.addOnQtys[item]);
                    _index1++;
                  }
                }
              }
              for (AddOns addOn2 in orderDetails.productDetails.addOns2) {
                for (var item = 0;
                    item < orderDetails.addOnIds.length;
                    item++) {
                  if (orderDetails.addOnIds[item] == addOn2.id) {
                    _addOns2 = _addOns2 +
                        (addOn2.price * orderDetails.addOnQtys[item]);
                    _index2++;
                  }
                }
              }
              _itemsPrice =
                  _itemsPrice + (orderDetails.price * orderDetails.quantity);
              _discount = _discount +
                  (orderDetails.discountOnProduct * orderDetails.quantity);
              _tax = _tax + (orderDetails.taxAmount * orderDetails.quantity);
            }
          }
          double _subTotal = _itemsPrice + _tax + _addOns + _addOns2 + _addOns1;
          double _total = _itemsPrice +
              _addOns -
              _discount +
              _addOns1 +
              _addOns2 +
              _tax +
              deliveryCharge -
              (order.trackModel != null
                  ? order.trackModel.couponDiscountAmount
                  : 0);

          return order.orderDetails != null
              ? Column(
                  children: [
                    Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        children: [
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Text(getTranslated('order_details', context),
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFEF8D30),
                              )),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Row(children: [
                            Text('${getTranslated('order_id', context)}:',
                                style: rubikRegular),
                            SizedBox(
                                width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            SizedBox(
                                width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Expanded(child: SizedBox()),
                            Icon(Icons.watch_later, size: 17),
                            SizedBox(
                                width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Text(
                                DateConverter.isoStringToLocalDateOnly(
                                    order.trackModel.createdAt),
                                style: rubikRegular),
                          ]),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Row(
                            children: [
                              Text(order.trackModel.id.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFEF8D30),
                                  )),
                              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                              Icon(Icons.copy,
                                  color: Color(0xFFEF8D30), size: 17),
                              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                              Icon(Icons.info,
                                  color: Color(0xFFEF8D30), size: 17),
                            ],
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Row(children: [
                            Text('Branch:', style: rubikRegular),
                          ]),
                          Text(branchname.toString(),
                              style: rubikMedium.copyWith(
                                  color: Color(0xFF00A4A4))),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Row(children: [
                            Text('Order type:', style: rubikRegular),
                          ]),
                          Text(order.orderType.toString(),
                              style: rubikMedium.copyWith(
                                  color: Color(0xFFEF8D30))),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Row(children: [
                            Text('${getTranslated('item', context)}:',
                                style: rubikRegular),
                            SizedBox(
                                width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Text(order.orderDetails.length.toString(),
                                style: rubikMedium.copyWith(
                                    color: Theme.of(context).primaryColor)),
                            Expanded(child: SizedBox()),
                            order.orderType == 'delivery'
                                ? TextButton.icon(
                                    onPressed: () {
                                      AddressModel _address;
                                      for (AddressModel address
                                          in Provider.of<LocationProvider>(
                                                  context,
                                                  listen: false)
                                              .addressList) { 
                                        if (address.id ==
                                            order
                                                .trackModel.deliveryAddressId) {
                                          _address = address;
                                          break;
                                        }
                                      }
                                      if (_address != null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => MapWidget(
                                                    address: _address)));
                                      }
                                    },
                                    icon: Icon(Icons.map, size: 18),
                                    label: Text(
                                        getTranslated(
                                            'delivery_address', context),
                                        style: rubikMedium.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL)),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: BorderSide(width: 1)),
                                        padding: EdgeInsets.all(Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                        minimumSize: Size(1, 30)),
                                  )
                                : Text(getTranslated('take_away', context),
                                    style: rubikMedium),
                          ]),
                          Divider(height: 20),

                          // Payment info
                          Align(
                            alignment: Alignment.center,
                            child: Text(getTranslated('payment_info', context),
                                style: rubikMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ),
                          SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                                flex: 2,
                                child: Text(getTranslated('status', context),
                                    style: rubikRegular)),
                            Expanded(
                                flex: 8,
                                child: Text(
                                  '${paymentstatus.toUpperCase()}',
                                  // ${paymentstatus.substring(1).replaceAll('_', ' ')}',
                                  style: rubikMedium.copyWith(
                                      color: Theme.of(context).primaryColor),
                                )),
                          ]),
                          SizedBox(height: 5),
                          Row(children: [
                            Expanded(
                                flex: 2,
                                child: Text(getTranslated('method', context),
                                    style: rubikRegular)),
                            Expanded(
                                flex: 8,
                                child: Row(children: [
                                  Text(
                                    (order.trackModel.paymentMethod != null &&
                                            order.trackModel.paymentMethod
                                                    .length >
                                                0)
                                        ? '${order.trackModel.paymentMethod[0].toUpperCase()}${order.trackModel.paymentMethod.substring(1).replaceAll('_', ' ')}'
                                        : 'Digital Payment',
                                    style: rubikMedium.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  (paymentstatus != 'paid' &&
                                          order.trackModel.paymentMethod !=
                                              'cash_on_delivery' &&
                                          order.trackModel.orderStatus !=
                                              'delivered')
                                      ? InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    ChangeMethodDialog(
                                                        orderID: order
                                                            .trackModel.id
                                                            .toString(),
                                                        callback: (String
                                                                message,
                                                            bool isSuccess) {
                                                          _scaffold.currentState
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      message),
                                                                  backgroundColor: isSuccess
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .red));
                                                        }));
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_SMALL,
                                                vertical: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL,
                                                vertical: 2),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.5)),
                                            child: Text(
                                                getTranslated(
                                                    'change', context),
                                                style: rubikRegular.copyWith(
                                                    fontSize: 10,
                                                    color: Colors.black)),
                                          ),
                                        )
                                      : SizedBox(),
                                ])),
                          ]),
                          Divider(height: 40),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: order.orderDetails.length,
                            itemBuilder: (context, index) {
                              List<AddOns> _addOns = [];
                              List<AddOns> _addOns1 = [];
                              List<AddOns> _addOns2 = [];

                              order.orderDetails[index].productDetails.addOns
                                  .forEach((addOn) {
                                for (var i = 0;
                                    i <
                                        order.orderDetails[index].addOnIds
                                            .length;
                                    i++) {
                                  if (order.orderDetails[index].addOnIds[i] ==
                                      addOn.id) {
                                    _addOns.add(addOn);
                                  }
                                }
                              });
                              order.orderDetails[index].productDetails.addOns1
                                  .forEach((addOn) {
                                for (var i = 0;
                                    i <
                                        order.orderDetails[index].addOnIds
                                            .length;
                                    i++) {
                                  if (order.orderDetails[index].addOnIds[i] ==
                                      addOn.id) {
                                    _addOns1.add(addOn);
                                  }
                                }
                              });
                              order.orderDetails[index].productDetails.addOns2
                                  .forEach((addOn) {
                                for (var i = 0;
                                    i <
                                        order.orderDetails[index].addOnIds
                                            .length;
                                    i++) {
                                  if (order.orderDetails[index].addOnIds[i] ==
                                      addOn.id) {
                                    _addOns2.add(addOn);
                                  }
                                }
                              });
                              print(_addOns2);
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder_image,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/'
                                              '${order.orderDetails[index].productDetails.image}',
                                          height: 70,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                          width: Dimensions.PADDING_SIZE_SMALL),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      order.orderDetails[index]
                                                          .productDetails.name,
                                                      style: rubikMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                      '${getTranslated('quantity', context)}:',
                                                      style: rubikRegular),
                                                  Text(
                                                      order.orderDetails[index]
                                                          .quantity
                                                          .toString(),
                                                      style: rubikMedium.copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor)),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              Row(children: [
                                                Text(
                                                  PriceConverter.convertPrice(
                                                      context,
                                                      order.orderDetails[index]
                                                              .price -
                                                          order
                                                              .orderDetails[
                                                                  index]
                                                              .discountOnProduct),
                                                  style: rubikBold,
                                                ),
                                                SizedBox(width: 5),
                                                order.orderDetails[index]
                                                            .discountOnProduct >
                                                        0
                                                    ? Expanded(
                                                        child: Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                context,
                                                                order
                                                                    .orderDetails[
                                                                        index]
                                                                    .price),
                                                        style:
                                                            rubikBold.copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
                                                          color: ColorResources
                                                              .COLOR_GREY,
                                                        ),
                                                      ))
                                                    : SizedBox(),
                                              ]),
                                              SizedBox(
                                                  height: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              Row(children: [
                                                Container(
                                                    height: 10,
                                                    width: 10,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .color,
                                                    )),
                                                SizedBox(
                                                    width: Dimensions
                                                        .PADDING_SIZE_EXTRA_SMALL),
                                                Text(
                                                  '${getTranslated(order.trackModel.orderStatus == 'delivered' ? 'delivered_at' : 'ordered_at', context)} '
                                                  '${DateConverter.isoStringToLocalDateOnly(order.trackModel.orderStatus == 'delivered' ? order.orderDetails[index].updatedAt : order.orderDetails[index].createdAt)}',
                                                  style: rubikRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_SMALL),
                                                ),
                                              ]),
                                            ]),
                                      ),
                                    ]),
                                    _addOns.length > 0
                                        ? SizedBox(
                                            height: 30,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              padding: EdgeInsets.only(
                                                  top: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              itemCount: _addOns.length,
                                              itemBuilder: (context, i) {
                                                int _index = 0;
                                                for (var item = 0;
                                                    item <
                                                        order
                                                            .orderDetails[index]
                                                            .addOnQtys
                                                            .length;
                                                    item++) {
                                                  if (order.orderDetails[index]
                                                          .addOnIds[item] ==
                                                      _addOns[i].id) {
                                                    _index = item;
                                                  }
                                                }
                                                print(order.orderDetails[index]
                                                    .addOnQtys[_index]);
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      right: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  child: Row(children: [
                                                    Text(_addOns[i].name,
                                                        style: rubikRegular),
                                                    SizedBox(width: 2),
                                                    Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                context,
                                                                _addOns[i]
                                                                    .price),
                                                        style: rubikMedium),
                                                    SizedBox(width: 2),
                                                    Text(
                                                        '(${order.orderDetails[index].addOnQtys[_index]})',
                                                        style: rubikRegular),
                                                  ]),
                                                );
                                              },
                                            ),
                                          )
                                        : SizedBox(),
                                    Divider(height: 40),
                                    _addOns1.length > 0
                                        ? SizedBox(
                                            height: 30,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              padding: EdgeInsets.only(
                                                  top: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              itemCount: _addOns1.length,
                                              itemBuilder: (context, i) {
                                                int _index = 0;
                                                for (var item = 0;
                                                    item <
                                                        order
                                                            .orderDetails[index]
                                                            .addOnQtys
                                                            .length;
                                                    item++) {
                                                  if (order.orderDetails[index]
                                                          .addOnIds[item] ==
                                                      _addOns1[i].id) {
                                                    _index = item;
                                                  }
                                                  // _index++;

                                                }
                                                print(order.orderDetails[index]
                                                    .addOnQtys[_index]);
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      right: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  child: Row(children: [
                                                    Text(_addOns1[i].name,
                                                        style: rubikRegular),
                                                    SizedBox(width: 2),
                                                    Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                context,
                                                                _addOns1[i]
                                                                    .price),
                                                        style: rubikMedium),
                                                    SizedBox(width: 2),
                                                    Text(
                                                        '(${order.orderDetails[index].addOnQtys[_index]})',
                                                        style: rubikRegular),
                                                  ]),
                                                );
                                              },
                                            ),
                                          )
                                        : SizedBox(),
                                    Divider(height: 40),
                                    _addOns2.length > 0
                                        ? SizedBox(
                                            height: 30,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              padding: EdgeInsets.only(
                                                  top: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              itemCount: _addOns2.length,
                                              itemBuilder: (context, i) {
                                                int _index = 0;
                                                for (var item = 0;
                                                    item <
                                                        order
                                                            .orderDetails[index]
                                                            .addOnQtys
                                                            .length;
                                                    item++) {
                                                  if (order.orderDetails[index]
                                                          .addOnIds[item] ==
                                                      _addOns2[i].id) {
                                                    _index = item;
                                                  }
                                                }
                                                print(order.orderDetails[index]
                                                    .addOnQtys[_index]);
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      right: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  child: Row(children: [
                                                    Text(_addOns2[i].name,
                                                        style: rubikRegular),
                                                    SizedBox(width: 2),
                                                    Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                context,
                                                                _addOns2[i]
                                                                    .price),
                                                        style: rubikMedium),
                                                    SizedBox(width: 2),
                                                    Text(
                                                        '(${order.orderDetails[index].addOnQtys[_index]})',
                                                        style: rubikRegular),
                                                  ]),
                                                );
                                              },
                                            ),
                                          )
                                        : SizedBox(),
                                    Divider(height: 40),
                                  ]);
                            },
                          ),

                          // Total
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('items_price', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    PriceConverter.convertPrice(
                                        context, _itemsPrice),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),
                          SizedBox(height: 10),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('tax', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    '(+) ${PriceConverter.convertPrice(context, _tax)}',
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),
                          SizedBox(height: 10),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('addons', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    '(+) ${PriceConverter.convertPrice(context, _addOns + _addOns1 + _addOns2)}',
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: CustomDivider(),
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('subtotal', context),
                                    style: rubikMedium.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    PriceConverter.convertPrice(
                                        context, _subTotal),
                                    style: rubikMedium.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),
                          SizedBox(height: 10),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('discount', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    '(-) ${PriceConverter.convertPrice(context, _discount)}',
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),
                          SizedBox(height: 10),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('coupon_discount', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                  '(-) ${PriceConverter.convertPrice(context, order.trackModel.couponDiscountAmount)}',
                                  style: rubikRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE),
                                ),
                              ]),
                          SizedBox(height: 10),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('delivery_fee', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: CustomDivider(),
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('total_amount', context),
                                    style: rubikMedium.copyWith(
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_LARGE,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                Text(
                                  PriceConverter.convertPrice(context, _total),
                                  style: rubikMedium.copyWith(
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_LARGE,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ]),

                          (order.trackModel.orderNote != null &&
                                  order.trackModel.orderNote.isNotEmpty)
                              ? Container(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  margin: EdgeInsets.only(
                                      top: Dimensions.PADDING_SIZE_LARGE),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1,
                                        color: ColorResources.getGreyColor(
                                            context)),
                                  ),
                                  child: Text(order.trackModel.orderNote,
                                      style: rubikRegular.copyWith(
                                          color: ColorResources.getGreyColor(
                                              context))),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    !order.showCancelled
                        ? Row(children: [
                            order.trackModel.orderStatus == 'pending'
                                ? Expanded(
                                    child: Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        minimumSize: Size(1, 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                                width: 2,
                                                color: ColorResources
                                                    .DISABLE_COLOR)),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                OrderCancelDialog(
                                                  orderID: order.trackModel.id
                                                      .toString(),
                                                  callback: (String message,
                                                      bool isSuccess,
                                                      String orderID) {
                                                    if (isSuccess) {
                                                      _scaffold.currentState
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  '$message. Order ID: $orderID'),
                                                              backgroundColor:
                                                                  Colors
                                                                      .green));
                                                    } else {
                                                      _scaffold.currentState
                                                          .showSnackBar(SnackBar(
                                                              content:
                                                                  Text(message),
                                                              backgroundColor:
                                                                  Colors
                                                                      .green));
                                                    }
                                                  },
                                                ));
                                      },
                                      child: Text(
                                          getTranslated(
                                              'cancel_order', context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              .copyWith(
                                                color: ColorResources
                                                    .DISABLE_COLOR,
                                                fontSize:
                                                    Dimensions.FONT_SIZE_LARGE,
                                              )),
                                    ),
                                  ))
                                : SizedBox(),
                            (paymentstatus == 'unpaid' &&
                                    order.trackModel.paymentMethod !=
                                        'cash_on_delivery' &&
                                    order.trackModel.orderStatus != 'delivered')
                                ? Expanded(
                                    child: Container(
                                    height: 50,
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_SMALL),
                                    child: CustomButton(
                                      btnTxt: getTranslated('pay_now', context),
                                      onTap: () async {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => PaymentScreen(
                                                    orderModel:
                                                        order.trackModel,
                                                    fromCheckout: false)));
                                      },
                                    ),
                                  ))
                                : SizedBox(),
                          ])
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            margin:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                                getTranslated('order_cancelled', context),
                                style: rubikBold.copyWith(
                                    color: Theme.of(context).primaryColor)),
                          ),
                    (order.trackModel.orderStatus == 'confirmed' ||
                            order.trackModel.orderStatus == 'processing' ||
                            order.trackModel.orderStatus == 'out_for_delivery')
                        ? Padding(
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            child: CustomButton(
                              btnTxt: getTranslated('track_order', context),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => OrderTrackingScreen(
                                              orderID: order.trackModel.id
                                                  .toString(),
                                              addressID: order
                                                  .trackModel.deliveryAddressId,
                                            )));
                              },
                            ),
                          )
                        : SizedBox(),
                    order.trackModel.orderStatus == 'delivered'
                        ? Padding(
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            child: CustomButton(
                              btnTxt: getTranslated('review', context),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => RateReviewScreen(
                                          orderDetailsList: order.orderDetails,
                                          deliveryMan:
                                              order.trackModel.deliveryMan,
                                        )));
                              },
                            ),
                          )
                        : SizedBox(),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
