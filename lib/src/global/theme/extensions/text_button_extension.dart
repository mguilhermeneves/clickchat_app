import 'package:flutter/material.dart';

extension TextButtonExtension on TextButton {
  Widget compact() {
    return SizedBox(
      height: 24,
      child: TextButton(
        style: TextButton.styleFrom(
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
        ),
        onPressed: onPressed,
        child: child!,
      ),
    );
  }
}
