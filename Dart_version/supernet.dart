import 'adresse.dart';
import 'relation.dart';

void main() {
  List<String> addresses_list = [
    "192.168.1.0/8",
    " 192.168.2. 0/2 4",
    "192.168.2.0/24",
    " 192.168.4.0/24",
    "192.168.9.1/32"
  ], addresses_list_uniques = addresses_list.sublist(0);
  List<Supernet> addresses_object = [], addresses_object_relations = [];
  List<Relation> relations =[];
  List<String> list_to_be_processed = [];
  List<String> bottom_address_A, top_address_A, bottom_address_B, top_address_B  ;
  String supernetAddress = "", result = "";
  addresses_list_uniques = Supernet.regexp_list(addresses_list_uniques);
  addresses_list_uniques = Supernet.process_duplicate_addresses (addresses_list_uniques, relations);

  int addressCount = addresses_list_uniques.length, supernet_address_Suffix = 0;

  // Creates a list of objects
  for (int i = 0; i < addresses_list_uniques.length; ++i) {
    addresses_object.add(implementation_object_supernet(addresses_list_uniques[i]));
  }

  // Hard copy this list to use it for relations
  addresses_object_relations = addresses_object.sublist(0);

  // Tests on list items
  // Tests if there are duplicate addresses and
  // if an address is inside another one
  for (int i = 0; i < addresses_object_relations.length; ++i) {
    for (int j = i+1; j < addresses_object_relations.length; ++j) {
      bottom_address_A = addresses_object_relations[i].address_network_list;
      top_address_A = addresses_object_relations[i].address_broadcast_list;
      bottom_address_B = addresses_object_relations[j].address_network_list;
      top_address_B = addresses_object_relations[j].address_broadcast_list;
      result = Supernet.test_of_intersections(bottom_address_A, top_address_A, bottom_address_B, top_address_B);
      print ("Result : " + result);
      print(" Adresse A : bottom : " + bottom_address_A.toString() + " top : " + top_address_A.toString());
      print(" Adresse B : bottom : " + bottom_address_B.toString() + " top : " + top_address_B.toString());
      if (result == "equal"){
        addresses_object_relations.removeAt(j);
      }
      relations.add(implementation_objet_relation(addresses_object[i].address_to_process, result, addresses_object[j].address_to_process));
    }
  }

// Creation of the list to submit to calculation of the supernet
  for (int i = 0; i < addresses_object.length; ++i) {
    if (addresses_object[i].suffix == 32) {
      list_to_be_processed.add(addresses_object[i].address_only_string);
    } else {
      list_to_be_processed.add(addresses_object[i].address_network_string_binary);
      list_to_be_processed.add(addresses_object[i].address_broadcast_string_binary);
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

  // Prints the relations object
  print("relations object : ");
  for (int i = 0; i < relations.length; ++i){
    print(relations[i].address_A+" "+relations[i].relation_AB+" "+relations[i].address_B);
  }
}

// Building objects
Supernet implementation_object_supernet(String address) {
  Supernet supernet = Supernet(address);
  return supernet;
}

Relation implementation_objet_relation (String address_A, relation_AB, address_B) {
  Relation relation = Relation(address_A, relation_AB, address_B);
  return relation;
}

String supernetCalculation(
    int addressCount, List<String> list, String supernetAddress) {
  for (int i = 0; i < 32; ++i) {
    for (int addressNumber = 0;
        addressNumber < addressCount - 1;
        ++addressNumber) {
      if (list[addressNumber][i] != list[addressNumber + 1][i])
        return supernetAddress;
    }
    supernetAddress += list[0][i];
  }
  return supernetAddress;
}

class Supernet extends Adresse {
  String address_temp;

  Supernet(this.address_temp) : super(address_temp, "supernet") {}

  static List<String> regexp_list(List<String> list_to_process){
    for (int i = 0; i < list_to_process.length; ++i){
      list_to_process[i] = regexp_process(list_to_process[i]);
    }
    return list_to_process;
  }
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
      for (int i = 0; i < 4; ++i){
        if (int.parse(listA[i]) > int.parse(listB[i])) return "higher";
        if (int.parse(listA[i]) < int.parse(listB[i])) return "lower";
      }
      return "equal";
    }

  static List<String> process_duplicate_addresses(List<String> list_to_process, List<Relation> relations){
    for (int i = 0; i < list_to_process.length; ++i){
      for (int j = 0; j < list_to_process.length; ++j){
        if (i == j) continue;
        if (list_to_process[i] == list_to_process[j]){
          relations.add(implementation_objet_relation(list_to_process[i], "equal", list_to_process[j]));
          list_to_process.removeAt(j);
        }
      }
    }
    return list_to_process;
  }
}
