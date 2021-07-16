import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetMenuRepo {
  final DioClient dioClient;
  SetMenuRepo({@required this.dioClient});

  Future<ApiResponse> getSetMenuList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("branchidshr");
    try {
      final response = await dioClient.get(AppConstants.SET_MENU_URI,
          queryParameters: {"branch_id": id, "lang": "en"});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
