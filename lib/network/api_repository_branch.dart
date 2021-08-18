import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_restaurant/network/CommonResponse.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import 'BranchPickup.dart';
import 'api_helper.dart';

class ApiRepositoryBranch {
  Future<List<BranchPickup>> getbranchPickup(String lat, String lng) async {
    Dio _dio = Dio();
    var response = await _dio.get(
        "https://venturus.in/dapp/api/v1/branch/branch_list",
        queryParameters: {"branch_pickup": 1}

        // data: {"type": lat,
        //   "type": lng},
        );
    print("getConfig Response" + response.toString());
    // Map<String, dynamic> data = jsonDecode(response.toString());
    // print(data.toString());
    List<BranchPickup> _categoryList = [];
    response.data.forEach(
        (category) => _categoryList.add(BranchPickup.fromJson(category)));
    return _categoryList;
  }
}
