import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testing_flutter_apps_workshop/features/auth/login/presentation/cubit/login_cubit.dart';

import '../../../../mocks/data/auth/models/mock_auth_user_model.dart';
import '../../../../mocks/data/auth/models/mock_login_request_model.dart';
import '../../../../mocks/data/auth/repository/mock_auth_repository.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginCubit loginCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginCubit = LoginCubit(mockAuthRepository);
  });

  test(
    'initial state loading state should be false, user and failure should be null',
    () {
      expect(loginCubit.state.isLoading, false);
      expect(loginCubit.state.user, null);
      expect(loginCubit.state.failure, null);
    },
  );

  group("login Tests", () {
    blocTest(
      'should emit state with email when emailChanged called',
      build: () => loginCubit,
      act: (bloc) => bloc.emailChanged(MockLoginRequestModel.email),
      expect: () => [
        const LoginState(email: MockLoginRequestModel.email),
      ],
    );

    blocTest(
      'should emit state with password when passwordChanged called',
      build: () => loginCubit,
      act: (bloc) => bloc.passwordChanged(MockLoginRequestModel.password),
      expect: () => [
        const LoginState(password: MockLoginRequestModel.password),
      ],
    );

    blocTest(
      'should emit state with isObscure when onObscureChanged called',
      build: () => loginCubit,
      act: (bloc) => bloc.onObscureChanged(),
      expect: () => [
        const LoginState(isObscure: false),
      ],
    );

    blocTest(
      '''
      should emit isFormValid with true when entering valid email and password
      ''',
      build: () => loginCubit,
      seed: () => const LoginState(
        email: MockLoginRequestModel.email,
        password: MockLoginRequestModel.password,
      ),
      verify: (bloc) {
        expect(bloc.state.isFormValid, true);
      },
    );

    blocTest(
      '''
      should emit isFormValid with false when entering invalid email and password
      ''',
      build: () => loginCubit,
      seed: () => const LoginState(
        email: 'invalid email',
        password: 'invalid password',
      ),
      verify: (bloc) {
        expect(bloc.state.isFormValid, false);
      },
    );

    blocTest(
      '''
      when signIn is called with valid email and password, 
      then the state should be in loading state and success state
      ''',
      build: () => loginCubit,
      setUp: () {
        when(() => mockAuthRepository
                .signInWithEmailAndPassword(MockLoginRequestModel.mock))
            .thenAnswer((_) async => const Right(MockAuthUserModel.mock));
      },
      seed: () => const LoginState(
        email: MockLoginRequestModel.email,
        password: MockLoginRequestModel.password,
      ),
      act: (bloc) => bloc.signIn(),
      expect: () => [
        const LoginState(
          email: MockLoginRequestModel.email,
          password: MockLoginRequestModel.password,
          isLoading: true,
        ),
        const LoginState(
          email: MockLoginRequestModel.email,
          password: MockLoginRequestModel.password,
          isLoading: false,
          user: MockAuthUserModel.mock,
        ),
      ],
    );
  });
}
