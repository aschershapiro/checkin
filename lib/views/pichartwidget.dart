import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key, required this.title, required this.values});
  final List<int> values;
  final String title;
  @override
  State<StatefulWidget> createState() =>
      PieChartWidgetState(values: values, title: title);
}

class PieChartWidgetState extends State {
  PieChartWidgetState({required this.title, required this.values});
  int touchedIndex = 0;
  String title;
  List<int> values;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          SizedBox(
            width: 200.0,
            height: 170.0,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: showingSections(
                    positive: values[0].toDouble(),
                    neutral: values[1].toDouble(),
                    negative: values[2].toDouble(),
                    none: values[3].toDouble()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      {required double positive,
      required double neutral,
      required double negative,
      required double none}) {
    // double total = positive + negative + neutral + none;
    // var length = 4;
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 80.0 : 70.0;
      final widgetSize = isTouched ? 45.0 : 30.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: positive.toDouble(),
            // title: '${(positive / total * 100).round()}%',
            title: positive.toInt().toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              const Icon(Icons.sentiment_very_satisfied),
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: neutral,
            // title: '${(neutral / total * 100).round()}%',
            title: neutral.toInt().toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              const Icon(Icons.sentiment_neutral),
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.red,
            value: negative,
            // title: '${(negative / total * 100).round()}%',
            title: negative.toInt().toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              const Icon(Icons.sentiment_very_dissatisfied),
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: Colors.grey,
            value: none,
            // title: '${(none / total * 100).round()}%',
            title: none.toInt().toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              const Icon(Icons.help),
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final Icon svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0),
      child: Center(
        child: svgAsset,
      ),
    );
  }
}
