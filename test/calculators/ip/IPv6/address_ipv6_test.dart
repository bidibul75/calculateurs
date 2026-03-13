import 'package:calculators/calculators/ip/IPv6/addressIPV6.dart';
import 'package:calculators/utils/i18n/local_number_symbols.dart';
import 'package:calculators/utils/my_exception.dart';
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

  group('IPv6 helpers', () {
    test('cleanAddressIPV6 uppercases and pads each hextet to 4 chars', () {
      final result = cleanAddressIPV6(['db8', '1', '00af', 'abcd']);

      expect(result, ['0DB8', '0001', '00AF', 'ABCD']);
    });

    test('isValidIPv6Suffix accepts only values from 0 to 128', () {
      expect(isValidIPv6Suffix('0'), isTrue);
      expect(isValidIPv6Suffix('64'), isTrue);
      expect(isValidIPv6Suffix('128'), isTrue);

      expect(isValidIPv6Suffix('-1'), isFalse);
      expect(isValidIPv6Suffix('129'), isFalse);
      expect(isValidIPv6Suffix('abc'), isFalse);
      expect(isValidIPv6Suffix(''), isFalse);
    });

    test('formatIPV6WithoutSuffix expands special shorthand addresses', () {
      final ipv6 = AddressIPV6('::1/128');

      expect(
        ipv6.formatIPV6WithoutSuffix('::'),
        ['0000', '0000', '0000', '0000', '0000', '0000', '0000', '0000'],
      );
      expect(
        ipv6.formatIPV6WithoutSuffix('::1'),
        ['0000', '0000', '0000', '0000', '0000', '0000', '0000', '0001'],
      );
    });

    test('formatIPV6WithoutSuffix expands condensed addresses in the middle', () {
      final ipv6 = AddressIPV6('2001:db8::1234:1:2:3/64');

      expect(
        ipv6.formatIPV6WithoutSuffix('2001:db8::1234:1:2:3'),
        ['2001', '0DB8', '0000', '0000', '1234', '0001', '0002', '0003'],
      );
    });

    test('hexListToBinaryString returns 128 bits and ignores an optional suffix item', () {
      final ipv6 = AddressIPV6('::1/128');
      final addressWithSuffix = ['2001', '0DB8', '0000', '0000', '1234', '0001', '0002', '0003', '64'];

      final binary = ipv6.hexListToBinaryString(List<String>.from(addressWithSuffix));

      expect(binary.length, 128);
      expect(binary.startsWith('0010000000000001'), isTrue);
      expect(binary.endsWith('0000000000000011'), isTrue);
    });

    test('hexListToBinaryString does not mutate the input list', () {
      final ipv6 = AddressIPV6('::1/128');
      final addressWithSuffix = ['2001', '0DB8', '0000', '0000', '1234', '0001', '0002', '0003', '64'];

      ipv6.hexListToBinaryString(addressWithSuffix);

      expect(addressWithSuffix, ['2001', '0DB8', '0000', '0000', '1234', '0001', '0002', '0003', '64']);
    });

    test('address6BinaryStringToListString converts a 128-bit binary string back to hextets', () {
      final ipv6 = AddressIPV6('::1/128');
      final binary =
          '0010000000000001000011011011100000000000000000000000000000000000'
          '0001001000110100000000000000000100000000000000100000000000000011';

      expect(
        ipv6.address6BinaryStringToListString(binary),
        ['2001', '0db8', '0000', '0000', '1234', '0001', '0002', '0003'],
      );
    });
  });

  group('AddressIPV6', () {
    test('parses a valid CIDR IPv6 and computes derived values', () {
      final ipv6 = AddressIPV6('2001:db8::1234:1:2:3/64');

      expect(ipv6.addressWithoutSuffixString, '2001:db8::1234:1:2:3');
      expect(ipv6.suffix, '64');
      expect(ipv6.numberOfAddresses, '18,446,744,073,709,551,616');
      expect(
        ipv6.address6WithoutSuffixListString,
        ['2001', '0DB8', '0000', '0000', '1234', '0001', '0002', '0003'],
      );
      expect(
        ipv6.networkAdress6,
        ['2001', '0db8', '0000', '0000', '0000', '0000', '0000', '0000'],
      );
    });

    test('keeps the same address as network for a /128 host address', () {
      final ipv6 = AddressIPV6('::1/128');

      expect(ipv6.numberOfAddresses, '1');
      expect(
        ipv6.networkAdress6,
        ['0000', '0000', '0000', '0000', '0000', '0000', '0000', '0001'],
      );
    });

    test('keeps address6WithoutSuffixListString independent from address6ListString', () {
      final ipv6 = AddressIPV6('2001:db8::1234:1:2:3/64');

      expect(ipv6.address6WithoutSuffixListString.length, 8);
      expect(ipv6.address6ListString.length, 9);
      expect(ipv6.address6WithoutSuffixListString, isNot(same(ipv6.address6ListString)));
    });
  });

  group('AddressIPV6 invalid inputs', () {
    test('throws when the CIDR suffix separator is missing', () {
      expect(() => AddressIPV6('2001:db8::1'), throwsA(isA<MyException>()));
    });

    test('throws when the suffix is empty', () {
      expect(() => AddressIPV6('2001:db8::1/'), throwsA(isA<MyException>()));
    });

    test('throws when the suffix is greater than 128', () {
      expect(() => AddressIPV6('2001:db8::1/129'), throwsA(isA<MyException>()));
    });

    test('throws when the suffix is negative', () {
      expect(() => AddressIPV6('2001:db8::1/-1'), throwsA(isA<MyException>()));
    });

    test('throws when the suffix is not numeric', () {
      expect(() => AddressIPV6('2001:db8::1/abc'), throwsA(isA<MyException>()));
    });

    test('throws when the IPv6 address is invalid even with a valid suffix', () {
      expect(() => AddressIPV6('2001:db8:::1/64'), throwsA(isA<MyException>()));
      expect(() => AddressIPV6('gggg::1/64'), throwsA(isA<MyException>()));
    });

    test('throws when the IPv6 part is empty', () {
      expect(() => AddressIPV6('/64'), throwsA(isA<MyException>()));
    });

    test('throws when more than one slash is present', () {
      expect(() => AddressIPV6('2001:db8::1/64/extra'), throwsA(isA<MyException>()));
    });
  });
}

