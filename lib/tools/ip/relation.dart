class Relation {
  String address_A, relation_AB, address_B;

  Relation(this.address_A, this.relation_AB, this.address_B) {
    switch (relation_AB) {
      case "A_inside_B":
        print("$address_A is inside $address_B]");
        break;
      case "B_inside_A":
        print("$address_B is inside $address_A");
        break;
      case "outside":
        print("$address_A is outside $address_B");
        break;
      case "intersecting":
        print("$address_A and $address_B have intersections");
    }
  }
}
