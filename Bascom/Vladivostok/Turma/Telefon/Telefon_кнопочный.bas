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

Led_red Alias Portd.4 : Config Led_red = Output : Set Led_red
Led_green Alias Portd.3 : Config Led_green = Output : Set Led_green

Trub Alias Pinb.6 : Config Trub = Input : Set Trub

Inpin1 Alias Pind.6 : Config Inpin1 = Input : Set Inpin1
Inpin2 Alias Pind.5 : Config Inpin2 = Input : Set Inpin2
Inpin3 Alias Pinb.7 : Config Inpin3 = Input : Set Inpin3
Outpin1 Alias Portd.7 : Config Outpin1 = Output : Set Outpin1
Outpin2 Alias Portb.0 : Config Outpin2 = Output : Set Outpin2
Outpin3 Alias Portb.1 : Config Outpin3 = Output : Set Outpin3
Outpin4 Alias Portb.2 : Config Outpin4 = Output : Set Outpin4



Dim Countn As Byte , Number As String * 5 , Pins As String * 2 , Pinnum As Byte
Countn = 0 : Number = "" : Pinnum = 0


Declare Sub Line1
Declare Sub Line2
Declare Sub Line3
Declare Sub Line4
Declare Sub Reg
Declare Sub Isnum

Macro Ok
Reset Led_green : Set Led_red : Print "Ok"
End Macro
Macro Error
Reset Led_red : Set Led_green : Print "Error"
End Macro
Macro Non
Set Led_red : Set Led_green : Set Outpin1 : Set Outpin2 : Set Outpin3 : Set Outpin4 : Print "NON"
End Macro

Macro Inline1
Reset Outpin1 : Set Outpin2 : Set Outpin3 : Set Outpin4
End Macro

Macro Inline2
Set Outpin1 : Reset Outpin2 : Set Outpin3 : Set Outpin4
End Macro

Macro Inline3
Set Outpin1 : Set Outpin2 : Reset Outpin3 : Set Outpin4
End Macro

Macro Inline4
Set Outpin1 : Set Outpin2 : Set Outpin3 : Reset Outpin4
End Macro

Print "---Telefon v turmu---"
Print "---Igri razuma---"
Print "---Set programm---"
Wait 1
Do
 If Trub = 1 Then
  Print "Start programm"
  Do
Inline1
Line1
If Countn >= 3 Then
 Isnum : Number = "" : Non : Exit Do
 End If
 Waitms 20
Inline2
Line2
If Countn >= 3 Then
 Isnum : Number = "" : Non : Exit Do
 End If
 Waitms 20
Inline3
Line3
If Countn >= 3 Then
 Isnum : Number = "" : Non : Exit Do
 End If
 Waitms 20
Inline4
Line4
If Countn >= 3 Then
 Isnum : Number = "" : Non : Exit Do
 End If
 Waitms 20
If Trub = 0 Then
Number = "" : Countn = 0 : Non : Exit Do
End If
Loop
End If
Loop
End



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Line1
Reg
If Pinnum > 0 Then
Countn = Countn + 1
Pins = Str(pinnum)
'Mid(pins , Countn , 1 ) = Number
Number = Number + Pins
Waitms 50
Do
Reg
If Pinnum = 0 Then Exit Do
Loop
End If
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Line2
Reg
If Pinnum > 0 Then
Countn = Countn + 1
Pinnum = Pinnum + 3
Pins = Str(pinnum)
'Mid(pins , Countn , 1) = Number
Number = Number + Pins
Waitms 50
Do
Reg
If Pinnum = 0 Then Exit Do
Loop
End If
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Line3
Reg
If Pinnum > 0 Then
Countn = Countn + 1
Pinnum = Pinnum + 6
Pins = Str(pinnum)
'Mid(pins , Countn , 1) = Number
Number = Number + Pins
Waitms 50
Do
Reg
If Pinnum = 0 Then Exit Do
Loop
End If
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Line4
Reg
If Pinnum > 0 And Pinnum = 2 Then
Countn = Countn + 1
 Pinnum = 0
Pins = Str(pinnum)
'Mid(pins , Countn , 1) = Number
Number = Number + Pins
Waitms 50
Do
Reg
If Pinnum = 0 Then Exit Do
Loop
End If
Return
End Sub
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


Sub Reg
If Inpin1 = 0 And Inpin2 = 1 And Inpin3 = 1 Then
Pinnum = 1
Elseif Inpin1 = 1 And Inpin2 = 0 And Inpin3 = 1 Then
Pinnum = 2
Elseif Inpin1 = 1 And Inpin2 = 1 And Inpin3 = 0 Then
Pinnum = 3
Else
Pinnum = 0
End If
Return
End Sub
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


Sub Isnum
If Countn >= 3 Then Countn = 0
Print "Number= " ; Number
    Select Case Number
     Case "742"
       Ok : Rus
     Case "227"
      Ok : Eng
     Case "427"
      Ok : Kor
     Case "666"
     Error : Man
     Case "777"
     Error : Nom
     Case "999"
     Error : Vor
     Case "228"
     Error : Nog
     Case "000"
     Error : Kh
     Case Else
     Error :Gud
    End Select
    Non : Number = ""
    Return
    End Sub