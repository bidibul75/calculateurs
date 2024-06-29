// IPV4 mask calculator
// erreur nombre d'adresses
import 'dart:io';

import 'MyException.dart';

void main() {
  Adresse adresse = Adresse("255.255.255.255/33");
  print("Masque réseau :");
  print(adresse.masque_reseau);
  print("Masque inverse :");
  print(adresse.masque_diffusion);
  print("Adresse réseau :");
  print(adresse.adresse_reseau);
  print("Adresse diffusion");
  print(adresse.adresse_diffusion);
  print("Première adresse réseau");
  print(adresse.premiereAdresseReseau);
  print("Dernière adresse réseau");
  print(adresse.derniereAdresseReseau);
  print("Nombre d'adresses");
  print(adresse.nombreAdressesDisponibles);
  print("Adresse binaire :");
  print(adresse.adresse_bin2);
}

class Adresse {
  String adresseATraiter,
      erreur = "",
      adresse_reseau = "",
      adresse_diffusion = "",
      masque_reseau = "",
      masque_diffusion = "",
      adresse_bin2 = "",
      adresseReseauStringBinaire = "",
      adresseDiffusionStringBinaire = "";
  int suffixe = 0, valeurTemp = 0, nombreAdressesDisponibles = 0;

  List<String> adresseList = [],
      adresseReseauTableau = [],
      adresseSeule = [],
      adresseDiffusionTableau = [],
      adresse_bin = [],
      premiereAdresseReseau = [],
      derniereAdresseReseau = [];

  Adresse(this.adresseATraiter) {
    String resultat = regexpProcess(this.adresseATraiter);
    this.adresseATraiter = resultat;
    this.adresseList = stringToListStrings(this.adresseATraiter);

    // Test of address numbers
    testNumbersOfList(adresseList);

    this.suffixe = int.parse(adresseList[4]);

    // Calculation of network mask and diffusion mask
    this.masque_reseau = "1" * this.suffixe + "0" * (32 - this.suffixe);
    this.masque_diffusion = "0" * this.suffixe + "1" * (32 - this.suffixe);

    this.adresseSeule = this.adresseList.sublist(0, 4);

    this.adresseSeule = listStringsDecimalToBinary(this.adresseSeule);

    this.adresse_bin2 = this.adresseSeule.join("");
    for (int i = 0; i < 32; i++) {
      this.adresse_reseau +=
          (int.parse(this.adresse_bin2[i]) & int.parse(this.masque_reseau[i]))
              .toString();
      this.adresse_diffusion += (int.parse(this.adresse_bin2[i]) |
              int.parse(this.masque_diffusion[i]))
          .toString();
    }
    this.adresse_reseau = chaineVersDecimal(this.adresse_reseau);
    this.adresse_diffusion = chaineVersDecimal(this.adresse_diffusion);
    this.adresseReseauTableau = chaineVersTableau(this.adresse_reseau);
    this.adresseDiffusionTableau = chaineVersTableau(this.adresse_diffusion);
    this.adresseReseauStringBinaire =
        conversionTableauVersStringBinaire(this.adresseReseauTableau);
    this.adresseDiffusionStringBinaire =
        conversionTableauVersStringBinaire(this.adresseDiffusionTableau);
    this.premiereAdresseReseau = this.adresseReseauTableau.sublist(0);
    this.premiereAdresseReseau =
        listStringsBinaryToDecimal(this.premiereAdresseReseau);

    this.derniereAdresseReseau = this.adresseDiffusionTableau.sublist(0);
    this.derniereAdresseReseau =
        listStringsBinaryToDecimal(this.derniereAdresseReseau);
    this.adresseReseauTableau =
        listStringsBinaryToDecimal(this.adresseReseauTableau);
    this.adresseDiffusionTableau =
        listStringsBinaryToDecimal(this.adresseDiffusionTableau);
    this.nombreAdressesDisponibles = 0;

    if (this.suffixe < 31) {
      this.premiereAdresseReseau =
          decalageAdresse(this.premiereAdresseReseau, 1);
      this.derniereAdresseReseau =
          decalageAdresse(this.derniereAdresseReseau, -1);

      print("avant nb adresses");
      print(adresseReseauTableau);
      print(adresseDiffusionTableau);
      this.nombreAdressesDisponibles = calculAdressesDisponibles(
          this.adresseReseauTableau, this.adresseDiffusionTableau);
    }

    this.masque_reseau = chaineVersDecimal(this.masque_reseau);
    this.masque_diffusion = chaineVersDecimal(this.masque_diffusion);
  }
}

