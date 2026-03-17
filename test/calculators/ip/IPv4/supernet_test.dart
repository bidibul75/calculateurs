import 'package:calculators/calculators/ip/IPv4/address.dart';
import 'package:calculators/calculators/ip/IPv4/relation.dart';
import 'package:calculators/calculators/ip/IPv4/supernet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ------------------------------------------------------------------ //
  // isAListOfContiguousAddresses
  // ------------------------------------------------------------------ //
  group('Supernet.isAListOfContiguousAddresses', () {
    test('returns true for adjacent /24 networks', () {
      final addresses = _buildSortedSupernets(['192.168.1.0/24', '192.168.0.0/24']);
      expect(Supernet.isAListOfContiguousAddresses(addresses), isTrue);
    });

    test('returns false when a gap exists between networks', () {
      final addresses = _buildSortedSupernets(['192.168.0.0/24', '192.168.2.0/24']);
      expect(Supernet.isAListOfContiguousAddresses(addresses), isFalse);
    });

    test('returns true for contiguous host addresses (/32)', () {
      final addresses = _buildSortedSupernets(['10.0.0.1/32', '10.0.0.0/32']);
      expect(Supernet.isAListOfContiguousAddresses(addresses), isTrue);
    });

    test('returns true for a single address (trivially contiguous)', () {
      final addresses = _buildSortedSupernets(['172.16.0.0/16']);
      expect(Supernet.isAListOfContiguousAddresses(addresses), isTrue);
    });

    test('returns true for four contiguous /26 networks', () {
      // Sort is done on addressNetworkStringBinary (numeric) → correct order.
      final addresses = _buildSortedSupernets(['10.0.0.64/26', '10.0.0.128/26', '10.0.0.0/26', '10.0.0.192/26']);
      expect(Supernet.isAListOfContiguousAddresses(addresses), isTrue);
    });

    test('returns false for /26 networks with a gap in the middle', () {
      final addresses = _buildSortedSupernets([
        '10.0.0.0/26',
        '10.0.0.128/26', // gap: 10.0.0.64/26 is missing
      ]);
      expect(Supernet.isAListOfContiguousAddresses(addresses), isFalse);
    });
  });

  // ------------------------------------------------------------------ //
  // supernetCalculation
  // ------------------------------------------------------------------ //
  group('supernetCalculation', () {
    test('calculates a /23 for two contiguous /24 networks', () {
      expect(_calculateSupernet(['192.168.1.0/24', '192.168.0.0/24']), '192.168.0.0/23');
    });

    test('calculates the common covering supernet for non-contiguous /24 networks', () {
      expect(_calculateSupernet(['192.168.0.0/24', '192.168.2.0/24']), '192.168.0.0/22');
    });

    test('calculates a /22 for three contiguous /24 networks', () {
      expect(_calculateSupernet(['10.0.2.0/24', '10.0.0.0/24', '10.0.1.0/24']), '10.0.0.0/22');
    });

    test('calculates a /24 for four contiguous /26 networks', () {
      expect(_calculateSupernet(['10.0.0.64/26', '10.0.0.128/26', '10.0.0.0/26', '10.0.0.192/26']), '10.0.0.0/24');
    });

    test('calculates a /31 for two contiguous /32 host addresses', () {
      expect(_calculateSupernet(['10.0.0.1/32', '10.0.0.0/32']), '10.0.0.0/31');
    });

    test('single address: supernetCalculation throws a StateError', () {
      // supernetCalculation explicitly rejects a single address.
      // The caller must handle this case before calling the function.
      final addresses = _buildSortedSupernets(['172.16.0.0/16']);
      final binaries = addresses
          .map((a) => a.suffix == 32 ? a.addressOnlyString : a.addressNetworkStringBinary)
          .toList();
      expect(() => Supernet.supernetCalculation(addresses.length, binaries, ''), throwsA(isA<StateError>()));
    });

    test('addresses at the edge of the address space (high octets)', () {
      expect(_calculateSupernet(['255.255.254.0/24', '255.255.255.0/24']), '255.255.254.0/23');
    });
  });

  // ------------------------------------------------------------------ //
  // Duplicates and range inclusions
  // ------------------------------------------------------------------ //
  group('process_duplicate_addresses', () {
    test('removes exact duplicate addresses', () {
      final relations = <Relation>[];
      final result = Supernet.processDuplicateAddresses(
        Supernet.regexpList(['192.168.0.0/24', '192.168.0.0/24', '192.168.1.0/24']),
        relations,
      );
      // Only one copy of 192.168.0.0/24 should remain.
      expect(result.where((a) => a == '192.168.0.0/24').length, 1);
      expect(result.length, 2);
    });

    test('keeps a single address when all entries are duplicates', () {
      final relations = <Relation>[];
      final result = Supernet.processDuplicateAddresses(
        Supernet.regexpList([
          '10.0.0.0/8',
          '10.0.0.0/8',
          '10.0.0.0/8',
          '11.1.1.1/5',
          '10.0.0.0/8',
          '10.0.0.0/8',
          '192.168.0.0/24',
        ]),
        relations,
      );
      expect(result.length, 3);
    });

    // j-- edge case : without j--, after removeAt(j) the next element shifts
    // to index j, but j++ would skip it, leaving one duplicate behind.
    test('removes all duplicates when 3 consecutive identical addresses (j-- edge case)', () {
      final relations = <Relation>[];
      final result = Supernet.processDuplicateAddresses(
        Supernet.regexpList(['10.0.0.0/8', '10.0.0.0/8', '10.0.0.0/8']),
        relations,
      );
      expect(result.length, 1);
      expect(result.first, '10.0.0.0/8');
    });

    test('removes non-consecutive duplicates scattered in the list', () {
      final relations = <Relation>[];
      final result = Supernet.processDuplicateAddresses(
        Supernet.regexpList([
          '10.0.0.0/8',
          '192.168.0.0/24',
          '10.0.0.0/8', // duplicate of first, non-consecutive
          '172.16.0.0/16',
          '192.168.0.0/24', // duplicate of second, non-consecutive
        ]),
        relations,
      );
      expect(result.length, 3);
      expect(result.contains('10.0.0.0/8'), isTrue);
      expect(result.contains('192.168.0.0/24'), isTrue);
      expect(result.contains('172.16.0.0/16'), isTrue);
    });
  });

  // ------------------------------------------------------------------ //
  // testOfIntersections
  // ------------------------------------------------------------------ //
  group('Supernet.testOfIntersections (range relations)', () {
    List<String> networkList(String cidr) => Supernet(cidr).addressNetworkList;
    List<String> broadcastList(String cidr) => Supernet(cidr).addressBroadcastList;

    test('detects equal networks', () {
      expect(
        Supernet.testOfIntersections(
          networkList('10.0.0.0/24'),
          broadcastList('10.0.0.0/24'),
          networkList('10.0.0.0/24'),
          broadcastList('10.0.0.0/24'),
        ),
        'equal',
      );
    });

    test('detects A outside B (no overlap)', () {
      expect(
        Supernet.testOfIntersections(
          networkList('10.0.2.0/24'),
          broadcastList('10.0.2.0/24'),
          networkList('10.0.0.0/24'),
          broadcastList('10.0.0.0/24'),
        ),
        'outside',
      );
    });

    test('detects B inside A (A contains B)', () {
      expect(
        Supernet.testOfIntersections(
          networkList('10.0.0.0/22'),
          broadcastList('10.0.0.0/22'), // larger network A
          networkList('10.0.0.0/24'),
          broadcastList('10.0.0.0/24'), // smaller network B
        ),
        'B_inside_A',
      );
    });

    test('detects A inside B (B contains A)', () {
      expect(
        Supernet.testOfIntersections(
          networkList('10.0.0.0/24'),
          broadcastList('10.0.0.0/24'), // smaller network A
          networkList('10.0.0.0/22'),
          broadcastList('10.0.0.0/22'), // larger network B
        ),
        'A_inside_B',
      );
    });
  });
}

