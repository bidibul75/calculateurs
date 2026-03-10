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
      const invalid = <String>[
        '2001:db8:::1',
        '2001:db8::g1',
        '12345::',
        '1:2:3:4:5:6:7:8:9',
        ':1:2:3:4:5:6:7',
        '',
      ];

      for (final address in invalid) {
        expect(address.isValidIPv6, isFalse, reason: 'Should be invalid: $address');
      }
    });
  });
}

