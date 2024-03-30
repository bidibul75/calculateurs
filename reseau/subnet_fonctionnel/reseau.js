// test erreur ne prend pas en compte lettre dans adresse

let erreur = "";
let adresse_reseau = "";
let adresse_diffusion = "";

//-----------------------------------------------------------------------------------------------------------------------
// La fonction decimal découpe les chaînes de caractères en portions de 8 caractères,
// convertit ces chaînes au format décimal et les sépare par des points :
function decimal(chaine) {
  let chaine_decimale = "";
  for (let i = 0; i < 32; i += 8) {
    chaine_decimale += parseInt(Number(chaine.slice(i, i + 8)), 2).toString(10);
    if (i != 24) chaine_decimale += ".";
  }
  return chaine_decimale;
}
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
function decalage_adresse(adresse, decalage) {
  let adresse_reseau_tableau = chaine_vers_tableau(adresse);
  adresse_reseau_tableau[3] = String(
    Number(adresse_reseau_tableau[3]) + decalage
  );
  let nouvelle_adresse_reseau = tableau_vers_chaine(adresse_reseau_tableau);
  return nouvelle_adresse_reseau;
}

//-----------------------------------------------------------------------------------------------------------------------
function test_regexp(adresse) {
  console.log("regexp");
  let erreur = "";
  bon_format = /\d+[.]\d+[.]\d+[.]\d+[/]\d+/;
  concordance = bon_format.test(adresse);
  console.log("concordance : ", concordance);
  if (!concordance) erreur += "L'adresse entrée comporte une erreur REGEXP";

  return erreur;
}
//-----------------------------------------------------------------------------------------------------------------------

function test_nombres(adresse_bin, masque) {
  let message_erreur = "";
  if (masque < 0 || masque > 32) message_erreur = "Erreur sur le masque. <br>";
  if (adresse_bin.length != 4)
    message_erreur = "Erreur dans le nombre d'éléments de l'adresse. <br>";
  for (let i = 0; i < 4; i++) {
    if (adresse_bin[i] < 0 || adresse_bin[i] > 255)
      message_erreur += "L'adresse comporte une erreur sur un(des) nombres.";
  }
  return message_erreur;
}
//------------------------------------------------------------------------------------------------------------------------
function traitement_adresse(adresse) {
  //On supprime tous les espaces, tabulations et retours ligne éventuels
  adresse = adresse.replace(/\s+/g, "");
  console.log("adresse en début de traitement :", adresse);
  // Test expressions régulières
  erreur = test_regexp(adresse);

  // si l'adresse fournie par l'utilisateur ne correspond pas au format CIDR,
  // on sort de la fonction en renvoyant le message d'erreur
  if (erreur != "") return erreur;

  // éclatement de l'adresse et test des erreurs quant aux nombres de celle-ci
  let adresse_bin = adresse.split("/");
  let masque = Number(adresse_bin[1]);
  adresse_traitee = adresse_bin[0];
  adresse_bin = adresse_traitee.split(".");
  erreur = test_nombres(adresse_bin, masque);
  adresse = adresse_traitee;
  // si des erreurs sont trouvées on sort de la fonction
  if (erreur != "") return erreur;

  document.getElementById("adresse_traitee").innerHTML = adresse_traitee;
  document.getElementById("cidr").innerHTML = masque;

  // calcul du masque réseau et générique à partir du masque
  let masque_reseau = "1".repeat(masque) + "0".repeat(32 - masque);
  let masque_generique = "0".repeat(masque) + "1".repeat(32 - masque);

  // On remplace les 4 nombres du tableau par leur valeur en binaire sous 8 caractères :
  for (let i = 0; i < 4; i++) {
    adresse_bin[i] = Number(adresse_bin[i]).toString(2);
    adresse_bin[i] = "0".repeat(8 - adresse_bin[i].length) + adresse_bin[i];
  }

  // On convertit le tableau adresse_bin en une chaîne de caractères unique constituée des 4 nombres au format binaire :
  let adresse_bin2 = adresse_bin.join("");

  // On applique les masques réseau et générique à l'adresse réseau et à l'adresse de diffusion au format binaire :
  for (let i = 0; i < 32; i++)
    adresse_reseau += adresse_bin2[i] & masque_reseau[i];
  for (let i = 0; i < 32; i++)
    adresse_diffusion += adresse_bin2[i] | masque_generique[i];

  // On met en forme les adresses au format décimal séparé par des points à l'aide de la fonction décimal :
  masque_reseau = decimal(masque_reseau);
  document.getElementById("masque_reseau").innerHTML = masque_reseau;

  masque_generique = decimal(masque_generique);
  document.getElementById("masque_inverse").innerHTML = masque_generique;

  adresse_reseau = decimal(adresse_reseau);
  document.getElementById("adresse_reseau").innerHTML = document.getElementById(
    "premiere_adresse_filtre"
  ).innerHTML = adresse_reseau;

  let premiere_adresse_reseau = decalage_adresse(adresse_reseau, 1);
  document.getElementById("premiere_adresse_reseau").innerHTML =
    premiere_adresse_reseau;

  adresse_diffusion = decimal(adresse_diffusion);
  document.getElementById("adresse_diffusion").innerHTML =
    document.getElementById("derniere_adresse_filtre").innerHTML =
      adresse_diffusion;

  let derniere_adresse_reseau = decalage_adresse(adresse_diffusion, -1);
  document.getElementById("derniere_adresse_reseau").innerHTML =
    derniere_adresse_reseau;

  // On calcule le nombre d'adresses IP disponibles et on affiche ce nombre selon que l'on est en mode réseau ou filtre :
  nombre_adresses_disponibles = calcul_adresses_disponibles(
    adresse_diffusion,
    adresse_reseau
  );
  document.getElementById("nombre_adresses_filtre").innerHTML =
    nombre_adresses_disponibles;
  document.getElementById("nombre_adresses_reseau").innerHTML =
    nombre_adresses_disponibles - 2;

  return ""; // on revoit le fait qu'il n'y a pas d'erreur
}
//-----------------------------------------------------------------------------------------------------------------------
var dom_erreur = document.getElementById("message_erreur");
dom_erreur.innerHTML = erreur;

let clique = document
  .getElementById("submit")
  .addEventListener("click", function (e) {
    e.preventDefault();
    erreur = "";
    dom_erreur.innerHTML = erreur;
    let adresse = document.getElementById("adresse");
    let adresse2 = adresse.value;

    adresse_diffusion = "";
    adresse_reseau = "";
    adresse_bin = "";
    // adresse_bin2="";

    erreur = traitement_adresse(adresse2);
    dom_erreur.innerHTML = erreur;

    if (erreur != "") {
      document.getElementsByTagName("span").innerHTML = "";
    }
  });
