import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/exceptions/database_exception.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/categories/data/category_repository.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_save_input_model.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_update_input_model.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';
import '../../../core/mysql/mock_database_connection.dart';
import '../../../core/mysql/mock_mysql_exception.dart';
import '../../../core/mysql/mock_results.dart';

void main() {
  late MockDatabaseConnection database;
  late ILog log;
  late CategoryRepository categoryRepository;

  setUp(() {
    database = MockDatabaseConnection();
    log = MockLogger();
    categoryRepository = CategoryRepository(connection: database, log: log);
  });

  group('Group test create category', () {
    test('Should create category with success', () async {
      // Arrange
      const categoryId = 1;
      final categorySaveInputModel = CategorySaveInputModel(
        description: 'Supermercado',
        iconCode: 59553,
        colorCode: 4278190080,
        userId: 1,
      );
      final mockResults = MockResults();
      when(() => mockResults.insertId).thenReturn(1);
      database.mockQuery(mockResults);
      //Act
      final category =
          await categoryRepository.createCategory(categorySaveInputModel);

      //Assert
      expect(category, categoryId);
      database.verifyConnectionClose();
    });

    test('Should throws DatabaseException', () async {
      // Arrange
      final categorySaveInputModel = CategorySaveInputModel(
        description: 'Supermercado',
        iconCode: 59553,
        colorCode: 4278190080,
        userId: 1,
      );

      database.mockQueryException(mockException: MockMysqlException());
      //Act
      final call = categoryRepository.createCategory;

      //Assert
      expect(call(categorySaveInputModel), throwsA(isA<DatabaseException>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      database.verifyConnectionClose();
    });
  });

  group('Group test update category by id', () {
    test('Update category by id with success', () async {
      //Arrange
      final categoryUpdateInputModel = CategoryUpdateInputModel(
        description: 'Supermercado',
        iconCode: 59553,
        colorCode: 4278190080,
      );

      database.mockQuery(MockResults());

      //Act
      await categoryRepository.updateCategoryById(
        1,
        categoryUpdateInputModel,
      );

      //Assert
      verify(() => database.mySqlConnection.query(any(), any())).called(1);
      database.verifyConnectionClose();
    });

    test('Update category exception', () async {
      //Arrange
      final categoryUpdateInputModel = CategoryUpdateInputModel(
        description: 'Supermercado',
        iconCode: 59553,
        colorCode: 4278190080,
      );

      database.mockQueryException(mockException: MockMysqlException());

      //Act
      final call = categoryRepository.updateCategoryById;

      //Assert
      expect(
        () => call(
          1,
          categoryUpdateInputModel,
        ),
        throwsA(isA<DatabaseException>()),
      );
      await Future<void>.delayed(const Duration(milliseconds: 200));

      verify(() => log.error(any(), any(), any())).called(1);
      verify(() => database.mySqlConnection.query(any(), any())).called(1);
      database.verifyConnectionClose();
    });
  });

  group('Group test delete category by id', () {
    test('Delete category by id with success', () async {
      //Arrange
      database.mockQuery(MockResults());

      //Act
      await categoryRepository.deleteCategoryById(1);

      //Assert
      verify(() => database.mySqlConnection.query(any(), any())).called(1);
      database.verifyConnectionClose();
    });

    test('Delete category exception', () async {
      //Arrange
      database.mockQueryException();

      //Act
      final call = categoryRepository.deleteCategoryById;

      //Assert
      expect(
        () => call(1),
        throwsA(isA<DatabaseException>()),
      );
      await Future<void>.delayed(const Duration(milliseconds: 200));

      verify(() => log.error(any(), any(), any())).called(1);
      verify(() => database.mySqlConnection.query(any(), any())).called(1);
      database.verifyConnectionClose();
    });
  });
}
