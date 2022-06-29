import 'package:injectable/injectable.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:onde_gastei_api/entities/category.dart';
import 'package:onde_gastei_api/entities/user.dart';
import 'package:onde_gastei_api/exceptions/service_exception.dart';
import 'package:onde_gastei_api/helpers/jwt_helper.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/users/data/i_user_repository.dart';
import 'package:onde_gastei_api/modules/users/services/i_user_service.dart';
import 'package:onde_gastei_api/modules/users/view_model/refresh_token_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_categories_by_percentage_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expense_by_period_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expenses_by_categories_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_login_input_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_save_input_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_update_name_input_model.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  UserService({required this.repository, required this.log});

  final IUserRepository repository;
  final ILog log;

  @override
  Future<int> createUser(UserSaveInputModel userSaveInputModel) =>
      repository.createUser(
        userSaveInputModel.name,
        userSaveInputModel.firebaseUserId,
      );

  @override
  Future<User> login(UserLoginInputModel userLoginInputModel) =>
      repository.login(userLoginInputModel.email, userLoginInputModel.password);

  @override
  Future<User> findById(int id) => repository.findById(id);

  @override
  Future<void> updateUserNameById(
    int userId,
    UserUpdateNameInputModel userUpdateNameInputModel,
  ) =>
      repository.updateUserNameById(userId, userUpdateNameInputModel.name);

  @override
  Future<List<Category>> findCategoriesByUserId(int userId) =>
      repository.findCategoriesByUserId(userId);

  @override
  Future<List<UserExpenseByPeriodViewModel>> findExpenseByPeriod(
    int userId,
    DateTime initialDate,
    DateTime finalDate,
  ) =>
      repository.findExpenseByPeriod(userId, initialDate, finalDate);

  @override
  Future<List<UserExpensesByCategoriesViewModel>> findTotalExpensesByCategories(
    int userId,
    DateTime initialDate,
    DateTime finalDate,
  ) =>
      repository.findTotalExpensesByCategories(userId, initialDate, finalDate);

  @override
  Future<List<UserCategoriesByPercentageViewModel>> findPercentageByCategories(
    int userId,
    DateTime initialDate,
    DateTime finalDate,
  ) =>
      repository.findPercentageByCategories(userId, initialDate, finalDate);

  @override
  Future<List<UserExpenseByPeriodViewModel>> findExpensesByCategories(
    int userId,
    int categoryId,
    DateTime initialDate,
    DateTime finalDate,
  ) =>
      repository.findExpensesByCategories(
        userId,
        categoryId,
        initialDate,
        finalDate,
      );

  @override
  Future<String> confirmLogin(int userId, String accessToken) async {
    final refreshToken = JwtHelper.refreshToken(accessToken);
    await repository.confirmLogin(userId, refreshToken);
    return refreshToken;
  }

  @override
  Future<RefreshTokenViewModel> refreshToken(
    int userId,
    String accessToken,
    String refreshToken,
  ) async {
    _validateRefreshToken(accessToken, refreshToken);
    final newAccessToken = JwtHelper.generateJwt(userId);
    final newRefreshToken =
        JwtHelper.refreshToken(newAccessToken.replaceAll('Bearer ', ''));
    await repository.updateRefreshToken(userId, newRefreshToken);
    return RefreshTokenViewModel(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );
  }

  void _validateRefreshToken(String accessToken, String refreshToken) {
    try {
      final validateRefreshToken = refreshToken.split(' ');

      if (validateRefreshToken.length != 2 ||
          validateRefreshToken.first != 'Bearer') {
        throw const ServiceException('Refresh Token invalido');
      }

      JwtHelper.getClaims(validateRefreshToken.last)
          .validate(issuer: accessToken);
    } on ServiceException {
      rethrow;
    } on JwtException catch (e, s) {
      log.error('Refresh token invalido', e, s);
      throw const ServiceException('Erro ao validar refresh token');
    } on Exception {
      throw const ServiceException('Erro ao validar refresh token');
    }
  }
}
