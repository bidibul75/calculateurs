import 'dart:io';

void main() {
  Adresse adresse = Adresse('122.2  .33.44/2 4', 'cidr');
  print("adresse_bin : ");
  print(adresse.adresse_bin);
  print("Adresse réseau :" + adresse.masque_reseau);
  print("Adresse de diffusion :" + adresse.masque_diffusion);
  print("adresse seule : ");
  print(adresse.adresseSeule);
  print("Adresse réseau :");
  print(adresse.adresse_reseau);
  print("Adresse diffusion");
  print(adresse.adresse_diffusion);
  print("adresse réseau");
  print(adresse.adresse_bin2);
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
  int suffixe = 0, longueur = 0;
  List<dynamic> adresse_bin = [], adresseSeule = [];

  Adresse(this.adresseATraiter, this.type) {
    test();
    String resultat = traitement_regexp();
    print(resultat);
    if (resultat.substring(0, 6) == "Erreur") exit(1);
    this.adresse_bin = decoupe();
    calcul_masques();
    this.adresseSeule = this.adresse_bin.sublist(0, 4);
    conversionBinaireTableau();
    calculAdressesReseauDiffusion();
    this.adresse_reseau = chaineVersDecimal(this.adresse_reseau);
    this.adresse_diffusion = chaineVersDecimal(this.adresse_diffusion);
    this.adresse_bin2 = chaineVersDecimal(this.adresse_bin2);
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
//String decalageAdresse(String adresse, int decalage){

//}

}
