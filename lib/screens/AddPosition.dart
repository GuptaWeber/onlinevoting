import 'package:flutter/material.dart';
import 'package:polling/ManagePositions.dart';
import 'package:polling/Widgets/MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:polling/main.dart';
import 'dart:async';
import 'dart:convert';

import 'package:polling/models/StatusModel.dart';
import 'package:polling/signup.dart';

class AddPosition extends StatefulWidget {
  AddPosition(this.jwt, this.payload);

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _AddPositionState createState() => _AddPositionState();
}

class _AddPositionState extends State<AddPosition> {

  final formKey = GlobalKey<FormState>();
  String position;
  bool hasError;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Online Voting Application")),
      drawer: MyDrawer(widget.jwt, widget.payload),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text("Add A Position", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),),
            Padding(padding: EdgeInsets.all(24.0), child: Column(
              children: [
                Form(key: formKey, child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      positionField(),
                      SizedBox(
                        height: 15.0,
                      ),
                      submitButton(),
                    ],
                  ),

                ))
              ],
            ),)
          ],
        ),
      ),
    );
  }

  Widget positionField() {
    return TextFormField(
      decoration: InputDecoration(
      labelText: 'Position',
        border: OutlineInputBorder()
),
      onSaved: (value) => setState(() => position = value.trim()),
      validator: (value) {
        if (value.length == 0) {
          return "Position must not be empty!";
        } else {
          return null;
        }
      },
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
          StatusModel status = await addPositionAPI(position.trim().toUpperCase());
          if(status.error != null){
            displayDialog(context, "Error", status.error);

          }else{
            displayDialog(context, "Success", status.success);
            print(status.success);
            Route route = MaterialPageRoute(builder: (c) => ManagePositions(widget.jwt, widget.payload));

            Navigator.push(
                context,
                route
            );

          }

        }
      },
    );
  }

  Future<StatusModel> addPositionAPI(String positionText) async {
    final url = Uri.parse('$SERVER_IP/candidate/addposition');
    final headers = {"Content-type": "application/json"};
    final jsonBody =
        '{"position" : "$positionText"}';

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
