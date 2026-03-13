import 'adresse.dart';
import 'relation.dart';

void main() {
  List<String> addressesList = [" 192.168.1.0/24", " 192.168.0.0/24"], addressesListUniques = addressesList.sublist(0);
  String supernetAddress = "", result = "";
  List<Relation> relations = [];

  // Always normalize and deduplicate first.
  addressesListUniques = Supernet.regexpList(addressesListUniques);
  addressesListUniques = Supernet.processDuplicateAddresses(addressesListUniques, relations);

  if (addressesListUniques.length == 1) {
    supernetAddress = addressesListUniques[0];
  } else {
    List<Supernet> addressesObject = [], addressesObjectRelations = [];
    List<String> listToBeProcessed = [];
    List<String> bottomAddressA, topAddressA, bottomAddressB, topAddressB;

    int addressCount = addressesListUniques.length;
    int supernetAddressSuffix = 0;

    // Creates a list of objects
    for (String address in addressesListUniques) {
      addressesObject.add(implementationObjectSupernet(address));
    }

    // Sorts the list of objects : binary sort guarantees numeric order
    addressesObject.sort((a, b) => a.addressNetworkStringBinary.compareTo(b.addressNetworkStringBinary));
    print(addressesObject.map((obj) => obj.addressNetwork).toList());

    // Tests if there is a contiguity in all the addresses of the list
    if (Supernet.isAListOfContiguousAddresses(addressesObject)) {
      print("Good news ! All networks are contiguous.");
    } else {
      print("Beware ! some networks are not contiguous !!!");

      // Hard copy this list to use it for relations
      addressesObjectRelations = addressesObject.sublist(0);

      // Tests if there are duplicate addresses and if an address is inside another one
      for (int i = 0; i < addressesObjectRelations.length; i++) {
        for (int j = i + 1; j < addressesObjectRelations.length; j++) {
          bottomAddressA = addressesObjectRelations[i].addressNetworkList;
          topAddressA = addressesObjectRelations[i].addressBroadcastList;
          bottomAddressB = addressesObjectRelations[j].addressNetworkList;
          topAddressB = addressesObjectRelations[j].addressBroadcastList;
          result = Supernet.testOfIntersections(bottomAddressA, topAddressA, bottomAddressB, topAddressB);
          relations.add(
            implementationObjetRelation(
              addressesObject[i].addressToProcess,
              result,
              addressesObject[j].addressToProcess,
            ),
          );
        }
      }
    }

    // Creation of the list to submit to calculation of the supernet
    for (Supernet address in addressesObject) {
      if (address.suffix == 32) {
        listToBeProcessed.add(address.addressOnlyString);
      } else {
        listToBeProcessed.add(address.addressNetworkStringBinary);
      }
    }

    // Calculation of the supernet address
    supernetAddress = supernetCalculation(addressCount, listToBeProcessed, supernetAddress = "");
    supernetAddressSuffix = supernetAddress.length;
    print(addressCount);
    print("list to be processed : $listToBeProcessed");
    print(supernetAddress);
    print(supernetAddressSuffix);

    supernetAddress += "0" * (32 - supernetAddressSuffix);
    supernetAddress = "${stringBinaryToStringDecimalDots(supernetAddress)}/$supernetAddressSuffix";

    // Prints the relations object
    for (Relation relation in relations) {
      print("${relation.addressA} ${relation.relationAB} ${relation.addressB}");
    }
  }
  print("L'adresse supernet est : $supernetAddress");
}

// Building objects
Supernet implementationObjectSupernet(String address) {
  return Supernet(address);
}

Relation implementationObjetRelation(String addressA, String relationAB, String addressB) {
  return Relation(addressA, relationAB, addressB);
}

/// Calculates the supernet
/// Beware ! must be more than one address !
String supernetCalculation(int addressCount, List<String> list, String supernetAddress) {
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

class Supernet extends Adresse {
  String addressTemp;

  Supernet(this.addressTemp) : super(addressTemp, "supernet");

  static List<String> regexpList(List<String> listToProcess) {
    for (int i = 0; i < listToProcess.length; i++) {
      listToProcess[i] = regexpProcess(listToProcess[i]);
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
  static String testPosition(List<String> listA, List<String> listB) {
    for (int i = 0; i < 4; i++) {
      if (int.parse(listA[i]) > int.parse(listB[i])) return "higher";
      if (int.parse(listA[i]) < int.parse(listB[i])) return "lower";
    }
    return "equal";
  }

  /// Detects if there are duplicate addresses and removes them from the list
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

  /// Tests if the networks in a list are all contiguous or not
  static bool isAListOfContiguousAddresses(List<Adresse> list) {
    for (int i = 0; i < list.length - 1; i++) {
      if (int.parse(list[i].addressBroadcastStringBinary, radix: 2) !=
          int.parse(list[i + 1].addressNetworkStringBinary, radix: 2) - 1) {
        return false;
      }
    }
    return true;
  }
}
