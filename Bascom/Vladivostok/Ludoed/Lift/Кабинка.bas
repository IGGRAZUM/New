$regfile = "m8def.dat"
$crystal = 8000000
$hwstack = 40
$swstack = 16
$framesize = 16
$baud = 38400

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


Print ; "Igri razuma"
Print ; "\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
Print ; ""
Print ; "Kabinka"
'Waitms 300

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

Dim Flag_teletipe As Bit : Reset Flag_teletipe
Dim Flag_door As Bit : Reset Flag_door
Dim Flag_luck As Bit : Reset Flag_luck
Dim Flag_ruch As Bit : Reset Flag_ruch
Dim Flag_sub As Byte : Flag_sub = 0
Dim Norm As Bit : Reset Norm
Dim Flag_uart As Byte : Flag_uart = 0

Dim Tim As Byte : Tim = 0
Dim Tim2 As Byte : Tim2 = 0
Dim Cmnd As String * 1 , Inchar As String * 2 , Saddr As String * 2       'UART

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
  Reset Up_telfer : Reset Down_telfer
End Macro

Macro Off_full
  Reset Luck_power : Reset Door_power : Reset Flag_teletipe
End Macro

Macro Off_full_f
  Reset Luck_power : Reset Door_power
End Macro

Macro Open_door
  Reset Luck_power : Set Door_power : Reset Flag_teletipe
End Macro

Macro Open_luck
  Set Luck_power : Reset Door_power : Reset Flag_teletipe
End Macro

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Прерывания\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Config Int0 = Falling
On Int0 Stopbutton
'Enable Int0


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
Declare Sub Ruch
Declare Sub Pologenie
Declare Sub Vozvrat
Declare Sub Up_lift
Declare Sub Down_lift
Declare Sub Stop_lift
Declare Sub Telfer_up
Declare Sub Telfer_down

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
 Reset Flag_door
 Pologenie


 Sub Glav

 Do
  Flag_sub = 1
  Pologenie
 If Stopflag = 1 And Stope = 1 Then
 Reset Stopflag : Stop_data : Off_full : Reset Svet
 Elseif Stope = 0 And Stopflag = 0 Then
 Set Svet : Stopflag = 1
 End If
If Door = 0 And Luck = 0 Then
 If Play_up = 0 Or Flag_uart = 1 Then
  Print ; "SU" : Flag_uart = 0 : Up_lift                    'start up
 Else
  Stop_data
 End If
 If Play_down = 0 Or Flag_uart = 2 Then
   Print ; "SD" : Flag_uart = 0 : Down_lift                 'start down
 Else
  Stop_data
 End If
 If Stope = 0 Then Stop_data
 If Flag_pologenie2 = Putn And Flag_pologenie = Nachalo Then
  If Teletipe = 0 And Flag_teletipe = 0 Then
   Reset Luck_power : Set Door_power : Print "OD" : Set Flag_teletipe : Set Flag_door : Wait 5 : Off_full_f
   Set Svet : Print ; "TO" : Wait 2 : Off_full_f : Wait 2
  Elseif Teletipe = 1 And Flag_teletipe = 0 Then
   Off_full_f
  Elseif Teletipe = 0 And Flag_teletipe = 1 Then
      If Flag_door = 1 Then
   Reset Luck_power : Set Door_power : Print "OD" : Set Flag_door : Wait 5 : Off_full
   End If
  End If
 Else
  Off_full : Stop_data : Pologenie
 End If
Else
 Reset Flag_door
 If Stope = 0 Then Stop_data
 Off_full_f : Stop_data : Pologenie

End If
 Loop
 End Sub




'\\\\\\\\\\\\\\\\\Прерывание аварийного стопа\\\\\\\\\\\\\\\\\\\\\\\
Stopbutton:

Stop_lift
Waitms 50
  Gifr = 64
Return
End

'\\\\\\\\\\\\\\\\Прерывание UART(WIFI)\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Getchar:

Inchar = Inkey()
Cmnd = Left(inchar , 1)
If Flag_ruch = 0 Then
Select Case Cmnd
Case "u"
Flag_uart = 1                                               'Программа поднимания
Case "d"
Flag_uart = 2                                               'Программа опускания
Case "s"
 Stop_lift                                                  'Экстренная остановка
  Case "S"
 Stop_lift                                                  'Экстренная остановка
