import 'package:calculators/utils/extensions/decimal_extensions.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUpAll(() {
    if (!GetIt.I.isRegistered<LocalNumberSymbols>()) {
      final localNumberSymbols = LocalNumberSymbols();
      localNumberSymbols.updateFromLocale('en_US');
      GetIt.I.registerSingleton<LocalNumberSymbols>(localNumberSymbols);
    }
  });

  tearDownAll(() async {
    await GetIt.I.reset();
  });

  group('DecimalExtensions.formatResult', () {
    test('formats result in scientific format if necessary', () {
      expect(Decimal.parse('12345678901234').formatResult(Decimal.parse('12345678901234'), n: 10), equals('1.23456789E+13'));
      expect(Decimal.parse('0.0000000012345678901234').formatResult(Decimal.parse('0.0000000012345678901234'), n: 9), equals('1.23456789E-9'));
    });
  });
}
