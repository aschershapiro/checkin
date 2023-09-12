import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Settings {
@Id(assignable: true)
  int id = 0;

  @Unique(onConflict: ConflictStrategy.replace)
  final String dummy = 'Settings';
  // @Property(type: PropertyType.date)
  // DateTime serverDate = DateTime(1990);
  @Property(type: PropertyType.date)
  DateTime boxDate = DateTime(1990);
  @Transient()
  var dailyPlusTitles = ['Task1', 'Task2', 'Task3', 'Task4'].obs;
  @Transient()
  var dailyMinusTitles = ['-Task1', '-Task2', '-Task3', '-Task4'].obs;

  Settings();
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
