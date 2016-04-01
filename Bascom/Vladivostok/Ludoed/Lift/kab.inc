$nocompile


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

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Sub Stop_lift
   Set Stopflag : Stop_data : Off_full : Set Svet : Print ; "ST"
End Sub

Sub Telfer_up
    If Down_telfer = 1 Then
    Stop_data : Waitms 200 : Up_data : Print "TU"
   Else
    Up_data
   End If
End Sub

Sub Telfer_down
If Up_telfer = 1 Then
    Stop_data : Waitms 200 : Down_data : Print "TD"
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
If Stopflag = 1 Or Stope = 0 Or Door = 0 Or Luck = 0 Then
Stop_lift : Exit Do
 End If
Pologenie
If Stopflag = 1 Then Exit Do
Select Case Flag_pologenie
 Case Nachalo
 Off_full : Telfer_up
 Case Konets
  Stop_data : Wait 15 : Open_luck : Print ; "OK" : Wait 15 : Reset Svet : Exit Do
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
  Return
  '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Подпрограмма поднятия кабинки\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 Sub Up_lift
 Flag_sub = 2
' Enable Interrupts
Do
Set Svet
If Stopflag = 1 Or Stope = 0 Or Door = 0 Or Luck = 0 Then
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
If Stopflag = 1 Or Stope = 0 Or Door = 0 Or Luck = 0 Then
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
If Stopflag = 1 Or Stope = 0 Or Door = 0 Or Luck = 0 Then
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
 Toggle Flag_door
Case "H"
 Toggle Flag_luck
Case "S"
 Stop_data
  Tim = 0
      Reset Stopflag
Case "s"
 Stop_data
  Tim = 0
     Reset Stopflag
Case "E"
 Stop_data
  Off_full
   Exit Do
End Select
Cmnd = ""
If Flag_door = 0 Then Reset Door_power Else Set Door_power
If Flag_luck = 0 Then Reset Luck_power Else Set Luck_power
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

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\