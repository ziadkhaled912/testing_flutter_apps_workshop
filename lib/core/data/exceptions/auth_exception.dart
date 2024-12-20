import 'package:testing_flutter_apps_workshop/core/data/exceptions/app_exception.dart';

class AuthException extends AppException {
  final String code;
  final String? message;
  
  AuthException({
    required this.code,
    this.message,
  });
}
