// To parse this JSON data, do
//
//     final successModel = successModelFromJson(jsonString);

import 'dart:convert';

SuccessModel successModelFromJson(String str) => SuccessModel.fromJson(json.decode(str));

String successModelToJson(SuccessModel data) => json.encode(data.toJson());

class SuccessModel {
  SuccessModel({
    this.success,
  });

  String success;

  factory SuccessModel.fromJson(Map<String, dynamic> json) => SuccessModel(
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
  };
}
