import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_version_test/base/LifeCycleState.dart';
import 'package:flutter_new_version_test/note/all/AllEventPage.dart';
import 'package:flutter_new_version_test/note/bean/AllDiaryRecord.dart';
import 'package:flutter_new_version_test/note/bean/Date.dart';
import 'package:flutter_new_version_test/note/bean/DiaryRecord.dart';
import 'package:flutter_new_version_test/note/db/DbHelper.dart';
import 'package:flutter_new_version_test/note/editor/Editor.dart';
import 'package:provider/provider.dart';

import 'MonthWidget.dart';

class NoteHomeWidget extends StatefulWidget {
  @override
  State createState() => _NoteHomeState();
}

class _NoteHomeState extends LifeCycleState<NoteHomeWidget> with WidgetsBindingObserver {
  DateTime _dateTime = DateTime.now();
  Date _date;
  AllDiaryRecord _allDiaryRecord = AllDiaryRecord();

  @override
  void initState() {
    super.initState();
    _date = Date(_dateTime.day, year: _dateTime.year, month: _dateTime.month);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => _date), ChangeNotifierProvider(create: (_) => _allDiaryRecord)],
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                  child: Text(
                "记事本",
                textAlign: TextAlign.center,
              )),
              GestureDetector(
                child: Text("全部"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                    return AllEventPage();
                  }));
                },
              )
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: CurrentTimeWidget(),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _getWeekWidget("一"),
                  _getWeekWidget("二"),
                  _getWeekWidget("三"),
                  _getWeekWidget("四"),
                  _getWeekWidget("五"),
                  _getWeekWidget("六"),
                  _getWeekWidget("日"),
                ],
              ),
            ),
            MonthPageView()
          ],
        ),
      ),
    );
  }

  Widget _getWeekWidget(String text) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class CurrentTimeWidget extends StatefulWidget {
  @override
  State createState() {
    return _CurrentTimeState();
  }
}

class _CurrentTimeState extends State {
  @override
  Widget build(BuildContext context) {
    return Text(
      _getTime(context),
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  String _getTime(BuildContext context) {
    Date _date = context.watch<Date>();
    return "${_date.year}年${_date.month}月";
  }
}

class MonthPageView extends StatefulWidget {
  @override
  State createState() => _MonthPageViewState();
}

class _MonthPageViewState extends State<MonthPageView> {
  PageController _controller = PageController(initialPage: DateTime.now().month - 1);

  @override
  void initState() {
    super.initState();
    getDate();
  }

  void getDate() {
    var db = DbHelper(DiaryRecord());
    db.init().then((value) {
      db.all().then((value) {
        context.read<AllDiaryRecord>().setList(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 301,
      child: PageView.builder(
        itemBuilder: (_, position) {
          return MonthWidget(Date(DateTime.now().day, month: position + 1, year: DateTime.now().year), (date) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => EditorPage(date))).then((value) {
              getDate();
            });
          });
        },
        itemCount: 12,
        controller: _controller,
        onPageChanged: (position) {
          context.read<Date>().set(month: position + 1);
        },
      ),
    );
  }
}
