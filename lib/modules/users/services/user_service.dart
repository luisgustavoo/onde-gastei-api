import 'package:injectable/injectable.dart';
import 'package:onde_gastei_api/entities/user.dart';
import 'package:onde_gastei_api/modules/users/data/i_user_repository.dart';
import 'package:onde_gastei_api/modules/users/services/i_user_service.dart';
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
}
