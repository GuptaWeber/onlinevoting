import 'package:flutter/material.dart';

class PieData{
  static List<Data> data = [
    Data(name: "ABC Basha !", percent: 50, color: const Color.fromRGBO(255, 100, 244, 1)),
    Data(name: "BSN Rao", percent: 50, color: const Color.fromRGBO(76, 255, 0, 1.0))
  ];
}

class Data{
  final String name;
  final double percent;
  final Color color;

  Data({this.name, this.percent, this.color});

}