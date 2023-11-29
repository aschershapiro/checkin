import 'package:checkin/main.dart';
import 'package:checkin/models/day.dart';
import 'package:checkin/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoodTrackingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 700,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              children: [
                Obx(() => buildMoodIcon('😃', 'Happy', 0)),
                Obx(() => buildMoodIcon('😐', 'Neutral', 1)),
                Obx(() => buildMoodIcon('😔', 'Sad', 2)),
                Obx(() => buildMoodIcon('😍', 'Loved', 3)),
                Obx(() => buildMoodIcon('😭', 'Crying', 4)),
                Obx(() => buildMoodIcon('😡', 'Angry', 5)),
                Obx(() => buildMoodIcon('😬', 'Anxious', 6)),
                Obx(() => buildMoodIcon('😌', 'Relieved', 7)),
                Obx(() => buildMoodIcon('😇', 'Thankful', 8)),
                Obx(() => buildMoodIcon('🥲', 'SmilingWithTear', 9)),
                Obx(() => buildMoodIcon('🤪', 'Ridiculous', 10)),
                Obx(() => buildMoodIcon('😴', 'ُSleepy', 11)),
                Obx(() => buildMoodIcon('🤒', 'Sick', 12)),
                Obx(() => buildMoodIcon('🤢', 'Nauseated', 13)),
                Obx(() => buildMoodIcon('🤯', 'ExplodingHead', 14)),
                Obx(() => buildMoodIcon('😕', 'Confused', 15)),
                Obx(() => buildMoodIcon('😢', 'SadWithTear', 16)),
                Obx(() => buildMoodIcon('😩', 'Tired', 17)),
                Obx(() => buildMoodIcon('🥺', 'Tearful', 18)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Day Summary:',
            style: TextStyle(fontSize: 16),
          ),
          // const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Day Summary"),
              controller: TextEditingController(text: c.today.summary.value),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSubmitted: (String s) {
                c.today.summary.value = s;
                DayBox db = DayBox();
                db.toJson(c.today);
                objectBox.dayBox.put(db);
                c.settings.value.boxDate = DateTime.now();
                objectBox.settingsBox.put(c.settings.value);
                database.syncBox2Server(objectBox: objectBox);
              },
              onChanged: (s) {
                c.today.summary.value = s;
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Thanksgiving:',
            style: TextStyle(fontSize: 16),
          ),
          // const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Thanksgiving"),
              controller:
                  TextEditingController(text: c.today.thanksgiving.value),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSubmitted: (String s) {
                c.today.thanksgiving.value = s;
                DayBox db = DayBox();
                db.toJson(c.today);
                objectBox.dayBox.put(db);
                c.settings.value.boxDate = DateTime.now();
                objectBox.settingsBox.put(c.settings.value);
                database.syncBox2Server(objectBox: objectBox);
              },
              onChanged: (s) {
                c.today.thanksgiving.value = s;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMoodIcon(String icon, String mood, int index) {
    bool isSelected = index == moodIndexFromString(c.today.mood.value);

    return Center(
      child: GestureDetector(
        onTap: () {
          c.today.mood.value = mood;
          DayBox db = DayBox();
          db.toJson(c.today);
          objectBox.dayBox.put(db);
          c.settings.value.boxDate = DateTime.now();
          objectBox.settingsBox.put(c.settings.value);
          database.syncBox2Server(objectBox: objectBox);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.yellow : null,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            icon,
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }

  int moodIndexFromString(String mood) {
    switch (mood) {
      case 'Happy':
        return 0;
      case 'Neutral':
        return 1;
      case 'Sad':
        return 2;
      case 'Loved':
        return 3;
      case 'Crying':
        return 4;
      case 'Angry':
        return 5;
      case 'Anxious':
        return 6;
      case 'Relieved':
        return 7;
      case 'Thankful':
        return 8;
      case 'SmilingWithTear':
        return 9;
      case 'Ridiculous':
        return 10;
      case 'ُSleepy':
        return 11;
      case 'Sick':
        return 12;
      case 'Nauseated':
        return 13;
      case 'ExplodingHead':
        return 14;
      case 'Confused':
        return 15;
      case 'SadWithTear':
        return 16;
      case 'Tired':
        return 17;
      case 'Tearful':
        return 18;

      default:
        return -1;
    }
  }
}
