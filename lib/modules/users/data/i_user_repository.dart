import 'package:onde_gastei_api/entities/category.dart';
import 'package:onde_gastei_api/entities/user.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_categories_by_percentage_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expense_by_period_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expenses_by_categories_view_model.dart';

abstract class IUserRepository {
  Future<int> createUser(String name, String email, String password);

  Future<User> login(String email, String password);

  Future<User> findById(int id);

  Future<void> updateUserNameById(int userId, String name);

  Future<List<Category>> findCategoriesByUserId(int userId);

  Future<List<UserExpenseByPeriodViewModel>> findExpenseByPeriod(
    int userId,
    DateTime initialDate,
    DateTime finalDate,
  );

  Future<List<UserExpensesByCategoriesViewModel>> findTotalExpensesByCategories(
    int userId,
    DateTime initialDate,
    DateTime finalDate,
  );

  Future<List<UserCategoriesByPercentageViewModel>> findPercentageByCategories(
    int userId,
    DateTime initialDate,
    DateTime finalDate,
  );

  Future<List<UserExpenseByPeriodViewModel>> findExpensesByCategories(
    int userId,
    int categoryId,
    DateTime initialDate,
    DateTime finalDate,
  );

  Future<void> confirmLogin(int userId, String refreshToken);

  Future<void> updateRefreshToken(int userId, String refreshToken);
}
