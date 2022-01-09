
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/exceptions/database_exception.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/categories/data/i_category_repository.dart';
import 'package:onde_gastei_api/modules/categories/services/category_service.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_save_input_model.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_update_input_model.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../../core/log/mock_logger.dart';

class MockCategoryRepository extends Mock implements ICategoryRepository {}

class MockCategorySaveInputModel extends Mock
    implements CategorySaveInputModel {}

class MockCategoryUpdateInputModel extends Mock
    implements CategoryUpdateInputModel {}

void main() {
  late ICategoryRepository repository;
  late ILog log;
  late CategoryService categoryService;

  setUp(() {
    repository = MockCategoryRepository();
    log = MockLogger();
    categoryService = CategoryService(repository: repository, log: log);
    registerFallbackValue(MockCategorySaveInputModel());
    registerFallbackValue(MockCategoryUpdateInputModel());
  });

  group('Group test createCategory', () {
    test('Should createCategory with success', () async {
      //Arrange
      final categorySaveInputModel = CategorySaveInputModel(
          description: 'Bla bla', iconCode: 1, colorCode: 1, userId: 1);
      when(() => repository.createCategory(any())).thenAnswer((_) async => 1);
      //Act
      final categoryId =
          await categoryService.createCategory(categorySaveInputModel);

      //Assert
      expect(categoryId, 1);
      verify(() => repository.createCategory(any())).called(1);
    });

    test('Should throws DatabaseException', () async {
      //Arrange
      final categorySaveInputModel = CategorySaveInputModel(
          description: 'Bla bla', iconCode: 1, colorCode: 1, userId: 1);
      when(() => repository.createCategory(any()))
          .thenThrow(DatabaseException());
      //Act
      final call = categoryService.createCategory;

      //Assert
      expect(() => call(categorySaveInputModel),
          throwsA(isA<DatabaseException>()));
      verify(() => repository.createCategory(any())).called(1);
    });
  });

  group('Group test updateCategoryById', () {
    test('Should updateCategoryById with success', () async {
      //Arrange
      final categoryUpdateInputModel = CategoryUpdateInputModel(
          description: 'Bla bla', iconCode: 1, colorCode: 1);
      when(() => repository.updateCategoryById(any(), any()))
          .thenAnswer((_) async => _);
      //Act
      await categoryService.updateCategoryById(1, categoryUpdateInputModel);

      //Assert
      verify(() => repository.updateCategoryById(any(), any())).called(1);
    });

    test('Should throws DatabaseException', () async {
      //Arrange
      final categoryUpdateInputModel = CategoryUpdateInputModel(
          description: 'Bla bla', iconCode: 1, colorCode: 1);
      when(() => repository.updateCategoryById(any(), any()))
          .thenThrow(DatabaseException());
      //Act
      final call = categoryService.updateCategoryById;

      //Assert
      expect(() => call(1, categoryUpdateInputModel),
          throwsA(isA<DatabaseException>()));
      verify(() => repository.updateCategoryById(any(), any())).called(1);
    });
  });

  group('Group test deleteCategoryById', () {
    test('Should deleteCategoryById with success', () async {
      //Arrange
      when(() => repository.deleteCategoryById(any()))
          .thenAnswer((_) async => _);
      //Act
      await categoryService.deleteCategoryById(1);

      //Assert
      verify(() => repository.deleteCategoryById(any())).called(1);
    });

    test('Should throws DatabaseException', () async {
      //Arrange
      when(() => repository.deleteCategoryById(any()))
          .thenThrow(DatabaseException());
      //Act
      final call = categoryService.deleteCategoryById;

      //Assert
      expect(() => call(1), throwsA(isA<DatabaseException>()));
      verify(() => repository.deleteCategoryById(any())).called(1);
    });
  });
}
