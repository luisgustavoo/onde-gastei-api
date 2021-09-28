// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../logs/i_log.dart' as _i8;
import '../../modules/categories/controllers/category_controller.dart' as _i17;
import '../../modules/categories/data/category_repository.dart' as _i14;
import '../../modules/categories/data/i_category_repository.dart' as _i13;
import '../../modules/categories/services/category_service.dart' as _i16;
import '../../modules/categories/services/i_category_service.dart' as _i15;
import '../../modules/users/controllers/auth_controller.dart' as _i12;
import '../../modules/users/controllers/user_controller.dart' as _i11;
import '../../modules/users/data/i_user_repository.dart' as _i6;
import '../../modules/users/data/user_repository.dart' as _i7;
import '../../modules/users/services/i_user_service.dart' as _i9;
import '../../modules/users/services/user_service.dart' as _i10;
import '../database/database_connection.dart' as _i4;
import '../database/i_database_connection.dart' as _i3;
import 'database_connection_configuration.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.IDatabaseConnection>(
      () => _i4.DatabaseConnection(get<_i5.DatabaseConnectionConfiguration>()));
  gh.lazySingleton<_i6.IUserRepository>(() => _i7.UserRepository(
      connection: get<_i3.IDatabaseConnection>(), log: get<_i8.ILog>()));
  gh.lazySingleton<_i9.IUserService>(
      () => _i10.UserService(repository: get<_i6.IUserRepository>()));
  gh.factory<_i11.UserController>(() => _i11.UserController(
      service: get<_i9.IUserService>(), log: get<_i8.ILog>()));
  gh.factory<_i12.AuthController>(() => _i12.AuthController(
      service: get<_i9.IUserService>(), log: get<_i8.ILog>()));
  gh.lazySingleton<_i13.ICategoryRepository>(() => _i14.CategoryRepository(
      connection: get<_i3.IDatabaseConnection>(), log: get<_i8.ILog>()));
  gh.lazySingleton<_i15.ICategoryService>(() => _i16.CategoryService(
      repository: get<_i13.ICategoryRepository>(), log: get<_i8.ILog>()));
  gh.factory<_i17.CategoryController>(() => _i17.CategoryController(
      service: get<_i15.ICategoryService>(), log: get<_i8.ILog>()));
  return get;
}
