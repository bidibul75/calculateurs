import 'package:calculators/calculators/ip/IPv4/address.dart';
import 'package:calculators/utils/my_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Address', () {
    test('calculates IPv4 /22 network details correctly', () {
      final address = Address('90.16.84.82/22', 'address');

      expect(address.suffix, 22);
      expect(address.mask, '255.255.252.0');
      expect(address.wildcardMask, '0.0.3.255');
      expect(address.addressNetwork, '90.16.84.0');
      expect(address.addressBroadcast, '90.16.87.255');
      expect(address.addressAvailableFirstOne, ['90', '16', '84', '1']);
      expect(address.addressAvailableLastOne, ['90', '16', '87', '254']);
      expect(address.numberAvailableAddresses, 1024);
    });

    test('keeps a single available address for /32', () {
      final address = Address('192.168.1.42/32', 'address');

      expect(address.addressNetwork, '192.168.1.42');
      expect(address.addressBroadcast, '192.168.1.42');
      expect(address.numberAvailableAddresses, 1);
      expect(address.addressAvailableFirstOne, ['192', '168', '1', '42']);
      expect(address.addressAvailableLastOne, ['192', '168', '1', '42']);
    });

    test('counts total addresses correctly for very large ranges', () {
      final slash0 = Address('0.0.0.0/0', 'address');
      final slash1 = Address('0.0.0.0/1', 'address');
      final slash8 = Address('10.0.0.0/8', 'address');
      final slash31 = Address('10.0.0.0/31', 'address');

      expect(slash0.numberAvailableAddresses, 4294967296);
      expect(slash1.numberAvailableAddresses, 2147483648);
      expect(slash8.numberAvailableAddresses, 16777216);
      expect(slash31.numberAvailableAddresses, 2);
    });

    test('computes /0 bounds correctly', () {
      final address = Address('123.45.67.89/0', 'address');

      expect(address.addressNetwork, '0.0.0.0');
      expect(address.addressBroadcast, '255.255.255.255');
    });

    test('computes usable host count with /31 and /32 edge rules', () {
      final slash24 = Address('192.168.1.42/24', 'address');
      final slash31 = Address('10.0.0.0/31', 'address');
      final slash32 = Address('10.0.0.1/32', 'address');
      final slash0 = Address('0.0.0.0/0', 'address');

      expect(slash24.numberUsableAddresses, 254);
      expect(slash31.numberUsableAddresses, 2);
      expect(slash32.numberUsableAddresses, 1);
      expect(slash0.numberUsableAddresses, 4294967294);
    });
  });

  group('Address helpers', () {
    test('regexpProcess removes spaces and keeps a valid CIDR', () {
      expect(Address.regexpProcess(' 192.168.1.0 /24 '), '192.168.1.0/24');
      expect(Address.regexpProcess('  0.0.0.0/0  '), '0.0.0.0/0');
      expect(Address.regexpProcess('255.255.255.255/32'), '255.255.255.255/32');
    });

    test('stringToListStrings splits address and suffix', () {
      expect(Address.stringToListStrings('10.20.30.40/16'), ['10', '20', '30', '40', '16']);
    });

    test('listStringsDecimalToStringBinary converts octets to 32-bit binary string', () {
      final result = Address.listStringsDecimalToStringBinary(['192', '168', '1', '5']);
      expect(result, '11000000101010000000000100000101');
    });

    test('stringBinaryToStringDecimalDots converts 32-bit binary to dotted decimal', () {
      const binary = '11000000101010000000000100000101';
      expect(stringBinaryToStringDecimalDots(binary), '192.168.1.5');
    });

    test('addressShift increments and decrements with carry/borrow', () {
      expect(Address.addressShift(['10', '0', '0', '255'], 1), ['10', '0', '1', '0']);
      expect(Address.addressShift(['10', '0', '1', '0'], -1), ['10', '0', '0', '255']);
      expect(Address.addressShift(['10', '0', '0', '0'], -1), ['9', '255', '255', '255']);
    });

    test('regexpProcess throws for invalid CIDR format', () {
      expect(() => Address.regexpProcess('192.168.1/24'), throwsA(isA<MyException>()));
      expect(() => Address.regexpProcess('192.168.1.1'), throwsA(isA<MyException>()));
      expect(() => Address.regexpProcess('192,168,1,1/24'), throwsA(isA<MyException>()));
      expect(() => Address.regexpProcess('/24'), throwsA(isA<MyException>()));
    });

    test('Address throws for suffix out of range', () {
      expect(() => Address('10.0.0.1/33', 'address'), throwsA(isA<MyException>()));
    });

    test('Address throws for octet out of range', () {
      expect(() => Address('256.1.1.1/24', 'address'), throwsA(isA<MyException>()));
    });

    test('regexpProcess throws for too-long input', () {
      expect(() => Address.regexpProcess('123.123.123.123/1234'), throwsA(isA<MyException>()));
    });

    test('MyException keeps a readable message', () {
      try {
        Address.regexpProcess('bad');
        fail('Expected MyException');
      } on MyException catch (e) {
        expect(e.toString(), isNotEmpty);
        expect(e.toString(), contains('bad'));
      }
    });
  });
}
