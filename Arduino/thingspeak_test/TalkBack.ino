
void TalkBack() { 
    if (!client.connect(host, httpPort)) {
    Serial.println("connection failed");
    return;
  }
  Send_get();
  Recent();
  return;
}

void Send_get() {
//Serial.print("connecting to ");
  //Serial.println(host);

   // We now create a URI for the request
  String url = "/talkbacks/4378/commands";
  url += streamId;
  url += "?api_key=";
  url += privateKey;
  /*url += "&value=";
  url += value;
  */
  //Serial.print("Requesting URL: ");
  //Serial.println(url);

  // This will send the request to the server
  client.print(String("GET ") + url + " HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" +
               "Connection: close\r\n\r\n");
  delay(10);  
}

void Recent() {
  int htt = 0;
  // Read all the lines of the reply from server and print them to Serial
  while (client.available()) {
    String line = client.readStringUntil('\r');
    //Serial.print("Line: ");
    //Serial.println(line);
    htt ++;
    // line += "\r\n";
    if (line.indexOf("{") != -1)  comm = line;
    //if (htt == 19)  comm = line;
    
    //Serial.println(line);
  }
  /*if (comm.length() > 1) {
    Serial.print("comm= ");
    Serial.println(comm);
    if (comm.indexOf("on") != -1) {
      val = 0;
    } else if (comm.indexOf("off") != -1) {
      val = 1;
    }
    comm = "";
    digitalWrite(2, val);
  }*/
  
  //Serial.print("Json: ");
  //Serial.println(comm);
 
  fl=0;
  while(fl==0){
  textRefactoring(comm);
  }
  comm = "";
  
  Serial.println();
  Serial.println("closing connection");
  return;
}

