class Relation {
  final String addressA;
  final String relationAB;
  final String addressB;

  static Relation implementationObjetRelation(String addressA, String relationAB, String addressB) {
    return Relation(addressA, relationAB, addressB);
  }

  Relation(this.addressA, this.relationAB, this.addressB);
}
