import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/search_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/search/search_result_screen.dart';
import 'package:flutter_restaurant/view/screens/search/widget/filter_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key, this.isMenuTapped}) : super(key: key);
  final Function isMenuTapped;
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  bool _searchResult = false;
  Product bottomSheetData;
  bool showbottomSheet = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();

    return Scaffold(
      body: SafeArea(
        child: !_searchResult?
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
          child: Consumer<SearchProvider>(
            builder: (context, searchProvider, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: getTranslated('search_items_here', context),
                        isShowBorder: true,
                        isShowSuffixIcon: true,
                        suffixIconUrl: Images.search,
                        onSuffixTap: () {
                          if (_searchController.text.length > 0) {
                            searchProvider.saveSearchAddress(_searchController.text);
                            searchProvider.searchProduct(_searchController.text, context);
                            setState(() {
                              _searchResult = true;
                            });
                            //Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: _searchController.text)));
                          }
                        },
                        controller: _searchController,
                        inputAction: TextInputAction.search,
                        isIcon: true,
                        onSubmit: (text) {
                          if (_searchController.text.length > 0) {
                            searchProvider.saveSearchAddress(_searchController.text);
                            searchProvider.searchProduct(_searchController.text, context);
                            setState(() {
                              _searchResult = true;
                            });
                            //Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: _searchController.text)));
                          }
                        },
                      ),
                    ),
                    /*TextButton(
                        onPressed: () {
                         // Navigator.of(context).pop();
                        },
                        child: Text(
                          getTranslated('cancel', context),
                          style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getGreyBunkerColor(context)),
                        ))*/
                  ],
                ),
                // for resent search section
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated('recent_search', context),
                      style: Theme.of(context).textTheme.headline3.copyWith(color: ColorResources.COLOR_GREY_BUNKER),
                    ),
                    searchProvider.historyList.length > 0
                        ? TextButton(
                            onPressed: searchProvider.clearSearchAddress,
                            child: Text(
                              getTranslated('remove_all', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.COLOR_GREY_BUNKER),
                            ))
                        : SizedBox.shrink(),
                  ],
                ),

                // for recent search list section
                Expanded(
                  child: ListView.builder(
                      itemCount: searchProvider.historyList.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              searchProvider.searchProduct(searchProvider.historyList[index], context);
                              setState(() {
                                _searchResult = true;
                              });

/*                                Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: searchProvider.historyList[index])));*/
                            },
                            child: Padding(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.history, size: 16, color: ColorResources.COLOR_HINT),
                                      SizedBox(width: 13),
                                      Text(
                                        searchProvider.historyList[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            .copyWith(color: ColorResources.COLOR_HINT, fontSize: Dimensions.FONT_SIZE_SMALL),
                                      )
                                    ],
                                  ),
                                  Icon(Icons.arrow_upward, size: 16, color: ColorResources.COLOR_HINT),
                                ],
                              ),
                            ),
                          )),
                )
              ],
            ),
          ),
        ):
        showbottomSheet?CartBottomSheet(
          product: bottomSheetData,
          callback: ()
          {
            showbottomSheet=false;
            setState(() {

            });
          },
        ):
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
          child: Consumer<SearchProvider>(
            builder: (context, searchProvider, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: getTranslated('search_items_here', context),
                        isShowBorder: true,
                        isShowSuffixIcon: true,
                        suffixIconUrl: Images.filter,
                        controller: _searchController,
                        isShowPrefixIcon: true,
                        prefixIconUrl: Images.search,
                        inputAction: TextInputAction.search,
                        isIcon: true,
                        onSuffixTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                List<double> _prices = [];
                                searchProvider.filterProductList.forEach((product) => _prices.add(product.price));
                                _prices.sort();
                                double _maxValue = _prices.length > 0 ? _prices[_prices.length-1] : 1000;
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)),
                                  child: FilterWidget(maxValue: _maxValue),
                                );
                              });

                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _searchResult = false;
                        });
                        //Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                searchProvider.searchProductList != null
                    ? Text(
                  '${searchProvider.searchProductList.length} ${getTranslated('product_found', context)}',
                  style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getGreyBunkerColor(context)),
                )
                    : SizedBox.shrink(),
                SizedBox(height: 13),
                Expanded(
                  child: searchProvider.searchProductList != null
                      ? searchProvider.searchProductList.length > 0
                      ? ListView.builder(
                      itemCount: searchProvider.searchProductList.length,
                      //padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      itemBuilder: (context, index) {
                        double _startingPrice;
                        double _endingPrice;
                        if (searchProvider.searchProductList[index].choiceOptions.length != 0) {
                          List<double> _priceList = [];
                          searchProvider.searchProductList[index].variations
                              .forEach((variation) => _priceList.add(variation.price));
                          _priceList.sort((a, b) => a.compareTo(b));
                          _startingPrice = _priceList[0];
                          if (_priceList[0] < _priceList[_priceList.length - 1]) {
                            _endingPrice = _priceList[_priceList.length - 1];
                          }
                        } else {
                          _startingPrice = searchProvider.searchProductList[index].price;
                        }

                        double _discountedPrice = PriceConverter.convertWithDiscount(
                            context, searchProvider.searchProductList[index].price,
                            searchProvider.searchProductList[index].discount,
                            searchProvider.searchProductList[index].discountType);

                        DateTime _currentTime =
                            Provider.of<SplashProvider>(context, listen: false).currentTime;
                        DateTime _start = DateFormat('hh:mm:ss').parse(searchProvider.searchProductList[index].availableTimeStarts);
                        DateTime _end = DateFormat('hh:mm:ss').parse(searchProvider.searchProductList[index].availableTimeEnds);
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
                            setState(() {
                              showbottomSheet =
                              true;
                            });
                            bottomSheetData =searchProvider.searchProductList[index];
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
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
                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${searchProvider.searchProductList[index].image}',
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
                                                  wishList.wishIdList.contains(searchProvider.searchProductList[index].id)
                                                      ? wishList.removeFromWishList(
                                                      searchProvider.searchProductList[index], (message) {})
                                                      : wishList.addToWishList(searchProvider.searchProductList[index], (message) {});
                                                },
                                                child: Icon(
                                                  wishList.wishIdList.contains(searchProvider.searchProductList[index].id)
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: wishList.wishIdList.contains(searchProvider.searchProductList[index].id)
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
                                                        child: Text(searchProvider.searchProductList[index].name,
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
                                                          '${PriceConverter.convertPrice(context, _startingPrice,
                                                              discount: searchProvider.searchProductList[index].discount,
                                                              discountType: searchProvider.searchProductList[index].discountType, asFixed: 1)}'
                                                              '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice,
                                                              discount: searchProvider.searchProductList[index].discount,
                                                              discountType: searchProvider.searchProductList[index].discountType, asFixed: 1)}' : ''}',
                                                          style: rubikBold.copyWith(
                                                              fontSize: Dimensions.FONT_SIZE_SMALL),
                                                        ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      searchProvider.searchProductList[index].price > _discountedPrice
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
                                                      '${searchProvider.searchProductList[index].description}',
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

                              ]),
                            ),
                          ),
                        );
                      }
                          //ProductWidget(product: searchProvider.searchProductList[index])
                  )
                      : NoDataScreen()
                      : ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => ProductShimmer(isEnabled: searchProvider.searchProductList == null),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
