import 'package:get_it/get_it.dart';
import 'package:onde_gastei_api/application/router/i_router.dart';
import 'package:onde_gastei_api/modules/categories/controllers/category_controller.dart';
import 'package:shelf_router/shelf_router.dart';

class CategoryRouter implements IRouter {
  @override
  void configure(Router router) {
    final categoryController = GetIt.I.get<CategoryController>();
    router.mount('/category/', categoryController.router);
  }
}
