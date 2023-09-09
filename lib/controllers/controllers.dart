import 'package:checkin/models/day.dart';
import 'package:checkin/models/settings.dart';
import 'package:checkin/models/todoitem.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var pagecounter = 0.obs;
  var conditionDailyToDO = <int>[0, 1, 2, 0, 1].obs;
  var todos = <TodoItem>[].obs;
  get itemsSelected => todos.fold(false, (previousValue, element) => previousValue || element.selected.value);
  get plusSelected => today.taskPlusList.fold(false, (previousValue, element) => previousValue || element.selected.value);
  get minusSelected => today.taskMinusList.fold(false, (previousValue, element) => previousValue || element.selected.value);
  var showCompleted = false.obs;
  late final Day today;
  var settings = Settings().obs;
  var username = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
}
