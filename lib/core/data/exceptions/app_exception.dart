abstract class AppException implements Exception {}

class UnknownException extends AppException {
  final String? message;
  final Exception exception;

  UnknownException({this.message, required this.exception});
}
