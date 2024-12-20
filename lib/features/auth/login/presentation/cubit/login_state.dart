part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.failure,
    this.user,
    this.email,
    this.password,
    this.isLoading = false,
    this.isObscure = true,
  });

  final bool isLoading;
  final Failure? failure;
  final AuthUserModel? user;
  final String? email;
  final String? password;
  final bool isObscure;

  bool get isFormValid => ((email != null && email!.isValidEmail()) &&
      (password != null && password!.isValidPassword()));

  LoginState loading() => copyWith(
        isLoading: true,
        failure: Nullable(null),
        user: Nullable(null),
      );

  LoginState error(Failure failure) => copyWith(
        isLoading: false,
        failure: Nullable(failure),
      );

  LoginState success(AuthUserModel user) => copyWith(
        isLoading: false,
        user: Nullable(user),
      );

  LoginState copyWith({
    bool? isLoading,
    String? email,
    String? password,
    bool? isObscure,
    Nullable<Failure?>? failure,
    Nullable<AuthUserModel?>? user,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      password: password ?? this.password,
      isObscure: isObscure ?? this.isObscure,
      failure: failure == null ? this.failure : failure.value,
      user: user == null ? this.user : user.value,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        failure,
        user,
        email,
        password,
        isObscure,
      ];
}
