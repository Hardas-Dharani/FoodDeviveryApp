import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_restaurant/network/CommonResponse.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import 'HomePickup.dart';
import 'api_helper.dart';

class ApiRepository {
  Future<List<HomePickup>> getHomePickup(String lat, String lng) async {
    Dio _dio = Dio();
    var response = await _dio.get(
      "https://venturus.in/dapp/api/v1/branch/branch_list",
      // data: {"type": lat,
      //   "type": lng},
    );
    print("getConfig Response" + response.toString());
    // Map<String, dynamic> data = jsonDecode(response.toString());
    // print(data.toString());
    List<HomePickup> _categoryList = [];
    response.data.forEach(
        (category) => _categoryList.add(HomePickup.fromJson(category)));
    return _categoryList;
  }
}
