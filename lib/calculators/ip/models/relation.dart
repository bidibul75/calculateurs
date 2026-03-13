class Relation {
  String addressA, relationAB, addressB;

  Relation(this.addressA, this.relationAB, this.addressB) {
    switch (relationAB) {
      case "A_inside_B":
        print("Warning ! IP address overlap detected : $addressB contains $addressA]");
        break;
      case "B_inside_A":
        print("Warning ! IP address overlap detected : $addressA contains $addressB");
        break;
      case "outside":
        print("No overlap detected between $addressA and $addressB");
        break;
      case "overlap":
        print("Warning ! IP address overlap detected :$addressA and $addressB share common addresses");
    }
  }
}