Case "r"
  Ruch
Case "D"
Stop_data : Open_door : Wait 1 : Off_full
Case "H"
Stop_data : Open_luck : Wait 1 : Off_full
End Select
End If
Return
End



'\\\\\\\\\\\\\\\Таймер для безопасности\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Timer0isr:
If Flag_ruch = 1 Then
If Tim = 33 Then
  Tim = 0
Stop_lift
  Off_full
Else
   Reset Stopflag
End If
Tim = Tim + 1
End If
'Print Tim
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
   Set Stopflag : Stop_data : Off_full : Set Svet : Print ; "ST" : Flag_uart = 0
End Sub

Sub Telfer_up
    If Down_telfer = 1 Then
   Up_data : Print "TU"
   Else
    Up_data
   End If
End Sub

Sub Telfer_down
If Up_telfer = 1 Then
     Down_data : Print "TD"
   Else
    Down_data
   End If
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\Подпрограмма опускания кабинки\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

 Sub Down_lift
 Flag_sub = 3
'Enable Interrupts
Do
Set Svet
If Stopflag = 1 Or Stope = 0 Or Door = 1 Or Luck = 1 Then
Stop_lift : Exit Do
 End If
Pologenie
If Stopflag = 1 Then Exit Do
Select Case Flag_pologenie
 Case Nachalo
 Off_full : Telfer_up
 Case Konets
  Stop_data : Wait 2 : Open_luck : Print ; "OK" : Wait 15 : Reset Svet : Exit Do
 Case Foto1
  Telfer_up
 Case Foto1_2
 Telfer_up
 Case Foto2
  Telfer_down
 Case Foto2_3
  Telfer_down
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


 End Sub

  '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Подпрограмма поднятия кабинки\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 Sub Up_lift
 Flag_sub = 2
' Enable Interrupts
Do
Set Svet
If Stopflag = 1 Or Stope = 0 Or Door = 1 Or Luck = 1 Then
Stop_lift : Exit Do
 End If
Pologenie
If Stopflag = 1 Then Exit Do
Select Case Flag_pologenie
 Case Nachalo
  Stop_data : Set Door_power : Wait 3 : Off_full : Print ; "OK" : Wait 3 : Reset Svet : Exit Do
  Case Konets
  Telfer_up : Off_full
 Reset Svet : Off_full
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
Select Case Flag_pologenie
 Case Perehod_nachalo
  Telfer_up : Reset Norm
 Case Foto3
  If Norm = 1 Then Telfer_down Else Telfer_up
 Case Foto2_3
  Telfer_down : Set Norm
 Case Foto2
  Telfer_down : Reset Norm
 Case Foto1_2
  Telfer_down : Reset Norm : Exit Do
 Case Foto1
  Telfer_down : Reset Norm : Exit Do
 Case Nachalo
  Stop_data : Off_full : Wait 3 : Reset Svet : Print ; "OK" : Exit Do
 Case Non
   Select Case Flag_pologenie2
  Case Putn : If Norm = 1 Then Telfer_up Else Telfer_down
  Case Puts : If Norm = 1 Then Telfer_down Else Telfer_up
  Case Put_non
   Stop_data : Off_full_f : Exit Do
  End Select
End Select
Loop


End Sub
'\\\\\\\\\\\\\\\\\Ручной режим по WIFI\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Ruch
 Enable Interrupts
Flag_sub = 5
Set Flag_ruch
'Stop_lift
Reset Stopflag : Reset Flag_door : Reset Flag_luck
 Timer0 = 21
Do
If Stopflag = 1 Or Stope = 0 Then
Stop_lift : Exit Do
 End If
Select Case Cmnd
Case "u"
 Telfer_down
   Tim = 0
Case "d"
 Telfer_up
    Tim = 0
Case "D"
 Stop_data : Set Door_power : Tim = 0
Case "H"
 Stop_data : Set Luck_power : Tim = 0
Case "S"
 Stop_lift
  Tim = 0
      Reset Stopflag
Case "s"
 Stop_lift
  Tim = 0
     Reset Stopflag
Case "o"
   Tim = 0
Case "E"
 Stop_data
  Off_full
   Exit Do
End Select
Cmnd = ""
Loop
Stop_lift : Reset Flag_door : Reset Flag_luck : Reset Flag_ruch

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

 End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\