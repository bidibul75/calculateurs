// La fonction agencement_sous_reseaux calcule le meilleur agencement de sous-réseaux
// pour loger les sous-réseaux dans un espace donné avec un minimum de perte.

export function agencement_sous_reseaux(sous_reseaux, nb_adresses){
let somme_min = nb_adresses, index_min = 0, somme = 0;

// La fonction arrayCombinations provient du site :
// https://www.equinode.com/fonctions-javascript/obtenir-les-combinaisons-d-une-liste-d-elements-avec-javascript
function arrayCombinations(a) {
    var r = [],
        f = function (b, a) {
            for (var i = 0, j = a.length; i < j; i++) {
                var x = b.concat(a[i]);
                r.push(x);
                f(x, a.slice(i + 1));
            }
        };
    f([], a);
    return r;
}
let combinaisons = arrayCombinations(sous_reseaux);

console.log(combinaisons);
console.log(combinaisons[0][0]);

combinaisons.forEach((item, index) => {
    console.log("item = ", item, " index : ", index);
    somme = nb_adresses;
    item.forEach((item2, index2) => {
        console.log(item2);
        somme -= item2;
    })
    console.log("somme = ", somme);
    if (somme > 0 && somme < somme_min) {
        index_min = index;
        somme_min = somme;
    }
})
return combinaisons[index_min];
}