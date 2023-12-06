import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class DatePickerTextField extends StatelessWidget {
  DatePickerTextField({Key? key, this.label = 'Due date'}) : super(key: key);
  final TextEditingController _dateController = TextEditingController();
  final String label;
  late final DateTime? dateTime;
  @override
  Widget build(BuildContext context) {
    _dateController.text = '';

    return TextField(
      readOnly: true,
      controller: _dateController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      onTap: () async {
        if (Get.locale == const Locale('en', 'US')) {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            _dateController.text = DateFormat('yyyy/MM/dd').format(pickedDate);
            //c.selectedDate.value = pickedDate;
            dateTime = pickedDate;
          } else {
            //c.selectedDate = Rx<DateTime?>(null);
            dateTime = null;
          }
        } else if (Get.locale == const Locale('fa', 'IR')) {
          var item = await showPersianDatePicker(
              context: context,
              initialDate: Jalali.now(),
              firstDate: Jalali(1400),
              lastDate: Jalali(1500));
          DateTime? pickedDate = item?.toDateTime();
          if (pickedDate != null) {
            _dateController.text = '${item?.year}/${item?.month}/${item?.day}';
            dateTime = pickedDate;
          } else {
            dateTime = null;
          }
        }
      },
    );
  }
}
