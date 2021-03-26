import 'package:flutter_new_version_test/note/db/DbSupport.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// 通用数据库helper
class DbHelper<T extends DbSupport> {
  Database _db;
  T _support;

  DbHelper(this._support);

  Future<DbHelper> init() async {
    String rootDir = await getDatabasesPath();
    var path = join(rootDir, "db");
    //onCreate方法需要async 和 await
    _db = await openDatabase(path, version: 3, onCreate: (db, v) async {
      await db.execute(_support.onCreate());
    });
    return this;
  }

  Future<int> insert(Map<String, dynamic> map) {
    return _db.insert(_support.tableName(), map);
  }

  Future<int> update(Map<String, dynamic> map, String where, List<dynamic> whereArgs) {
    return _db.update(_support.tableName(), map, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> query(String column, dynamic value) {
    return _db.query(_support.tableName(), where: '$column = ?', whereArgs: [value]);
  }

  Future<List<Map<String, dynamic>>> all() {
    return _db.rawQuery("select * from ${_support.tableName()}");
  }

  Future<int> delete(String column, dynamic value) {
    return _db.delete(_support.tableName(), where: '$column = ?', whereArgs: [value]);
  }

  void close() {
    _db.close();
  }

  Future<void> clear() {
    return _db.execute("drop table ${_support.tableName()}");
  }
}
