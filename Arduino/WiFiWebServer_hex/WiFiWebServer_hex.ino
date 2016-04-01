/*
 *  This sketch demonstrates how to set up a simple HTTP-like server.
 *  The server will set a GPIO pin depending on the request
 *    http://server_ip/gpio/0 will set the GPIO2 low,
 *    http://server_ip/gpio/1 will set the GPIO2 high
 *  server_ip is the IP address of the ESP8266 module, will be 
 *  printed to Serial when the module is connected.
 */

#include <ESP8266WiFi.h>
int bitsToSend = 0;
//Пин подключен к ST_CP входу 74HC595
int latchPin = 16;
//Пин подключен к SH_CP входу 74HC595
int clockPin = 14;
//Пин подключен к DS входу 74HC595
int dataPin = 13;
String val0 = "";
const char* ssid = "Fixiki";
const char* password = "lysyedemony";

// Create an instance of the server
// specify the port to listen on as an argument
WiFiServer server(80);




void setup() {
  Serial.begin(115200);
  delay(10);
pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  // prepare GPIO2
  pinMode(2, OUTPUT);
  digitalWrite(2, 0);
  registerWrite(0,0,0);
  // Connect to WiFi network
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  
  // Start the server
  server.begin();
  Serial.println("Server started");

  // Print the IP address
  Serial.println(WiFi.localIP());
  
}

void loop() {
  // Check if a client has connected
  WiFiClient client = server.available();
  if (!client) {
    return;
  }
  
  // Wait until the client sends some data
  Serial.println("new client");
  while(!client.available()){
    delay(1);
  }
  
  // Read the first line of the request
  String req = client.readStringUntil('\r');
  int val2 = req.length();
  if  (val2 > 11){
  val2 = val2-9;
  String val1=req.substring(5,val2);
  Serial.println(val2);
  Serial.println(req);
  val0=val1;
  Serial.println(val1);
  String val5 = req.substring(5,9);
  Serial.print("val5= ");
  Serial.println(val5); 
  if (val5 == "h595"){
   String ib=val0.substring(5,6);
   Serial.print("bs= ");
   Serial.println(ib); 
   int bs=ib.toInt();
   ib=val0.substring(6,7);
   Serial.print("bt= ");
   Serial.println(ib);
   int bt=ib.toInt();
   ib=val0.substring(7,8);
   Serial.print("ur= ");
   Serial.println(ib);
   int ur=ib.toInt();
   registerWrite(bs,bt,ur);
  }
  if (val2 > 12){
    String rd=val0.substring(7);
    int hex=rd.toInt();
    Serial.print("Hex= ");
    Serial.println(hex);
    Serial.println(rd);
    

  }
  }
  else{
    Serial.println(req);
  }
  
  
  client.flush();
  
  // Match the request
  int val;
  if (req.indexOf("/gpio/0") != -1)
    val = 0;
  else if (req.indexOf("/gpio/1") != -1)
    val = 1;
  else {
    Serial.println("invalid request");
    client.stop();
    return;
  }

  // Set GPIO2 according to the request
  digitalWrite(2, val);
  Serial.print("Gpio= ");
  Serial.println(val);
  
  client.flush();

  // Prepare the response
  String s = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<!DOCTYPE HTML>\r\n<html>\r\nGPIO is now ";
  s += (val)?"high":"low";
  s += "<br />";
  s += "<h1><a href = /gpio/0>Led ON</a></h1><br />";
  s += "<h1><a href = /gpio/1>Led OFF</a></h1><br />";
 s += "</html>\n";

  // Send the response to the client
  client.print(s);
  delay(1);
  Serial.println("Client disonnected");

  // The client will actually be disconnected 
  // when the function returns and 'client' object is detroyed
}
// Этот метот записывает байт в регистр
void registerWrite(int bits, int whichPin, int whichState) {
// инициализируем и обнуляем байт

if (bits ==0){
 bitsToSend = 0;
}
else{
 // устанавливаем HIGH в соответствующем бите
  bitWrite(bitsToSend, whichPin, whichState);
} 
 digitalWrite(latchPin, 0);
  // проталкиваем байт в регистр
  shiftOut(dataPin, clockPin, MSBFIRST, bitsToSend);
 
    // "защелкиваем" регистр, чтобы байт появился на его выходах
  digitalWrite(latchPin, HIGH);
}


