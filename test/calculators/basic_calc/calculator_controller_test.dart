import 'package:calculators/calculators/basic_calc/controllers/calculator_controller.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
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
}


