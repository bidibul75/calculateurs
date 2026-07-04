// lib/calculators/ip/IPv6/address_ipv6.dart
import 'package:calculators/utils/extensions/extensions.dart';
import 'package:calculators/l10n/app_localizations.dart';
import 'package:calculators/utils/my_exception.dart';
import 'package:flutter/cupertino.dart';

enum IPv6AddressType {
  loopback,
  linkLocal,
  globalUnicast,
  uniqueLocal,
  multicast,
  unspecified,
  unknown,
}

class AddressIPV6 {
  static const String errorInvalidCidrFormat = 'ipv6ErrorInvalidCidrFormat';
  static const String errorEmptyAddress = 'ipv6ErrorEmptyAddress';
  static const String errorInvalidSuffix = 'ipv6ErrorInvalidSuffix';
  static const String errorInvalidAddress = 'ipv6ErrorInvalidAddress';
  static const String errorInvalidMacFormat = 'ipv6ErrorInvalidMacFormat';

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
      throw MyException(errorInvalidCidrFormat, address6);
    }

    addressWithoutSuffixString = addressList[0];
    suffix = addressList[1];

    if (addressWithoutSuffixString.isEmpty) {
      throw MyException(errorEmptyAddress, address6);
    }

    if (suffix.isEmpty || !isValidIPv6Suffix(suffix)) {
      throw MyException(errorInvalidSuffix, address6);
    }

    if (!addressWithoutSuffixString.isValidIPv6) {
      throw MyException(errorInvalidAddress, addressWithoutSuffixString);
    }

    final int hostBits = 128 - int.parse(suffix);
    numberOfAddresses = BigInt.one << hostBits;

    address6WithoutSuffixListString = formatIPV6WithoutSuffix(addressWithoutSuffixString);
    address6ListString = [...address6WithoutSuffixListString, suffix];
    address6BinaryString = hexListToBinaryString(address6WithoutSuffixListString);
    networkAdress6 = networkAddress6ListString(address6ListString);
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
      List<String> addressPart0 = [],
          addressPart1 = [];
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
      throw StateError('Invalid internal IPv6 shape: expected 9 elements (8 hextets + suffix), got ${address.length}.');
    }

    final List<String> addressCopy = List<String>.from(address);
    final int suffix = int.parse(addressCopy.last);
    final String b = hexListToBinaryString(addressCopy).substring(0, suffix).padRight(128, '0');

    return address6BinaryStringToListString(b);
  }

  /// Converts a 128-bit binary string into a list of 8 lowercase hex hextets
  static List<String> address6BinaryStringToListString(String address) {
    if (address.length != 128) {
      throw ArgumentError.value(address.length, 'address.length', 'Expected a 128-bit IPv6 binary string.');
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
      throw MyException(errorInvalidMacFormat, macAddress);
    }
    macAddress = macAddress.replaceAll(":", "");
    macAddress = macAddress.replaceAll("-", "");
    macAddress = macAddress.replaceAll(".", "");
    macAddress = macAddress.insert(6, "FFFE");
    macAddress = macAddress.insertRep(4, ":");
    int val = int.parse(macAddress.substring(0, 2), radix: 16);
    int valReversed = val ^ 2;
    String newHex = valReversed.toRadixString(16).padLeft(2, '0');
    macAddress = newHex + macAddress.substring(2);

    return macAddress;
  }

  /// IPv6 address type indicator
  static IPv6AddressType identifyType(String address) {
    final String prefix = cidrSuffixRemover(address).trim();
    final List<String> expanded = formatIPV6WithoutSuffix(prefix);

    const String loopbackExpanded = '0000:0000:0000:0000:0000:0000:0000:0001';
    const String unspecifiedExpanded = '0000:0000:0000:0000:0000:0000:0000:0000';

    final String expandedAddress = expanded.join(':');
    if (expandedAddress == loopbackExpanded) {
      return IPv6AddressType.loopback;
    }
    if (expandedAddress == unspecifiedExpanded) {
      return IPv6AddressType.unspecified;
    }

    final int firstElement = int.parse(expanded[0], radix: 16);
    if (firstElement >= 0xFE80 && firstElement <= 0xFEBF) {
      return IPv6AddressType.linkLocal;
    }
    if (firstElement >= 0x2000 && firstElement <= 0x3FFF) {
      return IPv6AddressType.globalUnicast;
    }
    if ((firstElement & 0xFE00) == 0xFC00) {
      return IPv6AddressType.uniqueLocal;
    }
    if ((firstElement & 0xFF00) == 0xFF00) {
      return IPv6AddressType.multicast;
    }
    return IPv6AddressType.unknown;
  }

  static String typeIdentification(AppLocalizations l10n, String address) {
    return typeLabel(l10n, identifyType(address));
  }

  static String typeLabel(AppLocalizations l10n, IPv6AddressType type) {
    switch (type) {
      case IPv6AddressType.loopback:
        return l10n.ipv6TypeLoopback;
      case IPv6AddressType.linkLocal:
        return l10n.ipv6TypeLinkLocal;
      case IPv6AddressType.globalUnicast:
        return l10n.ipv6TypeGlobalUnicast;
      case IPv6AddressType.uniqueLocal:
        return l10n.ipv6TypeUniqueLocal;
      case IPv6AddressType.multicast:
        return l10n.ipv6TypeMulticast;
      case IPv6AddressType.unspecified:
        return l10n.ipv6TypeUnspecified;
      case IPv6AddressType.unknown:
        return '';
    }
  }

  static String localizeError(AppLocalizations l10n, String errorKey) {
    switch (errorKey) {
      case errorInvalidCidrFormat:
        return l10n.ipv6ErrorInvalidCidrFormat;
      case errorEmptyAddress:
        return l10n.ipv6ErrorEmptyAddress;
      case errorInvalidSuffix:
        return l10n.ipv6ErrorInvalidSuffix;
      case errorInvalidAddress:
        return l10n.ipv6ErrorInvalidAddress;
      case errorInvalidMacFormat:
        return l10n.ipv6ErrorInvalidMacFormat;
      default:
        return errorKey;
    }
  }
}

