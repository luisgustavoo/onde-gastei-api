import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/categories/services/i_category_service.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_save_input_model.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_update_input_model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'category_controller.g.dart';

@Injectable()
class CategoryController {
  CategoryController({required this.service, required this.log});

  final ICategoryService service;
  final ILog log;

  @Route.post('/register')
  Future<Response> createCategory(Request request) async {
    try {
      final dataRequest =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final categorySaveInputModel = CategorySaveInputModel(
        description: dataRequest['descricao'].toString(),
        iconCode: int.parse(dataRequest['codigo_icone'].toString()),
        colorCode: int.parse(dataRequest['codigo_cor'].toString()),
        userId: int.parse(dataRequest['id_usuario'].toString()),
      );

      final categoryId = await service.createCategory(categorySaveInputModel);

      return Response.ok(
        jsonEncode(
          {'message': 'Categoria criada com sucesso id:$categoryId'},
        ),
      );
    } on Exception catch (e, s) {
      log.error('Erro ao cadastrar categoria', e, s);
      return Response.internalServerError(
        body: jsonEncode({'message': 'Erro ao cadastrar categoria'}),
      );
    }
  }

  @Route.put('/<categoryId|[0-9]+>/update')
  Future<Response> updateCategoryById(
    Request request,
    String categoryId,
  ) async {
    try {
      final requestData =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final categoryUpdateInputModel = CategoryUpdateInputModel(
        description: requestData['descricao'].toString(),
        iconCode: int.parse(requestData['codigo_icone'].toString()),
        colorCode: int.parse(requestData['codigo_cor'].toString()),
      );

      await service.updateCategoryById(
        int.parse(categoryId),
        categoryUpdateInputModel,
      );

      return Response.ok(
        jsonEncode({'message': 'Categoria atualizado com sucesso'}),
      );
    } on Exception catch (e, s) {
      log.error('Erro ao atualizar categoria', e, s);
      return Response.internalServerError(
        body: jsonEncode({'message': 'Erro ao atualizar categoria'}),
      );
    }
  }

  @Route.delete('/<categoryId|[0-9]+>/delete')
  Future<Response> deleteCategoryById(
    Request request,
    String categoryId,
  ) async {
    try {
      await service.deleteCategoryById(int.parse(categoryId));

      return Response.ok(
        jsonEncode({'message': 'Categoria deletada com sucesso'}),
      );
    } on Exception catch (e, s) {
      log.error('Erro ao deletar categoria $categoryId', e, s);
      return Response.internalServerError(
        body: jsonEncode({'message': 'Erro ao deletar categoria'}),
      );
    }
  }

  Router get router => _$CategoryControllerRouter(this);
}
