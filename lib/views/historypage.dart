import 'package:checkin/models/history.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
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
        title: Text('History'),
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
                      style: TextStyle(fontSize: 30),
                    ),
                    title: Text(history.daysList[index].date.toString()),
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
                            'Day Summary:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(history.daysList[index].summary.value),
                          SizedBox(height: 10),
                          Text(
                            'I was thankful for...',
                            style: TextStyle(fontWeight: FontWeight.bold),
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
