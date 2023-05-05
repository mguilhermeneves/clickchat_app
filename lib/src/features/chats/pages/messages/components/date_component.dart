import 'package:flutter/material.dart';

import 'package:clickchat_app/src/global/helpers/datetime_extension.dart';

class DateComponent extends StatelessWidget {
  final DateTime? date;
  const DateComponent(this.date, {super.key});

  String getDate() {
    final now = DateTime.now();
    if (now.dateEquals(date)) {
      return 'Hoje';
    }
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    if (yesterday.dateEquals(date)) {
      return 'Ontem';
    }

    return date.dateWithMonthName;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (date == null) return Container();

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: colorScheme.onSurface,
        ),
        child: Text(
          getDate(),
          style: TextStyle(
            color: colorScheme.onSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
