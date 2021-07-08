// To parse this JSON data, do
//
//     final feedBackApi = feedBackApiFromJson(jsonString);

import 'dart:convert';

FeedBackApi feedBackApiFromJson(String str) => FeedBackApi.fromJson(json.decode(str));

String feedBackApiToJson(FeedBackApi data) => json.encode(data.toJson());

class FeedBackApi {
  FeedBackApi({
    this.message,
  });

  String message;

  factory FeedBackApi.fromJson(Map<String, dynamic> json) => FeedBackApi(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
