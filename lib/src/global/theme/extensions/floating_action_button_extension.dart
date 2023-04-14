import 'package:flutter/material.dart';

import '../app_theme.dart';

extension FloatingActionButtonExtension on FloatingActionButton {
  DecoratedBox gradient() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppTheme.gradient,
        borderRadius: BorderRadius.circular(100),
      ),
      child: FloatingActionButton(
        key: key,
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: child,
      ),
    );
  }
}
