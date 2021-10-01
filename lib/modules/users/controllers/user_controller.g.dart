// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$UserControllerRouter(UserController service) {
  final router = Router();
  router.add('GET', r'/', service.findByToken);
  router.add('PUT', r'/<userId|[0-9]+>/update', service.updateUserNameById);
  router.add(
      'GET', r'/<userId|[0-9]+>/categories', service.findCategoriesByUserId);
  router.add('GET', r'/<userId|[0-9]+>/categories/period',
      service.findExpenseByUserIdAndPeriod);
  router.add('GET', r'/<userId|[0-9]+>/expenses/categories',
      service.findExpensesByCategories);
  router.add('GET', r'/<userId|[0-9]+>/percentage/categories',
      service.findPercentageByCategories);
  return router;
}
