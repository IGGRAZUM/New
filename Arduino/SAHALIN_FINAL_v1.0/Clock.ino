void clock_out() {
  if (fl_clock == 0 || digitalRead(trub) == 1) {
    hourChange(clock_ch, clock_min);
bitWrite(resByteArray[other1], gud, 0);
    if (clock_min < 2 || clock_min > 58) {
      fl_clock = 0;
      if (clock_sek >= 59) {
        clock_sek = 0 ;
        clock_min++;
      }
      if (clock_min >= 60) {
        clock_min = 0;
        clock_ch++;
      }


    } else if (clock_min == 2 && clock_ch == 10) {
      if (digitalRead(trub) == 0 && clock_sek < 30) {
        bitWrite(resByteArray[other1], gud, 0);
        clock_min = 59;
        clock_ch = 9;
        fl_clock = 0;
      } else {
        if (clock_sek < 30) {
          bitWrite(resByteArray[other1], gud, 1);
        } else {
          bitWrite(resByteArray[other1], gud, 0);
          bitWrite(resByteArray[other1], pump, 1);
          fl_clock = 1;
        }
      }
    }
  }
  if  (fl_clock == 0) {
    clock_sek++;
  } else if (fl_clock == 1 && digitalRead(trub) == 0) {
    anan(an);
    an++;
    if (an >= 10) {
      an = 0;
    }
  }
  else if (fl_clock == 1 && digitalRead(trub) == 1) {
    an = 0;
  }
}
