// Regroupe les fonctions de conversions de chaînes de caractères et de tableaux

// Convertit une chaîne de caractères contenant une adresse IP en tableau
export function chaine_vers_tableau(chaine) {
  let tableau = chaine.split(".");
  return tableau;
}

// Convertit un tableau en chaîne de caractères
export function tableau_vers_chaine(tableau) {
  let chaine = tableau.join(".");
  return chaine;
}

// Découpe les chaînes de caractères en portions de 8 caractères,
// convertit ces chaînes au format décimal et les sépare par des points
export function chaine_vers_decimal(chaine) {
  let chaine_decimale = "";
  for (let i = 0; i < 32; i += 8) {
    chaine_decimale += parseInt(Number(chaine.slice(i, i + 8)), 2).toString(10);
    if (i != 24) chaine_decimale += ".";
  }
  return chaine_decimale;
}

// Convertit un tableau composé de nombres décimaux en tableau de nombres binaires de 8 bits
export function conversion_binaire_tableau(adresse) {
  for (let i = 0; i < 4; i++) {
    adresse[i] = Number(adresse[i]).toString(2);
    adresse[i] = "0".repeat(8 - adresse[i].length) + adresse[i];
  }
  return adresse;
}