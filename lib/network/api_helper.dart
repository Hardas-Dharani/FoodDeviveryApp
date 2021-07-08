// import 'dart:convert';
//
// import 'package:dio/dio.dart';
//
// import 'local_storage.dart';
// import 'logging_interceptor.dart';
//
// class ApiHelper {
//   Dio _dio;
//   BaseOptions options;
//
//   ApiHelper() {
//     options = BaseOptions(
//       connectTimeout: 20000,
//       receiveTimeout: 20000,
//     );
//     String authTOKEN;
//     _dio = Dio(options);
//     LocalStorage.getUserAuthToken().then((value) {
//       authTOKEN = "" + value;
//       print("x-access-token $authTOKEN");
//     });
//     options.baseUrl = "http://3.89.252.228:3001/api/";
//    // _dio.options.headers['content-Type'] = 'x-www-form-urlencoded';
//     _dio.options.headers['content-Type'] = 'application/json';
//
//
//
//     /*  if (authTOKEN != null) {
//       _dio.options.headers["x-access-token"] = authTOKEN;
//     }*/
//     _dio.interceptors.add(LoggingInterceptor());
// //    var token = isIos ? StringResourse.ios_jwt : StringResourse.android_jwt;
//   }
//
//   dynamic post({String apiUrl, FormData formData}) async {
//     try {
//       Response res = await _dio.post(apiUrl, data: formData);
//
//       print("statusCode${res.statusCode}");
//
//       return res.data;
//     } on DioError catch (e) {
//       //showDialog(false, "Internet is not Working");
//
//       _handleError(e);
//
//       throw Exception("Something wrong");
//     }
//   }
//
//   dynamic postImage({String apiUrl, FormData formData}) async {
//     try {
//       Response res = await _dio.post(apiUrl,
//           data: formData, options: Options(contentType: "multipart/form-data"));
//       print("statusCode${res.statusCode}");
//
//       return res.data;
//     } on DioError catch (e) {
//       //showDialog(false, "Internet is not Working");
//
//       _handleError(e);
//
//       throw Exception("Something wrong");
//     }
//   }
//
//   dynamic get({String apiUrl, FormData formData, String authToken}) async {
//     print("ApiUrl  $apiUrl");
//
//     if (authToken != null) {
//       _dio.options.headers["Authorization"] = "Bearer $authToken";
//     }
//
//     try {
//       Response res = await _dio.get(
//         apiUrl,
//       );
//
//       print("statusCode${res.statusCode}");
//       print("REPPPPP${json.decoder}");
//       return res.data;
//     } on DioError catch (e) {
//       //showDialog(false, "Internet is not Working");
//       print("Errrororororororororororororororo");
//       _handleError(e.error);
// //      if (e.error != null && e.response.data != null) {
// //        print(e.response.data);
// //
// //        //return LoginResponse.fromJson(e.response.data);
// //      } else {
// //        print(e.request);
// //        print(e.message);
// //      }
//     }
//   }
//
//   dynamic delete({String apiUrl, String authToken}) async {
//     try {
//       Response res = await _dio.delete(
//         apiUrl,
//       );
//
//       print("statusCode${res.statusCode}");
//
//       return res.statusCode;
//     } on DioError catch (e) {
//       //showDialog(false, "Internet is not Working");
//       _handleError(e);
//
//       throw Exception("Something wrong");
//     }
//   }
//
//   dynamic patch({
//     String apiUrl,
//     FormData formData,
//   }) async {
//     try {
//       Response res = await _dio.patch(apiUrl, data: formData);
//
//       print("statusCode${res.statusCode}");
//
//       return res.data;
//     } on DioError catch (e) {
//       //showDialog(false, "Internet is not Working");
//
//       _handleError(e);
//
//       throw Exception("Something wrong");
//     }
//   }
//
//
// }
