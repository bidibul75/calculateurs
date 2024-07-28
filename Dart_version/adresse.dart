// IPV4 mask calculator
// erreur nombre d'adresses
import 'dart:io';

import 'MyException.dart';

void main() {
  Adresse adresse = Adresse("255.255.255.255/12");
  print("Masque réseau : " + adresse.masque_reseau);
  print("Masque inverse : " + adresse.masque_diffusion);
  print("Adresse réseau : " + adresse.adresse_reseau);
  print("Adresse diffusion : " + adresse.adresse_diffusion);
  print("Première adresse réseau : " + adresse.premiereAdresseReseau.toString());
  print("Dernière adresse réseau : " + adresse.derniereAdresseReseau.toString());
  print("Nombre d'adresses : " + adresse.nombreAdressesDisponibles.toString());
  print("Adresse binaire : " + adresse.address_only_string);
  print("Adresse list : " + adresse.adresseList.toString());
}

class Adresse {
  String adresseATraiter,
      erreur = "",
      adresse_reseau = "",
      adresse_diffusion = "",
      masque_reseau = "",
      masque_diffusion = "",
      address_only_string = "",
      adresseReseauStringBinaire = "",
      adresseDiffusionStringBinaire = "";
  int suffixe = 0, valeurTemp = 0, nombreAdressesDisponibles = 0;

  List<String> adresseList = [],
      adresseReseauTableau = [],
      address_only_list = [],
      adresseDiffusionTableau = [],
      adresse_bin = [],
      premiereAdresseReseau = [],
      derniereAdresseReseau = [];

  Adresse(this.adresseATraiter) {
    String resultat = regexp_process(this.adresseATraiter);
    this.adresseATraiter = resultat;
    this.adresseList = string_to_list_strings(this.adresseATraiter);

    // Test of address numbers
    tests_numbers_in_list(adresseList);

    this.suffixe = int.parse(adresseList[4]);

    // Calculation of network mask and diffusion mask
    this.masque_reseau = "1" * this.suffixe + "0" * (32 - this.suffixe);
    this.masque_diffusion = "0" * this.suffixe + "1" * (32 - this.suffixe);
    
    // Extraction of the address without the suffix and casting it into a binary numbers string
    this.address_only_list = this.adresseList.sublist(0, 4);
    this.address_only_string = list_strings_decimal_to_string_binary(this.address_only_list);

    for (int i = 0; i < 32; i++) {
      this.adresse_reseau += (int.parse(this.address_only_string[i]) & int.parse(this.masque_reseau[i])).toString();
      this.adresse_diffusion += (int.parse(this.address_only_string[i]) | int.parse(this.masque_diffusion[i])).toString();
    }

    // Network address processing
    this.adresse_reseau = string_binary_to_string_decimal_dots(this.adresse_reseau);
    this.adresseReseauTableau = string_dots_to_list(this.adresse_reseau);
    this.adresseReseauStringBinaire = list_strings_decimal_to_string_binary(this.adresseReseauTableau);
    this.adresseReseauTableau = list_strings_binary_to_decimal(this.adresseReseauTableau);
    // List's hard copy
    this.premiereAdresseReseau = this.adresseReseauTableau.sublist(0);

    // Broadcast address processing
    this.adresse_diffusion = string_binary_to_string_decimal_dots(this.adresse_diffusion);
    this.adresseDiffusionTableau = string_dots_to_list(this.adresse_diffusion);
    this.adresseDiffusionStringBinaire = list_strings_decimal_to_string_binary(this.adresseDiffusionTableau);
    this.adresseDiffusionTableau = list_strings_binary_to_decimal(this.adresseDiffusionTableau);
    // List's hard copy
    this.derniereAdresseReseau = this.adresseDiffusionTableau.sublist(0);

    if (this.suffixe < 32) {
      this.premiereAdresseReseau = address_shift(this.premiereAdresseReseau, 1);
      this.derniereAdresseReseau = address_shift(this.derniereAdresseReseau, -1);
      this.nombreAdressesDisponibles = counts_available_addresses(this.adresseReseauTableau, this.adresseDiffusionTableau);
    } else {
      this.nombreAdressesDisponibles = 1;
    }

    this.masque_reseau = string_binary_to_string_decimal_dots(this.masque_reseau);
    this.masque_diffusion = string_binary_to_string_decimal_dots(this.masque_diffusion);
  }
}

String regexp_process(String addressToProcess) {
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
List<String> string_to_list_strings(String adresseString) {
  List<String> adresseList = adresseString.split("/");
  String suffixe = adresseList[1];
  adresseList = adresseList[0].split(".");
  adresseList.add(suffixe);
  print("adresseList : " + adresseList.toString());
  return adresseList;
}

// Tests the numbers of the address
void tests_numbers_in_list(List<String> adresseList) {
  int suffixe = int.parse(adresseList[4]);
  if (suffixe < 0 || suffixe > 32) {
    throw new MyException("Erreur ! suffixe incorrect ", "");
  }
  for (int i = 0; i < 4; i++) {
    if (int.parse(adresseList[i]) < 0 || int.parse(adresseList[i]) > 255) {
      throw new MyException("Erreur : L'adresse comporte une erreur sur un(des) nombres.", "");
    }
  }
}

// Casts a list of decimal numbers into a single binary string
String list_strings_decimal_to_string_binary(List<String> addressListShort) {
  for (int i = 0; i < 4; i++) {
    addressListShort[i] = (int.parse(addressListShort[i])).toRadixString(2);
    int longueur = addressListShort[i].length;
    addressListShort[i] = "0" * (8 - longueur) + addressListShort[i];
  }
  return addressListShort.join("");
}

// Casts a binary string into a string of 4 decimals separated by dots
String string_binary_to_string_decimal_dots(String chaine) {
  String chaineDecimale = "";
  for (int i = 0; i < 32; i += 8) {
    chaineDecimale +=
        (int.parse(chaine.substring(i, i + 8), radix: 2)).toString();
    if (i != 24) chaineDecimale += ".";
  }
  return chaineDecimale;
}

// Casts a dot-separated String into a List (address without the suffix)
List<String> string_dots_to_list(String chaine) {
  return chaine.split(".");
}

// Casts a List into a dot-separated String 
String list_to_string_dots(List list) {
  return list.join(".");
}

// Counts the number of available addresses among a range
int counts_available_addresses(
    List<String> adresseReseauTableau, adresseDiffusionTableau) {
  int nbAdressesDisponibles = 1, ecart = 0;
  for (int i = 0; i < 4; i++) {
    ecart = int.parse(adresseDiffusionTableau[i]) -
        int.parse(adresseReseauTableau[i]);
    if (ecart != 0) {
        nbAdressesDisponibles *= (ecart + 1);
        }
  }
  return nbAdressesDisponibles;
}

// Calculates the address that follows or precedes a given address (without suffix)
List<String> address_shift(List<String> address, int step) {
  for (int i = 3; i > -1; i--) {
    if (step == -1 && address[i] == "0") {
      address[i] = "255";
      continue;
    }
    if (step == 1 && address[i] == "255") {
      address[i] = "0";
      continue;
    }
    address[i] = (int.parse(address[i]) + step).toString();
    return address;
  }
  String addressString = list_to_string_dots(address);
  throw new MyException ("Erreur : décalage impossible car en dehors de la plage 0.0.0.0 / 255.255.255.255 de l'adresse ", addressString);
}

List<String> list_strings_binary_to_decimal(List<String> address) {
  for (int i = 0; i < 4; i++) {
    address[i] = int.parse(address[i], radix: 2).toString();
  }
  return address;
}
