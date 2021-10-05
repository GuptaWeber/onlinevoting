import 'package:flutter/material.dart';
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:polling/main.dart';
import 'package:polling/models/UserModel.dart';
import 'dart:async';
import 'dart:convert';

class ManageAdmins extends StatefulWidget {
  ManageAdmins(this.jwt, this.payload, this.users);

  final String jwt;
  final Map<String, dynamic> payload;
  List<UserModel> users;

  @override
  _ManageAdminsState createState() => _ManageAdminsState(this.users);
}

class _ManageAdminsState extends State<ManageAdmins> {

  _ManageAdminsState(List<UserModel> users){
    this.users = users;
  }

  List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Online Voting Application")),
      drawer: MyDrawer(widget.jwt, widget.payload),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
            ...users.map(buildSingleCheckbox).toList(),
        ],
      ),
    );
  }

  // Future<List> _getAdminStatus() async {
  //   final url = Uri.parse('$SERVER_IP/users/getadminstatus');
  //   final headers = {"Content-type": "application/json"};
  //
  //   var res = await http.get(url, headers: headers);
  //
  //   var jsonData = json.decode(res.body);
  //
  //   return jsonData;
  // }

  Future _updateAdminStatus(int id, bool status) async {
    final url = Uri.parse('$SERVER_IP/users/updateadmin/'+ id.toString() + '/' + status.toString());
    final headers = {"Content-type": "application/json"};

    var res = await http.get(url, headers: headers);

    return null;
  }

  Widget buildSingleCheckbox(UserModel checkbox) => CheckboxListTile(
    value: checkbox.isAdmin,
    onChanged: (value) async {
      _updateAdminStatus(checkbox.id, value);

      if(value){
        displayDialog(context, "Success", checkbox.name + " is now an Admin");
      }else{
        displayDialog(context, "Success", checkbox.name + " is not an admin anymore!");
      }

      setState(() => checkbox.isAdmin = value);
    } ,
    title: Text(
      checkbox.name
    ),
  );

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

}
