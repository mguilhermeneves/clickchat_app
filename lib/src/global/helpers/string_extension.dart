extension StringExtension on String? {
  bool get isNull => this == null;

  bool get isNullOrEmpty {
    return isNull || this!.isEmpty;
  }

  String get firstLetter {
    if (isNullOrEmpty) return '';

    return this!.trim()[0].toUpperCase();
  }
}
