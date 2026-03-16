import 'dart:async';

import 'package:calculators/calculators/ip/IPv6/supernetIPv6.dart';
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

  group('SupernetIPv6.computeRelations', () {
    test('detects contiguous adjacent /32 networks', () {
      final a = SupernetIPv6('2001:db8::/32');
      final b = SupernetIPv6('2001:db9::/32');

      expect(SupernetIPv6.computeRelations([a, b]).first.relationAB, 'contiguous');
    });

    test('detects outside networks when a gap exists', () {
      final a = SupernetIPv6('2001:db8::/32');
      final b = SupernetIPv6('2001:dba::/32');

      expect(SupernetIPv6.computeRelations([a, b]).first.relationAB, 'outside');
    });

    test('detects B_inside_A when outer network contains the inner', () {
      final outer = SupernetIPv6('2001:db8::/32');
      final inner = SupernetIPv6('2001:db8::/33');

      expect(SupernetIPv6.computeRelations([outer, inner]).first.relationAB, 'B_inside_A');
    });

    test('detects A_inside_B when inner comes before outer in sorted list', () {
      final inner = SupernetIPv6('2001:db8::/33');
      final outer = SupernetIPv6('2001:db8::/32');

      expect(SupernetIPv6.computeRelations([inner, outer]).first.relationAB, 'A_inside_B');
    });

    test('returns multiple relations for a 3-network list', () {
      final a = SupernetIPv6('2001:db8::/32');
      final b = SupernetIPv6('2001:db9::/32');
      final c = SupernetIPv6('2001:dba::/32');

      final relations = SupernetIPv6.computeRelations([a, b, c]);

      expect(relations.length, 2);
      expect(relations[0].relationAB, 'contiguous');
      expect(relations[1].relationAB, 'contiguous');
    });
  });

  group('SupernetIPv6.sameLists', () {
    test('returns true for two identical expanded address lists', () {
      expect(
        SupernetIPv6.sameLists(
          ['2001', '0DB8', '0000', '0000', '0000', '0000', '0000', '0000', '32'],
          ['2001', '0DB8', '0000', '0000', '0000', '0000', '0000', '0000', '32'],
        ),
        isTrue,
      );
    });

    test('returns false for two different address lists', () {
      expect(
        SupernetIPv6.sameLists(
          ['2001', '0DB8', '0000', '0000', '0000', '0000', '0000', '0000', '32'],
          ['2001', '0DB9', '0000', '0000', '0000', '0000', '0000', '0000', '32'],
        ),
        isFalse,
      );
    });
  });

  group('SupernetIPv6 utility flow', () {
    test('removes duplicate expanded addresses using sameLists', () {
      final list = [
        SupernetIPv6('2001:db8::/32'),
        SupernetIPv6('2001:0db8::/32'), // same network, different notation
        SupernetIPv6('2001:db9::/32'),
      ];

      final deduped = _removeDuplicates(list);

      expect(deduped.length, 2);
    });
  });
}

// ------------------------------------------------------------------
// Helpers
// ------------------------------------------------------------------

List<SupernetIPv6> _removeDuplicates(List<SupernetIPv6> input) {
  final result = List<SupernetIPv6>.from(input);
  for (int i = 0; i < result.length; i++) {
    for (int j = i + 1; j < result.length; j++) {
      if (SupernetIPv6.sameLists(result[i].address6ListString, result[j].address6ListString)) {
        result.removeAt(j);
        j--;
      }
    }
  }
  return result;
}
