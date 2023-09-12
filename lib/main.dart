import 'package:checkin/database/obx2pb.dart';
import 'package:checkin/models/settings.dart';
import 'package:checkin/routes.dart';
import 'package:checkin/objectbox.dart';
import 'package:checkin/controllers/controllers.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

late final Controller c;
late ObjectBox objectBox;
late Rx<Settings>set;
final pb = PocketBase('https://checkin.iran.liara.run');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();
  set = objectBox.settingsBox.getAll().firstOrNull?.obs ?? Settings().obs;
  c = Get.put(Controller());
  
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Checkin',
    home: const LoginPage(),
    //initialRoute: '/todolist',
    getPages: appRoutes,
    theme: ThemeData(primarySwatch: Colors.blue),
  ));
}
