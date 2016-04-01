/*
 *  This sketch sends data via HTTP GET requests to data.sparkfun.com service.
 *
 *  You need to get streamId and privateKey at data.sparkfun.com and paste them
 *  below. Or just customize this script to talk to other HTTP servers.
 *
 */
#include <ArduinoJson.h>
#include <ESP8266WiFi.h>
long Id [11];
long Command_string [11];
String comm = "";
const char* ssid     = "Tech";
const char* password = "52905290123";
int fl=0;
const char* host = "api.thingspeak.com";
const char* streamId   = ".json" ;  //"/execute";
const char* privateKey = "FEGCEDL7QET8W1AJ";
WiFiClient client;
const int httpPort = 80;


void setup() {
  Serial.begin(115200);
  delay(10);

    // We start by connecting to a WiFi network

  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  pinMode(2, OUTPUT);
  digitalWrite(2, 0);
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

int value = 0;
int val = 0;


void loop() {
  delay(1500);
  TalkBack(); 
}

