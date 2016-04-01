$regfile = "m328pdef.dat"
$crystal = 8000000
$hwstack = 250
$swstack = 250
$framesize = 250
$baud = 38400


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\Порты\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Up_telfer Alias Portd.5 : Config Up_telfer = Output         'Питание телфера
Down_telfer Alias Portd.6 : Config Down_telfer = Output
Reset Up_telfer : Reset Down_telfer

Door_power Alias Portb.6 : Config Door_power = Output : Reset Door_power       'Открывание двери
Luck_power Alias Portb.7 : Config Luck_power = Output : Reset Luck_power       'Открывание люка

Svet Alias Portb.5 : Config Svet = Output : Reset Svet      'Питание света в комнате

Tc1 Alias Pinb.3 : Tc2 Alias Pinb.4                         'Ик датчики обхода препятствий TCRT5000
Config Tc1 = Input , Tc2 = Input                            '01=начало пути, 00=середина, 10=конец
Set Tc1 : Set Tc2

F0 Alias Pinc.1 : F1 Alias Pinc.2 : F2 Alias Pinc.3 : F3 Alias Pinc.4 : F4 Alias Pinc.5       'Вход фотодиодов
Config F0 = Input , F1 = Input , F2 = Input , F3 = Input , F4 = Input
Reset F0 : Reset F1 : Reset F2 : Reset F3 : Reset F4

Play_up Alias Pind.3 : Play_down Alias Pind.4 : Stope Alias Pind.2       'кнопки запуска и остановки
Config Play_up = Input , Play_down = Input , Stope = Input
Set Play_up : Set Play_down : Set Stope

Okonchanie1 Alias Pind.7 : Config Okonchanie1 = Input       'кнопки нижнего положения начала
Okonchanie2 Alias Pinb.0 : Config Okonchanie2 = Input       'кнопки нижнего положения обратки
Set Okonchanie1 : Set Okonchanie2

Door Alias Pinb.1 : Luck Alias Pinb.2                       'Датчики проверки закрытия двери и люка
Config Door = Input , Luck = Input
Set Door : Set Luck

Teletipe Alias Pinc.0 : Config Teletipe = Input : Set Teletipe       'Телетайп

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Переменные\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Dim Stopflag As Bit
Stopflag = 0

Dim Flag_luck As Bit : Reset Flag_luck
Dim Flag_sub As Byte : Flag_sub = 0
Dim Norm As Bit : Reset Norm
Dim Flag_uart As Byte : Flag_uart = 0
Dim Pusk As Bit : Reset Pusk
Dim Flag_v As Bit : Reset Flag_v
Dim Flag_plan As Bit : Reset Flag_plan



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\EEPROM\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Dim Tup As Integer , Tdown As Integer , Fd As Byte
Dim Etup As Eram Integer , Etdown As Eram Integer , Efd As Eram Byte

Fd = Efd
Print "*fd= " ; Fd
Tup = Etup
Print "*tup= " ; Tup
Tdown = Etdown
Print "*tdown= " ; Tdown
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


Dim Tim2 As Byte : Tim2 = 0
Dim Cmnd As String * 1 , Inchar As String * 7 , Saddr As String * 7 , Sbyt As String * 5
Dim Byt As Integer , In1 As Byte                            'UART

 Dim Flag_pologenie As Byte , Flag_pologenie2 As Byte
 Dim S As String * 9 , S2 As String * 7
'\\\\\\\\\\\\\\\\\\\\\\\\ Константы флага положения кабинки \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Const Nachalo = 0 : Const Putn = 1 : Const Foto1 = 2 : Const Foto1_2 = 3 : Const Foto2 = 4 : Const Foto2_3 = 5
Const Foto3 = 6 : Const Puts = 7 : Const Perehod_nachalo = 8 : Const Perehod_konets = 9 : Const Putk = 10
Const Konets = 11 : Const Non = 12 : Const Put_non = 13


Macro Up_data
   Set Up_telfer : Reset Down_telfer
End Macro

Macro Down_data
   Reset Up_telfer : Set Down_telfer
End Macro

Macro Stop_data
 Set Pusk : Reset Up_telfer : Reset Down_telfer
End Macro

