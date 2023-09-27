import 'dart:convert';

import 'package:checkin/database/database.dart';
import 'package:checkin/main.dart';
import 'package:checkin/models/encryption.dart';

class Reports {
  Future<List<TaskReport>> dailyReport(
      DateTime init, DateTime end, String label) async {
    List<TaskReport> ls = List<TaskReport>.empty(growable: true);
    late List<String> tasks;
    if (label == 'dailyplus') {
      tasks = c.today.taskPlusList.value.map((e) => e.title).toList();
    } else if (label == 'dailyminus') {
      tasks = c.today.taskMinusList.value.map((e) => e.title).toList();
    }
    var resp = await database.getAllDays();
    for (var v = 0; v < tasks.length; v++) {
      var negative = 0;
      var positive = 0;
      var neutral = 0;
      var none = 0;
      for (var element in resp) {
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
