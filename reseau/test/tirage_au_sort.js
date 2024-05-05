// Il faut déterminer le bon espace (par exemple 40 adresses -> 64 : 2**n) :
function espaceCompatible(a) {
    for (let i = 2; true; i *= 2) {
      if (i >= a) return i;
    }
  }
  
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
  
  var sousReseaux = [40, 20, 5, 1,1,1,1,110, 25];
  console.log ("avant traitement ",sousReseaux);

// var a = ["a", "b", "c", "d"];
sousReseaux.forEach((item, index)=>{
    item=espaceCompatible(Number(item));
    sousReseaux[index]=item;
});
console.log ("après traitement ",sousReseaux);


  
const nb_adresses = 100;
var somme_min = nb_adresses, index_min = 0, somme = 0;

// La fonction arrayCombinations provient du site :
// https://www.equinode.com/fonctions-javascript/obtenir-les-combinaisons-d-une-liste-d-elements-avec-javascript

var combinaisons = arrayCombinations(sousReseaux);

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
console.log("index min : ", index_min, "combinaison : ", combinaisons[index_min]);