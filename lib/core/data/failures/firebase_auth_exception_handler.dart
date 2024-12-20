import 'package:testing_flutter_apps_workshop/core/data/exceptions/auth_exception.dart';
import 'package:testing_flutter_apps_workshop/core/data/failures/auth_failure.dart';
import 'package:testing_flutter_apps_workshop/core/data/failures/failure.dart';
import 'package:testing_flutter_apps_workshop/core/data/failures/unknown_failure.dart';

class AuthExceptionHandler {
  AuthExceptionHandler();

  Failure handle(Exception exception) {
    Failure? failure;
    if (exception is AuthException) {
      if (exception.code == 'invalid-email') {
        return AuthFailure(
          type: AuthFailureType.invalidEmail,
          errorMessage: exception.message ?? 'Invalid email',
        );
      } else if (exception.code == 'email-already-exists') {
        return AuthFailure(
          type: AuthFailureType.userAlreadyExists,
          errorMessage: exception.message ?? 'Email already exists',
        );
      } else if (exception.code == 'invalid-password') {
        return AuthFailure(
          type: AuthFailureType.wrongPassword,
          errorMessage: exception.message ?? 'Invalid password',
        );
      } else if (exception.code == 'user-not-found' ||
          exception.code == 'invalid-credential') {
        return AuthFailure(
          type: AuthFailureType.userNotFound,
          errorMessage: exception.message ?? 'User not found',
        );
      } else if (exception.code == 'operation-not-allowed') {
        return AuthFailure(
          type: AuthFailureType.operationNotAllowed,
          errorMessage: exception.message ?? 'Operation not allowed',
        );
      } else {
        return AuthFailure(
          type: AuthFailureType.unknown,
          errorMessage: exception.message ?? 'Unknown error',
        );
      }
    }
    return failure ?? UnknownFailure(exception: exception);
  }
}
