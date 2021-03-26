import 'package:flutter/cupertino.dart';

/// 禁止过度滚动
class NeverOverScroll extends ScrollBehavior{

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}