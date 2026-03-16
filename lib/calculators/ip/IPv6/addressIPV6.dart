import 'package:calculators/utils/extensions/extensions.dart';
import 'package:calculators/utils/my_exception.dart';

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
  static List<String> cleanAddressIPV6(List<String> address) =>
      address.map((element) => element.toUpperCase().padLeft(4, '0')).toList();

  /// Returns true if the given string is a valid IPv6 prefix length (0–128)
  static bool isValidIPv6Suffix(String cidr) {
    int? i = int.tryParse(cidr);
    return i != null && i >= 0 && i <= 128;
  }

  /// Formats a condensed IPv6 address into a full 8-hextet list of strings
  static List<String> formatIPV6WithoutSuffix(String address) {
    if (address == "::1") {
      return ["0000", "0000", "0000", "0000", "0000", "0000", "0000", "0001"];
    }
    if (address == "::") {
      return ["0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000"];
    }

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

      return cleanAddressIPV6(addressPart0 + addressPart1);
    }
    return cleanAddressIPV6(address.split(":"));
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
}
