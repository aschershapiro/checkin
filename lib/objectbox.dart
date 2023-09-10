import 'package:checkin/main.dart';
import 'package:checkin/models/day.dart';
import 'package:checkin/models/settings.dart';
import 'package:checkin/models/todoitem.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {
  /// The Store of this app.
  late final Store store;
  late final Box<TodoItem> todosBox;
  late final Box<DayBox> dayBox;
  late final Box<Settings> settingsBox;
  late final Query<DayBox> _query;

  ObjectBox._create(this.store) {
    todosBox = store.box<TodoItem>();
    dayBox = store.box<DayBox>();
    settingsBox = store.box<Settings>();
    // Add any additional setup code, e.g. build queries.
    _query = dayBox.query(DayBox_.date.equals(DateFormat('yyyy-MM-dd').format(DateTime.now()))).build();
  }

  DayBox? findToday() {
    var res = _query.find();
    _query.close();
    return res.firstOrNull;
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(directory: p.join(docsDir.path, "checkin"));
    return ObjectBox._create(store);
  }
}
