import 'package:clickchat_app/src/app_widget.dart';
import 'package:flutter/material.dart';

class Navigation {
  BuildContext get context => navigatorKey.currentContext!;

  void pop<T extends Object?>([T? result]) {
    Navigator.of(context).pop(result);
  }
}
