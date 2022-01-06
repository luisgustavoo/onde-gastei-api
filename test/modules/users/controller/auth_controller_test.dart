import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/entities/user.dart';
import 'package:onde_gastei_api/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/users/controllers/auth_controller.dart';
import 'package:onde_gastei_api/modules/users/services/i_user_service.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_login_input_model.dart';
import 'package:onde_gastei_api/modules/users/view_model/user_save_input_model.dart';
import 'package:shelf/shelf.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/shelf/mock_shelf_request.dart';
import 'mock/mock_ser_service.dart';

class MockUserSaveInputModel extends Mock implements UserSaveInputModel {}

class MockUserLoginInputModel extends Mock implements UserLoginInputModel {}

void main() {
  late ILog log;
  late IUserService service;
  late AuthController authController;
  late Request request;

  setUp(() {
    log = MockLogger();
    service = MockUserService();
    authController = AuthController(service: service, log: log);
    request = MockShelfRequest();
    load();
    registerFallbackValue(MockUserSaveInputModel());
    registerFallbackValue(MockUserLoginInputModel());
  });

  group('Group createUser', () {
    test('Should createUser with success', () async {
      //Arrange
      final dataRequestFixture = FixtureReader.getJsonData(
          'modules/users/controller/fixture/create_user_request.json');

      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);

      when(() => service.createUser(any())).thenAnswer((_) async => 1);

      //Act
      final response = await authController.createUser(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(response.statusCode, 200);
      expect(responseData['message'], isNotEmpty);
      expect(responseData['message'].toString().contains('1'), true);
      verify(() => service.createUser(any())).called(1);
    });

    test('Should createUser throws UserExistsException', () async {
      //Arrange
      final dataRequestFixture = FixtureReader.getJsonData(
          'modules/users/controller/fixture/create_user_request.json');

      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);

      when(() => service.createUser(any())).thenThrow(UserExistsException());

      //Act
      final response = await authController.createUser(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(response.statusCode, 400);
      expect(responseData['message'], isNotEmpty);
      expect(
          responseData['message'].toString().contains('Usuário já cadastrado'),
          true);
      verify(() => service.createUser(any())).called(1);
    });

    test('Should createUser throws Exception', () async {
      //Arrange
      final dataRequestFixture = FixtureReader.getJsonData(
          'modules/users/controller/fixture/create_user_request.json');

      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);

      when(() => service.createUser(any())).thenThrow(Exception());

      //Act
      final response = await authController.createUser(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(response.statusCode, 500);
      expect(responseData['message'], isNotEmpty);
      expect(
          responseData['message']
              .toString()
              .contains('Erro ao cadastrar usuário'),
          true);
      verify(() => service.createUser(any())).called(1);
    });
  });

  group('Group login', () {
    test('Should login with succes', () async {
      //Arrange
      final dataRequestFixture = FixtureReader.getJsonData(
          'modules/users/controller/fixture/login_request.json');
      final userExpected = User(
        id: 1,
        name: 'Luis Gustavo',
        email: 'luisgustavovieirasantos@gmail.com',
      );

      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);

      when(() => service.login(any())).thenAnswer((_) async => userExpected);

      //Act
      final response = await authController.login(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(response.statusCode, 200);
      expect(responseData['access_token'], isNotEmpty);
      expect(responseData['access_token'].toString().contains('1'), true);
      verify(() => service.login(any())).called(1);
    });

    test('Should login throws Exception', () async {
      //Arrange
      final dataRequestFixture = FixtureReader.getJsonData(
          'modules/users/controller/fixture/create_user_request.json');

      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);

      when(() => service.login(any())).thenThrow(Exception());

      //Act
      final response = await authController.login(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(response.statusCode, 500);
      expect(responseData['message'], isNotEmpty);
      expect(
          responseData['message'].toString().contains('Erro ao realizar login'),
          true);
      verify(() => service.login(any())).called(1);
    });
  });
}
