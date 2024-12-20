import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:testing_flutter_apps_workshop/core/data/exceptions/app_exception.dart';
import 'package:testing_flutter_apps_workshop/core/data/exceptions/auth_exception.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/requests/login_request_model.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/requests/register_request_model.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/response/auth_user_model.dart';

abstract class AuthServices {
  AuthUserModel? get currentUser;

  Future<AuthUserModel?> loginWithEmailAndPassword(
      LoginRequestModel request);

  Future<AuthUserModel?> signUpWithEmailAndPassword(
      RegisterRequestModel request);

  Future<void> logout();
}

@LazySingleton(as: AuthServices)
class AuthServicesImpl implements AuthServices {
  AuthServicesImpl({
    @ignoreParam FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  AuthUserModel? get currentUser => _firebaseAuth.currentUser != null
      ? AuthUserModel.fromFirebaseUser(_firebaseAuth.currentUser!)
      : null;

  @override
  Future<AuthUserModel?> loginWithEmailAndPassword(
      LoginRequestModel request) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );
      return AuthUserModel.fromFirebaseUser(user.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        code: e.code,
        message: e.message,
      );
    } on Exception catch (e) {
      throw UnknownException(
        exception: e,
        message: e.toString(),
      );
    }
  }

  @override
  Future<AuthUserModel?> signUpWithEmailAndPassword(
      RegisterRequestModel request) async {
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );
      await user.user!.updateDisplayName(request.name);
      return AuthUserModel.fromFirebaseUser(user.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        code: e.code,
        message: e.message,
      );
    } on Exception catch (e) {
      throw UnknownException(
        exception: e,
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> logout() {
    try {
      return _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        code: e.code,
        message: e.message,
      );
    } on Exception catch (e) {
      throw UnknownException(
        exception: e,
        message: e.toString(),
      );
    }
  }
}
