import 'package:equatable/equatable.dart';
import 'package:testing_flutter_apps_workshop/core/data/failures/failure.dart';

enum AuthFailureType {
  invalidEmail,
  invalidPassword,
  userNotFound,
  userDisabled,
  wrongPassword,
  tooManyRequests,
  userAlreadyExists,
  operationNotAllowed,
  unknown,
}

class AuthFailure extends Failure {
  final AuthFailureType type;
  final String? errorMessage;

  AuthFailure({
    required this.type,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [
        type,
        errorMessage,
      ];
}
