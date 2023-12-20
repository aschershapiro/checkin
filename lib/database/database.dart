import 'package:checkin/main.dart';
import 'package:checkin/models/day.dart';
import 'package:checkin/models/encryption.dart';
import 'package:checkin/models/longtermitem.dart';
import 'package:checkin/models/settings.dart';
import 'package:checkin/models/todoitem.dart';
import 'package:checkin/objectbox.dart';
import 'package:checkin/objectbox.g.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Database {
  final _pb = PocketBase('https://pb.greenbase.ir');
  bool get isAuth {
    return _pb.authStore.isValid && _pb.authStore.token.isNotEmpty;
  }

  Future<List<RecordModel>> getAllDays() async {
    var resp = await _pb.collection('days').getFullList();
    return resp;
  }

  Future<void> syncBox2Server({required ObjectBox objectBox}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) return;

    try {
      // sync todos from box to server
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
            "task": Encryption.encryptStringWithPassword(
                item.task, c.settings.value.password),
            "user": _pb.authStore.model is String
                ? _pb.authStore.model
                : _pb.authStore.model.id,
            "completed": item.completed.value,
            "duedate": item.dueDate.toString()
          };
          _pb.collection('todo_items').update(pbId, body: body);
        }
        // create
        else {
          final body = <String, dynamic>{
            "boxid": item.id,
            "task": Encryption.encryptStringWithPassword(
                item.task, c.settings.value.password),
            'user': _pb.authStore.model is String
                ? _pb.authStore.model
                : _pb.authStore.model.id,
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

      // sync longterms
      var resp2 = await _pb.collection('longterm_items').getFullList();
      var boxlongterms = objectBox.longtermsBox.getAll();
      for (var item in boxlongterms) {
        var contains = resp2.fold(
            false,
            (previousValue, element) =>
                previousValue || element.data['boxid'] == item.id);
        // update
        if (contains) {
          var pbId = resp2
              .where((element) => element.data['boxid'] == item.id)
              .first
              .id;
          final body = <String, dynamic>{
            "task": Encryption.encryptStringWithPassword(
                item.task, c.settings.value.password),
            "user": _pb.authStore.model is String
                ? _pb.authStore.model
                : _pb.authStore.model.id,
            "completed": item.completed.value,
            "duedate": item.dueDate.toString()
          };
          _pb.collection('longterm_items').update(pbId, body: body);
        }
        // create
        else {
          final body = <String, dynamic>{
            "boxid": item.id,
            "task": Encryption.encryptStringWithPassword(
                item.task, c.settings.value.password),
            'user': _pb.authStore.model is String
                ? _pb.authStore.model
                : _pb.authStore.model.id,
            "completed": item.completed.value,
            "duedate": item.dueDate.toString()
          };
          _pb.collection('longterm_items').create(
                body: body,
              );
        }
      }
      //delete
      var boxIds2 = boxlongterms.map((e) => e.id).toList();
      for (var item in resp2) {
        if (!boxIds2.contains(item.data['boxid'])) {
          _pb.collection('longterm_items').delete(item.id);
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
        if (contains &&
            item.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          var pbId = resp
              .where((element) => element.data['boxid'] == item.id)
              .first
              .id;
          final body = <String, dynamic>{
            "date": item.date,
            'dailyplus': Encryption.encryptStringWithPassword(
                item.plusJsonString, c.settings.value.password),
            'dailyminus': Encryption.encryptStringWithPassword(
                item.minusJsonString, c.settings.value.password),
            'mood': Encryption.encryptStringWithPassword(
                item.mood, c.settings.value.password),
            'summary': Encryption.encryptStringWithPassword(
                item.summary, c.settings.value.password),
            'thanksgiving': Encryption.encryptStringWithPassword(
                item.thanksgiving, c.settings.value.password),
            'boxid': item.id,
            'user': _pb.authStore.model is String
                ? _pb.authStore.model
                : _pb.authStore.model.id
          };
          _pb.collection('days').update(pbId, body: body);
        }
        //create
        else if (!contains) {
          final body = <String, dynamic>{
            "date": item.date,
            'dailyplus': Encryption.encryptStringWithPassword(
                item.plusJsonString, c.settings.value.password),
            'dailyminus': Encryption.encryptStringWithPassword(
                item.minusJsonString, c.settings.value.password),
            'mood': Encryption.encryptStringWithPassword(
                item.mood, c.settings.value.password),
            'summary': Encryption.encryptStringWithPassword(
                item.summary, c.settings.value.password),
            'thanksgiving': Encryption.encryptStringWithPassword(
                item.thanksgiving, c.settings.value.password),
            'boxid': item.id,
            'user': _pb.authStore.model is String
                ? _pb.authStore.model
                : _pb.authStore.model.id
          };
          _pb.collection('days').create(
                body: body,
              );
        }
      }
      // delete
      var daysIds = boxDays.map((e) => e.id).toList();
      for (var item in resp) {
        if (!daysIds.contains(item.data['boxid'])) {
          _pb.collection('days').delete(item.id);
        }
      }

      //sync settings to server
      var id = await _pb.collection('settings').getFullList().then((value) =>
          value
              .where((element) => element.data['title'] == 'dailyplustitles')
              .first
              .id);
      _pb.collection('settings').update(id, body: <String, dynamic>{
        'title': 'dailyplustitles',
        'value': Encryption.encryptStringWithPassword(
            c.settings.value.dailyPlusTitles.toString(),
            c.settings.value.password)
      });

      id = await _pb.collection('settings').getFullList().then((value) => value
          .where((element) => element.data['title'] == 'dailyminustitles')
          .first
          .id);
      _pb.collection('settings').update(id, body: <String, dynamic>{
        'title': 'dailyminustitles',
        'value': Encryption.encryptStringWithPassword(
            c.settings.value.dailyMinusTitles.toString(),
            c.settings.value.password)
      });

      id = await _pb.collection('settings').getFullList().then((value) => value
          .where((element) => element.data['title'] == 'syncdate')
          .first
          .id);
      _pb.collection('settings').update(id, body: <String, dynamic>{
        'title': 'syncdate',
        'value': DateTime.now().subtract(const Duration(minutes: 1)).toString()
      });
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> syncServer2Box({required ObjectBox objectBox}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) return;
    //sync todos from server to box
    var resp = await _pb.collection('todo_items').getFullList();
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
        var todo = TodoItem(
            task: Encryption.decryptStringWithPassword(
                item.data['task'], c.settings.value.password))
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
        var todo = TodoItem(
            task: Encryption.decryptStringWithPassword(
                item.data['task'], c.settings.value.password))
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

    // sync longterms from server to box
    var resp2 = await _pb.collection('longterm_items').getFullList();
    var boxLongterms = objectBox.longtermsBox.getAll();
    for (var item in resp2) {
      var contains = boxLongterms.fold(
          false,
          (previousValue, element) =>
              previousValue || element.id == item.data['boxid']);
      //update
      if (contains) {
        var boxId = boxLongterms
            .where((element) => element.id == item.data['boxid'])
            .first
            .id;
        var longterm = LongTermItem(
            task: Encryption.decryptStringWithPassword(
                item.data['task'], c.settings.value.password))
          ..completed.value = item.data['completed']
          ..dueDate = DateTime.tryParse(
              item.data['duedate'].toString().isNotEmpty
                  ? item.data['duedate'].toString().substring(0, 10)
                  : '')
          ..id = boxId;
        objectBox.longtermsBox.put(longterm, mode: PutMode.update);
      }
      // create
      else {
        var longterm = LongTermItem(
            task: Encryption.decryptStringWithPassword(
                item.data['task'], c.settings.value.password))
          ..completed.value = item.data['completed']
          ..dueDate = DateTime.tryParse(
              item.data['duedate'].toString().isNotEmpty
                  ? item.data['duedate'].toString().substring(0, 10)
                  : '')
          ..id = item.data['boxid'];
        objectBox.longtermsBox.put(longterm, mode: PutMode.put);
      }
    }
    //delete
    var longtermIds = resp2.map((e) => e.data['boxid']).toList();
    for (var item in boxLongterms) {
      if (!longtermIds.contains(item.id)) {
        objectBox.longtermsBox.remove(item.id);
      }
    }

    // sync days from server to box
    resp = await _pb.collection('days').getFullList();
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
          ..minusJsonString = Encryption.decryptStringWithPassword(
              item.data['dailyminus'].toString(), c.settings.value.password)
          ..plusJsonString = Encryption.decryptStringWithPassword(
              item.data['dailyplus'].toString(), c.settings.value.password)
          ..mood = Encryption.decryptStringWithPassword(
              item.data['mood'].toString(), c.settings.value.password)
          ..summary = Encryption.decryptStringWithPassword(
              item.data['summary'].toString(), c.settings.value.password)
          ..thanksgiving = Encryption.decryptStringWithPassword(
              item.data['thanksgiving'].toString(), c.settings.value.password);
        objectBox.dayBox.put(dayBox, mode: PutMode.update);
      }
      // create
      else {
        var dayBox = DayBox()
          ..date = item.data['date'].toString().isNotEmpty
              ? item.data['date'].toString().substring(0, 10)
              : ''
          ..id = item.data['boxid']
          ..minusJsonString = Encryption.decryptStringWithPassword(
              item.data['dailyminus'].toString(), c.settings.value.password)
          ..plusJsonString = Encryption.decryptStringWithPassword(
              item.data['dailyplus'].toString(), c.settings.value.password)
          ..mood = Encryption.decryptStringWithPassword(
              item.data['mood'].toString(), c.settings.value.password)
          ..summary = Encryption.decryptStringWithPassword(
              item.data['summary'].toString(), c.settings.value.password)
          ..thanksgiving = Encryption.decryptStringWithPassword(
              item.data['thanksgiving'].toString(), c.settings.value.password);
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
    // sync settings
    var s1 = await _pb.collection('settings').getFullList().then((value) =>
        value
            .where((element) => element.data['title'] == 'dailyplustitles')
            .first);
    c.settings.value.dailyPlusTitles = (Encryption.decryptStringWithPassword(
            s1.data['value'], c.settings.value.password))
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',')
        .map((e) => e.trim())
        .toList();

    s1 = await _pb.collection('settings').getFullList().then((value) => value
        .where((element) => element.data['title'] == 'dailyminustitles')
        .first);
    c.settings.value.dailyMinusTitles = (Encryption.decryptStringWithPassword(
            s1.data['value'], c.settings.value.password))
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',')
        .map((e) => e.trim())
        .toList();
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
      await syncServer2Box(objectBox: objectBox);
    } else if (isAuth) {
      try {
        syncBox2Server(objectBox: objectBox);
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
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
        if (kDebugMode) {
          print(e.toString());
        }
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
    c.settings.value.userId = _pb.authStore.model.id ?? '';
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
    final body3 = <String, dynamic>{
      "title": "dailyplustitles",
      "value": Encryption.encryptStringWithPassword(
          '[+Task1, +Task2, +Task3]', password),
      "user": record.id
    };
    await _pb.collection('settings').create(body: body3);
    final body4 = <String, dynamic>{
      "title": "dailyminustitles",
      "value": Encryption.encryptStringWithPassword(
          '[-Task1, -Task2, -Task3]', password),
      "user": record.id
    };
    await _pb.collection('settings').create(body: body4);
    await _pb.collection('users').requestVerification(email);
    await objectBox.dayBox.removeAllAsync();
    await objectBox.todosBox.removeAllAsync();
    await objectBox.settingsBox.removeAllAsync();
  }

  Future<void> logout() async {
    _pb.authStore.clear();
    c.settings.value.userId = '';
    c.settings.value.userToken = '';
    c.settings.value.boxDate = DateTime(1980);
    objectBox.settingsBox.put(c.settings.value);
    await objectBox.dayBox.removeAllAsync();
    await objectBox.todosBox.removeAllAsync();
    await objectBox.settingsBox.removeAllAsync();
  }
}
