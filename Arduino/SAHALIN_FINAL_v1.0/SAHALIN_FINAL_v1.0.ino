#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <WiFiClient.h>
#include <ESP8266mDNS.h>
//Пин подключен к SH/LD входу 74HC595
#define latchPin_595 14
//Пин подключен к ST_CP входу 74HC595
#define clockPin 16
//Пин подключен к DS входу 74HC595
#define dataPin 13

#define ledPin 2
#define trub 5
int an = 0;
int door = 3;//Дверь коридор
int pump = 2;//Подсветка трубчатой головоломки
int gud = 1;//Звонок телефона
int clock_1 = 2;
int clock_2 = 3;
int clock_3 = 4;
int clock_4 = 5;
int clock_sek = 0;
int clock_min = 59;
int clock_ch = 9;
int other1 = 0;
int other2=1;
int fl_svet = 0;
int fl_start = 0;
int fl_clock = 0;
int fl_pl = 0;
int sec_pl = 0;
int fl_tm = 0;
//Точка доступа wifi
const char* ssid = "Fixiki" ;
const char* password = "lysyedemony";
const char* name_client = "kbv";
char server_in[] = "192.168.1.39";// Доменое имя операторского ноутбука\компьютера
//char server_in[] = "Noutbook";// Доменое имя операторского ноутбука\компьютера
#define server_port 6666
// Create an instance of the server
// specify the port to listen on as an argument
// multicast DNS responder
MDNSResponder mdns;
WiFiServer server(80);
WiFiClient client;


//Для работы с регистрами
byte resByteArray[] = {0, 0, 0, 0, 0, 0, 0, 0, 0}; //с 0 по 5 shiftOut c 6 по 8 ShiftIn
byte clock_set[] = {252, 96, 218, 242, 102, 182, 190, 224, 254, 246 , 238, 110, 156, 16}; // от 0 до 9 и " А=10,Н=11,С=12",_=13
//int caseSelector;
String stringVar;
String serv_mes;
unsigned long previousMillis = 0;
// constants won't change :
const long interval = 1000;
const long interval2 = 500;
ESP8266WiFiMulti wifiMulti;
void setup() {
  HC595(0);
  analogRead(A0);
  Serial.begin(115200);
  delay(10);
  wifiMulti.addAP("Fixiki", "lysyedemony");
  wifiMulti.addAP("niko", "nikogroup");
  pinMode(trub, INPUT);
  pinMode(latchPin_595, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  // prepare GPIO2
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
  HC595(0);
   Serial.println("conecting wifi");
 while (wifiMulti.run() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
 /* WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  */
  Serial.println("");
  Serial.println("WiFi connected");
  // Set up mDNS responder:
  // - first argument is the domain name, in this example
  //   the fully-qualified domain name is "esp8266.local"
  // - second argument is the IP address to advertise
  //   we send our IP address on the WiFi network
  if (!MDNS.begin("ludoed")) {
    Serial.println("Error setting up MDNS responder!");
    while(1) { 
      delay(1000);
    }
  }
  Serial.println("mDNS responder started");
  // Start the server
  server.begin();
  Serial.println("Server started");
  // Print the IP address
   // Add service to MDNS-SD
     MDNS.addService("http", "tcp", 80);
  Serial.println(WiFi.localIP());
  digitalWrite(ledPin, LOW);
  serv_mes = "ip:" + String(WiFi.localIP()) + " name=" + name_client;
  Send_to_server(serv_mes);
}

void loop() {
  // Check if a client has connected
  WiFiClient client = server.available();
  if (!client) {
    unsigned long currentMillis = millis();
    if (currentMillis - previousMillis >= interval2 ) {
      digitalWrite(ledPin, LOW);
    }
    if (currentMillis - previousMillis >= interval) {
      // save the last time
      if (fl_pl == 1 && bitRead(resByteArray[other1],door)==1) {
        sec_pl++;
        if (sec_pl == 20) {
          // sec_pl = 0;
          plansh(0);
        }
      }

      previousMillis = currentMillis;
      serv_mes = "ADC= ";
      serv_mes += analogRead(A0);
      Serial.println(analogRead(A0));
      if (fl_start == 1) {
        if ((analogRead(A0) > 750 || fl_svet == 1) && fl_tm == 1) {
          if (fl_clock == 0) {
            digitalWrite(ledPin, HIGH);
          }
          fl_svet = 1;
          clock_out();
        } else {
          digitalWrite(ledPin, LOW);
          for (int i = clock_1; i <= clock_4; i++) {
            resByteArray[i] = 0;
          }

          clock_sek = 0;
          clock_min = 59;
          clock_ch = 9;
        }
      } else {
        fl_svet = 0;
        digitalWrite(ledPin, LOW);
        for (int i = clock_1; i <= clock_4; i++) {
          resByteArray[i] = 0;
        }
        fl_clock = 0;
        clock_sek = 0;
        clock_min = 59;
        clock_ch = 9;
        bitWrite(resByteArray[other1], gud, 0);
        bitWrite(resByteArray[other1], pump, 0);
      }
      //Send_to_server(serv_mes);

      HC595(1);
    }
    return;
  }

  while (!client.available()) {
    delay(1);
  }

  String req = client.readStringUntil('\r');
  textRefactoring(req);
  client.flush();

  String s = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<!DOCTYPE HTML>\r\n<html>\r\n<head>\r\n<meta charset=\"utf-8\">";
  s += "<title>ESP8266 SWICH</title>\r\n</head>\r\n<body>\r\n";
  serv_mes = "hc595 ";
  for (int i = 0; i < 6; i++) {
    serv_mes += String(resByteArray[i], DEC) + ",";
  }
  serv_mes += "/\r\n<br />";
  s += serv_mes;
  s += "</body></html>";
  client.print(s);
  client.stop();

}





