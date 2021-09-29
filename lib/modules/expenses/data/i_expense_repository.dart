import 'package:onde_gastei_api/modules/expenses/view_model/expense_save_input_model.dart';

abstract class IExpenseRepository {
  Future<int> createExpense(ExpenseSaveInputModel expenseSaveInputModel);
}
