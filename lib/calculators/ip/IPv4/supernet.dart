// lib/calculators/ip/IPv4/supernet.dart
import 'address.dart';
import 'relation.dart';

class DuplicateProcessResult {
  final List<String> uniqueAddresses;
  final Map<String, int> duplicateCounts;

  const DuplicateProcessResult({required this.uniqueAddresses, required this.duplicateCounts});
}

class Supernet extends Address {
  String addressTemp;

  Supernet(this.addressTemp) : super(addressTemp);

  /// Applies [Address.regexpProcess] to every address in the list
  static List<String> regexpList(List<String> listToProcess) {
    for (int i = 0; i < listToProcess.length; i++) {
      listToProcess[i] = Address.regexpProcess(listToProcess[i]);
    }
    return listToProcess;
  }

  /// Tests if 2 addresses are colliding each other or not and returns the result
  static String testOfIntersections(Address addressA, Address addressB) {
    List<String> bottomAddressA = addressA.addressNetworkList;
    List<String> bottomAddressB = addressB.addressNetworkList;
    List<String> topAddressA = addressA.addressBroadcastList;
    List<String> topAddressB = addressB.addressBroadcastList;

    switch (testPosition(topAddressA, topAddressB)) {
      case "equal":
        switch (testPosition(bottomAddressA, bottomAddressB)) {
          case "equal":
            return "equal";
          case "higher":
            return "A_inside_B";
          case "lower":
            return "B_inside_A";
        }
        break;
      case "higher":
        switch (testPosition(bottomAddressA, topAddressB)) {
          case "equal":
            return "overlaps";
          case "higher":
            return "outside";
          case "lower":
            switch (testPosition(bottomAddressA, bottomAddressB)) {
              case "equal":
                return "B_inside_A";
              case "higher":
                return "overlaps";
              case "lower":
                return "B_inside_A";
            }
        }
        break;
      case "lower":
        switch (testPosition(topAddressA, bottomAddressB)) {
          case "equal":
            return "intersecting";
          case "higher":
            switch (testPosition(bottomAddressA, bottomAddressB)) {
              case "equal":
                return "A_inside_B";
              case "higher":
                return "A_inside_B";
              case "lower":
                return "intersecting";
            }
            break;
          case "lower":
            List<Address> list = [addressA, addressB];
            return isAListOfContiguousAddresses(list) ? "contiguous" : "outside";
        }
    }
    return "Erreur de test des ensembles.";
  }

  /// Tests if an address A is higher or lower than an address B
  /// For IPV4 and IPV6 (TODO: test)
  static String testPosition(List<String> listA, List<String> listB, {String iPVersion = "4"}) {
    int numberOfLoops = iPVersion == "4" ? 4 : 8;
    for (int i = 0; i < numberOfLoops; i++) {
      if (int.parse(listA[i]) > int.parse(listB[i])) return "higher";
      if (int.parse(listA[i]) < int.parse(listB[i])) return "lower";
    }
    return "equal";
  }

  /// Calculates the common supernet prefix.
  /// Beware! must receive more than one address.
  static String supernetCalculation(int addressCount, List<String> list, String supernetAddress) {
    if (addressCount == 1) throw StateError("supernetCalculation requires at least 2 addresses");
    for (int i = 0; i < 32; i++) {
      for (int addressNumber = 0; addressNumber < addressCount - 1; addressNumber++) {
        if (list[addressNumber][i] != list[addressNumber + 1][i]) {
          return supernetAddress;
        }
      }
      supernetAddress += list[0][i];
    }
    return supernetAddress;
  }

  /// Detects and removes duplicate addresses from the list
  static List<String> processDuplicateAddresses(List<String> listToProcess, List<Relation> relations) {
    return deduplicateAddresses(listToProcess).uniqueAddresses;
  }

  /// Detects duplicates and returns both the unique list and duplicate counters.
  static DuplicateProcessResult deduplicateAddresses(List<String> listToProcess) {
    final unique = List<String>.from(listToProcess);
    final duplicateCounts = <String, int>{};

    for (int i = 0; i < unique.length; i++) {
      int duplicates = 1;
      for (int j = i + 1; j < unique.length; j++) {
        if (unique[i] == unique[j]) {
          duplicates++;
          unique.removeAt(j);
          j--;
        }
      }
      if (duplicates > 1) {
        duplicateCounts[unique[i]] = duplicates;
      }
    }

    return DuplicateProcessResult(uniqueAddresses: unique, duplicateCounts: duplicateCounts);
  }

  /// Sorts a list of List<Address>
  static void sortAddressList(List<Address> list) {
    list.sort((a, b) => a.addressNetworkStringBinary.compareTo(b.addressNetworkStringBinary));
  }

  /// Tests if all networks in a sorted list are contiguous
  static bool isAListOfContiguousAddresses(List<Address> list) {
    sortAddressList(list);
    for (int i = 0; i < list.length - 1; i++) {
      if (int.parse(list[i].addressBroadcastStringBinary, radix: 2) !=
          int.parse(list[i + 1].addressNetworkStringBinary, radix: 2) - 1) {
        return false;
      }
    }
    return true;
  }

  /// Computes pairwise relations between all addresses in the list.
  static List<Relation> computeRelations(List<Address> list) {
    String testInter;
    sortAddressList(list);
    final relations = <Relation>[];
    for (int i = 0; i < list.length - 1; i++) {
      for (int j = i + 1; j < list.length; j++) {
        testInter = testOfIntersections(list[i], list[j]);
        if (testInter == "outside" && j != i + 1) continue;
        relations.add(
          Relation.implementationObjetRelation(list[i].addressToProcess, testInter, list[j].addressToProcess),
        );
      }
    }
    return relations;
  }
}
