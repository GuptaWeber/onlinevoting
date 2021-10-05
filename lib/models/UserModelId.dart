// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModelId userModelFromJson(String str) => UserModelId.fromJson(json.decode(str));

String userModelToJson(UserModelId data) => json.encode(data.toJson());

class UserModelId {
  UserModelId({
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

  factory UserModelId.fromJson(Map<String, dynamic> json) => UserModelId(
    token: json["token"],
    name: json["name"],
    email: json["email"],
    aadhar: json["aadhar_id"],
    voterId: json["voter_id"],
    isAdmin: json["is_admin"],
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
