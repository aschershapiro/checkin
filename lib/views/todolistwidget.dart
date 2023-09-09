import 'package:checkin/controllers/controllers.dart';
import 'package:checkin/main.dart';
import 'package:checkin/models/todoitem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
                },
              ),
              subtitle: todos[index].dueDate != null ? Text('Due Date:${DateFormat('yyyy-MM-dd').format(todos[index].dueDate ?? DateTime.now())} ') : null,
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
