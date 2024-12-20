import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testing_flutter_apps_workshop/core/data/exceptions/auth_exception.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/response/auth_user_model.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/services/auth_services.dart';

import '../../../../../mocks/data/auth/models/mock_auth_user_model.dart';
import '../../../../../mocks/data/auth/models/mock_login_request_model.dart';
import '../../../../../mocks/data/auth/models/mock_register_request_model.dart';
import '../../../faker.dart';

void main() {
  late AuthServices authServices;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthUserModel authUserModel;

  setUpAll(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    authServices = AuthServicesImpl(
      firebaseAuth: mockFirebaseAuth,
    );
    when(() => mockUser.uid).thenReturn(MockAuthUserModel.id);
    when(() => mockUser.email).thenReturn(MockAuthUserModel.email);
    when(() => mockUser.displayName).thenReturn(MockAuthUserModel.name);
    when(() => mockUser.photoURL).thenReturn(MockAuthUserModel.photoUrl);
    authUserModel = AuthUserModel.fromFirebaseUser(mockUser);
  });

  group('singInWithEmailAndPassword Tests', () {
    test('''Should Return (AuthUserModel) if call to firebase is success''',
        () async {
      // Arrange
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: MockAuthUserModel.email,
            password: MockAuthUserModel.password,
          )).thenAnswer((_) async => mockUserCredential);
      when(() => mockUserCredential.user).thenReturn(mockUser);
      // Act
      final result = await authServices
          .loginWithEmailAndPassword(MockLoginRequestModel.mock);
      // Assert
      expect(result, authUserModel);
    });

    test('''Should Throw (AuthException) if call to firebase is fail''',
        () async {
      // Arrange
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: MockAuthUserModel.email,
              password: MockAuthUserModel.password))
          .thenThrow(FirebaseAuthException(code: 'code'));
      // Act
      final call =
          authServices.loginWithEmailAndPassword(MockLoginRequestModel.mock);
      // Assert
      expect(() => call, throwsA(isA<AuthException>()));
    });
  });

  group(
    'signUpWithEmailAndPassword',
    () {
      test(
        'Should return AuthUserModel if call to firebase is success',
        () async {
          // Arrange
          when(
            () => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: MockRegisterRequestModel.email,
              password: MockRegisterRequestModel.password,
            ),
          ).thenAnswer((_) async => mockUserCredential);
          when(() => mockUserCredential.user).thenReturn(mockUser);
          when(() => mockUser.updateDisplayName(any()))
              .thenAnswer((_) async {});
          // Act
          final result = await authServices
              .signUpWithEmailAndPassword(MockRegisterRequestModel.mock);
          // Assert
          expect(result, authUserModel);
        },
      );

      test(
        'Should throw AuthException if call to firebase is fail',
        () async {
          // Arrange
          when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
                email: MockRegisterRequestModel.email,
                password: MockRegisterRequestModel.password,
              )).thenThrow(FirebaseAuthException(
            code: 'code',
          ));
          // Act
          final call = authServices
              .signUpWithEmailAndPassword(MockRegisterRequestModel.mock);
          // Assert
          expect(() => call, throwsA(isA<AuthException>()));
        },
      );
    },
  );
}
