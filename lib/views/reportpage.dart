import 'package:checkin/main.dart';
import 'package:checkin/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
