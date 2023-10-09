import 'package:checkin/database/database.dart';
import 'package:checkin/main.dart';
import 'package:checkin/models/bottomnavigaionbar.dart';
import 'package:checkin/models/day.dart';
import 'package:checkin/models/drawer.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/views/dailypluswidget.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:checkin/views/newdailydialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyPlusPage extends StatelessWidget {
  const DailyPlusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primarySwatch: Colors.green),
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          toolbarHeight: 50,
          title: Text('Good habits'),
          actions: [
            Obx(
              () => Visibility(
                visible: c.plusSelected,
                child: ElevatedButton(
                  onPressed: () {
                    c.today.taskPlusList.removeWhere((element) {
                      if (element.selected.value) {
                        c.settings.value.dailyPlusTitles.remove(element.title);
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
                  c.settings.value.dailyPlusTitles.add(result.title);
                  objectBox.settingsBox.put(c.settings.value);
                  c.today.taskPlusList.add(result);
                }
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        bottomNavigationBar: const BottomBar(),
        body: Obx(() => DailyPlusWidget(tasks: c.today.taskPlusList.value)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            DayBox db = DayBox();
            db.toJson(c.today);
            objectBox.dayBox.put(db);
            c.settings.value.boxDate = DateTime.now();
            objectBox.settingsBox.put(c.settings.value);
            database.syncBox2Server(objectBox: objectBox);
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
