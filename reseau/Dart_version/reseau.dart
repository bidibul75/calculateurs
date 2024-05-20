import 'dart:io';

void main() {
  Adresse adresse = Adresse('122.2  .33.44/2 4', 'cidr');
  print("adresse_bin : ");
  print(adresse.adresse_bin);
  print("Adresse réseau :"+adresse.masque_reseau);
  print("Adresse de diffusion :"+adresse.masque_diffusion);
}

class Adresse {
  String adresseATraiter,
      erreur = "",
      adresse_reseau = "",
      adresse_diffusion = "",
      type,
      masque_reseau = "",
      masque_diffusion = "";
  int suffixe = 0;
  List adresse_bin = [];

  Adresse(this.adresseATraiter, this.type) {
    test();
    String resultat = traitement_regexp();
    print(resultat);
    if (resultat.substring(0, 6) == "Erreur") exit(1);
    this.adresse_bin=decoupe();
    calcul_masques();
  }

  void test() => print("adresse en début de traitement : $adresseATraiter");

  String traitement_regexp() {
    String adresseTraitee = this.adresseATraiter;
    adresseTraitee = adresseTraitee.replaceAll(" ", "");
    print(adresseTraitee);
    if (adresseTraitee.length > 18)
      return "$adresseTraitee Erreur ! l'adresse entrée comporte trop de caractères.";

    if (type == 'cidr') {
      RegExp exp = RegExp(r"^[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+[/][0-9]+");
      if (exp.firstMatch(adresseTraitee) == null) {
        return "Erreur REGEXP";
      } else {
        print("passe regexp");
        this.adresseATraiter = adresseTraitee;
        return adresseTraitee;
      }
      ;
    } else {
      RegExp exp = RegExp(r"^[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+");
      if (exp.firstMatch(adresseTraitee) == null) {
        return "Erreur REGEXP";
      } else {
        print("passe regexp");
        this.adresseATraiter = adresseTraitee;
        return adresseTraitee;
      }
      ;
    }
  }

  List decoupe() {
    adresse_bin = this.adresseATraiter.split("/");
    adresse_bin = test_nombres(adresse_bin);
    return adresse_bin;
  }

  List test_nombres(List adresse_bin) {
    suffixe = int.parse(adresse_bin[1]);
    this.suffixe = suffixe;
    if (suffixe < 0 || suffixe > 32) {
      print("Erreur : suffixe incorrect");
      exit(1);
    }
    List adresse_bin2 = adresse_bin[0].split(".");
    adresse_bin2.add(adresse_bin[1]);
    return adresse_bin2;
  }

  void calcul_masques() {
    this.masque_reseau = "1" * suffixe + "0" * (32 - suffixe);
    this.masque_diffusion = "0" * suffixe + "1" * (32 - suffixe);
  }
}

