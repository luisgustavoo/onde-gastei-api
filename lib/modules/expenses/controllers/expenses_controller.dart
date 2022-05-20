import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/expenses/services/i_expense_services.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_save_input_model.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_update_input_model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'expenses_controller.g.dart';

@Injectable()
class ExpensesController {
  ExpensesController({required this.service, required this.log});

  final IExpenseServices service;
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
        local: requestData['local'].toString(),
        userId: int.parse(requestData['id_usuario'].toString()),
        categoryId: int.parse(requestData['id_categoria'].toString()),
      );

      final expenseId = await service.createExpense(expenseSaveInputModel);

      return Response.ok(
        jsonEncode(
          {'message': 'Despesa criada com sucesso expenseId: $expenseId'},
        ),
      );
    } on Exception catch (e, s) {
      log.error('Erro ao salvar despesa', e, s);
      return Response.internalServerError(
        body: jsonEncode({'message': 'Erro ao salvar despesa'}),
      );
    }
  }

  @Route.put('/<expenseId|[0-9]+>/update')
  Future<Response> updateExpenseById(Request request, String expenseId) async {
    try {
      final requestData =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;

      final expenseUpdateInputModel = ExpenseUpdateInputModel(
        description: requestData['descricao'].toString(),
        value: double.parse(requestData['valor'].toString()),
        date: DateTime.parse(requestData['data'].toString()),
        categoryId: int.parse(requestData['id_categoria'].toString()),
      );

      await service.updateExpenseById(
        int.parse(expenseId),
        expenseUpdateInputModel,
      );

      return Response.ok(
        jsonEncode({'message': 'Despesa atualizada com sucesso'}),
      );
    } on Exception catch (e, s) {
      log.error('Erro ao atualizar despesa', e, s);
      return Response.internalServerError(
        body: jsonEncode({'message': 'Erro ao atualizar despesa'}),
      );
    }
  }

  @Route.delete('/<expenseId|[0-9]+>/delete')
  Future<Response> deleteExpenseById(Request request, String expenseId) async {
    try {
      await service.deleteExpenseById(int.parse(expenseId));

      return Response.ok(
        jsonEncode({'message': 'Despesa deletada com sucesso'}),
      );
    } on Exception catch (e, s) {
      log.error('Erro ao deletar despesa', e, s);
      return Response.internalServerError(
        body: jsonEncode({'message': 'Erro ao deletar despesa'}),
      );
    }
  }

  Router get router => _$ExpensesControllerRouter(this);
}
