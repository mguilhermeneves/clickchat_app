import 'package:flutter/material.dart';

extension CircularProgressIndicatorExtension on CircularProgressIndicator {
  SizedBox elevatedButton() {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }
}
