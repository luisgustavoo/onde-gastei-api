import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/entities/user.dart';
import 'package:onde_gastei_api/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_api/helpers/jwt_helper.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/users/controllers/auth_controller.dart';
import 'package:onde_gastei_api/modules/users/services/i_user_service.dart';
import 'package:onde_gastei_api/modules/users/view_model/refresh_token_view_model.dart';
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

  group('Group test createUser', () {
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

  group('Group test login', () {
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

  group('Group test confirmLogin', () {
    test('Should confirmLogin with success', () async {
      //Arrange
      const userId = 1;
      final refreshTokenExpected = JwtHelper.generateJwt(userId);

      when(() => request.headers)
          .thenReturn(<String, String>{'user': userId.toString()});
      when(() => service.confirmLogin(any(), any()))
          .thenAnswer((_) async => refreshTokenExpected);

      //Act
      final response = await authController.confirmLogin(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(response.statusCode, 200);
      expect(responseData['access_token'], isNotEmpty);
      expect(responseData['refresh_token'], isNotEmpty);
      expect(responseData['refresh_token'], refreshTokenExpected);
      verify(() => service.confirmLogin(any(), any())).called(1);
    });

    test('Should throws Exception', () async {
      //Arrange
      const userId = 1;

      when(() => request.headers)
          .thenReturn(<String, String>{'user': userId.toString()});
      when(() => service.confirmLogin(any(), any())).thenThrow(Exception());

      //Act
      final response = await authController.confirmLogin(request);

      //Assert
      expect(response.statusCode, 500);
    });
  });

  group('Group test refresToken', () {
    test('Should refresToken with success', () async {
      //Arrange
      const userId = 1;
      final dataRequestFixture = FixtureReader.getJsonData(
          'modules/users/controller/fixture/refresh_token_request.json');
      final accessToken = JwtHelper.generateJwt(userId);
      final refreshToken = JwtHelper.generateJwt(userId);

      when(() => request.headers).thenReturn(<String, String>{
        'user': userId.toString(),
        'access_token': accessToken
      });

      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);

      when(() => service.refreshToken(any(), any(), any())).thenAnswer(
          (_) async => RefreshTokenViewModel(
              accessToken: accessToken, refreshToken: refreshToken));
      //Act
      final response = await authController.refresToken(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(response.statusCode, 200);
      expect(responseData['access_token'], isNotEmpty);
      expect(responseData['refresh_token'], isNotEmpty);
      expect(
          responseData['access_token'].toString().contains(accessToken), true);
      expect(responseData['refresh_token'].toString().contains(refreshToken),
          true);
      verify(() => service.refreshToken(any(), any(), any())).called(1);
    });

    test('Should throws Exception', () async {
      //Arrange
      const userId = 1;
      final dataRequestFixture = FixtureReader.getJsonData(
          'modules/users/controller/fixture/refresh_token_request.json');
      final accessToken = JwtHelper.generateJwt(userId);

      when(() => request.headers).thenReturn(<String, String>{
        'user': userId.toString(),
        'access_token': accessToken
      });

      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);

      when(() => service.refreshToken(any(), any(), any()))
          .thenThrow(Exception());
      //Act
      final response = await authController.refresToken(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(response.statusCode, 500);
      expect(
          responseData['message']
              .toString()
              .contains('Erro ao atualizar access token'),
          true);
      verify(() => service.refreshToken(any(), any(), any())).called(1);
    });
  });
}
