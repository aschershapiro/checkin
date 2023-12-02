import 'package:checkin/main.dart';
import 'package:checkin/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('settings'.tr),
        ),
        body: Column(
          children: [
            const Text('Language/زبان'),
            Obx(() => SegmentedButton<Languages>(
                  segments: const <ButtonSegment<Languages>>[
                    ButtonSegment<Languages>(
                        label: Text('Persian/فارسی'),
                        value: Languages.persian,
                        icon: Text('🇮🇷')),
                    ButtonSegment<Languages>(
                        value: Languages.english,
                        label: Text('English/انگلیسی'),
                        icon: Text('🇺🇸')),
                  ],
                  selected: <Languages>{c.settings.value.language.value},
                  onSelectionChanged: (Set<Languages> p0) {
                    c.settings.value.language.value = p0.first;
                    if (c.settings.value.language.value == Languages.persian) {
                      var locale = Locale('fa', 'IR');
                      Get.updateLocale(locale);
                    } else if (c.settings.value.language.value ==
                        Languages.english) {
                      var locale = Locale('en', 'US');
                      Get.updateLocale(locale);
                    }
                  },
                ))
          ],
        ));
  }
}
