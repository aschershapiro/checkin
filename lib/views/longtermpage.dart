import 'package:checkin/main.dart';
import 'package:checkin/views/longtermwidget.dart';
import 'package:checkin/views/newlongtermdialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LongTermPage extends StatelessWidget {
  LongTermPage({super.key}) {
    _init();
  }
  void _init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(() => Visibility(
                visible: c.longtermsSelected,
                child: ElevatedButton(
                  onPressed: () {
                    c.longterms.removeWhere((element) {
                      if (element.selected.value) {
                        objectBox.longtermsBox.remove(element.id);
                        c.settings.value.boxDate = DateTime.now();
                        objectBox.settingsBox.put(c.settings.value);
                        database.syncBox2Server(objectBox: objectBox);
                      }
                      return element.selected.value;
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
              )),
          ElevatedButton(
            onPressed: () async {
              var result = await newLongTermDialog();
              if (result != null) {
                c.longterms.add(result);
                objectBox.longtermsBox.put(result);
                c.settings.value.boxDate = DateTime.now();
                objectBox.settingsBox.put(c.settings.value);
                database.syncBox2Server(objectBox: objectBox);
              }
            },
            child: const Icon(Icons.add),
          ),
        ],
        toolbarHeight: 50,
        title: Text('longTermTitle'.tr),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/longterm.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        // color: Colors.white,
        alignment: Alignment.center,
        child: Obx(() => LongTermWidget(longterms: c.longterms.value)),
      ),
    );
  }
}
