import 'package:checkin/models/reports.dart';
import 'package:checkin/views/pichartwidget.dart';
import 'package:flutter/material.dart';

class DurationReport extends StatelessWidget {
  DurationReport({super.key, required this.startDate, required this.endDate});
  final DateTime startDate;
  final DateTime endDate;
  final reports = Reports();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.green),
            height: 40,
            child: const Center(
                child: Text(
              "Good Habits",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
          ),
          FutureBuilder(
            future: reports.dailyPlusReport(startDate, endDate),
            builder: (context, snapshot) {
              Widget child;
              if (snapshot.hasData) {
                child = Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SizedBox(
                    height: snapshot.data!.length * 180,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) => PieChartWidget(
                          title: snapshot.data![index].title,
                          values: snapshot.data![index].values),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                child = const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                );
              } else {
                child = const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return child;
            },
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.red),
            height: 40,
            child: const Center(
                child: Text(
              "Bad Habits",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )),
          ),
          FutureBuilder(
            future: reports.dailyMinusReport(startDate, endDate),
            builder: (context, snapshot) {
              Widget child;
              if (snapshot.hasData) {
                child = Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SizedBox(
                    height: snapshot.data!.length * 180,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) => PieChartWidget(
                          title: snapshot.data![index].title,
                          values: snapshot.data![index].values),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                child = const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                );
              } else {
                child = const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return child;
            },
          ),
        ],
      ),
    );
  }
}
