import 'package:integration_test/integration_test.dart';
import 'features/auth/login_page_test.dart' as login_page_test;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  login_page_test.main();
}