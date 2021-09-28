import 'package:get_it/get_it.dart';
import 'package:onde_gastei_api/application/router/i_router.dart';
import 'package:onde_gastei_api/modules/users/controllers/auth_controller.dart';
import 'package:onde_gastei_api/modules/users/controllers/user_controller.dart';
import 'package:shelf_router/shelf_router.dart';

class UserRouter implements IRouter {
  @override
  void configure(Router router) {
    final authController = GetIt.I.get<AuthController>();
    final userController = GetIt.I.get<UserController>();
    router
      ..mount('/auth/', authController.router)
      ..mount('/users/', userController.router);
  }
}
