import 'package:checkin/models/settings.dart';
import 'package:get/get.dart';

class DailyTask {
  var title = '';
  var condition = DailyCondition.none.obs;
  var selected = false.obs;
  DailyTask({required this.title});
}
