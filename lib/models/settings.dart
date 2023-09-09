import 'package:get/get.dart';

class Settings {
  var dailyPlusTitles = ['Task1', 'Task2', 'Task3', 'Task4'].obs;
  var dailyMinusTitles = ['-Task1', '-Task2', '-Task3', '-Task4'].obs;

  Settings() {}
}

enum DailyCondition { positive, neutral, negative, none }

DailyCondition dailyCondition(int value) {
  switch (value) {
    case 0:
      return DailyCondition.positive;
    case 1:
      return DailyCondition.neutral;
    case 2:
      return DailyCondition.negative;
    default:
      return DailyCondition.none;
  }
}
