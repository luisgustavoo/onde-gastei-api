import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';
import 'package:onde_gastei_api/application/database/i_database_connection.dart';
import 'package:onde_gastei_api/exceptions/database_exception.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/expenses/data/i_expense_repository.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_save_input_model.dart';

@LazySingleton(as: IExpenseRepository)
class ExpenseRepository implements IExpenseRepository {
  ExpenseRepository({required this.connection, required this.log});

  final IDatabaseConnection connection;
  final ILog log;

  @override
  Future<int> createExpense(ExpenseSaveInputModel expenseSaveInputModel) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result = await conn.query('''
        INSERT INTO despesa(descricao, valor, data, id_usuario, id_categoria) VALUES (?, ?, ?, ?,?);
      ''', [
        expenseSaveInputModel.description,
        expenseSaveInputModel.value,
        expenseSaveInputModel.date.toIso8601String(),
        expenseSaveInputModel.userId,
        expenseSaveInputModel.categoryId
      ]);

      return result.insertId ?? 0;
    } on MySqlException catch (e, s) {
      log.error('Erro ao salvar despesa', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
