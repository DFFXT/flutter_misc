import 'package:flutter/cupertino.dart';
import 'package:flutter_new_version_test/note/db/DbSupport.dart';

class DiaryRecord extends ChangeNotifier with WithIdKey implements DbSupport {
  static final String c_title = "title";
  static final String c_content = "content";
  static final String c_createTime = "createTime";
  static final String c_updateTime = "updateTime";

  String title;

  String content;

  String createTime;

  String updateTime;

  @override
  String onCreate() {
    return "create table ${tableName()}(${WithIdKey.c_id} integer primary key AUTOINCREMENT, $c_title TEXT, $c_content TEXT, $c_createTime String, $c_updateTime String)";
  }

  String tableName() => "diaryRecord";

  @override
  Map<String, dynamic> toMap() {
    return {
      WithIdKey.c_id: id,
      c_title: title,
      c_content: content,
      c_createTime: createTime,
      c_updateTime: updateTime
    };
  }

  @override
  DiaryRecord fromMap(Map<String, dynamic> map) {
    id = map[WithIdKey.c_id];
    title = map[c_title];
    content = map[c_content];
    createTime = map[c_createTime];
    updateTime = map[c_updateTime];
    notifyListeners();
    return this;
  }
}
