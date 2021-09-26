import 'package:flutter/material.dart';
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:polling/main.dart';
import 'dart:async';
import 'package:polling/models/StatusModel.dart';
import 'package:polling/models/UserModel.dart';
import 'package:polling/screens/ManageCandidates.dart';

class UpdateProfile extends StatefulWidget {
  UpdateProfile(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final formKey = GlobalKey<FormState>();
  String userName;
  String voterId;
  String position;
  bool hasError;

  Future<UserModel> _getProfileDetails() async {
    print(widget.payload['user']['id'].toString());
    final url = Uri.parse(
        '$SERVER_IP/users/profile/' + widget.payload['user']['id'].toString());
    print(url);
    final headers = {"Content-type": "application/json"};

    var res = await http.get(url, headers: headers);
    print(res.body);

    return userModelFromJson(res.body);
  }

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
            FutureBuilder(
              future: _getProfileDetails(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  String tempName = snapshot.data.name;
                  String tempEmail = snapshot.data.email;
                  String aadharNumber = snapshot.data.aadhar;
                  String tempVoterId = snapshot.data.voterId;
                  print(snapshot.data.aadhar);
                  return Expanded(
                    child: Container(
                        child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    userNameField(tempName),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    emailField(tempEmail),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    aadharField(aadharNumber),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    voterField(tempVoterId),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    submitButton(),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    )),
                  );
                } else {
                  return Container(
                    child: Text("Loading...."),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget userNameField(String tempName) {
    print(tempName);
    return TextFormField(
      initialValue: tempName,
      decoration:
          InputDecoration(labelText: 'User Name', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => userName = value.trim()),
      validator: (value) {
        if (value.length == 0) {
          return "Username must not be empty!";
        } else {
          return null;
        }
      },
    );
  }

  Widget emailField(String tempEmail) {
    return TextFormField(
      initialValue: tempEmail,
      readOnly: true,
      decoration: InputDecoration(
          labelText: 'Email', border: OutlineInputBorder()),
    );
  }

  Widget aadharField(String tempAadhar) {
    return TextFormField(
      initialValue: tempAadhar,
      readOnly: true,
      decoration: InputDecoration(
          labelText: 'Aadhar Number', border: OutlineInputBorder()),
    );
  }

  Widget voterField(String tempVoter) {
    return TextFormField(
      initialValue: tempVoter,
      readOnly: true,
      decoration: InputDecoration(
          labelText: 'Voter Id', border: OutlineInputBorder()),
    );
  }

  Widget submitButton() {
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      height: 45,
      color: Colors.blue[600],
      child: new Text('Update Profile',
          style: new TextStyle(fontSize: 16.0, color: Colors.white)),
      onPressed: () async {
        final isValid = formKey.currentState.validate();

        if (isValid) {
          formKey.currentState.save();
          StatusModel status = await UpdateProfileAPI(userName.trim());
          if (status.error != null) {
            displayDialog(context, "Error", status.error);
          } else {
            displayDialog(context, "Success", status.success);
            print(status.success);

          }
        }
      },
    );
  }

  Future<StatusModel> UpdateProfileAPI(
      String nameText) async {

    final url = Uri.parse('$SERVER_IP/users/profile/'+widget.payload['user']['id'].toString());
    final headers = {"Content-type": "application/json"};
    final jsonBody = '{ "user" : "$nameText"}';

    var res = await http.post(url, headers: headers, body: jsonBody);

    // if (res.statusCode == 201) {
    //   setState(() {
    //     hasError = false;
    //   });
    //   return statusModelFromJson(res.body);
    // } else if (res.statusCode == 412) {
    //   setState(() {
    //     hasError = true;
    //   });
    //   print(res.body);
    //   return statusModelFromJson(res.body);
    // }
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
