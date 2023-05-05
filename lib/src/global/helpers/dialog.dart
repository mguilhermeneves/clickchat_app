import 'package:flutter/material.dart';

import '../../app_widget.dart';

class Dialog {
  Future<void> alert(
    String message, {
    void Function()? onPressedOk,
  }) async {
    final context = navigatorKey.currentContext!;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 50,
              ),
              child: Image.asset(
                  'assets/images/illustrations/warning_illustration.png'),
            ),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
        actionsPadding: EdgeInsets.zero,
        actions: [
          Column(
            children: [
              Divider(
                thickness: 1,
                height: 1,
                color: Theme.of(context).colorScheme.outline,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onPressedOk != null) onPressedOk();
                  },
                  child: const Text('OK'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
