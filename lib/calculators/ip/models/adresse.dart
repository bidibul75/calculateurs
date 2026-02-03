// IPV4 mask calculator
// erreur nombre d'adresses
import 'MyException.dart';

void main() {
  Adresse adresse = Adresse(" 90.16.84.82/22", "adresse");
  print("Masque réseau : ${adresse.mask}");
  print("Masque inverse : ${adresse.wildcard_mask}");
  print("Adresse réseau : ${adresse.address_network}");
  print("Adresse diffusion : ${adresse.address_broadcast}");
  print("Première adresse réseau : ${adresse.address_available_first_one}");
  print("Dernière adresse réseau : ${adresse.address_available_last_one}");
  print(
    "Nombre d'adresses : ${thousand_spaces(adresse.number_available_addresses)}",
  );
  print(
    "Nombre d'adresses utilisables : ${thousand_spaces(adresse.number_available_addresses - 2)}",
  );
  print("Adresse binaire : ${adresse.address_only_string}");
  print("Adresse list : ${adresse.address_list}");
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

  Adresse(this.address_to_process, String origin) {
    // Regexp processing in case of not having done yet
    if (origin == "adresse") {
      String resultat = regexp_process(address_to_process);
      address_to_process = resultat;
    }
    print("origin : $origin");
    address_list = string_to_list_strings(address_to_process);

    // Test of address numbers
    tests_numbers_in_list(address_list);

    suffix = int.parse(address_list[4]);

    // Calculation of network mask and diffusion mask
    mask = "1" * suffix + "0" * (32 - suffix);
    wildcard_mask = "0" * suffix + "1" * (32 - suffix);

    // Extraction of the address without the suffix and casting it into a binary numbers string
    address_only_list = address_list.sublist(0, 4);
    address_only_string = list_strings_decimal_to_string_binary(
      address_only_list,
    );

    for (int i = 0; i < 32; ++i) {
      address_network += (int.parse(address_only_string[i]) & int.parse(mask[i])).toString();
      address_broadcast += (int.parse(address_only_string[i]) | int.parse(wildcard_mask[i])).toString();
    }

    // Network address processing
    address_network = string_binary_to_string_decimal_dots(address_network);
    address_network_list = string_dots_to_list(address_network);
    address_network_string_binary = list_strings_decimal_to_string_binary(address_network_list);
    address_network_list = list_strings_binary_to_decimal(address_network_list);
    // List's hard copy
    address_available_first_one = address_network_list.sublist(0);

    // Broadcast address processing
    address_broadcast = string_binary_to_string_decimal_dots(address_broadcast);
    address_broadcast_list = string_dots_to_list(address_broadcast);
    address_broadcast_string_binary = list_strings_decimal_to_string_binary(address_broadcast_list);
    address_broadcast_list = list_strings_binary_to_decimal(address_broadcast_list);
    // List's hard copy
    address_available_last_one = address_broadcast_list.sublist(0);

    if (suffix < 32) {
      address_available_first_one = address_shift(address_available_first_one, 1);
      address_available_last_one = address_shift(address_available_last_one, -1);
      number_available_addresses = counts_available_addresses(address_network_list, address_broadcast_list);
    } else {
      number_available_addresses = 1;
    }

    mask = string_binary_to_string_decimal_dots(mask);
    wildcard_mask = string_binary_to_string_decimal_dots(wildcard_mask);
  }
}

String regexp_process(String address_to_process_string) {
  address_to_process_string = address_to_process_string.replaceAll(" ", "");
  if (address_to_process_string.length > 18) {
    throw MyException("Erreur ! l'adresse entrée comporte trop de caractères", address_to_process_string);
  }
  RegExp exp = RegExp(r"^[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+/[0-9]+");
  if (exp.firstMatch(address_to_process_string) == null) {
    throw MyException("Erreur REGEXP à l'adresse :", address_to_process_string);
  } else {
    return address_to_process_string;
  }
}

// Converts a string into a list of 5 strings (the elements of the address)
List<String> string_to_list_strings(String adresseString) {
  List<String> adresseList = adresseString.split("/");
  String suffixe = adresseList[1];
  adresseList = adresseList[0].split(".");
  adresseList.add(suffixe);
  print("adresseList : $adresseList");
  return adresseList;
}

// Tests the numbers of the address
void tests_numbers_in_list(List<String> address_list_string) {
  int suffixe = int.parse(address_list_string[4]);
  if (suffixe < 0 || suffixe > 32) {
    throw MyException("Erreur ! suffixe incorrect ", address_list_string.toString());
  }
  for (int i = 0; i < 4; ++i) {
    if (int.parse(address_list_string[i]) < 0 ||
        int.parse(address_list_string[i]) > 255) {
      throw MyException("Erreur : L'adresse comporte une erreur sur un(des) nombres", address_list_string.toString());
    }
  }
}

// Casts a list of decimal numbers into a single binary string
String list_strings_decimal_to_string_binary(List<String> addressListShort) {
  for (int i = 0; i < 4; ++i) {
    addressListShort[i] = (int.parse(addressListShort[i])).toRadixString(2);
    addressListShort[i] = "0" * (8 - addressListShort[i].length) + addressListShort[i];
  }
  return addressListShort.join("");
}

// Casts a binary string into a string of 4 decimals separated by dots
String string_binary_to_string_decimal_dots(String chaine) {
  String chaineDecimale = (int.parse(chaine.substring(0, 8), radix: 2)).toString();
  for (int i = 8; i < 32; i += 8) {
    chaineDecimale += ".${int.parse(chaine.substring(i, i + 8), radix: 2)}";
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
  List<String> adresseReseauTableau,
  adresseDiffusionTableau,
) {
  int nbAdressesDisponibles = 1, ecart = 0;
  for (int i = 0; i < 4; ++i) {
    ecart =
        int.parse(adresseDiffusionTableau[i]) -
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
  String address_string = list_to_string_dots(address);
  throw MyException("Erreur : décalage impossible car en dehors plage 0.0.0.0 / 255.255.255.255 de l'adresse ", address_string);
}

List<String> list_strings_binary_to_decimal(List<String> address) {
  for (int i = 0; i < 4; ++i) {
    address[i] = int.parse(address[i], radix: 2).toString();
  }
  return address;
}

String thousand_spaces(int number) {
  String number_string = number.toString(), result = "";
  while (number_string.length > 3) {
    result = "${number_string.substring(number_string.length - 3)} $result";
    number_string = number_string.substring(0, number_string.length - 3);
  }
  return ("$number_string $result").trimRight();
}
