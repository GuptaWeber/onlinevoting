import 'package:flutter/material.dart';
import 'package:polling/HomePage.dart';
import 'package:polling/ManagePositions.dart';
import 'package:polling/Widgets/my_header_drawer.dart';
import 'package:polling/login.dart';
import 'package:polling/main.dart';
import 'package:polling/models/UserModel.dart';
import 'package:polling/screens/CheckResults.dart';
import 'package:polling/screens/CurrentPolls.dart';
import 'package:polling/screens/ManageAdmins.dart';
import 'package:polling/screens/ManageCandidates.dart';
import 'package:polling/screens/UpdatePassword.dart';
import 'package:polling/screens/UpdateProfile.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MyDrawer extends StatefulWidget {
  MyDrawer(this.jwt, this.payload);
  final String jwt;
  final Map<String, dynamic> payload;
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  @override
  Widget build(BuildContext context) {
    print(widget.payload['user']['is_admin']);
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              MyHeaderDrawer(widget.jwt, widget.payload),
              MyDrawerList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(),
          Divider(),
          widget.payload['user']['is_admin'] == true? manageAdmins() : Container(),
          widget.payload['user']['is_admin'] == true? Divider() : Container(),
          widget.payload['user']['is_admin'] == true? managePositions() : Container(),
          widget.payload['user']['is_admin'] == true? Divider() : Container(),
          widget.payload['user']['is_admin'] == true? manageCandidates() : Container(),
          widget.payload['user']['is_admin'] == true? Divider() : Container(),
          widget.payload['user']['is_admin'] == true? checkResults() : Container(),
          widget.payload['user']['is_admin'] == true? Divider() : Container(),
          widget.payload['user']['is_admin'] == false? currentPolls() : Container(),
          widget.payload['user']['is_admin'] == false? Divider() : Container(),
          updateProfile(),
          Divider(),
          updatePassword(),
          Divider(),
          logoutScreen(),
          Divider(),
        ],
      ),
    );
  }

  Widget menuItem() {
    return Material(
      child: InkWell(
        onTap: () {
          Route route = MaterialPageRoute(builder: (c) => HomePage(widget.jwt, widget.payload));

          Navigator.push(
              context,
              route
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                Icons.dashboard_outlined,
                size: 20,
                color: Colors.black,
              )),
              Expanded(
                flex: 3,
                child: Text(
                  "Dashboard",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget manageAdmins() {
    return Material(
      child: InkWell(
        onTap: () async {

          List<UserModel> users = await _getUsers();

          Route route = MaterialPageRoute(builder: (c) => ManageAdmins(widget.jwt, widget.payload, users));
          Navigator.push(
              context,
              route
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                    Icons.supervised_user_circle_rounded,
                    size: 20,
                    color: Colors.black,
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  "Manage Admins",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget managePositions() {
    return Material(
      child: InkWell(
        onTap: () {
          Route route = MaterialPageRoute(builder: (c) => ManagePositions(widget.jwt, widget.payload));

          Navigator.push(
              context,
              route
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.black,
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  "Manage Positions",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget manageCandidates() {
    return Material(
      child: InkWell(
        onTap: () {

          Route route = MaterialPageRoute(builder: (c) => ManageCandidates(widget.jwt, widget.payload));

          Navigator.push(
              context,
              route
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                    Icons.person_add,
                    size: 20,
                    color: Colors.black,
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  "Manage Candidates",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget checkResults() {
    return Material(
      child: InkWell(
        onTap: () {

          Route route = MaterialPageRoute(builder: (c) => CheckResults(widget.jwt, widget.payload));

          Navigator.push(
              context,
              route
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                    Icons.poll,
                    size: 20,
                    color: Colors.black,
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  "Check Results",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget currentPolls() {
    return Material(
      child: InkWell(
        onTap: () {
          Route route = MaterialPageRoute(builder: (c) => CurrentPolls(widget.jwt, widget.payload));

          Navigator.push(
              context,
              route
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                    Icons.poll,
                    size: 20,
                    color: Colors.black,
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  "Current Polls",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget updateProfile() {
    return Material(
      child: InkWell(
        onTap: () {

          Route route = MaterialPageRoute(builder: (c) => UpdateProfile(widget.jwt, widget.payload));

          Navigator.push(
              context,
              route
          );

        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.black,
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  "Profile",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget updatePassword() {
    return Material(
      child: InkWell(
        onTap: () {

          Route route = MaterialPageRoute(builder: (c) => UpdatePassword(widget.jwt, widget.payload));

          Navigator.push(
              context,
              route
          );

        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.black,
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  "Update Password",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logoutScreen() {
    return Material(
      child: InkWell(
        onTap: () {
          _logout();
          Route route = MaterialPageRoute(builder: (c) => LoginPage());

          Navigator.push(
              context,
              route
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                    Icons.exit_to_app,
                    size: 20,
                    color: Colors.black,
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    /// Method to Logout the User
    print("Logout ");
    try {
      // signout code
      await storage.deleteAll();
    } catch (e) {
      print(e.toString());
    }
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
