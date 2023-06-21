import 'package:flutter/material.dart';

import '../../app_widget.dart';

class Dialog {
  void alert(
    String message, {
    void Function()? onPressedOk,
  }) {
    final context = navigatorKey.currentContext!;

    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 150),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation1, animation2, widget) {
        return Transform.scale(
          scale: animation1.value,
          child: Opacity(
            opacity: animation1.value,
            child: AlertDialog(
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
          ),
        );
      },
    );
  }
}
