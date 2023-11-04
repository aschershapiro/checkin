import 'package:checkin/models/reports.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter/material.dart';

class ReportOverview extends StatelessWidget {
  ReportOverview({super.key});
  final reports = Reports();

  @override
  Widget build(BuildContext context) {
    var map = <DateTime, int>{};

    return FutureBuilder(
      future: reports.checkedDaysReport(),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          for (var element in snapshot.data!) {
            map[element] = 10;
          }
          child = HeatMap(
            startDate: DateTime.now().subtract(const Duration(days: 120)),
            endDate: DateTime.now(),
            size: 15,
            fontSize: 10,
            showColorTip: false,
            borderRadius: 0,
            datasets: map,
            colorMode: ColorMode.opacity,
            showText: false,
            scrollable: true,
            colorsets: const {
              1: Colors.blue,
              3: Colors.orange,
              5: Colors.yellow,
              7: Colors.green,
              9: Colors.blue,
              11: Colors.indigo,
              13: Colors.purple,
            },
            onClick: (value) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(value.toString())));
            },
          );
        } else {
          child = const Center(child: CircularProgressIndicator());
        }
        return child;
      },
    );
  }
}
