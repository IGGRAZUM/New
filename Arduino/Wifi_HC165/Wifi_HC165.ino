#include <ESP8266WiFi.h>
#include <WiFiClient.h>
//Пин подключен к SH/LD входу 74HC165
#define latchPin_165 16
//Пин подключен к CLK_INH входу 74HC165 Надо повтянуть к массе
//#define clockinh_165 1
//Пин подключен к SH_CP входу 74HC595
#define clockPin 14
//Пин подключен к DS входу 74HC595
//#define dataPin 13
//Пин подключен к DS входу 74HC165
#define dataPort 13

#define ledPin 2

int svet_in=1;
int svet_out=4;
int trub=2;
int ven1_out=0;
int ven2_out=1;
int ven3_out=2;
int ven4_out=3;
int ven1_in=0;
int ven2_in=1;
int ven3_in=2;
int ven4_in=3;
int pump=6;
int gud=5;
int clock_1=1;
int clock_2=2;
int clock_3=3;
int clock_4=4;
int clock_sek=0;
int clock_min=59;
int clock_ch=9;
int other1=5;
int fl_svet=0;
//Точка доступа wifi
const char* ssid = "Fixiki" ;
const char* password = "lysyedemony";
const char* name_client = "kbv";
char server_in[] = "192.168.1.39";// Доменое имя операторского ноутбука\компьютера
//char server_in[] = "NOUTBOOK";// Доменое имя операторского ноутбука\компьютера
#define server_port 6666
// Create an instance of the server
// specify the port to listen on as an argument
WiFiServer server(80);
WiFiClient client;

//Для работы с регистрами
byte resByteArray[] = {0, 0, 0, 0, 0, 0, 0, 0, 0};//с 0 по 4 shiftOut c 5 по 8 ShiftIn
byte clock_set[] = {252, 96, 218, 242, 102, 182, 190, 224, 254, 246 ,238, 110, 156};// от 0 до 9 и " А=10,Н=11,С=12"
int caseSelector;
String stringVar;
String serv_mes;
unsigned long previousMillis = 0; 
// constants won't change :
const long interval = 1000; 
void setup() {
Serial.begin(115200);
  delay(10);
  pinMode(latchPin_165, OUTPUT);
  pinMode(clockPin, OUTPUT);
  //pinMode(dataPin, OUTPUT);
  pinMode(dataPort, INPUT);
  // prepare GPIO2
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
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
 serv_mes = "ip:"+String(WiFi.localIP())+" name="+name_client;
 Send_to_server(serv_mes);
 serv_mes =",";
 HC165();
}

void loop(){
  // Check if a client has connected
     unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
    // save the last time 
    previousMillis = currentMillis;
    HC165();    
  }
}
void HC165(){//дописать защёлку на PL
  digitalWrite(clockPin, HIGH);
  digitalWrite(latchPin_165, LOW);//Садим защелку на землю
   digitalWrite(latchPin_165, HIGH);//Подтягиваем к питанию
  for (int i=5;i<9;i++){
    resByteArray[i]=shiftIn(dataPort, clockPin, MSBFIRST);
    //resByteArray[i]=shiftIn(dataPort, clockPin, LSBFIRST);
  }
  digitalWrite(clockPin, LOW);
  serv_mes=".hc165 ";
  for (int i=5;i<9;i++){
  serv_mes+=String(resByteArray[i], DEC)+",";
  }
  serv_mes+="/";
  Serial.println(serv_mes);
  Send_to_server(serv_mes);
}
void Send_to_server(String snd){ 
  Serial.println("\nStarting connection to server...");
   if (client.connect(server_in, server_port)) {
    Serial.println("connected to server");
    // Make a HTTP request:
    client.println(snd);
    //client.println("Connection: close\r\n");
  }
  while (client.available()) {
    char c = client.read();
    Serial.write(c);
  }
    // if the server's disconnected, stop the client:
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting from server.");
    client.stop();
  }  
  
}
