// lib/calculators/ip/IPv4/address.dart
// IPV4 mask calculator
// erreur nombre d'adresses
import 'package:calculators/utils/my_exception.dart';
import 'package:calculators/utils/extensions/extensions.dart';

class Address {
  String addressToProcess,
      addressNetwork = "",
      addressBroadcast = "",
      mask = "",
      wildcardMask = "",
      addressOnlyString = "",
      addressNetworkStringBinary = "",
      addressBroadcastStringBinary = "";
  int suffix = 0, valueTemp = 0;

  List<String> addressList = [],
      addressNetworkList = [],
      addressOnlyList = [],
      addressBroadcastList = [],
      addressBinary = [],
      addressAvailableFirstOne = [],
      addressAvailableLastOne = [];

  Address(this.addressToProcess) {
    addressToProcess = regexpProcess(addressToProcess);
    addressList = stringToListStrings(addressToProcess);

    _testsNumbersInList(addressList);

    suffix = int.parse(addressList[4]);

    mask = "1" * suffix + "0" * (32 - suffix);
    wildcardMask = "0" * suffix + "1" * (32 - suffix);

    addressOnlyList = addressList.sublist(0, 4);
    addressOnlyString = listStringsDecimalToStringBinary(addressOnlyList);

    for (int i = 0; i < 32; i++) {
      addressNetwork += (int.parse(addressOnlyString[i]) & int.parse(mask[i])).toString();
      addressBroadcast += (int.parse(addressOnlyString[i]) | int.parse(wildcardMask[i])).toString();
    }

    addressNetwork = stringBinaryToStringDecimalDots(addressNetwork);
    addressNetworkList = addressNetwork.split(".");
    addressNetworkStringBinary = listStringsDecimalToStringBinary(addressNetworkList);
    addressNetworkList = listStringsBinaryToDecimal(addressNetworkList);
    addressAvailableFirstOne = addressNetworkList.sublist(0);

    addressBroadcast = stringBinaryToStringDecimalDots(addressBroadcast);
    addressBroadcastList = addressBroadcast.split(".");
    addressBroadcastStringBinary = listStringsDecimalToStringBinary(addressBroadcastList);
    addressBroadcastList = listStringsBinaryToDecimal(addressBroadcastList);
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
  /// /32 keeps 1 host address, /31 keeps 2 (RFC 3021),
  /// otherwise network and broadcast are excluded.
  int get numberUsableAddresses {
    if (suffix == 32) return 1;
    if (suffix == 31) return 2;
    return numberAvailableAddresses - 2;
  }

  /// Validates format and strips spaces from a raw CIDR IPv4 string
  static String regexpProcess(String address) {
    address = address.replaceAll(" ", "");
    if (!address.isValidIPv4CIDR) {
      throw MyException("REGEXP error at address :", address);
    }
    return address;
  }

  /// Converts a CIDR string into a list of 5 strings (4 octets + suffix)
  static List<String> stringToListStrings(String addressString) {
    List<String> addressParts = addressString.split("/");
    String suffixStr = addressParts[1];
    addressParts = addressParts[0].split(".");
    addressParts.add(suffixStr);
    return addressParts;
  }

  /// Validates each octet (0–255) and the suffix (0–32)
  static void _testsNumbersInList(List<String> a) {
    List<String> a2 = a.sublist(0);
    String s = a2.removeLast();
    s="${a2.join('.')}/$s";
    if (!s.isValidIPv4CIDR) throw("Error in address : not a valid IPv4 address",s);
  }

  /// Casts a list of 4 decimal strings into a 32-bit binary string (mutates input)
  static String listStringsDecimalToStringBinary(List<String> addressListShort) {
    for (int i = 0; i < 4; i++) {
      addressListShort[i] = (int.parse(addressListShort[i])).toRadixString(2);
      addressListShort[i] = addressListShort[i].padLeft(8, '0');
    }
    return addressListShort.join("");
  }

  /// Calculates the address that follows (+1) or precedes (-1) a given address
  static List<String> addressShift(List<String> address, int step) {
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
    throw MyException(
      "Error : impossible shift has outside 0.0.0.0 - 255.255.255.255 range.",
      address.join("."),
    );
  }

  /// Converts a list of binary strings (8-bit) back to decimal strings
  static List<String> listStringsBinaryToDecimal(List<String> address) {
    for (int i = 0; i < 4; i++) {
      address[i] = int.parse(address[i], radix: 2).toString();
    }
    return address;
  }
}

/// Casts a 32-bit binary string into a dotted-decimal string (e.g. "192.168.1.5").
/// Kept top-level as it is shared between [Address] and [Supernet].
String stringBinaryToStringDecimalDots(String binaryString) {
  String decimalString = (int.parse(binaryString.substring(0, 8), radix: 2)).toString();
  for (int i = 8; i < 32; i += 8) {
    decimalString += ".${int.parse(binaryString.substring(i, i + 8), radix: 2)}";
  }
  return decimalString;
}
