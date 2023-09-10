import 'package:checkin/main.dart';
import 'package:checkin/models/day.dart';
import 'package:checkin/models/settings.dart';
import 'package:checkin/models/todoitem.dart';
import 'package:get/get.dart';
import 'package:checkin/database/obx2pb.dart';

class Controller extends GetxController {
  var pagecounter = 0.obs;
  var todos = <TodoItem>[].obs;
  get itemsSelected => todos.fold(false, (previousValue, element) => previousValue || element.selected.value);
  get plusSelected => today.taskPlusList.fold(false, (previousValue, element) => previousValue || element.selected.value);
  get minusSelected => today.taskMinusList.fold(false, (previousValue, element) => previousValue || element.selected.value);
  late final Day today;
  var settings = objectBox.settingsBox.getAll().firstOrNull?.obs ?? Settings().obs;
  var username = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  Controller() {
    _init();
  }

  Future<void> _init() async {
    todos.value = objectBox.todosBox.getAll();
    today = Day.fromJson(objectBox.findToday());
  }
}
