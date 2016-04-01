
void drawAllData() {
    Serial.print( "INJ " );
    Serial.println(String( getOBDdata(OBD_INJ)));

     Serial.print("IGN ");
    Serial.println(String(getOBDdata(OBD_IGN)));

     Serial.print("IAC ");
    Serial.println(String(getOBDdata(OBD_IAC)));

     Serial.print( "RPM ");
    Serial.println(String(getOBDdata(OBD_RPM)));

     Serial.print( "MAP " );
    Serial.println(String(getOBDdata(OBD_MAP)));

     Serial.print(  "ECT ");
    Serial.println(String(getOBDdata(OBD_ECT)));

     Serial.print(  "TPS ");
    Serial.println(String(getOBDdata(OBD_TPS)));

     Serial.print( "SPD ");
    Serial.println(String(getOBDdata(OBD_SPD)));

} // end void drawalldata


void drawFlagsBinnary() {  
    Serial.print( "Flag1");
    Serial.println( String(getOBDdata(11), BIN));
    Serial.print( "Flag1");
    Serial.println( String(getOBDdata(12), BIN));
} // end void



