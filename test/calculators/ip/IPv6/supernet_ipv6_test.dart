import 'dart:async';

import 'package:calculators/calculators/ip/IPv6/supernetIPv6.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupernetIPv6 core behavior', () {
    test('parses IPv6 CIDR and computes exact network size as BigInt', () {
      final net = SupernetIPv6('2001:db8::/64');

      expect(net.numberOfAddresses, BigInt.parse('18446744073709551616'));
      expect(net.networkAdress6, ['2001', '0db8', '0000', '0000', '0000', '0000', '0000', '0000']);
    });

    test('host /128 has a single address', () {
      final net = SupernetIPv6('2001:db8::1/128');

      expect(net.numberOfAddresses, BigInt.one);
      expect(net.networkAdress6, ['2001', '0db8', '0000', '0000', '0000', '0000', '0000', '0001']);
    });
  });

  group('SupernetIPv6 relation logic (same math as production)', () {
    test('detects contiguous adjacent /32 networks', () {
      final a = SupernetIPv6('2001:db8::/32');
      final b = SupernetIPv6('2001:db9::/32');

      expect(_relation(a, b), 'contiguous');
    });

    test('detects outside networks when a gap exists', () {
      final a = SupernetIPv6('2001:db8::/32');
      final b = SupernetIPv6('2001:dba::/32');

      expect(_relation(a, b), 'outside');
    });

    test('detects inclusion when one network contains the other', () {
      final outer = SupernetIPv6('2001:db8::/32');
      final inner = SupernetIPv6('2001:db8::/33');

      expect(_relation(outer, inner), 'B_inside_A');
      expect(_relation(inner, outer), 'A_inside_B');
    });
  });

  group('SupernetIPv6 utility flow', () {
    test('removes duplicate expanded addresses', () {
      final list = [
        SupernetIPv6('2001:db8::/32'),
        SupernetIPv6('2001:0db8::/32'),
        SupernetIPv6('2001:db9::/32'),
      ];

      final deduped = _removeDuplicatesByExpandedForm(list);

      expect(deduped.length, 2);
      expect(deduped.map((e) => e.address6).toList(), contains('2001:db9::/32'));
    });

    test('supernetIPv6 runs and reports contiguous default sample', () {
      final printed = <String>[];

      runZonedGuarded(
        supernetIPv6,
        (error, stack) => fail('supernetIPv6 threw an error: $error'),
        zoneSpecification: ZoneSpecification(
          print: (self, parent, zone, line) {
            printed.add(line);
          },
        ),
      );

      expect(printed.any((line) => line.contains('Good news ! All networks are contiguous.')), isTrue);
    });
  });
}

String _relation(SupernetIPv6 netA, SupernetIPv6 netB) {
  final startA = BigInt.parse(netA.address6BinaryString, radix: 2);
  final startB = BigInt.parse(netB.address6BinaryString, radix: 2);
  final endA = startA + netA.numberOfAddresses - BigInt.one;
  final endB = startB + netB.numberOfAddresses - BigInt.one;

  if (startA == startB) {
    return endA <= endB ? 'A_inside_B' : 'B_inside_A';
  }
  if (endA > startB) {
    return endA > endB ? 'B_inside_A' : 'overlap';
  }
  if (endA == startB - BigInt.one) {
    return 'contiguous';
  }
  return 'outside';
}

List<SupernetIPv6> _removeDuplicatesByExpandedForm(List<SupernetIPv6> input) {
  final result = List<SupernetIPv6>.from(input);
  const listEq = ListEquality<String>();

  for (int i = 0; i < result.length; i++) {
    for (int j = i + 1; j < result.length; j++) {
      if (listEq.equals(result[i].address6ListString, result[j].address6ListString)) {
        result.removeAt(j);
        j--;
      }
    }
  }

  return result;
}

