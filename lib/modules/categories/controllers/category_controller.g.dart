// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$CategoryControllerRouter(CategoryController service) {
  final router = Router();
  router.add('POST', r'/register', service.createCategory);
  router.add('PUT', r'/<categoryId|[0-9]+>/update', service.updateCategoryById);
  router.add(
      'DELETE', r'/<categoryId|[0-9]+>/delete', service.deleteCategoryById);
  router.add('GET', r'/<categoryId|[0-9]+>/expenses-quantity',
      service.expenseQuantityByCategoryId);
  return router;
}
