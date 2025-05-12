import 'package:diainfo/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GlucoseData {
  final String day;
  final double value;
  GlucoseData(this.day, this.value);
}

class ColumnChart extends StatelessWidget {
  ColumnChart({super.key});

  final List<GlucoseData> _chartData = [
    GlucoseData('1', 110),
    GlucoseData('2', 120),
    GlucoseData('3', 105),
    GlucoseData('4', 130),
    GlucoseData('5', 115),
    GlucoseData('6', 125),
    GlucoseData('7', 100),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220, // altura máxima do gráfico
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          title: AxisTitle(
            text:
                'Dia do mês', // Adiciona o nome "Dia" na parte inferior do gráfico
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        series: <CartesianSeries<dynamic, dynamic>>[
          ColumnSeries<GlucoseData, String>(
            dataSource: _chartData,
            xValueMapper: (GlucoseData data, _) => data.day,
            yValueMapper: (GlucoseData data, _) => data.value,
            color: primaryColor,
            borderRadius: BorderRadius.circular(16),
            pointColorMapper: (GlucoseData data, int index) {
              return index.isEven ? primaryColor : Colors.grey;
            },
          ),
        ],
      ),
    );
  }
}
