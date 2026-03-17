class MyException implements Exception {
  final String error;
  final String incorrectElement;

  MyException(this.error, this.incorrectElement);

  @override
  String toString() {
    return error + ((incorrectElement != "") ? " : $incorrectElement" : "");
  }
}

