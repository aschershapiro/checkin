import 'package:checkin/database/database.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/objectbox.dart';
import 'package:checkin/controllers/controllers.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:checkin/views/splashscreen.dart';
import 'package:checkin/views/todolistpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

late final Controller c;
late ObjectBox objectBox;
final database = Database();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
  //objectBox.dayBox.removeAll();
  c = Get.put(Controller());
  await database.autoLogin();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Checkin',
    home: database.isAuth ? TodoListPage() : const LoginPage(),
    //initialRoute: '/todolist',
    getPages: appRoutes,
    theme: ThemeData(primarySwatch: Colors.blue),
  ));
}
