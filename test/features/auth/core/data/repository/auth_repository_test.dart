import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testing_flutter_apps_workshop/core/data/failures/failure.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/response/auth_user_model.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/repository/auth_repository.dart';

import '../../../../../mocks/data/auth/models/mock_auth_user_model.dart';
import '../../../../../mocks/data/auth/models/mock_login_request_model.dart';
import '../../../../../mocks/data/auth/services/mock_auth_services.dart';

void main() {
  late MockAuthServices authServices;
  late AuthRepository authRepository;

  setUpAll(() {
    authServices = MockAuthServices();
    authRepository = AuthRepositoryImpl(authServices);
  });

  group('signInWithEmailAndPassword Tests', () {
    test('''Should Return AuthUserModel if call to auth services is success''',
        () async {
      // Arrange
      when(() => authServices
              .loginWithEmailAndPassword(MockLoginRequestModel.mock))
          .thenAnswer((_) async => MockAuthUserModel.mock);
      // Act
      final result = await authRepository
          .signInWithEmailAndPassword(MockLoginRequestModel.mock);
      // Assert
      expect(
          result, const Right<Failure, AuthUserModel>(MockAuthUserModel.mock));
    });

    test('''Should Return Failure if call to auth services is fail''', () async {
      // Arrange
      when(() => authServices
              .loginWithEmailAndPassword(MockLoginRequestModel.mock))
          .thenThrow(Exception());
      // Act
      final result = await authRepository
          .signInWithEmailAndPassword(MockLoginRequestModel.mock);
      // Assert
      expect(result, isA<Left<Failure, AuthUserModel>>());
    });
  });
}
