import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/entities/category.dart';
import 'package:onde_gastei_api/entities/user.dart';
import 'package:onde_gastei_api/exceptions/database_exception.dart';
import 'package:onde_gastei_api/exceptions/service_exception.dart';
import 'package:onde_gastei_api/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_api/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_api/helpers/jwt_helper.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/users/data/i_user_repository.dart';
import 'package:onde_gastei_api/modules/users/services/user_service.dart';
import 'package:onde_gastei_api/modules/users/view_model/refresh_token_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_categories_by_percentage_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expense_by_period_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_expenses_by_categories_view_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_save_input_model.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../../core/log/mock_logger.dart';

class MockUserRepository extends Mock implements IUserRepository {}

class MockJwtHelper extends Mock implements JwtHelper {}

void main() {
  late ILog log;
  late IUserRepository userRepository;
  late UserService userService;

  setUp(() {
    log = MockLogger();
    userRepository = MockUserRepository();
    userService = UserService(repository: userRepository, log: log);
  });

  group('Group test create user', () {
    test('Should create user with success', () async {
      //Arrange
      const name = 'Bla bla';
      const firebaseUserId = '123456';
      final userSaveInputModel =
          UserSaveInputModel(name: name, firebaseUserId: firebaseUserId);

      when(() => userRepository.createUser(name, firebaseUserId))
          .thenAnswer((_) async => 1);

      //Act
      final userId = await userService.createUser(userSaveInputModel);

      //Assert
      expect(userId, 1);
      verify(() => userRepository.createUser(name, firebaseUserId)).called(1);
    });

    test('Should throws UserExistsException', () async {
      //Arrange
      const name = 'Bla bla';
      const firebaseUserId = '123456';
      final userSaveInputModel =
          UserSaveInputModel(name: name, firebaseUserId: firebaseUserId);

      when(() => userRepository.createUser(name, firebaseUserId))
          .thenThrow(UserExistsException());

      //Act
      final call = userService.createUser;

      //Assert
      expect(
        () => call(userSaveInputModel),
        throwsA(isA<UserExistsException>()),
      );
      verify(() => userRepository.createUser(name, firebaseUserId)).called(1);
    });

    test('Should throws DatabaseException', () async {
      //Arrange
      const name = 'Bla bla';
      const firebaseUserId = '123456';
      final userSaveInputModel =
          UserSaveInputModel(name: name, firebaseUserId: firebaseUserId);

      when(() => userRepository.createUser(name, firebaseUserId))
          .thenThrow(DatabaseException());

      //Act
      final call = userService.createUser;

      //Assert
      expect(() => call(userSaveInputModel), throwsA(isA<DatabaseException>()));
      verify(() => userRepository.createUser(name, firebaseUserId)).called(1);
    });
  });

  group('Group test login', () {
    test('Should login with success', () async {
      //Arrange
      const name = 'Bla bla';
      const firebaseUserId = '123456';

      final userExpected =
          User(id: 1, name: name, firebaseUserId: firebaseUserId);

      when(() => userRepository.login(firebaseUserId))
          .thenAnswer((_) async => userExpected);

      //Act
      final user = await userService.login(firebaseUserId);

      //Assert
      expect(user, userExpected);
      verify(() => userRepository.login(firebaseUserId)).called(1);
    });

    test('Should login throws UserNotFoundException', () async {
      //Arrange
      const firebaseUserId = '123456';

      when(() => userRepository.login(firebaseUserId))
          .thenThrow(UserNotFoundException());

      //Act
      final call = userService.login;

      //Assert
      expect(
        () => call(firebaseUserId),
        throwsA(isA<UserNotFoundException>()),
      );
      verify(() => userRepository.login(firebaseUserId)).called(1);
    });

    test('Should login throws DatabaseException', () async {
      //Arrange
      const firebaseUserId = '123456';

      when(() => userRepository.login(firebaseUserId))
          .thenThrow(DatabaseException());

      //Act
      final call = userService.login;

      //Assert
      expect(
        () => call(firebaseUserId),
        throwsA(isA<DatabaseException>()),
      );
      verify(() => userRepository.login(firebaseUserId)).called(1);
    });
  });

  group('Group test findById', () {
    test('Should findById with success', () async {
      //Arrange
      const id = 1;
      const name = 'Bla bla';
      const firebaseUserId = '123456';
      final userExpected =
          User(id: id, name: name, firebaseUserId: firebaseUserId);

      when(() => userRepository.findById(id))
          .thenAnswer((_) async => userExpected);

      //Act
      final user = await userService.findById(id);

      //Assert
      expect(user, userExpected);

      verify(() => userRepository.findById(id)).called(1);
    });

    test('Should throws UserNotFoundException', () async {
      //Arrange
      const id = 1;

      when(() => userRepository.findById(id))
          .thenThrow(UserNotFoundException());

      //Act
      final call = userService.findById;

      //Assert
      expect(() => call(id), throwsA(isA<UserNotFoundException>()));
      verify(() => userRepository.findById(id)).called(1);
    });

    test('Should throws DatabaseException', () async {
      //Arrange
      const id = 1;

      when(() => userRepository.findById(id)).thenThrow(DatabaseException());

      //Act
      final call = userService.findById;

      //Assert
      expect(() => call(id), throwsA(isA<DatabaseException>()));
      verify(() => userRepository.findById(id)).called(1);
    });
  });

  group('Group test findCategoriesByUserId', () {
    test('Should findCategoriesByUserId with success', () async {
      //Arrange
      const userId = 1;
      final categoryListExpcted = [
        Category(id: 1, description: 'Bla bla', iconCode: 123, colorCode: 123)
      ];

      when(() => userRepository.findCategoriesByUserId(userId))
          .thenAnswer((_) async => categoryListExpcted);

      //Act
      final categoryList = await userService.findCategoriesByUserId(userId);

      //Assert
      expect(categoryList, categoryListExpcted);
      verify(() => userRepository.findCategoriesByUserId(userId)).called(1);
    });

    test('Should category list empty', () async {
      //Arrange
      const userId = 1;

      when(() => userRepository.findCategoriesByUserId(userId))
          .thenAnswer((_) async => <Category>[]);

      //Act
      final categoryList = await userService.findCategoriesByUserId(userId);

      //Assert
      expect(categoryList, <Category>[]);
      verify(() => userRepository.findCategoriesByUserId(userId)).called(1);
    });

    test('Should throws DatabaseException', () async {
      //Arrange
      const userId = 1;

      when(() => userRepository.findCategoriesByUserId(userId))
          .thenThrow(DatabaseException());

      //Act
      final call = userService.findCategoriesByUserId;

      //Assert
      expect(() => call(userId), throwsA(isA<DatabaseException>()));
      verify(() => userRepository.findCategoriesByUserId(userId)).called(1);
    });
  });

  group('Group test findExpenseByPeriod ', () {
    test('Should findExpenseByPeriod with success', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      final userExpenseByPeriodListExpected = [
        UserExpenseByPeriodViewModel(
          expenseId: 1,
          description: 'Bla bla',
          date: DateTime.now(),
          value: 1,
          category: Category(
            id: 1,
            description: 'Bla bla',
            iconCode: 1,
            colorCode: 1,
            userId: 1,
          ),
        )
      ];

      when(
        () => userRepository.findExpenseByPeriod(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenAnswer((_) async => userExpenseByPeriodListExpected);

      //Act
      final userExpenseByPeriodList =
          await userService.findExpenseByPeriod(userId, initialDate, finalDate);

      //Assert
      expect(userExpenseByPeriodList, userExpenseByPeriodListExpected);
      verify(
        () => userRepository.findExpenseByPeriod(
          userId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });

    test('Should findExpenseByPeriod empty', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      when(
        () => userRepository.findExpenseByPeriod(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenAnswer((_) async => <UserExpenseByPeriodViewModel>[]);

      //Act
      final userExpenseByPeriodList =
          await userService.findExpenseByPeriod(userId, initialDate, finalDate);

      //Assert
      expect(userExpenseByPeriodList, <UserExpenseByPeriodViewModel>[]);
      verify(
        () => userRepository.findExpenseByPeriod(
          userId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });

    test('Should findExpenseByPeriod DatabaseException', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      when(
        () => userRepository.findExpenseByPeriod(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenThrow(DatabaseException());

      //Act
      final call = userService.findExpenseByPeriod;

      //Assert
      expect(
        () => call(userId, initialDate, finalDate),
        throwsA(isA<DatabaseException>()),
      );
      verify(
        () => userRepository.findExpenseByPeriod(
          userId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });
  });

  group('Group test findTotalExpensesByCategories', () {
    test('Should findTotalExpensesByCategories with success', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      final userExpensesByCategoriesListExpected = [
        UserExpensesByCategoriesViewModel(
          totalValue: 1,
          category: Category(
            id: 1,
            description: 'Test',
            iconCode: 1,
            colorCode: 1,
            userId: 1,
          ),
        )
      ];

      when(
        () => userRepository.findTotalExpensesByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenAnswer((_) async => userExpensesByCategoriesListExpected);

      //Act
      final userExpensesByCategoriesList = await userService
          .findTotalExpensesByCategories(userId, initialDate, finalDate);

      //Assert
      expect(
        userExpensesByCategoriesList,
        userExpensesByCategoriesListExpected,
      );
      verify(
        () => userRepository.findTotalExpensesByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });

    test('Should findTotalExpensesByCategories empty', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      when(
        () => userRepository.findTotalExpensesByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenAnswer((_) async => <UserExpensesByCategoriesViewModel>[]);

      //Act
      final userExpensesByCategoriesList = await userService
          .findTotalExpensesByCategories(userId, initialDate, finalDate);

      //Assert
      expect(
        userExpensesByCategoriesList,
        <UserExpensesByCategoriesViewModel>[],
      );
      verify(
        () => userRepository.findTotalExpensesByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });

    test('Should findTotalExpensesByCategories DatabaseException', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      when(
        () => userRepository.findTotalExpensesByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenThrow(DatabaseException());

      //Act
      final call = userService.findTotalExpensesByCategories;

      //Assert
      expect(
        () => call(userId, initialDate, finalDate),
        throwsA(isA<DatabaseException>()),
      );
      verify(
        () => userRepository.findTotalExpensesByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });
  });

  group('Group test findPercentageByCategories', () {
    test('Should findPercentageByCategories with success', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      final userCategoriesByPercentageListExpected = [
        UserCategoriesByPercentageViewModel(
          value: 1,
          percentage: 1,
          category: Category(
            id: 1,
            description: 'Test',
            iconCode: 1,
            colorCode: 1,
          ),
        )
      ];

      when(
        () => userRepository.findPercentageByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenAnswer((_) async => userCategoriesByPercentageListExpected);

      //Act
      final userCategoriesByPercentageList = await userService
          .findPercentageByCategories(userId, initialDate, finalDate);

      //Assert
      expect(
        userCategoriesByPercentageList,
        userCategoriesByPercentageListExpected,
      );
      verify(
        () => userRepository.findPercentageByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });

    test('Should findPercentageByCategories empty', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      when(
        () => userRepository.findPercentageByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenAnswer((_) async => <UserCategoriesByPercentageViewModel>[]);

      //Act
      final userCategoriesByPercentageList = await userService
          .findPercentageByCategories(userId, initialDate, finalDate);

      //Assert
      expect(
        userCategoriesByPercentageList,
        <UserCategoriesByPercentageViewModel>[],
      );
      verify(
        () => userRepository.findPercentageByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });

    test('Should findPercentageByCategories DatabaseException', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      when(
        () => userRepository.findPercentageByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenThrow(DatabaseException());

      //Act
      final call = userService.findPercentageByCategories;

      //Assert
      expect(
        () => call(userId, initialDate, finalDate),
        throwsA(isA<DatabaseException>()),
      );
      verify(
        () => userRepository.findPercentageByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });
  });

  group('Group test findExpensesByCategories', () {
    test('Should findExpensesByCategories with success', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();
      const categoryId = 1;

      final userExpenseByPeriodListExpected = [
        UserExpenseByPeriodViewModel(
          expenseId: 1,
          description: 'Bla bla',
          date: DateTime.now(),
          value: 1,
          category: Category(
            id: 1,
            description: 'Bla bla',
            iconCode: 1,
            colorCode: 1,
            userId: 1,
          ),
        )
      ];

      when(
        () => userRepository.findExpensesByCategories(
          userId,
          categoryId,
          initialDate,
          finalDate,
        ),
      ).thenAnswer((_) async => userExpenseByPeriodListExpected);

      //Act
      final userExpenseByPeriodList = await userService
          .findExpensesByCategories(userId, categoryId, initialDate, finalDate);

      //Assert
      expect(userExpenseByPeriodList, userExpenseByPeriodListExpected);
      verify(
        () => userRepository.findExpensesByCategories(
          userId,
          categoryId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });

    test('Should findExpensesByCategories empty', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();
      const categoryId = 1;

      when(
        () => userRepository.findExpensesByCategories(
          userId,
          categoryId,
          initialDate,
          finalDate,
        ),
      ).thenAnswer((_) async => <UserExpenseByPeriodViewModel>[]);

      //Act
      final userExpenseByPeriodList = await userService
          .findExpensesByCategories(userId, categoryId, initialDate, finalDate);

      //Assert
      expect(userExpenseByPeriodList, <UserExpenseByPeriodViewModel>[]);
      verify(
        () => userRepository.findExpensesByCategories(
          userId,
          categoryId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });

    test('Should findExpensesByCategories DatabaseException', () async {
      //Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();
      const categoryId = 1;

      when(
        () => userRepository.findExpensesByCategories(
          userId,
          categoryId,
          initialDate,
          finalDate,
        ),
      ).thenThrow(DatabaseException());

      //Act
      final call = userService.findExpensesByCategories;

      //Assert
      expect(
        () => call(userId, categoryId, initialDate, finalDate),
        throwsA(isA<DatabaseException>()),
      );
      verify(
        () => userRepository.findExpensesByCategories(
          userId,
          categoryId,
          initialDate,
          finalDate,
        ),
      ).called(1);
    });
  });

  group('Group test confirmLogin', () {
    test('Should confirmLogin with success', () async {
      //Arrange
      const userId = 1;
      final accessToken = JwtHelper.generateJwt(userId);
      when(() => userRepository.confirmLogin(userId, any()))
          .thenAnswer((_) async => _);

      //Act
      final responseRefreshToken =
          await userService.confirmLogin(userId, accessToken);

      //Assert
      expect(responseRefreshToken, isNotEmpty);
      verify(() => userRepository.confirmLogin(userId, any())).called(1);
    });

    test('Should confirmLogin DatabaseException', () async {
      //Arrange
      const userId = 1;
      final accessToken = JwtHelper.generateJwt(userId);
      when(() => userRepository.confirmLogin(userId, any()))
          .thenAnswer((_) async => _);

      when(() => userRepository.confirmLogin(userId, any()))
          .thenThrow(DatabaseException());
      //Act
      final call = userService.confirmLogin;

      //Assert
      expect(
        () => call(userId, accessToken),
        throwsA(isA<DatabaseException>()),
      );
      verify(() => userRepository.confirmLogin(userId, any())).called(1);
    });
  });

  group('Group test refreshToken', () {
    test('Should refreshToken with success', () async {
      //Arrange
      const userId = 1;
      final accessToken = JwtHelper.generateJwt(userId);
      final refreshToken = JwtHelper.refreshToken(accessToken);

      when(() => userRepository.updateRefreshToken(userId, any()))
          .thenAnswer((_) async => _);

      //Act
      final responseRefreshToken =
          await userService.refreshToken(userId, accessToken, refreshToken);

      //Assert
      expect(responseRefreshToken, isA<RefreshTokenViewModel>());
      expect(responseRefreshToken.accessToken, isNotEmpty);
      expect(responseRefreshToken.refreshToken, isNotEmpty);
      verify(() => userRepository.updateRefreshToken(userId, any())).called(1);
    });

    test('Should throws ServiceException ', () async {
      //Arrange

      const userId = 1;
      const accessToken = 'Bla bla';
      const refreshToken = 'Bla bla';

      //Act
      final call = userService.refreshToken;

      //Assert
      expect(
        () => call(userId, accessToken, refreshToken),
        throwsA(isA<ServiceException>()),
      );
    });

    test('Should throws JwtException ', () async {
      //Arrange

      const userId = 1;
      final accessToken = JwtHelper.generateJwt(userId);
      final refreshToken = JwtHelper.refreshToken('Bla bla');

      //Act
      final call = userService.refreshToken;

      //Assert
      expect(
        () => call(userId, accessToken, refreshToken),
        throwsA(isA<ServiceException>()),
      );
    });
  });
}
