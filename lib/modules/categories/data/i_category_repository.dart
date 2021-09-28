import 'package:onde_gastei_api/modules/categories/view_model/category_save_input_model.dart';

abstract class ICategoryRepository {
  Future<int> createCategory(CategorySaveInputModel categorySaveInputModel);
}
