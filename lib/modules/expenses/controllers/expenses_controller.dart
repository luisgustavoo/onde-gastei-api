import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/expenses/services/i_expense_services.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_save_input_model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'expenses_controller.g.dart';

@Injectable()
class ExpensesController {
  ExpensesController({required this.services, required this.log});

  final IExpenseServices services;
  final ILog log;

  @Route.post('/register')
  Future<Response> createExpense(Request request) async {
    try {
      final requestData =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final expenseSaveInputModel = ExpenseSaveInputModel(
          description: requestData['descricao'].toString(),
          value: double.parse(requestData['valor'].toString()),
          date: DateTime.parse(requestData['data'].toString()),
          userId: int.parse(requestData['id_usuario'].toString()),
          categoryId: int.parse(requestData['id_categoria'].toString()));

      final expenseId = await services.createExpense(expenseSaveInputModel);

      return Response.ok(jsonEncode(
          {'message': 'Despesa criada com sucesso expenseId: $expenseId'}));
    } on Exception catch (e, s) {
      log.error('Erro ao salvar despesa', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao salvar despesa'}));
    }
  }

  @Route.put('/<expenseId|[0-9]+>/update')
  Future<Response> deleteExpenseById(Request request) async {
    return Response.ok(jsonEncode(''));
  }

  Router get router => _$ExpensesControllerRouter(this);
}
