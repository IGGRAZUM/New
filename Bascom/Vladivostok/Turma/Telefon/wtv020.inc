$nocompile


Macro Plays
Reset Play : Waitms 20 : Set Play : Waitms 20
End Macro
Macro Nextv
 Reset Nextpin : Waitms 20 : Set Nextpin : Waitms 200
End Macro
Macro Res
Reset Resetpin : Waitms 20 : Set Resetpin : Waitms 600
End Macro


Sub Rus
Res : Nextv : Voise
Return
End Sub

Sub Eng
Res : Nextv : Nextv : Voise
Return
End Sub

Sub Kor
Res : Nextv : Nextv : Nextv : Voise
Return
End Sub

Sub Gud
Res : Plays : Voise
Return
End Sub

Sub Man
Res : Nextv : Nextv : Nextv : Nextv : Voise
Return
End Sub

Sub Nom
Res : Nextv : Nextv : Nextv : Nextv : Nextv : Voise
Return
End Sub

Sub Vor
Res : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Voise
Return
End Sub

Sub Nog
Res : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Voise
Return
End Sub

Sub Kh
Res : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Voise
Return
End Sub


Sub Voise
Do
If Busy = 0 Or Trub = 1 Then Exit Do
Loop
Return
End Sub