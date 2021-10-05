import 'package:flutter/material.dart';
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:polling/main.dart';
import 'package:polling/models/CandidateModel.dart';
import 'dart:async';
import 'dart:convert';

import 'package:polling/models/StatusModel.dart';
import 'package:polling/screens/CurrentPolls.dart';


class PollingCandidates extends StatefulWidget {
  PollingCandidates(this.jwt, this.payload, this.candidates);

  final String jwt;
  final Map<String, dynamic> payload;
  final List<Candidate> candidates;

  @override
  _PollingCandidatesState createState() => _PollingCandidatesState();
}

class _PollingCandidatesState extends State<PollingCandidates> {

  int toVote = 100;
  String sCandidateName;
  String sPosition;
  String sParty;
  int sId;
  bool isSelected = false;
  bool hasError = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Online Voting Application")),
      drawer: MyDrawer(widget.jwt, widget.payload),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(

                  itemCount: widget.candidates.length,
                  itemBuilder: (BuildContext context, int index) {

                    Candidate candidate = widget.candidates[index];

                    return ListTile(
                      title: Text(candidate.candidateName),
                      trailing: Radio(
                        value: index.toInt(),
                        groupValue: toVote,
                        onChanged: (val){

                          setState(() {
                            isSelected = true;
                            toVote = val;
                            sCandidateName = candidate.candidateName;
                            sParty = candidate.party;
                            sPosition = candidate.position;
                            sId = candidate.id;
                          });

                        },
                      ),
                    );
                  }),
            ),
            isSelected? Padding(
              padding: const EdgeInsets.all(15.0),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                height: 45,
                color: Colors.blue[600],
                child: new Text('Vote',
                    style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                onPressed: () async {

                  StatusModel voteStatus = await voteSomeone(sId, sCandidateName, sParty, sPosition, widget.payload["user"]["name"], widget.payload["user"]["id"]);

                  if(hasError){
                    displayDialog(context, "Error", voteStatus.error);
                  }else{

                    Timer(Duration(seconds: 2), ()=>displayDialog(context, "Success", "${voteStatus.success} for $sCandidateName") );

                    Route route = MaterialPageRoute(
                        builder: (c) => CurrentPolls(widget.jwt, widget.payload));

                    Navigator.push(context, route);
                  }

                },
              ),
            ) : Container(),
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

  Future<StatusModel> voteSomeone(
      int candidateId, String candidateName, String party, String position, String voterName, int votedBy) async {

    final url = Uri.parse('$SERVER_IP/votes/votesomeone'
        '');
    final headers = {"Content-type": "application/json"};
    final jsonBody =
        '{ "candidateId" : $candidateId,  "candidateName" : "$candidateName", "position" : "$position", "party" : "$party", "voterName": "$voterName", "votedBy": $votedBy}';

    var res = await http.post(url, headers: headers, body: jsonBody);

    if (res.statusCode == 201) {
      setState(() {
        hasError = false;
      });
      return statusModelFromJson(res.body);
    } else if (res.statusCode == 412) {
      setState(() {
        hasError = true;
      });
      print(res.body);
      return statusModelFromJson(res.body);
    }

    return null;
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
}

