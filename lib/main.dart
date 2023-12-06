import 'package:checkin/database/database.dart';
import 'package:checkin/models/notification.dart';
import 'package:checkin/models/settings.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/objectbox.dart';
import 'package:checkin/controllers/controllers.dart';
import 'package:checkin/translations/messages.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:checkin/views/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

late final Controller c;
late ObjectBox objectBox;
final database = Database();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
  c = Get.put(Controller());
  await database.autoLogin();
  if (Platform.isAndroid) {
    var notif = LocalNotificationService();
    await notif.init();
    await notif.scheduleWeeklyTenPMNotification();
  }
  runApp(GetMaterialApp(
    translations: Messages(),
    locale: c.settings.value.language.value == Languages.persian
        ? Locale('fa', 'IR')
        : Locale('en', 'US'),
    fallbackLocale: Locale('en', 'US'),
    debugShowCheckedModeBanner: false,
    title: 'checkin'.tr,
    home: database.isAuth ? const SplashScreen() : const LoginPage(),
    //initialRoute: '/todolist',
    getPages: appRoutes,
    theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
  ));
}
