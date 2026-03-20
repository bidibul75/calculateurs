import 'package:calculators/utils/extensions/string_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtensions.isValidIPv6', () {
    test('returns true for valid IPv6 addresses', () {
      const valid = <String>[
        '::',
        '::1',
        '2001:db8::1',
        '2001:db8:85a3::8a2e:370:7334',
        '2001:0db8:0000:0000:0000:ff00:0042:8329',
        '1:2:3:4:5:6:7:8',
      ];

      for (final address in valid) {
        expect(address.isValidIPv6, isTrue, reason: 'Should be valid: $address');
      }
    });

    test('returns false for invalid IPv6 addresses', () {
      const invalid = <String>['2001:db8:::1', '2001:db8::g1', '12345::', '1:2:3:4:5:6:7:8:9', ':1:2:3:4:5:6:7', ''];

      for (final address in invalid) {
        expect(address.isValidIPv6, isFalse, reason: 'Should be invalid: $address');
      }
    });
  });

  group('StringExtensions.isValidMACAddress', () {
    test('returns true for valid classic MAC formats (Windows/Linux)', () {
      const validClassic = <String>[
        'AA:BB:CC:DD:EE:FF',
        'aa:bb:cc:dd:ee:ff',
        'AA-BB-CC-DD-EE-FF',
        'aa-bb-cc-dd-ee-ff',
      ];

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
        'AA:BB:CC:DD:EE',
        'AA:BB:CC:DD:EE:FF:11',
        'AA:BB:CC:DD:EE:FG',
        'AA-BB:CC-DD:EE-FF',
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
}
