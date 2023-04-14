import 'package:flutter/material.dart';

import '../app_theme.dart';

extension IconExtension on Icon {
  Widget gradient() {
    final defaultSize = size ?? 24;

    return ShaderMask(
      child: Icon(
        icon,
        size: defaultSize,
        color: Colors.white,
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, defaultSize, defaultSize);
        return AppTheme.gradient.createShader(rect);
      },
    );
  }
}
