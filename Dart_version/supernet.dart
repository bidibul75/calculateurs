import 'adresse.dart';
import 'relation.dart';

void main() {
  List<String> adresses_reseau = [
    "192.168.1.0/8",
    "192.168.2.0/24",
    "192.168.2.0/24",
    "192.168.4.0/24",
    "192.168.9.1/32"
  ];
  List<Supernet> adresses_reseau_objet = [];
  List<String> listToBeTreated = [], bottomAddress, topAddress;
  String supernetAddress = "", result = "", global_result = "";
  int addressCount = adresses_reseau.length, supernetAddressSuffix = 0;

  // Creates a list of objects
  for (int i = 0; i < adresses_reseau.length; i++) {
    adresses_reseau_objet.add(implementationObjet(adresses_reseau[i]));
  }

  // Tests on list items
  // Tests if there are duplicate addresses and
  // if an address is inside another one
  List<String> bottomAddressA, topAddressA, bottomAddressB, topAddressB  ;
  for (int i = 0; i < adresses_reseau_objet.length; i++) {
    for (int j = 0; j < adresses_reseau_objet.length; j++) {
      if (j == i) continue;

      bottomAddressA = adresses_reseau_objet[i].adresseReseauTableau;
      topAddressA = adresses_reseau_objet[i].adresseDiffusionTableau;
      bottomAddressB = adresses_reseau_objet[j].adresseReseauTableau;
      topAddressB = adresses_reseau_objet[j].adresseDiffusionTableau;
      result = Supernet.testIfIntersecting(bottomAddressA, topAddressA, bottomAddressB, topAddressB);
      print("Result : $result");
        print(" Adresse A : bottom : " + bottomAddressA.toString() + " top : " + topAddressA.toString());
        print(" Adresse B : bottom : " + bottomAddressB.toString() + " top : " + topAddressB.toString());
        Relation relation = new Relation (adresses_reseau_objet[i].adresseATraiter, adresses_reseau_objet[j].adresseATraiter, result);
        //continue;
      }
    }


// Creation of the list to submit to calculation of the supernet
  for (int i = 0; i < adresses_reseau_objet.length; i++) {
    if (adresses_reseau_objet[i].suffixe == 32) {
      listToBeTreated.add(adresses_reseau_objet[i].address_only_string);
    } else {
      listToBeTreated.add(adresses_reseau_objet[i].adresseReseauStringBinaire);
      listToBeTreated
          .add(adresses_reseau_objet[i].adresseDiffusionStringBinaire);
    }
  }

  // Calculation of the supernet address
  supernetAddress =
      supernetCalculation(addressCount, listToBeTreated, supernetAddress = "");
  supernetAddressSuffix = supernetAddress.length;
  supernetAddress += "0" * (32 - supernetAddressSuffix);
  supernetAddress = string_binary_to_string_decimal_dots(supernetAddress) +
      "/" +
      supernetAddressSuffix.toString();
  print("L'adresse supernet est : " + supernetAddress);
}

// Building objects
Supernet implementationObjet(String adresse) {
  Supernet supernet = Supernet(adresse);
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
  String adresse_reseau_temp;

  Supernet(this.adresse_reseau_temp) : super(adresse_reseau_temp) {}

 static String testIfIntersecting(List<String> bottomAddressA, List<String> topAddressA, List<String> bottomAddressB, List<String> topAddressB) {

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
