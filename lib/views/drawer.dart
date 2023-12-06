import 'package:checkin/main.dart';
import 'package:checkin/models/reports.dart';
import 'package:checkin/views/historypage.dart';
import 'package:checkin/views/loginpage.dart';
import 'package:checkin/views/reportpage.dart';
import 'package:checkin/views/settingspage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Get.locale == const Locale('en', 'US')
                ? Text(
                    'Checkin 0.1b\n${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} \nID: ${c.settings.value.userId}',
                    style: const TextStyle(color: Colors.white),
                  )
                : Text(
                    'چکین 0.1b \n${Jalali.now().year}/${Jalali.now().month}/${Jalali.now().day} \nID: ${c.settings.value.userId}',
                    style: const TextStyle(color: Colors.white),
                  ),
          ),
          ListTile(
            title: Text('trends'.tr),
            leading: const Icon(Icons.summarize),
            onTap: () {
              Get.to(() => ReportPage());
            },
          ),
          ListTile(
            title: Text('history'.tr),
            leading: const Icon(Icons.history),
            onTap: () {
              Get.to(() => HistoryPage());
            },
          ),
          ListTile(
            title: Text('logout'.tr),
            leading: const Icon(Icons.logout),
            onTap: () {
              database.logout();
              Get.off(() => const LoginPage());
            },
          ),
          ListTile(
            title: Text('settings'.tr),
            leading: const Icon(Icons.settings),
            onTap: () {
              Get.to(() => const SettingsPage());
            },
          ),
        ],
      ),
    );
  }
}
