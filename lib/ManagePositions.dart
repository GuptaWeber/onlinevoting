import 'package:flutter/material.dart';
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:polling/main.dart';
import 'dart:async';
import 'dart:convert';

import 'package:polling/screens/AddPosition.dart';

class ManagePositions extends StatefulWidget {
  ManagePositions(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _ManagePositionsState createState() => _ManagePositionsState();
}

class _ManagePositionsState extends State<ManagePositions> {
  Future<List<Position>> _getPositions() async {
    final url = Uri.parse('$SERVER_IP/candidate/getpositions');
    final headers = {"Content-type": "application/json"};

    var res = await http.get(url, headers: headers);

    var jsonData = json.decode(res.body);

    List<Position> positions = [];

    for (var p in jsonData) {
      Position position = Position(p["DISTINCT"]);
      positions.add(position);
    }

    print(positions.length);
    return positions;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Online Voting Application")),
      drawer: MyDrawer(widget.jwt, widget.payload),
      body: Container(
        child: Column(
          children: [
            FutureBuilder(
              future: _getPositions(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Text("Loading...."),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                        
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(snapshot.data[index].position);
                          return ListTile(
                            title: Text(snapshot.data[index].position),
                          );
                        }),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                height: 45,
                color: Colors.blue[600],
                child: new Text('Add New Position',
                    style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                onPressed: () async {

                  Route route = MaterialPageRoute(
                      builder: (c) => AddPosition(widget.jwt, widget.payload));

                  Navigator.push(context, route);


                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Position {
  final String position;

  Position(this.position);
}
