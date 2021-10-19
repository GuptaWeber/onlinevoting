import 'package:flutter/material.dart';
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:polling/main.dart';
import 'dart:async';
import 'package:polling/models/StatusModel.dart';
import 'package:polling/screens/ManageCandidates.dart';

class AddCandidate extends StatefulWidget {
  AddCandidate(this.jwt, this.payload, this.positions);

  final String jwt;
  final Map<String, dynamic> payload;
  final List<String> positions;

  @override
  _AddCandidateState createState() => _AddCandidateState();
}

class _AddCandidateState extends State<AddCandidate> {
  final formKey = GlobalKey<FormState>();
  String candidateName;
  String party;
  String position;
  List<String> partys = ["YSRCP", "BJP", "CONGRESS", "TDP", "JSP"];
  bool hasError;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Online Voting Application")),
      drawer: MyDrawer(widget.jwt, widget.payload),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Add A Candidate",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            candidateNameField(),
                            SizedBox(
                              height: 15.0,
                            ),
                            partyDropDown(),
                            SizedBox(
                              height: 15.0,
                            ),
                            positionDropDown(),
                            SizedBox(
                              height: 15.0,
                            ),
                            submitButton(),
                          ],
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget candidateNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Candidate Name', border: OutlineInputBorder()),
      onSaved: (value) => setState(() => candidateName = value.trim()),
      validator: (value) {
        if (value.length == 0) {
          return "Candidate Name must not be empty!";
        } else {
          return null;
        }
      },
    );
  }

  Widget partyDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Party : ",
          style: TextStyle(fontSize: 20),
        ),
        DropdownButton<String>(
          value: party,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (newValue) {
            setState(() {
              party = newValue;
            });
          },
          items: partys.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget positionDropDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Position : ",
          style: TextStyle(fontSize: 20),
        ),
        DropdownButton<String>(
          value: position,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (newValue) {
            setState(() {
              position = newValue;
            });
          },
          items: widget.positions.map<DropdownMenuItem<String>>((String value) {
            print(widget.positions);
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget submitButton() {
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      height: 45,
      color: Colors.blue[600],
      child: new Text('Add',
          style: new TextStyle(fontSize: 16.0, color: Colors.white)),
      onPressed: () async {
        final isValid = formKey.currentState.validate();

        if (isValid) {
          formKey.currentState.save();
          StatusModel status = await addCandidateAPI(candidateName.trim(),
              party.trim(), position.trim().toUpperCase());
          if (status.error != null) {
            displayDialog(context, "Error", status.error);
          } else {
            displayDialog(context, "Success", status.success);
            print(status.success);
            Route route = MaterialPageRoute(
                builder: (c) => ManageCandidates(widget.jwt, widget.payload));

            Navigator.push(context, route);
          }
        }
      },
    );
  }

  Future<StatusModel> addCandidateAPI(
      String nameText, String partyText, String positionText) async {

    String jaiJWT = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoxLCJuYW1lIjoiV2ViZXIiLCJwYXNzd29yZCI6InRlc3QiLCJlbWFpbCI6IndlYmVyQHdlYmVyLmNvbSIsImFhZGhhcl9pZCI6Ijk1NDUqKioqKioqIiwidm90ZXJfaWQiOiJUMTIzKioqIiwiaXNfYWRtaW4iOnRydWUsImhhc192b3RlZCI6ZmFsc2UsImNyZWF0ZWRBdCI6IjIwMjEtMDktMDRUMTc6NTY6MDUuNDg5WiIsInVwZGF0ZWRBdCI6IjIwMjEtMDktMDRUMTc6NTY6MDUuNDg5WiJ9LCJpYXQiOjE2MzEwODE2MDB9.XmJgyHm4tIUGm53N8ElmnvlOcOY-Xk7tcgT8RaGHUKg";

    final url = Uri.parse('$SERVER_IP/candidate/addcandidate');
    final headers = {"Content-type": "application/json", "accessToken": jaiJWT};
    final jsonBody =
        '{ "candidateName" : "$nameText", "position" : "$positionText", "party" : "$partyText"}';

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
