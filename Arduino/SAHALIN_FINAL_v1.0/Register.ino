void AllHigh() {
  for (int i = 0; i < 6; i++) {
    resByteArray[i] = 255;
  }
}
void AllLow() {
  int chngd = 0;
  for (int i = 0; i < 6; i++) {
    resByteArray[i] = 0;
  }
}
void HC595(int wif) {
  digitalWrite(clockPin, LOW);
  digitalWrite(latchPin_595, LOW);  // проталкиваем байт в регистр
  for (int i = 5; i >= 0; i--) {
    shiftOut(dataPin, clockPin, MSBFIRST, resByteArray[i]);
  }
  //digitalWrite(clockPin, LOW);
  // "защелкиваем" регистр, чтобы байт появился на его выходах
  digitalWrite(latchPin_595, HIGH);
  if (wif == 1) {
    serv_mes = "hc595 ";
    for (int i = 0; i < 6; i++) {
      serv_mes += String(resByteArray[i], DEC) + ",";
    }
    serv_mes += "/";
    //Send_to_server(serv_mes);
    //serv_mes += "\r\noth " + String(digitalRead(trub)) + String(digitalRead(ledPin)) + String(fl_start);
   // serv_mes += "\r\nADC= ";
    //  serv_mes += analogRead(A0);
    Send_to_server(serv_mes);
  }
   if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting from server.");
    client.stop();
  }
}
void ByteWrite(String input) {//запись в массив
  //Serial.print("length "); //слово длина
  int inputlen = input.length();
  for (int i = 0; i < inputlen / 3; i++) {
    String post = input.substring(i * 3, ((i * 3) + 3));
    //Serial.println(post);
    byte intvar = post.toInt(); //две строки для преобразования
    resByteArray[i] = intvar;//
  }
}
void bitrewrite(String input) {
  int len  = input.length();
  for (int i = 0; i < len / 3; i++) {
    String post = input.substring(i * 3, ((i * 3) + 3));
    int x = (post.substring(0, 1)).toInt();
    int y = (post.substring(1, 2)).toInt();
    int val = (post.substring(2, 3)).toInt();
    bitWrite(resByteArray[x], y, val);
  }
}
void plansh(int pl) {
  fl_pl = pl;
  sec_pl = 0;
  fl_tm=pl;
  fl_clock = pl;
  bitWrite(resByteArray[other1], door, pl);
  bitWrite(resByteArray[other1], pump, pl);
}
void start(String input) {
  fl_start = input.toInt();
  if (fl_start == 0) {
    resByteArray[other1] = 0; 
    resByteArray[other2] = 0;   
  }
   resByteArray[other1] = 0; 
    resByteArray[other2] = 0;   
  fl_tm=fl_start;
  }

