import 'adresse.dart';

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
  String supernetAddress = "";
  int addressCount = adresses_reseau.length, supernetAddressSuffix = 0;

  // Creates a list of objects
  for (int i = 0; i < adresses_reseau.length; i++) {
    adresses_reseau_objet.add(implementationObjet(adresses_reseau[i]));
  }

  // Tests on list items
  // Tests if there are duplicate addresses and
  // if an address is inside another one
  for (int i = 0; i < adresses_reseau_objet.length; i++) {
    if (adresses_reseau_objet[i].suffixe == 32) {
      for (int j = 0; j < adresses_reseau_objet.length; j++) {
        if (j == i) continue;
        if (adresses_reseau_objet[j].suffixe != 32) {
          // launches the inside test
          print(adresses_reseau_objet[i].suffixe);
          bottomAddress = adresses_reseau_objet[j].adresseReseauTableau;
          topAddress = adresses_reseau_objet[j].adresseDiffusionTableau;
          if (Supernet.testIfInInterval(
              adresses_reseau_objet[i].adresseReseauTableau,
              bottomAddress,
              topAddress)) {
            print(adresses_reseau_objet[i].adresseReseauTableau);
            print(" is in the interval ");
            print(adresses_reseau_objet[j].adresseReseauTableau);
          } else {
            print(adresses_reseau_objet[i].adresseReseauTableau);
            print("isn't in the interval");
            print(adresses_reseau_objet[j].adresseReseauTableau);
          }
        } else {
          print("adresse reseau tableau");
          print(adresses_reseau_objet[i].adresseReseauTableau);
          print(adresses_reseau_objet[j].adresseReseauTableau);
          // Equality of 2 addresses test
          if (Supernet.testIfEqual(
              adresses_reseau_objet[i].adresseReseauTableau,
              adresses_reseau_objet[j].adresseReseauTableau)) {
            print("Information : duplicate entries.");
          }
        }
      }
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

  // Tests if an address (without suffix) is included in a range
  static bool testIfInInterval(
      List<String> stringToTest, bottomAddress, topAddress) {
    for (int i = 0; i < 4; i++) {
      if ((int.parse(stringToTest[i]) > int.parse(topAddress[i])) ||
          (int.parse(stringToTest[i]) < int.parse(bottomAddress[i])))
        return false;
    }
    return true;
  }

  // Tests if 2 lists are equal
  static bool testIfEqual(List listA, List listB) {
    if (listA.length != listB.length) return false;
    for (int i = 0; i < listA.length; i++) {
      if (int.parse(listA[i]) != int.parse(listB[i])) return false;
    }
    return true;
  }
}
