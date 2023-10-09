import 'package:checkin/main.dart';
import 'package:checkin/models/bottomnavigaionbar.dart';
import 'package:checkin/models/drawer.dart';
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
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text('Reports'),
      ),
      body: DurationReport(
        startDate: DateTime.now().subtract(const Duration(days: 6)),
        endDate: DateTime.now(),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
