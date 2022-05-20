import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/exceptions/database_exception.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/expenses/data/expense_repository.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_save_input_model.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';
import '../../../core/mysql/mock_database_connection.dart';
import '../../../core/mysql/mock_mysql_exception.dart';
import '../../../core/mysql/mock_results.dart';

void main() {
  late MockDatabaseConnection database;
  late ILog log;
  late ExpenseRepository expenseRepository;

  setUp(() {
    database = MockDatabaseConnection();
    log = MockLogger();
    expenseRepository = ExpenseRepository(connection: database, log: log);
  });

  group('Group test create expenses', () {
    test('Should create expenses with success', () async {
      const expenseIdExpected = 1;

      final expenseSaveInputModel = ExpenseSaveInputModel(
        description: 'Test',
        value: 1,
        date: DateTime.now(),
        local: 'Test',
        userId: 1,
        categoryId: 1,
      );

      final mockResults = MockResults();
      when(() => mockResults.insertId).thenReturn(1);
      database.mockQuery(mockResults);
      //Act
      final expenseId =
          await expenseRepository.createExpense(expenseSaveInputModel);

      //Assert
      expect(expenseId, expenseIdExpected);
      database.verifyConnectionClose();
    });

    test('Should throws DatabaseException', () async {
      // Arrange
      final expenseSaveInputModel = ExpenseSaveInputModel(
        description: 'Test',
        value: 1,
        date: DateTime.now(),
        local: 'Test',
        userId: 1,
        categoryId: 1,
      );

      final exception = MockMysqlException();
      database.mockQueryException(mockException: exception);
      //Act
      final call = expenseRepository.createExpense;

      //Assert
      expect(
        () => call(expenseSaveInputModel),
        throwsA(
          isA<DatabaseException>(),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 200));
      database.verifyConnectionClose();
    });
  });
}
