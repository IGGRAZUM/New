$regfile = "m8def.dat"
$crystal = 8000000
$hwstack = 64
$swstack = 64
$framesize = 64
$baud = 38400



Dim Level1 As Integer , Level2 As Integer , Level3 As Integer
Dim A As Byte
Ds Alias Portc.0 : Config Ds = Output : Reset Ds
Sh_cp Alias Portc.2 : Config Sh_cp = Output : Reset Sh_cp
Mr Alias Portc.3 : Config Mr = Output
Const St_cp = 1 : Config Portc.1 = Output
Reset Mr
Pulseout Portc , St_cp , 5
Set Mr
Pulseout Portc , St_cp , 5

Vk Alias Pinb.7 : Config Vk = Input : Set Vk
Tb Alias Pinb.6 : Config Tb = Input : Set Tb
Pump Alias Portc.5 : Config Pump = Output : Reset Pump
Zn Alias Portc.4 : Config Zn = Output : Reset Zn
Toch Alias Portb.0 : Config Toch = Output : Reset Toch
Zum Alias Portb.1 : Config Zum = Output : Reset Zum

Enable Interrupts
Enable Timer1
Config Timer1 = Timer , Prescale = 256
On Timer1 Clock:
                                                'Переполнение через каждые 1 секунд 256/8000000

Enable Timer0
Config Timer0 = Timer , Prescale = 64
On Timer0 Zvon:


Start Timer0                                                'Переполнение через каждые 0,008 секунд 1024/8000000

Timer1 = 34285
Start Timer1

Dim S As Byte , M As Byte , H As Bit , T As Bit , Ti As Byte , Zni As Bit , Zt As Byte , E As Byte , An As Bit
S = 0 : M = 59 : Reset H : Reset T : Ti = 0 : Reset Zni : Zt = 0 : E = 0 : Reset An

Dim Ana As Byte : Ana = 0

Declare Sub 595
Declare Sub 596
Declare Sub Zumchik

Const I = &HEE
Const N = &H6E
Const C = &H9C
Reset Mr
Pulseout Portc , St_cp , 5
Set Mr


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Do
Reset Mr
Pulseout Portc , St_cp , 5
Set Mr

If Vk = 0 Then
Level1 = 9 : Level2 = 5 : Level3 = 9 : 595 : S = 0
If S = 0 And Level1 = 9 Then Zumchik
Set T
Do
If Level3 = 0 And S = 30 Then Set Zni
If Level3 = 0 And Tb = 0 Then Exit Do
If Level3 = 1 Then
Do
Set Pump : Reset Zni : Reset Zn : Reset T : Set Toch
Do
If Tb = 0 Then
 Set An : Reset Toch
 Else
 Ana = 0 : Reset An : Level2 = 0 : Level3 = 1 : Level1 = 0 : 595 : Set Toch : Exit Do
 End If
 If Vk = 1 Then Exit Do
 Loop
If Vk = 1 Then Exit Do
Loop
End If
If Vk = 1 Then Exit Do
Loop
End If
Reset T
M = 59: S = 0
Reset Zni : Reset Zn : Reset Pump
Level1 = 9 : Level2 = 5 : Level3 = 9 : 595 : Waitms 400


Loop
End

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Zumchik
Set Zum : Waitms 300 : Reset Zum : Waitms 150 : Set Zum : Waitms 200 : Reset Zum
Waitms 150 : Set Zum : Waitms 130 : Reset Zum
Return
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Clock:
Timer1 = 34285
Start Timer1

If An = 1 Then
Select Case Ana
Case 0
Level1 = &H10 : Level2 = &H10 : Level3 = &H10 : 596
Case 1
Level1 = &H10 : Level2 = &H10 : Level3 = I : 596
Case 2
Level1 = &H10 : Level2 = I : Level3 = N : 596
Case 3
Level1 = I : Level2 = N : Level3 = I : 596
Case 4
Level1 = N : Level2 = I : Level3 = N : 596
Case 5
Level1 = N : Level2 = I : Level3 = C : 596
Case 6
Level1 = I : Level2 = C : Level3 = &H10 : 596
Case 7
Level1 = C : Level2 = &H10 : Level3 = &H10 : 596
Case 8
Level1 = &H10 : Level2 = &H10 : Level3 = &H10 : 596
Case 9
An = 0 : Ana = 0
End Select
Incr Ana
End If


If T = 1 And H = 0 Then
Incr S : Set Toch : Ti = 1
If S = 60 Then
S = 0 : Incr M
If M = 60 Then
M = 0 : Level2 = 0 : Level3 = 0 : Level1 = 0
End If
Level3 = M
595
End If
Else
Reset Toch : Ti = 0
End If
Return



'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Zvon:

If Zni = 1 Then
 If E > 0 And E < 13 Then
  If Zt > 0 And Zt < 8 Then
   Toggle Zn : Incr Zt
  Else
   Reset Zn : Incr Zt
   If Zt = 19 Then
    Zt = 1 : Incr E
   End If
  End If
 Else
 Incr E : If E = 255 Then E = 0

 End If
Else
 Reset Zn : Reset Zt
End If

If Ti > 0 Then
Incr Ti : If Ti = 192 Then Ti = 0
Else
Reset Toch
 End If

Return
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Sub 595
A = Lookup(level1 , Numbers)
Shiftout Ds , Sh_cp , A , 1
A = Lookup(level2 , Numbers)
Shiftout Ds , Sh_cp , A , 1
A = Lookup(level3 , Numbers)
Shiftout Ds , Sh_cp , A , 1
Pulseout Portc , St_cp , 5
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Sub 596
A = Level1
Shiftout Ds , Sh_cp , A , 1
A = Level2
Shiftout Ds , Sh_cp , A , 1
A = Level3
Shiftout Ds , Sh_cp , A , 1
Pulseout Portc , St_cp , 5
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Numbers:
Data &B11111100                                             '0
Data &B01100000                                             '1
Data &B11011010                                             '2
Data &B11110010                                             '3
Data &B01100110                                             '4
Data &B10110110                                             '5
Data &B10111110                                             '6
Data &B11100000                                             '7
Data &B11111110                                             '8
Data &B11110110                                             '9
Data &HFC                                                   '0
Data &H60                                                   '1
Data &HDA                                                   '2
Data &HF2                                                   '3
Data &H66                                                   '4
Data &HB6                                                   '5
Data &HBE                                                   '6
Data &HE0                                                   '7
Data &HFE                                                   '8
Data &HF6                                                   '9