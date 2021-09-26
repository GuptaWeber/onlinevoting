import 'package:flutter/material.dart';
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:polling/main.dart';
import 'package:polling/screens/AddCandidate.dart';
import 'dart:async';
import 'dart:convert';

import 'package:polling/screens/AddPosition.dart';

class ManageCandidates extends StatefulWidget {
  ManageCandidates(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _ManageCandidatesState createState() => _ManageCandidatesState();
}

class _ManageCandidatesState extends State<ManageCandidates> {

  Future<List<Candidate>> _getPositions() async {
    final url = Uri.parse('$SERVER_IP/candidate/getcandidates');
    final headers = {"Content-type": "application/json"};

    var res = await http.get(url, headers: headers);

    var jsonData = json.decode(res.body);

    List<Candidate> candidates = [];

    for (var c in jsonData) {
      Candidate candidate = Candidate(c["position"], c["candidateName"], c["party"]);
      candidates.add(candidate);
    }

    return candidates;
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
                            title: Text(snapshot.data[index].candidateName),
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
                child: new Text('Add New Candidate',
                    style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                onPressed: () async {

                  List <String> positions = await getPositions();

                  Route route = MaterialPageRoute(
                      builder: (c) => AddCandidate(widget.jwt, widget.payload, positions));

                  Navigator.push(context, route);


                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getPositions() async {
    final url = Uri.parse('$SERVER_IP/candidate/getpositionsarray');
    final headers = {"Content-type": "application/json"};
    var res = await http.get(url, headers: headers);
    List positionsArray = jsonDecode(res.body);
    List<String> positions = [];

    for(var i = 0; i<positionsArray.length; i++){
      positions.add(positionsArray[i].toString());
    }

    return positions;
  }
}

class Candidate {
  final String position;
  final String candidateName;
  final String party;

  Candidate(this.position, this.candidateName, this.party);
}
