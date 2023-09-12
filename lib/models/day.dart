import 'dart:convert';
import 'package:checkin/main.dart';
import 'package:checkin/models/dailytask.dart';
import 'package:checkin/models/settings.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

class Day {
  var taskPlusList = <DailyTask>[].obs;
  var taskMinusList = <DailyTask>[].obs;
  late final String date;
  Day(this.date) {
    for (var element in c.settings.value.dailyPlusTitles) {
      taskPlusList.add(DailyTask(title: element));
    }
    for (var element in c.settings.value.dailyMinusTitles) {
      taskMinusList.add(DailyTask(title: element));
    }
  }
  Day.fromJson(DayBox? db) {
    if (db != null) {
      var mapPlus = jsonDecode(db.plusJsonString);
      var mapMinus = jsonDecode(db.minusJsonString);
      date = db.date;
      mapPlus.forEach((key, value) {
        taskPlusList.add(DailyTask(title: key)..condition.value = dailyCondition(int.tryParse(value) ?? 3));
      });
      mapMinus.forEach((key, value) {
        taskMinusList.add(DailyTask(title: key)..condition.value = dailyCondition(int.tryParse(value) ?? 3));
      });
    } else {
      date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      for (var element in c.settings.value.dailyPlusTitles) {
        taskPlusList.add(DailyTask(title: element));
      }
      for (var element in c.settings.value.dailyMinusTitles) {
        taskMinusList.add(DailyTask(title: element));
      }
    }
  }
}

@Entity()
class DayBox {
@Id(assignable: true)
  int id = 0;
  @Unique(onConflict: ConflictStrategy.replace)
  String date = '';

  String plusJsonString = '';
  String minusJsonString = '';
  void toJson(Day day) {
    date = day.date;
    var taskPlusMap = <String, String>{};
    var taskMinusMap = <String, String>{};
    for (var element in day.taskPlusList) {
      taskPlusMap[element.title] = element.condition.value.index.toString();
    }
    for (var element in day.taskMinusList) {
      taskMinusMap[element.title] = element.condition.value.index.toString();
    }
    plusJsonString = jsonEncode(taskPlusMap);
    minusJsonString = jsonEncode(taskMinusMap);
  }
}
