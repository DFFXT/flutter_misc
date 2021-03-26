import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_version_test/note/all/DeleteDialog.dart';
import 'package:flutter_new_version_test/note/bean/AllDiaryRecord.dart';
import 'package:flutter_new_version_test/note/bean/Date.dart';
import 'package:flutter_new_version_test/note/bean/DiaryRecord.dart';
import 'package:flutter_new_version_test/note/db/DbHelper.dart';
import 'package:flutter_new_version_test/note/editor/Editor.dart';
import 'package:provider/provider.dart';

///全部事件页面
class AllEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AllDiaryRecord()),
        ChangeNotifierProvider(create: (_) => AllEventPageData())
      ],
      child: Scaffold(
        appBar: _AppBar(),
        body: _AllEventWidget(),
      ),
    );
  }
}

class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<StatefulWidget> createState() => _AppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<_AppBar> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    var helper = DbHelper(DiaryRecord());
    helper.init().then((value) {
      helper.all().then((value) {
        helper.close();
        context.read<AllDiaryRecord>().setList(value);
        print(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(right: 40),
            child: Text("所有事件", textAlign: TextAlign.center),
          )),
          Container(
              width: 50,
              child: Visibility(visible: context.watch<AllEventPageData>().multiSelect, child: getDelWidget())),
        ],
      ),
    );
  }

  Widget getDelWidget() {
    return GestureDetector(
      child: Text("删除"),
      onTap: () {
        var data = context.read<AllEventPageData>();
        showDialog(
            context: context,
            builder: (ctx) {
              return DeleteDialog.createDialog(ctx, data);
            }).then((del) {
          if (del) {
            data.multiSelect = false;
            data.selected.clear();
            data.notifyListeners();
            refresh();
          }
        });
      },
    );
  }
}

class _AllEventWidget extends StatefulWidget {
  @override
  State createState() {
    return _AllEventState();
  }
}

class _AllEventState extends State<_AllEventWidget> {
  @override
  Widget build(BuildContext context) {
    var all = context.watch<AllDiaryRecord>().getStdList();
    var _pageData = context.watch<AllEventPageData>();
    var _multiSelect = _pageData.multiSelect;
    Set<DiaryRecord> _selected = _pageData.selected;
    return WillPopScope(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            var item = all[index];
            return Container(
              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
              padding: EdgeInsets.only(bottom: 4),
              decoration: ShapeDecoration(
                  shape: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, style: BorderStyle.solid, width: 1))),
              child: GestureDetector(
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.createTime,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6),
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      )),
                      if (_multiSelect)
                        if (_selected.contains(item)) Icon(Icons.check_box) else Icon(Icons.check_box_outline_blank)
                    ],
                  ),
                ),
                onTap: () {
                  if (_multiSelect) {
                    if (_selected.contains(item)) {
                      _selected.remove(item);
                    } else {
                      _selected.add(item);
                    }
                    _pageData.notifyListeners();
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return EditorPage(Date.toDate(item.createTime));
                    }));
                  }
                },
                onLongPress: () {
                  _pageData.multiSelect = true;
                  _pageData.selected.add(item);
                  _pageData.notifyListeners();
                },
              ),
            );
          },
          itemCount: all?.length ?? 0,
        ),
        onWillPop: () {
          var res = Future.value(!_multiSelect);
          if (_multiSelect) {
            setState(() {
              _pageData.selected.clear();
              _pageData.multiSelect = false;
              _pageData.notifyListeners();
            });
          }
          return res;
        });
  }
}

class AllEventPageData extends ChangeNotifier {
  var multiSelect = false;
  var selected = Set<DiaryRecord>();

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
