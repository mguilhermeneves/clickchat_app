import 'package:flutter/material.dart';

import '../app_theme.dart';

extension IconButtonExtension on IconButton {
  DecoratedBox gradient() {
    final defaultStyle = IconButton.styleFrom(
      backgroundColor: Colors.transparent,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppTheme.gradient,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            key: key,
            splashColor: Colors.white.withOpacity(0.2),
            onPressed: onPressed,
            style: (style ?? defaultStyle).merge(defaultStyle),
            autofocus: autofocus,
            focusNode: focusNode,
            icon: icon,
          ),
        ),
      ),
    );
  }
}
