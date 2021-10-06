import 'package:flutter/material.dart';
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:polling/main.dart';
import 'dart:async';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:polling/screens/ResultDetails.dart';

class CheckResults extends StatefulWidget {
  CheckResults(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _CheckResultsState createState() => _CheckResultsState();
}

class _CheckResultsState extends State<CheckResults> {
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
                            title: Text(
                              snapshot.data[index].position,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () async {
                              print(snapshot.data[index].position);

                              List<Vote> votes = await _getVotesByPosition(
                                  snapshot.data[index].position);

                              if(votes.length != 0){
                                Route route = MaterialPageRoute(
                                    builder: (c) => ResultDetails(
                                      widget.jwt,
                                      widget.payload,
                                      _createSampleVotesData(votes),
                                      animate: true,
                                    ));

                                Navigator.push(context, route);
                              }else{
                                displayDialog(context, "Error", "No Candidates for that Position");
                              }


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

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  /// Create one series with sample hard coded data.
  static List<charts.Series<Vote, String>> _createSampleVotesData(List<Vote> votes) {
    final data = votes;

    return [
      new charts.Series<Vote, String>(
        id: 'Votes',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Vote vote, _) => vote.candidateName,
        measureFn: (Vote vote, _) => vote.votes,
        data: data,
      )
    ];
  }

  Future<List<Vote>> _getVotesByPosition(String position) async {
    final url = Uri.parse('$SERVER_IP/votes/votesbyposition/' + position);
    final headers = {"Content-type": "application/json"};

    var res = await http.get(url, headers: headers);

    var jsonData = json.decode(res.body);

    List<Vote> votesByPosition = [];

    for (var v in jsonData) {
      Vote vote = Vote(v["candidateName"], v["votes"]);
      votesByPosition.add(vote);
    }

    return votesByPosition;
  }
}

class Vote {
  final String candidateName;
  final int votes;

  Vote(this.candidateName, this.votes);
}

class Position {
  final String position;

  Position(this.position);
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
