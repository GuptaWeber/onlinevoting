import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polling/HomePage.dart';
import 'package:polling/login.dart';
import 'package:polling/main.dart';
import 'package:http/http.dart';
import 'package:polling/models/ErrorModel.dart';
import 'dart:convert' show json, base64, ascii;

import 'package:polling/models/UserModel.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  String name;
  String aadhar;
  String voterId;
  String password;
  String email;
  bool hasError;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue[800], Colors.blue[600]],
                begin: Alignment.topLeft,
                end: Alignment.centerRight),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 36.0, horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Signup",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 46.0,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Vote for a better Society!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )),
              Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    nameField(),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    emailField(),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    aadharField(),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    voterField(),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    passwordField(),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    submitButton(),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              height: 45,
                              color: Colors.blue[600],
                              child: new Text('Login',
                                  style: new TextStyle(
                                      fontSize: 16.0, color: Colors.white)),
                              onPressed: () async {
                                Route route = MaterialPageRoute(
                                    builder: (c) => LoginPage());

                                Navigator.push(context, route);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget nameField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Color(0xFFe7edeb),
          hintText: "Name",
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey[600],
          )),
      onSaved: (value) => setState(() => name = value.trim()),
      validator: (value) {
        if (value.length < 3) {
          return "Name must be more than 3 characters";
        } else if (value.length == 0) {
          return "Name must not be empty!";
        } else {
          return null;
        }
      },
    );
  }

  Widget emailField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Color(0xFFe7edeb),
          hintText: "Email",
          prefixIcon: Icon(
            Icons.email,
            color: Colors.grey[600],
          )),
      onSaved: (value) => setState(() => email = value.trim()),
      validator: (value) {
        bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value);
        if (!emailValid) {
          return "Please Enter Valid Email Address";
        } else if (value.length == 0) {
          return "Email must not be empty!";
        } else {
          return null;
        }
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Color(0xFFe7edeb),
          hintText: "Password",
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.grey[600],
          )),
      onSaved: (value) => setState(() => password = value.trim()),
      validator: (value) {
        if (value.length < 6) {
          return "Password must be more than 6 characters";
        } else if (value.length == 0) {
          return "Password must not be empty!";
        } else {
          return null;
        }
      },
    );
  }

  Widget aadharField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Color(0xFFe7edeb),
          hintText: "Aadhar ID",
          prefixIcon: Icon(
            Icons.perm_identity,
            color: Colors.grey[600],
          )),
      onSaved: (value) => setState(() => aadhar = value.trim()),
      validator: (value) {
        if (value.length < 6) {
          return "Aadhar must be more than 6 characters";
        } else if (value.length == 0) {
          return "Aadhar must not be empty!";
        } else {
          return null;
        }
      },
    );
  }

  Widget voterField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Color(0xFFe7edeb),
          hintText: "Voter ID",
          prefixIcon: Icon(
            Icons.how_to_vote,
            color: Colors.grey[600],
          )),
      onSaved: (value) => setState(() => voterId = value.trim()),
      validator: (value) {
        if (value.length < 6) {
          return "Voter ID must be more than 6 characters";
        } else if (value.length == 0) {
          return "Voter ID must not be empty!";
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
      child: new Text('Signup',
          style: new TextStyle(fontSize: 16.0, color: Colors.white)),
      onPressed: () async {
        final isValid = formKey.currentState.validate();

        if (isValid) {
          formKey.currentState.save();

          final UserModel user =
              await attemptSignup(email, password, name, voterId, aadhar);
          if (user != null) {
            if (hasError) {
              print(user.error);
              displayDialog(context, "Error Message", user.error);
            } else {
              Timer(Duration(seconds: 3), () {
                displayDialog(context, "Success Message",
                    "Account has been created Successfully");
              });

              Route route = MaterialPageRoute(builder: (c) => LoginPage());

              Navigator.push(context, route);
            }
          } else {
            displayDialog(context, "An Error Occurred",
                "No account was found matching that username and password");
          }
        }
      },
    );
  }

  Future<UserModel> attemptSignup(String emailText, String passwordText,
      String nameText, String voterText, String aadharText) async {
    bool is_admin = false;
    bool has_voted = false;
    final url = Uri.parse('$SERVER_IP/users/signup');
    final headers = {"Content-type": "application/json"};
    final jsonBody =
        '{"email" : "$emailText", "name":"$nameText", "password" : "$passwordText", "aadhar_id": "$aadharText", "voter_id":"$voterText", "is_admin": "$is_admin", "has_voted": "$has_voted"}';

    print(jsonBody);

    var res = await post(url, headers: headers, body: jsonBody);

    if (res.statusCode == 201) {
      setState(() {
        hasError = false;
      });
      return userModelFromJson(res.body);
    } else if (res.statusCode == 412) {
      setState(() {
        hasError = true;
      });
      return userModelFromJson(res.body);
    }

    return null;
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<UserModel> attemptLogIn(String username, String password) async {
    final url = Uri.parse('$SERVER_IP/users/login');
    final headers = {"Content-type": "application/json"};
    final jsonBody = '{"email" : "$username", "password" : "$password" }';

    var res = await post(url, headers: headers, body: jsonBody);

    if (res.statusCode == 200) return userModelFromJson(res.body);
    return null;
  }
}
