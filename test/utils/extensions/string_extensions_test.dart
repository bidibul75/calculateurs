import 'package:calculators/utils/extensions/string_extensions.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
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

  group('StringExtensions.isValidIPv4', () {
    test('returns true for valid IPv4 addresses', () {
      const valid = <String>['0.0.0.0', '255.255.255.255', '192.168.1.1', ' 10.0.0.1 '];

      for (final address in valid) {
        expect(address.isValidIPv4, isTrue, reason: 'Should be valid: $address');
      }
    });

    test('returns false for invalid IPv4 addresses', () {
      const invalid = <String>['256.0.0.1', '192.168.1', '192.168.1.1.1', '192.168.01.1', 'a.b.c.d', ''];

      for (final address in invalid) {
        expect(address.isValidIPv4, isFalse, reason: 'Should be invalid: $address');
      }
    });
  });

  group('StringExtensions.isValidIPv4CIDR', () {
    test('returns true for valid IPv4 CIDR notation', () {
      const valid = <String>[
        '192.168.1.0/24',
        '10.0.0.0/8',
        '172.16.0.0/12',
        ' 192.168.1.1/32 ',
        '0.0.0.0/0',
        '255.255.255.255/32',
        '10.0.0.1/0',
        '192.168.1.100/16',
      ];

      for (final cidr in valid) {
        expect(cidr.isValidIPv4CIDR, isTrue, reason: 'Should be valid CIDR: $cidr');
      }
    });

    test('returns false for invalid IPv4 CIDR notation', () {
      const invalid = <String>[
        '192.168.1.0',
        '192.168.1.0/33',
        '192.168.1.0/-1',
        '256.0.0.1/24',
        '192.168.1/24',
        '192.168.1.1.1/24',
        'a.b.c.d/24',
        '192.168.1.0/24/8',
        '',
      ];

      for (final cidr in invalid) {
        expect(cidr.isValidIPv4CIDR, isFalse, reason: 'Should be invalid CIDR: $cidr');
      }
    });
  });

  group('StringExtensions.isValidIPv6', () {
    test('returns true for valid IPv6 addresses', () {
      const valid = <String>[
        '::',
        '::1',
        '  ::1  ',
        '2001:db8::1',
        '2001:db8:85a3::8a2e:370:7334',
        '2001:0db8:0000:0000:0000:ff00:0042:8329',
        '1:2:3:4:5:6:7:8',
        '2001:db8:0:1:1:1:1:1',
      ];

      for (final address in valid) {
        expect(address.isValidIPv6, isTrue, reason: 'Should be valid: $address');
      }
    });

    test('returns false for invalid IPv6 addresses', () {
      const invalid = <String>[
        '2001:db8:::1',
        '2001:db8::g1',
        '12345::',
        '1:2:3:4:5:6:7:8:9',
        ':1:2:3:4:5:6:7',
        '2001:db8::1::',
        'fe80::1%eth0',
        '::ffff:192.0.2.128',
        '',
      ];

      for (final address in invalid) {
        expect(address.isValidIPv6, isFalse, reason: 'Should be invalid: $address');
      }
    });
  });

  group('StringExtensions.isValidIPv6CIDR', () {
    test('returns true for valid IPv6 CIDR notation', () {
      const valid = <String>[
        '::/0',
        '::1/128',
        ' ::1/128 ',
        '::ffff:0:0/96',
        'fe80::/10',
        'ff00::/8',
        '2001:0db8:0000:0000:0000:0000:0000:0001/32',
        '2001:0DB8:0000:0000:0000:0000:0000:0001/32',
      ];

      for (final cidr in valid) {
        expect(cidr.isValidIPv6CIDR, isTrue, reason: 'Should be valid CIDR: $cidr');
      }
    });

    test('returns false for invalid IPv6 CIDR notation', () {
      const invalid = <String>[
        '2001:db8::1',
        '2001:db8::1/129',
        '2001:db8::1/-1',
        '2001:db8:::1/64',
        '2001:db8::g1/64',
        'hello/64',
        '',
      ];

      for (final cidr in invalid) {
        expect(cidr.isValidIPv6CIDR, isFalse, reason: 'Should be invalid CIDR: $cidr');
      }
    });
  });

  group('StringExtensions.IPv4 mapped forms', () {
    test('detects obsolete IPv4-mapped form', () {
      expect('::192.168.10.20'.isObsoleteIPV4Mapped, isTrue);
      expect('  ::10.0.0.1  '.isObsoleteIPV4Mapped, isTrue);
    });

    test('returns false for non-obsolete or malformed obsolete forms', () {
      expect('::ffff:192.168.10.20'.isObsoleteIPV4Mapped, isFalse);
      expect('::300.1.1.1'.isObsoleteIPV4Mapped, isFalse);
      expect('192.168.10.20'.isObsoleteIPV4Mapped, isFalse);
    });

    test('detects valid IPv4-mapped form', () {
      expect('0000:0000:0000:0000:0000:FFFF:192.168.10.20'.isValidMappedIPv4, isTrue);
    });

    test('returns false for obsolete or malformed mapped forms', () {
      const invalidMapped = <String>[
        '::192.168.10.20',
        '::ffff:300.1.1.1',
        '0000:0000:0000:0000:0000:FFFE:192.168.10.20',
        'hello',
      ];

      for (final address in invalidMapped) {
        expect(address.isValidMappedIPv4, isFalse, reason: 'Should be invalid mapped: $address');
      }
    });
  });

  group('StringExtensions.isValidMACAddress', () {
    test('returns true for valid classic MAC formats (Windows/Linux)', () {
      const validClassic = <String>['AA:BB:CC:DD:EE:FF', 'aa:bb:cc:dd:ee:ff', 'AA-BB-CC-DD-EE-FF', 'aa-bb-cc-dd-ee-ff'];

      for (final mac in validClassic) {
        expect(mac.isValidMACAddress, isTrue, reason: 'Should be valid classic MAC: $mac');
      }
    });

    test('returns true for valid Cisco and raw MAC formats', () {
      const validCiscoAndRaw = <String>[
        'aabb.ccdd.eeff',
        'AABB.CCDD.EEFF',
        'aabbccddeeff',
        'AABBCCDDEEFF',
        '  AA:BB:CC:DD:EE:FF  ',
      ];

      for (final mac in validCiscoAndRaw) {
        expect(mac.isValidMACAddress, isTrue, reason: 'Should be valid Cisco/raw MAC: $mac');
      }
    });

    test('returns false for invalid MAC strings', () {
      const invalid = <String>[
        '',
        '  ',
        'AA:BB:CC:DD:EE',
        'AA:BB:CC:DD:EE:FF:11',
        'AA:BB:CC:DD:EE:FG',
        'AA-BB:CC-DD:EE-FF',
        'AA-BB-CC-DD-EE-FF-',
        '.AABB.CCDD.EEFF',
        'AABB.CCDD.EEF',
        'AABB.CCDD.EEFF.0011',
        'AABBCCDDEEF',
        'AABBCCDDEEFF11',
      ];

      for (final mac in invalid) {
        expect(mac.isValidMACAddress, isFalse, reason: 'Should be invalid MAC: $mac');
      }
    });
  });

  group('StringExtensions.removeLastChar', () {
    test('removes last character', () {
      expect('123456'.removeLastChar, "12345");
      expect('abc'.removeLastChar, "ab");
      expect('a'.removeLastChar, "");
    });
  });

  group('StringExtensions.roundString', () {
    test('rounds a String reprensenting a number', () {
      expect('123456'.roundString(limit: 5), "123,456");
      expect('123.456'.roundString(limit: 2), "≈ 123.46");
      expect('1234.499999'.roundString(limit: 0), "≈ 1,234");
      expect('1234.54'.roundString(limit: 1), "≈ 1,234.5");
      expect('1234.56'.roundString(limit: 5), "1,234.56");
    });
  });

  group('StringExtensions.containsOperator', () {
    test('recognizes x as an operator', () {
      expect('12 x 3'.containsOperator, isTrue);
      expect('12 + 3'.containsOperator, isTrue);
      expect('123'.containsOperator, isFalse);
    });
  });

  group('StringExtensions.formatRound', () {
    test('rounds a String reprensenting a number', () {
      expect('123456'.formatRound(limit: 5), "123,456");
      expect('10,123.456'.formatRound(limit: 2), "≈ 10,123.46");
    });
  });

  group('StringExtensions.isANumber', () {
    test('tests if a String is a number', () {
      expect('123456'.isANumber, true);
      expect('10,123.456'.isANumber, false);
      expect('e1a'.isANumber, false);
    });
  });

  group('StringExtensions.isNotANumber', () {
    test('tests if a String is a number', () {
      expect('123456'.isNotANumber, false);
      expect('a'.isNotANumber, true);
    });
  });

  group('StringExtensions.isADouble', () {
    test('tests if a String is a double', () {
      expect('123456'.isADouble, false);
      expect('123456.0'.isADouble, false);
      expect('10,123.456'.toCleanMathString.isADouble, true);
    });
  });

  group('StringExtensions.scientific display', () {
    test('conversion into scientific display', () {
      expect('1234.000010000'.scientificDisplay, '1234.00001');
      expect('1234000010000'.scientificDisplay, '1.234000010e+12');
      expect('1234.000100005'.scientificDisplay, '1234.0001');
    });
  });
}
