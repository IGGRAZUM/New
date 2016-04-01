$regfile = "m8def.dat"
$crystal = 8000000
$hwstack = 40
$swstack = 32
$framesize = 32
$baud = 38400

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


Print ; "Igri razuma"
Print ; "\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
Print ; ""
Print ; "shluz"
'Waitms 300

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\Порты\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Door_min Alias Portd.5 : Config Door_min = Output           'Двери
Door_full Alias Portd.6 : Config Door_full = Output
Reset Door_min : Reset Door_full

Led Alias Portb.6 : Config Led = Output : Reset Led         'Лампа (стробоскоб)
Zum Alias Portb.7 : Config Zum = Output : Reset Zum         'Зумер

Svet Alias Portb.5 : Config Svet = Output : Reset Svet      'Питание света в комнате



Holl_df Alias Pind.7 : Config Holl_df = Input               'кнопки нижнего положения начала
Holl_dm Alias Pinb.0 : Config Holl_dm = Input               'кнопки нижнего положения обратки
Set Holl_df : Set Holl_dm

Pult Alias Pinb.1 : Oper Alias Pinb.2                       'Датчики проверки закрытия двери и люка
Config Pult = Input , Oper = Input
Set Pult : Set Oper

'Teletipe Alias Pinc.0 : Config Teletipe = Input : Set Teletipe       'Телетайп

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Переменные\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Dim Tim As Byte , Flag_sl As Bit : Reset Flag_sl : Tim = 0
'\\\\\\\\\\\\\\\\\\\\\\\\ Константы флага положения кабинки \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Enable Timer0
Config Timer0 = Timer , Prescale = 1024

On Timer0 Timer0isr:
Timer0 = 21
Start Timer0
Enable Interrupts


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Подпрограммы\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Declare Sub Shl_on
Declare Sub Shl_off
Declare Sub Door_on
Declare Sub Door_off
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Wait 1
Print ; "Igri razuma"
Print ; "\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
Print ; ""
Print ; "Shluz v1.0"

'\\\\\\\\\\\\\\\\\\\\\\\\\\\Макросы\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Macro Door_min_on
Set Door_min : Reset Door_full : Print "door shluz open"
End Macro

Macro Door_max_on
   Reset Door_min : Set Door_full : Print "door max open"
End Macro

Macro Door_full_off
  Reset Door_min : Reset Door_full : Print "door closed"
End Macro

Macro Off_full
  Reset Door_min : Reset Door_full : Reset Zum : Reset Led : Print "Off full"
End Macro

Macro Error_on
Reset Led : Set Zum : Print "Set zummer and reset led"
End Macro

Macro Error_off
Set Led : Reset Zum : Print "Reset zummer and set led"
End Macro



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\Проверка состояния(основной цикл)\\\\\\\\\\\\\\\\\\\\\\\

Do
If Pult = 1 And Holl_df = 0 Then
Waitms 20
If Pult = 1 Then Shl_on
End If
Loop

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Shl_on
Door_min_on
Do
Wait 3
Print "Not holl"
If Holl_dm = 1 Then Exit Do
Loop Until Holl_dm = 1
Do
Waitms 1
Loop Until Holl_dm = 1
Door_full_off
Do
Waitms 1
Loop Until Holl_dm = 0
Shl_off : Print " return or start"
Return
End Sub
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Shl_off
Set Flag_sl : Error_on : Door_on : Print "return shl_on"
Return
End Sub
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Door_on
Door_max_on
Do
Waitms 1
Loop Until Holl_df = 1
Wait 7 : Door_off : Print "return shl_off"
Return
End Sub
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Sub Door_off
Do
Waitms 20
Loop Until Pult = 0
Door_full_off : Print "door_off"
Do
Waitms 20
Loop Until Holl_df = 0
Door_full_off : Error_off : Reset Flag_sl
Print "error_off"
Do
Waitms 20
Loop Until Oper = 0
Off_full : Tim = 0 : Print "Reset operator batton"
Return
End Sub
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Timer0isr:
If Flag_sl = 1 Then
Incr Tim
If Tim = 21 Then
Error_off
Elseif Tim = 31 Then
Error_on
Tim = 0
End If
End If
Return