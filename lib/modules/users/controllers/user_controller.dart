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
          {'id_usuario': user.id, 'nome': user.name, 'email': user.email}));
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
          UserUpdateNameInputModel(name: dataRequest['nome'].toString());

      await service.updateUserNameById(userId, userUpdateNameInputModel);

      return Response.ok(
          jsonEncode({'message': 'Nome do usuario atualizado com sucesso'}));
    } on Exception catch (e, s) {
      log.error('Erro ao atualizar nome de usuário', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao atualizar nome de usuário'}));
    }
  }

  @Route.get('/<userId|[0-9]+>/categories')
  Future<Response> findCategoriesByUserId(
      Request request, String userId) async {
    final categories = await service.findCategoriesByUserId(int.parse(userId));
    final categoriesMapped = categories
        .map((c) => {
              'id_categoria': c.id,
              'descricao': c.description,
              'codigo_icone': c.iconCode,
              'codigo_cor': c.colorCode,
            })
        .toList();
    return Response.ok(jsonEncode(categoriesMapped));
  }

  @Route.get('/<userId|[0-9]+>/categories/period')
  Future<Response> findExpenseByPeriod(
      Request request, String userId) async {
    try {
      final initialDate =
          DateTime.parse(request.url.queryParameters['datainicial'].toString());
      final finalDate =
          DateTime.parse(request.url.queryParameters['datafinal'].toString());

      final expenses = await service.findExpenseByPeriod(
          int.parse(userId.toString()), initialDate, finalDate);

      final expensesMapped = expenses
          .map((d) => {
                'id_despesa': d.expenseId,
                'descricao': d.description,
                'valor': d.value,
                'data': d.date.toIso8601String(),
                'categoria': {
                  'id_categoria': d.category.id,
                  'descricao_categoria': d.category.description,
                  'codigo_icone': d.category.iconCode,
                  'codigo_cor': d.category.colorCode,
                }
              })
          .toList();

      return Response.ok(jsonEncode(expensesMapped));
    } on Exception catch (e, s) {
      log.error('Erro ao buscar despesas por período', e, s);
      return Response.internalServerError(
          body: {'message': 'Não foi possível buscar despesas por período'});
    }
  }


  @Route.get('/<userId|[0-9]+>/total-expenses/categories')
  Future<Response> findTotalExpensesByCategories(
      Request request, String userId) async {
    try {
      final initialDate =
          DateTime.parse(request.url.queryParameters['datainicial'].toString());
      final finalDate =
          DateTime.parse(request.url.queryParameters['datafinal'].toString());


      final expenseByCategories = await service.findTotalExpensesByCategories(
          int.parse(userId.toString()), initialDate, finalDate);

      final expenseByCategoriesMapped = expenseByCategories
          .map((d) => {
                'id_categoria': d.categoryId,
                'descricao': d.description,
                'valor_total': d.totalValue
              })
          .toList();

      return Response.ok(jsonEncode(expenseByCategoriesMapped));
    } on Exception catch (e, s) {
      log.error('Erro ao buscar despesas por categorias', e, s);
      return Response.internalServerError(
          body: {'message': 'Não foi possível buscar despesas por categorias'});
    }
  }

  @Route.get('/<userId|[0-9]+>/percentage/categories')
  Future<Response> findPercentageByCategories(
      Request request, String userId) async {
    try {
      final initialDate =

          DateTime.parse(request.url.queryParameters['datainicial'].toString());
      final finalDate =
          DateTime.parse(request.url.queryParameters['datafinal'].toString());

      final userCategoriesPercentage = await service.findPercentageByCategories(
          int.parse(userId.toString()), initialDate, finalDate);

      final userCategoriesPercentageMapped = userCategoriesPercentage
          .map((c) => {
                'id_categoria': c.categoryId,
                'descricao': c.description,
                'valor_total_categoria': c.categoryValue,
                'percentual_categoria': c.categoryPercentage,
              })
          .toList();

      return Response.ok(jsonEncode(userCategoriesPercentageMapped));
    } on Exception catch (e, s) {
      log.error('Erro ao buscar percentual por categoria', e, s);
      return Response.internalServerError(
          body: jsonEncode(
              {'message': 'Erro ao buscar percentual por categoria'}));
    }
  }

  @Route.get('/<userId|[0-9]+>/expenses/categories/<categoryId|[0-9]+>')
  Future<Response> findExpensesByCategories(
      Request request, String userId, String categoryId) async {
    try {
      final initialDate = request.url.queryParameters['datainicial'];
      final finalDate = request.url.queryParameters['datafinal'];

      final expensesByCategory = await service.findExpensesByCategories(
          int.parse(userId.toString()),
          int.parse(categoryId.toString()),
          DateTime.parse(initialDate.toString()),
          DateTime.parse(finalDate.toString()));

      final expensesByCategoryMapped = expensesByCategory
          .map((d) => {
                'id_despesa': d.expenseId,
                'descricao': d.description,
                'valor': d.value,
                'data': d.date.toIso8601String(),
                'categoria': {
                  'id_categoria': d.category.id,
                  'descricao_categoria': d.category.description,
                  'codigo_icone': d.category.iconCode,
                  'codigo_cor': d.category.colorCode,
                }
              })
          .toList();

      return Response.ok(jsonEncode(expensesByCategoryMapped));
    } on Exception catch (e, s) {
      log.error('Erro ao buscar despesas por categoria', e, s);
      return Response.internalServerError(
          body: jsonEncode(
              {'message': 'Erro ao buscar despesas por categoria'}));
    }
  }

  Router get router => _$UserControllerRouter(this);
}
