import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'BranchPickup.dart';
import 'api_repository_branch.dart';

class BranchPickupBloc {
//progress
  Stream get progressStream => progressController.stream;
  final BehaviorSubject progressController = BehaviorSubject<bool>();

  StreamSink get progressSink => progressController.sink;

  Stream get branchPickupStream => branchPickupController.stream;
  final BehaviorSubject branchPickupController =
      BehaviorSubject<List<BranchPickup>>();

  StreamSink get branchPickupSink => branchPickupController.sink;

  ApiRepositoryBranch apiRepository = ApiRepositoryBranch();

  void getbranchPickup(BuildContext context, String lat, String lng) {
    progressSink.add(true);
    apiRepository.getbranchPickup(lat, lng).then((onResponse) {
      // print("Response Block:  ${onResponse.message.toString()}");
      if (onResponse == null) {
        progressSink.add(false);
      } else if (onResponse != null) {
        progressSink.add(false);
      }
      branchPickupSink.add(onResponse);
      print("branchPickupSink${onResponse.length}");
    }).catchError((onError) {
      progressSink.add(false);
      print("On_Error  " + onError.toString());
    });
  }
}
