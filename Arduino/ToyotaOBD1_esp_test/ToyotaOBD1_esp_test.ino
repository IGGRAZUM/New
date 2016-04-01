// ToyotaOBD1_Reader
// In order to read the data from the OBD connector, short E1 + TE2. then to read the data connect to VF1.
// Note the data line output is 12V - connecting it directly to one of the arduino pins might damage (proabably) the board
// This is made for diaply with an OLED display using the U8glib - which allow wide range of display types with minor adjusments.
// Many thanks to GadgetFreak for the greate base code for the reasding of the data.
// If you want to use invert line - note the comments on the MY_HIGH and the INPUT_PULLUP in the SETUP void.


// for debug option - swith output to Serial
#define DEBUG_OUTPUT true
// pin 2
#define ENGINE_DATA_PIN 4 
// for attachInterrupt
#define ENGINE_DATA_INT 4  
#define LED_PIN 2

// I have inverted the Eng line using an Opto-Coupler, if yours isn't then reverse these low & high defines.
//LOW
#define  MY_HIGH HIGH 
//HIGH
#define  MY_LOW LOW 

#define  TOYOTA_MAX_BYTES 24
volatile uint8_t ToyotaNumBytes, ToyotaID;
volatile uint8_t ToyotaData[TOYOTA_MAX_BYTES];
volatile uint16_t ToyotaFailBit = 0;


// "names" for the OND data to make life easier
//Injector pulse width (INJ)
#define OBD_INJ 1 
//Ignition timing angle (IGN)
#define OBD_IGN 2 
//Idle Air Control (IAC)
#define OBD_IAC 3 
 //Engine speed (RPM)
#define OBD_RPM 4
//Manifold Absolute Pressure (MAP)
#define OBD_MAP 5 
 //Engine Coolant Temperature (ECT)
#define OBD_ECT 6
// Throttle Position Sensor (TPS)
#define OBD_TPS 7 
//Speed (SPD)
#define OBD_SPD 8 

// dfeine connection flag and last success packet - for lost connection function.
boolean OBDConnected;
unsigned long OBDLastSuccessPacket;

//#define TOGGLE_BTN_PIN 3
//#define TOGGLE_BTN_INT 1
//int CurrentDisplayIDX;

// VOID SETUP
void setup() {
  Serial.begin(115200);
  if (DEBUG_OUTPUT) {
    Serial.println("system Started");
  }

  // Display no connection
  //displayNoConnection();

  // setup input and output pins
  pinMode(ENGINE_DATA_PIN, INPUT); // _PULLUP
  pinMode(LED_PIN, OUTPUT);
  //setup Interrupt for data line
  attachInterrupt(ENGINE_DATA_PIN, ChangeState, CHANGE);
//int state = digitalRead(ENGINE_DATA_PIN);
  digitalWrite(LED_PIN, MY_LOW);
  //setup button
//  pinMode(TOGGLE_BTN_PIN, INPUT);
 // attachInterrupt(TOGGLE_BTN_INT, ButtonChangeState, CHANGE);
//Serial.print("get ok: ");
 // Serial.println(digitalRead(ENGINE_DATA_PIN));
  // Set OBD to not connected
  OBDConnected = false;
  //CurrentDisplayIDX = 1; // set to display 1
} // END VOID SETUP


// VOID LOOP
void loop() {
  /*static boolean pin_key = false;
  if (digitalRead(ENGINE_DATA_PIN)==pin_key){
     digitalWrite(LED_PIN, pin_key);
    pin_key=!pin_key;
   Serial.print("pin ok: ");
  Serial.println(digitalRead(ENGINE_DATA_PIN));
  }*/
  // if found bytes
  if (ToyotaNumBytes > 0)  {
    if (DEBUG_OUTPUT) {
      debugdataoutput();
    }
    // draw screen
    //drawScreenSelector();

    // set last success
    OBDLastSuccessPacket = millis();
    // set connected to true
    OBDConnected = true;
    // reset the counter.
    ToyotaNumBytes = 0;
  } // end if (ToyotaNumBytes > 0)

  // if found FAILBIT and dbug
  if (ToyotaFailBit > 0 && DEBUG_OUTPUT )  {
    debugfaildataoutput();
  }

  //check for lost connection
  if (OBDLastSuccessPacket + 3500 < millis() && OBDConnected) {
    // show no connection
    //displayNoConnection();
    // set OBDConnected to false.
    OBDConnected = false;
  } // end if loas conntcion

} // end void loop


// VOID drawScreenSelector()
/*void drawScreenSelector() {
  if (CurrentDisplayIDX == 1) {
    drawSpeedRpm();
  } else if (CurrentDisplayIDX == 2) {
    drawAllData();
  } else if (CurrentDisplayIDX == 3) {
    drawFlagsBinnary();
  }
} // end drawScreenSelector()

*/
// VOID ButtonChangeState
/*
void ButtonChangeState() {
  int buttonState = digitalRead(TOGGLE_BTN_PIN);
  // only on HIGH ((press) and OBDConnected = true
  if (buttonState && OBDConnected ) {
    CurrentDisplayIDX += 1;
    if (CurrentDisplayIDX > 3) {
      CurrentDisplayIDX = 1;
    }
    // all screen chnage
    drawScreenSelector();
  } // end if

} // end void  ButtonChangeState()


// DEBUG OUTPUT VOIDS
*/

void debugdataoutput() {
  // output to Serial.
  Serial.print("ID=");
  Serial.print(ToyotaID);
  for (int i = 0; i < ToyotaNumBytes; i++)
  {
    Serial.print(", ");
    Serial.print(ToyotaData[i]);
  }
  Serial.println(".");
} // end void

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


