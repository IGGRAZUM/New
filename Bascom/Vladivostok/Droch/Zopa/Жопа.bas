$regfile = "m8def.dat"
$crystal = 8000000
$hwstack = 64
$swstack = 64
$framesize = 64
$baud = 38400
Config Submode = New : $include "wtv020.inc"
 Busy Alias Pinc.2
Nextpin Alias Portc.1                                       'the pin number of the clock
Play Alias Portc.0                                          ' the pin number of the datapin
Resetpin Alias Portc.3                                      'The Pin Number Of The Reset
Config Nextpin = Output : Set Nextpin
Config Play = Output : Set Play
Config Resetpin = Output : Set Resetpin
Config Busy = Input : Set Busy
'Led Alias Portb.5 : Config Led = Output : Set Led

'Led_red Alias Portd.4 : Config Led_red = Output : Set Led_red
'Led_green Alias Portd.3 : Config Led_green = Output : Set Led_green
Zamok Alias Portd.3 : Config Zamok = Output : Reset Zamok

Pin1 Alias Pind.5 : Config Pin1 = Input : Set Pin1
Pin2 Alias Pind.6 : Config Pin2 = Input : Set Pin2
Pin3 Alias Pind.7 : Config Pin3 = Input : Set Pin3
Pin4 Alias Pinb.0 : Config Pin4 = Input : Set Pin4



Dim Countn As Byte , Number As String * 5 , Pins As String * 2 , Pinnum As Byte , Flag_g As Bit
Countn = 0 : Number = "" : Pinnum = 0 : Flag_g = 0

Const Slovo = "1234"

Declare Sub Knop
Declare Sub Reg
Declare Sub Isnum


Wait 1 
Print "---Govoriashie knopki---"
Print "---Igri razuma---"
Print "---Set programm---"

  Print "Start programm1"
  Print "Ok pins= " + Pin1 + "," + Pin2 + "," + Pin3 + "," + Pin4 + ","
  Do
   Reg
Knop
'Waitms 100
Loop
End



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Knop
If Pinnum > 0 Then
Pink Pinnum
If Countn = 0 And Pinnum = 1 Then
Countn = Countn + 1 : Flag_g = 1
Pins = Str(pinnum)
Print "Pin= " + Pins
Number = Number + Pins
Elseif Flag_g = 1 And Pinnum > 1 Then
Countn = Countn + 1
Pins = Str(pinnum)
Print "Pin= " + Pins
Number = Number + Pins
Else
Pins = Str(pinnum)
Print "Pin= " + Pins
Flag_g = 0 : Countn = 0 : Number = ""
End If
 'Waitms 50
If Countn = 4 Then Isnum
End If
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Reg
If Pin1 = 0 Or Pin2 = 0 Or Pin3 = 0 Or Pin4 = 0 Then
If Pin1 = 0 And Pin2 = 1 And Pin3 = 1 And Pin4 = 1 Then Pinnum = 1
If Pin1 = 1 And Pin2 = 0 And Pin3 = 1 And Pin4 = 1 Then Pinnum = 2
If Pin1 = 1 And Pin2 = 1 And Pin3 = 0 And Pin4 = 1 Then Pinnum = 3
If Pin1 = 1 And Pin2 = 1 And Pin3 = 1 And Pin4 = 0 Then Pinnum = 4
'Print "Pin= " + Pinnum
Else
Pinnum = 0
'Print "Pin= " + Pinnum
End If
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


Sub Isnum
Flag_g = 0 : Countn = 0
Print "Number= " ; Number
    Select Case Number
     Case Slovo
      Set Zamok : Pink_ok
    End Select
    Number = ""
    Return
    End Sub