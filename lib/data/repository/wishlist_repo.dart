import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class WishListRepo {
  final DioClient dioClient;

  WishListRepo({@required this.dioClient});

  Future<ApiResponse> getWishList() async {
    //dioClient.dio.options.headers["Authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNDRlOTBkYWI3NWUxODkxODM4MzRhYWU4MDA5YjZiYjExMTg3Yjc3ZGZlNmZmMGYyMWE5MjgxYmI4ZDAzNGQ0NTk0MzRmMDE5Mzg3MGIwMjQiLCJpYXQiOiIxNjIyMTI0NDQ2Ljk4NDk1NyIsIm5iZiI6IjE2MjIxMjQ0NDYuOTg0OTYyIiwiZXhwIjoiMTY1MzY2MDQ0Ni45ODA4NzMiLCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.e42O8pZzlCuaulUTs6-9kBSRV2N7nrTuVBdQZL6oyqvjgV9dJ2ER-HkfExIJKIm4cGBMaHxjgdl1Ibiz4IU-DKLVqOgvGJ6JKrtZJOfAgBGDp2lWfM1P-1qnZJY0OVjYebmXKSTv9meHv2OlhF_67eov3KIROuSnvgFMSXOWzYQxtvxnR0rjM-KKuw51tOSeJx2DWjO-z8WIXi5wFcAVOnLWQLWd-8CnhB629A-U9K5BySpkYOhX2gPAe0PdF3ybE-BCUESU-QvNvc_BnMw7lIiyIoQK1W63V6mBKvxwNgdJHjeFb_zANrhSSDlT5fx7YSZ1eJPTzZta9uTmFb1nJyVCH9pUGF9kntv0vv2B-cAEdEuIK6z8Xw5cOVY3VnkID8YsI90duPJv_WUDox5Qn-0e0YEthRDI-qamBIjX1dylewPNMi_9366pq2KSx5YX5D9H9QKfdhCVFKaxWknSXQOKIbo0KGZJlHPsDKyw0o22U4U4s4dRZIVLDRq3Az2bQNmd7ZqAvbyXlNCBG3lYcRTONDwWNgmpDIm-FjmqjtlmOlUSmILsUr5qItNkKdZDBsGBRgjL72omseRsAmb0d43trcOMPKE0RDW207W0tANw_lAQ8lUs9mMPep0lGjCGntRFi94nizdKDzOAlT3vBJ1dsC9lfYH7WEIsg1VowBE";
    try {
      final response = await dioClient.get(AppConstants.WISH_LIST_GET_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addWishList(int productID) async {
    try {
      final response = await dioClient
          .post(AppConstants.ADD_WISH_LIST_URI + productID.toString());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeWishList(int productID) async {
    try {
      final response = await dioClient
          .delete(AppConstants.REMOVE_WISH_LIST_URI + productID.toString());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
