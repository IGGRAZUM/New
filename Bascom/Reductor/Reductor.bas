              $regfile = "m8def.dat"                        '??????????????? ATmega8
$crystal = 8000000
$hwstack = 40
$swstack = 40
$framesize = 40
$baud = 38400
Dim Cmnd As String * 1 , Cmnd2 As String * 1 , Inchar As String * 6 , Saddr As String * 6
Serva Alias Portb.2
Config Serva = Output

Shestern Alias Pinb.1
Config Shestern = Input

Holl Alias Pinb.0
Config Holl = Input




'Config Servos = 3 , Servo1 = Portb.0 , Servo2 = Portb.1 , Servo3 = Portd.7 , Reload = 15
Config Servos = 1 , Servo1 = Serva , Reload = 15 , Timer = Timer0

Dim F As Byte
Dim S As Byte
Dim Flag As Bit , Flag_uart As Bit , Byt As Byte : Reset Flag_uart

$eeprom
Ef:
Data 35
Es:
Data 85
$data

Readeeprom F , Ef
Readeeprom S , Es
On Urxc Getchar
Enable Urxc
Enable Interrupts
Enable Timer0
Config Timer1 = Timer , Prescale = 256
Enable Timer1
On Timer1 Tim:
Timer1 = 0
Stop Timer1

'максимум 110 минимум 32
Print "S"
Waitms 100
If Flag_uart = 1 Then
Print "F" ; F
Waitms 300
Print "L" ; S
Start Timer1
Do
If Flag_uart = 0 Then Exit Do
Loop
End If
'
Print "Closet"
Servo(1) = F
Flag = 0

Do
If Holl = 0 Then
If Shestern = 0 Then
Enable Timer0
If Flag = 0 Then Servo(1) = S
Flag = 1
Print "Open"
Timer1 = 0 : Start Timer1
Do
If Holl = 1 Then Exit Do
Loop
Enable Timer0
Else
If Flag = 1 Then
 Enable Timer0 : Servo(1) = F : Timer1 = 0 : Start Timer1
 Flag = 0
End If
Timer1 = 0 : Start Timer1
End If
Else
If Flag = 1 Then
 Enable Timer0 : Servo(1) = F : Timer1 = 0 : Start Timer1
 Flag = 0
End If

End If

Waitms 100
'Servo(1) = F
'Wait 1
'Servo(1) = I
'Wait 1
'Servo(1) = S
'Wait 1

Loop

End

Getchar:
Inchar = Inkey()
    Cmnd = Left(inchar , 1)
    If Cmnd = "s" Then
     Set Flag_uart
     End If
    Select Case Cmnd
    Case "s"
      Set Flag_uart
    Case "u"
    Enable Timer0 : Servo(1) = S : Print "O" : Timer1 = 0 : Start Timer1
    Case "l"
    Enable Timer0 : Servo(1) = F : Print "C" : Timer1 = 0 : Start Timer1
      Case "A"
      Input Inchar Noecho
      Saddr = Mid(inchar , 1 , 2)
      Byt = Val(saddr)
      F = Byt


     Case "B"
      Input Inchar Noecho
      Saddr = Mid(inchar , 1 , 2)
      Byt = Val(saddr)
      S = Byt
     Print "A"

     'End Select
     Case "Z"
     Print "Z"
     Writeeeprom S , Es
      Writeeeprom F , Ef
      Case "E" : Reset Flag_uart
      End Select
Return

Tim:
If Flag_uart = 0 Then  Disable Urxc
Stop Timer1 : Disable Timer0 : Timer1 = 0 : Return