import 'dart:io';

void main() {
  Adresse adresse = Adresse('125.126  .128.222/8', 'cidr');
  print("adresse_bin : ");
  print(adresse.adresse_bin);
  print("Adresse réseau :");
  print(adresse.adresse_reseau);
  print("Adresse diffusion");
  print(adresse.adresse_diffusion);
  print("Adresse fournie");
  print(adresse.adresse_bin2);
  print("adresse reseau tableau");
  print(adresse.adresseReseauTableau);
  print("adresse diffusion tableau");
  print(adresse.adresseDiffusionTableau);
  print("Première adresse réseau");
  print(adresse.premiereAdresseReseau);
  print("Dernière adresse réseau");
  print(adresse.derniereAdresseReseau);
  print("nombre d'adresses");
  print(adresse.nombreAdressesDisponibles);
}

class Adresse {
  String adresseATraiter,
      erreur = "",
      adresse_reseau = "",
      adresse_diffusion = "",
      type,
      masque_reseau = "",
      masque_diffusion = "",
      adresse_bin2 = "";
  int suffixe = 0, longueur = 0, valeurTemp = 0;
  double nombreAdressesDisponibles = 0;
  List<dynamic> adresse_bin = [],
      adresseSeule = [],
      adresseReseauTableau = [],
      adresseDiffusionTableau = [],
      premiereAdresseReseau = [],
      derniereAdresseReseau = [];

  Adresse(this.adresseATraiter, this.type) {
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
    this.adresse_bin2 = chaineVersDecimal(this.adresse_bin2);
    this.adresseReseauTableau = chaineVersTableau(this.adresse_reseau);
    this.adresseDiffusionTableau = chaineVersTableau(this.adresse_diffusion);

    this.premiereAdresseReseau = this.adresseReseauTableau.sublist(0);
    this.premiereAdresseReseau = decalageAdresse(this.premiereAdresseReseau, 1);
    this.derniereAdresseReseau = this.adresseDiffusionTableau.sublist(0);
    this.derniereAdresseReseau =
        decalageAdresse(this.derniereAdresseReseau, -1);
    this.nombreAdressesDisponibles = calculAdressesDisponibles();
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
    } else {
      RegExp exp = RegExp(r"^[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+");
      if (exp.firstMatch(adresseTraitee) == null) {
        return "Erreur REGEXP";
      } else {
        print("passe regexp");
        this.adresseATraiter = adresseTraitee;
        return adresseTraitee;
      }
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

  String chaineVersDecimal(String chaine) {
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

  double calculAdressesDisponibles() {
    double nbAdressesDisponibles = 1, ecart;
    for (int i = 0; i < 4; i++) {
      ecart = double.parse(this.adresseDiffusionTableau[i]) -
          double.parse(this.adresseReseauTableau[i]);
      print(ecart);
      if (ecart != 0) nbAdressesDisponibles *= (ecart + 1);
    }
    return nbAdressesDisponibles;
  }

  List decalageAdresse(List<dynamic> adresse, int decalage) {
    int i = 3;
    valeurTemp = (int.parse(adresse[i]) + decalage);
    if (valeurTemp == -1) {
      adresse[i] = "255";
      for (int j = 2; j > 0; j--) {
        if (adresse[j] == "0") {
          adresse[j] = "255";
        } else {
          adresse[j] = (int.parse(adresse[j]) + decalage).toString();
          break;
        }
      }
    } else {
      adresse[i] = valeurTemp.toString();
    }
    return adresse;
  }
}
