import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/entities/user.dart';
import 'package:onde_gastei_api/exceptions/database_exception.dart';
import 'package:onde_gastei_api/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_api/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/users/data/user_repository.dart';
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
          'modules/data/fixture/login_with_email_password_success.json');
      final mockResults = MockResults(jsonData);
      database.mockQuery(mockResults);

      //Act
      final user = await userRepository.login(email, password);

      //Assert
      expect(user, userExpect);
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
          'modules/data/fixture/find_by_id_success.json');
      final mockResults = MockResults(jsonData);
      database.mockQuery(mockResults);

      //Act
      final user = await userRepository.findById(userId);

      //Assert
      expect(user, userExpect);
    });

    test('Should throws DatabaseException', () async {
      // Arrange
      const userId = 1;
      database.mockQueryException(mockException: MockMysqlException());

      //Act
      final call = userRepository.findById;

      //Assert
      expect(call(userId), throwsA(isA<DatabaseException>()));
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
    });
  });
}
