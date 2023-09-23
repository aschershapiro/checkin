import 'package:checkin/main.dart';
import 'package:checkin/models/day.dart';
import 'package:checkin/models/settings.dart';
import 'package:checkin/models/todoitem.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var pagecounter = 0.obs;
  var todos = <TodoItem>[].obs;
  get itemsSelected => todos.fold(false,
      (previousValue, element) => previousValue || element.selected.value);
  get plusSelected => today.taskPlusList.fold(false,
      (previousValue, element) => previousValue || element.selected.value);
  get minusSelected => today.taskMinusList.fold(false,
      (previousValue, element) => previousValue || element.selected.value);
  late final Day today;
  Rx<Settings> settings = Settings().obs;
  var username = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var isSyncing = false.obs;
  var username_signup = ''.obs;
  var password_signup = ''.obs;
  var email_signup = ''.obs;
  var password_c_signup = ''.obs;
  Controller() {
    settings.value = objectBox.settingsBox.getAll().firstOrNull ?? Settings();
  }

  Future<void> init() async {
    todos.value = objectBox.todosBox.getAll();
    today = Day.fromJson(objectBox.findToday());
  }
}
