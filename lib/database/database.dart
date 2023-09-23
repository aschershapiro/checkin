import 'package:checkin/main.dart';
import 'package:checkin/models/day.dart';
import 'package:checkin/models/settings.dart';
import 'package:checkin/models/todoitem.dart';
import 'package:checkin/objectbox.dart';
import 'package:checkin/objectbox.g.dart';
import 'package:pocketbase/pocketbase.dart';

class Database {
  final _pb = PocketBase('https://pb.greenbase.ir');
  bool get isAuth {
    return _pb.authStore.isValid && _pb.authStore.token.isNotEmpty;
  }

  Future<void> syncBox2Server({required ObjectBox objectBox}) async {
    // sync todos from box to server
    try {
      var resp = await _pb.collection('todo_items').getFullList();
      var boxItems = objectBox.todosBox.getAll();
      for (var item in boxItems) {
        var contains = resp.fold(
            false,
            (previousValue, element) =>
                previousValue || element.data['boxid'] == item.id);
        // update
        if (contains) {
          var pbId = resp
              .where((element) => element.data['boxid'] == item.id)
              .first
              .id;
          final body = <String, dynamic>{
            "task": item.task,
            "user": _pb.authStore.model,
            "completed": item.completed.value,
            "duedate": item.dueDate.toString()
          };
          _pb.collection('todo_items').update(pbId, body: body);
        }
        // create
        else {
          final body = <String, dynamic>{
            "boxid": item.id,
            "task": item.task,
            "user": _pb.authStore.model,
            "completed": item.completed.value,
            "duedate": item.dueDate.toString()
          };
          _pb.collection('todo_items').create(
                body: body,
              );
        }
      }
      //delete
      var boxIds = boxItems.map((e) => e.id).toList();
      for (var item in resp) {
        if (!boxIds.contains(item.data['boxid'])) {
          _pb.collection('todo_items').delete(item.id);
        }
      }
      // sync day from box to server
      resp = await _pb.collection('days').getFullList();
      var boxDays = objectBox.dayBox.getAll();
      for (var item in boxDays) {
        var contains = resp.fold(
            false,
            (previousValue, element) =>
                previousValue || element.data['boxid'] == item.id);

        //update
        if (contains) {
          var pbId = resp
              .where((element) => element.data['boxid'] == item.id)
              .first
              .id;
          final body = <String, dynamic>{
            "date": item.date,
            'dailyplus': item.plusJsonString,
            'dailyminus': item.minusJsonString,
            'boxid': item.id,
            'user': _pb.authStore.model
          };
          _pb.collection('days').update(pbId, body: body);
        }
        //create
        else {
          final body = <String, dynamic>{
            "date": item.date,
            'dailyplus': item.plusJsonString,
            'dailyminus': item.minusJsonString,
            'boxid': item.id,
            'user': _pb.authStore.model
          };
          _pb.collection('days').create(
                body: body,
              );
        }
      }
      //delete
      var daysIds = boxDays.map((e) => e.id).toList();
      for (var item in resp) {
        if (!daysIds.contains(item.data['boxid'])) {
          _pb.collection('days').delete(item.id);
        }
      }
      var id = await _pb.collection('settings').getFullList().then((value) =>
          value
              .where((element) => element.data['title'] == 'syncdate')
              .first
              .id);
      _pb.collection('settings').update(id, body: <String, dynamic>{
        'title': 'syncdate',
        'value': DateTime.now().subtract(const Duration(minutes: 1)).toString()
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> syncServer2Box(
      {required ObjectBox objectBox, required PocketBase pocketBase}) async {
    //sync todos from server to box
    var resp = await pocketBase.collection('todo_items').getFullList();
    var boxItems = objectBox.todosBox.getAll();
    for (var item in resp) {
      var contains = boxItems.fold(
          false,
          (previousValue, element) =>
              previousValue || element.id == item.data['boxid']);
      //update
      if (contains) {
        var boxId = boxItems
            .where((element) => element.id == item.data['boxid'])
            .first
            .id;
        var todo = TodoItem(task: item.data['task'])
          ..completed.value = item.data['completed']
          ..dueDate = DateTime.tryParse(
              item.data['duedate'].toString().isNotEmpty
                  ? item.data['duedate'].toString().substring(0, 10)
                  : '')
          ..id = boxId;
        objectBox.todosBox.put(todo, mode: PutMode.update);
      }
      // create
      else {
        var todo = TodoItem(task: item.data['task'])
          ..completed.value = item.data['completed']
          ..dueDate = DateTime.tryParse(
              item.data['duedate'].toString().isNotEmpty
                  ? item.data['duedate'].toString().substring(0, 10)
                  : '')
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
      var contains = boxdays.fold(
          false,
          (previousValue, element) =>
              previousValue || element.id == item.data['boxid']);
      //update
      if (contains) {
        //var boxId = boxdays.where((element) => element.id == item.data['boxid']).first.id;
        var dayBox = DayBox()
          ..date = item.data['date'].toString().isNotEmpty
              ? item.data['date'].toString().substring(0, 10)
              : ''
          ..id = item.data['boxid']
          ..minusJsonString = item.data['dailyminus'].toString()
          ..plusJsonString = item.data['dailyplus'].toString();
        objectBox.dayBox.put(dayBox, mode: PutMode.update);
      }
      // create
      else {
        var dayBox = DayBox()
          ..date = item.data['date'].toString().isNotEmpty
              ? item.data['date'].toString().substring(0, 10)
              : ''
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

  Future<void> initialSync(
      {required ObjectBox objectBox, required Settings settings}) async {
    var aaa = await _pb.collection('settings').getFullList().then((value) =>
        value
            .firstWhere((element) => element.data['title'] == 'syncdate')
            .data['value']
            .toString());
    var serverDate = DateTime.parse(aaa);
    if (serverDate.isAfter(settings.boxDate)) {
      await syncServer2Box(objectBox: objectBox, pocketBase: _pb);
    } else if (isAuth) {
      try {
        syncBox2Server(objectBox: objectBox);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<bool> autoLogin() async {
    if (c.settings.value.userToken == '' || c.settings.value.userId == '') {
      return false;
    } else {
      try {
        _pb.authStore.save(c.settings.value.userToken, c.settings.value.userId);
        await database.initialSync(
            objectBox: objectBox, settings: c.settings.value);
        await c.init();
        return _pb.authStore.isValid;
      } catch (e) {
        print(e.toString());
        await c.init();
        return false;
      }
    }
  }

  Future<void> login(String email, String password) async {
    final authData = await _pb.collection('users').authWithPassword(
          email,
          password,
        );
    c.settings.value.userId = _pb.authStore.model ?? '';
    c.settings.value.userToken = _pb.authStore.token;
    objectBox.settingsBox.put(c.settings.value);
  }

  Future<void> signup(
      {required username,
      required String email,
      required bool emailVisibility,
      required String password,
      required String passwordConfirm}) async {
    final body = <String, dynamic>{
      "username": username,
      "email": email,
      "emailVisibility": true,
      "password": password,
      "passwordConfirm": passwordConfirm,
      "name": username
    };

    final record = await _pb.collection('users').create(body: body);
    final body2 = <String, dynamic>{
      "title": "syncdate",
      "value": DateTime(1990).toString(),
      "user": record.id
    };
    await _pb.collection('settings').create(body: body2);
    await _pb.collection('users').requestVerification(email);
    await objectBox.dayBox.removeAllAsync();
    await objectBox.todosBox.removeAllAsync();
    await objectBox.settingsBox.removeAllAsync();
  }

  Future<void> logout() async {}
}
