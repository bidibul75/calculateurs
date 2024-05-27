'use strict';

import { chaine_vers_tableau, tableau_vers_chaine } from "./conversion_chaines_tableaux.js";

// Regroupe des traitements sur les adresses IP 

export function calcul_adresses_disponibles(adresse_diffusion, adresse_reseau) {
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
export function decalage_adresse(adresse, decalage) {
  let adresse_reseau_tableau = chaine_vers_tableau(adresse);
  adresse_reseau_tableau[3] = String(Number(adresse_reseau_tableau[3]) + decalage
  );
  let nouvelle_adresse_reseau = tableau_vers_chaine(adresse_reseau_tableau);
  return nouvelle_adresse_reseau;
}
