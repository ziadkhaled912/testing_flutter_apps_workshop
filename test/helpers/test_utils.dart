import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:testing_flutter_apps_workshop/di/injection_container.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/repository/auth_repository.dart';
import 'package:testing_flutter_apps_workshop/features/auth/login/presentation/cubit/login_cubit.dart';

import '../mocks/data/auth/repository/mock_auth_repository.dart';

final authRepository = MockAuthRepository();

Widget makeTestableWidget({
  required Widget child,
  List<BlocProvider>? blocProvider,
}) =>
    blocProvider == null
        ? child
        : MultiBlocProvider(
            providers: blocProvider,
            child: child,
          );

Future<void> pumpMaterialWidget(
  WidgetTester tester,
  Widget widget, {
  bool pumpAndSettle = true,
  List<GoRoute> routes = const [],
  List<BlocProvider>? blocProviders,
}) async {
  final builderWidget = Material(
    child: Builder(
      builder: (ctx) {
        return widget;
      },
    ),
  );

  await tester.pumpWidget(
    blocProviders != null
        ? MultiBlocProvider(
            providers: blocProviders,
            child: MaterialApp(
              home: builderWidget,
            ),
          )
        : MaterialApp(
            home: builderWidget,
          ),
  );

  if (pumpAndSettle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump();
  }
}

Future<void> initSignedOutUser() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureTestDependencies();
  locator
    ..unregister<AuthRepository>()
    ..registerLazySingleton<AuthRepository>(() => authRepository)
    ..unregister<LoginCubit>()
    ..registerFactory<LoginCubit>(() => LoginCubit(authRepository));
    await Future.delayed(const Duration(milliseconds: 300));
}

Future<void> configureTestDependencies() async {
  await locator.reset();
  configureDependencies();
}
