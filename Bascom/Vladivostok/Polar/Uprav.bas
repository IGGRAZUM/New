




$regfile = "m8def.dat"
$crystal = 8000000
$baud = 9600


Dim Button1 As Integer                                      'ÀÖÏ
Dim Button2 As Integer                                      'ÀÖÏ
Dim Button3 As Integer                                      'ÀÖÏ

'Enable Interrupts
'Enable Urxc
Const Ok = 1
Const Of = 0

Config Adc = Single , Prescaler = Auto , Reference = Avcc   'Íàñòðîéêà ÀÖÏ


Config Portd.3 = Output
Ledr1 Alias Portd.3
Ledr1 = Of
Config Portd.4 = Output
Ledo1 Alias Portd.4
Ledo1 = Ok
Config Portd.5 = Output
Ledg1 Alias Portd.5
Ledg1 = Of
Config Portd.6 = Output
Ledr2 Alias Portd.6
Ledr2 = Of
Config Portd.7 = Output
Ledo2 Alias Portd.7
Ledo2 = Ok
Config Portb.0 = Output
Ledg2 Alias Portb.0
Ledg2 = Of
Config Portc.2 = Output
Ledr3 Alias Portc.2
Ledr3 = Of
Config Portc.1 = Output
Ledo3 Alias Portc.1
Ledo3 = Ok
Config Portc.0 = Output
Ledg3 Alias Portc.0
Ledg3 = Of
Config Portd.2 = Output
Reley Alias Portd.2
Reley = Of
Print "Start ADC"
Start Adc
'\\\\\\\\\\\\\\\
Macro G1
Set Ledg1 : Reset Ledr1 : Reset Ledo1
End Macro
Macro R1
Reset Ledg1 : Set Ledr1 : Reset Ledo1
End Macro
Macro O1
Reset Ledg1 : Reset Ledr1 : Set Ledo1
End Macro
'\\\\\\\\\\\\\\\\\\\
Macro G2
Set Ledg2 : Reset Ledr2 : Reset Ledo2
End Macro
Macro R2
Reset Ledg2 : Set Ledr2 : Reset Ledo2
End Macro
Macro O2
Reset Ledg2 : Reset Ledr2 : Set Ledo2
End Macro
'\\\\\\\\\\\\\\\\\\\
Macro G3
Set Ledg3 : Reset Ledr3 : Reset Ledo3
End Macro
Macro R3
Reset Ledg3 : Set Ledr3 : Reset Ledo3
End Macro
Macro O3
Reset Ledg3 : Reset Ledr3 : Set Ledo3
End Macro
'\\\\\\\\\\\\\\\\\\\\\\\\\
Dim Madc As Integer , Hadc As Integer , M As Integer , H As Integer
Madc = 450 : Hadc = 550
M = Madc -1 : H = Hadc + 1

Do
Button1 = Getadc(5)

'Print ; "acd1=" ; Button1
Waitms 50
'Print ; "acd2=" ; Button2
'Waitms 200
'Print ; "acd3=" ; Button3
'Wait 1
'If Button1 >= Madc And Button1 <= Hadc Then G1
'If Button1 = 0 And Button1 <= M Then O1
'If Button1 >= H And Button1 <= 1023 Then R1
Select Case Button1


  Case Madc To Hadc : G1

  Case Is <= M : O1

  Case Is >= H : R1

End Select

Button2 = Getadc(4)
Waitms 50

'If Button2 >= Madc And Button2 <= Hadc Then G2
'If Button2 = 0 And Button2 <= M Then O2
'If Button2 >= H And Button2 <= 1023 Then R2

Select Case Button2


  Case Madc To Hadc : G2

  Case Is <= M : O2

  Case Is >= H : R2

End Select

Button3 = Getadc(3)
Waitms 50
'If Button3 >= Madc And Button3 <= Hadc Then G3
'If Button3 = 0 And Button3 <= M Then O3
'If Button3 >= H And Button3 <= 1023 Then R3

Select Case Button3


  Case Madc To Hadc : G3

  Case Is <= M : O3

  Case Is >= H : R3

End Select


If Ledg1 = Ok And Ledg2 = Ok And Ledg3 = Ok Then Reley = Ok Else Reley = Of

Loop
End