import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          //c.selectedDate.value = pickedDate;
          dateTime = pickedDate;
        } else {
          //c.selectedDate = Rx<DateTime?>(null);
          dateTime = null;
        }
      },
    );
  }
}
