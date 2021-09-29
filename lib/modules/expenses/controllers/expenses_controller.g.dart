// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ExpensesControllerRouter(ExpensesController service) {
  final router = Router();
  router.add('POST', r'/register', service.createExpense);
  router.add('PUT', r'/<expenseId|[0-9]+>/update', service.deleteExpenseById);
  return router;
}
