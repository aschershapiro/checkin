import 'package:checkin/database/obx2pb.dart';
import 'package:checkin/main.dart';
import 'package:checkin/models/day.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/views/newdailydialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dailyminuswidget.dart';

class DailyMinusPage extends StatelessWidget {
  const DailyMinusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Center(child: Text('${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}')),
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                var result = await newDailyDialog();
                if (result != null) {
                  c.settings.value.dailyMinusTitles.add(result.title);
                  c.today.taskMinusList.add(result);
                }
              },
              child: const Icon(Icons.add),
            ),
            Obx(
              () => Visibility(
                visible: c.minusSelected,
                child: ElevatedButton(
                  onPressed: () {
                    c.today.taskMinusList.removeWhere((element) {
                      if (element.selected.value) c.settings.value.dailyMinusTitles.remove(element.title);
                      return element.selected.value;
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
              ),
            ),
          ],
        ),
        leadingWidth: 150,
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: c.pagecounter.value,
          onDestinationSelected: (value) {
            c.pagecounter.value = value;
            Get.toNamed(appRoutes[value].name);
          },
          destinations: const <Widget>[
            NavigationDestination(icon: Icon(Icons.checklist_outlined), selectedIcon: Icon(Icons.checklist), label: 'To Do'),
            NavigationDestination(icon: Icon(Icons.plus_one_outlined), selectedIcon: Icon(Icons.plus_one), label: 'Daily +'),
            NavigationDestination(icon: Icon(Icons.exposure_minus_1_outlined), selectedIcon: Icon(Icons.exposure_minus_1), label: 'Daily -'),
            NavigationDestination(icon: Icon(Icons.summarize_outlined), selectedIcon: Icon(Icons.summarize), label: 'Report'),
          ],
        ),
      ),
      body: Obx(() => DailyMinusWidget(tasks: c.today.taskMinusList.value)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DayBox db = DayBox();
          db.toJson(c.today);
          objectBox.dayBox.put(db);
          c.settings.value.boxDate = DateTime.now();
          Database.syncBox2Server(objectBox: objectBox, pocketBase: pb);
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
    );
  }
}
