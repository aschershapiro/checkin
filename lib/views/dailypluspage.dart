import 'package:checkin/database/database.dart';
import 'package:checkin/main.dart';
import 'package:checkin/models/day.dart';
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
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Checkin 0.1b\n${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} \nID: ${c.settings.value.userId}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                title: const Text('Log out'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  database.logout();
                  Get.off(() => const LoginPage());
                },
              ),
              ListTile(
                title: const Text('Settings'),
                leading: const Icon(Icons.settings),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          toolbarHeight: 50,
          title: Text('Habit tracker for good habits'),
          actions: [
            Obx(
              () => Visibility(
                visible: c.plusSelected,
                child: ElevatedButton(
                  onPressed: () {
                    c.today.taskPlusList.removeWhere((element) {
                      if (element.selected.value)
                        c.settings.value.dailyPlusTitles.remove(element.title);
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
                  c.today.taskPlusList.add(result);
                }
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          () => NavigationBar(
            selectedIndex: c.pagecounter.value,
            onDestinationSelected: (value) {
              c.pagecounter.value = value;
              Get.toNamed(appRoutes[value].name);
            },
            destinations: const <Widget>[
              NavigationDestination(
                  icon: Icon(Icons.checklist_outlined),
                  selectedIcon: Icon(Icons.checklist),
                  label: 'To Do'),
              NavigationDestination(
                  icon: Icon(Icons.plus_one_outlined),
                  selectedIcon: Icon(Icons.plus_one),
                  label: 'Daily +'),
              NavigationDestination(
                  icon: Icon(Icons.exposure_minus_1_outlined),
                  selectedIcon: Icon(Icons.exposure_minus_1),
                  label: 'Daily -'),
              NavigationDestination(
                  icon: Icon(Icons.summarize_outlined),
                  selectedIcon: Icon(Icons.summarize),
                  label: 'Report'),
            ],
          ),
        ),
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
