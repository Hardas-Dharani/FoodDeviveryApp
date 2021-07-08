import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:flutter_restaurant/data/model/response/base/feedback_model.dart';

class FeedBackScreen extends StatefulWidget {
  @override
  _FeedBackScreenState createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  String _email,
      _branch,
      _phone,
      _name,
      _meal,
      _apperanceSubmit,
      _cookingSubmit,
      _tasteSubmit,
      _tempratureSubmit,
      _speedSubmit,
      _accuracySubmit,
      _counterSubmit,
      _diningSubmit,
      _restRoomSubmit,
      _playlandSubmit,
      _outdoorSubmit,
      _friendlinessSubmit,
      _helpfullnessSubmit,
      _personalHygieneSubmit;
  var _isDarkMode;
  bool _isLoading = false;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String dob = DateTime.now().toString().substring(0, 10);
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        selectedDate = picked;
        dob = selectedDate.toString().substring(0, 10);
      });
    }
  }

  TimeOfDay time;
  TimeOfDay picked;

  Future<Null> selectTime(BuildContext context) async {
    picked = await showTimePicker(context: context, initialTime: time);
    if (picked != null) {
      setState(() {
        time = picked;
      });
    }
  }

  //controllers.................................................................
  final _branchController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _orderController = TextEditingController();
  final _mealController = TextEditingController();

  //nodes.......................................................................
  final FocusNode _branchnode = FocusNode();
  final FocusNode _username = FocusNode();
  final FocusNode _emailnode = FocusNode();
  final FocusNode _phonenode = FocusNode();
  final FocusNode _ordernode = FocusNode();
  final FocusNode _mealnode = FocusNode();

  //radio buttons controller....................................................
  // QUALITY OF FOOD............................................................
  int selectedApperanceTile;
  String _apperance = null;

  setSelectedApperanceTile(int val) {
    setState(() {
      selectedApperanceTile = val;
      if (selectedApperanceTile == 1) {
        setState(() {
          _apperance = "Excellent";
          print("Radio " + _apperance);
        });
      } else if (selectedApperanceTile == 2) {
        setState(() {
          _apperance = "Good";
          print("Radio " + _apperance);
        });
      } else if (selectedApperanceTile == 3) {
        setState(() {
          _apperance = "Poor";
          print("Radio " + _apperance);
        });
      }
    });
  }

  int selectedCookingTile;
  String _cookig = null;

  setSelectedCookingTile(int val) {
    setState(() {
      selectedCookingTile = val;
      if (selectedCookingTile == 1) {
        setState(() {
          _cookig = "Excellent";
        });
      } else if (selectedCookingTile == 2) {
        setState(() {
          _cookig = "Good";
        });
      } else if (selectedCookingTile == 3) {
        setState(() {
          _cookig = "Poor";
        });
      }
    });
  }

  int selectedTasteTile;
  String _taste = null;

  setSelectedTasteTile(int val) {
    setState(() {
      selectedTasteTile = val;
      if (selectedTasteTile == 1) {
        setState(() {
          _taste = "Excellent";
        });
      } else if (selectedTasteTile == 2) {
        setState(() {
          _taste = "Good";
        });
      } else if (selectedTasteTile == 3) {
        setState(() {
          _taste = "Poor";
        });
      }
    });
  }

  int selectedTempTile;
  String _temp = null;

  setSelectedTempTile(int val) {
    setState(() {
      selectedTempTile = val;
      if (selectedTempTile == 1) {
        setState(() {
          _temp = "Excellent";
        });
      } else if (selectedTempTile == 2) {
        setState(() {
          _temp = "Good";
        });
      } else if (selectedTempTile == 3) {
        setState(() {
          _temp = "Poor";
        });
      }
    });
  }

  //SERVICES FEEDBACK...........................................................
  int selectedSpeedOfServiceTile;
  String _SpeedOfService = null;

  setSelectedSpeedOfServiceTile(int val) {
    setState(() {
      selectedSpeedOfServiceTile = val;
      if (selectedSpeedOfServiceTile == 1) {
        setState(() {
          _SpeedOfService = "Excellent";
        });
      } else if (selectedSpeedOfServiceTile == 2) {
        setState(() {
          _SpeedOfService = "Good";
        });
      } else if (selectedSpeedOfServiceTile == 3) {
        setState(() {
          _SpeedOfService = "Poor";
        });
      }
    });
  }

  int selectedAccuracyOfOrderTile;
  String _AccuracyOfOrder = null;

  setSelectedAccuracyOfOrderTile(int val) {
    setState(() {
      selectedAccuracyOfOrderTile = val;
      if (selectedAccuracyOfOrderTile == 1) {
        setState(() {
          _AccuracyOfOrder = "Excellent";
        });
      } else if (selectedAccuracyOfOrderTile == 2) {
        setState(() {
          _AccuracyOfOrder = "Good";
        });
      } else if (selectedAccuracyOfOrderTile == 3) {
        setState(() {
          _AccuracyOfOrder = "Poor";
        });
      }
    });
  }

  // CLEANLINESS OF FOOD............................................................
  int selectedCounterAreaTile;
  String _CounterArea = null;

  setSelectedCounterAreaTile(int val) {
    setState(() {
      selectedCounterAreaTile = val;
      if (selectedCounterAreaTile == 1) {
        setState(() {
          _CounterArea = "Excellent";
        });
      } else if (selectedCounterAreaTile == 2) {
        setState(() {
          _CounterArea = "Good";
        });
      } else if (selectedCounterAreaTile == 3) {
        setState(() {
          _CounterArea = "Poor";
        });
      }
    });
  }

  int selectedDinningAreaTile;
  String _DinningArea = null;

  setSelectedDinningAreaTile(int val) {
    setState(() {
      selectedDinningAreaTile = val;
      if (selectedDinningAreaTile == 1) {
        setState(() {
          _DinningArea = "Excellent";
        });
      } else if (selectedDinningAreaTile == 2) {
        setState(() {
          _DinningArea = "Good";
        });
      } else if (selectedDinningAreaTile == 3) {
        setState(() {
          _DinningArea = "Poor";
        });
      }
    });
  }

  int selectedRestRoomsTile;
  String _RestRooms = null;

  setSelectedRestRoomsTile(int val) {
    setState(() {
      selectedRestRoomsTile = val;
      if (selectedRestRoomsTile == 1) {
        setState(() {
          _RestRooms = "Excellent";
        });
      } else if (selectedRestRoomsTile == 2) {
        setState(() {
          _RestRooms = "Good";
        });
      } else if (selectedRestRoomsTile == 3) {
        setState(() {
          _RestRooms = "Poor";
        });
      }
    });
  }

  int selectedPlayLandTile;
  String _PlayLand = null;

  setSelectedPlayLandTile(int val) {
    setState(() {
      selectedPlayLandTile = val;
      if (selectedPlayLandTile == 1) {
        setState(() {
          _PlayLand = "Excellent";
        });
      } else if (selectedPlayLandTile == 2) {
        setState(() {
          _PlayLand = "Good";
        });
      } else if (selectedPlayLandTile == 3) {
        setState(() {
          _PlayLand = "Poor";
        });
      }
    });
  }

  int selectedOutDoorTile;
  String _OutDoor = null;

  setSelectedOutDoorTile(int val) {
    setState(() {
      selectedOutDoorTile = val;
      if (selectedOutDoorTile == 1) {
        setState(() {
          _OutDoor = "Excellent";
        });
      } else if (selectedOutDoorTile == 2) {
        setState(() {
          _OutDoor = "Good";
        });
      } else if (selectedOutDoorTile == 3) {
        setState(() {
          _OutDoor = "Poor";
        });
      }
    });
  }

  //STAFF...........................................................
  int selectedFriendLinessTile;
  String _FriendLiness = null;

  setSelectedFriendLinessTile(int val) {
    setState(() {
      selectedFriendLinessTile = val;
      if (selectedFriendLinessTile == 1) {
        setState(() {
          _FriendLiness = "Excellent";
        });
      } else if (selectedFriendLinessTile == 2) {
        setState(() {
          _FriendLiness = "Good";
        });
      } else if (selectedFriendLinessTile == 3) {
        setState(() {
          _FriendLiness = "Poor";
        });
      }
    });
  }

  int selectedHelpFulnessTile;
  String _HelpFulness = null;

  setSelectedHelpFulnessTile(int val) {
    setState(() {
      selectedHelpFulnessTile = val;
      if (selectedHelpFulnessTile == 1) {
        setState(() {
          _HelpFulness = "Excellent";
        });
      } else if (selectedHelpFulnessTile == 2) {
        setState(() {
          _HelpFulness = "Good";
        });
      } else if (selectedHelpFulnessTile == 3) {
        setState(() {
          _HelpFulness = "Poor";
        });
      }
    });
  }

  int selectedPersonalHygieneTile;
  String _PersonalHygiene = null;

  setSelectedPersonalHygieneTile(int val) {
    setState(() {
      selectedPersonalHygieneTile = val;
      if (selectedPersonalHygieneTile == 1) {
        setState(() {
          _PersonalHygiene = "Excellent";
        });
      } else if (selectedPersonalHygieneTile == 2) {
        setState(() {
          _PersonalHygiene = "Good";
        });
      } else if (selectedPersonalHygieneTile == 3) {
        setState(() {
          _PersonalHygiene = "Poor";
        });
      }
    });
  }

  //spinner branch..............................................................
  String dropdownValue = 'BRANCH One';

  List<String> spinnerItems = [
    'BRANCH One',
    'BRANCH Two',
    'BRANCH Three',
    'BRANCH Four',
    'BRANCH Five'
  ];

  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    time = TimeOfDay.now();
    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel !=
        null) {
      UserInfoModel _userInfoModel =
          Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
      _nameController.text = _userInfoModel.fName ?? '';
      _phoneController.text = _userInfoModel.phone ?? '';
      _emailController.text = _userInfoModel.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: _isDarkMode ? Color(0xFF000000) : Color(0xFF00A4A4)));
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xff000000) : Color(0xffF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.09,
              floating: false,
              stretch: true,
              elevation: 0,
              pinned: false,
              title: Text(getTranslated("feedback", context)),
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
                        height: MediaQuery.of(context).size.height * 0.09,
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
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 30),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          Images.tazaj_english,
                          height: MediaQuery.of(context).size.height / 4.5,
                          fit: BoxFit.scaleDown,
                          matchTextDirection: true,
                        ),
                      ),
                    ]),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          )),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: size.width,
                            color: Colors.grey,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("customer_info", context),
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            width: size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Flexible(
                                  child: Row(
                                children: [
                                  Text(
                                    "*",
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    getTranslated("time_visit", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _selectDate(context);
                                              },
                                              child: Text(
                                                formatter.format(selectedDate),
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_DEFAULT,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                selectTime(context);
                                              },
                                              child: Text(
                                                "${time.hour}:${time.minute}",
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_DEFAULT,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 1,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                            ),
                          ),
                          Container(
                            height: 65,
                            width: size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Flexible(
                                  child: Row(
                                children: [
                                  Text(
                                    "*",
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    getTranslated("branch", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: DropdownButton<String>(
                                              value: dropdownValue,
                                              icon: Icon(Icons.arrow_drop_down),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: _isDarkMode
                                                      ? Colors.white
                                                      : Colors.black),
                                              underline: SizedBox(),
                                              dropdownColor: Colors.grey,
                                              onChanged: (String data) {
                                                setState(() {
                                                  dropdownValue = data;
                                                  print(dropdownValue);
                                                });
                                              },
                                              items: spinnerItems.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ), /*TextFormField(
                                                  cursorColor: Color(0xff00A4A4),
                                                  style: TextStyle(),
                                                  decoration:
                                                  new InputDecoration.collapsed(
                                                    */ /*hintText: 'NAME',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'comfortaa_semibold',
                                                      fontSize: 14.0,),*/ /*
                                                  ),
                                                  controller: _branchController,
                                                  focusNode: _branchnode,
                                                  onFieldSubmitted: (term) {
                                                    _branchnode.unfocus();
                                                    FocusScope.of(context)
                                                        .requestFocus(_username);
                                                  },
                                                  keyboardType: TextInputType.text,
                                                  validator: validateBranch,
                                                  textInputAction: TextInputAction.next,
                                                ),*/
                                          ),
                                          /*Container(
                                                height: 1,
                                                color: Colors.grey,
                                              ),*/
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Flexible(
                                  child: Row(
                                children: [
                                  Text(
                                    "*",
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    getTranslated("_name", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: TextFormField(
                                              cursorColor: Color(0xff00A4A4),
                                              style: TextStyle(),
                                              decoration: new InputDecoration
                                                      .collapsed(
                                                  /*hintText: 'NAME',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'comfortaa_semibold',
                                                      fontSize: 14.0,),*/
                                                  ),
                                              controller: _nameController,
                                              focusNode: _username,
                                              onFieldSubmitted: (term) {
                                                _username.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(_emailnode);
                                              },
                                              keyboardType: TextInputType.text,
                                              //validator: validateName,
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Flexible(
                                  child: Row(
                                children: [
                                  Text(
                                    "*",
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    getTranslated("_email", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: TextFormField(
                                              cursorColor: Color(0xff00A4A4),
                                              style: TextStyle(),
                                              decoration: new InputDecoration
                                                      .collapsed(
                                                  /*hintText: 'NAME',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'comfortaa_semibold',
                                                      fontSize: 14.0,),*/
                                                  ),
                                              controller: _emailController,
                                              focusNode: _emailnode,
                                              onFieldSubmitted: (term) {
                                                _emailnode.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(_phonenode);
                                              },
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              validator: validateEmail,
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Flexible(
                                  child: Row(
                                children: [
                                  Text(
                                    "*",
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    getTranslated("_phone", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            child: TextFormField(
                                              cursorColor: Color(0xff00A4A4),
                                              style: TextStyle(),
                                              decoration: new InputDecoration
                                                      .collapsed(
                                                  /*hintText: 'NAME',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'comfortaa_semibold',
                                                      fontSize: 14.0,),*/
                                                  ),
                                              controller: _phoneController,
                                              focusNode: _phonenode,
                                              onFieldSubmitted: (term) {
                                                _phonenode.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(_mealnode);
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: validateMobile,
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Flexible(
                                  child: Row(
                                children: [
                                  Text(
                                    "*",
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    getTranslated("meal", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            child: TextFormField(
                                              cursorColor: Color(0xff00A4A4),
                                              style: TextStyle(),
                                              decoration: new InputDecoration
                                                      .collapsed(
                                                  fillColor: Colors.red
                                                  /*hintText: 'NAME',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'comfortaa_semibold',
                                                      fontSize: 14.0,),*/
                                                  ),
                                              controller: _mealController,
                                              focusNode: _mealnode,
                                              keyboardType: TextInputType.text,
                                              validator: validateMeal,
                                              textInputAction:
                                                  TextInputAction.done,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                            ),
                          )
                        ],
                      ),
                    ),

//QUALITY OF FOOD...............................................................
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          )),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: size.width,
                            color: Colors.grey,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("food_quality", context),
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("apperance", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedApperanceTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            setSelectedApperanceTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: selectedApperanceTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedApperanceTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: selectedApperanceTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedApperanceTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("cooking", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedCookingTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedCookingTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: selectedCookingTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedCookingTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: selectedCookingTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedCookingTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("taste", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedTasteTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedTasteTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: selectedTasteTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedTasteTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: selectedTasteTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedTasteTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("temp", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedTempTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedTempTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: selectedTempTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedTempTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: selectedTempTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedTempTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

//SERVICES FEEDBACK.............................................................
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          )),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: size.width,
                            color: Colors.grey,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("service_feedback", context),
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("service_speed", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue:
                                              selectedSpeedOfServiceTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedSpeedOfServiceTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue:
                                              selectedSpeedOfServiceTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedSpeedOfServiceTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue:
                                              selectedSpeedOfServiceTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedSpeedOfServiceTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("order_accuracy", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue:
                                              selectedAccuracyOfOrderTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedAccuracyOfOrderTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue:
                                              selectedAccuracyOfOrderTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedAccuracyOfOrderTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue:
                                              selectedAccuracyOfOrderTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedAccuracyOfOrderTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

//CLEANLINESS OF FOOD...........................................................
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          )),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: size.width,
                            color: Colors.grey,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("cleanliness", context),
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("counter_area", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedCounterAreaTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedCounterAreaTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: selectedCounterAreaTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedCounterAreaTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: selectedCounterAreaTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedCounterAreaTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("dining_area", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedDinningAreaTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedDinningAreaTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: selectedDinningAreaTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedDinningAreaTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: selectedDinningAreaTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedDinningAreaTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("rest_room", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedRestRoomsTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedRestRoomsTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: selectedRestRoomsTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedRestRoomsTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: selectedRestRoomsTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedRestRoomsTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("play_land", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedPlayLandTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedPlayLandTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: selectedPlayLandTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedPlayLandTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: selectedPlayLandTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedPlayLandTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("outdoor", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedOutDoorTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedOutDoorTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: selectedOutDoorTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedOutDoorTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: selectedOutDoorTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedOutDoorTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

//STAFF.........................................................................
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          )),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: size.width,
                            color: Colors.grey,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("staff", context),
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("friendliness", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedFriendLinessTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedFriendLinessTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: selectedFriendLinessTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedFriendLinessTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: selectedFriendLinessTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedFriendLinessTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("helpfullness", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: selectedHelpFulnessTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedHelpFulnessTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue: selectedHelpFulnessTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedHelpFulnessTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue: selectedHelpFulnessTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedHelpFulnessTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            // height: 80,
                            width: size.width,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getTranslated("personal_hygiene", context),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue:
                                              selectedPersonalHygieneTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedPersonalHygieneTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("excellent", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 2,
                                          groupValue:
                                              selectedPersonalHygieneTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedPersonalHygieneTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("good", context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Radio(
                                          value: 3,
                                          groupValue:
                                              selectedPersonalHygieneTile,
                                          activeColor: Color(0xff00A4A4),
                                          onChanged: (val) {
                                            print("Radio $val");
                                            setSelectedPersonalHygieneTile(val);
                                          },
                                        ),
                                        Text(
                                          getTranslated("poor", context),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    //Submit  button...............................................................
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _email = _emailController.text.trim();
                        _branch = dropdownValue;
                        _phone = _phoneController.text.toString();
                        _name = _nameController.text.trim();
                        _meal = _mealController.text.trim();
                        _apperanceSubmit = _apperance;
                        _cookingSubmit = _cookig;
                        _tasteSubmit = _taste;
                        _tempratureSubmit = _temp;
                        _speedSubmit = _SpeedOfService;
                        _accuracySubmit = _AccuracyOfOrder;
                        _counterSubmit = _CounterArea;
                        _diningSubmit = _DinningArea;
                        _restRoomSubmit = _RestRooms;
                        _playlandSubmit = _PlayLand;
                        _outdoorSubmit = _OutDoor;
                        _friendlinessSubmit = _FriendLiness;
                        _helpfullnessSubmit = _HelpFulness;
                        _personalHygieneSubmit = _PersonalHygiene;

                        if (_email.isEmpty) {
                          showCustomSnackBar(
                              getTranslated('enter_email_address', context),
                              context);
                        } else if (EmailChecker.isNotValid(_email)) {
                          showCustomSnackBar(
                              getTranslated('enter_valid_email', context),
                              context);
                        } else if (_branch.isEmpty) {
                          showCustomSnackBar(
                              getTranslated('enter_branch_name', context),
                              context);
                        } else if (_name.isEmpty) {
                          showCustomSnackBar(
                              getTranslated('enter_name', context), context);
                        } else if (_phone.isEmpty) {
                          showCustomSnackBar(
                              getTranslated('enter_phone', context), context);
                        } else if (_phone.length != 10) {
                          showCustomSnackBar(
                              getTranslated('check_phone', context), context);
                        } else if (_meal.isEmpty) {
                          showCustomSnackBar(
                              getTranslated('check_meal', context), context);
                        } else if (_apperanceSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_apperance', context),
                              context);
                        } else if (_cookingSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_cooking', context), context);
                        } else if (_tasteSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_taste', context), context);
                        } else if (_tempratureSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_temp', context), context);
                        } else if (_speedSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_speed', context), context);
                        } else if (_accuracySubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_accuracy', context),
                              context);
                        } else if (_counterSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_counter', context), context);
                        } else if (_diningSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_dining', context), context);
                        } else if (_restRoomSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_restRoom', context),
                              context);
                        } else if (_playlandSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_playland', context),
                              context);
                        } else if (_outdoorSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_outdoor', context), context);
                        } else if (_friendlinessSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_friendliness', context),
                              context);
                        } else if (_helpfullnessSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_helpfullness', context),
                              context);
                        } else if (_personalHygieneSubmit == null) {
                          showCustomSnackBar(
                              getTranslated('check_personalHygiene', context),
                              context);
                        } else {
                          print("ALl set");
                          setState(() {
                            _isLoading = true;
                            hitFeedbackApi();
                          });
                        }
                      },
                      child: Container(
                        height: 45,
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff00A4A4)),
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
                    )
                  ]),
            ))
          ],
        ),
      ),
    );
  }

  String validateBranch(String value) {
    if (value.length < 4) {
      return 'Branch must contains 5 characters';
    } else
      return null;
  }

  String validateName(String value) {
    if (value.length < 5) {
      return 'Name must contains 5 characters';
    } else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter valid email';
    else
      return null;
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (!value.isEmpty) {
      if (value.length < 10 || value.length > 10) {
        return 'Enter Valid Mobile Number';
      } else {
        if (!regExp.hasMatch(value)) {
          return 'Please enter valid mobile number';
        } else {
          if (value == "9999999999") {
            return 'Please enter valid mobile number';
          } else if (value == "8888888888") {
            return 'Please enter valid mobile number';
          } else if (value == "7777777777") {
            return 'Please enter valid mobile number';
          } else if (value == "6666666666") {
            return 'Please enter valid mobile number';
          } else if (value == "5555555555") {
            return 'Please enter valid mobile number';
          } else if (value == "4444444444") {
            return 'Please enter valid mobile number';
          } else if (value == "3333333333") {
            return 'Please enter valid mobile number';
          } else if (value == "2222222222") {
            return 'Please enter valid mobile number';
          } else if (value == "1111111111") {
            return 'Please enter valid mobile number';
          } else if (value == "0000000000") {
            return 'Please enter valid mobile number';
          } else
            return null;
        }
      }
    } else {
      return 'Enter Mobile Number';
    }
  }

  String validateMeal(String value) {
    if (value.length < 4) {
      return 'Meal must contains 4 characters';
    } else
      return null;
  }

  static var userdetails;
  Map<String, Object> json;

  Future<FeedBackApi> hitFeedbackApi() async {
    Map<String, String> headervalue = {
      'Authorization':
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOTgwN2MyYTI3ODVjMjMwZGI2ZTJjOGE1N2U4YTgxNTZhODM5ZTA0ZmM0ODEzYjljMTZkZTg4YTg1YzE0NmRiMzc5NWFhMmE0MWI5OWZkYjkiLCJpYXQiOiIxNjIyMTgwMDQ5LjQwODY4NyIsIm5iZiI6IjE2MjIxODAwNDkuNDA4NjkwIiwiZXhwIjoiMTY1MzcxNjA0OS40MDUxMDgiLCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.lFxfAGMNZznB9UkhG19RjVFk692LSizkmXOk9CE6OhrwaRsI5NM0ZxSfeOwqjKhynKxRQHo8LyRuC_IyGj6a3klCwZ-tDcBtRXrfZkLQaEzPaGO5fzUEKYhnZcfYxBUXB41YY41sR2MiyYBEE6Dw8bWm8ArDGRsq21HMutS3fWehh3QWiWEDs1LVvDOYPL-C6eJPWka7XDR4K74GXxpGZH4FQg_ba45wktdgyEW_3GXnjKiaKJG-msv3BcojC_JhVkYBl2RNQttxwQf89PB9phRj5n8w-vw4ehez94tW4TqPjp_P_M6_G0LlZjSo9or43cRkk4i8y9sJF2jNdH5Y60BtKRgKuQI8tXOsMNICnrJTwhlWIgW31-LAojUm9UV5a6ax5jIOD4dgn2Uqa5sRHMv5gfLxw0wtFRHgmJgMmF6iBo4XJ2zkFUK3pOfBg2JSBcE9705v2B9k-oIzmR8HrLcLLLYQyKR9S_OOhKHqFEUyKRkPV03oQcw7tbOjRg0Q0XSxcf0kwCVvX-pR2MzqJSnvgVgHUxjlPuDatnEsNagTi8kMOhBHhgXCvUD0ZF3QqPUi48jqpqxJ92YEgIw85SrfgYQWOmo3OkUVw42_51tnapJMw2MnWZwbRdCbq8qI9NZAKjWN672z7FO5j2Z_2pBk06A7SSTAB08nJ6boToA"
    };
    setState(() {
      json = {
        "date_to_visit": dob,
        "time_to_visit": "03:15",
        "branch": dropdownValue,
        "user_name": _name,
        "email_id": _email,
        "phone": _phone,
        "meal": _meal,
        "qlty_food_apperance": _apperanceSubmit,
        "qlty_food_cooking": _cookingSubmit,
        "qlty_food_taste": _tasteSubmit,
        "qlty_food_temprature": _tempratureSubmit,
        "service_feedback_speed": _speedSubmit,
        "service_feedback_accurcy_order": _accuracySubmit,
        "cleanliness_counter_area": _counterSubmit,
        "cleanliness_dining_area": _diningSubmit,
        "cleanliness_restrooms": _restRoomSubmit,
        "cleanliness_playland": _playlandSubmit,
        "cleanliness_outdoor": _outdoorSubmit,
        "staff_friendliess": _friendlinessSubmit,
        "staff_helpfullness": _helpfullnessSubmit,
        "staff_personal_hygine": _personalHygieneSubmit,
        "user_id": "2"
      };
    });
    print("Vlaue of json is = " + json.toString());

    Response response = await http.post(
        Uri.parse("https://venturus.in/dapp/api/v1/customer/feedback/add"),
        body: json,
        headers: headervalue);

    print("hkjdhgkg = " + response.statusCode.toString());
    if (response.statusCode == 200) {
      userdetails = JSON.jsonDecode(response.body);
      if (userdetails['message'] == "successfully added!") {
        print("done");
        setState(() {
          _isLoading = false;
        });

        showSucessSnackBar("Feedback is submitted", context);
      } else {
        print("not message");
        setState(() {
          _isLoading = false;
        });
        showCustomSnackBar("Something went wrong", context);
      }
    } else {
      print("bad request");
      setState(() {
        _isLoading = false;
      });
      showCustomSnackBar("Bad request", context);
    }
  }
}
