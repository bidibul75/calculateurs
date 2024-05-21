'use strict';

import { test_regexp } from "./validation_nettoyage_entrees.js";

let erreur = "";
let adresse_reseau = "";
let adresse_diffusion = "";
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
function calcul_adresses_disponibles(adresse_diffusion, adresse_reseau) {
  adresse_reseau = chaine_vers_tableau(adresse_reseau);
  adresse_diffusion = chaine_vers_tableau(adresse_diffusion);

  let nb_adresses_disponibles = 1;
  let ecart = 0;
  for (let i = 0; i < 4; i++) {
    ecart = adresse_diffusion[i] - adresse_reseau[i];
    if (ecart != 0) nb_adresses_disponibles *= ecart + 1;
  }
  return nb_adresses_disponibles;
}

//-----------------------------------------------------------------------------------------------------------------------
// Fonction pour calculer la première adresse réseau disponible ou la dernière
// à partir des adresses réseau ou de diffusion
function decalage_adresse(adresse, decalage) {
  let adresse_reseau_tableau = chaine_vers_tableau(adresse);
  adresse_reseau_tableau[3] = String(Number(adresse_reseau_tableau[3]) + decalage
  );
  let nouvelle_adresse_reseau = tableau_vers_chaine(adresse_reseau_tableau);
  return nouvelle_adresse_reseau;
}

//------------------------------------------------------------------------------------------------------------------------
function traitement_adresse(adresse) {
 
  console.log("adresse en début de traitement :", adresse);
  // Test expressions régulières : renvoit la chaîne de caractère extraite 
  // via un match REGEXP, sinon un message d'erreur et la sortie de la fonction. 
  let testRegexp = test_regexp(adresse, "cidr");
  if (testRegexp.substring(0,6)=="Erreur") return testRegexp;
  else adresse=testRegexp;

  // éclatement de l'adresse et test des erreurs quant aux nombres de celle-ci
  let adresse_bin = adresse.split("/");
  let masque = Number(adresse_bin[1]);
  let adresse_traitee = adresse_bin[0];
  adresse_bin = adresse_traitee.split(".");
  erreur = test_nombres(adresse_bin, masque);
  adresse = adresse_bin[0];

  // si des erreurs sont trouvées on sort de la fonction
  if (erreur != "") return erreur;

  // calcul du masque réseau et générique à partir du masque
  let masque_reseau = "1".repeat(masque) + "0".repeat(32 - masque);
  let masque_generique = "0".repeat(masque) + "1".repeat(32 - masque);

  adresse_bin = conversion_binaire_tableau(adresse_bin);

  // On convertit le tableau adresse_bin en une chaîne de caractères unique constituée des 4 nombres au format binaire :
  let adresse_bin2 = adresse_bin.join("");

  // On applique les masques réseau et générique à l'adresse réseau et à l'adresse de diffusion au format binaire :
  adresse_reseau = "";
  adresse_diffusion = "";

  for (let i = 0; i < 32; i++) {
    adresse_reseau += adresse_bin2[i] & masque_reseau[i];
    adresse_diffusion += adresse_bin2[i] | masque_generique[i];
  };

  // On met en forme les adresses au format décimal séparé par des points à l'aide de la fonction decimal :
  masque_reseau = decimal(masque_reseau);
  masque_generique = decimal(masque_generique);

   // On met en forme les adresses au format décimal séparé par des points à l'aide de la fonction décimal :
  
   adresse_reseau = decimal(adresse_reseau);
 
   let premiere_adresse_reseau = decalage_adresse(adresse_reseau, 1);
 
   adresse_diffusion = decimal(adresse_diffusion);
 
   let derniere_adresse_reseau = decalage_adresse(adresse_diffusion, -1);
 
   // On calcule le nombre d'adresses IP disponibles et on affiche ce nombre selon que l'on est en mode réseau ou filtre :
   let nombre_adresses_disponibles = calcul_adresses_disponibles(
     adresse_diffusion,
     adresse_reseau
   );

erreur=`<div class="row"><div class="col-sm-3"><p>Adresse IPV4 : `+adresse_traitee+`</p>
<p>Suffixe : `+masque+`</p>
<p>Masque de réseau : `+masque_reseau+`</p>
<p>Masque inverse : `+masque_generique+`</p></div><div class="col-sm-3">
<h4>En mode réseau :</h4>
<p>Adresse réseau : `+adresse_reseau+`</p>
<p>Première adresse : `+premiere_adresse_reseau+`</p>
<p>Dernière adresse : `+derniere_adresse_reseau+`</p>
<p>Adresse de diffusion : `+adresse_diffusion+`</p>
<p>Nombre d'adresses IP disponibles : `+(nombre_adresses_disponibles-2)+`</p></div><div class="col-sm-3">
<h4>En mode filtre :</h4>
<p>Première adresse : `+adresse_reseau+`</p>
<p>Dernière adresse : `+adresse_diffusion+`</p>
<p>Nombre d'adresses IP disponibles : `+nombre_adresses_disponibles+`</p></div></div>`;

  return erreur; // retourne le fait qu'il n'y a pas d'erreur
}
//-----------------------------------------------------------------------------------------------------------------------
var dom_erreur = document.getElementById("message_erreur");
dom_erreur.innerHTML = erreur;

let clique = document.getElementById("submit").addEventListener("click", function (e) {
    e.preventDefault();
    erreur = "";
    dom_erreur.innerHTML = erreur;
    let adresse = document.getElementById("adresse");
    let adresse2 = adresse.value;

    let adresse_diffusion = "";
    let adresse_reseau = "";
    let adresse_bin = "";
    let adresse_bin2="";
    let masque_generique="";
    let masque_reseau="";

    erreur = traitement_adresse(adresse2);
    dom_erreur.innerHTML = erreur;

  });
