import 'package:flutter_new_version_test/ext/CollectionsExt.dart';
import 'package:flutter_new_version_test/note/bean/BaseListNotifier.dart';
import 'package:flutter_new_version_test/note/bean/DiaryRecord.dart';

class AllDiaryRecord extends BaseListNotifier {
  List<DiaryRecord> _drList = [];

  @override
  void setList(List<Map<String, dynamic>> list) {
    _drList.clear();
    list?.forEach((element) {
      _drList.add(DiaryRecord().fromMap(element));
    });
    _drList.sort((a, b) {
      return a.createTime.compareTo(b.createTime);
    });
    super.setList(list);
  }

  List<DiaryRecord> getStdList() {
    return _drList;
  }

  DiaryRecord getRecord(String date) {
    return _drList.find<DiaryRecord>((e) => e.createTime == date);
  }
}
