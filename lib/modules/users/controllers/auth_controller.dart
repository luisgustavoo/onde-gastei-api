import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:onde_gastei_api/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_api/helpers/jwt_helper.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/users/services/i_user_service.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_login_input_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_save_input_model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

@Injectable()
class AuthController {
  AuthController({required this.service, required this.log});

  final IUserService service;
  final ILog log;

  @Route.post('/register')
  Future<Response> createUser(Request request) async {
    try {
      final dataRequest =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final userInputModel = UserSaveInputModel(
          name: dataRequest['name'].toString(),
          email: dataRequest['email'].toString(),
          password: dataRequest['password'].toString());
      await service.createUser(userInputModel);
      return Response.ok(
          jsonEncode({'message': 'Cadastro realizado com sucesso!'}));
    } on UserExistsException {
      return Response(400,
          body: jsonEncode({'message': 'Usuário já cadasatrado'}));
    } on Exception catch (e) {
      log.error('Erro ao cadastrar usuário', e);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao cadastrar usuário'}));
    }
  }

  @Route.post('/')
  Future<Response> login(Request request) async {
    try {
      final dataRequest =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final userLoginInputModel = UserLoginInputModel(
          email: dataRequest['email'].toString(),
          password: dataRequest['password'].toString());

      final user = await service.login(userLoginInputModel);

      return Response.ok(
          jsonEncode({'access_token': JwtHelper.generateJwt(user.id)}));
    } on Exception catch (e, s) {
      log.error('Erro ao fazer login', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao realizar login'}));
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
