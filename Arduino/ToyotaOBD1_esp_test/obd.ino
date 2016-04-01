void ChangeState()
{
  //Serial.print(digitalRead(ENGINE_DATA_PIN));
  static uint8_t ID, EData[TOYOTA_MAX_BYTES];
  static boolean InPacket = false;
  static unsigned long StartMS;
  static uint16_t BitCount;
  static int statCount;
  static int byteStep;
  int state = digitalRead(ENGINE_DATA_PIN);
  digitalWrite(LED_PIN, state);

  if (InPacket == false)  {
    if (state == MY_HIGH)   {
      StartMS = millis();
    }   else   { // else  if (state == MY_HIGH)
      if ((millis() - StartMS) >= (15 * 8))   {
        StartMS = millis();
        InPacket = true;
        BitCount = 0;
      }
    } // end if  (state == MY_HIGH)
  }  else   { // else  if (InPacket == false)
    uint16_t bits = ((millis() - StartMS) + 1 ) / 8; // The +1 is to cope with slight time errors
    int statCountOld=statCount;
    statCount += bits;
    StartMS = millis();
    // process bits
    while (bits > 0)  {
      if (BitCount < 4)  {
        if (BitCount == 0)
          ID = 0;
        ID >>= 1;
        if (state == MY_LOW)  // inverse state as we are detecting the change!
         { ID |= 0x08;}
         --bits;
      } else {
        if ((BitCount == 5 && state == MY_HIGH)||(BitCount == 15 && state == MY_HIGH)) {
          InPacket = false;
          BitCount = 0;
          byteStep = 0;
          drawAllData();
          drawFlagsBinnary();
          break;
        }
        if (BitCount > 5 && BitCount < 14) {
          
        } else if (BitCount==15&& state == MY_LOW) {
         BitCount=4; 
         ++byteStep;
        }
        ++BitCount;
        --bits;
      }      
      }
      ++BitCount;      
    } // end while
  } // end (InPacket == false)
} // end void change
