// IPV4 mask calculator

import 'dart:io';

void main() {
  Adresse adresse = Adresse('192.16.18.1/8');
  print("Masque réseau :");
  print(adresse.masque_reseau);
  print("Masque inverse :");
  print(adresse.masque_diffusion);
  print("Adresse réseau :");
  print(adresse.adresse_reseau);
  print("Adresse diffusion");
  print(adresse.adresse_diffusion);
  print("Première adresse réseau");
  print(adresse.premiereAdresseReseau);
  print("Dernière adresse réseau");
  print(adresse.derniereAdresseReseau);
  print("Nombre d'adresses");
  print(adresse.nombreAdressesDisponibles);
  print("Adresse binaire :");
  print(adresse.adresse_bin2);
}

class Adresse {
  String adresseATraiter,
      erreur = "",
      adresse_reseau = "",
      adresse_diffusion = "",
      masque_reseau = "",
      masque_diffusion = "",
      adresse_bin2 = "";
  int suffixe = 0, longueur = 0, valeurTemp = 0, nombreAdressesDisponibles = 0;
  List<dynamic> adresse_bin = [],
      adresseSeule = [],
      adresseReseauTableau = [],
      adresseDiffusionTableau = [],
      premiereAdresseReseau = [],
      derniereAdresseReseau = [];

  Adresse(this.adresseATraiter) {
    test();
    String resultat = traitement_regexp();
    if (resultat.substring(0, 6) == "Erreur") exit(1);
    this.adresse_bin = decoupe();
    calcul_masques();
    this.adresseSeule = this.adresse_bin.sublist(0, 4);
    conversionBinaireTableau();
    calculAdressesReseauDiffusion();
    this.adresse_reseau = chaineVersDecimal(this.adresse_reseau);
    this.adresse_diffusion = chaineVersDecimal(this.adresse_diffusion);
    this.adresseReseauTableau = chaineVersTableau(this.adresse_reseau);
    this.adresseDiffusionTableau = chaineVersTableau(this.adresse_diffusion);

    this.premiereAdresseReseau = this.adresseReseauTableau.sublist(0);
    this.derniereAdresseReseau = this.adresseDiffusionTableau.sublist(0);
    this.nombreAdressesDisponibles = 0;

    if (this.suffixe < 31) {
      this.premiereAdresseReseau =
          decalageAdresse(this.premiereAdresseReseau, 1);
      this.derniereAdresseReseau =
          decalageAdresse(this.derniereAdresseReseau, -1);
      this.nombreAdressesDisponibles = calculAdressesDisponibles();
    }

    this.masque_reseau = chaineVersDecimal(this.masque_reseau);
    this.masque_diffusion = chaineVersDecimal(this.masque_diffusion);
  }

  void test() => print("adresse en début de traitement : $adresseATraiter");

  String traitement_regexp() {
    String adresseTraitee = this.adresseATraiter;
    adresseTraitee = adresseTraitee.replaceAll(" ", "");
    print(adresseTraitee);
    if (adresseTraitee.length > 18) {
      return "Erreur ! l'adresse entrée comporte trop de caractères.";
    }
    RegExp exp = RegExp(r"^[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+[/][0-9]+");
    if (exp.firstMatch(adresseTraitee) == null) {
      return "Erreur REGEXP";
    } else {
      print("passe regexp");
      this.adresseATraiter = adresseTraitee;
      return adresseTraitee;
    }
  }

  List<dynamic> decoupe() {
    adresse_bin = this.adresseATraiter.split("/");
    adresse_bin = test_nombres(adresse_bin);
    return adresse_bin;
  }

  List<dynamic> test_nombres(List adresse_bin) {
    suffixe = int.parse(adresse_bin[1]);
    this.suffixe = suffixe;
    if (suffixe < 0 || suffixe > 32) {
      print("Erreur : suffixe incorrect");
      exit(1);
    }
    List<dynamic> adresse_bin2 = adresse_bin[0].split(".");
    for (int i = 0; i < 4; i++) {
      if (int.parse(adresse_bin2[i]) < 0 || int.parse(adresse_bin2[i]) > 255) {
        print("L'adresse comporte une erreur sur un(des) nombres.");
        exit(1);
      }
    }
    adresse_bin2.add(adresse_bin[1]);
    return adresse_bin2;
  }

  void calcul_masques() {
    this.masque_reseau = "1" * suffixe + "0" * (32 - suffixe);
    this.masque_diffusion = "0" * suffixe + "1" * (32 - suffixe);
  }

  void conversionBinaireTableau() {
    for (int i = 0; i < 4; i++) {
      this.adresseSeule[i] = (int.parse(this.adresseSeule[i])).toRadixString(2);
      longueur = this.adresseSeule[i].length;
      this.adresseSeule[i] = "0" * (8 - longueur) + this.adresseSeule[i];
    }
  }

  void calculAdressesReseauDiffusion() {
    this.adresse_bin2 = this.adresseSeule.join("");
    this.adresse_reseau = "";
    this.adresse_diffusion = "";
    for (int i = 0; i < 32; i++) {
      this.adresse_reseau +=
          (int.parse(this.adresse_bin2[i]) & int.parse(this.masque_reseau[i]))
              .toString();
      this.adresse_diffusion += (int.parse(this.adresse_bin2[i]) |
              int.parse(this.masque_diffusion[i]))
          .toString();
    }
  }

  static String chaineVersDecimal(String chaine) {
    String chaineDecimale = "";
    for (int i = 0; i < 32; i += 8) {
      chaineDecimale +=
          (int.parse(chaine.substring(i, i + 8), radix: 2)).toString();
      if (i != 24) chaineDecimale += ".";
    }
    return chaineDecimale;
  }

  List<dynamic> chaineVersTableau(String chaine) {
    return chaine.split(".");
  }

  String tableauVersChaine(List tableau) {
    return tableau.join(".");
  }

  int calculAdressesDisponibles() {
    int nbAdressesDisponibles = 1, ecart;
    for (int i = 0; i < 4; i++) {
      ecart = int.parse(this.adresseDiffusionTableau[i]) -
          int.parse(this.adresseReseauTableau[i]);
      if (ecart != 0) nbAdressesDisponibles *= (ecart + 1);
    }
    return nbAdressesDisponibles;
  }

  List decalageAdresse(List<dynamic> adresse, int decalage) {
    for (int i = 3; i > -1; i--) {
      if (decalage == -1 && adresse[i] == "0") {
        adresse[i] = "255";
        continue;
      }
      if (decalage == 1 && adresse[i] == "255") {
        adresse[i] = "0";
        continue;
      }
      adresse[i] = (int.parse(adresse[i]) + decalage).toString();
      return adresse;
    }
    print(
        "Erreur : décalage impossible car en dehors de la plage 0.0.0.0 / 255.255.255.255.");
    return adresse;
  }
}
