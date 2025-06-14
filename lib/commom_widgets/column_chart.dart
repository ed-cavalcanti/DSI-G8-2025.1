import 'package:diainfo/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnChart extends StatelessWidget {
  final List<ChartData> chartData;

  const ColumnChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          title: AxisTitle(
            text: 'últimos registros',
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        series: <CartesianSeries>[
          ColumnSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.day,
            yValueMapper: (ChartData data, _) => data.value,
            color: primaryColor,
            borderRadius: BorderRadius.circular(16),
            pointColorMapper: (ChartData data, int index) {
              return index.isEven ? primaryColor : Colors.grey;
            },
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String day;
  final double value;

  ChartData(this.day, this.value);
}