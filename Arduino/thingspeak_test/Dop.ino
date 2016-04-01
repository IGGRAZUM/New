void textRefactoring(String request) {
  String newResultat;
  int i = request.indexOf("{");
  if (i != -1) {
    int o = request.indexOf("}");
    newResultat = request.substring(i , o + 1);
    //Serial.println(newResultat);
    Parsing(newResultat);
    comm = request.substring(o + 1 );
  } else {
    fl = 1;
  }
  return;
}


