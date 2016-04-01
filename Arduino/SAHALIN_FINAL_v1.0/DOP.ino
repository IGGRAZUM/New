void Send_to_server(String snd) {
  Serial.println("\nStarting connection to server...");
  if (client.connect(server_in, server_port)) {
    Serial.println("connected to server");
    // Make a HTTP request:
    client.print(snd);
    //client.println("Connection: close\r\n");
  }
  /* while (client.available()) {
     char c = client.read();
     Serial.write(c);
   }*/
  // if the server's disconnected, stop the client:
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting from server.");
    client.stop();
  }
}
void textRefactoring(String request) {
  String newResultat;
  int i = request.indexOf(' ');
  int o = request.lastIndexOf(' ');
  newResultat = request.substring(i + 2, o);
  Serial.println(newResultat);
  caseSelector(newResultat);//функция ниже
}
void caseSelector(String message) {
  int caseSelector = message.substring(0, 1).toInt();
  int messageLength = message.length();
  String input = message.substring(1, messageLength + 1);
  switch (caseSelector) {
    case 1:
      ByteWrite(input);
      break;
    case 2:
      bitrewrite(input);
      break;
    case 3:
      AllLow();
      break;
    case 4:
      AllHigh();
      break;
    case 5:
      if (fl_start == 1 && fl_clock == 1) {
        plansh(1);
      } 
      break;
    case 6:
      start(input);
      break;
    default:;
      // default
  }
}
void hourChange(int hr, int minu) {
  int hrD;
  if (hr < 10) {
    resByteArray[clock_1] = 0;
  } else {
    hrD = hr / 10;
    resByteArray[clock_1] = clock_set[hrD];
  }
  int hr0 = hr % 10;
  resByteArray[clock_2] = clock_set[hr0];
  int miD = minu / 10;
  resByteArray[clock_3] = clock_set[miD];
  int mi0 = minu % 10;
  resByteArray[clock_4] = clock_set[mi0];
}
