import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUserModel extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;

  const AuthUserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.photoUrl,
  });

  factory AuthUserModel.fromFirebaseUser(User firebaseUser) {
    return AuthUserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  @override
  List<Object?> get props => [id, email, name, photoUrl];
}
