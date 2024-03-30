// La fonction fait un test des expressions régulières et renvoit soit le message d'erreur
// soit l'extraction de l'adresse
// (cas d'une adresse à tester qui comporterait des caractères non décimaux en début ou en fin de chaîne).

export function test_regexp(adresse, type) {
  //On supprime tous les espaces, tabulations et retours ligne éventuels
  adresse = adresse.replace(/\s+/g, "");

  let bon_format = "";

  if (type == "cidr") {
    bon_format = /\d+[.]\d+[.]\d+[.]\d+[/]\d/g;
  } else {
    bon_format = /\d+[.]\d+[.]\d+[.]\d/g;
  }
  let concordance = bon_format.test(adresse);
  if (concordance) {
    concordance = adresse.match(bon_format);
    concordance = concordance[0];
  } else {
    concordance = "Erreur ! L'adresse entrée comporte une erreur REGEXP";
  }

  return concordance;
};

