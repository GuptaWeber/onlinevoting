import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget {

  MyHeaderDrawer(this.jwt, this.payload);
  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[700],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
              )
            ),
          ),
          Text(widget.payload["user"]["name"], style: TextStyle(color: Colors.white, fontSize: 20.0),),
          Text(widget.payload["user"]["email"], style: TextStyle(color: Colors.white, fontSize: 14.0),),
        ],
      ),
    );
  }
}
