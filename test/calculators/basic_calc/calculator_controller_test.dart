import 'package:calculators/calculators/basic_calc/controllers/calculator_controller.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rational/rational.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    if (GetIt.I.isRegistered<LocalNumberSymbols>()) {
      GetIt.I.unregister<LocalNumberSymbols>();
    }
    final symbols = LocalNumberSymbols();
    symbols.updateFromLocale('en-US');
    GetIt.I.registerSingleton<LocalNumberSymbols>(symbols);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  test('keeps only the 50 most recent history entries', () {
    final controller = CalculatorController();

    controller.onButtonPressed('1');
    controller.onButtonPressed('+');
    controller.onButtonPressed('1');
    controller.onButtonPressed('=');

    for (int i = 0; i < 50; i++) {
      controller.onButtonPressed('+');
      controller.onButtonPressed('1');
      controller.onButtonPressed('=');
    }

    expect(controller.state.historyEntries.length, 50);
    expect(controller.state.historyEntries.first.resultDisplay, '52');
    expect(controller.state.historyEntries.last.resultDisplay, '3');
  });

  test('accepts multiplication aliases from keyboard input', () {
    final controller = CalculatorController();

    controller.onButtonPressed('6');
    controller.onButtonPressed('*');
    controller.onButtonPressed('7');
    controller.onButtonPressed('=');

    expect(controller.state.output, '42');
    expect(controller.state.historyEntries.first.displayText, '6 x 7 = 42');

    controller.onButtonPressed('C');
    controller.onButtonPressed('6');
    controller.onButtonPressed('×');
    controller.onButtonPressed('7');
    controller.onButtonPressed('=');

    expect(controller.state.output, '42');
    expect(controller.state.historyEntries.first.displayText, '6 x 7 = 42');
  });

  test('marks repeating division results as approximate in history', () {
    final controller = CalculatorController();

    controller.onButtonPressed('2');
    controller.onButtonPressed('÷');
    controller.onButtonPressed('3');
    controller.onButtonPressed('=');

    expect(controller.state.output.startsWith('0.6666666666'), isTrue);
    expect(controller.state.historyEntries.first.displayText, '2 ÷ 3 = ≈ 0.6666666667');
  });

  test('keeps exact division results without approximation marker in history', () {
    final controller = CalculatorController();

    controller.onButtonPressed('1');
    controller.onButtonPressed('÷');
    controller.onButtonPressed('4');
    controller.onButtonPressed('=');

    expect(controller.state.output, '0.25');
    expect(controller.state.historyEntries.first.displayText, '1 ÷ 4 = 0.25');
  });

  test('keeps exact Rational values for chained division and addition', () {
    final controller = CalculatorController();
    final oneThird = Rational.fromInt(1) / Rational.fromInt(3);

    controller.onButtonPressed('1');
    controller.onButtonPressed('÷');
    controller.onButtonPressed('3');
    controller.onButtonPressed('=');
    expect(controller.state.currentInputValue, oneThird);

    controller.onButtonPressed('+');
    controller.onButtonPressed('1');
    controller.onButtonPressed('=');
    expect(controller.state.currentInputValue, oneThird + Rational.fromInt(1));

    controller.onButtonPressed('-');
    controller.onButtonPressed('1');
    controller.onButtonPressed('=');
    expect(controller.state.currentInputValue, oneThird);
  });

  test('keeps exact Rational values for unary reciprocal and square', () {
    final controller = CalculatorController();
    final oneThird = Rational.fromInt(1) / Rational.fromInt(3);

    controller.onButtonPressed('3');
    controller.onButtonPressed('1/x');
    expect(controller.state.currentInputValue, oneThird);

    controller.onButtonPressed('x²');
    expect(controller.state.currentInputValue, oneThird * oneThird);
  });

  test('keeps exact Rational value for percent and chained binary operation', () {
    final controller = CalculatorController();

    controller.onButtonPressed('2');
    controller.onButtonPressed('%');
    expect(controller.state.currentInputValue, Rational.fromInt(2) / Rational.fromInt(100));

    controller.onButtonPressed('+');
    controller.onButtonPressed('1');
    controller.onButtonPressed('=');
    expect(controller.state.currentInputValue, Rational.fromInt(51) / Rational.fromInt(50));
  });

  test('restores persisted internal Rational value', () async {
    final controller = CalculatorController();

    controller.onButtonPressed('1');
    controller.onButtonPressed('÷');
    controller.onButtonPressed('3');
    controller.onButtonPressed('=');

    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 10; i++) {
      if (prefs.getString('basic.currentInputValue.v1') != null) {
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }

    final restoredController = CalculatorController();
    await restoredController.restorePersistedState();

    final oneThird = Rational.fromInt(1) / Rational.fromInt(3);
    expect(restoredController.state.currentInputValue, oneThird);
    expect(restoredController.state.currentInput, controller.state.currentInput);
  });

  test('restores last interaction state so digit after restart replaces result', () async {
    final controller = CalculatorController();

    controller.onButtonPressed('1');
    controller.onButtonPressed('+');
    controller.onButtonPressed('1');
    controller.onButtonPressed('=');
    expect(controller.state.output, '2');

    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 10; i++) {
      if (prefs.getString('basic.lastAction.v1') != null) {
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }

    final restoredController = CalculatorController();
    await restoredController.restorePersistedState();

    restoredController.onButtonPressed('7');

    expect(restoredController.state.currentInput, '7');
    expect(restoredController.state.output, '7');
  });

  test('restores clear interaction state so second C after restart clears history', () async {
    final controller = CalculatorController();

    controller.onButtonPressed('1');
    controller.onButtonPressed('+');
    controller.onButtonPressed('1');
    controller.onButtonPressed('=');
    expect(controller.state.historyEntries, isNotEmpty);

    controller.onButtonPressed('C');

    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 10; i++) {
      if (prefs.getString('basic.lastAction.v1') != null) {
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(prefs.getString('basic.lastAction.v1'), 'clear');

    final restoredController = CalculatorController();
    await restoredController.restorePersistedState();

    restoredController.onButtonPressed('C');

    expect(restoredController.state.historyEntries, isEmpty);
    expect(restoredController.state.output, '0');
  });

  test('reuses exact Rational from history entry on selection', () {
    final controller = CalculatorController();
    final oneThird = Rational.fromInt(1) / Rational.fromInt(3);

    controller.onButtonPressed('1');
    controller.onButtonPressed('÷');
    controller.onButtonPressed('3');
    controller.onButtonPressed('=');

    final entry = controller.state.historyEntries.first;

    controller.onButtonPressed('C');
    controller.onButtonPressed('C');
    controller.selectHistoryEntry(entry);

    expect(controller.state.currentInputValue, oneThird);
  });

  test('keeps exact Rational value for square root when possible', () {
    final controller = CalculatorController();

    controller.onButtonPressed('0');
    controller.onButtonPressed('.');
    controller.onButtonPressed('5');
    controller.onButtonPressed('6');
    controller.onButtonPressed('2');
    controller.onButtonPressed('5');
    controller.onButtonPressed('√');

    expect(controller.state.currentInputValue, Rational.fromInt(3, 4));
  });

  test('keeps exact Rational value for x^y with rational exponent when possible', () {
    final controller = CalculatorController();

    controller.onButtonPressed('9');
    controller.onButtonPressed('x^y');
    controller.onButtonPressed('0');
    controller.onButtonPressed('.');
    controller.onButtonPressed('5');
    controller.onButtonPressed('=');

    expect(controller.state.currentInputValue, Rational.fromInt(3));
  });

  test('reproduces exact calculation: 5 ÷ 6 × 6 from history selection', () {
    final controller = CalculatorController();
    final fiveSixths = Rational.fromInt(5) / Rational.fromInt(6);
    final five = Rational.fromInt(5);

    // First calculation: 5 ÷ 6
    controller.onButtonPressed('5');
    controller.onButtonPressed('÷');
    controller.onButtonPressed('6');
    controller.onButtonPressed('=');

    expect(controller.state.currentInputValue, fiveSixths);
    final entry = controller.state.historyEntries.first;

    // Clear and select from history
    controller.onButtonPressed('C');
    controller.onButtonPressed('C');
    controller.selectHistoryEntry(entry);

    // Verify the selected value is still the exact rational
    expect(controller.state.currentInputValue, fiveSixths);

    // Now multiply by 6
    controller.onButtonPressed('x');
    controller.onButtonPressed('6');
    controller.onButtonPressed('=');

    // Should get exactly 5, not an approximation
    expect(controller.state.currentInputValue, five);
    expect(controller.state.output, '5');
  });
}
