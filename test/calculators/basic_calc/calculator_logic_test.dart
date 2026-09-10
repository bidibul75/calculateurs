import 'package:calculators/calculators/basic_calc/services/calculator_logic.dart';
import 'package:calculators/utils/extensions/extensions.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rational/rational.dart';

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

    test('keeps exact rational value for fractional exponent when possible', () {
      final exact = CalculatorLogic.tryExactPowerRational(
        Rational.fromInt(27),
        Rational.fromInt(2, 3),
      );

      expect(exact, Rational.fromInt(9));
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

    test('supports huge exact powers without locale registration', () {
      if (GetIt.I.isRegistered<LocalNumberSymbols>()) {
        GetIt.I.unregister<LocalNumberSymbols>();
      }

      final result = CalculatorLogic.calculateResult(
        num1: '2',
        num2: '1000',
        operation: '^',
      );

      // Internal/clean math form (dot separator); UI localizes via formatRound.
            expect(result, '1.07150860718627E+301');
          });

          test('formats very large integers in compact scientific notation for display', () {
            const raw =
                '10715086071862673209484250490600018105614048117055336074437503883703510511249361224931983788156958581275946729175531468251871452856923140435984577574698574803934567774824230985421074605062371141877954182153046474983581941267398767559165543946077062914571196477686542167660429831652624386837205668069376';

            // en_US locale in this suite: same as clean math (dot decimal sep).
            expect(raw.formatRound(), '1.07150860718627E+301');
            expect('1.07150860718627E+301'.formatRound(), '1.07150860718627E+301');
          });

          test('localizes scientific mantissa with LocalNumberSymbols decimal separator', () {
            if (!GetIt.I.isRegistered<LocalNumberSymbols>()) {
              final symbols = LocalNumberSymbols();
              symbols.updateFromLocale('en_US');
              GetIt.I.registerSingleton<LocalNumberSymbols>(symbols);
            }
            final symbols = GetIt.I<LocalNumberSymbols>();
            symbols.updateFromLocale('fr_FR');
            addTearDown(() => symbols.updateFromLocale('en_US'));

            expect(
              '1.07150860718627E+301'.formatRound(),
              '1,07150860718627E+301',
            );
          });

    test('supports exact square root for rational numbers', () {
      final result = CalculatorLogic.calculateUnary(
        input: '0.5625',
        operation: '√',
      );

      expect(result, '0.75');
    });

    test('keeps exact rational square root helper for perfect rational squares', () {
      final exact = CalculatorLogic.tryExactSqrtRational(
        Rational.fromInt(9, 16),
      );

      expect(exact, Rational.fromInt(3, 4));
    });

    test('keeps exact rational power helper for odd roots of negative values', () {
      final exact = CalculatorLogic.tryExactPowerRational(
        Rational.fromInt(-8),
        Rational.fromInt(1, 3),
      );

      expect(exact, Rational.fromInt(-2));
    });
  });
}


