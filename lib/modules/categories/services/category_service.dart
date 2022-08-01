import 'package:injectable/injectable.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/categories/data/i_category_repository.dart';
import 'package:onde_gastei_api/modules/categories/services/i_category_service.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_save_input_model.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_update_input_model.dart';

@LazySingleton(as: ICategoryService)
class CategoryService implements ICategoryService {
  CategoryService({required this.repository, required this.log});

  final ICategoryRepository repository;
  final ILog log;

  @override
  Future<int> createCategory(CategorySaveInputModel categorySaveInputModel) =>
      repository.createCategory(categorySaveInputModel);

  @override
  Future<void> updateCategoryById(
    int categoryId,
    CategoryUpdateInputModel categoryUpdateInputModel,
  ) =>
      repository.updateCategoryById(categoryId, categoryUpdateInputModel);

  @override
  Future<void> deleteCategoryById(int categoryId) =>
      repository.deleteCategoryById(categoryId);

  @override
  Future<int> expenseQuantityByCategoryId(int categoryId) =>
      repository.expenseQuantityByCategoryId(categoryId);
}
