import 'package:calculators/utils/extensions/extensions.dart';

void main() {
  String address = "2001:db8:0:0:1234:1:2:3/128";
  print(address);

  AddressIPV6 addressIPV6 = AddressIPV6(address);

  print(addressIPV6.address6List);
}

/// Fills the elements of the address with 0 at the beginning
List<String> cleanAddressIPV6(List<String> address) {
  for (int i = 0; i < address.length; i++) {
    address[i] = address[i].toUpperCase();
    if (address[i].length < 4) {
      address[i] = "0000".substring(0, 4 - address[i].length) + address[i];
    }
  }
  return address;
}

bool isValidIPv6Suffix(String cidr) {
  int? i = int.tryParse(cidr);
  return (i != null && i >= 0 && i <= 128) ? true : false;
}

class AddressIPV6 {
  String address6 = "";
  List<String> address6List = [];

  AddressIPV6(this.address6) {
    List<String> addressList = address6.split("/");
    // Validate the pure IPv6 part, not the CIDR suffix.
    if (addressList.isNotEmpty && addressList[0].isValidIPv6) {
      print("adresse valide hors suffixe (regexp");
      if (addressList[1].isNotEmpty && isValidIPv6Suffix(addressList[1])) {
        print("suffixe valide");

        address6List = formatIPV6WithoutSuffix(addressList[0]);
        address6List.add(addressList[1]);
      } else {
        print("suffixe non valide");
      }
    } else {
      print("regexp : adresse invalide");
      //throw ("Error : invalid IPV6 address");
    }
  }

  /// Formats a condensed IPV6 address into a full format list of strings
  List<String> formatIPV6WithoutSuffix(String address) {
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
      print("count $count");

      for (int i = 0; i < 8 - count; i++) {
        addressPart0.add("0000");
      }

      return cleanAddressIPV6(addressPart0 + addressPart1);
    }
    return cleanAddressIPV6(address.split(":"));
  }
}
