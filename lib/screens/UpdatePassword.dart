import 'package:flutter/material.dart';
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:polling/main.dart';
import 'dart:async';
import 'package:polling/models/StatusModel.dart';

class UpdatePassword extends StatefulWidget {
  UpdatePassword(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final formKey = GlobalKey<FormState>();
  String currentPasswordString;
  String newPass;
  String confirmPass;
  bool hasError;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Online Voting Application")),
      drawer: MyDrawer(widget.jwt, widget.payload),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Update Profile",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child:
                      Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              currentPassword(),
                              SizedBox(
                                height: 15.0,
                              ),
                              newPassword(),
                              SizedBox(
                                height: 15.0,
                              ),
                              confirmPassword(),
                              SizedBox(
                                height: 15.0,
                              ),
                              submitButton(),
                            ],
                          ))

                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget currentPassword() {

    return TextFormField(
      obscureText: true,
      decoration:
      InputDecoration(labelText: 'Current Password', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => currentPasswordString = value.trim()),
      validator: (value) {
        if (value.length == 0) {
          return "Password must not be empty!";
        } else {
          return null;
        }
      },
    );
  }

  Widget newPassword() {
    return TextFormField(
      obscureText: true,
      decoration:
      InputDecoration(labelText: 'New Password', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => newPass = value.trim()),
      validator: (value) {
        if (value.length == 0) {
          return "New Password must not be empty!";
        } else {
          return null;
        }
      },
    );
  }

  Widget confirmPassword() {
    return TextFormField(
      obscureText: true,
      decoration:
      InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => confirmPass = value.trim()),
      validator: (value) {
        if (value.length == 0) {
          return "Confirm Password must not be empty!";
        } else {
          return null;
        }
      },
    );
  }


  Widget submitButton() {
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      height: 45,
      color: Colors.blue[600],
      child: new Text('Update Password',
          style: new TextStyle(fontSize: 16.0, color: Colors.white)),
      onPressed: () async {
        final isValid = formKey.currentState.validate();

        if (isValid) {
          formKey.currentState.save();
          print(currentPasswordString);

          if(newPass != confirmPass){
            displayDialog(context, "Error", "New Password & Confirm Password didn't match");
          }else{
            StatusModel status = await UpdatePasswordAPI(currentPasswordString, confirmPass);
            if (hasError) {
              displayDialog(context, "Error", status.error);
            } else {
              displayDialog(context, "Success", status.success);
              print(status.success);
            }
          }

        }
      },
    );
  }

  Future<StatusModel> UpdatePasswordAPI(
      String currentP, String confirmP) async {

    final url = Uri.parse('$SERVER_IP/users/updatepassword/'+widget.payload['user']['id'].toString() + '/$currentP' + '/$confirmP' );
    final headers = {"Content-type": "application/json"};

    var res = await http.get(url, headers: headers,);

    print(res);

    if (res.statusCode == 200) {
      setState(() {
        hasError = false;
      });
      return statusModelFromJson(res.body);
    } else if (res.statusCode == 401) {
      setState(() {
        hasError = true;
      });
      print(res.body);
      return statusModelFromJson(res.body);
    }
    print(res.body);
    return null;
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
}
