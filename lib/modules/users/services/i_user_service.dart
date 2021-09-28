import 'package:onde_gastei_api/entities/category.dart';
import 'package:onde_gastei_api/entities/user.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_login_input_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_save_input_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_update_name_input_model.dart';

abstract class IUserService {
  Future<int> createUser(UserSaveInputModel userSaveInputModel);

  Future<User> login(UserLoginInputModel userLoginInputModel);

  Future<User> findById(int id);

  Future<void> updateUserNameById(
      int userId, UserUpdateNameInputModel userUpdateNameInputModel);

  Future<List<Category>> findCategoriesByUserId(int userId);
}
