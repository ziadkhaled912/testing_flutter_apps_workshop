import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter router() => GoRouter(
        errorBuilder: (context, state) {
          return const Center(
            child: Text('Error 404'),
          );
        },
        routes: [
          // GoRoute(path: '/', pageBuilder: (context, state) => const SplashPage()),
        ],
      );
}
