import 'package:calculators/calculators/ip/IPv4/relation.dart';
import 'package:collection/collection.dart';

import 'address_ipv6.dart';

class SupernetIPv6 extends AddressIPV6 {
  String address6Temp;

  SupernetIPv6(this.address6Temp) : super(address6Temp);

  /// Sorts a list of List<Address>
  static void sortAddress6List(List<AddressIPV6> list) {
    list.sort((a, b) => a.address6BinaryString.compareTo(b.address6BinaryString));
  }

  /// Returns true if two expanded IPv6 address lists represent the same network
  static bool sameLists(List<String> a, List<String> b) => const ListEquality<String>().equals(a, b);

  /// Computes pairwise relations between consecutive networks in a sorted list.
  /// The list MUST BE SORTED (by [AddressIPV6.address6BinaryString]) before calling.
  /// Returns a [Relation] for each consecutive pair.
  static List<Relation> computeRelations(List<SupernetIPv6> list) {
    sortAddress6List(list);
    final relations = <Relation>[];
    for (int i = 0; i < (list.length - 1); i++) {
      final netA = list[i];
      final netB = list[i + 1];
      final startA = BigInt.parse(netA.address6BinaryString, radix: 2);
      final startB = BigInt.parse(netB.address6BinaryString, radix: 2);
      final endA = startA + netA.numberOfAddresses - BigInt.one;
      final endB = startB + netB.numberOfAddresses - BigInt.one;

      if (startA == startB) {
        relations.add(
          Relation.implementationObjetRelation(
            netA.address6,
            endA <= endB ? "A_inside_B" : "B_inside_A",
            netB.address6,
          ),
        );
      } else if (endA > startB) {
        relations.add(
          Relation.implementationObjetRelation(netA.address6, endA > endB ? "B_inside_A" : "overlap", netB.address6),
        );
      } else if (endA == startB - BigInt.one) {
        relations.add(Relation.implementationObjetRelation(netA.address6, "contiguous", netB.address6));
      } else {
        relations.add(Relation.implementationObjetRelation(netA.address6, "outside", netB.address6));
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