Macro Off_full
 Set Pusk : Reset Luck_power : Reset Door_power
End Macro



Macro Open_door
  Reset Luck_power : Set Door_power
End Macro

Macro Open_luck
  Set Luck_power : Reset Door_power
End Macro


Macro Help1
Print "s then config sub" : Print "u then upravlenie" : Print "e then exit do"
End Macro

Macro Help2
Print "f then config fotodiode down to comand down lift" : Print "u then confih time sub UP_LIFT" : Print "d then config time sub down_lift" : Print "e then exit select"
End Macro

Macro Help3
Print "e then exit select"
End Macro

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Прерывания\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Config Int0 = Falling
On Int0 Stopbutton
Enable Int0


On Urxc Getchar
Enable Urxc

Enable Timer0
Config Timer0 = Timer , Prescale = 1024

On Timer0 Timer0isr
Timer0 = 21
Start Timer0
Enable Interrupts


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Подпрограммы\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Declare Sub Glav
Declare Sub Pologenie
Declare Sub Vozvrat
Declare Sub Up_lift
Declare Sub Down_lift
Declare Sub Stop_lift
Declare Sub Telfer_up
Declare Sub Telfer_down
Declare Sub Ruch
Declare Sub Super_down

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


Print ; "Igri razuma"
Print ; "\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
Print ; ""
Print ; "Kabinka v1.0"

'\\\\\\\\\\\\\\\\\\\\\\\\\\\Макросы\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Проверка состояния(основной цикл)\\\\\\\\\\\\\\\\\\\\\\\
 Set Svet
 Wait 1
 Reset Svet
 Pologenie
 Stop Timer0
 Print ; "F0=" ; F0 : Print ; "F1=" ; F1 : Print ; "F2=" ; F2 : Print ; "F3=" ; F3 : Print "F4=" ; F4 : Waitms 600
 Start Timer0
 Sub Glav
 Reset Pusk

 Do
  Flag_sub = 1
  Pologenie
 If Stopflag = 1 And Stope = 1 Then
 Reset Stopflag : Stop_data : Off_full : Flag_uart = 0
 If Door = 0 And Luck = 0 Then Reset Svet Else Set Svet
 Elseif Stopflag = 0 And Stope = 1 Then
 Stop_data : If Door = 0 And Luck = 0 And Flag_plan = 0 Then Reset Svet Else Set Svet
 Elseif Stope = 0 Or Stopflag = 1 Then
 Off_full : Stop_data : Flag_uart = 0 : Set Svet
 Elseif Stope = 0 And Stopflag = 0 Then
 Set Svet : Stopflag = 1 : Flag_uart = 0
 End If


If Door = 0 And Luck = 0 Then
 If Play_up = 0 Or Flag_uart = 1 Then
  Waitms 300 : Print ; "SU" : Flag_uart = 0 : Reset Flag_plan : Up_lift       'start up
 Else
  Stop_data
 End If
 If Play_down = 0 Or Flag_uart = 2 Then
  Waitms 300 : Print ; "SD" : Flag_uart = 0 : Reset Flag_plan : Down_lift       'start down
 Else
  Stop_data
 End If


 If Flag_pologenie2 = Putn And Flag_pologenie = Nachalo Then
  If Teletipe = 0 Then
   Set Svet : Open_door : Print "OD" : Wait 5 : Off_full
       Print ; "TO" : Off_full : Wait 2 : Set Flag_plan
  End If
 Else
  Off_full : Stop_data : Pologenie
 End If
Else
 If Stope = 0 Or Stopflag = 1 Then Stop_data
 Off_full : Stop_data : Pologenie : Flag_uart = 0 : Set Svet

End If
 Loop
 End Sub




'\\\\\\\\\\\\\\\\\Прерывание аварийного стопа\\\\\\\\\\\\\\\\\\\\\\\
Stopbutton:
If Pusk = 0 Then Stop_lift
Print "Stop"
Waitms 50
  Eifr = 3
Return
End

'\\\\\\\\\\\\\\\\Прерывание UART(WIFI)\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Getchar:

