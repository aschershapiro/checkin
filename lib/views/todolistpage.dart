import 'package:checkin/main.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:checkin/views/newtodotaskdialog.dart';
import 'package:checkin/views/todolistwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoListPage extends StatelessWidget {
  TodoListPage({super.key}) {
    _init();
  }
  void _init() async {}

  @override

  //late final Controller c;

  @override
  Widget build(BuildContext context) {
    // todosBox.putMany(todos);
    return Scaffold(
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
        actions: [
          Obx(() => Visibility(
                visible: c.itemsSelected,
                child: ElevatedButton(
                  onPressed: () {
                    c.todos.removeWhere((element) {
                      if (element.selected.value) {
                        objectBox.todosBox.remove(element.id);
                        c.settings.value.boxDate = DateTime.now();
                        objectBox.settingsBox.put(c.settings.value);
                        database.syncBox2Server(objectBox: objectBox);
                      }
                      return element.selected.value;
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
              )),
          ElevatedButton(
            onPressed: () async {
              var result = await newTodoTaskDialog();
              if (result != null) {
                c.todos.add(result);
                objectBox.todosBox.put(result);
                c.settings.value.boxDate = DateTime.now();
                objectBox.settingsBox.put(c.settings.value);
                database.syncBox2Server(objectBox: objectBox);
              }
            },
            child: const Icon(Icons.add),
          ),
        ],
        toolbarHeight: 50,
        title: const Text('To Do List'),
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
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: ColoredBox(
          color: Colors.green,
          child: Material(
            child: Obx(() => TodoListWidget(todos: c.todos.value)),
          ),
        ),
      ),
    );
  }
}
