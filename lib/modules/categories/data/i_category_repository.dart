import 'package:onde_gastei_api/modules/categories/view_model/category_save_input_model.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_update_input_model.dart';

abstract class ICategoryRepository {
  Future<int> createCategory(CategorySaveInputModel categorySaveInputModel);

  Future<void> updateCategoryById(
    int categoryId,
    CategoryUpdateInputModel categoryUpdateInputModel,
  );

  Future<void> deleteCategoryById(int categoryId);

  Future<int> expenseQuantityByCategoryId(int categoryId);
}
