import 'package:onde_gastei_api/application/router/i_router.dart';
import 'package:onde_gastei_api/modules/categories/category_router.dart';
import 'package:onde_gastei_api/modules/users/user_router.dart';
import 'package:shelf_router/shelf_router.dart';

class RouterConfigure {
  RouterConfigure(this._router);

  final Router _router;
  final _routers = <IRouter>[UserRouter(), CategoryRouter()];

  void configure() {
    for (final r in _routers) {
      r.configure(_router);
    }
  }
}
