import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:testing_flutter_apps_workshop/core/data/failures/failure.dart';
import 'package:testing_flutter_apps_workshop/core/data/nullable.dart';
import 'package:testing_flutter_apps_workshop/core/utils/validators.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/requests/login_request_model.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/models/response/auth_user_model.dart';
import 'package:testing_flutter_apps_workshop/features/auth/core/data/repository/auth_repository.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginState());

  Future<void> signIn() async {
    if (!state.isFormValid) return;
    emit(state.copyWith(isLoading: true));
    final request = LoginRequestModel(
      email: state.email!,
      password: state.password!,
    );
    final result = await _authRepository.signInWithEmailAndPassword(request);
    result.fold(
      (failure) => emit(state.error(failure)),
      (user) => emit(state.success(user)),
    );
  }

  void emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  void onObscureChanged() {
    emit(state.copyWith(isObscure: !state.isObscure));
  }
}
