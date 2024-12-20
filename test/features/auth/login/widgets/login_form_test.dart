
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testing_flutter_apps_workshop/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:testing_flutter_apps_workshop/features/auth/login/presentation/widgets/login_form.dart';

import '../../../../helpers/test_utils.dart';
import '../../../../mocks/data/auth/cubits/mock_login_cubit.dart';

void main() {
  late final MockLoginCubit loginCubit;

  Widget loginForm() => makeTestableWidget(
        blocProvider: [
          BlocProvider<LoginCubit>.value(
            value: loginCubit,
          ),
        ],
        child: BlocProvider<LoginCubit>(
          create: (context) => loginCubit,
          child: const LoginForm(),
        ),
      );

  setUp(() {
    loginCubit = MockLoginCubit();
    when(() => loginCubit.state).thenReturn(const LoginState());
  });

  testWidgets('should render login form with email and password field',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await pumpMaterialWidget(tester, loginForm());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    expect(find.byKey(const Key('loginButton')), findsOneWidget);
    expect(find.byKey(const Key('toggleObscureButton')), findsOneWidget);
  });
}
