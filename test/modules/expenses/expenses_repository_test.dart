import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/expenses/data/expense_repository.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_save_input_model.dart';
import 'package:test/test.dart';

import '../../core/log/mock_logger.dart';
import '../../core/mysql/mock_database_connection.dart';
import '../../core/mysql/mock_results.dart';

void main() {
  late MockDatabaseConnection database;
  late ILog log;
  late ExpenseRepository expensesRepository;

  setUp(() {
    database = MockDatabaseConnection();
    log = MockLogger();
    expensesRepository = ExpenseRepository(connection: database, log: log);
  });

  group('Group test create expenses', () {
    test('Should create expenses with success', () async {
      // Arrange
      const expenseId = 1;
      final expenseSaveInputModel = ExpenseSaveInputModel(
        description: 'Combustivél',
        value: 50,
        date: DateTime(2022),
        userId: 1,
        categoryId: 1,
      );

      final mockResults = MockResults();
      when(() => mockResults.insertId).thenReturn(1);
      database.mockQuery(mockResults);
      //Act
      final expense =
          await expensesRepository.createExpense(expenseSaveInputModel);

      //Assert
      expect(expense, expenseId);
    });
  });
}
