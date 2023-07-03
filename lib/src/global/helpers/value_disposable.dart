abstract class ValueDisposable {
  /// Utilizado em classes providers em AppProvider.disposeValues()
  Future<void> disposeValue();
}
