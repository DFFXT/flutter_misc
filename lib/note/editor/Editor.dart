import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_version_test/note/bean/Date.dart';
import 'file:///D:/Android/flutter_new_version_test/lib/note/bean/DiaryRecord.dart';
import 'package:flutter_new_version_test/note/db/DbHelper.dart';
import 'package:provider/provider.dart';

class EditorPage extends StatelessWidget {
  final Date _date;
  final DiaryRecord _record = DiaryRecord();

  EditorPage(this._date) {
    var db = DbHelper(_record);
    db.init().then((value) {
      db.query(DiaryRecord.c_createTime, _date.toString()).then((value) {
        if (value.isNotEmpty) {
          _record.fromMap(value.first);
        }
        db.close();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => _record)],
      child: EditorWidget(_date),
    );
  }
}

class EditorWidget extends StatefulWidget {
  final Date _date;

  EditorWidget(this._date);

  @override
  State createState() {
    return _EditorWidgetState();
  }
}

class _EditorWidgetState extends State<EditorWidget> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final InputBorder _border = UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide:
          BorderSide(color: Colors.red, width: 0.5, style: BorderStyle.solid));

  @override
  void initState() {
    super.initState();
  }

  void onTap() {
    var record = context.read<DiaryRecord>();
    record.title = _controller.text;
    record.content = _contentController.text;
    if (record.createTime == null) {
      record.createTime = widget._date.toString();
    }
    record.updateTime = widget._date.toString();
    var db = DbHelper(record);
    db.init().then((value) {
      record.updateOrInsert(db).then((value) => db.close());
    });
  }

  @override
  Widget build(BuildContext context) {
    var record = context.watch<DiaryRecord>();
    _controller.text = record.title;
    _contentController.text = record.content;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
                child: Text(
              "${widget._date.toString()}",
              textAlign: TextAlign.center,
            )),
            GestureDetector(
              child: Text("保存"),
              onTap: onTap,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          TextField(
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.all(10),
              hintText: "标题",
              focusedBorder: _border,
              enabledBorder: _border,
            ),
            controller: _controller,
          ),
          Expanded(
              child: TextField(
            controller: _contentController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.all(10),
                hintText: "内容",
                border: InputBorder.none),
          ))
        ],
      ),
    );
  }
}
