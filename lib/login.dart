import 'package:flutter/material.dart';
import 'package:polling/HomePage.dart';
import 'package:polling/main.dart';
import 'package:http/http.dart';
import 'dart:convert' show json, base64, ascii;

import 'package:polling/models/UserModel.dart';
import 'package:polling/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {



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
                          "Login",
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
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none
                              ),
                              filled: true,
                              fillColor: Color(0xFFe7edeb),
                              hintText: "Voter Id",
                              prefixIcon: Icon(Icons.email, color: Colors.grey[600],)
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none
                                ),
                                filled: true,
                                fillColor: Color(0xFFe7edeb),
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock, color: Colors.grey[600],)
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            height: 45,
                            color: Colors.blue[600],
                            child: new Text('Login',
                                style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                            onPressed: () async {
                              var username = _usernameController.text;
                              var password = _passwordController.text;

                              final UserModel user = await attemptLogIn(username, password);
                              if(user != null) {

                                print(user.token);
                                print(user.toJson());
                                storage.write(key: "jwt", value: user.token);
                                storage.write(key: "name", value: user.name);
                                storage.write(key: "email", value: user.email);
                                storage.write(key: "isAdmin", value: user.isAdmin.toString());
                                storage.write(key: "hasVoted", value: user.hasVoted.toString());
                                storage.write(key: "aadhar", value: user.aadhar);
                                storage.write(key: "voterId", value: user.voterId);

                                print(await storage.read(key: "hasVoted"));

                                var jwt_str =user.token.split(".");

                                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt_str[1]))));


                                Route route = MaterialPageRoute(builder: (c) => HomePage(user.token, payload));

                                Navigator.push(
                                    context,
                                    route
                                );
                              } else {
                                displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                              }
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            height: 45,
                            color: Colors.blue[600],
                            child: new Text('Create New Account',
                                style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                            onPressed: () async {


                                Route route = MaterialPageRoute(builder: (c) => SignupPage());

                                Navigator.push(
                                    context,
                                    route
                                );

                            },
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
                title: Text(title),
                content: Text(text)
            ),
      );

  Future<UserModel> attemptLogIn(String username, String password) async {

    final url = Uri.parse('$SERVER_IP/users/login');
    final headers = {"Content-type": "application/json"};
    final jsonBody = '{"email" : "$username", "password" : "$password" }';

    var res = await post(
        url,
        headers: headers,
        body: jsonBody
        );

    if(res.statusCode == 200) return userModelFromJson(res.body);
    return null;
  }
}
