class Relation {
  String address_A, relation_AB, address_B;

  Relation(this.address_A, this.relation_AB, this.address_B) {
    switch (relation_AB) {
      case "A_inside_B":
        print("Warning ! IP address overlap detected : $address_B contains $address_A]");
        break;
      case "B_inside_A":
        print("Warning ! IP address overlap detected : $address_A contains $address_B");
        break;
      case "outside":
        print("No overlap detected between $address_A and $address_B");
        break;
      case "overlap":
        print("Warning ! IP address overlap detected :$address_A and $address_B share common addresses");
    }
  }
}
