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

Led_red Alias Portd.7 : Config Led_red = Output : Reset Led_red
Led_green Alias Portd.6 : Config Led_green = Output : Reset Led_green

Encod Alias Pinb.2 : Config Encod = Input : Set Encod
Set_enc Alias Pinb.1 : Config Set_enc = Input : Set Set_enc
Trub Alias Pinb.0 : Config Trub = Input : Set Trub

Dim Count As Byte , Flag_count As Byte , Flag_error As Bit , Yaz As Byte
Count = 0 : Flag_count = 0 : Flag_error = 0 : Yaz = 0

Macro Ok
Set Led_green : Reset Led_red
End Macro
Macro Error
Set Led_red : Reset Led_green
End Macro
Macro Non
Reset Led_red : Reset Led_green
End Macro

Print "---Telefon v turmu---"
Print "---Igri razuma---"
Print "---Set programm---"
Wait 1
Do
 If Trub = 0 Then
  Print "Start programm"
  Do
   If Set_enc = 0 Then
   Waitms 50
   Count = 0
   '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    Do
    'Set Led
    If Trub = 1 Then Exit Do
    If Set_enc = 1 Then
     Count = Count - 1
     Print "Encoder= " ; Count
     Select Case Flag_count
     Case 0
      Select Case Count
      Case 7 : Yaz = 1
      Case 2 : Yaz = 2
      Case 4 : Yaz = 3
      Case 6 : Yaz = 4
      Case 9 : Yaz = 6
      Case 10 : Yaz = 8
      Case Else
      Yaz = 0 : Set Flag_error
      End Select
     Case 1
      Select Case Count
      Case 4 : If Yaz = 1 Then Yaz = 1 Else Set Flag_error
      Case 2
       If Yaz = 2 Then
        Yaz = 2
        Elseif Yaz = 3 Then
        Yaz = 3
        Else
        Yaz = 0
       End If
      Case 6 : If Yaz = 4 Then Yaz = 4 Else Set Flag_error
      Case 7 : If Yaz = 1 Then Yaz = 5 Else Set Flag_error
      Case 9 : If Yaz = 6 Then Yaz = 6 Else Set Flag_error
      Case 10 : If Yaz = 8 Then Yaz = 8 Else Set Flag_error
      Case Else
      Yaz = 0 : Set Flag_error
      End Select
     Case 2
     Select Case Count
      Case 2 : If Yaz = 1 Then Yaz = 1 Else Set Flag_error
      Case 7
       If Yaz = 2 Then
       Yaz = 2
       Elseif Yaz = 3 Then
       Yaz = 3
       Elseif Yaz = 5 Then
       Yaz = 5
       Else
       Yaz = 0
       End If
      Case 6 : If Yaz = 4 Then Yaz = 4 Else Set Flag_error
      Case 9 : If Yaz = 6 Then Yaz = 6 Else Set Flag_error
      Case 8 : If Yaz = 2 Then Yaz = 7 Else Yaz = 0
      Case 10 : If Yaz = 8 Then Yaz = 8 Else Set Flag_error
      Case Else
      Yaz = 0 : Set Flag_error
      End Select
     End Select
     Flag_count = Flag_count + 1 : Count = 0 : Exit Do
    Else
    '\\\\\\\\\\\\\\\\\\\\\\\\\\
    Do
     If Encod = 1 Then
      Count = Count + 1
      Waitms 50
      Do
       If Encod = 0 Then Exit Do
      Loop
     End If
      If Set_enc = 1 Then Exit Do
     Loop
     '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    End If
    Loop
    '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
   End If
   'Reset Led
   If Flag_count = 3 And Flag_error = 0 And Yaz > 0 Then
     Flag_count = 0 : Print "OK!"
    Select Case Yaz
     Case 1
       Ok : Rus
     Case 2
      Ok : Eng
     Case 3
      Ok : Kor
     Case 4
     Error : Man
     Case 5
     Error : Nom
     Case 6
     Error : Vor
     Case 7
     Error : Nog
     Case 8
     Error : Kh
    End Select
     Yaz = 0 : Non : Print "st" :                           'Set Led
   Elseif Flag_count = 3 And Flag_error = 1 Then
    Flag_count = 0 : Reset Flag_error : Print "ERROR" : Error : Gud : Non : Print "st" :       'Set Led
   End If

  Loop
 Else
  Flag_count = 0 : Reset Flag_error : Yaz = 0
  Waitms 200
 End If
Loop
End