import { test_nombres } from "./test_nombres.js";
import { decimal } from "./decimal.js";
import { test_regexp } from "./test_regexp.js";
import { conversion_binaire_tableau } from "./conversion_binaire_tableau.js";

let erreur = "";
let adresses_reseau = ["192.16 8.1.0", "1 92.168.2.0", "192.0.3.0", "192.132.3.0"];
let adresses_reseau_bin = [];

//-----------------------------------------------------------------------------------------------------------------------
function chaine_vers_tableau(chaine) {
  let tableau = chaine.split(".");
  return tableau;
}

function tableau_vers_chaine(tableau) {
  let chaine = tableau.join(".");
  return chaine;
}

//-----------------------------------------------------------------------------------------------------------------------
function test_supernet(adresse) {
  let supernet = "";
  for (let i = 0; i < 32; i++) {
    for (let j = 0; j < adresse.length - 1; j++) {
      if (adresse[j][i] != adresse[j + 1][i]) return supernet;
    }
    supernet += adresse[0][i];
  }
  return supernet;
}
//------------------------------------------------------------------------------------------------------------------------
function traitement_adresse(adresse) {
  let adresses_bin_tableau = [];
  // Nettoyage et test des adresses
  for (let i = 0; i < adresses_reseau.length; i++) {
    let adresse = adresses_reseau[i];
    // Test expressions régulières
    let testRegexp = test_regexp(adresse, "adr");
    if (testRegexp.substring(0,6)=="Erreur") return testRegexp;
    else adresse=testRegexp;

    console.log("adresse en début de traitement :", adresse);

    // On transforme l'adresse en tableau
    let adresse_bin = adresse.split(".");
    let erreur = test_nombres(adresse_bin, 1);
    if (erreur != "") return erreur;
    adresse_bin = conversion_binaire_tableau(adresse_bin);
    console.log("adresse bin : ", adresse_bin);
    adresses_bin_tableau.push(adresse_bin);
  }

  for (let i = 0; i < adresses_bin_tableau.length; i++) {
    // // On convertit le tableau adresse_bin en une chaîne de caractères unique constituée des 4 nombres au format binaire :
    adresses_bin_tableau[i] = adresses_bin_tableau[i].join("");
  }

  console.log(
    "adresses_bin_tableau :",
    adresses_bin_tableau,
    "longueur : ",
    adresses_bin_tableau.length
  );

  let supernet = test_supernet(adresses_bin_tableau);
  let suffixe = supernet.length;
  console.log("supernet :", supernet, " suffixe : ", suffixe);
  supernet += "0".repeat(32 - supernet.length);
  supernet = decimal(supernet) + "/" + suffixe;
  return supernet;
}

console.log("résultat :",traitement_adresse(adresses_reseau));
