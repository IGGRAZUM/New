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




Sub Pink_ok
Res : Plays
Return
End Sub

Sub Pink_err
Res : Nextv : Nextv : Nextv : Nextv : Nextv
Return
End Sub

'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub Pink(b1 As Byte)
Select Case B1
Case 1
Res : Nextv : Voise
Case 2
Res : Nextv : Nextv : Voise
Case 3
Res : Nextv : Nextv : Nextv  : Voise
Case 4
Res : Nextv : Nextv : Nextv : Nextv : Voise
Case 5
Res : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Voise
Case 6
Res : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Voise
Case 7
Res : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Nextv : Voise
End Select
End Sub

Sub Voise
Do
If Busy = 0 Then Exit Do
Loop
Return
End Sub