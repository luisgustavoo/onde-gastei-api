import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/entities/category.dart';
import 'package:onde_gastei_api/entities/user.dart';
import 'package:onde_gastei_api/exceptions/database_exception.dart';
import 'package:onde_gastei_api/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_api/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/users/data/user_repository.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_categories_by_percentage_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expense_by_period_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expenses_by_categories_view_model.dart';
import 'package:test/test.dart';

import '../../core/fixture/fixture_reader.dart';
import '../../core/log/mock_logger.dart';
import '../../core/mysql/mock_database_connection.dart';
import '../../core/mysql/mock_mysql_exception.dart';
import '../../core/mysql/mock_results.dart';

void main() {
  late MockDatabaseConnection database;
  late ILog log;
  late UserRepository userRepository;

  setUp(() {
    database = MockDatabaseConnection();
    log = MockLogger();
    userRepository = UserRepository(connection: database, log: log);
  });

  group('Group test createUser', () {
    test('Should create users with success', () async {
      // Arrange
      const userId = 1;
      const name = 'Luis Gustavo';
      const email = 'luisgustavovieirasantos@gmail.com';
      const password = '123132';

      final mockResults = MockResults();

      when(() => mockResults.insertId).thenReturn(userId);
      database.mockQuery(mockResults);

      //Act
      final user = await userRepository.createUser(name, email, password);

      //Assert
      expect(user, userId);
      database.verifyConnectionClose();
    });

    test('Should throw DatabaseException', () async {
      // Arrange
      const name = 'Luis Gustavo';
      const email = 'luisgustavovieirasantos@gmail.com';
      const password = '123132';
      database.mockQueryException();

      //Act
      final call = userRepository.createUser;

      //Assert
      expect(call(name, email, password), throwsA(isA<DatabaseException>()));
    });

    test('Should throw UserExistsException', () async {
      // Arrange
      const name = 'Luis Gustavo';
      const email = 'luisgustavovieirasantos@gmail.com';
      const password = '123132';
      database.mockQueryException();
      final exception = MockMysqlException();
      when(() => exception.message).thenReturn('usuario.email_UNIQUE');
      database.mockQueryException(mockException: exception);
      //Act
      final call = userRepository.createUser;
      //Assert
      expect(call(name, email, password), throwsA(isA<UserExistsException>()));
    });
  });

  group('Group test login', () {
    test('Should login success', () async {
      // Arrange
      const email = 'luisgustavovieirasantos@gmail.com';
      const password = '123132';
      final userExpect = User(
          id: 1,
          name: 'Luis Gustavo',
          email: 'luisgustavovieirasantos@gmail.com');
      final jsonData = FixtureReader.getJsonData(
          'modules/users/data/fixture/login_with_email_password_success.json');
      final mockResults = MockResults(jsonData);
      database.mockQuery(mockResults);

      //Act
      final user = await userRepository.login(email, password);

      //Assert
      expect(user, userExpect);
      database.verifyConnectionClose();
    });

    test('Should throw DatabaseException', () async {
      // Arrange
      const name = 'Luis Gustavo';
      const email = 'luisgustavovieirasantos@gmail.com';
      database.mockQueryException();

      //Act
      final call = userRepository.login;

      //Assert
      expect(call(name, email), throwsA(isA<DatabaseException>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      database.verifyConnectionClose();
    });

    test('Should throw UserNotFoundException', () async {
      // Arrange
      const name = 'Luis Gustavo';
      const email = 'luisgustavovieirasantos@gmail.com';
      final mockResults = MockResults();
      database.mockQuery(mockResults);

      //Act
      final call = userRepository.login;

      //Assert
      expect(call(name, email), throwsA(isA<UserNotFoundException>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      database.verifyConnectionClose();
    });
  });

  group('Group test findById', () {
    test('Should findById with success', () async {
      // Arrange
      const userId = 1;
      final userExpect = User(
          id: 1,
          name: 'Luis Gustavo',
          email: 'luisgustavovieirasantos@gmail.com');
      final jsonData = FixtureReader.getJsonData(
          'modules/users/data/fixture/find_by_id_success.json');
      final mockResults = MockResults(jsonData);
      database.mockQuery(mockResults);

      //Act
      final user = await userRepository.findById(userId);

      //Assert
      expect(user, userExpect);
      database.verifyConnectionClose();
    });

    test('Should throws DatabaseException', () async {
      // Arrange
      const userId = 1;
      database.mockQueryException(mockException: MockMysqlException());

      //Act
      final call = userRepository.findById;

      //Assert
      expect(call(userId), throwsA(isA<DatabaseException>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      database.verifyConnectionClose();
    });

    test('Should throws DatabaseException', () async {
      // Arrange
      const userId = 1;
      final mockResults = MockResults();
      database.mockQuery(mockResults);

      //Act
      final call = userRepository.findById;

      //Assert
      expect(call(userId), throwsA(isA<UserNotFoundException>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      database.verifyConnectionClose();
    });
  });

  group('Group test findCategoriesByUserId', () {
    test('Should find categories with success', () async {
      // Arrange
      const userId = 1;
      final jsonData = FixtureReader.getJsonData(
          'modules/users/data/fixture/find_categories_by_user_id_success.json');
      final mockResults = MockResults(jsonData);
      database.mockQuery(mockResults);
      final categoriesExpect = <Category>[
        Category(
            id: 1,
            description: 'Supermercado',
            iconCode: 59553,
            colorCode: 4278190080,
            userId: userId),
      ];

      //Act
      final categories = await userRepository.findCategoriesByUserId(userId);

      //Assert
      expect(categories, categoriesExpect);
      database.verifyConnectionClose();
    });

    test('Should categories list empty', () async {
      // Arrange
      const userId = 1;
      final mockResults = MockResults();
      database.mockQuery(mockResults);
      //Act
      final categories = await userRepository.findCategoriesByUserId(userId);

      //Assert
      expect(categories, <Category>[]);
      database.verifyConnectionClose();
    });

    test('Should throws DatabaseException', () async {
      // Arrange
      const userId = 1;
      database.mockQueryException(mockException: MockMysqlException());

      //Act
      final call = userRepository.findCategoriesByUserId;

      //Assert
      expect(call(userId), throwsA(isA<DatabaseException>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      database.verifyConnectionClose();
    });
  });

  group('group test findExpenseByUserIdAndPeriod', () {
    test('Should expenses by user id and period success', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      final expensesExpected = UserExpenseByPeriodViewModel(
          expenseId: 1,
          description: 'Compra no supermercado',
          value: 150.5,
          date: DateTime.parse('2021-09-28T00:00:00.000Z'),
          category: Category(
              id: 2,
              description: 'Supermercado',
              iconCode: 59553,
              colorCode: 4293128957));

      final jsonData = FixtureReader.getJsonData(
          'modules/users/data/fixture/find_expense_by_userid_and_period.json');
      final mockResults = MockResults(jsonData);
      database.mockQuery(mockResults);

      //Act
      final expense = await userRepository.findExpenseByPeriod(
          userId, initialDate, finalDate);
      //Assert
      expect(expense[0], expensesExpected);
      expect(expense[0], isA<UserExpenseByPeriodViewModel>());
      database.verifyConnectionClose();
    });

    test('Should expenses list empty', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      final mockResults = MockResults();
      database.mockQuery(mockResults);
      //Act
      final expense = await userRepository.findExpenseByPeriod(
          userId, initialDate, finalDate);

      //Assert
      expect(expense, <UserExpenseByPeriodViewModel>[]);
      database.verifyConnectionClose();
    });

    test('Should throws DatabaseException', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      database.mockQueryException(mockException: MockMysqlException());

      //Act
      final call = userRepository.findExpenseByPeriod;

      //Assert
      expect(call(userId, initialDate, finalDate),
          throwsA(isA<DatabaseException>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      database.verifyConnectionClose();
    });
  });

  group('Group test findExpensesByCategories', () {
    test('Should return expenses by categories success', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      final expenseByCategoriesExpected = UserExpensesByCategoriesViewModel(
          categoryId: 1, description: 'Supermercado', totalValue: 15.5);
      final jsonData = FixtureReader.getJsonData(
          'modules/users/data/fixture/find_total_expense_by_categories_success.json');
      final mockResults = MockResults(jsonData);
      database.mockQuery(mockResults);
      //Act
      final expenseByCategories = await userRepository
          .findTotalExpensesByCategories(userId, initialDate, finalDate);

      //Assert
      expect(expenseByCategories[0], expenseByCategoriesExpected);
    });

    test('Should return expenses by categories empty', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      final mockResults = MockResults();
      database.mockQuery(mockResults);
      //Act

      final expenseByCategories = await userRepository
          .findTotalExpensesByCategories(userId, initialDate, finalDate);


      //Assert
      expect(expenseByCategories, <UserExpensesByCategoriesViewModel>[]);
    });

    test('Should throws DatabaseException', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      database.mockQueryException(mockException: MockMysqlException());

      //Act

      final call = userRepository.findTotalExpensesByCategories;


      //Assert
      expect(call(userId, initialDate, finalDate),
          throwsA(isA<DatabaseException>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      database.verifyConnectionClose();
    });
  });

  group('Group test findPercentageByCategories', () {
    test('Should return categories by percentage with success', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      final jsonData = FixtureReader.getJsonData(
          'modules/users/data/fixture/find_percentage_by_categories_success.json');
      final mockResults = MockResults(jsonData);
      database.mockQuery(mockResults);
      final userCategoriesPercentageExpected =
          UserCategoriesByPercentageViewModel(
              categoryId: 1,
              description: 'Supermercado',
              categoryValue: 150.5,
              categoryPercentage: 60.08);

      //Act
      final userCategoriesPercentage = await userRepository
          .findPercentageByCategories(userId, initialDate, finalDate);

      //Assert
      expect(userCategoriesPercentage[0], userCategoriesPercentageExpected);
      database.verifyConnectionClose();
    });

    test('Should return categories by percentage empty', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      final mockResults = MockResults();
      database.mockQuery(mockResults);
      //Act
      final userCategoriesPercentage = await userRepository
          .findPercentageByCategories(userId, initialDate, finalDate);

      //Assert
      expect(userCategoriesPercentage, <UserCategoriesByPercentageViewModel>[]);
      database.verifyConnectionClose();
    });

    test('Should return throw DatabaseException', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      database.mockQueryException(mockException: MockMysqlException());

      //Act
      final call = userRepository.findPercentageByCategories;

      //Assert
      expect(call(userId, initialDate, finalDate),
          throwsA(isA<DatabaseException>()));

      await Future<void>.delayed(const Duration(milliseconds: 200));
      database.verifyConnectionClose();
    });
  });

  group('Group findExpensesByCategory', () {
    test('Should expenses by category with success', () async {
      // Arrange
      const userId = 1;
      const categoryId = 2;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      final expensesExpected = UserExpenseByPeriodViewModel(
          expenseId: 1,
          description: 'Compra no supermercado',
          value: 150.5,
          date: DateTime.parse('2021-09-28T00:00:00.000Z'),
          category: Category(
              id: 2,
              description: 'Supermercado',
              iconCode: 59553,
              colorCode: 4293128957));

      final jsonData = FixtureReader.getJsonData(
          'modules/users/data/fixture/find_expenses_by_category_success.json');
      final mockResults = MockResults(jsonData);
      database.mockQuery(mockResults);

      //Act
      final expense = await userRepository.findExpensesByCategories(
          userId, categoryId, initialDate, finalDate);
      //Assert
      expect(expense[0], expensesExpected);
      expect(expense[0], isA<UserExpenseByPeriodViewModel>());
      database.verifyConnectionClose();
    });

    test('Should return expenses by categories empty', () async {
      // Arrange
      const userId = 1;
      const categoryId = 2;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      final mockResults = MockResults();
      database.mockQuery(mockResults);
      //Act
      final expenseByCategories = await userRepository.findExpensesByCategories(
          userId, categoryId, initialDate, finalDate);

      //Assert
      expect(expenseByCategories, <UserExpensesByCategoriesViewModel>[]);
    });

    test('Should throws DatabaseException', () async {
      // Arrange
      const userId = 1;
      const categoryId = 2;
      final initialDate = DateTime.parse('2021-09-28');
      final finalDate = DateTime.parse('2021-09-28');
      database.mockQueryException(mockException: MockMysqlException());

      //Act
      final call = userRepository.findExpensesByCategories;

      //Assert
      expect(call(userId, categoryId, initialDate, finalDate),
          throwsA(isA<DatabaseException>()));

      await Future<void>.delayed(const Duration(milliseconds: 200));
      database.verifyConnectionClose();
    });
  });
}
