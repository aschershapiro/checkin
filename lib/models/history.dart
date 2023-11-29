import 'package:checkin/main.dart';
import 'package:checkin/models/day.dart';

class History {
  var daysList = <Day>[];
  History() {
    var resp = objectBox.dayBox.getAll();
    for (var element in resp) {
      daysList.add(Day.fromJson(element));
    }
  }
  String emojiFromString(String mood) {
    switch (mood) {
      case 'Happy':
        return '😃';
      case 'Neutral':
        return '😐';
      case 'Sad':
        return '😔';
      case 'Loved':
        return '😍';
      case 'Crying':
        return '😭';
      case 'Angry':
        return '😡';
      case 'Anxious':
        return '😬';
      case 'Relieved':
        return '😌';
      case 'Thankful':
        return '😇';
      case 'SmilingWithTear':
        return '🥲';
      case 'Ridiculous':
        return '🤪';
      case 'ُSleepy':
        return '😴';
      case 'Sick':
        return '🤒';
      case 'Nauseated':
        return '🤢';
      case 'ExplodingHead':
        return '🤯';
      case 'Confused':
        return '😕';
      case 'SadWithTear':
        return '😢';
      case 'Tired':
        return '😩';
      case 'Tearful':
        return '🥺';

      default:
        return "😶";
    }
  }
}
