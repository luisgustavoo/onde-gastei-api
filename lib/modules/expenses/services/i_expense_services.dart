import 'package:onde_gastei_api/modules/expenses/view_model/expense_save_input_model.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_update_input_model.dart';

abstract class IExpenseServices {
  Future<int> createExpense(ExpenseSaveInputModel expenseSaveInputModel);

  Future<void> updateExpenseById(
    int expenseId,
    ExpenseUpdateInputModel expenseUpdateInputModel,
  );

  Future<void> deleteExpenseById(int expenseId);
}
