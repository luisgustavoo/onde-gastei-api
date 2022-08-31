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
      service.findExpenseByPeriod);
  router.add('GET', r'/<userId|[0-9]+>/total-expenses/categories',
      service.findTotalExpensesByCategories);
  router.add('GET', r'/<userId|[0-9]+>/percentage/categories',
      service.findPercentageByCategories);
  router.add('GET', r'/<userId|[0-9]+>/expenses/categories/<categoryId|[0-9]+>',
      service.findExpensesByCategories);
  router.add('DELETE', r'/<userId|[0-9]+>', service.deleteAccount);
  return router;
}
