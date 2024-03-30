export function conversion_binaire_tableau(adresse) {
  for (let i = 0; i < 4; i++) {
    adresse[i] = Number(adresse[i]).toString(2);
    adresse[i] = "0".repeat(8 - adresse[i].length) + adresse[i];
  }
  return adresse;
}