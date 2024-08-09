// IPV4 mask calculator
// erreur nombre d'adresses
import 'MyException.dart';

void main() {
  Adresse adresse = Adresse(" 90.16.84.82/22");
  print("Masque réseau : " + adresse.mask);
  print("Masque inverse : " + adresse.wildcard_mask);
  print("Adresse réseau : " + adresse.address_network);
  print("Adresse diffusion : " + adresse.address_broadcast);
  print("Première adresse réseau : " + adresse.address_available_first_one.toString());
  print("Dernière adresse réseau : " + adresse.address_available_last_one.toString());
  print("Nombre d'adresses : " + thousand_spaces(adresse.number_available_addresses));
  print("Nombre d'adresses utilisables : " + thousand_spaces(adresse.number_available_addresses-2));
  print("Adresse binaire : " + adresse.address_only_string);
  print("Adresse list : " + adresse.address_list.toString());
}

class Adresse {
  String address_to_process,
      address_network = "",
      address_broadcast = "",
      mask = "",
      wildcard_mask = "",
      address_only_string = "",
      address_network_string_binary = "",
      address_broadcast_string_binary = "";
  int suffix = 0, value_temp = 0, number_available_addresses = 0;

  List<String> address_list = [],
      address_network_list = [],
      address_only_list = [],
      address_broadcast_list = [],
      address_binary = [],
      address_available_first_one = [],
      address_available_last_one = [];

  Adresse(this.address_to_process) {
    String resultat = regexp_process(this.address_to_process);
    this.address_to_process = resultat;
    this.address_list = string_to_list_strings(this.address_to_process);

    // Test of address numbers
    tests_numbers_in_list(address_list);

    this.suffix = int.parse(address_list[4]);

    // Calculation of network mask and diffusion mask
    this.mask = "1" * this.suffix + "0" * (32 - this.suffix);
    this.wildcard_mask = "0" * this.suffix + "1" * (32 - this.suffix);
    
    // Extraction of the address without the suffix and casting it into a binary numbers string
    this.address_only_list = this.address_list.sublist(0, 4);
    this.address_only_string = list_strings_decimal_to_string_binary(this.address_only_list);

    for (int i = 0; i < 32; ++i) {
      this.address_network += (int.parse(this.address_only_string[i]) & int.parse(this.mask[i])).toString();
      this.address_broadcast += (int.parse(this.address_only_string[i]) | int.parse(this.wildcard_mask[i])).toString();
    }

    // Network address processing
    this.address_network = string_binary_to_string_decimal_dots(this.address_network);
    this.address_network_list = string_dots_to_list(this.address_network);
    this.address_network_string_binary = list_strings_decimal_to_string_binary(this.address_network_list);
    this.address_network_list = list_strings_binary_to_decimal(this.address_network_list);
    // List's hard copy
    this.address_available_first_one = this.address_network_list.sublist(0);

    // Broadcast address processing
    this.address_broadcast = string_binary_to_string_decimal_dots(this.address_broadcast);
    this.address_broadcast_list = string_dots_to_list(this.address_broadcast);
    this.address_broadcast_string_binary = list_strings_decimal_to_string_binary(this.address_broadcast_list);
    this.address_broadcast_list = list_strings_binary_to_decimal(this.address_broadcast_list);
    // List's hard copy
    this.address_available_last_one = this.address_broadcast_list.sublist(0);

    if (this.suffix < 32) {
      this.address_available_first_one = address_shift(this.address_available_first_one, 1);
      this.address_available_last_one = address_shift(this.address_available_last_one, -1);
      this.number_available_addresses = counts_available_addresses(this.address_network_list, this.address_broadcast_list);
    } else {
      this.number_available_addresses = 1;
    }

    this.mask = string_binary_to_string_decimal_dots(this.mask);
    this.wildcard_mask = string_binary_to_string_decimal_dots(this.wildcard_mask);
  }
}

String eliminate_spaces(String string_to_clean){
  return string_to_clean.replaceAll(" ", "");
}

String regexp_process(String addressToProcess) {
  addressToProcess = eliminate_spaces(addressToProcess);
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
  for (int i = 0; i < 4; ++i) {
    if (int.parse(adresseList[i]) < 0 || int.parse(adresseList[i]) > 255) {
      throw new MyException("Erreur : L'adresse comporte une erreur sur un(des) nombres.", "");
    }
  }
}

// Casts a list of decimal numbers into a single binary string
String list_strings_decimal_to_string_binary(List<String> addressListShort) {
  for (int i = 0; i < 4; ++i) {
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
  for (int i = 0; i < 4; ++i) {
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
  for (int i = 0; i < 4; ++i) {
    address[i] = int.parse(address[i], radix: 2).toString();
  }
  return address;
}

String thousand_spaces(int number){
  String number_string = number.toString(), result = "";
  while (number_string.length > 3) {
    result = number_string.substring(number_string.length-3) + " " + result;
    number_string = number_string.substring(0, number_string.length-3);
  }
return (number_string + " " + result).trimRight();
}