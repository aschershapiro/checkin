import 'package:objectbox/objectbox.dart';
import 'package:get/get.dart';

@Entity()
class TodoItem {
@Id(assignable: true)
  int id = 0;

  String task;

  @Property(type: PropertyType.date)
  DateTime? dueDate;

  var completed = false.obs;

  bool get status => completed.value;
  set status(bool val) {
    completed.value = val;
  }

  @Transient()
  var selected = false.obs;

  TodoItem({required this.task, this.dueDate, bool? stat}) {
    status = stat ?? false;
  }
}
