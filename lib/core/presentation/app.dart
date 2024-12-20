import 'package:flutter/material.dart';
import 'package:testing_flutter_apps_workshop/core/presentation/router/app_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _router = AppRouter.router();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Testing Flutter Apps Workshop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff00945D)),
        useMaterial3: true,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
