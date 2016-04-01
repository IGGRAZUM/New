

'\\\\\\\\\СВЕТОФОР\\\\\\\
'Код для сигнализации
'2=красный, 1=желтый, 0=зеленый
'Результат: 10210201=1,2,3,4,5,6,7,8


$regfile = "m8def.dat"                                      ' используем ATmega8
$crystal = 8000000


Config Portd.2 = Output
Zamok Alias Portd.2
Zamok = 0

Config Portc.0 = Output                                     'Светодиод кнопки
Rb Alias Portc.0
Rb = 0

Config Portc.1 = Output
Yb Alias Portc.1
Yb = 0

Config Portc.2 = Output
Gb Alias Portc.2
Gb = 0

Config Portc.3 = Output                                     'Реле светофора
Rs Alias Portc.3
Rs = 0

Config Portc.4 = Output
Ys Alias Portc.4
Ys = 0

Config Portc.5 = Output
Gs Alias Portc.5
Gs = 0

Wait 2
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\Вход кнопок\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Pind.5 = 1
Config Pind.5 = Input
Rbutton Alias Pind.5

Pind.6 = 1
Config Pind.6 = Input
Ybutton Alias Pind.6

Pind.7 = 1
Config Pind.7 = Output
Gbutton Alias Pind.7

Dim Flag_start As Bit
Flag_start = 0

Dim Flagbutton As Byte
Flagbutton = 0

Dim Secund As Byte
Secund = 1

Dim Sec_reley As Byte
Sec_reley = 0

Dim Sec_tm As Dword
Sec_tm = 0

Dim Erors As Bit
Erors = 0

Dim Flag_zamok As Bit
Flag_zamok = 0

Macro Red_data
   Rs = 1 : Ys = 0 : Gs = 0
End Macro

Macro Yellow_data
   Rs = 0 : Ys = 1 : Gs = 0
End Macro

Macro Green_data
   Rs = 0 : Ys = 0 : Gs = 1
End Macro

Macro Non_data
   Rs = 0 : Ys = 0 : Gs = 0
End Macro


Macro Led_but_on
   Rb = 1 : Yb = 1 : Gb = 1
End Macro

Macro Led_but_off
   Rb = 0 : Yb = 0 : Gb = 0
End Macro

Declare Sub Red
Declare Sub Yellow
Declare Sub Green
Declare Sub Non



Enable Interrupts
Enable Timer0
Config Timer0 = Timer , Prescale = 1024
On Timer0 Svetofor:
Timer0 = 99
Const Tm = 75                                               'Переполнение через каждые 0,03 секунд 1024/8000000
Start Timer0




Do
If Flag_zamok = 0 Then
Debounce Rbutton , 0 , Red , Sub
Debounce Ybutton , 0 , Yellow , Sub
Debounce Gbutton , 0 , Green , Sub
End If
Loop
End

'\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Red
Waitms 70
If Flagbutton = 7 Then
Non
Elseif Flagbutton = 1 Or Flagbutton = 3 Or Flagbutton = 4 Or Flagbutton = 6 Then
 Erors = 1
 Incr Flagbutton
 Else
 Incr Flagbutton
End If
Do
If Rbutton = 1 Then Exit Do
Loop
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\
Sub Yellow
Waitms 70
 If Flagbutton = 7 Then
 If Erors = 0 Then
  Zamok = 1
  Rb = 0
  Gb = 1
  Flag_zamok = 1
  Secund = 0
  Sec_tm = 0
  Timer0 = 99
Start Timer0
  Else
  Non
 End If
 Else
 If Flagbutton = 1 Or Flagbutton = 2 Or Flagbutton = 4 Or Flagbutton = 5 Or Flagbutton = 6 Then
 Erors = 1
 Incr Flagbutton
 Else
 Incr Flagbutton
 End If
 End If
Do
If Ybutton = 1 Then Exit Do
Loop
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\

Sub Green
Waitms 70
If Flagbutton = 7 Then
 Non
Elseif Flagbutton = 2 Or Flagbutton = 3 Or Flagbutton = 5 Then
 Erors = 1
 Incr Flagbutton
 Else
 Incr Flagbutton
End If

Do
If Gbutton = 1 Then Exit Do
Loop
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Non
Flag_zamok = 0
Erors = 0
Stop Timer0
Non_data
Flagbutton = 0
Zamok = 0
Led_but_on
Waitms 200
Led_but_off
Waitms 100
Led_but_on
Waitms 200
Led_but_off
Waitms 100
Led_but_on
Waitms 200
Led_but_off
Waitms 100
Led_but_on
Waitms 200
Led_but_off
Waitms 100
Led_but_on
Waitms 200
Led_but_off
Wait 1
Rb = 1
Secund = 0
Sec_tm = 0
Timer0 = 99
Start Timer0
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Svetofor:
If Sec_tm = Tm Then
Sec_tm = 0
If Flag_zamok = 0 Then
Select Case Secund
Case 1
  Yellow_data
Case 2
  Green_data
Case 3
  Red_data
Case 4
  Yellow_data
Case 5
  Green_data
Case 6
  Red_data
Case 7
  Green_data
Case 8
  Yellow_data
Case 11
  If Flag_start = 0 Then
  Flag_start = 1
  Non
  End If
Case 28
  Secund = 0
Case Else
  Non_data
End Select
Else
If Secund = 40 Then
Zamok = 0
Gb = 0
Rb = 1
Flag_zamok = 0
Secund = 0
End If
End If
Incr Secund
End If
Incr Sec_tm 
Timer0 = 99
Start Timer0
Return