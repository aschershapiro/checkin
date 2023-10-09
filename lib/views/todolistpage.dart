import 'package:checkin/main.dart';
import 'package:checkin/views/bottomnavigaionbar.dart';
import 'package:checkin/views/drawer.dart';
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
      drawer: const DrawerWidget(),
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
      bottomNavigationBar: const BottomBar(),
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
