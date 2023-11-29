import 'package:checkin/main.dart';
import 'package:checkin/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
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
              label: 'Good Habits'),
          NavigationDestination(
              icon: Icon(Icons.exposure_minus_1_outlined),
              selectedIcon: Icon(Icons.exposure_minus_1),
              label: 'Bad Habits'),
          NavigationDestination(
              icon: Icon(Icons.mood_outlined),
              selectedIcon: Icon(Icons.mood),
              label: 'Mood'),
        ],
      ),
    );
  }
}
