import 'package:calculators/calculators/conversions/temperature/controllers/temperature_controller.dart';
import 'package:calculators/calculators/conversions/temperature/models/temperature_state.dart';
import 'package:calculators/calculators/conversions/temperature/services/temperature_logic.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUp(() {
    if (GetIt.I.isRegistered<LocalNumberSymbols>()) {
      GetIt.I.unregister<LocalNumberSymbols>();
    }
    final symbols = LocalNumberSymbols();
    symbols.updateFromLocale('en-US');
    GetIt.I.registerSingleton<LocalNumberSymbols>(symbols);
  });

  tearDown(() {
    if (GetIt.I.isRegistered<LocalNumberSymbols>()) {
      GetIt.I.unregister<LocalNumberSymbols>();
    }
  });

  test('converts celsius to fahrenheit kelvin and rankine', () {
    final values = TemperatureLogic.convert('0', TemperatureScale.celsius);

    expect(values.celsius, '0');
    expect(values.fahrenheit, '32');
    expect(values.kelvin, '273.15');
    expect(values.rankine, '491.67');
  });

  test('updates all temperatures while typing', () {
    final controller = TemperatureController();

    controller.onButtonPressed('2');
    controller.onButtonPressed('5');

    expect(controller.state.activeScale, TemperatureScale.celsius);
    expect(controller.state.currentInput, '25');
    expect(controller.state.celsius, '25');
    expect(controller.state.fahrenheit, '77');
    expect(controller.state.kelvin, '298.15');
    expect(controller.state.rankine, '536.67');
  });
}
