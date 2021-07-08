import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartProductWidget extends StatefulWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;

  CartProductWidget(
      {@required this.cart,
      @required this.cartIndex,
      @required this.isAvailable,
      @required this.addOns});

  @override
  _CartProductWidgetState createState() => _CartProductWidgetState();
}

class _CartProductWidgetState extends State<CartProductWidget> {
  bool showbottomSheet = false;

  @override
  Widget build(BuildContext context) {
    print("value checck are = " + widget.addOns.toString());
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10)),
      child: Stack(children: [
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child:
              Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
        ),
        Container(
          //padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
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
          child: Column(
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholder_image,
                        image:
                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${widget.cart.product.image}',
                        height: 100,
                        width: 85,
                        fit: BoxFit.cover,
                      ),
                    ),
                    widget.isAvailable
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
                                  getTranslated(
                                      'not_available_now_break', context),
                                  textAlign: TextAlign.center,
                                  style: rubikRegular.copyWith(
                                    color: Colors.white,
                                    fontSize: 8,
                                  )),
                            ),
                          ),
                  ],
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .3,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(widget.cart.product.name,
                                      style: rubikBold,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            /*addOns.length > 0
                                ? SizedBox(
                                    height: 30,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      padding: EdgeInsets.only(
                                          top: Dimensions.PADDING_SIZE_SMALL),
                                      itemCount: addOns.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              right: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: Row(children: [
                                            InkWell(
                                              onTap: () {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .removeAddOn(
                                                        cartIndex, index);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2),
                                                child: Icon(Icons.remove_circle,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 18),
                                              ),
                                            ),
                                            Text(addOns[index].name,
                                                style: rubikRegular),
                                            SizedBox(width: 2),
                                            Text(
                                                PriceConverter.convertPrice(
                                                    context,
                                                    addOns[index].price),
                                                style: rubikMedium),
                                            SizedBox(width: 2),
                                            Text(
                                                '(${cart.addOnIds[index].quantity})',
                                                style: rubikRegular),
                                          ]),
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox(),*/
                          ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    right: 8.0,
                    bottom: 8.0,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              child: Stack(children: [
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFFFC6A57),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 4),
                                  child: Icon(
                                    Icons.mode_edit,
                                    size: 22,
                                    color: Color(0xFFFC6A57),
                                  ),
                                ),
                              ]),
                              onTap: () {
                                /*showbottomSheet =
                                true;
                                // bottomSheetData = widget.cart.product;

                                setState(() {});*/

                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (con) => CartBottomSheet(
                                    product: widget.cart.product,
                                    cartIndex: widget.cartIndex,
                                    cart: widget.cart,
                                    callback: () {
                                      showbottomSheet = false;
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                            InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, bottom: 4.0, right: 5.0),
                                  child: Icon(
                                    Icons.delete,
                                    size: 28,
                                    color: Color(0xFFFC6A57),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => alert(context));
                                }),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.cart.quantity.toString() +
                                      " * " +
                                      widget.cart.discountedPrice.toString() +
                                      /*PriceConverter.convertPrice(
                                      context, cart.discountedPrice)+*/
                                      " = " +
                                      (widget.cart.quantity *
                                              widget.cart.discountedPrice)
                                          .toString(),
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              widget.cart.discountAmount > 0
                                  ? Flexible(
                                      child: Text(
                                          PriceConverter.convertPrice(
                                              context,
                                              widget.cart.discountedPrice +
                                                  widget.cart.discountAmount),
                                          style: rubikBold.copyWith(
                                            color: ColorResources.COLOR_GREY,
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          )),
                                    )
                                  : SizedBox(),
                            ]),
                      ],
                    ),
                  ),
                )
                // Container(
                //   decoration: BoxDecoration(
                //       color: ColorResources.getBackgroundColor(context),
                //       borderRadius: BorderRadius.circular(5)),
                //   child: Row(children: [
                //     InkWell(
                //       onTap: () {
                //         if (cart.quantity > 1) {
                //           Provider.of<CartProvider>(context, listen: false)
                //               .setQuantity(false, cart);
                //         }
                //       },
                //       child: Padding(
                //         padding: EdgeInsets.symmetric(
                //             horizontal: Dimensions.PADDING_SIZE_SMALL,
                //             vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                //         child: Icon(Icons.remove, size: 20),
                //       ),
                //     ),
                //     Text(cart.quantity.toString(),
                //         style: rubikMedium.copyWith(
                //             fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                //     InkWell(
                //       onTap: () =>
                //           Provider.of<CartProvider>(context, listen: false)
                //               .setQuantity(true, cart),
                //       child: Padding(
                //         padding: EdgeInsets.symmetric(
                //             horizontal: Dimensions.PADDING_SIZE_SMALL,
                //             vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                //         child: Icon(Icons.add, size: 20),
                //       ),
                //     ),
                //   ]),
                // ),
              ]),
              widget.addOns.length > 0
                  ? SizedBox(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        padding:
                            EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                        itemCount: widget.addOns.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                right: Dimensions.PADDING_SIZE_SMALL),
                            child: Row(children: [
                              /*InkWell(
                          onTap: () {
                            Provider.of<CartProvider>(context, listen: false).removeAddOn(cartIndex, index);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor, size: 18),
                          ),
                        ),*/
                              Text(widget.addOns[index].name,
                                  style: rubikRegular),
                              SizedBox(width: 2),
                              Text(
                                  PriceConverter.convertPrice(
                                      context, widget.addOns[index].price),
                                  style: rubikMedium),
                              SizedBox(width: 2),
                              Text('(${widget.cart.addOnIds[index].quantity})',
                                  style: rubikRegular),
                            ]),
                          );
                        },
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ]),
    );
  }

  Widget alert(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.contact_support, size: 50),
        ),
        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Text("Are you sure you want to remove?",
              style: rubikBold, textAlign: TextAlign.center),
        ),
        Divider(height: 0, color: ColorResources.getHintColor(context)),
        Row(children: [
          Expanded(
              child: InkWell(
            onTap: () {
              Provider.of<CartProvider>(context, listen: false)
                  .removeFromCart(widget.cart);
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(10))),
              child: Text(getTranslated('yes', context),
                  style:
                      rubikBold.copyWith(color: ColorResources.COLOR_PRIMARY)),
            ),
          )),
          Expanded(
              child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ColorResources.getPrimaryColor(context),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(10))),
              child: Text(getTranslated('no', context),
                  style: rubikBold.copyWith(color: Colors.white)),
            ),
          )),
        ]),
      ]),
    );
  }
}
