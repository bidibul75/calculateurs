import 'package:calculators/calculators/basic_calc/services/calculator_logic.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUpAll(() {
    if (GetIt.I.isRegistered<LocalNumberSymbols>()) {
      GetIt.I.unregister<LocalNumberSymbols>();
    }
    final symbols = LocalNumberSymbols();
    symbols.updateFromLocale('en_US');
    GetIt.I.registerSingleton<LocalNumberSymbols>(symbols);
  });

  tearDownAll(() async {
    await GetIt.I.reset();
  });

  group('CalculatorLogic.calculateResult exponentiation', () {
    test('accepts multiplication aliases', () {
      final starResult = CalculatorLogic.calculateResult(
        num1: '6',
        num2: '7',
        operation: '*',
      );

      final crossResult = CalculatorLogic.calculateResult(
        num1: '6',
        num2: '7',
        operation: '×',
      );

      expect(starResult, '42');
      expect(crossResult, '42');
    });

    test('supports multiplication with x', () {
      final result = CalculatorLogic.calculateResult(
        num1: '6',
        num2: '7',
        operation: 'x',
      );

      expect(result, '42');
    });

    test('keeps exact integer exponent behavior', () {
      final result = CalculatorLogic.calculateResult(
        num1: '2',
        num2: '3',
        operation: '^',
      );

      expect(result, '8');
    });

    test('supports decimal exponents for power operation', () {
      final result = CalculatorLogic.calculateResult(
        num1: '9',
        num2: '0.5',
        operation: '^',
      );

      expect(result, '3');
    });

    test('returns Error exp for non-real decimal exponent results', () {
      final result = CalculatorLogic.calculateResult(
        num1: '-2',
        num2: '0.5',
        operation: '^',
      );

      expect(result, 'Error exp');
    });

    test('returns Error exp for infinite power results', () {
      final result = CalculatorLogic.calculateResult(
        num1: '0',
        num2: '-1',
        operation: '^',
      );

      expect(result, 'Error exp');
    });

    test('supports decimal exponent in second operand chain', () {
      final result = CalculatorLogic.calculateResult(
        num1: '1',
        num2: '9',
        num3: '0.5',
        operation: '+',
        operation2: '^',
      );

      expect(result, '4');
    });
  });
}

