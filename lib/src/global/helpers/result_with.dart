class ResultWith<TData> {
  final List<String> _errors = [];
  TData? _data;

  ResultWith();

  ResultWith.instance({
    required List<String> errors,
    required TData? data,
  }) {
    _data = data;
    _errors.addAll(errors);
  }

  String? get error => _errors.isEmpty ? null : _errors.join(". ");
  bool get succeeded => _errors.isEmpty;
  TData? get data => _data;

  ResultWith.ok(TData data) {
    _data = data;
  }

  ResultWith.error(String errorMessage) {
    _errors.add(errorMessage);
  }

  ResultWith.errors(List<String> errorMessages) {
    _errors.addAll(errorMessages);
  }
}
