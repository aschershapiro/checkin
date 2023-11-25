import 'package:checkin/database/database.dart';
import 'package:checkin/models/notification.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/objectbox.dart';
import 'package:checkin/controllers/controllers.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:checkin/views/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

late final Controller c;
late ObjectBox objectBox;
final database = Database();
var notif = LocalNotificationService();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
  c = Get.put(Controller());
  await database.autoLogin();
  if (Platform.isAndroid) {
    await notif.init();
    await notif.scheduleWeeklyTenPMNotification();
  }
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Checkin',
    home: database.isAuth ? const SplashScreen() : const LoginPage(),
    //initialRoute: '/todolist',
    getPages: appRoutes,
    theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
  ));
}
