import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_version_test/ext/Functions.dart';
import 'package:flutter_new_version_test/note/all/AllEventPage.dart';
import 'package:flutter_new_version_test/note/bean/DiaryRecord.dart';
import 'package:flutter_new_version_test/note/db/DbHelper.dart';
import 'package:provider/provider.dart';

///删除选中的事件
class DeleteDialog {
  static Widget createDialog(BuildContext ctx, AllEventPageData allEventPageData) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 30),
                child: Text(
                  "是否删除，删除不可恢复",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
          Container(
            height: 1,
            color: Colors.deepOrange,
          ),
          Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  Navigator.pop(ctx, false);
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "否",
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
              Container(
                height: 30,
                width: 1,
                color: Colors.deepOrange,
              ),
              Expanded(
                  child: InkWell(
                onTap: () {
                  var helper = DbHelper(DiaryRecord());
                  helper.init().then((value) {
                    var selected = allEventPageData.selected;
                    print(selected);
                    List<Future<int>> task = [];
                    selected.forEach((element) {
                      print(element);
                      task.add(element.delete(helper));
                    });
                    Future.wait(task).then((value) {
                      helper.close();
                      Navigator.pop(ctx, true);
                    });
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "是",
                    textAlign: TextAlign.center,
                  ),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
