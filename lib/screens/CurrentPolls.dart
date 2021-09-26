import 'package:flutter/material.dart';
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:polling/main.dart';
import 'package:polling/models/CandidateModel.dart';
import 'dart:async';
import 'dart:convert';

import 'package:polling/screens/PollingCandidates.dart';

class CurrentPolls extends StatefulWidget {
  CurrentPolls(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _CurrentPollsState createState() => _CurrentPollsState();
}

class _CurrentPollsState extends State<CurrentPolls> {
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
                            title: Text(snapshot.data[index].position, style: TextStyle( fontWeight: FontWeight.w600 ),),
                            trailing: Icon(
                              Icons.arrow_forward_ios
                            ),
                            onTap: () async {
                              print(snapshot.data[index]);
                             List <Candidate> candidates = await _getCandidatesByPositions(snapshot.data[index].position);

                              Route route = MaterialPageRoute(
                                  builder: (c) => PollingCandidates(widget.jwt, widget.payload, candidates));

                              Navigator.push(context, route);

                            },
                          );
                        }),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Candidate>> _getCandidatesByPositions(String position) async {
    final url = Uri.parse('$SERVER_IP/candidate/getcandidates/$position');
    final headers = {"Content-type": "application/json"};

    var res = await http.get(url, headers: headers);

    var jsonData = json.decode(res.body);

    List<Candidate> candidates = [];

    for (var c in jsonData) {
      Candidate candidate = Candidate(c["position"], c["candidateName"], c["party"], c["id"]);
      candidates.add(candidate);
    }

    return candidates;
  }

}

class Position {
  final String position;

  Position(this.position);
}

