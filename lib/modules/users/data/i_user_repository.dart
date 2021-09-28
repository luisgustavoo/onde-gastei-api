import 'package:onde_gastei_api/entities/category.dart';
import 'package:onde_gastei_api/entities/user.dart';

abstract class IUserRepository {
  Future<int> createUser(String name, String email, String password);

  Future<User> login(String email, String password);

  Future<User> findById(int id);

  Future<void> updateUserNameById(int userId, String name);

  Future<List<Category>> findCategoriesByUserId(int userId);
}
