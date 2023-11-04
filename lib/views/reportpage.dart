import 'package:checkin/main.dart';
import 'package:checkin/views/bottomnavigaionbar.dart';
import 'package:checkin/views/datepickerwidget.dart';
import 'package:checkin/views/drawer.dart';
import 'package:checkin/views/reportduration.dart';
import 'package:checkin/views/reportoverview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportPage extends StatelessWidget {
  ReportPage({super.key});
  final initialDate = DatePickerTextField(
    label: 'Initial Date',
  );
  final endDate = DatePickerTextField(
    label: 'End Date',
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          initialIndex: 0,
          length: 4,
          child: Scaffold(
            bottomNavigationBar: const BottomBar(),
            drawer: const DrawerWidget(),
            appBar: AppBar(
              toolbarHeight: 50,
              title: const Text('Reports'),
              bottom: const TabBar(tabs: <Widget>[
                Tab(
                  text: 'Overview',
                ),
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
                ReportOverview(),
                SingleChildScrollView(
                  child: DurationReport(
                    startDate: DateTime.now().subtract(const Duration(days: 6)),
                    endDate: DateTime.now(),
                  ),
                ),
                SingleChildScrollView(
                  child: DurationReport(
                    startDate:
                        DateTime.now().subtract(const Duration(days: 29)),
                    endDate: DateTime.now(),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: initialDate,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: endDate,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: 200,
                            child: TextButton(
                                onPressed: () {
                                  c.reportInitDate.value = initialDate
                                          .dateTime ??
                                      DateTime.now()
                                          .subtract(const Duration(days: 9));
                                  c.reportEndDate.value =
                                      endDate.dateTime ?? DateTime.now();
                                  c.reportVisible.toggle();
                                },
                                child: const Text('Submit'))),
                      ),
                      c.reportVisible.value
                          ? DurationReport(
                              startDate: c.reportInitDate.value,
                              endDate: c.reportEndDate.value,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
