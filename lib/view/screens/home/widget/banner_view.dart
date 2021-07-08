import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/screens/category/category_screen.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerView extends StatefulWidget {
  @override
  _BannerViewState createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    int _current = 0;
    return SizedBox(
      height: MediaQuery.of(context).size.height * .28,
      child: Consumer<BannerProvider>(
        builder: (context, banner, child) {
          return banner.bannerList != null
              ? banner.bannerList.length > 0
                  ? Stack(children: [
                      CarouselSlider.builder(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * .28,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          onPageChanged: (index, dsjkbg) {
                            setState(() {
                              _current = index;
                            });
                          },
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 500),
                          viewportFraction: 1,
                        ),
                        itemCount: banner.bannerList.length,
                        itemBuilder: (context, index, val) {
                          return InkWell(
                            onTap: () {
                              if (banner.bannerList[index].productId != null) {
                                Product product;
                                for (Product prod in banner.productList) {
                                  if (prod.id ==
                                      banner.bannerList[index].productId) {
                                    product = prod;
                                    break;
                                  }
                                }
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (con) => CartBottomSheet(
                                    product: product,
                                    callback: (CartModel cartModel) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(getTranslated(
                                            'added_to_cart', context)),
                                        backgroundColor: Colors.green,
                                      ));
                                    },
                                  ),
                                );
                              } else if (banner.bannerList[index].categoryId !=
                                  null) {
                                CategoryModel category;
                                for (CategoryModel categoryModel
                                    in Provider.of<CategoryProvider>(context,
                                            listen: false)
                                        .categoryList) {
                                  if (categoryModel.id ==
                                      banner.bannerList[index].categoryId) {
                                    category = categoryModel;
                                    break;
                                  }
                                }
                                if (category != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => CategoryScreen(
                                              categoryModel: category)));
                                }
                              }
                            },
                            child: Container(
                              height: 85,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  right: Dimensions.PADDING_SIZE_SMALL),
                              decoration: BoxDecoration(
                                color: ColorResources.COLOR_WHITE,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}/${banner.bannerList[index].image}',
                                  height: 85,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              map<Widget>(banner.bannerList, (index, url) {
                            return Container(
                              width: 10.0,
                              height: 10.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Color(int.parse("#00A4A4".substring(1, 7),
                                            radix: 16) +
                                        0xFF000000)
                                    : Color(int.parse("#FFFFFF".substring(1, 7),
                                            radix: 16) +
                                        0xFF000000),
                              ),
                            );
                          }),
                        ),
                      ),
                    ])
                  : Center(
                      child:
                          Text(getTranslated('no_banner_available', context)))
              : BannerShimmer();
        },
      ),
    );
  }
}

class BannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
          child: Container(
            width: 250,
            height: 85,
            margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[200], spreadRadius: 1, blurRadius: 5)
              ],
              color: ColorResources.COLOR_WHITE,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}
