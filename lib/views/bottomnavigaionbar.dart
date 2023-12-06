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
        destinations: <Widget>[
          NavigationDestination(
              icon: const Icon(Icons.checklist_outlined),
              selectedIcon: const Icon(Icons.checklist),
              label: 'todo'.tr),
          NavigationDestination(
              icon: const Icon(Icons.plus_one_outlined),
              selectedIcon: const Icon(Icons.plus_one),
              label: 'goodHabits'.tr),
          NavigationDestination(
              icon: const Icon(Icons.exposure_minus_1_outlined),
              selectedIcon: const Icon(Icons.exposure_minus_1),
              label: 'badHabits'.tr),
          NavigationDestination(
              icon: const Icon(Icons.mood_outlined),
              selectedIcon: const Icon(Icons.mood),
              label: 'mood'.tr),
        ],
      ),
    );
  }
}
