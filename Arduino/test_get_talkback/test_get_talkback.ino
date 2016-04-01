/*
 TalkBack --> Arduino Yun via Wi-Fi
 
 The TalkBack App sketch is designed for the Arduino Yun connected to a
 Wi-Fi network and the Arduino 1.5.4 IDE or newer. This sketch allows the
 Arduino to request commands stored by a ThingSpeak TalkBack via the
 TalkBack API (https://thingspeak.com/docs/talkback).
  
 Getting Started with ThingSpeak:
 
   * Sign Up for New User Account - https://www.thingspeak.com/users/new
   * Create a new Channel by selecting Channels and then Create New Channel
   * Create a TalkBack by selecting Apps, TalkBack, and New TalkBack
   * Enter the TalkBack API Key in this sketch under "ThingSpeak Settings"
   * Enter the TalkBack ID in this sketch under "ThingSpeak Settings"
 
 Arduino Requirements:
 
   * Arduino Yun
   * Arduino 1.5.4 IDE or newer
   
  Network Requirements:
   * Router with Wi-Fi
   * DHCP enabled on Router
 
 Created: Jan 30, 2014 by Hans Scharler (http://www.nothans.com)
 
 Additional Credits:
 Example sketches from Arduino team, ThingSpeak and Yun Example by Tenet Technetronics
 
*/
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
String comm = "";
const char* ssid     = "Tech";
const char* password = "52905290123";

//ThingSpeak Settings 
String thingSpeakAPI = "api.thingspeak.com";
String talkBackAPIKey = "FEGCEDL7QET8W1AJ";
String talkBackID = "4378";
const int checkTalkBackInterval = 15 * 1000;    // Time interval in milliseconds to check TalkBack (number of seconds * 1000 = interval)

// Variable Setup
long lastConnectionTime = 0;
HTTPClient http;
void setup()
{
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
  // allow reuse (if server supports it)
    http.setReuse(true);
}

void loop()
{  
  // Check ThingSpeak for TalkBack Commands
  checkTalkBack();
  delay(checkTalkBackInterval);
}

void checkTalkBack()
{
    
  String talkBackCommand;
  char charIn;
  String talkBackURL =  "http://" + thingSpeakAPI + "/talkbacks/" + talkBackID + "/commands/execute?api_key=" + talkBackAPIKey;
  http.begin(talkBackURL);
  
  // Make a HTTP GET request to the TalkBack API:  
  talkBackCommand = http.GET();  
  
  
  // Turn On/Off the On-board LED
  if (talkBackCommand == "TURN_ON")
  {  
    Serial.println(talkBackCommand);
    digitalWrite(2, HIGH);
  }
  else if (talkBackCommand == "TURN_OFF")
  {      
    Serial.println(talkBackCommand);
    digitalWrite(2, LOW);
  }
  
  Serial.flush(); 
  delay(1000);
}