Inchar = Inkey()
Cmnd = Left(inchar , 1)
Select Case Cmnd
Case "u"
Flag_uart = 1                                               'Программа поднимания
Case "d"
Flag_uart = 2                                               'Программа опускания
Case "s"
Stop_lift : Set Stopflag                                    'Экстренная остановка
Case "D"
 Stop_data : Open_door : Wait 4 : Off_full
Case "H"
 Stop_data : Open_luck : Wait 4 : Off_full
Case "i"
Stop_data : Print ; "F0=" ; F0 : Print ; "F1=" ; F1 : Print ; "F2=" ; F2 : Print ; "F3=" ; F3 : Print "F4=" ; F4
Print "*fd= " ; Fd : Print "*tup= " ; Tup : Print "*tdown= " ; Tdown : Print "stop= " ; Stope : Waitms 200
Case "r"
 Ruch
End Select
Return
End



'\\\\\\\\\\\\\\\Таймер для безопасности\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Timer0isr:


Tim2 = Tim2 + 1
If Tim2 = 15 Then
Print ; "PO" ; S
If Flag_pologenie = Non Then Print ; "PU" ; S2
Tim2 = 0
Select Case Flag_sub
Case 1
 Print "G"
Case 2
Print "LU"
Case 3
 Print "LD"
Case 4
 Print "V"
Case 5
 Print "R"
End Select
 If Door = 1 Then Print ; "DO"                              'открытая дверь
 If Luck = 1 Then Print ; "HO"                              'открыт люк
End If
 Timer0 = 21
  Start Timer0
 Return

End





'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Sub Stop_lift
  Set Stopflag : Stop_data : Off_full : Set Svet : Print ; "ST" : Flag_uart = 0 : Return
End Sub

Sub Telfer_up
    If Down_telfer = 1 Or Up_telfer = 0 Then
  Set Pusk : Up_data : Print "TU" : Waitms 450 : Reset Stopflag
   Else
    Up_data : Reset Pusk
   End If
   Return
End Sub

Sub Telfer_down
If Up_telfer = 1 Or Down_telfer = 0 Then
    Set Pusk : Down_data : Print "TD" : Waitms 450 : Reset Stopflag
   Else
    Down_data : Reset Pusk
   End If
   Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\Подпрограмма опускания кабинки\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

 Sub Down_lift
 Flag_sub = 3
'Enable Interrupts
Do
Set Svet
If Play_up = 0 Or Stopflag = 1 Or Stope = 0 Or Door = 1 Or Luck = 1 Then
Stop_lift : Wait 1 : Exit Do
 End If
Pologenie
If Stope = 0 Or Door = 1 Or Luck = 1 Then Exit Do
If Stopflag = 1 Then Exit Do
Select Case Flag_pologenie
 Case Nachalo
 Off_full : Telfer_up
 Case Konets
Flag_uart = 0 : Stop_data : Wait 3 : Open_luck : Print ; "OK" : Wait 15 : Reset Svet : Exit Do
 Case Foto1
 If Fd = 0 Then Super_down Else Telfer_up
 Case Foto1_2
 If Fd = 1 Then
 Super_down
 Elseif Fd = 0 Then
   Telfer_down
   Else
   Telfer_up
   End If
 Case Foto2
  If Fd = 2 Then
 Super_down
 Elseif Fd < 2 Then
   Telfer_down
   Else
   Telfer_up
   End If
 Case Foto2_3
  If Fd = 3 Then
 Super_down
 Elseif Fd < 3 Then
   Telfer_down
   Else
   Telfer_up
   End If
 Case Foto3
  Telfer_down
 Case Non
  Select Case Flag_pologenie2
  Case Putn
  Telfer_up
  Case Puts
  Telfer_down
  Case Putk
   Telfer_down
  Case Put_non
   Stop_data : Off_full : Exit Do
   End Select
 Case Perehod_nachalo : Telfer_down
 Case Perehod_konets : Telfer_down
 End Select
Loop
 Return

 End Sub

  '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Подпрограмма поднятия кабинки\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 Sub Up_lift
 Flag_sub = 2
' Enable Interrupts
Do
Set Svet
If Play_down = 0 Or Stopflag = 1 Or Stope = 0 Or Door = 1 Or Luck = 1 Then
Stop_lift : Wait 1 : Exit Do
 End If
