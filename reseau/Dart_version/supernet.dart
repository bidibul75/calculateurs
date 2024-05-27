import 'dart:io';
import 'adresse.dart';

void main() {
  List<String> adresses_reseau = [
    "192.16 8.17.0/16",
    "1 92.168.2.0/24",
    "192.0.3.0/11",
    "192.132.3.0/10"
  ];
  List<Supernet> adresses_reseau_objet=[];
  for (int i = 0; i < adresses_reseau.length; i++) {
    adresses_reseau_objet.add(implementationObjet(adresses_reseau[i]));
  }
  // test
  print(adresses_reseau_objet[0].premiereAdresseReseau);
}

Supernet implementationObjet(String adresse) {
  Supernet supernet = Supernet(adresse);
  return supernet;
}

class Supernet extends Adresse {
  String adresse_reseau_temp;

  Supernet(this.adresse_reseau_temp) : super(adresse_reseau_temp, 'cidr') {}
}
