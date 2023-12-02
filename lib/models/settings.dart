import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';

enum Languages { persian, english }

enum DailyCondition { positive, neutral, negative, none }

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
  var dailyPlusTitles = ['Task1', 'Task2', 'Task3', 'Task4'];
  var dailyMinusTitles = ['-Task1', '-Task2', '-Task3', '-Task4'];
  var userId = '';
  var userToken = '';
  var password = '';
  var username = '';
  @Transient()
  var language = Languages.english.obs;

  int? get dbLanguage {
    return language.value.index;
  }

  set dbLanguage(int? value) {
    if (value == null) {
      language.value = Languages.english;
    } else {
      language.value = value >= 0 && value < Languages.values.length
          ? Languages.values[value]
          : Languages.english;
    }
  }

  Settings();
}

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
