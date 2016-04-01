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
void debugdataoutput() {  
  serv_mes=String(ToyotaData[0])+"," ; 
  serv_mes+=String(ToyotaData[OBD_INJ]/10)+"," ; 
  // Serial.print((float)ToyotaData[OBD_INJ]/10);
   //Serial.print(",");
   serv_mes+=String(ToyotaData[OBD_IGN]-90, DEC)+",";
   //Serial.print(ToyotaData[OBD_IGN]-90);
   //Serial.print(",");
   serv_mes+=String(ToyotaData[OBD_IAC]/125*100, DEC)+",";
   //Serial.print(ToyotaData[OBD_IAC]/125*100);
   //Serial.print(",");
   serv_mes+=String(ToyotaData[OBD_RPM]*25)+"," ; 
   //Serial.print((float)ToyotaData[OBD_RPM]*25);
   //Serial.print(",");
   serv_mes+=String(ToyotaData[OBD_MAP], DEC)+",";
   //Serial.print(ToyotaData[OBD_MAP]);
   //Serial.print(",");
float OBD_ECTi;
   if (ToyotaData[OBD_ECT] >= 244)
   OBD_ECTi = ((ToyotaData[OBD_ECT] - 244) * 10.0) + 132.0;
   else if (ToyotaData[OBD_ECT] >= 238)
            OBD_ECTi = ((ToyotaData[OBD_ECT] - 238) * 4.0) + 103.0;
          else if (ToyotaData[OBD_ECT] >= 228)
            OBD_ECTi = ((ToyotaData[OBD_ECT] - 228) * 2.1) + 80.0;
          else if (ToyotaData[OBD_ECT] >= 210)
            OBD_ECTi = ((ToyotaData[OBD_ECT] - 210) * 1.11) + 60.0;
          else if (ToyotaData[OBD_ECT] >= 180)
            OBD_ECTi = ((ToyotaData[OBD_ECT] - 180) * 0.666) + 40.0;
          else if (ToyotaData[OBD_ECT] >= 135)
            OBD_ECTi = ((ToyotaData[OBD_ECT] - 135) * 0.444) + 20.0;
          else if (ToyotaData[OBD_ECT] >= 82)
            OBD_ECTi = ((ToyotaData[OBD_ECT] - 82) * 0.377) + 0.0;
          else if (ToyotaData[OBD_ECT] >= 39)
            OBD_ECTi = ((ToyotaData[OBD_ECT] - 39) * 0.465) + (-20.0);
          else if (ToyotaData[OBD_ECT] >= 15)
            OBD_ECTi = ((ToyotaData[OBD_ECT] - 15) * 0.833) + (-40.0);
          else
            OBD_ECTi = (ToyotaData[OBD_ECT] * 2.0) + (-70.0);
   // OBD_ECTi= OBD_ECTi-32;
     //OBD_ECTi=OBD_ECTi*5/9;  
     
   serv_mes+=String(OBD_ECTi)+"," ;     
   //Serial.print((float)OBD_ECTi);
   //Serial.print(",");
   serv_mes+=String(ToyotaData[OBD_TPS]/2, DEC)+",";
   //Serial.print(ToyotaData[OBD_TPS]/2);
   //Serial.print(","); 
   serv_mes+=String(ToyotaData[OBD_SPD], DEC)+",";
   //Serial.print(ToyotaData[OBD_SPD]);   
   //Serial.print(",");
   serv_mes+=String(ToyotaData[11], DEC)+",";
   //Serial.print(ToyotaData[OBD_SPD+1]);
   //Serial.print(",");    
   serv_mes+=String(ToyotaData[12], DEC)+",";
   serv_mes+=String(ToyotaData[13], DEC)+",";   
   serv_mes+=String(ToyotaData[14], DEC)+",";
   serv_mes+=String(ToyotaData[15], DEC)+"/";
   //Serial.print(ToyotaData[OBD_SPD+2]);
   //Serial.print(","); 
//Serial.println(" ");
Send_to_server(serv_mes);
     
} // end void
