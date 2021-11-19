// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../logs/i_log.dart' as _i8;
import '../../modules/categories/controllers/category_controller.dart' as _i22;
import '../../modules/categories/data/category_repository.dart' as _i19;
import '../../modules/categories/data/i_category_repository.dart' as _i18;
import '../../modules/categories/services/category_service.dart' as _i21;
import '../../modules/categories/services/i_category_service.dart' as _i20;
import '../../modules/expenses/controllers/expenses_controller.dart' as _i17;
import '../../modules/expenses/data/expense_repository.dart' as _i7;
import '../../modules/expenses/data/i_expense_repository.dart' as _i6;
import '../../modules/expenses/services/expense_services.dart' as _i10;
import '../../modules/expenses/services/i_expense_services.dart' as _i9;
import '../../modules/users/controllers/auth_controller.dart' as _i16;
import '../../modules/users/controllers/user_controller.dart' as _i15;
import '../../modules/users/data/i_user_repository.dart' as _i11;
import '../../modules/users/data/user_repository.dart' as _i12;
import '../../modules/users/services/i_user_service.dart' as _i13;
import '../../modules/users/services/user_service.dart' as _i14;
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
  gh.lazySingleton<_i6.IExpenseRepository>(() => _i7.ExpenseRepository(
      connection: get<_i3.IDatabaseConnection>(), log: get<_i8.ILog>()));
  gh.lazySingleton<_i9.IExpenseServices>(
      () => _i10.ExpenseServices(repository: get<_i6.IExpenseRepository>()));
  gh.lazySingleton<_i11.IUserRepository>(() => _i12.UserRepository(
      connection: get<_i3.IDatabaseConnection>(), log: get<_i8.ILog>()));
  gh.lazySingleton<_i13.IUserService>(() => _i14.UserService(
      repository: get<_i11.IUserRepository>(), log: get<_i8.ILog>()));
  gh.factory<_i15.UserController>(() => _i15.UserController(
      service: get<_i13.IUserService>(), log: get<_i8.ILog>()));
  gh.factory<_i16.AuthController>(() => _i16.AuthController(
      service: get<_i13.IUserService>(), log: get<_i8.ILog>()));
  gh.factory<_i17.ExpensesController>(() => _i17.ExpensesController(
      service: get<_i9.IExpenseServices>(), log: get<_i8.ILog>()));
  gh.lazySingleton<_i18.ICategoryRepository>(() => _i19.CategoryRepository(
      connection: get<_i3.IDatabaseConnection>(), log: get<_i8.ILog>()));
  gh.lazySingleton<_i20.ICategoryService>(() => _i21.CategoryService(
      repository: get<_i18.ICategoryRepository>(), log: get<_i8.ILog>()));
  gh.factory<_i22.CategoryController>(() => _i22.CategoryController(
      service: get<_i20.ICategoryService>(), log: get<_i8.ILog>()));
  return get;
}
