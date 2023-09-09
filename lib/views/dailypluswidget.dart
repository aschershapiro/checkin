import 'package:checkin/main.dart';
import 'package:checkin/models/settings.dart';
import 'package:checkin/models/dailytask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyPlusWidget extends StatelessWidget {
  final List<DailyTask> tasks;
  const DailyPlusWidget({super.key, required this.tasks});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) => Obx(
        () => ListTile(
          title: Obx(() => Text(c.today.taskPlusList[index].title)),
          trailing: Obx(
            () => SegmentedButton(
              segments: const [
                ButtonSegment(value: 0, icon: Icon(Icons.sentiment_very_satisfied, size: 25)),
                ButtonSegment(value: 1, icon: Icon(Icons.sentiment_neutral, size: 25)),
                ButtonSegment(value: 2, icon: Icon(Icons.sentiment_very_dissatisfied, size: 25)),
              ],
              selected: {c.today.taskPlusList[index].condition.value.index},
              emptySelectionAllowed: true,
              onSelectionChanged: (p0) {
                switch (p0.firstOrNull) {
                  case 0:
                    c.today.taskPlusList[index].condition.value = DailyCondition.positive;
                    break;
                  case 1:
                    c.today.taskPlusList[index].condition.value = DailyCondition.neutral;
                    break;
                  case 2:
                    c.today.taskPlusList[index].condition.value = DailyCondition.negative;
                    break;
                  case null:
                    c.today.taskPlusList[index].condition.value = DailyCondition.none;
                  default:
                }
              },
            ),
          ),
          onLongPress: () {
            c.today.taskPlusList[index].selected.toggle();
          },
          selected: c.today.taskPlusList[index].selected.value,
          selectedTileColor: Colors.grey,
          selectedColor: Colors.white,
        ),
      ),
    );
  }
}
