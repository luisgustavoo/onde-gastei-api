// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AuthControllerRouter(AuthController service) {
  final router = Router();
  router.add('POST', r'/register', service.createUser);
  router.add('POST', r'/', service.login);
  router.add('PATCH', r'/confirm', service.confirmLogin);
  router.add('GET', r'/refresh', service.refresToken);
  return router;
}
