import 'package:get_it/get_it.dart';
import 'package:onde_gastei_api/application/router/i_router.dart';
import 'package:onde_gastei_api/modules/expenses/controllers/expenses_controller.dart';
import 'package:shelf_router/shelf_router.dart';

class ExpensesRouter implements IRouter {
  @override
  void configure(Router router) {
    final expensesController = GetIt.I.get<ExpensesController>();
    router.mount('/expenses/', expensesController.router);
  }
}