Pologenie
If Stope = 0 Or Door = 1 Or Luck = 1 Then Exit Do
If Stopflag = 1 Then Exit Do
Select Case Flag_pologenie
 Case Nachalo
  Flag_uart = 0 : Stop_data : Open_door : Wait 5 : Off_full : Print ; "OK" : Reset Svet : Exit Do
  Case Konets
  Telfer_up : Off_full
 Set Svet : Off_full
 Case Foto1
  Telfer_down
 Case Foto1_2
  Telfer_down
 Case Foto2
  Vozvrat
 Case Foto2_3
 Vozvrat
 Case Foto3
  Vozvrat
 Case Perehod_nachalo
  Telfer_up
 Case Perehod_konets
 Telfer_up
 Case Non
  Select Case Flag_pologenie2
  Case Putn
  Telfer_down
  Case Puts
  Telfer_up
  Case Putk
   Telfer_up
  Case Put_non
   Stop_data : Off_full : Exit Do
  End Select
 End Select
Loop

Return
 End Sub


'\\\\\\\\\\\\\\\\\\Подпрограмма для плавного возврата кабинки\\\\\\\\\\\\\\\\\\\\
Sub Vozvrat
Flag_sub = 4
 'Enable Interrupts
Do
If Stopflag = 1 Or Stope = 0 Or Door = 1 Or Luck = 1 Then
Stop_lift : Exit Do
 End If
Pologenie
If Stope = 0 Or Door = 1 Or Luck = 1 Then Exit Do
If Stopflag = 1 Then Exit Do
Select Case Flag_pologenie
 Case Perehod_konets
  Telfer_up : Reset Norm : Reset Flag_v
 Case Foto3
  If Norm = 1 Then
  Stop_data : Telfer_down : Reset Flag_v
   Else
   Telfer_up : Waitms Tup : Stop_data : Wait 5 : Telfer_down : Wait 5
   End If
 Case Foto2_3
  Telfer_down : Set Norm : Set Flag_v
 Case Foto2
  Telfer_down : Set Norm : Set Flag_v
 Case Foto1_2
  Telfer_down : Set Norm
 Case Foto1
  Telfer_down : Reset Norm
 Case Nachalo
   Stop_data : Off_full : Print ; "OK" : Exit Do
 Case Non
   Select Case Flag_pologenie2
  Case Putn : If Norm = 0 Or Flag_v = 1 Then Telfer_down Else Telfer_up
  Case Puts : If Norm = 1 Then Telfer_down Else Telfer_up
  Case Put_non
   Stop_data : Off_full : Exit Do
  End Select
End Select
Loop
Return

End Sub


'\\\\\\\\\\\\\\\\\\\\\Положение\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 Sub Pologenie
If Okonchanie1 = 1 And Okonchanie2 = 0 Then
S = "N"                                                     'Начало
Flag_pologenie = Nachalo
Elseif Okonchanie2 = 1 And Okonchanie1 = 0 Then
S = "K"                                                     'Конец
Flag_pologenie = Konets
Elseif F0 = 0 And F1 = 1 And F2 = 1 And F3 = 1 And F4 = 1 Then
S = "F1"
Flag_pologenie = Foto1
Elseif F0 = 0 And F1 = 0 And F2 = 1 And F3 = 1 And F4 = 1 Then
S = "F12"
Flag_pologenie = Foto1_2
Elseif F0 = 1 And F1 = 0 And F2 = 1 And F3 = 1 And F4 = 1 Then
S = "F2"
Flag_pologenie = Foto2
Elseif F0 = 1 And F1 = 0 And F2 = 0 And F3 = 1 And F4 = 1 Then
S = "F23"
Flag_pologenie = Foto2_3
Elseif F0 = 1 And F1 = 1 And F2 = 0 And F3 = 1 And F4 = 1 Then
S = "F3"
Flag_pologenie = Foto3
Elseif F1 = 1 And F2 = 1 And F0 = 1 And F3 = 0 And F4 = 1 Then
S = "PN"                                                    'переход начало
Flag_pologenie = Perehod_nachalo
Elseif F0 = 1 And F1 = 1 And F2 = 1 And F3 = 1 And F4 = 0 Then
S = "PK"                                                    'переход конец
Flag_pologenie = Perehod_konets
Else
S = "E"                                                     'erorr
Flag_pologenie = Non
End If

