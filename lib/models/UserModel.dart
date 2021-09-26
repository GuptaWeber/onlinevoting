// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.token,
    this.name,
    this.email,
    this.aadhar,
    this.voterId,
    this.isAdmin,
    this.hasVoted,
    this.error,
    this.success,
  });

  String token;
  String name;
  String email;
  String aadhar;
  String voterId;
  bool isAdmin;
  bool hasVoted;
  String error;
  String success;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    token: json["token"],
    name: json["name"],
    email: json["email"],
    aadhar: json["aadhar"],
    voterId: json["voter_id"],
    isAdmin: json["isAdmin"],
    hasVoted: json["hasVoted"],
    error: json["error"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "name": name,
    "email": email,
    "aadhar_id": aadhar,
    "voterId": voterId,
    "isAdmin": isAdmin,
    "hasVoted": hasVoted,
    "error": error,
    "success": success,
  };
}
