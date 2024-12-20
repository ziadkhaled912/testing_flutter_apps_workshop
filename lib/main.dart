import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:testing_flutter_apps_workshop/core/presentation/app.dart';
import 'package:testing_flutter_apps_workshop/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init dependency
  configureDependencies();

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      runApp(const App());
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
