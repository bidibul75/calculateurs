// lib/calculators/ip/IPv6/supernet_ipv6.dart
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

  static String _networkBinaryString(AddressIPV6 address) {
    final networkWithSuffix = <String>[...address.networkAdress6, address.suffix];
    return AddressIPV6.hexListToBinaryString(networkWithSuffix);
  }

  static ({BigInt start, BigInt end}) _cidrRange(AddressIPV6 address) {
    final start = BigInt.parse(_networkBinaryString(address), radix: 2);
    final end = start + address.numberOfAddresses - BigInt.one;
    return (start: start, end: end);
  }

  /// Sorts a list of List<Address>
  static void sortAddress6List(List<AddressIPV6> list) {
    final indexed = list.asMap().entries.toList();
    indexed.sort((a, b) {
      final binaryComparison =
          _networkBinaryString(a.value).compareTo(_networkBinaryString(b.value));
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
  static String testOfIntersectionsIPv6(AddressIPV6 addressA, AddressIPV6 addressB) {
    final rangeA = _cidrRange(addressA);
    final rangeB = _cidrRange(addressB);
    final startA = rangeA.start;
    final endA = rangeA.end;
    final startB = rangeB.start;
    final endB = rangeB.end;

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
      final rangeA = _cidrRange(sorted[i]);
      final rangeB = _cidrRange(sorted[i + 1]);
      if (rangeA.end + BigInt.one != rangeB.start) {
        return false;
      }
    }
    return true;
  }

  /// Returns true if two expanded IPv6 address lists represent the same network
  static bool sameLists(List<String> a, List<String> b) => const ListEquality<String>().equals(a, b);

  /// Computes pairwise relations between consecutive IPv6 CIDR networks in a sorted list.
  static List<Relation> computeRelations(List<SupernetIPv6> list) {
    String testInter;
    sortAddress6List(list);
    final relations = <Relation>[];
    for (int i = 0; i < list.length - 1; i++) {
      for (int j = i + 1; j < list.length; j++) {
        testInter = testOfIntersectionsIPv6(list[i], list[j]);
        if (testInter == "outside" && j != i + 1) continue;
        relations.add(Relation(list[i].address6, testInter, list[j].address6));
      }
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

    final binaries = list.map(_networkBinaryString).toList(growable: false);
    final String firstBinary = binaries.first;
    int prefixLength = 0;
    for (int bitIndex = 0; bitIndex < 128; bitIndex++) {
      final String bit = firstBinary[bitIndex];
      if (binaries.every((binary) => binary[bitIndex] == bit)) {
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
