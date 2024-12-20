// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../features/auth/core/data/repository/auth_repository.dart' as _i842;
import '../features/auth/core/data/services/auth_services.dart' as _i16;
import '../features/auth/login/presentation/cubit/login_cubit.dart' as _i596;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i16.AuthServices>(() => _i16.AuthServicesImpl());
    gh.lazySingleton<_i842.AuthRepository>(
        () => _i842.AuthRepositoryImpl(gh<_i16.AuthServices>()));
    gh.factory<_i596.LoginCubit>(
        () => _i596.LoginCubit(gh<_i842.AuthRepository>()));
    return this;
  }
}
