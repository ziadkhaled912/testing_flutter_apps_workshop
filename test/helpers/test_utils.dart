import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

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
