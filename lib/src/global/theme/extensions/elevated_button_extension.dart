import 'package:flutter/material.dart';

import '../app_theme.dart';

extension ElevatedButtonExtension on ElevatedButton {
  DecoratedBox gradient() {
    final defaultStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppTheme.gradient,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ElevatedButton(
        key: key,
        onPressed: onPressed,
        style: (style ?? defaultStyle).merge(defaultStyle),
        onFocusChange: onFocusChange,
        onHover: onHover,
        statesController: statesController,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        focusNode: focusNode,
        onLongPress: onLongPress,
        child: child,
      ),
    );
  }
}
