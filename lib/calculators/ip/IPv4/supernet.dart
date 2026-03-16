import 'address.dart';
import 'relation.dart';

class Supernet extends Address {
  String addressTemp;

  Supernet(this.addressTemp) : super(addressTemp, "supernet");

  /// Applies [Address.regexpProcess] to every address in the list
  static List<String> regexpList(List<String> listToProcess) {
    for (int i = 0; i < listToProcess.length; i++) {
      listToProcess[i] = Address.regexpProcess(listToProcess[i]);
    }
    return listToProcess;
  }

  /// Tests if 2 addresses are colliding each other or not and returns the result
  static String testOfIntersections(
    List<String> bottomAddressA,
    List<String> topAddressA,
    List<String> bottomAddressB,
    List<String> topAddressB,
  ) {
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
            print(bottomAddressA);
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
            return "outside";
        }
    }
    return "Erreur de test des ensembles.";
  }

  /// Tests if an address A is higher or lower than an address B
  /// For IPV4 and IPV6 (TODO: test)
  static String testPosition(List<String> listA, List<String> listB, {String IPVersion = "4"}) {
    int numberOfLoops = IPVersion == "4" ? 4 : 8;
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
    int duplicates;
    for (int i = 0; i < listToProcess.length; i++) {
      duplicates = 1;
      for (int j = i + 1; j < listToProcess.length; j++) {
        if (listToProcess[i] == listToProcess[j]) {
          duplicates++;
          listToProcess.removeAt(j);
          j--;
        }
      }
      if (duplicates > 1) {
        print(
          "Warning ! Duplicate IP range detected : ${listToProcess[i]} is duplicated $duplicates times - removed duplicates",
        );
      }
    }
    print(listToProcess);
    return listToProcess;
  }

  /// Tests if all networks in a sorted list are contiguous
  static bool isAListOfContiguousAddresses(List<Address> list) {
    for (int i = 0; i < list.length - 1; i++) {
      if (int.parse(list[i].addressBroadcastStringBinary, radix: 2) !=
          int.parse(list[i + 1].addressNetworkStringBinary, radix: 2) - 1) {
        return false;
      }
    }
    return true;
  }
}
