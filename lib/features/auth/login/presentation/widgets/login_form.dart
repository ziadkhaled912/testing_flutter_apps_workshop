import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:testing_flutter_apps_workshop/core/data/failures/auth_failure.dart';
import 'package:testing_flutter_apps_workshop/core/presentation/widgets/app_snackbar.dart';
import 'package:testing_flutter_apps_workshop/core/utils/context_utils.dart';
import 'package:testing_flutter_apps_workshop/core/utils/validators.dart';
import 'package:testing_flutter_apps_workshop/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:testing_flutter_apps_workshop/features/home/presentation/pages/home_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) =>
              previous.user != current.user && current.user != null,
          listener: (context, state) {
            context
              ..showSnackBar(
                message: 'Login Success',
                state: SnackBarStates.success,
              )
              ..go(HomePage.id);
          },
        ),
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure && current.failure != null,
          listener: (context, state) {
            if (state.failure is AuthFailure) {
              final failure = state.failure! as AuthFailure;
              if (failure.type == AuthFailureType.userNotFound) {
                context.showSnackBar(
                  message: 'Invalid Email or Password',
                  state: SnackBarStates.error,
                );
                return;
              }
              context.showSnackBar(
                message: failure.errorMessage ?? 'Unknown Error',
                state: SnackBarStates.error,
              );
              return;
            }
            context.showSnackBar(
              message: 'Unknown Error',
              state: SnackBarStates.error,
            );
          },
        ),
      ],
      child: Form(
        child: Column(
          children: [
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (previous, current) => previous.email != current.email,
              builder: (context, state) {
                return TextFormField(
                  key: const Key('emailField'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                  onChanged: (value) {
                    context.read<LoginCubit>().emailChanged(value);
                  },
                  validator: (value) {
                    if (state.email == null || !state.email!.isValidEmail()) {
                      return 'Email is required';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (previous, current) =>
                  previous.password != current.password ||
                  previous.isObscure != current.isObscure,
              builder: (context, state) {
                return TextFormField(
                  key: const Key('passwordField'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    suffix: IconButton(
                      key: const Key('toggleObscureButton'),
                      icon: Icon(state.isObscure
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        context.read<LoginCubit>().onObscureChanged();
                      },
                    ),
                  ),
                  onChanged: (value) {
                    context.read<LoginCubit>().passwordChanged(value);
                  },
                  obscureText: state.isObscure,
                  validator: (value) {
                    if (value == null || !value.isValidPassword()) {
                      return 'Password is required';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (previous, current) =>
                  previous.isLoading != current.isLoading 
                  || previous.isFormValid != current.isFormValid,
              builder: (context, state) {
                if (state.isLoading) {
                  return const CircularProgressIndicator(
                    key: Key('loginLoading'),
                  );
                }
                return ElevatedButton(
                  key: const Key('loginButton'),
                  onPressed: !state.isFormValid
                      ? null
                      : () {
                          context.read<LoginCubit>().signIn();
                        },
                  child: const Text('Login'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
