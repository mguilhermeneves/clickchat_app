import 'package:flutter/material.dart';

class Messenger extends StatelessWidget {
  final String message;
  final Widget? action;
  final bool alert;

  const Messenger(
    this.message, {
    super.key,
    this.action,
  }) : alert = false;

  const Messenger.alert(
    this.message, {
    super.key,
    this.action,
  }) : alert = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 50,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (alert)
              Image.asset(
                'assets/images/illustrations/warning_illustration.png',
                width: 200,
              ),
            if (alert) const SizedBox(height: 30),
            Text(message, textAlign: TextAlign.center),
            if (action != null) const SizedBox(height: 10),
            if (action != null) action!,
          ],
        ),
      ),
    );
  }
}