String regexpProcess(String addressToProcess) {
  addressToProcess = addressToProcess.replaceAll(" ", "");
  print(addressToProcess);
  if (addressToProcess.length > 18)
    throw new MyException(
        "Erreur ! l'adresse entrée comporte trop de caractères",
        addressToProcess);
  RegExp exp = RegExp(r"^[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+/[0-9]+");
  if (exp.firstMatch(addressToProcess) == null) {
    throw new MyException("Erreur REGEXP à l'adresse :", addressToProcess);
  } else {
    print("passe regexp");
    return addressToProcess;
  }
}

// Converts a string into a list of 5 strings (the elements of the address)
List<String> stringToListStrings(String adresseString) {
  List<String> adresseList = adresseString.split("/");
  String suffixe = adresseList[1];
  adresseList = adresseList[0].split(".");
  adresseList.add(suffixe);
  print("adresseList : " + adresseList.toString());
  return adresseList;
}

// Tests the numbers of the address
void testNumbersOfList(List<String> adresseList) {
  int suffixe = int.parse(adresseList[4]);
  if (suffixe < 0 || suffixe > 32) {
    throw new MyException("Erreur ! suffixe incorrect ", suffixe.toString());
  }
  for (int i = 0; i < 4; i++) {
    if (int.parse(adresseList[i]) < 0 || int.parse(adresseList[i]) > 255) {
      throw new MyException("Erreur : L'adresse comporte une erreur sur un(des) nombres.", "");
    }
  }
}

// Converts a list of strings representing decimal numbers
// into a list of strings representing binary numbers
List<String> listStringsDecimalToBinary(List<String> addressListShort) {
  for (int i = 0; i < 4; i++) {
    addressListShort[i] = (int.parse(addressListShort[i])).toRadixString(2);
    int longueur = addressListShort[i].length;
    addressListShort[i] = "0" * (8 - longueur) + addressListShort[i];
  }
  return addressListShort;
}

String conversionTableauVersStringBinaire(List<String> liste) {
  liste = listStringsDecimalToBinary(liste);
  return liste.join("");
}

String chaineVersDecimal(String chaine) {
  String chaineDecimale = "";
  for (int i = 0; i < 32; i += 8) {
    chaineDecimale +=
        (int.parse(chaine.substring(i, i + 8), radix: 2)).toString();
    if (i != 24) chaineDecimale += ".";
  }
  return chaineDecimale;
}

List<String> chaineVersTableau(String chaine) {
  return chaine.split(".");
}

String tableauVersChaine(List tableau) {
  return tableau.join(".");
}

int calculAdressesDisponibles(
    List<String> adresseReseauTableau, adresseDiffusionTableau) {
  int nbAdressesDisponibles = 1, ecart;
  for (int i = 0; i < 4; i++) {
    ecart = int.parse(adresseDiffusionTableau[i]) -
        int.parse(adresseReseauTableau[i]);
    if (ecart != 0) nbAdressesDisponibles *= (ecart + 1);
  }
  return nbAdressesDisponibles;
}

List<String> decalageAdresse(List<String> adresse, int decalage) {
  for (int i = 3; i > -1; i--) {
    if (decalage == -1 && adresse[i] == "0") {
      adresse[i] = "255";
      continue;
    }
    if (decalage == 1 && adresse[i] == "255") {
      adresse[i] = "0";
      continue;
    }
    adresse[i] = (int.parse(adresse[i]) + decalage).toString();
    return adresse;
  }
  String addressString = tableauVersChaine(adresse);
  throw new MyException ("Erreur : décalage impossible car en dehors de la plage 0.0.0.0 / 255.255.255.255 de l'adresse ", addressString);
}

List<String> listStringsBinaryToDecimal(List<String> address) {
  for (int i = 0; i < 4; i++) {
    address[i] = int.parse(address[i], radix: 2).toString();
  }
  return address;
}
