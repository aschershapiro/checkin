import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerTextField extends StatelessWidget {
  //final NewTodoTaskController c = Get.find<NewTodoTaskController>();
  DatePickerTextField({Key? key}) : super(key: key);
  final TextEditingController _dateController = TextEditingController();
  DateTime? dateTime;
  @override
  Widget build(BuildContext context) {
    _dateController.text = '';

    return TextField(
      readOnly: true,
      controller: _dateController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Due Date',
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
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
