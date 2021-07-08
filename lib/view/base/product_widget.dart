import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../provider/wishlist_provider.dart';

class ProductWidget extends StatelessWidget {
  var _isDarkMode;
  final Product product;
  bool showbottomSheet = false;
  Product bottomSheetData;
  ProductWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double _startingPrice;
    double _endingPrice;
    if (product.choiceOptions.length != 0) {
      List<double> _priceList = [];
      product.variations
          .forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if (_priceList[0] < _priceList[_priceList.length - 1]) {
        _endingPrice = _priceList[_priceList.length - 1];
      }
    } else {
      _startingPrice = product.price;
    }

    double _discountedPrice = PriceConverter.convertWithDiscount(
        context, product.price, product.discount, product.discountType);

    DateTime _currentTime =
        Provider.of<SplashProvider>(context, listen: false).currentTime;
    DateTime _start = DateFormat('hh:mm:ss').parse(product.availableTimeStarts);
    DateTime _end = DateFormat('hh:mm:ss').parse(product.availableTimeEnds);
    DateTime _startTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _start.hour, _start.minute, _start.second);
    DateTime _endTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _end.hour, _end.minute, _end.second);
    if (_endTime.isBefore(_startTime)) {
      _endTime = _endTime.add(Duration(days: 1));
    }
    bool _isAvailable =
        _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);

    return InkWell(
      onTap: () {
        print("Rishav");
        showbottomSheet =
        true;
        bottomSheetData =product;
/*        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor:
          _isDarkMode?Colors.white:Colors.black,
          builder: (con) => CartBottomSheet(
            product: product,
            callback: (CartModel cartModel) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(getTranslated('added_to_cart', context)),
                  backgroundColor: Colors.green));
            },
          ),
        );*/
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // padding: EdgeInsets.symmetric(
          //     vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          //     horizontal: Dimensions.PADDING_SIZE_SMALL),
          // margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[
                    Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                blurRadius: 5,
                spreadRadius: 1,
              )
            ],
          ),
          child: Row(children: [
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder_image,
                  image:
                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}',
                  width: 94,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              _isAvailable
                  ? SizedBox()
                  : Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.6)),
                        child: Text(
                            getTranslated('not_available_now_break', context),
                            textAlign: TextAlign.center,
                            style: rubikRegular.copyWith(
                              color: Colors.white,
                              fontSize: 8,
                            )),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Container(
                  height: 30,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4))),
                  child: Center(
                    child: Consumer<WishListProvider>(
                        builder: (context, wishList, child) {
                      return InkWell(
                        onTap: () {
                          wishList.wishIdList.contains(product.id)
                              ? wishList.removeFromWishList(
                                  product, (message) {})
                              : wishList.addToWishList(product, (message) {});
                        },
                        child: Icon(
                          wishList.wishIdList.contains(product.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: wishList.wishIdList.contains(product.id)
                              ? Color(0xFFFC6A57)
                              : ColorResources.COLOR_GREY,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ]),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 5.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(product.name,
                                        textAlign: TextAlign.justify,
                                        style: rubikMedium,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: CircleAvatar(
                                  backgroundColor: Colors.black, radius: 3),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.275,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType, asFixed: 1)}'
                                      '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount, discountType: product.discountType, asFixed: 1)}' : ''}',
                                      style: rubikBold.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  product.price > _discountedPrice
                                      ? Flexible(
                                          child: Text(
                                              '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                                              '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                                              style: rubikRegular.copyWith(
                                                color:
                                                    ColorResources.COLOR_GREY,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: Dimensions
                                                    .FONT_SIZE_EXTRA_SMALL,
                                              )),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50.0),
                          child: Divider(
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * .5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  '${product.description}',
                                  style: TextStyle(color: Colors.grey),
                                  maxLines: 2,
                                  textAlign: TextAlign.justify,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            ),
            // Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            //   Icon(Icons.add),
            //   Expanded(child: SizedBox()),
            //   RatingBar(
            //       rating: product.rating.length > 0
            //           ? double.parse(product.rating[0].average)
            //           : 0.0,
            //       size: 10),
            // ]),
          ]),
        ),
      ),
    );
  }
}
