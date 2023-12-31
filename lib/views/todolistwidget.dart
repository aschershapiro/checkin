import 'package:checkin/controllers/controllers.dart';
import 'package:checkin/main.dart';
import 'package:checkin/models/todoitem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class TodoListWidget extends StatelessWidget {
  final List<TodoItem> todos;
  final Controller c = Get.put(Controller());
  TodoListWidget({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        return Obx(() => ListTile(
              leading: const Icon(Icons.task),
              title: Text(todos[index].task),
              trailing: Checkbox(
                value: c.todos[index].completed.value,
                onChanged: (value) {
                  c.todos[index].status = !c.todos[index].status;
                  objectBox.todosBox.put(c.todos[index]);
                  c.settings.value.boxDate = DateTime.now();
                  objectBox.settingsBox.put(c.settings.value);
                  database.syncBox2Server(objectBox: objectBox);
                },
              ),
              subtitle: todos[index].dueDate != null
                  ? Get.locale == const Locale('en', 'US')
                      ? Text(
                          '${'dueDate'.tr}:${DateFormat('yyyy-MM-dd').format(todos[index].dueDate ?? DateTime.now())} ',
                          style: TextStyle(
                              color:
                                  DateTime.now().isAfter(todos[index].dueDate!)
                                      ? Colors.red
                                      : Colors.grey),
                        )
                      : Text(
                          '${'dueDate'.tr}:${todos[index].dueDate?.toJalali().year}/${todos[index].dueDate?.toJalali().month}/${todos[index].dueDate?.toJalali().day} ',
                          style: TextStyle(
                              color:
                                  DateTime.now().isAfter(todos[index].dueDate!)
                                      ? Colors.red
                                      : Colors.grey),
                        )
                  : null,
              onLongPress: () {
                todos[index].selected.toggle();
              },
              selected: c.todos[index].selected.value,
              selectedTileColor: Colors.grey,
              selectedColor: Colors.white,
            ));
      },
    );
  }
}
