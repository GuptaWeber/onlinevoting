import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:polling/Widgets/MyDrawer.dart';

class ResultDetails extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String jwt;
  final Map<String, dynamic> payload;

  ResultDetails(this.jwt, this.payload, this.seriesList, {this.animate});

  @override
  _ResultDetailsState createState() => _ResultDetailsState();

}

class _ResultDetailsState extends State<ResultDetails> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Online Voting'),
      ),
      drawer: MyDrawer(widget.jwt, widget.payload),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: new charts.BarChart(
            widget.seriesList,
            animate: widget.animate,
          ),
        ),
      ),
    );
  }
}


