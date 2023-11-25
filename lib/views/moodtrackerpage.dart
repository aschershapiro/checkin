import 'package:flutter/material.dart';

class MoodTrackingWidget extends StatefulWidget {
  @override
  _MoodTrackingWidgetState createState() => _MoodTrackingWidgetState();
}

class _MoodTrackingWidgetState extends State<MoodTrackingWidget> {
  String selectedMood = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'How are you feeling today?',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildMoodIcon('😃', 'Happy'),
            buildMoodIcon('😐', 'Neutral'),
            buildMoodIcon('😔', 'Sad'),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Selected mood: $selectedMood',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget buildMoodIcon(String icon, String mood) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          icon,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
