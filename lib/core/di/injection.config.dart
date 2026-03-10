// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:to_do_list/core/di/external_module.dart' as _i27;
import 'package:to_do_list/data/auth/repositories/auth_repository_impl.dart'
    as _i489;
import 'package:to_do_list/data/tasks/data_sources/task_remote_data_source.dart'
    as _i678;
import 'package:to_do_list/data/tasks/repositories/task_repository_impl.dart'
    as _i285;
import 'package:to_do_list/domain/auth/repositories/auth_repository.dart'
    as _i602;
import 'package:to_do_list/domain/auth/usecases/auth_usecases.dart' as _i446;
import 'package:to_do_list/domain/tasks/repositories/task_repository.dart'
    as _i351;
import 'package:to_do_list/domain/tasks/usecases/task_usecases.dart' as _i952;
import 'package:to_do_list/presentation/auth/bloc/auth_bloc.dart' as _i1025;
import 'package:to_do_list/presentation/tasks/bloc/task_bloc.dart' as _i559;

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
    final externalModule = _$ExternalModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => externalModule.firebaseAuth);
    gh.lazySingleton<_i519.Client>(() => externalModule.httpClient);
    gh.lazySingleton<_i678.TaskRemoteDataSource>(
        () => _i678.FirebaseTaskDataSource(gh<_i519.Client>()));
    gh.lazySingleton<_i351.TaskRepository>(
        () => _i285.TaskRepositoryImpl(gh<_i678.TaskRemoteDataSource>()));
    gh.lazySingleton<_i602.AuthRepository>(
        () => _i489.AuthRepositoryImpl(gh<_i59.FirebaseAuth>()));
    gh.lazySingleton<_i446.GetAuthStatus>(
        () => _i446.GetAuthStatus(gh<_i602.AuthRepository>()));
    gh.lazySingleton<_i446.LogIn>(
        () => _i446.LogIn(gh<_i602.AuthRepository>()));
    gh.lazySingleton<_i446.SignUp>(
        () => _i446.SignUp(gh<_i602.AuthRepository>()));
    gh.lazySingleton<_i446.LogOut>(
        () => _i446.LogOut(gh<_i602.AuthRepository>()));
    gh.lazySingleton<_i446.GetToken>(
        () => _i446.GetToken(gh<_i602.AuthRepository>()));
    gh.lazySingleton<_i952.GetTasks>(
        () => _i952.GetTasks(gh<_i351.TaskRepository>()));
    gh.lazySingleton<_i952.AddTask>(
        () => _i952.AddTask(gh<_i351.TaskRepository>()));
    gh.lazySingleton<_i952.UpdateTask>(
        () => _i952.UpdateTask(gh<_i351.TaskRepository>()));
    gh.lazySingleton<_i952.DeleteTask>(
        () => _i952.DeleteTask(gh<_i351.TaskRepository>()));
    gh.factory<_i559.TaskBloc>(() => _i559.TaskBloc(
          gh<_i952.GetTasks>(),
          gh<_i952.AddTask>(),
          gh<_i952.UpdateTask>(),
          gh<_i952.DeleteTask>(),
          gh<_i446.GetToken>(),
        ));
    gh.factory<_i1025.AuthBloc>(() => _i1025.AuthBloc(
          gh<_i446.GetAuthStatus>(),
          gh<_i446.LogOut>(),
        ));
    return this;
  }
}

class _$ExternalModule extends _i27.ExternalModule {}
