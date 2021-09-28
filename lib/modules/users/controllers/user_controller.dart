import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:onde_gastei_api/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/users/services/i_user_service.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_update_name_input_model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'user_controller.g.dart';

@Injectable()
class UserController {
  UserController({required this.service, required this.log});

  final IUserService service;
  final ILog log;

  @Route.get('/')
  Future<Response> findByToken(Request request) async {
    try {
      final userId = int.parse(request.headers['users'].toString());

      final user = await service.findById(userId);

      return Response.ok(jsonEncode(
          {'id_usuario': user.id, 'name': user.name, 'email': user.email}));
    } on UserNotFoundException {
      return Response(204);
    } on Exception catch (e, s) {
      log.error('Erro ao buscar usuario', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao buscar usuário'}));
    }
  }

  @Route.put('/<userId|[0-9]+>/update')
  Future<Response> updateUserNameById(Request request, String userId) async {
    try {
      final userId = int.parse(request.headers['users'].toString());
      final dataRequest =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final userUpdateNameInputModel =
          UserUpdateNameInputModel(name: dataRequest['name'].toString());

      await service.updateUserNameById(userId, userUpdateNameInputModel);

      return Response.ok(
          jsonEncode({'message': 'Nome do usuario atualizado com sucesso'}));
    } on Exception catch (e, s) {
      log.error('Erro ao atualizar nome de usuário', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao atualizar nome de usuário'}));
    }
  }

  Router get router => _$UserControllerRouter(this);
}
