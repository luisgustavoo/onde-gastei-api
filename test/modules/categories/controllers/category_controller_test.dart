import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/categories/controllers/category_controller.dart';
import 'package:onde_gastei_api/modules/categories/services/i_category_service.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_save_input_model.dart';
import 'package:onde_gastei_api/modules/categories/view_model/category_update_input_model.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/shelf/mock_shelf_request.dart';

class MockCategoryService extends Mock implements ICategoryService {}

class MockCategorySaveInputModel extends Mock
    implements CategorySaveInputModel {}

class MockCategoryUpdateInputModel extends Mock
    implements CategoryUpdateInputModel {}

void main() {
  late ICategoryService service;
  late ILog log;
  late CategoryController controller;
  late Request request;

  setUp(() {
    service = MockCategoryService();
    log = MockLogger();
    controller = CategoryController(service: service, log: log);
    request = MockShelfRequest();
    registerFallbackValue(MockCategorySaveInputModel());
    registerFallbackValue(MockCategoryUpdateInputModel());
  });
  group('Group test createCategory', () {
    test('Should createCategory with success', () async {
      //Arrange
      final dataRequestFixture = FixtureReader.getJsonData(
        'modules/categories/controllers/fixture/create_category_request.json',
      );
      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);
      when(() => service.createCategory(any())).thenAnswer((_) async => 1);
      //Act
      final response = await controller.createCategory(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(response.statusCode, 200);
      expect(responseData['message'].toString().contains('1'), isTrue);
      verify(() => service.createCategory(any())).called(1);
    });

    test('Should throws Exception', () async {
      //Arrange
      final dataRequestFixture = FixtureReader.getJsonData(
        'modules/categories/controllers/fixture/create_category_request.json',
      );
      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);

      when(() => service.createCategory(any())).thenThrow(Exception());
      //Act
      final response = await controller.createCategory(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(response.statusCode, 500);
      expect(
        responseData['message']
            .toString()
            .contains('Erro ao cadastrar categoria'),
        isTrue,
      );
      verify(() => service.createCategory(any())).called(1);
    });
  });

  group('Group test updateCategoryById', () {
    test('Should updateCategoryById with succes', () async {
      //Arrange
      final dataRequestFixture = FixtureReader.getJsonData(
        'modules/categories/controllers/fixture/update_category_by_id_request.json',
      );
      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);

      when(() => service.updateCategoryById(any(), any()))
          .thenAnswer((_) async => _);
      //Act
      final response = await controller.updateCategoryById(request, '1');

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(response.statusCode, 200);
      expect(
        responseData['message']
            .toString()
            .contains('Categoria atualizado com sucesso'),
        isTrue,
      );
      verify(() => service.updateCategoryById(any(), any())).called(1);
    });

    test('Should throws Exception', () async {
      //Arrange
      final dataRequestFixture = FixtureReader.getJsonData(
        'modules/categories/controllers/fixture/update_category_by_id_request.json',
      );
      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);

      when(() => service.updateCategoryById(any(), any()))
          .thenThrow(Exception());

      //Act
      final response = await controller.updateCategoryById(request, '1');

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(response.statusCode, 500);
      expect(
        responseData['message']
            .toString()
            .contains('Erro ao atualizar categoria'),
        isTrue,
      );
      verify(() => service.updateCategoryById(any(), any())).called(1);
    });
  });

  group('Group test deleteCategoryById', () {
    test('Should deleteCategoryById with succes', () async {
      //Arrange
      when(() => service.deleteCategoryById(any())).thenAnswer((_) async => _);
      //Act
      final response = await controller.deleteCategoryById(request, '1');

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(response.statusCode, 200);
      expect(
        responseData['message']
            .toString()
            .contains('Categoria deletada com sucesso'),
        isTrue,
      );
      verify(() => service.deleteCategoryById(any())).called(1);
    });

    test('Should throws Exception', () async {
      //Arrange
      when(() => service.deleteCategoryById(any())).thenThrow(Exception());
      //Act
      final response = await controller.deleteCategoryById(request, '1');

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(response.statusCode, 500);
      expect(
        responseData['message']
            .toString()
            .contains('Erro ao deletar categoria'),
        isTrue,
      );
      verify(() => service.deleteCategoryById(any())).called(1);
    });
  });
}
