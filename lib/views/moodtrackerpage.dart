import 'package:checkin/views/bottomnavigaionbar.dart';
import 'package:checkin/views/drawer.dart';
import 'package:checkin/views/moodtrackerwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoodTrackerPage extends StatelessWidget {
  MoodTrackerPage({super.key}) {
    _init();
  }
  void _init() async {}

  @override
  Widget build(BuildContext context) {
    // todosBox.putMany(todos);
    return Theme(
      data: ThemeData(colorSchemeSeed: Colors.yellow, useMaterial3: true),
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          toolbarHeight: 50,
          title: Text('mood'.tr),
        ),
        bottomNavigationBar: const BottomBar(),
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: const ColoredBox(
            color: Colors.green,
            child: Material(
              child: MoodTrackingWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
