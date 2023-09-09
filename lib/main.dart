import 'package:checkin/models/day.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/objectbox.dart';
import 'package:checkin/controllers/controllers.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

late final Controller c;
late ObjectBox objectBox;
final pb = PocketBase('https://checkin.iran.liara.run');
Future<void> main() async {
  c = Get.put(Controller());
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
  c.todos.value = objectBox.todosBox.getAll();
  c.today = Day.fromJson(objectBox.findToday());
  // objectBox.dayBox.removeAll();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Checkin',
    home: const LoginPage(),
    //initialRoute: '/todolist',
    getPages: appRoutes,
    theme: ThemeData(primarySwatch: Colors.blue),
  ));
}
