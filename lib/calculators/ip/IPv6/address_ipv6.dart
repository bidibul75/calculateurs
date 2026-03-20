import 'package:calculators/utils/extensions/extensions.dart';
import 'package:calculators/utils/my_exception.dart';
import 'package:flutter/cupertino.dart';

class AddressIPV6 {
  String address6 = "";
  List<String> address6ListString = []; // Formatted address with 4 digits and no ::
  List<String> address6WithoutSuffixListString = [];
  BigInt numberOfAddresses = BigInt.zero;
  String addressWithoutSuffixString = "";
  String suffix = "";
  String address6BinaryString = "";
  List<String> networkAdress6 = [];

  AddressIPV6(this.address6) {
    address6 = address6.replaceAll(" ", "");
    List<String> addressList = address6.split("/");

    if (addressList.length != 2) {
      throw MyException("Erreur : format CIDR IPv6 invalide", address6);
    }

    addressWithoutSuffixString = addressList[0];
    suffix = addressList[1];

    if (addressWithoutSuffixString.isEmpty) {
      throw MyException("Erreur : adresse IPv6 vide", address6);
    }

    if (suffix.isEmpty || !isValidIPv6Suffix(suffix)) {
      throw MyException("Erreur : suffixe IPv6 invalide", address6);
    }

    if (!addressWithoutSuffixString.isValidIPv6) {
      throw MyException("Erreur : adresse IPv6 invalide", addressWithoutSuffixString);
    }

    final int hostBits = 128 - int.parse(suffix);
    numberOfAddresses = BigInt.one << hostBits;

    address6WithoutSuffixListString = formatIPV6WithoutSuffix(addressWithoutSuffixString);
    address6ListString = [...address6WithoutSuffixListString, suffix];
    address6BinaryString = hexListToBinaryString(address6WithoutSuffixListString);
    networkAdress6 = networkAddress6ListString(address6ListString);
    print("network : $networkAdress6");
  }

  /// Fills each hextet with leading zeros and uppercases it
  static List<String> fourDigitsAddressIPV6(List<String> address) =>
      address.map((e) => e.toUpperCase().padLeft(4, '0')).toList();

  static List<String> simplifiesAddressIPV6(List<String> address) =>
      address.map((e) => int.parse(e, radix: 16).toRadixString(16)).toList();

  /// Returns true if the given string is a valid IPv6 prefix length (0–128)
  static bool isValidIPv6Suffix(String cidr) {
    int? i = int.tryParse(cidr);
    return i != null && i >= 0 && i <= 128;
  }

  /// CIDR suffix remover (String)
  static String cidrSuffixRemover(String cidr) => cidr.split('/')[0];

  static String cidrSuffixGetter(String cidr) => cidr.split('/')[1];

  /// Formats a condensed IPv6 address into a full 8-hextet list of strings
  static List<String> formatIPV6WithoutSuffix(String address) {
    if (address.contains("::")) {
      int count = 0;
      List<String> addressPart0 = [], addressPart1 = [];
      List<String> addressParts = address.split("::");
      if (addressParts[0] != "") {
        addressPart0 = addressParts[0].split(":");
        count += addressPart0.length;
      }
      if (addressParts[1] != "") {
        addressPart1 = addressParts[1].split(":");
        count += addressPart1.length;
      }

      for (int i = 0; i < 8 - count; i++) {
        addressPart0.add("0000");
      }

      return fourDigitsAddressIPV6(addressPart0 + addressPart1);
    }
    return fourDigitsAddressIPV6(address.split(":"));
  }

  /// Converts a list of hexadecimal hextets into a 128-bit binary string
  static String hexListToBinaryString(List<String> address) {
    final List<String> addressWithoutSuffix = address.length == 9 ? address.sublist(0, 8) : List<String>.from(address);
    String s = addressWithoutSuffix.join("");
    return s
        .split('')
        .map((c) {
          int value = int.parse(c, radix: 16);
          return value.toRadixString(2).padLeft(4, '0');
        })
        .join('');
  }

  /// From a list of hex strings WITH SUFFIX returns the network address as a hextet list
  static List<String> networkAddress6ListString(List<String> address) {
    if (address.length != 9) {
      throw MyException("Erreur : format interne IPv6 invalide", address.toString());
    }

    final List<String> addressCopy = List<String>.from(address);
    final int suffix = int.parse(addressCopy.last);
    final String b = hexListToBinaryString(addressCopy).substring(0, suffix).padRight(128, '0');

    return address6BinaryStringToListString(b);
  }

  /// Converts a 128-bit binary string into a list of 8 lowercase hex hextets
  static List<String> address6BinaryStringToListString(String address) {
    if (address.length != 128) {
      throw MyException("Erreur : longueur binaire IPv6 invalide", address);
    }
    String s = (int.parse(address.substring(0, 16), radix: 2)).toRadixString(16).toString().padLeft(4, '0');
    for (int i = 16; i < 128; i += 16) {
      s += ":${(int.parse(address.substring(i, i + 16), radix: 2)).toRadixString(16).toString().padLeft(4, '0')}";
    }
    return s.split(":");
  }

  /// Replaces multiple 0000 sequences in a String representing a CIDR address
  static String cidrSimplifier(String cidr) {
    String suffix = cidrSuffixGetter(cidr);
    String prefix = cidrSuffixRemover(cidr);

    // if an address has ::, to be sure that the elements of the address
    // don't begin by 0, we first replace the address by its 4 digits format
    // before compressing the address
    if (prefix.contains('::')) {
      prefix = formatIPV6WithoutSuffix(prefix).join(':');
    }
    String formattedPrefix = simplifiesAddressIPV6(prefix.split(':')).join(':');
    String s;
    List<String> l = [];
    for (int i = 7; i > 0; i--) {
      s = "0${":0" * i}"; // format style 0:0:0

      if (formattedPrefix.contains(s)) {
        l = formattedPrefix.split(s);
        // If the left part of the address has elements we remove the last :
        if (l[0].endsWith(":")) {
          l[0] = l[0].characters.skipLast(1).toString();
        }
        // If the right part of the address has elements we remove the first :
        if (l[1].startsWith(":")) {
          l[1] = l[1].substring(1);
        }
        return "${l[0]}::${l[1]}/$suffix";
      }
    }
    return "$formattedPrefix/$suffix";
  }

  /// Converts a MAC address to the 64-bit interface identifier used in IPv6 (EUI-64 style).
  ///
  /// Accepted input formats:
  /// - classic with separators: `00:1A:2B:3C:4D:5E` or `00-1A-2B-3C-4D-5E`
  /// - Cisco style: `001A.2B3C.4D5E`
  /// - raw 12-hex format: `001A2B3C4D5E`
  ///
  /// The output is normalized in uppercase grouped as `XXXX:XXXX:XXXX:XXXX`.
  /// Throws [MyException] when the input is not a valid MAC format.
  static String macConversion(String macAddress) {
    macAddress = macAddress.trim().toUpperCase();
    if (!macAddress.isValidMACAddress) {
      throw MyException("Erreur : format interne IPv6 invalide", macAddress);
    }
    macAddress = macAddress.replaceAll(":", "");
    macAddress = macAddress.replaceAll("-", "");
    macAddress = macAddress.replaceAll(".", "");
    macAddress = macAddress.insert(6, "FFFE");
    macAddress = macAddress.insert(4, ":");
    int val = int.parse(macAddress.substring(0, 2), radix: 16);
    int valReversed = val ^ 2;
    String newHex = valReversed.toRadixString(16).padLeft(2, '0');
    macAddress = newHex + macAddress.substring(2);

    return macAddress;
  }
}
