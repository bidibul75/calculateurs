// Regroupe les fonctions de validation et de nettoyage des entrées utilisateur


// La fonction fait un test des expressions régulières et renvoit soit le message d'erreur
// soit l'extraction de l'adresse
// (cas d'une adresse à tester qui comporterait des caractères non décimaux en début ou en fin de chaîne).
export function test_regexp(adresse, type) {
  //On supprime tous les espaces, tabulations et retours ligne éventuels
  adresse = adresse.replace(/\s+/g, "");
  if (adresse.length > 18) return "Erreur ! L'adresse entrée comporte trop de caractères.";
  let bon_format = "";

  if (type == "cidr") {
    bon_format = /\d+[.]\d+[.]\d+[.]\d+[/]\d+/g;
  } else {
    bon_format = /\d+[.]\d+[.]\d+[.]\d+/g;
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

// Teste les nombres qui composent l'adresse IP et le suffixe
export function test_nombres(adresse, suffixe) {
  let message_erreur = "";
  if (suffixe < 0 || suffixe > 32) message_erreur = "Erreur sur le suffixe. <br>";
  if (adresse.length != 4)
    message_erreur = "Erreur dans le nombre d'éléments de l'adresse. <br>";
  for (let i = 0; i < 4; i++) {
    if (adresse[i] < 0 || adresse[i] > 255)
      message_erreur += "L'adresse comporte une erreur sur un(des) nombres.";
  }
  return message_erreur;
}
