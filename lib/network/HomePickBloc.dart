import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'HomePickup.dart';
import 'api_repository.dart';

class HomePickupBloc {
//progress
  Stream get progressStream => progressController.stream;
  final BehaviorSubject progressController = BehaviorSubject<bool>();

  StreamSink get progressSink => progressController.sink;


Stream get homePickupStream => homePickupController.stream;
  final BehaviorSubject homePickupController = BehaviorSubject<List<HomePickup>>();

  StreamSink get homePickupSink => homePickupController.sink;



  ApiRepository apiRepository = ApiRepository();

  void getHomePickup(BuildContext context, String lat, String lng) {
    progressSink.add(true);
    apiRepository.getHomePickup(lat, lng).then((onResponse) {
      // print("Response Block:  ${onResponse.message.toString()}");
      if (onResponse == null) {
        progressSink.add(false);
      } else if (onResponse != null) {

        progressSink.add(false);
      }
      homePickupSink.add(onResponse);
      print("homePickupSink${onResponse.length}");
    }).catchError((onError) {
      progressSink.add(false);
      print("On_Error  " + onError.toString());
    });
  }
}
