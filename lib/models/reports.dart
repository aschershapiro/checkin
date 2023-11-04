import 'dart:convert';
import 'package:checkin/main.dart';
import 'package:checkin/models/encryption.dart';
import 'package:intl/intl.dart';

class Reports {
  List<String> _getDaysBetween(DateTime init, DateTime end) {
    List<String> days = [];
    days.add(DateFormat('yyyy-MM-dd').format(init));
    while (init.isBefore(end)) {
      init = init.add(const Duration(days: 1));
      days.add(DateFormat('yyyy-MM-dd').format(init));
    }
    return days;
  }

  Future<List<DateTime>> checkedDaysReport() async {
    var resp = await database.getAllDays();
    var availableDates = <DateTime>[];
    for (var element in resp) {
      availableDates.add(DateTime.parse(
          (element.data['date'] as String).substring(0, 10).trim()));
    }
    return availableDates;
  }

  Future<List<TaskReport>> dailyReport(
      DateTime init, DateTime end, String label) async {
    List<TaskReport> ls = List<TaskReport>.empty(growable: true);
    late List<String> tasks;
    var availableDates = <String>[];
    var dateSpan = <String>[];
    if (label == 'dailyplus') {
      tasks = c.today.taskPlusList.map((e) => e.title).toList();
    } else if (label == 'dailyminus') {
      tasks = c.today.taskMinusList.map((e) => e.title).toList();
    }
    var resp = await database.getAllDays();
    dateSpan = _getDaysBetween(init, end);
    for (var element in resp) {
      availableDates
          .add((element.data['date'] as String).substring(0, 10).trim());
    }

    for (var v = 0; v < tasks.length; v++) {
      var negative = 0;
      var positive = 0;
      var neutral = 0;
      var none = 0;

      for (var element in resp) {
        if (!dateSpan.contains(
            element.data['date'].toString().substring(0, 10).trim())) continue;
        var str = Encryption.decryptStringWithPassword(
            element.data[label], c.settings.value.password);
        Map<String, dynamic> map = jsonDecode(str) as Map<String, dynamic>;
        if (map.containsKey(tasks[v])) {
          switch (int.tryParse(map[tasks[v]])) {
            case 0:
              positive++;
              break;
            case 1:
              neutral++;
              break;
            case 2:
              negative++;
              break;
            case 3:
              none++;
              break;
          }
        }
      }
      for (var element in dateSpan) {
        if (!availableDates.contains(element)) {
          none++;
        }
      }
      ls.add(TaskReport(tasks[v], [positive, neutral, negative, none]));
    }
    return ls;
  }

  Future<List<TaskReport>> dailyPlusReport(DateTime init, DateTime end) async {
    return await dailyReport(init, end, 'dailyplus');
  }

  Future<List<TaskReport>> dailyMinusReport(DateTime init, DateTime end) async {
    return await dailyReport(init, end, 'dailyminus');
  }
}

class TaskReport {
  TaskReport(this.title, this.values);
  String title;
  List<int> values;
}
