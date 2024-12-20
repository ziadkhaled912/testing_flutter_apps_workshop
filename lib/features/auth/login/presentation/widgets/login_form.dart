import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_flutter_apps_workshop/core/utils/validators.dart';
import 'package:testing_flutter_apps_workshop/features/auth/login/presentation/cubit/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          BlocBuilder<LoginCubit, LoginState>(
            buildWhen: (previous, current) => previous.email != current.email,
            builder: (context, state) {
              return TextFormField(
                key: const Key('emailField'),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                onChanged: (value) {
                  context.read<LoginCubit>().emailChanged(value);
                },
                validator: (value) {
                  if (state.email == null || state.email!.isValidEmail()) {
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
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              );
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<LoginCubit, LoginState>(
            buildWhen: (previous, current) => previous.isLoading != current.isLoading,
            builder: (context, state) {
              if (state.isLoading) {
                return const CircularProgressIndicator.adaptive(
                  key: Key('loginLoading'),
                );
              }
              return ElevatedButton(
                key: const Key('loginButton'),
                onPressed: () {
                  context.read<LoginCubit>().signIn();
                },
                child: const Text('Login'),
              );
            },
          ),
        ],
      ),
    );
  }
}
