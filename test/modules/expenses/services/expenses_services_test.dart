import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/exceptions/database_exception.dart';
import 'package:onde_gastei_api/modules/expenses/data/i_expense_repository.dart';
import 'package:onde_gastei_api/modules/expenses/services/expense_services.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_save_input_model.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_update_input_model.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockExpenseRepository extends Mock implements IExpenseRepository {}

void main() {
  late IExpenseRepository repository;
  late ExpenseServices expenseServices;

  setUp(() {
    repository = MockExpenseRepository();
    expenseServices = ExpenseServices(repository: repository);
  });

  group('Group test createExpense', () {
    test('Should createExpense with succes', () async {
      //Arrange
      final expenseSaveInputModel = ExpenseSaveInputModel(
        categoryId: 1,
        description: 'Bla bla',
        date: DateTime.now(),
        value: 1,
        userId: 1,
      );

      when(() => repository.createExpense(expenseSaveInputModel))
          .thenAnswer((_) async => 1);
      //Act
      final exepenseId =
          await expenseServices.createExpense(expenseSaveInputModel);

      //Assert
      expect(exepenseId, 1);
      verify(() => repository.createExpense(expenseSaveInputModel)).called(1);
    });

    test('Should throws DatabaseException', () async {
      //Arrange
      final expenseSaveInputModel = ExpenseSaveInputModel(
        description: 'Bla bla',
        date: DateTime.now(),
        value: 1,
        categoryId: 1,
        userId: 1,
      );

      when(() => repository.createExpense(expenseSaveInputModel))
          .thenThrow(DatabaseException());
      //Act
      final call = expenseServices.createExpense;

      //Assert
      expect(
        () => call(expenseSaveInputModel),
        throwsA(isA<DatabaseException>()),
      );
      verify(() => repository.createExpense(expenseSaveInputModel)).called(1);
    });
  });

  group('Group test ', () {
    test('Should updateExpenseById with success', () async {
      //Arrange
      final expenseUpdateInputModel = ExpenseUpdateInputModel(
        description: 'Bla bla',
        value: 1,
        date: DateTime.now(),
        categoryId: 1,
      );

      when(() => repository.updateExpenseById(any(), expenseUpdateInputModel))
          .thenAnswer((_) async => _);

      //Act
      await expenseServices.updateExpenseById(1, expenseUpdateInputModel);

      //Assert
      verify(() => repository.updateExpenseById(any(), expenseUpdateInputModel))
          .called(1);
    });

    test('Should updateExpenseById DatabaseException', () async {
      //Arrange
      final expenseUpdateInputModel = ExpenseUpdateInputModel(
        description: 'Bla bla',
        value: 1,
        date: DateTime.now(),
        categoryId: 1,
      );

      when(() => repository.updateExpenseById(any(), expenseUpdateInputModel))
          .thenThrow(DatabaseException());

      //Act
      final call = expenseServices.updateExpenseById;

      //Assert
      expect(
        () => call(1, expenseUpdateInputModel),
        throwsA(isA<DatabaseException>()),
      );
      verify(() => repository.updateExpenseById(any(), expenseUpdateInputModel))
          .called(1);
    });
  });
}
