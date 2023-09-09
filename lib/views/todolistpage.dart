import 'package:checkin/main.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/views/newtodotaskdialog.dart';
import 'package:checkin/views/todolistwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  //late final Controller c;

  @override
  Widget build(BuildContext context) {
    // todosBox.putMany(todos);
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
                var result = await newTodoTaskDialog();
                if (result != null) {
                  c.todos.add(result);
                  objectBox.todosBox.put(result);
                }
              },
              child: const Icon(Icons.add),
            ),
            Obx(() => Visibility(
                  visible: c.itemsSelected,
                  child: ElevatedButton(
                    onPressed: () {
                      c.todos.removeWhere((element) {
                        if (element.selected.value) objectBox.todosBox.remove(element.id);
                        return element.selected.value;
                      });
                    },
                    child: const Icon(Icons.remove),
                  ),
                )),
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
