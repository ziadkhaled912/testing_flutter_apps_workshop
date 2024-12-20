import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/response/auth_user_model.dart';

class MockAuthUserModel {
  static const String email = "email@gmail.com";
  static const String password = "password";
  static const String id = "id";
  static const String name = "name";
  static const String photoUrl = "photoUrl";

  static const mock = AuthUserModel(
    id: id,
    email: email,
    name: name,
    photoUrl: photoUrl,
  );
}
