import 'package:calculators/tools/ip/adresse.dart';
import 'package:calculators/utils/extensions/extensions.dart';
import '../MyException.dart';

void main() {
  String address = "20001:db8::acd:1234::/64";
  print (address);
  AddressIPV6 addressIPV6 = AddressIPV6(address);
  if (addressIPV6.isValidIPv6CIDRSimple(address)) {
    print("adresse valide (RegExp)");
  } else {
    print("adresse invalide (RegExp)");
  }
  addressIPV6.string_to_list_strings_IPV6();
}

class AddressIPV6 {
  String address6 = "";

  AddressIPV6(this.address6);

  bool isValidIPv6CIDRSimple(String cidr) {
    // Simple RegExp
    final regex = RegExp(r'^([0-9a-fA-F:]+)\/([0-9]|[1-9][0-9]|1[01][0-9]|12[0-8])$');
    return regex.hasMatch(cidr);
  }

  String isValidIPv6Hextet (List<String> list, String cidr){
    String message = "";
    for (String hextet in list){
      if (hextet.length > 4) message += "Error : at least one hextet contains more than 4 digits.\n";
    }
    if (cidr.count("::") > 1) message += "Error : more than one zero compression in address.\n";
    return message;
  }

  void string_to_list_strings_IPV6() {
    List<String> adresseList = address6.split("/");
    List<String> adresseListTemp = adresseList[0].split(":");
    int numberOfDoublePoints = adresseListTemp.length - 1;
    print(numberOfDoublePoints);
    String suffixe = adresseList[1];
    if (adresseList[0].contains("::") && numberOfDoublePoints < 7) {
      adresseList[0] = adresseList[0].replaceAll("::", ":::::::".substring(0, 7 - numberOfDoublePoints + 2));
      print(adresseList[0]);
    }
    adresseListTemp = adresseList[0].split(":");
    print(adresseListTemp);
    print (isValidIPv6Hextet(adresseListTemp, address6));

    for (int i = 0; i < adresseListTemp.length; ++i) {
      adresseListTemp[i] = adresseListTemp[i].toUpperCase();
      if (adresseListTemp[i] == "") {
        adresseListTemp[i] = "0000";
      } else if (adresseListTemp[i].length < 4) {
        adresseListTemp[i] = "0000".substring(0, 4 - adresseListTemp[i].length) + adresseListTemp[i];
      }
    }
    print(adresseListTemp);
  }
}
