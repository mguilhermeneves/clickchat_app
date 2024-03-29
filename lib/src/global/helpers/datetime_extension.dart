import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime? {
  bool dateEquals(DateTime? dateToCompare) {
    if (this == null || dateToCompare == null) {
      return false;
    }

    return this!.year == dateToCompare.year &&
        this!.month == dateToCompare.month &&
        this!.day == dateToCompare.day;
  }

  String get time => DateFormat('HH:mm').format(this!);

  String get date => DateFormat('dd/MM/yyyy').format(this!);

  String get dateWithMonthName {
    final month = _months[this!.month - 1];

    return '${this!.day} de $month de ${this!.year}';
  }

  static const List<String> _months = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro'
  ];
}
