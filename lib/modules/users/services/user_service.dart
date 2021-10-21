import 'package:injectable/injectable.dart';
import 'package:onde_gastei_api/entities/category.dart';
import 'package:onde_gastei_api/entities/user.dart';
import 'package:onde_gastei_api/modules/users/data/i_user_repository.dart';
import 'package:onde_gastei_api/modules/users/services/i_user_service.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_categories_by_percentage_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expense_by_period_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expenses_by_categories_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_login_input_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_save_input_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_update_name_input_model.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  UserService({required this.repository});

  final IUserRepository repository;

  @override
  Future<int> createUser(UserSaveInputModel userSaveInputModel) =>
      repository.createUser(userSaveInputModel.name, userSaveInputModel.email,
          userSaveInputModel.password);

  @override
  Future<User> login(UserLoginInputModel userLoginInputModel) =>
      repository.login(userLoginInputModel.email, userLoginInputModel.password);

  @override
  Future<User> findById(int id) => repository.findById(id);

  @override
  Future<void> updateUserNameById(
          int userId, UserUpdateNameInputModel userUpdateNameInputModel) =>
      repository.updateUserNameById(userId, userUpdateNameInputModel.name);

  @override
  Future<List<Category>> findCategoriesByUserId(int userId) =>
      repository.findCategoriesByUserId(userId);

  @override
  Future<List<UserExpenseByPeriodViewModel>> findExpenseByPeriod(
          int userId, DateTime initialDate, DateTime finalDate) =>
      repository.findExpenseByPeriod(userId, initialDate, finalDate);

  @override
  Future<List<UserExpensesByCategoriesViewModel>> findTotalExpensesByCategories(
          int userId, DateTime initialDate, DateTime finalDate) =>
      repository.findTotalExpensesByCategories(userId, initialDate, finalDate);

  @override
  Future<List<UserCategoriesByPercentageViewModel>> findPercentageByCategories(
          int userId, DateTime initialDate, DateTime finalDate) =>
      repository.findPercentageByCategories(userId, initialDate, finalDate);

  @override
  Future<List<UserExpenseByPeriodViewModel>> findExpensesByCategories(
          int userId,
          int categoryId,
          DateTime initialDate,
          DateTime finalDate) =>
      repository.findExpensesByCategories(
          userId, categoryId, initialDate, finalDate);
}
