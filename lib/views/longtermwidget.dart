import 'package:checkin/main.dart';
import 'package:checkin/models/longtermitem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class LongTermWidget extends StatelessWidget {
  final List<LongTermItem> longterms;
  // final Controller c = Get.put(Controller());
  LongTermWidget({super.key, required this.longterms});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: longterms.length,
      itemBuilder: (BuildContext context, int index) {
        return Obx(() => ListTile(
              leading: const Icon(Icons.task),
              title: Text(longterms[index].task),
              trailing: Checkbox(
                value: c.longterms[index].completed.value,
                onChanged: (value) {
                  c.longterms[index].status = !c.longterms[index].status;
                  objectBox.longtermsBox.put(c.longterms[index]);
                  c.settings.value.boxDate = DateTime.now();
                  objectBox.settingsBox.put(c.settings.value);
                  database.syncBox2Server(objectBox: objectBox);
                },
              ),
              subtitle: longterms[index].dueDate != null
                  ? Get.locale == const Locale('en', 'US')
                      ? Text(
                          '${'dueDate'.tr}:${DateFormat('yyyy-MM-dd').format(longterms[index].dueDate ?? DateTime.now())} ',
                          style: TextStyle(
                              color: DateTime.now()
                                      .isAfter(longterms[index].dueDate!)
                                  ? Colors.red
                                  : Colors.grey),
                        )
                      : Text(
                          '${'dueDate'.tr}:${longterms[index].dueDate?.toJalali().year}/${longterms[index].dueDate?.toJalali().month}/${longterms[index].dueDate?.toJalali().day} ',
                          style: TextStyle(
                              color: DateTime.now()
                                      .isAfter(longterms[index].dueDate!)
                                  ? Colors.red
                                  : Colors.grey),
                        )
                  : null,
              onLongPress: () {
                longterms[index].selected.toggle();
              },
              selected: c.longterms[index].selected.value,
              selectedTileColor: Colors.grey,
              selectedColor: Colors.white,
              tileColor: Colors.white,
            ));
      },
    );
  }
}
