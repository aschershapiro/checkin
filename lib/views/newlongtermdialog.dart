import 'package:checkin/models/longtermitem.dart';
import 'package:checkin/views/datepickerwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<LongTermItem?> newLongTermDialog() {
  var taskTitle = '';
  var x = DatePickerTextField();
  return Get.defaultDialog<LongTermItem>(
    title: 'addNewTask'.tr,
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
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'newTask'.tr,
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
          child: Text('cancel'.tr),
        ),
      ),
      SizedBox(
        width: 100,
        child: TextButton(
          onPressed: () {
            taskTitle.isNotEmpty
                ? Get.back(
                    result: LongTermItem(task: taskTitle, dueDate: x.dateTime))
                : Get.back();
          },
          child: Text('ok'.tr),
        ),
      ),
    ],
  );
}
