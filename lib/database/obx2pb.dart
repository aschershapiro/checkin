import 'package:checkin/models/settings.dart';
import 'package:checkin/objectbox.dart';
import 'package:pocketbase/pocketbase.dart';

class Database {
  static void syncBox2Server({required ObjectBox objectBox, required PocketBase pocketBase}) async {
    var resp = await pocketBase.collection('todo_items').getFullList();
    for (var item in objectBox.todosBox.getAll()) {
      var contains = resp.fold(false, (previousValue, element) => previousValue || element.id == item.id.toString());

      if (contains) {
        final body = <String, dynamic>{"task": item.task, "user": "RELATION_RECORD_ID", "completed": item.completed, "duedate": item.dueDate.toString()};
        pocketBase.collection('todo_items').update(item.id.toString(), body: body);
      } else {
        final body = <String, dynamic>{"id": item.id.toString(), "task": item.task, "user": "RELATION_RECORD_ID", "completed": item.completed, "duedate": item.dueDate.toString()};
        pocketBase.collection('todo_items').create(
              body: body,
            );
      }
    }
  }

  static void syncServer2Box({required ObjectBox objectBox, required PocketBase pocketBase}) {}

  static void sync({required ObjectBox objectBox, required PocketBase pocketBase, required Settings settings}) {
    if (settings.serverDate.isAfter(settings.boxDate)) {
      syncServer2Box(objectBox: objectBox, pocketBase: pocketBase);
    } else {
      syncBox2Server(objectBox: objectBox, pocketBase: pocketBase);
    }
  }
}
