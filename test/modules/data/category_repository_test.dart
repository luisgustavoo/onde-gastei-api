import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/exceptions/database_exception.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/categories/data/category_repository.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_save_input_model.dart';
import 'package:test/test.dart';

import '../../core/log/mock_logger.dart';
import '../../core/mysql/mock_database_connection.dart';

import '../../core/mysql/mock_mysql_exception.dart';
import '../../core/mysql/mock_results.dart';

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
          userId: 1);
      final mockResults = MockResults();
      when(() => mockResults.insertId).thenReturn(1);
      database.mockQuery(mockResults);
      //Act
      final category =
          await categoryRepository.createCategory(categorySaveInputModel);

      //Assert
      expect(category, categoryId);
    });

    test('Should throws DatabaseException', () async {
      // Arrange
      final categorySaveInputModel = CategorySaveInputModel(
          description: 'Supermercado',
          iconCode: 59553,
          colorCode: 4278190080,
          userId: 1);
      final exception = MockMysqlException();
      database.mockQueryException(mockException: exception);
      //Act
      final call = categoryRepository.createCategory;

      //Assert
      expect(call(categorySaveInputModel), throwsA(isA<DatabaseException>()));
    });
  });
}
