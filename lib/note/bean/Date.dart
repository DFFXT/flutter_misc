import 'package:flutter/cupertino.dart';
import 'package:sprintf/sprintf.dart';

class Date extends ChangeNotifier {
  int year = -1;
  int month = -1;
  int day;

  Date(this.day, {this.month, this.year});

  int dayOfWeek() {
    return DateTime(year, month, day).weekday;
  }

  void set({int year, int month, int day}) {
    if (year != null) {
      this.year = year;
    }
    if (month != null) {
      this.month = month;
    }
    if (day != null) {
      this.day = day;
    }
    notifyListeners();
  }

  @override
  String toString() {
    return "$year-${sprintf("%02d",[month])}-${sprintf("%02d",[day])}";
  }

  static Date toDate(String date){
    var list = date.split('-');
    if(list.length >= 3){
      var res = Date(int.parse(list[2]),month: int.parse(list[1]),year: int.parse(list[0]));
      return res;
    }
    return null;
  }

}
