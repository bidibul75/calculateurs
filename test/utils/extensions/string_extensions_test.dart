import 'package:calculators/utils/extensions/string_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtensions.isValidIPv4', () {
    test('returns true for valid IPv4 addresses', () {
      const valid = <String>[
        '0.0.0.0',
        '255.255.255.255',
        '192.168.1.1',
        ' 10.0.0.1 ',
      ];

      for (final address in valid) {
        expect(address.isValidIPv4, isTrue, reason: 'Should be valid: $address');
      }
    });

    test('returns false for invalid IPv4 addresses', () {
      const invalid = <String>[
        '256.0.0.1',
        '192.168.1',
        '192.168.1.1.1',
        '192.168.01.1',
        'a.b.c.d',
        '',
      ];

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
      expect(
        '0000:0000:0000:0000:0000:FFFF:192.168.10.20'.isValidMappedIPv4,
        isTrue,
      );
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
}
