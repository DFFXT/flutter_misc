import 'package:flutter/cupertino.dart';

import 'DiaryRecord.dart';

class BaseListNotifier extends ChangeNotifier{
  List<Map<String, dynamic>> _list;

  void setList(List<Map<String, dynamic>> list) {
    _list = list;
    notifyListeners();
  }

  List<Map<String, dynamic>> getList() => _list;
}