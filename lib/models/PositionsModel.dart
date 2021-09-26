// To parse this JSON data, do
//
//     final positionsModel = positionsModelFromJson(jsonString);

import 'dart:convert';

List<PositionsModel> positionsModelFromJson(String str) => List<PositionsModel>.from(json.decode(str).map((x) => PositionsModel.fromJson(x)));

String positionsModelToJson(List<PositionsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PositionsModel {
  PositionsModel({
    this.distinct,
  });

  String distinct;

  factory PositionsModel.fromJson(Map<String, dynamic> json) => PositionsModel(
    distinct: json["DISTINCT"],
  );

  Map<String, dynamic> toJson() => {
    "DISTINCT": distinct,
  };
}
