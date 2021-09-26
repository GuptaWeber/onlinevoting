import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:http/http.dart' as http;
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:polling/main.dart';

class HomePage extends StatefulWidget {

  HomePage(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();
    fetchValues();
  }

  void fetchValues () async {

     final name = await storage.read(key: "name");

     final email = await storage.read(key: "email");

     final hasVoted = await storage.read(key: "hasVoted");

     print(name + email + hasVoted);
     print(await storage.read(key: "jwt"));
     print(widget.payload["user"]["id"]);
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: Text("Online Voting Application")),
        drawer: MyDrawer(widget.jwt, widget.payload),
        body: Center(

          child: Container(
            child: Column(
              children: [
                Text(
                  "You're safe at Home"
                ),
                Text(
                  " Name : ${widget.payload['user']['name']}"
                ),
                Text(
                  "Email : ${widget.payload['user']['email']}"
                ),
                Text(
                  "hasVoted: ${widget.payload['user']['has_voted']}"
                )
              ],
            ),
          ),

          // child: FutureBuilder(
          //     future: http.read('$SERVER_IP/data', headers: {"Authorization": jwt}),
          //     builder: (context, snapshot) =>
          //     snapshot.hasData ?
          //     Column(children: <Widget>[
          //       Text("${payload['username']}, here's the data:"),
          //       Text(snapshot.data, style: Theme.of(context).textTheme.display1)
          //     ],)
          //         :
          //     snapshot.hasError ? Text("An error occurred") : CircularProgressIndicator()
          // ),
        ),
      );
}