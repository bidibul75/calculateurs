import 'package:calculators/calculators/ip/IPv4/relation.dart';
import 'package:calculators/calculators/ip/IPv4/supernet.dart' show DuplicateProcessResult;
import 'package:collection/collection.dart';

import 'address_ipv6.dart';

class SupernetIPv6 extends AddressIPV6 {
  String address6Temp;

  SupernetIPv6(this.address6Temp) : super(address6Temp);

  static String _normalizeCidr(String cidr) {
    return AddressIPV6.cidrSimplifier(cidr.replaceAll(' ', '').toUpperCase());
  }

  /// Sorts a list of List<Address>
  static void sortAddress6List(List<AddressIPV6> list) {
    final indexed = list.asMap().entries.toList();
    indexed.sort((a, b) {
      final binaryComparison = a.value.address6BinaryString.compareTo(b.value.address6BinaryString);
      if (binaryComparison != 0) {
        return binaryComparison;
      }
      return a.key.compareTo(b.key);
    });

    for (int i = 0; i < indexed.length; i++) {
      list[i] = indexed[i].value;
    }
  }

  /// Detects and removes duplicate IPv6 CIDR addresses.
  static DuplicateProcessResult processDuplicateAddresses(List<String> listToProcess) {
    return deduplicateAddresses(listToProcess);
  }

  /// Detects duplicates after normalizing CIDR notation.
  static DuplicateProcessResult deduplicateAddresses(List<String> listToProcess) {
    final unique = <String>[];
    final duplicateCounts = <String, int>{};

    for (final address in listToProcess) {
      final normalized = _normalizeCidr(address);
      if (unique.contains(normalized)) {
        duplicateCounts[normalized] = (duplicateCounts[normalized] ?? 1) + 1;
      } else {
        unique.add(normalized);
      }
    }

    return DuplicateProcessResult(uniqueAddresses: unique, duplicateCounts: duplicateCounts);
  }

  /// Tests if two IPv6 CIDR networks overlap, touch, or are separated.
  static String testOfIntersections(AddressIPV6 addressA, AddressIPV6 addressB) {
    final startA = BigInt.parse(addressA.address6BinaryString, radix: 2);
    final startB = BigInt.parse(addressB.address6BinaryString, radix: 2);
    final endA = startA + addressA.numberOfAddresses - BigInt.one;
    final endB = startB + addressB.numberOfAddresses - BigInt.one;

    if (startA == startB) {
      if (endA == endB) {
        return 'equal';
      }
      return endA < endB ? 'A_inside_B' : 'B_inside_A';
    }

    if (endA + BigInt.one == startB || endB + BigInt.one == startA) {
      return 'contiguous';
    }

    if (endA < startB || endB < startA) {
      return 'outside';
    }

    if (startA <= startB && endA >= endB) {
      return 'B_inside_A';
    }
    if (startB <= startA && endB >= endA) {
      return 'A_inside_B';
    }

    return 'overlap';
  }

  /// Tests if a list of IPv6 CIDR networks is contiguous.
  static bool isAListOfContiguousAddresses(List<AddressIPV6> list) {
    if (list.length < 2) {
      return true;
    }

    final sorted = List<AddressIPV6>.from(list);
    sortAddress6List(sorted);
    for (int i = 0; i < sorted.length - 1; i++) {
      final startA = BigInt.parse(sorted[i].address6BinaryString, radix: 2);
      final endA = startA + sorted[i].numberOfAddresses - BigInt.one;
      final startB = BigInt.parse(sorted[i + 1].address6BinaryString, radix: 2);
      if (endA + BigInt.one != startB) {
        return false;
      }
    }
    return true;
  }

  /// Returns true if two expanded IPv6 address lists represent the same network
  static bool sameLists(List<String> a, List<String> b) => const ListEquality<String>().equals(a, b);

  /// Computes pairwise relations between consecutive IPv6 CIDR networks in a sorted list.
  static List<Relation> computeRelations(List<SupernetIPv6> list) {
    sortAddress6List(list);
    final relations = <Relation>[];
    for (int i = 0; i < list.length - 1; i++) {
      relations.add(
        Relation(
          list[i].address6,
          testOfIntersections(list[i], list[i + 1]),
          list[i + 1].address6,
        ),
      );
    }
    return relations;
  }

  /// Calculates the supernet address with 2001:db8::/32 format
  static String supernetCalc(List<SupernetIPv6> list) {
    if (list.isEmpty) {
      throw ArgumentError('SupernetIPv6 list cannot be empty');
    }

    if (list.length == 1) {
      return '${list.first.networkAdress6.join(':')}/${list.first.suffix}';
    }

    final String firstBinary = list.first.address6BinaryString;
    int prefixLength = 0;
    for (int bitIndex = 0; bitIndex < 128; bitIndex++) {
      final String bit = firstBinary[bitIndex];
      if (list.every((s) => s.address6BinaryString[bitIndex] == bit)) {
        prefixLength++;
      } else {
        break;
      }
    }

    final List<String> addressListFormat = AddressIPV6.address6BinaryStringToListString(
      firstBinary.substring(0, prefixLength).padRight(128, '0'),
    );
    final String supernetHexResult = '${addressListFormat.join(':')}/$prefixLength';

    return supernetHexResult;
  }
}
