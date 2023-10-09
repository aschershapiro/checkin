import 'package:checkin/database/database.dart';
import 'package:checkin/main.dart';
import 'package:checkin/models/bottomnavigaionbar.dart';
import 'package:checkin/models/day.dart';
import 'package:checkin/models/drawer.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:checkin/views/newdailydialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dailyminuswidget.dart';

class DailyMinusPage extends StatelessWidget {
  const DailyMinusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primarySwatch: Colors.red),
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          toolbarHeight: 50,
          title: const Text('Bad habits'),
          actions: [
            Obx(
              () => Visibility(
                visible: c.minusSelected,
                child: ElevatedButton(
                  onPressed: () {
                    c.today.taskMinusList.removeWhere((element) {
                      if (element.selected.value) {
                        c.settings.value.dailyMinusTitles.remove(element.title);
                        objectBox.settingsBox.put(c.settings.value);
                      }
                      return element.selected.value;
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await newDailyDialog();
                if (result != null) {
                  c.settings.value.dailyMinusTitles.add(result.title);
                  objectBox.settingsBox.put(c.settings.value);
                  c.today.taskMinusList.add(result);
                }
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        bottomNavigationBar: const BottomBar(),
        body: Obx(() => DailyMinusWidget(tasks: c.today.taskMinusList.value)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            DayBox db = DayBox();
            db.toJson(c.today);
            objectBox.dayBox.put(db);
            c.settings.value.boxDate = DateTime.now();
            objectBox.settingsBox.put(c.settings.value);
            database.syncBox2Server(objectBox: objectBox);
            //c.today = Day.fromJson(objectBox.dayBox.getAll().first);
            Get.showSnackbar(
              const GetSnackBar(
                title: 'Done!',
                message: 'All tasks saved successfully.',
                icon: Icon(Icons.done_all, color: Colors.amber),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Icon(Icons.done),
        ),
      ),
    );
  }
}
