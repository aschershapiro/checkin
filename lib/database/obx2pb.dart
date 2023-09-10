import 'package:checkin/models/day.dart';
import 'package:checkin/models/settings.dart';
import 'package:checkin/models/todoitem.dart';
import 'package:checkin/objectbox.dart';
import 'package:checkin/objectbox.g.dart';
import 'package:pocketbase/pocketbase.dart';

class Database {
  static void syncBox2Server({required ObjectBox objectBox, required PocketBase pocketBase}) async {
    // sync todos from box to server
    var resp = await pocketBase.collection('todo_items').getFullList();
    var boxItems = objectBox.todosBox.getAll();
    for (var item in boxItems) {
      var contains = resp.fold(false, (previousValue, element) => previousValue || element.data['boxid'] == item.id);
      // update
      if (contains) {
        var pbId = resp.where((element) => element.data['boxid'] == item.id).first.id;
        final body = <String, dynamic>{"task": item.task, "user": pocketBase.authStore.model.id, "completed": item.completed.value, "duedate": item.dueDate.toString()};
        pocketBase.collection('todo_items').update(pbId, body: body);
      }
      // create
      else {
        final body = <String, dynamic>{"boxid": item.id, "task": item.task, "user": pocketBase.authStore.model.id, "completed": item.completed.value, "duedate": item.dueDate.toString()};
        pocketBase.collection('todo_items').create(
              body: body,
            );
      }
    }
    //delete
    var boxIds = boxItems.map((e) => e.id).toList();
    for (var item in resp) {
      if (!boxIds.contains(item.data['boxid'])) {
        pocketBase.collection('todo_items').delete(item.id);
      }
    }
    // sync day from box to server
    resp = await pocketBase.collection('days').getFullList();
    var boxDays = objectBox.dayBox.getAll();
    for (var item in boxDays) {
      var contains = resp.fold(false, (previousValue, element) => previousValue || element.data['boxid'] == item.id);

      //update
      if (contains) {
        var pbId = resp.where((element) => element.data['boxid'] == item.id).first.id;
        final body = <String, dynamic>{"date": item.date, 'dailyplus': item.plusJsonString, 'dailyminus': item.minusJsonString, 'boxid': item.id, 'user': pocketBase.authStore.model.id};
        pocketBase.collection('days').update(pbId, body: body);
      }
      //create
      else {
        final body = <String, dynamic>{"date": item.date, 'dailyplus': item.plusJsonString, 'dailyminus': item.minusJsonString, 'boxid': item.id, 'user': pocketBase.authStore.model.id};
        pocketBase.collection('days').create(
              body: body,
            );
      }
    }
    //delete
    var daysIds = boxDays.map((e) => e.id).toList();
    for (var item in resp) {
      if (!daysIds.contains(item.data['boxid'])) {
        pocketBase.collection('days').delete(item.id);
      }
    }
  }

  static void syncServer2Box({required ObjectBox objectBox, required PocketBase pocketBase}) async {
    //sync todos from server to box
    var resp = await pocketBase.collection('todo_items').getFullList();
    var boxItems = objectBox.todosBox.getAll();
    for (var item in resp) {
      var contains = boxItems.fold(false, (previousValue, element) => previousValue || element.id == item.data['boxid']);
      //update
      if (contains) {
        var boxId = boxItems.where((element) => element.id == item.data['boxid']).first.id;
        var todo = TodoItem(task: item.data['task'])
          ..completed.value = item.data['completed']
          ..dueDate = DateTime.tryParse(item.data['duedate'].toString().isNotEmpty ? item.data['duedate'].toString().substring(0, 10) : '')
          ..id = boxId;
        objectBox.todosBox.put(todo, mode: PutMode.update);
      }
      // create
      else {
        var todo = TodoItem(task: item.data['task'])
          ..completed.value = item.data['completed']
          ..dueDate = DateTime.tryParse(item.data['duedate'].toString().isNotEmpty ? item.data['duedate'].toString().substring(0, 10) : '')
          ..id = item.data['boxid'];
        objectBox.todosBox.put(todo, mode: PutMode.put);
      }
    }
    //delete
    var todosIds = resp.map((e) => e.data['boxid']).toList();
    for (var item in boxItems) {
      if (!todosIds.contains(item.id)) {
        objectBox.todosBox.remove(item.id);
      }
    }

    // sync days from server to box
    resp = await pocketBase.collection('days').getFullList();
    var boxdays = objectBox.dayBox.getAll();
    for (var item in resp) {
      var contains = boxdays.fold(false, (previousValue, element) => previousValue || element.id == item.data['boxid']);
      //update
      if (contains) {
        var boxId = boxdays.where((element) => element.id == item.data['boxid']).first.id;
        var dayBox = DayBox()
          ..date = item.data['date'].toString().isNotEmpty ? item.data['date'].toString().substring(0, 10) : ''
          ..id = item.data['boxid']
          ..minusJsonString = item.data['dailyminus'].toString()
          ..plusJsonString = item.data['dailyplus'].toString();
        objectBox.dayBox.put(dayBox, mode: PutMode.update);
      }
      // create
      else {
        var dayBox = DayBox()
          ..date = item.data['date'].toString().isNotEmpty ? item.data['date'].toString().substring(0, 10) : ''
          ..id = item.data['boxid']
          ..minusJsonString = item.data['dailyminus'].toString()
          ..plusJsonString = item.data['dailyplus'].toString();
        objectBox.dayBox.put(dayBox, mode: PutMode.put);
      }
    }
    //delete
    var daysIds = resp.map((e) => e.data['boxid']).toList();
    for (var item in boxdays) {
      if (!daysIds.contains(item.id)) {
        objectBox.todosBox.remove(item.id);
      }
    }
  }

  static void sync({required ObjectBox objectBox, required PocketBase pocketBase, required Settings settings}) {
    if (settings.serverDate.isAfter(settings.boxDate)) {
      syncServer2Box(objectBox: objectBox, pocketBase: pocketBase);
    } else {
      syncBox2Server(objectBox: objectBox, pocketBase: pocketBase);
    }
  }
}
