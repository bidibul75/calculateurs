export function test_nombres(adresse_bin, suffixe) {
  let message_erreur = "";
  if (suffixe < 0 || suffixe > 32) message_erreur = "Erreur sur le suffixe. <br>";
  if (adresse_bin.length != 4)
    message_erreur = "Erreur dans le nombre d'éléments de l'adresse. <br>";
  for (let i = 0; i < 4; i++) {
    if (adresse_bin[i] < 0 || adresse_bin[i] > 255)
      message_erreur += "L'adresse comporte une erreur sur un(des) nombres.";
  }
  return message_erreur;
}