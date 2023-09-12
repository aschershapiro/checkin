import 'package:checkin/models/todoitem.dart';
import 'package:checkin/views/datepickerwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<TodoItem?> newTodoTaskDialog() {
  var taskTitle = '';
  var x = DatePickerTextField();
  return Get.defaultDialog<TodoItem>(
    title: 'Add new Task',
    backgroundColor: Colors.white,
    content: SizedBox(
      width: 600,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              autofocus: true,
              obscureText: false,
              onChanged: (value) {
                taskTitle = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'New Task',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: x,
          ),
        ],
      ),
    ),
    actions: <Widget>[
      SizedBox(
        width: 100,
        child: TextButton(
          onPressed: () {
            return Get.back();
          },
          child: const Text('Cancel'),
        ),
      ),
      SizedBox(
        width: 100,
        child: TextButton(
          onPressed: () {
            taskTitle.isNotEmpty ? Get.back(result: TodoItem(task: taskTitle, dueDate: x.dateTime)) : Get.back();
          },
          child: const Text('OK'),
        ),
      ),
    ],
  );
}