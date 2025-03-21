import 'package:sqflite/sqflite.dart';

abstract class BaseDataSource {
  late final Database db;

  Future<void> initDb() async {
    db = await openDatabase(
      'to_do_list.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT, status INTEGER DEFAULT 0 CHECK(status IN (0,1)), due_date TEXT, created_at TEXT DEFAULT CURRENT_TIMESTAMP, updated_at TEXT DEFAULT CURRENT_TIMESTAMP);',
        );
      },
    );
  }

}
