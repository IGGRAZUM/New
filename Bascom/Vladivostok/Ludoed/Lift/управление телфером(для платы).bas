                                 $regfile = "m8def.dat"
$crystal = 8000000
$hwstack = 40
$swstack = 16
$framesize = 32
$baud = 38400

Led Alias Portd.5 : Config Led = Output : Set Led
Power_relay_down Alias Portc.1 : Config Power_relay_down = Output : Reset Power_relay_down
Power_relay_up Alias Portc.0 : Config Power_relay_up = Output : Reset Power_relay_up
Power_relay Alias Portc.2 : Config Power_relay = Output : Reset Power_relay
In_up Alias Pinb.1 : Config In_up = Input : Set In_up
In_down Alias Pinb.2 : Config In_down = Input : Set In_down
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Const Up = 1 : Const Down = 2 : Const Non = 3 : Const Error = 0
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Dim Sys As Byte : Sys = 0
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Declare Sub Up_telfer
Declare Sub Down_telfer
Declare Sub Stope
Declare Sub Flag
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Do
Flag
Select Case Sys
Case Up
Reset Led : Up_telfer
Case Down
Reset Led : Down_telfer
Case Non
Reset Led : Stope
Case Error
Reset Led : Stope
End Select
Loop
End
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Flag
If In_up = 0 And In_down = 0 Then
Sys = Non
Elseif In_up = 1 And In_down = 0 Then
Sys = Down
Elseif In_up = 0 And In_down = 1 Then
Sys = Up
Else
Sys = Error
End If
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Up_telfer
If Power_relay_down = 1 And Power_relay_up = 0 Then
 If Power_relay = 0 Then
 Reset Power_relay_down : Set Power_relay_up : Waitms 250
 Set Power_relay : Waitms 150 : Print "telfer UP"
 Else
 Reset Power_relay : Waitms 200 : Reset Power_relay_down : Set Power_relay_up
 Waitms 250 : Set Power_relay : Waitms 150 : Print "telfer UP"
 End If

Elseif Power_relay_down = 0 And Power_relay_up = 1 Then
 If Power_relay = 0 Then
 Set Power_relay : Waitms 150 : Print "telfer UP"
 End If

Elseif Power_relay_down = 1 And Power_relay_up = 1 Then
 If Power_relay = 0 Then
 Reset Power_relay_down : Set Power_relay_up
 Waitms 250 : Set Power_relay : Waitms 150 : Print "telfer UP"
 Else
 Reset Power_relay : Waitms 200 : Reset Power_relay_down : Waitms 150
 Set Power_relay : Waitms 150 : Print "telfer UP"
 End If

Elseif Power_relay_down = 0 And Power_relay_up = 0 Then
 If Power_relay = 0 Then
 Set Power_relay_up : Waitms 250 : Set Power_relay : Waitms 150 : Print "telfer UP"
 Else
 Reset Power_relay : Waitms 200 : Set Power_relay_up : Waitms 250
 Set Power_relay : Waitms 150 : Print "telfer UP"
 End If
End If
Set Led
Return
End Sub
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Sub Down_telfer
If Power_relay_down = 1 And Power_relay_up = 0 Then
 If Power_relay = 0 Then
 Set Power_relay : Waitms 150 : Print "telfer down"
 End If

Elseif Power_relay_down = 1 And Power_relay_up = 1 Then
 If Power_relay = 0 Then
 Reset Power_relay_up : Waitms 200 : Set Power_relay : Waitms 150 : Print "telfer down"
 Else
 Reset Power_relay : Waitms 200 : Reset Power_relay_up : Waitms 150
 Set Power_relay : Waitms 150 : Print "telfer down"
 End If

Elseif Power_relay_down = 0 And Power_relay_up = 1 Then
 If Power_relay = 0 Then
 Reset Power_relay_up : Set Power_relay_down : Waitms 250 : Set Power_relay : Waitms 150 : Print "telfer down"
 Else
 Reset Power_relay : Waitms 200 : Reset Power_relay_up : Waitms 150
 Set Power_relay_down : Waitms 250 : Set Power_relay : Waitms 150 : Print "telfer down"
 End If

Elseif Power_relay_down = 0 And Power_relay_up = 0 Then
 If Power_relay = 0 Then
 Set Power_relay_down : Waitms 250 : Set Power_relay : Waitms 150 : Print "telfer down"
 Else
 Reset Power_relay : Waitms 200
 Set Power_relay_down : Waitms 250 : Set Power_relay : Waitms 150 : Print "telfer down"
 End If
End If
Set Led
Return
End Sub
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Sub Stope
If Power_relay = 1 Then
 If Power_relay_up = 1 Or Power_relay_down = 1 Then
 Reset Power_relay : Waitms 200 : Reset Power_relay_down
 Reset Power_relay_up : Waitms 100 : Print "telfer stop"
 Elseif Power_relay_up = 0 Or Power_relay_down = 0 Then
 Reset Power_relay : Waitms 200 : Print "telfer stop"
 End If
Else
 If Power_relay_up = 1 Or Power_relay_down = 1 Then
 Reset Power_relay_down : Reset Power_relay_up : Waitms 150 : Print "telfer stop"
 End If
End If
Set Led
Return
End Sub