$regfile = "m8def.dat"
$crystal = 8000000
$hwstack = 64
$swstack = 64
$framesize = 64
$baud = 38400

Ds Alias Portc.0 : Config Ds = Output : Reset Ds
Sh_cp Alias Portc.2 : Config Sh_cp = Output : Reset Sh_cp
Mr Alias Portc.3 : Config Mr = Output
Const St_cp = 1 : Config Portc.1 = Output
Seg_1 Alias Portc.4 : Config Seg_1 = Output : Reset Seg_1
Seg_2 Alias Portc.5 : Config Seg_2 = Output : Reset Seg_2
D1 Alias Pind.5 : D2 Alias Pind.6 : D3 Alias Pind.7 : D4 Alias Pinb.0
Config D1 = Input : Set D1 : Config D2 = Input : Set D2 : Config D3 = Input : Set D3 : Config D4 = Input : Set D4
Dim A As Byte
Reset Mr
Pulseout Portc , St_cp , 5
Set Mr



Do
If D4 = 0 Then
A = Lookup(8 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
Else
A = Lookup(2 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
End If

If D3 = 0 Then
A = Lookup(2 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
Else
A = Lookup(8 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
End If

If D2 = 0 Then
A = Lookup(0 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
Else
A = Lookup(5 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
End If

If D1 = 0 Then
A = Lookup(5 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
Else
A = Lookup(2 , Numbers)
A = Not A
 Shiftout Ds , Sh_cp , A , 1
End If



Pulseout Portc , St_cp , 5
Reset Seg_2 : Set Seg_1
Waitms 10
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
If D4 = 1 Then
A = Lookup(8 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
Else
A = Lookup(5 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
End If

If D3 = 1 Then
A = Lookup(5 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
Else
A = Lookup(8 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
End If

If D2 = 1 Then
A = Lookup(0 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
Else
A = Lookup(2 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
End If

If D1 = 1 Then
A = Lookup(5 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
Else
A = Lookup(2 , Numbers)
A = Not A
Shiftout Ds , Sh_cp , A , 1
End If



Pulseout Portc , St_cp , 5
Set Seg_2 : Reset Seg_1
Waitms 10
Loop
End


Numbers:
Data &H7E                                                   '0
Data &H60                                                   '1
Data &HDA                                                   '2
Data &HF2                                                   '3
Data &H66                                                   '4
Data &HB6                                                   '5
Data &HBE                                                   '6
Data &HE0                                                   '7
Data &HFF                                                   '8
Data &HF6                                                   '9