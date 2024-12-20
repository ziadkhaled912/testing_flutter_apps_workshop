import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/requests/login_request_model.dart';

class MockLoginRequestModel {
  static const String email = 'email@gmail.com';
  static const String password = 'password';

  static const mock = LoginRequestModel(
    email: email,
    password: password,
  );
}