import 'dart:async';
import 'dart:ffi';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/network/HomePickBloc.dart';
import 'package:flutter_restaurant/network/HomePickup.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/dashboard/Menu_dash_board_layout.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:shared_preferences/shared_preferences.dart';

class HomeDeliveyAndHomePickupScreen extends StatefulWidget {
  var label;
  double latfrommap;
  double lngfrommap;

  HomeDeliveyAndHomePickupScreen(
      {this.label, this.latfrommap, this.lngfrommap});

  @override
  _HomeDeliveyAndHomePickupScreenState createState() =>
      _HomeDeliveyAndHomePickupScreenState();
}

class _HomeDeliveyAndHomePickupScreenState
    extends State<HomeDeliveyAndHomePickupScreen> {
  var _isDarkMode;
  bool _isLoading = false;

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  int selectedIndex = -1;
  Iterable markers = [];
  Iterable _markers;
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  TextEditingController _searchController = TextEditingController();

  List<HomePickup> homePickupList;
  List<HomePickup> searchPickupList = [];
  HomePickupBloc homePickupBloc;
  List<Map<String, dynamic>> list = [
    {"title": "one", "id": "1", "lat": "23.8859", "lon": "45.0792"},
    {
      "title": "two",
      "id": "2",
      "lat": "21.56848959279122",
      "lon": "39.11024542465108"
    },
    {
      "title": "three",
      "id": "3",
      "lat": "21.61357044792778",
      "lon": "39.153399207464226"
    },
    // {"title": "four", "id": "4", "lat": "30.6942", "lon": "76.8606"},
  ];

  double currentLat, currentLng;
  bool isSearchInitiated = false;

  @override
  void initState() {
    super.initState();
    homePickupBloc = HomePickupBloc();
    homePickupList = [];
    _getLocation();
  }

  _getLocation() async {
    print("**********_getLocation ***********");
    // await Permission.locationWhenInUse.request();
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      debugPrint('_getLocation Latitude: ${value.latitude}');
      debugPrint('_getLocation Longitude: ${value.longitude}');
      currentLat = value.latitude;
      currentLng = value.longitude;
      LatLng pinPosition = LatLng(value.latitude, value.longitude);
      homePickupBloc.getHomePickup(context, "", "");
      return null;
    });

    // initialLocation =
    //     CameraPosition(zoom: 12, bearing: 30, target: pinPosition);
    // if(latitude ==null && longitude==null) {
    //   print("********** lat lng null**********");
    //   latitude = position.latitude;
    //   longitude = position.longitude;
    //
    //   setState(() {});

    // }

    // _markers = Iterable.generate(list.length, (index) {
    //   return Marker(
    //     markerId: MarkerId(list[index]["id"]),
    //     position: LatLng(
    //         double.parse(list[index]["lat"]), double.parse(list[index]["lon"])),
    //     // icon: pinLocationIcon,
    //     onTap: () {
    //       // showProfileIOSBottomSheet(context, index);
    //     },
    //   );
    // });
    // print("--------- markers  ${_markers.length}");
    // markers = _markers;
    // setState(() {});
  }

  int branchid = 0;
  String status = "";
  String branchname = '';
  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: _isDarkMode ? Color(0xFF000000) : Color(0xFF00A4A4)));
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
      persistentFooterButtons: [
        Container(
          height: 45,
          width: size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff00A4A4)),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.zero,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt("branchidshr", branchid);
              prefs.setString("branchname", branchname);
              print(branchid);

              if (selectedIndex != -1 && status != "Closed") {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => DashBoardLayOut()),
                    (route) => false);
              }
            },
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : Text(
                      getTranslated("submit", context),
                      style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
            ),
          ),
        ),
      ],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.13,
              floating: false,
              stretch: true,
              elevation: 0,
              pinned: false,
              // title: Text(getTranslated(widget.label?.toString(), context)),
              // title: Text(widget.label),
              title: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        Images.tazaj_english,
                        height: MediaQuery.of(context).size.height / 7.5,
                        fit: BoxFit.scaleDown,
                        matchTextDirection: true,
                      ),
                      //  CustomTextField(
                      //   hintText: getTranslated('search_items_here', context),
                      //   isShowBorder: true,
                      //   isShowSuffixIcon: true,
                      //   suffixIconUrl: Images.search,
                      //   onSuffixTap: () {
                      //     // if (_searchController.text.length > 0) {
                      //     //   searchProvider.saveSearchAddress(_searchController.text);
                      //     //   searchProvider.searchProduct(_searchController.text, context);
                      //     //   setState(() {
                      //     //     _searchResult = true;
                      //     //   });
                      //     //   //Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: _searchController.text)));
                      //     // }
                      //   },
                      //   controller: _searchController,
                      //   inputAction: TextInputAction.search,
                      //   isIcon: true,
                      //   onChanged: (text) {
                      //     setState(() {
                      //       print("object${text}");

                      //       if (text != null) {
                      //         isSearchInitiated = true;
                      //         searchPickupList = [];
                      //         homePickupList.forEach((element) {
                      //           print("lat is =" +
                      //               element.latitude.toString() +
                      //               "    " +
                      //               "long is =" +
                      //               element.longitude.toString() +
                      //               "\n");
                      //           if (element.name.toLowerCase().contains(text) ||
                      //               element.address
                      //                   .toLowerCase()
                      //                   .contains(text)) {
                      //             searchPickupList.add(element);
                      //           }
                      //         });
                      //       } else {
                      //         isSearchInitiated = false;
                      //       }
                      //     });
                      //   },
                      //   onSubmit: (text) {
                      //     setState(() {
                      //       isSearchInitiated = false;
                      //     });
                      //     // if (_searchController.text.length > 0) {
                      //     //   searchProvider.saveSearchAddress(_searchController.text);
                      //     //   searchProvider.searchProduct(_searchController.text, context);
                      //     //   setState(() {
                      //     //     _searchResult = true;
                      //     //   });
                      //     //   //Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: _searchController.text)));
                      //     // }
                      //   },
                      // ),
                    ),
                    SizedBox(
                      width: 60,
                    )
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
              ),
              stretchTriggerOffset: 150.0,
              titleSpacing: 0,
              backgroundColor: Color(
                  int.parse("#00A4A4".substring(1, 7), radix: 16) + 0xFF000000),
              actionsIconTheme: IconThemeData(opacity: 0.0),
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [
                  StretchMode.zoomBackground,
                ],
                background: Container(
                  color: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        decoration: BoxDecoration(
                          color: Color(
                              int.parse("#00A4A4".substring(1, 7), radix: 16) +
                                  0xFF000000),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: StreamBuilder<List<HomePickup>>(
                    initialData: null,
                    stream: homePickupBloc.homePickupStream,
                    builder: (context, snapshot) {
                      homePickupList = [];
                      if (snapshot.hasData && snapshot.data != null) {
                        homePickupList.addAll(snapshot.data);

                        _markers =
                            Iterable.generate(homePickupList.length, (index) {
                          return Marker(
                            markerId:
                                MarkerId(homePickupList[index].id.toString()),
                            position: LatLng(
                                double.parse(homePickupList[index].latitude),
                                double.parse(homePickupList[index].longitude)),
                            onTap: () {},
                          );
                        });
                        print("--------- markers  ${_markers.length}");

                        markers = _markers;
                        return Container(
                          child: Column(
                            children: [
                              Container(
                                height: 250,
                                margin: EdgeInsets.only(top: 20),
                                child: Stack(
                                  children: [
                                    GoogleMap(
                                      mapType: MapType.normal,
                                      myLocationEnabled: true,
                                      //initialCameraPosition: initialLocation,
                                      initialCameraPosition: CameraPosition(
                                          zoom: 6,
                                          bearing: 30,
                                          target: LatLng(
                                              double.parse(homePickupList[0]
                                                  .latitude
                                                  .toString()),
                                              double.parse(homePickupList[0]
                                                  .longitude
                                                  .toString()))),
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        print(
                                            "--------- locationList markers  ${list.length}");
                                        _controller.complete(controller);
                                      },
                                      markers: Set.from(markers),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: commonButton("Pick up", () {},
                                          color: Color(0xff00A4A4)),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: commonButton("Delivery", () {},
                                          color: Colors.grey),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: commonButton("All Branch", () {},
                                          color: Color(0xff00A4A4)),
                                    ),
                                  ],
                                ),
                              ),
                              _listView(isSearchInitiated
                                  ? searchPickupList
                                  : homePickupList),
                            ],
                          ),
                        );
                      } else
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Color(0xFF00A4A4)),
                              ),
                            ),
                          ),
                        );
                    }))
          ],
        ),
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
        color: color != null
            ? color
            : !_isDarkMode
                ? ColorResources.COLOR_PRIMARY
                : Color(0xff000000),
        // :
        //  ColorResources.COLOR_PRIMARY,
        splashColor: Colors.grey.withOpacity(0.5),
        child: Text(
          label,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ));
  }

  TimeOfDay time;
  List openClose = [];
  DateFormat dateFormat = new DateFormat.Hm();
  Widget _listView(List<HomePickup> homePickupList) {
    return ListView.separated(
      itemCount: homePickupList != null && homePickupList.length > 0
          ? homePickupList.length
          : 0,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // print("Data is ="+homePickupList[index].closeTime+"\n");
        // final startTime = DateTime(2021, 7, 7, 10, 30);
        // final endTime = DateTime(2021, 7, 7, 01, 00);
        /*final startTime = dateFormat.parse(homePickupList[index].openTime);
        final endTime = dateFormat.parse(homePickupList[index].closeTime);*/

        // final currentTime = DateTime.now();
        //
        // if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
        //   // do something
        //   print ("ys");
        //   openClose.add("(Open)");
        // }
        // else{
        //   openClose.add("(Close)");
        //   print("no");
        // }
        /*DateTime before = DateTime.now();
        DateTime after = DateTime.parse( homePickupList[index].closeTime.subString(0,4));
        print((before.difference(after).inMilliseconds).toString());*/
        int distance = widget.latfrommap.toString() != null
            ? (Geolocator.distanceBetween(
                        widget.latfrommap,
                        widget.lngfrommap,
                        double.parse(homePickupList[index].latitude.toString()),
                        double.parse(
                            homePickupList[index].longitude.toString())) /
                    1000)
                .round()
            : (Geolocator.distanceBetween(
                        currentLat,
                        currentLng,
                        double.parse(homePickupList[index].latitude.toString()),
                        double.parse(
                            homePickupList[index].longitude.toString())) /
                    1000)
                .round();
        if (distance <= 50) {
          return ListTile(
            tileColor: selectedIndex == index
                ? Color(0xFF00A4A4).withOpacity(0.5)
                : Color(0xFFE5791E),
            onTap: () {
              branchid = homePickupList[index].id;
              status = homePickupList[index].openCloseStatus;
              branchname = homePickupList[index].name;
              selectedIndex = index;
              setState(() {});
            },
            title: Text("${homePickupList[index].name}",
                style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            subtitle: Text("${homePickupList[index].address}",
                style: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400)),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${distance}km",
                    style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(homePickupList[index].openCloseStatus,
                    style: Theme.of(context).textTheme.headline2.copyWith(
                        color: homePickupList[index].openCloseStatus == "Open"
                            ? Colors.white
                            : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 2,
          color: Colors.grey.withOpacity(0.2),
        );
      },
    );
  }
}
