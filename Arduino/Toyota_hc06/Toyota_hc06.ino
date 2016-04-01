#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <WiFiClient.h>
#define ENGINE_DATA_PIN 2 
// pin 2
#define ENGINE_DATA_INT 2  
// for attachInterrupt
#define OBD_DATA true 
#define  MY_HIGH  HIGH 
//LOW
#define  MY_LOW   LOW 
//HIGH

#define  TOYOTA_MAX_BYTES  24
volatile uint8_t ToyotaNumBytes, ToyotaID;
volatile uint8_t ToyotaData[TOYOTA_MAX_BYTES];
volatile uint16_t ToyotaFailBit = 0;


// "names" for the OND data to make life easier
#define OBD_INJ 1 //Injector pulse width (INJ)
#define OBD_IGN 2 //Ignition timing angle (IGN)
#define OBD_IAC 3 //Idle Air Control (IAC)
#define OBD_RPM 4 //Engine speed (RPM)
#define OBD_MAP 5 //Manifold Absolute Pressure (MAP)
#define OBD_ECT 6 //Engine Coolant Temperature (ECT)
#define OBD_TPS 7 // Throttle Position Sensor (TPS)
#define OBD_SPD 8 //Speed (SPD)

// dfeine connection flag and last success packet - for lost connection function.
boolean OBDConnected;
unsigned long OBDLastSuccessPacket;

#define server_port 6666
const char* ssid = "Home inet" ;
const char* password = "5290529012";
const char* name_client = "kbv";
char server_in[] = "192.168.1.150";// Доменое имя операторского ноутбука\компьютера
WiFiClient client;
String serv_mes;
// VOID SETUP
void setup() {
  Serial.begin(115200);
  Serial.println("system Started");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  serv_mes = "ip:" + String(WiFi.localIP()) + " name=" + name_client;
  Send_to_server(serv_mes);
  // setup input and output pins
  pinMode(ENGINE_DATA_PIN, INPUT); // _PULLUP
  //setup Interrupt for data line
  attachInterrupt(ENGINE_DATA_INT, ChangeState, CHANGE);
          
} // END VOID SETUP


// VOID LOOP
void loop() {
  
  if (ToyotaNumBytes > 0)  {
   
if (OBD_DATA)  { 
    debugdataoutput();  }
     // set last success 
     OBDLastSuccessPacket = millis();
     // set connected to true
     OBDConnected = true;
     // reset the counter.
     ToyotaNumBytes = 0;
  } // end if (ToyotaNumBytes > 0)
  
  // if found FAILBIT and dbug
  //if (ToyotaFailBit > 0)  { debugfaildataoutput(); } 
  
  //check for lost connection
  if (OBDLastSuccessPacket + 3500 < millis() && OBDConnected) {
     OBDConnected = false;
  } // end if loas conntcion
} // end void loop 


// GET DATA FROM OBD
float getOBDdata(int OBDdataIDX) {
 // define return value
  float returnValue;
  switch (OBDdataIDX) {
    case 0:// UNKNOWN
        returnValue = ToyotaData[0]; 
        break;
    case OBD_INJ: //  Injector pulse width (INJ) - in milisec
        returnValue = ToyotaData[OBD_INJ]/10;
        break;
    case OBD_IGN: // Ignition timing angle (IGN) - degree- BTDC
        returnValue = ToyotaData[OBD_IGN]-90;
        break;
    case OBD_IAC: //Idle Air Control (IAC) - Step # X = 125 = open 100%
        returnValue = ToyotaData[OBD_IAC]/125*100;
         break;
     case OBD_RPM: //Engine speed (RPM)
         returnValue = ToyotaData[OBD_RPM]*25;
         break; 
     case OBD_MAP: //Manifold Absolute Pressure (MAP) - kPa Abs
         returnValue = ToyotaData[OBD_MAP];
          break;  
    case OBD_ECT: // Engine Coolant Temperature (ECT)
          if (ToyotaData[OBD_ECT] >= 244)
            returnValue = ((float)(ToyotaData[OBD_ECT] - 244) * 10.0) + 132.0;
          else if (ToyotaData[OBD_ECT] >= 238)
            returnValue = ((float)(ToyotaData[OBD_ECT] - 238) * 4.0) + 103.0;
          else if (ToyotaData[OBD_ECT] >= 228)
            returnValue = ((float)(ToyotaData[OBD_ECT] - 228) * 2.1) + 80.0;
          else if (ToyotaData[OBD_ECT] >= 210)
            returnValue = ((float)(ToyotaData[OBD_ECT] - 210) * 1.11) + 60.0;
          else if (ToyotaData[OBD_ECT] >= 180)
            returnValue = ((float)(ToyotaData[OBD_ECT] - 180) * 0.666) + 40.0;
          else if (ToyotaData[OBD_ECT] >= 135)
            returnValue = ((float)(ToyotaData[OBD_ECT] - 135) * 0.444) + 20.0;
          else if (ToyotaData[OBD_ECT] >= 82)
            returnValue = ((float)(ToyotaData[OBD_ECT] - 82) * 0.377) + 0.0;
          else if (ToyotaData[OBD_ECT] >= 39)
            returnValue = ((float)(ToyotaData[OBD_ECT] - 39) * 0.465) + (-20.0);
          else if (ToyotaData[OBD_ECT] >= 15)
            returnValue = ((float)(ToyotaData[OBD_ECT] - 15) * 0.833) + (-40.0);
          else
            returnValue = ((float)ToyotaData[OBD_ECT] * 2.0) + (-70.0);
       
         break;  
    case OBD_TPS: // Throttle Position Sensor (TPS) - DEGREE
         returnValue = ToyotaData[OBD_TPS]/2;
         break;       
    case OBD_SPD: // Speed (SPD) - km/h
         returnValue = ToyotaData[OBD_SPD];
         break; 
    case 9:// UNKNOWN
        returnValue = ToyotaData[9]; 
        break;
    case 10:// UNKNOWN
        returnValue = ToyotaData[10]; 
        break;   
    case 11:// FLAG #1
        returnValue = ToyotaData[11]; 
        break;
    case 12:// FLAG # 2
        returnValue = ToyotaData[12]; 
        break;   
    default: // DEFAULT CASE (in no match to number)
      // send "error" value
      returnValue =  9999.99;
   } // end switch
  // send value back
  return returnValue;
} // end void getOBDdata

