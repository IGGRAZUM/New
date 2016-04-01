$regfile = "m8def.dat"                                      ' используем ATmega8
$crystal = 8000000
$baud = 38400
Dim Shagi As Dword : Shagi = 103

Led Alias Portb.1 : Config Led = Input : Reset Led

Holl Alias Pind.5 : Config Holl = Input
Pist Alias Pind.7 : Config Pist = Input
Button Alias Pind.6 : Config Button = Input
Reley Alias Portc.4 : Reset Reley : Config Reley = Output
'\\\\\\\Шаговый двиготель\\\\

Config Submode = New : $include "28BYJ-48.inc"
N1 Alias Portc.3 : Config N1 = Output
N2 Alias Portc.2 : Config N2 = Output
N3 Alias Portc.1 : Config N3 = Output
N4 Alias Portc.0 : Config N4 = Output
Shag_const = 1                                              '1=без полушага
T = 4
Dim T2 As Word : T2 = 750
Dim C As Byte : C = 0
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Wait 3
Print " Igra Razuma"
Print "\\\\\\\\\\\\\\\"
Print "Kolonka"
Print "Full OK!"
Wait 1
Print "\\Start kalibr\\"

Set Led
Do
If Holl = 0 Then
Shag_no
Exit Do
Else
28byj 0 , 0 : Waitms 3
End If
Loop
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Print "\\Kalibr OK!\\"
Wait 1
Print "Start program"

Wait 1
Do
For C = 0 To 18
 Print "Shag=" ; C : Set Led
   If Button = 1 Then
    If Pist = 1 Then
     28byj Shagi , 0
    Else
     Shag_no
     Do
     If C = 9 Then
     Print "Programm Ok!" : Set Reley : Waitms 500
      Else
       Reset Reley
       End If
      If Pist = 1 Then
       Reset Reley : 28byj Shagi , 0 : Exit Do
      End If
     Loop
    End If
    Shag_no : Waitms T2
   Else
    Do
    If Button = 0 Then Shag_no Else Exit Do
    Loop
    28byj Shagi , 0 : Shag_no : Waitms T2
   End If
Next C
Reset Led :
Print "\\Start kalibr\\"
Do
If Holl = 0 Then Exit Do Else 28byj 0 , 0
Loop
Print "\\Kalibr OK!\\"
C = 0 : Shag_no : Waitms T2
Loop
End