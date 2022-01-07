import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_api/logs/i_log.dart';
import 'package:onde_gastei_api/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_api/modules/expenses/services/i_expense_services.dart';
import 'package:onde_gastei_api/modules/expenses/view_model/expense_save_input_model.dart';
import 'package:shelf/shelf.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/shelf/mock_shelf_request.dart';

class MockExpensesServices extends Mock implements IExpenseServices {}

class MockExpenseSaveInputModel extends Mock implements ExpenseSaveInputModel {}

void main() {
  late IExpenseServices service;
  late ILog log;
  late ExpensesController expensesController;
  late Request request;

  setUp(() {
    service = MockExpensesServices();
    log = MockLogger();
    expensesController = ExpensesController(service: service, log: log);
    registerFallbackValue(MockExpenseSaveInputModel());
    request = MockShelfRequest();
  });

  group('Group test createExpense', () {
    test('Should createExpense with success', () async {
      //Arrange
      final dataRequestFixture = FixtureReader.getJsonData(
          'modules/expenses/controller/fixture/create_expense_request.json');

      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);
      when(() => service.createExpense(any())).thenAnswer((_) async => 1);

      //Act
      final response = await expensesController.createExpense(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(response.statusCode, 200);
      expect(responseData['message'].toString().contains('1'), true);
      verify(() => service.createExpense(any())).called(1);
    });

    test('Should throws Exception', () async {
      //Arrange
      final dataRequestFixture = FixtureReader.getJsonData(
          'modules/expenses/controller/fixture/create_expense_request.json');

      when(() => request.readAsString())
          .thenAnswer((_) async => dataRequestFixture);
      when(() => service.createExpense(any())).thenThrow(Exception());

      //Act
      final response = await expensesController.createExpense(request);

      //Assert
      final responseData =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(response.statusCode, 500);
      expect(
          responseData['message'].toString().contains('Erro ao salvar despesa'),
          true);
      verify(() => service.createExpense(any())).called(1);
    });
  });
}
