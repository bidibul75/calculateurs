import 'adresse.dart';
import 'relation.dart';

void main() {
  List<String> addresses_list = [
    "192.168.1.0/8",
    "192.168.2.0/24",
    "192.168.2.0/24",
    "192.168.4.0/24",
    "192.168.9.1/32"
  ];
  List<Supernet> addresses_object = [];
  List<String> list_to_be_processed = [], bottomAddress, topAddress;
  String supernetAddress = "", result = "", global_result = "";
  int addressCount = addresses_list.length, supernet_address_Suffix = 0;

  // Creates a list of objects
  for (int i = 0; i < addresses_list.length; i++) {
    addresses_object.add(implementation_object(addresses_list[i]));
  }

  // Tests on list items
  // Tests if there are duplicate addresses and
  // if an address is inside another one
  List<String> bottom_address_A, top_address_A, bottom_address_B, top_address_B  ;
  for (int i = 0; i < addresses_object.length; i++) {
    for (int j = 0; j < addresses_object.length; j++) {
      if (j == i) continue;

      bottom_address_A = addresses_object[i].address_network_list;
      top_address_A = addresses_object[i].address_broadcast_list;
      bottom_address_B = addresses_object[j].address_network_list;
      top_address_B = addresses_object[j].address_broadcast_list;
      result = Supernet.test_of_intersections(bottom_address_A, top_address_A, bottom_address_B, top_address_B);
      print("Result : $result");
        print(" Adresse A : bottom : " + bottom_address_A.toString() + " top : " + top_address_A.toString());
        print(" Adresse B : bottom : " + bottom_address_B.toString() + " top : " + top_address_B.toString());
        Relation relation = new Relation (addresses_object[i].address_to_process, addresses_object[j].address_to_process, result);
      }
    }


// Creation of the list to submit to calculation of the supernet
  for (int i = 0; i < addresses_object.length; i++) {
    if (addresses_object[i].suffix == 32) {
      list_to_be_processed.add(addresses_object[i].address_only_string);
    } else {
      list_to_be_processed.add(addresses_object[i].address_network_string_binary);
      list_to_be_processed
          .add(addresses_object[i].address_broadcast_string_binary);
    }
  }

  // Calculation of the supernet address
  supernetAddress =
      supernetCalculation(addressCount, list_to_be_processed, supernetAddress = "");
  supernet_address_Suffix = supernetAddress.length;
  supernetAddress += "0" * (32 - supernet_address_Suffix);
  supernetAddress = string_binary_to_string_decimal_dots(supernetAddress) +
      "/" +
      supernet_address_Suffix.toString();
  print("L'adresse supernet est : " + supernetAddress);
}

// Building objects
Supernet implementation_object(String address) {
  Supernet supernet = Supernet(address);
  return supernet;
}

String supernetCalculation(
    int addressCount, List<String> list, String supernetAddress) {
  for (int i = 0; i < 32; i++) {
    for (int addressNumber = 0;
        addressNumber < addressCount - 1;
        addressNumber++) {
      if (list[addressNumber][i] != list[addressNumber + 1][i])
        return supernetAddress;
    }
    supernetAddress += list[0][i];
  }
  return supernetAddress;
}

class Supernet extends Adresse {
  String address_temp;

  Supernet(this.address_temp) : super(address_temp) {}

 static String test_of_intersections(List<String> bottomAddressA, List<String> topAddressA, List<String> bottomAddressB, List<String> topAddressB) {

    switch (testPosition(topAddressA, topAddressB)){
      case "equal":
        switch (testPosition(bottomAddressA, bottomAddressB)){
          case "equal":
            return "equal";
          case "higher":
            return "A_inside_B";
          case "lower":
            return "B_inside_A";
        }
      case "higher":
        switch (testPosition(bottomAddressA, topAddressB)){
          case "equal":
            return "intersecting";
          case "higher":
            return "outside";
          case "lower":
            switch (testPosition(bottomAddressA, bottomAddressB)){
              case "equal":
                return "B_inside_A";
              case "higher":
                return "intersecting";
              case "lower":
                return "B_inside_A";
            }
        }
      case "lower":
        switch (testPosition(topAddressA, bottomAddressB)){
          case "equal":
            return "intersecting";
          case "higher":
            switch (testPosition(bottomAddressA, bottomAddressB)){
              case "equal":
                return "A_inside_B";
              case "higher":
                return "A_inside_B";
              case "lower":
                return "intersecting";
            };
          case "lower":
            return "outside";
        }
    }
    return "Erreur de test des ensembles.";
  }

    static String testPosition (List<String> listA, List<String> listB){
      for (int i = 0; i < 4; i++){
        if (int.parse(listA[i]) > int.parse(listB[i])) return "higher";
        if (int.parse(listA[i]) < int.parse(listB[i])) return "lower";
      }
      return "equal";
    }
}
