class Relation {
  final String addressA;
  final String relationAB;
  final String addressB;

  static Relation implementationObjetRelation(String addressA, String relationAB, String addressB) {
    if (relationAB=="B_inside_A") {
      return Relation(addressB, "A_inside_B", addressA);
    } else {
      return Relation(addressA, relationAB, addressB);
    }
  }

  Relation(this.addressA, this.relationAB, this.addressB);
}