If Tc1 = 0 And Tc2 = 1 Then
 Flag_pologenie2 = Putn
If Flag_pologenie = Non Then S2 = "N"
End If
If Tc1 = 0 And Tc2 = 0 Then
 Flag_pologenie2 = Puts
If Flag_pologenie = Non Then S2 = "S"
End If
If Tc1 = 1 And Tc2 = 0 Then
 Flag_pologenie2 = Putk
If Flag_pologenie = Non Then S2 = "K"
End If
If Tc1 = 1 And Tc2 = 1 Then
 Flag_pologenie2 = Put_non
If Flag_pologenie = Non Then S2 = "_NON"
End If
If Stope = 0 Then Set Stopflag
Return
 End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Sub Ruch
In1 = 0
Stop_lift : Reset Svet
Print "h or H then HELP"
Do
If In1 = 0 Then
Input "param: " , Inchar
Cmnd = Left(inchar , 1)
Select Case Cmnd
Case "H"
Waitms 100 : Help1
Case "h"
Waitms 100 : Help1
Case "s"
Waitms 100 : In1 = 1 : Cmnd = ""
Case "u"
Waitms 100 : In1 = 2 : Cmnd = ""
Case "e"
Exit Do
End Select

Elseif In1 = 1 Then
Print "Config sub time and regim" : Print "h or H then HELP"
Input "sub: " , Inchar
Cmnd = Left(inchar , 1)
Select Case Cmnd
Case "h"
Waitms 100 : Help2
Case "H"
Waitms 100 : Help2
Case "e"
Waitms 100 : In1 = 0 : Cmnd = ""
Case "u"
Waitms 100 : In1 = 3 : Cmnd = ""
Case "f"
Waitms 100 : In1 = 5 : Cmnd = ""
Case "d"
Waitms 100 : In1 = 4 : Cmnd = ""
End Select

Elseif In1 = 3 Or In1 = 4 Then
Print "Config sub time" : Print "h or H then HELP"
Input "time: " , Inchar
Sbyt = Left(inchar , 4)
Byt = Val(sbyt)
Cmnd = Left(inchar , 1)
Select Case Cmnd
Case "e"
Waitms 100 : In1 = 1 : Cmnd = ""
Case "h"
Waitms 100 : Help3
Case "H"
Waitms 100 : Help3
Case Else
Waitms 100 :
If In1 = 3 Then Tup = Byt Else Tdown = Byt
If In1 = 3 Then Print "Tup= " ; Tup Else Print "Tdown= " ; Tdown
Input "save? y/n : " , Inchar
Cmnd = Left(inchar , 1)
If Cmnd = "y" Then
If In1 = 3 Then Etup = Tup Else Etdown = Tdown
End If
End Select


Elseif In1 = 5 Then
Print "fotodiode down" : Print "h or H then HELP"
Input "fotodiode : " , Inchar
Cmnd = Left(inchar , 1)
Select Case Cmnd
Case "h"
Waitms 100 : Help3
Case "H"
Waitms 100 : Help3
Case "e"
Waitms 100 : In1 = 1 : Cmnd = ""
 Case Else
Sbyt = Left(inchar , 1)
Byt = Val(sbyt)
Fd = Byt
Input "save? y/n : " , Inchar
Cmnd = Left(inchar , 1)
If Cmnd = "y" Then Efd = Fd
End Select

Elseif In1 = 2 Then
Print "Ruchnoe upravlenie"
Input "comand: " , Inchar
Cmnd = Left(inchar , 1)
Select Case Cmnd
Case "e"
Waitms 100 : In1 = 0 : Cmnd = ""
Case "d"
 Stop_data : Open_door : Wait 4 : Off_full
Case "h"
 Stop_data : Open_luck : Wait 4 : Off_full
Case "s"
 Toggle Svet
End Select
End If
Loop
Return
End Sub

Sub Super_down
Telfer_up : Waitms Tdown                                    ': Stop_data : Waitms 300 :
Telfer_down : Waitms 800 : Stop_data : Wait 3 : Telfer_down : Wait 4
Return
End Sub