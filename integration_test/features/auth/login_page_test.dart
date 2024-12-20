import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testing_flutter_apps_workshop/core/presentation/app.dart';
import 'package:testing_flutter_apps_workshop/di/injection_container.dart';
import 'package:testing_flutter_apps_workshop/features/home/presentation/pages/home_page.dart';

import '../../../test/helpers/test_utils.dart';
import '../../../test/mocks/data/auth/models/mock_auth_user_model.dart';
import '../../../test/mocks/data/auth/models/mock_login_request_model.dart';

void main() {
  final loginPage = makeTestableWidget(
    child: const App(),
  );

  setUpAll(() {
    registerFallbackValue(MockLoginRequestModel.mock);
  });

  group('Login Page form validation test', () {
    setUpAll(() async {
      await initSignedOutUser();
    });

    tearDownAll(() async {
      await locator.reset();
    });

    testWidgets('''
      Giver User is on the login page
      When User enters invalid email
      Then User should see email validation error message
    ''', (tester) async {
      /// Arrange
      await tester.pumpWidget(loginPage);
      await tester.pumpAndSettle();

      /// Act
      await tester.enterText(
          find.byKey(const Key('emailField')), 'invalidEmail');
      await tester.pumpAndSettle();

      /// Assert
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('''
      Giver User is on the login page
      When User enters invalid password
      Then User should see password validation error message
    ''', (tester) async {
      /// Arrange
      await tester.pumpWidget(loginPage);
      await tester.pumpAndSettle();

      /// Act
      await tester.enterText(find.byKey(const Key('passwordField')), '123');
      await tester.pumpAndSettle();

      /// Assert
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('''
      Giver User is on the login page
      When User enters valid email and password
      Then Login button should be enabled
    ''', (tester) async {
      /// Arrange
      await tester.pumpWidget(loginPage);
      await tester.pumpAndSettle();

      /// Act
      await enterValidForm(tester);

      /// Assert
      assertValidForm(tester);
    });
  });

  group('LoginAction Test', () {
    setUpAll(() async {
      await initSignedOutUser();
    });

    tearDownAll(() async {
      await locator.reset();
    });

    // testWidgets('''
    //   Given user is not logged in
    //   When user enters valid email and valid password
    //   Then press login button User should see loading progress''',
    //     (tester) async {
    //   /// Arrange
    //   await tester.pumpWidget(loginPage);
    //   await tester.pumpAndSettle();
    //   await enterValidForm(tester);
    //   when(() => authRepository.signInWithEmailAndPassword(any())).thenAnswer(
    //     (_) => Future.delayed(const Duration(milliseconds: 500)).then(
    //       (_) => const Right(MockAuthUserModel.mock),
    //     ),
    //   );
    //   /// Act
    //   await pressLogin(tester);

    //   /// Assert
    //   await assertLoading(tester);
    // });

    testWidgets('''
      Given user is not logged in
      When user enters valid email and valid password
      Then press login button and repository returns success
      Then should navigate to HomeBasePage''', (tester) async {
      /// Arrange
      await tester.pumpWidget(loginPage);
      await tester.pumpAndSettle();
      await enterValidForm(tester);
      when(() => authRepository.signInWithEmailAndPassword(any())).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 500)).then(
          (_) => const Right(MockAuthUserModel.mock),
        ),
      );

      /// Act
      await pressLogin(tester);

      /// Assert
      await assertLoading(tester);
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}

void assertValidForm(WidgetTester tester) {
  expect(find.text('Please Enter Valid Email'), findsNothing);
  expect(find.text('Please Enter Your Password'), findsNothing);
  final loginButton =
      tester.widget<ElevatedButton>(find.byKey(const Key('loginButton')));
  expect(loginButton.onPressed, isNotNull);
}

Future<void> enterValidForm(WidgetTester tester) async {
  await tester.enterText(
      find.byKey(const Key('emailField')), MockLoginRequestModel.email);
  await tester.enterText(
      find.byKey(const Key('passwordField')), MockLoginRequestModel.password);
  await tester.pumpAndSettle();
}

Future<void> pressLogin(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('loginButton')));
  final loginButton = find.byKey(const Key('loginButton'));
  await tester.tap(loginButton);
  // await tester.pumpAndSettle();
}

Future<void> assertLoading(WidgetTester tester) async {
  await tester.pump(Duration.zero);
  expect(find.byKey(const Key('loginLoading')), findsOneWidget);
  await tester.pump(const Duration(milliseconds: 500));
  expect(find.byKey(const Key('loginLoading')), findsNothing);
  await tester.pumpAndSettle();
}
