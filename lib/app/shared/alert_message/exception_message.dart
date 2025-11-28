class ExceptionMessage implements Exception {
  ExceptionMessage({required this.error, required this.errorDescription});
  final String error;
  final String errorDescription;
}
