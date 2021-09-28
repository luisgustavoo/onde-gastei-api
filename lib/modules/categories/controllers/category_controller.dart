import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/categories/services/i_category_service.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_save_input_model.dart';
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
          userId: int.parse(dataRequest['id_usuario'].toString()));

      final categoryId = await service.createCategory(categorySaveInputModel);

      return Response.ok(jsonEncode(
          {'message': 'Categoria criada com sucesso id:$categoryId'}));
    } on Exception catch (e, s) {
      log.error('Erro ao cadastrar categoria', e, s);
      return Response.internalServerError(
          body: {'message': 'Erro ao cadastrar categoria'});
    }
  }


  Router get router => _$CategoryControllerRouter(this);
}
