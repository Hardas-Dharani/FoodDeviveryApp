import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/home_delivery_home_pickup/HomeDeliveryHomePickupScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocationScreen extends StatefulWidget {
  var screenname;
  SelectLocationScreen({this.screenname});
  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController _controller;
  TextEditingController _locationController = TextEditingController();
  int _groupValue = -1;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget commonButton(String label, VoidCallback voidCallback, {Color color}) {
    return MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        onPressed: voidCallback,
        color: color != null ? color : ColorResources.COLOR_PRIMARY,
        // :
        //  ColorResources.COLOR_PRIMARY,
        splashColor: Colors.grey.withOpacity(0.5),
        child: Text(
          label,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ));
  }

  bool _lights = false;
  @override
  Widget build(BuildContext context) {
    if (Provider.of<LocationProvider>(context).address != null) {
      _locationController.text =
          '${Provider.of<LocationProvider>(context).address.name ?? ''}, '
          '${Provider.of<LocationProvider>(context).address.subAdministrativeArea ?? ''}, '
          '${Provider.of<LocationProvider>(context).address.isoCountryCode ?? ''}';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: SizedBox.shrink(),
        centerTitle: true,
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
        // Text(getTranslated('select_delivery_address', context)),
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) => Stack(
          clipBehavior: Clip.none,
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(locationProvider.position.latitude ?? 0.0,
                    locationProvider.position.longitude ?? 0.0),
                zoom: 14,
              ),
              zoomControlsEnabled: false,
              compassEnabled: false,
              indoorViewEnabled: true,
              mapToolbarEnabled: true,
              onCameraIdle: () {
                locationProvider.dragableAddress();
              },
              onCameraMove: ((_position) =>
                  locationProvider.updatePosition(_position)),
              // markers: Set<Marker>.of(locationProvider.markers),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                if (_controller != null) {
                  locationProvider.getCurrentLocation(
                      mapController: _controller);
                }
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: commonButton("Pick up", () {}, color: Colors.grey),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: commonButton("Delivery", () {}, color: Color(0xff00A4A4)),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.35,
              left: MediaQuery.of(context).size.width * 0.85,
              child: InkWell(
                onTap: () {
                  locationProvider.getCurrentLocation(
                      mapController: _controller);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                    color: ColorResources.COLOR_WHITE,
                  ),
                  child: Icon(
                    Icons.my_location,
                    color: ColorResources.COLOR_PRIMARY,
                    size: 35,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                color: Color(0xFFE5791E),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    locationProvider.address != null
                        ? Container(
                            padding: EdgeInsets.only(top: 20),
                            // height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Delivery Location",
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize:
                                              Dimensions.FONT_SIZE_EXTRA_LARGE,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        )),
                                    Text(
                                        locationProvider.address.name != null
                                            ? '${locationProvider.address.name} , ${locationProvider.address.subAdministrativeArea} , ${locationProvider.address.isoCountryCode} '
                                            : '',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: Dimensions.FONT_SIZE_LARGE,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    Container(
                      padding: EdgeInsets.all(5),
                      // width: 200,
                      child: CustomTextField(
                        hintText: "Description",
                        isShowBorder: true,
                        // isShowSuffixIcon: true,
                        // suffixIconUrl: Images.search,
                        onSuffixTap: () {
                          // if (_searchController.text.length > 0) {
                          //   searchProvider.saveSearchAddress(_searchController.text);
                          //   searchProvider.searchProduct(_searchController.text, context);
                          //   setState(() {
                          //     _searchResult = true;
                          //   });
                          //   //Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: _searchController.text)));
                          // }
                        },
                        inputAction: TextInputAction.search,
                        // isIcon: true,
                        onChanged: (text) {},
                        onSubmit: (text) {
                          // if (_searchController.text.length > 0) {
                          //   searchProvider.saveSearchAddress(_searchController.text);
                          //   searchProvider.searchProduct(_searchController.text, context);
                          //   setState(() {
                          //     _searchResult = true;
                          //   });
                          //   //Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: _searchController.text)));
                          // }
                        },
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Save for later use",
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              )),
                          Container(
                            // width: 40,
                            // height: 30,
                            child: Switch(
                              value: _lights,
                              onChanged: (value) {
                                setState(() {
                                  _lights = value;
                                  print(_lights);
                                });
                              },
                              activeTrackColor: Color(0xff00A4A4),
                              activeColor: Color(0xff00A4A4),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _lights,
                      child: Column(
                        children: [
                          _myRadioButton(
                            title: "Others",
                            value: 0,
                            onChanged: (newValue) =>
                                setState(() => _groupValue = newValue),
                          ),
                          _myRadioButton(
                            title: "Works",
                            value: 1,
                            onChanged: (newValue) =>
                                setState(() => _groupValue = newValue),
                          ),
                          _myRadioButton(
                            title: "Home",
                            value: 2,
                            onChanged: (newValue) =>
                                setState(() => _groupValue = newValue),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                      child: TextButton(
                        onPressed: locationProvider.loading
                            ? null
                            : () {
                                widget.screenname == "Home"
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                HomeDeliveyAndHomePickupScreen(
                                                  label: "Home Delivery",
                                                  latfrommap: locationProvider
                                                      .position.latitude,
                                                  lngfrommap: locationProvider
                                                      .position.longitude,
                                                )))
                                    : Navigator.of(context).pop();
                              },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 50),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Confirm",
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    color: Color(0xff00A4A4),
                                    fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ),

                      // CustomButton(
                      //   backgroundColor: Colors.white,
                      //   btnTxt:,

                      //   onTap:
                      // ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  Images.marker,
                  width: 25,
                  height: 35,
                )),
            locationProvider.loading
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)))
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
