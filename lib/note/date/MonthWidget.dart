import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_new_version_test/note/NeverOverScroll.dart';
import 'package:flutter_new_version_test/note/bean/AllDiaryRecord.dart';
import 'package:flutter_new_version_test/note/bean/Date.dart';
import 'package:flutter_new_version_test/note/util/DateUtil.dart';
import 'package:provider/provider.dart';

typedef DayClick = void Function(Date);

/// 月份 widget
class MonthWidget extends StatefulWidget {
  final Date _date;
  final DayClick _click;

  MonthWidget(this._date, this._click);

  @override
  State createState() {
    return _MonthWidget();
  }
}

class _MonthWidget extends State<MonthWidget> {
  int weekOfFirstDay;

  @override
  void initState() {
    super.initState();

    weekOfFirstDay = DateTime(widget._date.year, widget._date.month, 1).weekday;
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: ScrollConfiguration(
        behavior: NeverOverScroll(),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisExtent: 50),
          itemBuilder: (_, position) {
            bool today = false;
            if (widget._date.year == time.year &&
                widget._date.month == time.month &&
                widget._date.day == position + 1) {
              today = true;
            }
            int text = position + 2 - weekOfFirstDay;
            if (position + 1 < weekOfFirstDay ||
                weekOfFirstDay + DateUtil.dayOfMoth(widget._date.year, widget._date.month) <= position + 1) {
              text = null;
            }
            return _getDay(text, widget._date.year, widget._date.month, today: today, onClick: () {
              if (text == null) return;
              setState(() {
                var date = Date(position + 2 - weekOfFirstDay, month: widget._date.month, year: widget._date.year);
                widget._click.call(date);
              });
            });
          },
          itemCount: 42,
        ),
      ),
    );
  }

  Widget _getDay(int day, int year, int month, {bool today = false, void onClick()}) {
    Color color;
    Color textColor = Colors.black;
    if (today) {
      color = Colors.blue.shade300;
    } else {
      color = Colors.transparent;
    }
    if (day != null) {
      var all = context.watch<AllDiaryRecord>();
      var find = all.getRecord(Date(day, month: month, year: year).toString());

      if (find != null) {
        textColor = Colors.deepOrange;
      }
    }
    return GestureDetector(
      onTap: () {
        if (onClick != null) {
          onClick();
        }
      },
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        margin: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Text(
          day?.toString() ?? "",
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