// ------------------------------------------------------------------ //
// Helpers
// ------------------------------------------------------------------ //

/// Builds a sorted list of [Supernet] objects from raw CIDR strings,
/// deduplicating entries first (mirroring the real app flow).
List<Supernet> _buildSortedSupernets(List<String> rawAddresses) {
  final normalized = Supernet.processDuplicateAddresses(
    Supernet.regexpList(List<String>.from(rawAddresses)),
    <Relation>[],
  );
  final addresses = normalized.map(Supernet.new).toList();
  // Sort on the binary representation of the network address (numeric order),
  // matching the sort used in supernet.dart.
  addresses.sort((a, b) => a.addressNetworkStringBinary.compareTo(b.addressNetworkStringBinary));
  return addresses;
}

/// Returns the supernet CIDR string for a list of raw CIDR addresses,
/// using the same pipeline as the real app (dedup → sort → calculate).
String _calculateSupernet(List<String> rawAddresses) {
  final addresses = _buildSortedSupernets(rawAddresses);
  final binaries = addresses.map((a) => a.suffix == 32 ? a.addressOnlyString : a.addressNetworkStringBinary).toList();
  final prefix = Supernet.supernetCalculation(addresses.length, binaries, '');
  final binarySupernet = prefix.padRight(32, '0');
  return '${stringBinaryToStringDecimalDots(binarySupernet)}/${prefix.length}';
}
