import 'package:onde_gastei_api/modules/expenses/view_model/expense_save_input_model.dart';

abstract class IExpenseServices {
  Future<int> createExpense(ExpenseSaveInputModel expenseSaveInputModel);
}