// IPV4 mask calculator
// erreur nombre d'adresses
import 'package:calculators/utils/my_exception.dart';
import 'package:calculators/utils/extensions/extensions.dart';

void address() {
  Address address = Address(" 90.16.84.82/8", "address");
  print("Masque réseau : ${address.mask}");
  print("Masque inverse : ${address.wildcardMask}");
  print("Adresse réseau : ${address.addressNetwork}");
  print("Adresse diffusion : ${address.addressBroadcast}");
  print("Première adresse réseau : ${address.addressAvailableFirstOne}");
  print("Dernière adresse réseau : ${address.addressAvailableLastOne}");
  print("Nombre d'adresses : ${(address.numberAvailableAddresses).toString().format}");
  print("Nombre d'adresses utilisables : ${(address.numberUsableAddresses).toString().format}");
  print("Adresse binaire : ${address.addressOnlyString}");
  print("Adresse list : ${address.addressList}");
}

class Address {
  String addressToProcess,
      addressNetwork = "",
      addressBroadcast = "",
      mask = "",
      wildcardMask = "",
      addressOnlyString = "",
      addressNetworkStringBinary = "",
      addressBroadcastStringBinary = "";
  int suffix = 0, valueTemp = 0; //, numberAvailableAddresses = 0;

  List<String> addressList = [],
      addressNetworkList = [],
      addressOnlyList = [],
      addressBroadcastList = [],
      addressBinary = [],
      addressAvailableFirstOne = [],
      addressAvailableLastOne = [];

  Address(this.addressToProcess, String origin) {
    // Regexp processing in case of not having done yet
    if (origin == "address") {
      addressToProcess = regexpProcess(addressToProcess);
    }
    print("origin : $origin");
    addressList = stringToListStrings(addressToProcess);

    // Test of address numbers
    testsNumbersInList(addressList);

    suffix = int.parse(addressList[4]);

    // Calculation of network mask and diffusion mask
    mask = "1" * suffix + "0" * (32 - suffix);
    wildcardMask = "0" * suffix + "1" * (32 - suffix);

    // Extraction of the address without the suffix and casting it into a binary numbers string
    addressOnlyList = addressList.sublist(0, 4);
    addressOnlyString = listStringsDecimalToStringBinary(addressOnlyList);

    for (int i = 0; i < 32; i++) {
      addressNetwork += (int.parse(addressOnlyString[i]) & int.parse(mask[i])).toString();
      addressBroadcast += (int.parse(addressOnlyString[i]) | int.parse(wildcardMask[i])).toString();
    }

    // Network address processing
    addressNetwork = stringBinaryToStringDecimalDots(addressNetwork);
    addressNetworkList = stringDotsToList(addressNetwork);
    addressNetworkStringBinary = listStringsDecimalToStringBinary(addressNetworkList);
    addressNetworkList = listStringsBinaryToDecimal(addressNetworkList);
    // List's hard copy
    addressAvailableFirstOne = addressNetworkList.sublist(0);

    // Broadcast address processing
    addressBroadcast = stringBinaryToStringDecimalDots(addressBroadcast);
    addressBroadcastList = stringDotsToList(addressBroadcast);
    addressBroadcastStringBinary = listStringsDecimalToStringBinary(addressBroadcastList);
    addressBroadcastList = listStringsBinaryToDecimal(addressBroadcastList);
    // List's hard copy
    addressAvailableLastOne = addressBroadcastList.sublist(0);

    if (suffix < 32) {
      addressAvailableFirstOne = addressShift(addressAvailableFirstOne, 1);
      addressAvailableLastOne = addressShift(addressAvailableLastOne, -1);
    }

    mask = stringBinaryToStringDecimalDots(mask);
    wildcardMask = stringBinaryToStringDecimalDots(wildcardMask);
  }

  /// Returns the number of available addresses
  int get numberAvailableAddresses => 1 << (32 - suffix);

  /// Returns the number of usable host addresses for this prefix.
  /// /32 keeps 1 host address, /31 keeps 2 host addresses (RFC 3021),
  /// otherwise network and broadcast are excluded.
  int get numberUsableAddresses {
    if (suffix == 32) return 1;
    if (suffix == 31) return 2;
    return numberAvailableAddresses - 2;
  }
}

String regexpProcess(String addressToProcessString) {
  addressToProcessString = addressToProcessString.replaceAll(" ", "");
  if (addressToProcessString.length > 18) {
    throw MyException("Erreur ! l'adresse entrée comporte trop de caractères", addressToProcessString);
  }
  RegExp exp = RegExp(r"^[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+/[0-9]+");
  if (exp.firstMatch(addressToProcessString) == null) {
    throw MyException("Erreur REGEXP à l'adresse :", addressToProcessString);
  } else {
    return addressToProcessString;
  }
}

/// Converts a string into a list of 5 strings (the elements of the address)
List<String> stringToListStrings(String addressString) {
  List<String> addressParts = addressString.split("/");
  String suffixStr = addressParts[1];
  addressParts = addressParts[0].split(".");
  addressParts.add(suffixStr);
  print("adresseList : $addressParts");
  return addressParts;
}

/// Tests the numbers of the address
void testsNumbersInList(List<String> addressListString) {
  int suffixValue = int.parse(addressListString[4]);
  if (suffixValue < 0 || suffixValue > 32) {
    throw MyException("Erreur ! suffixe incorrect ", addressListString.toString());
  }
  for (int i = 0; i < 4; i++) {
    if (int.parse(addressListString[i]) < 0 || int.parse(addressListString[i]) > 255) {
      throw MyException("Erreur : L'adresse comporte une erreur sur un(des) nombres", addressListString.toString());
    }
  }
}

/// Casts a list of decimal numbers into a single binary string
String listStringsDecimalToStringBinary(List<String> addressListShort) {
  for (int i = 0; i < 4; i++) {
    addressListShort[i] = (int.parse(addressListShort[i])).toRadixString(2);
    addressListShort[i] = "0" * (8 - addressListShort[i].length) + addressListShort[i];
  }
  return addressListShort.join("");
}

/// Casts a binary string into a string of 4 decimals separated by dots
String stringBinaryToStringDecimalDots(String binaryString) {
  String decimalString = (int.parse(binaryString.substring(0, 8), radix: 2)).toString();
  for (int i = 8; i < 32; i += 8) {
    decimalString += ".${int.parse(binaryString.substring(i, i + 8), radix: 2)}";
  }
  return decimalString;
}

/// Casts a dot-separated String into a List (address without the suffix)
List<String> stringDotsToList(String dotString) {
  return dotString.split(".");
}

/// Casts a List into a dot-separated String
String listToStringDots(List list) {
  return list.join(".");
}

/// Counts the number of available addresses among a range
int countsAvailableAddresses(List<String> networkList, broadcastList) {
  int nbAvailableAddresses = 1, gap = 0;
  for (int i = 0; i < 4; i++) {
    gap = int.parse(broadcastList[i]) - int.parse(networkList[i]);
    if (gap != 0) {
      nbAvailableAddresses *= (gap + 1);
    }
  }
  return nbAvailableAddresses;
}

/// Calculates the address that follows or precedes a given address (without suffix)
List<String> addressShift(List<String> address, int step) {
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
  String addressString = listToStringDots(address);
  throw MyException(
    "Erreur : décalage impossible car en dehors plage 0.0.0.0 / 255.255.255.255 de l'adresse ",
    addressString,
  );
}

List<String> listStringsBinaryToDecimal(List<String> address) {
  for (int i = 0; i < 4; i++) {
    address[i] = int.parse(address[i], radix: 2).toString();
  }
  return address;
}