// VOID CHANGE 
void ChangeState()
{
  //Serial.print(digitalRead(ENGINE_DATA_PIN));
  static uint8_t ID, EData[TOYOTA_MAX_BYTES];
  static boolean InPacket = false;
  static unsigned long StartMS;
  static uint16_t BitCount;

  int state = digitalRead(ENGINE_DATA_PIN);
  
  if (InPacket == false)  {
    if (state == MY_HIGH)   {
      StartMS = millis();
     }   else   { // else  if (state == MY_HIGH)  
       if ((millis() - StartMS) > (15 * 8))   {
          StartMS = millis();
          InPacket = true;
          BitCount = 0;
      } // end if  ((millis() - StartMS) > (15 * 8))  
    } // end if  (state == MY_HIGH) 
  }  else   { // else  if (InPacket == false)  
    uint16_t bits = ((millis() - StartMS)+1 ) / 8;  // The +1 is to cope with slight time errors
    StartMS = millis();
    // process bits
    while (bits > 0)  {
      if (BitCount < 4)  {
        if (BitCount == 0)
          ID = 0;
        ID >>= 1;
        if (state == MY_LOW)  // inverse state as we are detecting the change!
          ID |= 0x08;
      }   else    { // else    if (BitCount < 4) 
        uint16_t bitpos = (BitCount - 4) % 11;
        uint16_t bytepos = (BitCount - 4) / 11;
        if (bitpos == 0)      {
 
          // Start bit, should be LOW
           if ((BitCount > 4) && (state != MY_HIGH))  { // inverse state as we are detecting the change!
               ToyotaFailBit = BitCount;
               InPacket = false;
               break;
            } // end if ((BitCount > 4) && (state != MY_HIGH)) 
 
        }  else if (bitpos < 9)  { //else TO  if (bitpos == 0)  
      
           EData[bytepos] >>= 1;
           if (state == MY_LOW)  // inverse state as we are detecting the change!
               EData[bytepos] |= 0x80;
        
       } else { // else if (bitpos == 0) 
          
          // Stop bits, should be HIGH
          if (state != MY_LOW)  { // inverse state as we are detecting the change!
            ToyotaFailBit = BitCount;
            InPacket = false;
            break;
          } // end if (state != MY_LOW) 
          
          if ( (bitpos == 10) && ((bits > 1) || (bytepos == (TOYOTA_MAX_BYTES - 1))) ) {
            ToyotaNumBytes = 0;
            ToyotaID = ID;
            for (int i=0; i<=bytepos; i++)
              ToyotaData[i] = EData[i];
            ToyotaNumBytes = bytepos + 1;
            if (bits >= 15)  // Stop bits of last byte were 1's so detect preamble for next packet
              BitCount = 0;              
            else  {
              ToyotaFailBit = BitCount;
              InPacket = false;
            }
            break;
          }
        }
      }
      ++BitCount;
      --bits;
    } // end while
  } // end (InPacket == false)  
} // end void change




// DEBUG OUTPUT VOIDS 



void debugfaildataoutput() {
        Serial.print("FAIL = ");
        Serial.print(ToyotaFailBit);
        if (((ToyotaFailBit - 4) % 11) == 0)
        Serial.print(" (StartBit)");
        else if (((ToyotaFailBit - 4) % 11) > 8)
        Serial.print(" (StopBit)");
        Serial.println(".");
        ToyotaFailBit = 0;
} // end void
