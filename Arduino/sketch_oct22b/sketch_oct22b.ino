//**************************************************************//
//  Name    : shiftOutCode, Hello World                               
//  Author  : Carlyn Maw,Tom Igoe, David A. Mellis
//  Date    : 25 Oct, 2006   
//  Modified: 21 Mar 2010 
//  Modified: 19 Feb 2011                              
//  Version : 2.0                                            
//  Notes   : Программа использует два сдвиговых регистра 74HC595
//          : для вывода значений от 0 до 255                         
//****************************************************************
 
//Пин подключен к ST_CP входу 74HC595
int latchPin = 16;
//Пин подключен к SH_CP входу 74HC595
int clockPin = 14;
//Пин подключен к DS входу 74HC595
int dataPin = 13;
 
 
 
void setup() {
  //устанавливаем режим OUTPUT
  Serial.begin(115200);
  delay(10);

  // prepare GPIO2
  pinMode(2, OUTPUT);
  digitalWrite(2, 0);
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  Serial.println("Start");
}
 
void loop() {
  // отсчитываем от 0 до 255  и отображаем значение на светодиоде
  Serial.println("Read HC595");
    for (int numberToDisplay = 0; numberToDisplay < 256; numberToDisplay++) {
    // устанавливаем синхронизацию "защелки" на LOW
    digitalWrite(latchPin, LOW);
    // передаем последовательно на dataPin
    shiftOut(dataPin, clockPin, MSBFIRST, numberToDisplay); 
 
    //"защелкиваем" регистр, тем самым устанавливая значения на выходах
    digitalWrite(latchPin, HIGH);
    // пауза перед следующей итерацией
    delay(600);
    Serial.print("numberToDisplay= ");
    Serial.println(numberToDisplay);
    if (numberToDisplay==254){
    numberToDisplay = 0;
    digitalWrite(2, 1);
    Serial.println("End");}
  }
 }


