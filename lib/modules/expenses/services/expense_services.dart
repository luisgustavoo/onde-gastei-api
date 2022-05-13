import 'package:injectable/injectable.dart';
import 'package:onde_gastei_api/modules/expenses/data/i_expense_repository.dart';
import 'package:onde_gastei_api/modules/expenses/services/i_expense_services.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_save_input_model.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_update_input_model.dart';

@LazySingleton(as: IExpenseServices)
class ExpenseServices implements IExpenseServices {
  ExpenseServices({required this.repository});

  final IExpenseRepository repository;

  @override
  Future<int> createExpense(ExpenseSaveInputModel expenseSaveInputModel) =>
      repository.createExpense(expenseSaveInputModel);

  @override
  Future<void> updateExpenseById(
    int expenseId,
    ExpenseUpdateInputModel expenseUpdateInputModel,
  ) =>
      repository.updateExpenseById(expenseId, expenseUpdateInputModel);

  @override
  Future<void> deleteExpenseById(int expenseId) =>
      repository.deleteExpenseById(expenseId);
}
