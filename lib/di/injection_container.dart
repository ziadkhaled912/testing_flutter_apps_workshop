import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:testing_flutter_apps_workshop/di/injection_container.config.dart';

final locator = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
  // preferRelativeImports: false
)
void configureDependencies({String? environment}) => locator.init(
  environment: environment,
);
