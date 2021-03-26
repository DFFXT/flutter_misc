import 'package:flutter_new_version_test/note/db/DbHelper.dart';

///数据bean必须实现的接口
abstract class DbSupport {
  String onCreate();

  String tableName();

  Map<String, dynamic> toMap();

  DbSupport fromMap(Map<String, dynamic> map);
}

///如果表存在主键id，可以with进去
abstract class WithIdKey {
  static final String c_id = "id";
  int id;

  Future<int> updateOrInsert(DbHelper db) {
    if (this is DbSupport) {
      var support = (this as DbSupport);
      if (id == null) {
        return db.insert(support.toMap());
      } else {
        return db.update(support.toMap(), '$c_id = ?', [id]);
      }
    }
    return Future.value(0);
  }

  Future<int> delete(DbHelper helper) {
    if (id != null) {
      return helper.delete(c_id, id);
    }
    return Future.value(0);
  }
}
