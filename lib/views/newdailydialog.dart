import 'package:checkin/models/dailytask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<DailyTask?> newDailyDialog() {
  var taskTitle = '';
  return Get.defaultDialog<DailyTask?>(
    title: 'addNewTask'.tr,
    backgroundColor: Colors.white,
    content: SizedBox(
      width: 600,
      child: TextField(
        autofocus: true,
        obscureText: false,
        onChanged: (value) {
          taskTitle = value;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'newTask'.tr,
        ),
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
                ? Get.back(result: DailyTask(title: taskTitle))
                : Get.back();
          },
          child: Text('ok'.tr),
        ),
      ),
    ],
  );
}
