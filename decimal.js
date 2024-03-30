 export function decimal(chaine) {
// La fonction decimal découpe les chaînes de caractères en portions de 8 caractères,
// convertit ces chaînes au format décimal et les sépare par des points :
  let chaine_decimale = "";
  for (let i = 0; i < 32; i += 8) {
    chaine_decimale += parseInt(Number(chaine.slice(i, i + 8)), 2).toString(10);
    if (i != 24) chaine_decimale += ".";
  }
  return chaine_decimale;
}