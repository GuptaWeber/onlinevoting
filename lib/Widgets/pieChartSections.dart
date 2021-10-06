import 'package:fl_chart/fl_chart.dart';
import 'package:polling/data/pieData.dart';
import 'package:flutter/material.dart';

List<PieChartSectionData> getPieSections() => PieData.data
    .asMap()
    .map<int, PieChartSectionData>((index, data){
      final value = PieChartSectionData(
        color: data.color,
        value: data.percent,
        title: data.name,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white
        )
      );
      return MapEntry(index, value);
})
.values
.toList();
