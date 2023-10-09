import 'package:checkin/main.dart';
import 'package:checkin/views/bottomnavigaionbar.dart';
import 'package:checkin/views/drawer.dart';
import 'package:checkin/models/reports.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:checkin/views/pichartwidget.dart';
import 'package:checkin/views/reportduration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    var reports = Reports();
    //reports.dailyReport(DateTime(1990), DateTime.now());
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        bottomNavigationBar: const BottomBar(),
        drawer: const DrawerWidget(),
        appBar: AppBar(
          toolbarHeight: 50,
          title: const Text('Reports'),
          bottom: const TabBar(tabs: <Widget>[
            Tab(
              text: 'Last week',
            ),
            Tab(
              text: 'Last Month',
            ),
            Tab(text: 'Custom'),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            DurationReport(
              startDate: DateTime.now().subtract(const Duration(days: 6)),
              endDate: DateTime.now(),
            ),
            DurationReport(
              startDate: DateTime.now().subtract(const Duration(days: 29)),
              endDate: DateTime.now(),
            ),
            DurationReport(
              startDate: DateTime.now().subtract(const Duration(days: 5)),
              endDate: DateTime.now(),
            ),
          ],
        ),
      ),
    );
  }
}
