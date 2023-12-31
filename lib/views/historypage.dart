import 'package:checkin/models/history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var history = History();

  late List<bool> _expanded = List.generate(
      500, (index) => false); // Track expanded state for each item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('history'.tr),
      ),
      body: ListView.builder(
        itemCount: history.daysList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _expanded[index] = !_expanded[index];
                  });
                },
                child: Card(
                  child: ListTile(
                    leading: Text(
                      history
                          .emojiFromString(history.daysList[index].mood.value),
                      style: const TextStyle(fontSize: 30),
                    ),
                    title: Get.locale == const Locale('en', 'US')
                        ? Text(history.daysList[index].date)
                        : Text(DateTime.parse(history.daysList[index].date)
                            .toJalali()
                            .formatCompactDate()),
                    trailing: Icon(_expanded[index]
                        ? Icons.expand_less
                        : Icons.expand_more),
                  ),
                ),
              ),
              if (_expanded[index])
                ListTile(
                  title: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${'daySummary'.tr}:',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(history.daysList[index].summary.value),
                          const SizedBox(height: 10),
                          Text(
                            'thanksgivingHistory'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(history.daysList[index].thanksgiving.value),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
