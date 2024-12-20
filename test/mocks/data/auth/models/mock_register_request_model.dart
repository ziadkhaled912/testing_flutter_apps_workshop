import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/requests/register_request_model.dart';

class MockRegisterRequestModel {
  static const String email = "email@gmail.com";
  static const String password = "password";
  static const String name = "name";

  static const mock = RegisterRequestModel(
    email: email,
    password: password,
    name: name,
  );
}
