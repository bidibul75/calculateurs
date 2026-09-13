import 'package:calculators/calculators/finance/percentage/models/percentage_state.dart';
import 'package:calculators/calculators/finance/percentage/services/percentage_logic.dart';
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

  group('PercentageLogic tax mode', () {
    test('computes gross and tax from net and rate', () {
      final values = PercentageLogic.convert(
        input: '100',
        activeField: PercentageField.primary,
        mode: PercentageMode.tax,
        primary: '0',
        rate: '20',
        delta: '0',
        result: '0',
      );

      expect(values.primary, '100');
      expect(values.rate, '20');
      expect(values.delta, '20');
      expect(values.result, '120');
    });

    test('computes net from gross and rate', () {
      final values = PercentageLogic.convert(
        input: '120',
        activeField: PercentageField.result,
        mode: PercentageMode.tax,
        primary: '0',
        rate: '20',
        delta: '0',
        result: '0',
      );

      expect(values.result, '120');
      expect(values.rate, '20');
      expect(values.primary, '100');
      expect(values.delta, '20');
    });
  });

  group('PercentageLogic discount mode', () {
    test('computes final price from original and discount rate', () {
      final values = PercentageLogic.convert(
        input: '25',
        activeField: PercentageField.rate,
        mode: PercentageMode.discount,
        primary: '80',
        rate: '0',
        delta: '0',
        result: '0',
      );

      expect(values.primary, '80');
      expect(values.rate, '25');
      expect(values.delta, '20');
      expect(values.result, '60');
    });
  });

  group('PercentageLogic tip mode', () {
    test('computes tip and total from bill and tip rate', () {
      final values = PercentageLogic.convert(
        input: '15',
        activeField: PercentageField.rate,
        mode: PercentageMode.tip,
        primary: '40',
        rate: '0',
        delta: '0',
        result: '0',
      );

      expect(values.primary, '40');
      expect(values.rate, '15');
      expect(values.delta, '6');
      expect(values.result, '46');
    });
  });

  group('PercentageLogic increase mode', () {
    test('computes increase amount and final from original and rate', () {
      final values = PercentageLogic.convert(
        input: '200',
        activeField: PercentageField.primary,
        mode: PercentageMode.increase,
        primary: '0',
        rate: '10',
        delta: '0',
        result: '0',
      );

      expect(values.primary, '200');
      expect(values.rate, '10');
      expect(values.delta, '20');
      expect(values.result, '220');
    });
  });
}
