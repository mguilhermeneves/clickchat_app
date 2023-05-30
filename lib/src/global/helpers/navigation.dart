import 'package:clickchat_app/src/app_widget.dart';
import 'package:flutter/material.dart';

class Navigation {
  BuildContext get context => navigatorKey.currentContext!;

  String get currentRoute => ModalRoute.of(context)?.settings.name ?? '';

  void pop<T extends Object?>([T? result]) {
    Navigator.of(context).pop(result);
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamed<T?>(routeName, arguments: arguments);
  }

  void pushReplacementNamed(String routeName, {Object? arguments}) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  void popAndPushReplacementNamed(String routeName) {
    pop();
    pushReplacementNamed(routeName);
  }
}
