import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:testing_flutter_apps_workshop/core/data/exceptions/app_exception.dart';
import 'package:testing_flutter_apps_workshop/core/data/failures/auth_failure.dart';
import 'package:testing_flutter_apps_workshop/core/data/failures/failure.dart';
import 'package:testing_flutter_apps_workshop/core/data/failures/firebase_auth_exception_handler.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/requests/login_request_model.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/requests/register_request_model.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/response/auth_user_model.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/services/auth_services.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUserModel>> signInWithEmailAndPassword(
      LoginRequestModel loginRequestModel);

  Future<Either<Failure, AuthUserModel>> signUpWithEmailAndPassword(
      RegisterRequestModel registerRequestModel);

  Future<void> signOut();

  AuthUserModel? get currentUser;
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl(this._authServices);

  final AuthServices _authServices;

  @override
  AuthUserModel? get currentUser => _authServices.currentUser;

  @override
  Future<Either<Failure, AuthUserModel>> signInWithEmailAndPassword(
      LoginRequestModel loginRequestModel) async {
    try {
      final result =
          await _authServices.loginWithEmailAndPassword(loginRequestModel);
      return Right(result!);
    } on AppException catch (e) {
      return Left(AuthExceptionHandler().handle(e));
    } catch (e) {
      return Left(AuthFailure(
        errorMessage: 'An unknown error occurred',
        type: AuthFailureType.unknown,
      ));
    }
  }

  @override
  Future<Either<Failure, AuthUserModel>> signUpWithEmailAndPassword(
      RegisterRequestModel registerRequestModel) async {
    try {
      final result =
          await _authServices.signUpWithEmailAndPassword(registerRequestModel);
      return Right(result!);
    } on AppException catch (e) {
      return Left(AuthExceptionHandler().handle(e));
    } catch (e) {
      return Left(AuthFailure(
        errorMessage: 'An unknown error occurred',
        type: AuthFailureType.unknown,
      ));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      return await _authServices.logout();
    } on AppException catch (e) {
      throw AuthExceptionHandler().handle(e);
    } catch (e) {
      throw AuthFailure(
        errorMessage: 'An unknown error occurred',
        type: AuthFailureType.unknown,
      );
    }
  }
}
