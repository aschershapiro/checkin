import 'package:checkin/main.dart';
import 'package:checkin/views/bottomnavigaionbar.dart';
import 'package:checkin/views/datepickerwidget.dart';
import 'package:checkin/views/drawer.dart';
import 'package:checkin/views/reportduration.dart';
import 'package:checkin/views/reportoverview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

class ReportPage extends StatelessWidget {
  ReportPage({super.key});
  final initialDate = DatePickerTextField(
    label: 'initialDate'.tr,
  );
  final endDate = DatePickerTextField(
    label: 'endDate'.tr,
  );

  @override
  Widget build(BuildContext context) {
    var jmonth = Jalali.now()
        .toDateTime()
        .subtract(Duration(days: Jalali.now().day))
        .subtract(Duration(days: 1))
        .toJalali()
        .month;
    var lastWeekStart =
        DateTime.now().subtract(Duration(days: Jalali.now().weekDay - 1 + 7));
    var lastWeekEnd =
        DateTime.now().subtract(Duration(days: Jalali.now().weekDay));
    var lastMonthStart = Jalali(Jalali.now().year, jmonth, 1).toDateTime();
    var lastMonthEnd =
        Jalali(Jalali.now().year, jmonth, lastMonthStart.toJalali().monthLength)
            .toDateTime();

    return Obx(() => DefaultTabController(
          initialIndex: 0,
          length: 4,
          child: Scaffold(
            // drawer: const DrawerWidget(),
            appBar: AppBar(
              toolbarHeight: 50,
              title: Text('reports'.tr),
              bottom: TabBar(tabs: <Widget>[
                Tab(
                  text: 'overview'.tr,
                ),
                Tab(
                  text: 'lastWeek'.tr,
                ),
                Tab(
                  text: 'lastMonth'.tr,
                ),
                Tab(text: 'custom'.tr),
              ]),
            ),
            body: TabBarView(
              children: <Widget>[
                ReportOverview(),
                SingleChildScrollView(
                  child: DurationReport(
                    startDate: lastWeekStart,
                    endDate: lastWeekEnd,
                  ),
                ),
                SingleChildScrollView(
                  child: DurationReport(
                    startDate: lastMonthStart,
                    endDate: lastMonthEnd,
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
                                child: Text('submit'.tr))),
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
