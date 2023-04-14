class Result {
  final List<String> _errors = [];

  Result();

  Result.instance({
    required List<String> errors,
  }) {
    _errors.addAll(errors);
  }

  String? get error => _errors.isEmpty ? null : _errors.join(". ");
  bool get succeeded => _errors.isEmpty;

  Result.ok();

  Result.error(String errorMessage) {
    _errors.add(errorMessage);
  }

  Result.errors(List<String> errorMessages) {
    _errors.addAll(errorMessages);
  }

  void addError(String errorMessage) {
    _errors.add(errorMessage);
  }
}
