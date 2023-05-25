import 'package:clickchat_app/src/app_widget.dart';
import 'package:flutter/material.dart';

class Navigation {
  BuildContext get context => navigatorKey.currentContext!;

  String get currentRoute => ModalRoute.of(context)?.settings.name ?? '';

  void pop<T extends Object?>([T? result]) {
    Navigator.of(context).pop(result);
  }

  void pushReplacementNamed(String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  void popAndPushReplacementNamed(String routeName) {
    pop();
    pushReplacementNamed(routeName);
  }
}
