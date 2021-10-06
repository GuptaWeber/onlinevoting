import 'package:flutter/material.dart';
import 'package:polling/ManagePositions.dart';
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:polling/main.dart';
import 'package:polling/models/UserModel.dart';
import 'package:http/http.dart' as http;
import 'package:polling/screens/CheckResults.dart';
import 'package:polling/screens/CurrentPolls.dart';
import 'dart:async';
import 'dart:convert';

import 'package:polling/screens/ManageAdmins.dart';
import 'package:polling/screens/ManageCandidates.dart';
import 'package:polling/screens/UpdatePassword.dart';
import 'package:polling/screens/UpdateProfile.dart';

class HomePage extends StatefulWidget {
  HomePage(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var cardTextStyle = TextStyle(
      fontFamily: "Montserrat Regular",
      fontSize: 16,
    );

    return Scaffold(
        appBar: AppBar(title: Text("Online Voting Application")),
        drawer: MyDrawer(widget.jwt, widget.payload),
        body: Stack(
          children: [
            Container(
              height: size.height * 30,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage('assets/images/wave.png'))),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      height: 64,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Welcome, " + widget.payload["user"]["name"],
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Montserrat Medium',
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      primary: false,
                      children: [
                        widget.payload['user']['is_admin'] == true? InkWell(
                          onTap: () async {
                            List<UserModel> users = await _getUsers();

                            Route route = MaterialPageRoute(
                                builder: (c) => ManageAdmins(
                                    widget.jwt, widget.payload, users));
                            Navigator.push(context, route);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.supervised_user_circle_rounded,
                                  size: 70,
                                  color: const Color.fromRGBO(0, 153, 255, 1),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Manage Admins", style: cardTextStyle, textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        ) : InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(builder: (c) => CurrentPolls(widget.jwt, widget.payload));

                            Navigator.push(
                                context,
                                route
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.poll,
                                  size: 70,
                                  color: const Color.fromRGBO(0, 153, 255, 1),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Current Polls", style: cardTextStyle, textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        ),
                        widget.payload['user']['is_admin'] == true? InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (c) => ManagePositions(
                                    widget.jwt, widget.payload));

                            Navigator.push(context, route);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 70,
                                  color: const Color.fromRGBO(0, 153, 255, 1),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Manage Positions", style: cardTextStyle, textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        ) : Container(),
                        InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (c) =>
                                    UpdateProfile(widget.jwt, widget.payload));

                            Navigator.push(context, route);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 70,
                                  color: const Color.fromRGBO(0, 153, 255, 1),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Update Profile", style: cardTextStyle, textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (c) =>
                                    UpdatePassword(widget.jwt, widget.payload));

                            Navigator.push(context, route);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 70,
                                  color: const Color.fromRGBO(0, 153, 255, 1),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Update Password",
                                  style: cardTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        widget.payload['user']['is_admin'] == true? InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (c) => ManageCandidates(
                                    widget.jwt, widget.payload));

                            Navigator.push(context, route);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_add,
                                  size: 70,
                                  color: const Color.fromRGBO(0, 153, 255, 1),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Manage Candidates",
                                  style: cardTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ): Container(),
                        widget.payload['user']['is_admin'] == true? InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (c) =>
                                    CheckResults(widget.jwt, widget.payload));

                            Navigator.push(context, route);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.poll,
                                  size: 70,
                                  color: const Color.fromRGBO(0, 153, 255, 1),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Check Results", style: cardTextStyle, textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        ) : Container(),

                      ],
                    ))
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<List<UserModel>> _getUsers() async {
    final url = Uri.parse('$SERVER_IP/users/getusers');
    final headers = {"Content-type": "application/json"};

    var res = await http.get(url, headers: headers);

    var jsonData = json.decode(res.body);

    List<UserModel> users = [];

    for (var u in jsonData) {
      UserModel user = UserModel.fromJson(u);
      users.add(user);
    }

    return users;
  }
}
