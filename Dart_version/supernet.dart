import 'adresse.dart';

void main() {
  List<String> adresses_reseau = [
    "192.13 2.3.1/32",
    "192.132.3.1/32",
    "1 92.168.2.0/32",
    "192.0.3.0/32",
    "192.132.3.0/27"
  ];
  List<Supernet> adresses_reseau_objet = [];
  List bottomAddress, topAddress;
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

          if (Supernet.testIfEqual(
              adresses_reseau_objet[i].adresseReseauTableau,
              adresses_reseau_objet[j].adresseReseauTableau)) {
            print("Information : duplicate entries.");
          }
        }
      }
    }
  }

  // Calculation of the supernet address
  supernetAddress =
      supernetCalculation(addressCount, adresses_reseau_objet, supernetAddress);
  supernetAddressSuffix = supernetAddress.length;
  supernetAddress += "0" * (32 - supernetAddressSuffix);
  supernetAddress = Adresse.chaineVersDecimal(supernetAddress) +
      "/" +
      supernetAddressSuffix.toString();
  print("L'adresse supernet est : " + supernetAddress);
}

// Building objects
Supernet implementationObjet(String adresse) {
  Supernet supernet = Supernet(adresse);
  return supernet;
}

String supernetCalculation(int addressCount,
    List<Supernet> adresses_reseau_objet, String supernetAddress) {
  for (int i = 0; i < 32; i++) {
    for (int addressNumber = 0;
        addressNumber < addressCount - 1;
        addressNumber++) {
      if (adresses_reseau_objet[addressNumber].adresse_bin2[i] !=
          adresses_reseau_objet[addressNumber + 1].adresse_bin2[i])
        return supernetAddress;
    }
    supernetAddress += adresses_reseau_objet[0].adresse_bin2[i];
  }
  return supernetAddress;
}

class Supernet extends Adresse {
  String adresse_reseau_temp;

  Supernet(this.adresse_reseau_temp) : super(adresse_reseau_temp) {}

  static bool testIfInInterval(
      List stringToTest, List bottomAddress, List topAddress) {
    for (int i = 0; i < 4; i++) {
      if ((int.parse(stringToTest[i]) > int.parse(topAddress[i])) ||
          (int.parse(stringToTest[i]) < int.parse(bottomAddress[i])))
        return false;
    }
    return true;
  }

  static bool testIfEqual(List listA, List listB) {
    for (int i = 0; i < 4; i++) {
      if (int.parse(listA[i]) != int.parse(listB[i])) return false;
    }
    return true;
  }
}
