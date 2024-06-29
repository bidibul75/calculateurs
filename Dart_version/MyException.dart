import 'dart:io';

class MyException implements Exception {

  MyException(String error, String incorrectElement){
    print("$error"+((incorrectElement!="")?" : $incorrectElement":""));
    exit(1);
  }
}