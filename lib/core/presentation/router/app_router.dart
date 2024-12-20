import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testing_flutter_apps_workshop/features/auth/login/presentation/pages/login_page.dart';

class AppRouter {
  static GoRouter router() => GoRouter(
        errorBuilder: (context, state) {
          return const Center(
            child: Text('Error 404'),
          );
        },
        initialLocation: LoginPage.id,
        routes: [
          GoRoute(
            path: LoginPage.id,
            builder: (context, state) => const LoginPage(),
          ),
        ],
      );
}
