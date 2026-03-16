import 'package:calculators/calculators/ip/IPv4/relation.dart';
import 'package:collection/collection.dart';

import 'addressIPV6.dart';

void supernetIPv6() {
  List<String> addresses6List = ["2001:db8::/32", "2001:db9::/32"];

  // "2001:db8::1234:1:2:3/64",
  // "2001:db8::1234:0:2:3/64",
  // "2001:db8:0:0:1234:1:2:3/64",
  // "2001:db8:0:0:1234:1:2:3/64",
  //

  List<SupernetIPv6> addresses6ListObjects = [];
  List<Relation> relationsIPv6 = [];
  int count;

  SupernetIPv6 implementationObjectSupernetIPv6(String address) {
    return SupernetIPv6(address);
  }

  /// Tests equality between two addresses
  bool sameLists(List<String> a, List<String> b) => const ListEquality<String>().equals(a, b);

  /// Tests if addresses are contiguous
  /// The list MUST BE SORTED for correct relations evaluation
  void addressesIPv6Relations(List<SupernetIPv6> list) {
    for (int i = 0; i < (list.length - 1); i++) {
      SupernetIPv6 netA = list[i];
      SupernetIPv6 netB = list[i + 1];
      BigInt startA = BigInt.parse(netA.address6BinaryString, radix: 2);
      BigInt startB = BigInt.parse(netB.address6BinaryString, radix: 2);
      BigInt sizeA = netA.numberOfAddresses;
      BigInt sizeB = netB.numberOfAddresses;
      BigInt endA = startA + sizeA - BigInt.one;
      BigInt endB = startB + sizeB - BigInt.one;

      if (startA == startB) {
        if (endA <= endB) {
          relationsIPv6.add(Relation.implementationObjetRelation(netA.address6, "A_inside_B", netB.address6));
        } else {
          relationsIPv6.add(Relation.implementationObjetRelation(netA.address6, "B_inside_A", netB.address6));
        }
      } else if (endA > startB) {
        if (endA > endB) {
          relationsIPv6.add(Relation.implementationObjetRelation(netA.address6, "B_inside_A", netB.address6));
        } else {
          relationsIPv6.add(Relation.implementationObjetRelation(netA.address6, "overlap", netB.address6));
        }
      } else if (endA == startB - BigInt.one) {
        relationsIPv6.add(Relation.implementationObjetRelation(netA.address6, "contiguous", netB.address6));
      } else {
        relationsIPv6.add(Relation.implementationObjetRelation(netA.address6, "outside", netB.address6));
      }
    }
  }

  for (String string in addresses6List) {
    addresses6ListObjects.add(implementationObjectSupernetIPv6(string));
  }
  print("supernet 6");
  print(addresses6ListObjects[0].address6ListString);
  print(addresses6ListObjects[1].address6ListString);

  // Removes duplicate addresses in list
  for (int i = 0; i < addresses6ListObjects.length; i++) {
    count = 0;
    for (int j = i + 1; j < addresses6ListObjects.length; j++) {
      if (sameLists(addresses6ListObjects[i].address6ListString, addresses6ListObjects[j].address6ListString)) {
        addresses6ListObjects.removeAt(j);
        j--;
        count++;
      }
    }
    if (count > 0) {
      print("Warning : ${addresses6ListObjects[i].address6} is duplicated $count time${count > 1 ? "s" : ""}.");
    }
  }

  // Sorts the list of objects : binary sort guarantees numeric order
  addresses6ListObjects.sort((a, b) => a.address6BinaryString.compareTo(b.address6BinaryString));
  print(addresses6ListObjects.map((obj) => obj.address6).toList());

  addressesIPv6Relations(addresses6ListObjects);

  bool everyNetworkIsContiguous = relationsIPv6.every((r) => r.relationAB == "contiguous");

  if (everyNetworkIsContiguous) {
    print("Good news ! All networks are contiguous.");

  } else {
    print("Beware ! some networks are not contiguous !!!");
  }
}

class SupernetIPv6 extends AddressIPV6 {
  String address6Temp;

  SupernetIPv6(this.address6Temp) : super(address6Temp);
}
