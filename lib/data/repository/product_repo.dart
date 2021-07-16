import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepo {
  final DioClient dioClient;

  ProductRepo({@required this.dioClient});

  Future<ApiResponse> getPopularProductList(String offset) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("branchidshr");
    try {
      final response = await dioClient.get(
          '${AppConstants.POPULAR_PRODUCT_URI}?limit=10&&offset=$offset',
          queryParameters: {"branch_id": id, "lang": "en"});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchProduct(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("branchidshr");
    try {
      final response = await dioClient.get(
          '${AppConstants.SEARCH_PRODUCT_URI}$productId',
          queryParameters: {"branch_id": id, "lang": "en"});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitReview(ReviewBody reviewBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("branchidshr");
    try {
      final response = await dioClient.post(AppConstants.REVIEW_URI,
          data: reviewBody, queryParameters: {"branch_id": id, "lang": "en"});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitDeliveryManReview(ReviewBody reviewBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("branchidshr");
    try {
      final response = await dioClient.post(AppConstants.DELIVER_MAN_REVIEW_URI,
          data: reviewBody, queryParameters: {"branch_id": id, "lang": "en"});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
