#include <ESP8266WiFi.h>
#include <WiFiClient.h>
//Пин подключен к ST_CP входу 74HC595
#define latchPin_595 16
//Пин подключен к SH/LD входу 74HC165
#define latchPin_165 0
//Пин подключен к CLK_INH входу 74HC165
#define clockinh_165 1
//Пин подключен к SH_CP входу 74HC595
#define clockPin 14
//Пин подключен к DS входу 74HC595
#define dataPin 13
//Пин подключен к DS входу 74HC165
#define dataPort 12

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
char server_in[] = "operator";// Доменое имя операторского ниутбука\компьютера
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
  pinMode(latchPin_595, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  pinMode(dataPort, INPUT);
  // prepare GPIO2
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  AllLow();
  HC595(0);
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
 HC165();
}

void loop(){
  // Check if a client has connected
 
  WiFiClient client = server.available();
  if (!client) {
    return;
  }  
   Serial.println("new client");
  while(!client.available()){
     unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
    // save the last time 
    previousMillis = currentMillis;
    HC165();
    if (resByteArray[5] & svet_in == svet_in || fl_svet==1){
      String poz=String(other1)+String(svet_out)+"0";
  bitrewrite(poz);
    clock_out();
    fl_svet=1;
    }  else{
    for (int i=clock_1;i<clock_4;i++){
    resByteArray[i]=0;
  }
  clock_sek=0;
  clock_min=59;
  clock_ch=9;
  HC595(1);
  }
  }
  }
}
void ByteWrite(String input) {//запись в массив
  //Serial.print("length "); //слово длина
  int inputlen = input.length();  
  for (int i = 0; i < inputlen / 3; i++) {
    String post = input.substring(i * 3, ((i * 3) + 3));
    //Serial.println(post);
    byte intvar = post.toInt(); //две строки для преобразования
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


void HC595(int wif){
  digitalWrite(latchPin_595, LOW);  // проталкиваем байт в регистр
  for (int i=4; i<=0; i--){
    shiftOut(dataPin, clockPin, MSBFIRST, resByteArray[i]); 
  }
   // "защелкиваем" регистр, чтобы байт появился на его выходах
  digitalWrite(latchPin_595, HIGH);
  if (wif ==1){
   serv_mes= "hc595 ";
  for (int i=4; i<=0; i--){
  serv_mes+=String(resByteArray[i], DEC)+",";
  }
  serv_mes+="/";
  Send_to_server(serv_mes); 
  }
}

void HC165(){//дописать защёлку на PL
  String poz="0"+String(latchPin_165)+"1";//Садим защелку на землю
  bitrewrite(poz);
  poz="0"+String(clockinh_165)+"1";//Включаем тактирование
  bitrewrite(poz);
  HC595(0);
   poz="0"+String(latchPin_165)+"0";//Подтягиваем к питанию
  bitrewrite(poz);
  HC595(0);
  for (int i=5;i<9;i++){
    resByteArray[i]=shiftIn(dataPort, clockPin, LSBFIRST);
  }
  poz="0"+String(clockinh_165)+"0"; //Отключаем тактирование
  bitrewrite(poz);
  HC595(0); 
  serv_mes= "hc165 ";
  for (int i=5;i<9;i++){
  serv_mes+=String(resByteArray[i], DEC)+",";
  }
  serv_mes+="/";
  Send_to_server(serv_mes);
}
void AllHigh(){
  for (int i=0;i<5;i++){
    resByteArray[i]=255;
  }
}
void AllLow(){
  int chngd=0;
  for (int i=0;i<5;i++){
    resByteArray[i]=0;
  }
}

void Send_to_server(String snd){ 
   if (client.connect(server_in, server_port)) {
    Serial.println("connected to server");
    // Make a HTTP request:
    client.println(snd);
    client.println("Connection: close\r\n");
  }
    // if the server's disconnected, stop the client:
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting from server.");
    client.stop();
  }
  serv_mes ="";
}

void clock_out(){
if (clock_min<2){
  if (clock_sek==59){
    clock_sek=0 ; 
    clock_min++; 
    if (clock_min == 60){
      clock_min=0;
      clock_ch++;
      String clock_str = String(clock_ch);
     int val=clock_str.length();
      if (val<2){
        int n=0;
        resByteArray[clock_1]=clock_set[n]; 
        n=clock_str.toInt();
        resByteArray[clock_2]=clock_set[n];
      }
      else{
        int n=(clock_str.substring(1,1)).toInt();
        resByteArray[clock_1]=clock_set[n];
        n=(clock_str.substring(2,1)).toInt();
        resByteArray[clock_2]=clock_set[n];
      }   
    }
  String clock_str = String(clock_min);
      int val=clock_str.length();
      if (val<2){
        int n=0;
        resByteArray[clock_3]=clock_set[n]; 
        n=clock_str.toInt();
        resByteArray[clock_4]=clock_set[n];
      }
      else{
        int n=(clock_str.substring(1,1)).toInt();
        resByteArray[clock_3]=clock_set[n];
        n=(clock_str.substring(2,1)).toInt();
        resByteArray[clock_4]=clock_set[n];
      }   
  }  
}else if(clock_min==2 && clock_ch==10){
 if (resByteArray[5] & trub == trub){
  String poz=String(other1)+String(gud)+"0";
  bitrewrite(poz);
  clock_min=59;
  clock_ch=9;
 }else{
  if(clock_sek<30){
  String poz=String(other1)+String(gud)+"1";
  bitrewrite(poz);
  }else{
   String poz=String(other1)+String(gud)+"0";
  bitrewrite(poz);
   poz=String(other1)+String(pump)+"1";
  bitrewrite(poz); 
  }
 }
}
clock_sek++;
HC595(1); 
}
