import 'dart:io';
import 'adresse.dart';

void main() {
  List<String> adresses_reseau = [
    "192.16 8.17.0/32",
    "1 92.168.2.0/32",
    "192.0.3.0/32",
    "192.132.3.0/32"
  ];
  List<Supernet> adresses_reseau_objet = [];
  String supernetAddress = "";
  int addressCount = adresses_reseau.length, supernetAddressSuffix = 0;

  for (int i = 0; i < adresses_reseau.length; i++) {
    adresses_reseau_objet.add(implementationObjet(adresses_reseau[i]));
  }
  supernetAddress =
      supernetCalculation(addressCount, adresses_reseau_objet, supernetAddress);
  supernetAddressSuffix = supernetAddress.length;
  supernetAddress += "0" * (32 - supernetAddressSuffix);
  supernetAddress = Adresse.chaineVersDecimal(supernetAddress) +
      "/" +
      supernetAddressSuffix.toString();
  print("L'adresse supernet est : " + supernetAddress);
}

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

  Supernet(this.adresse_reseau_temp) : super(adresse_reseau_temp) {

  }
}
