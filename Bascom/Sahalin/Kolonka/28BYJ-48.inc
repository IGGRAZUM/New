


'\\\\\Шаговый двигатель 28BYJ-48\\\\\
$nocompile
Dim Bit_shag As Byte
Dim Shag_const As Bit                                       'установка шага или полушага 0 - полушаги
Dim A As Dword
Dim T As Byte


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

Macro Shag_com
 If Shag_const = 0 Then
 If Bit_shag = 7 Then Bit_shag = 0 Else Bit_shag = Bit_shag + 1
 Else
 If Bit_shag = 3 Then Bit_shag = 0 Else Bit_shag = Bit_shag + 1
 End If
End Macro



Macro Shag_com2
 If Shag_const = 0 Then
 If Bit_shag = 0 Then Bit_shag = 7 Else Bit_shag = Bit_shag - 1
 Else
 If Bit_shag = 0 Then Bit_shag = 3 Else Bit_shag = Bit_shag - 1
 End If
End Macro


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Macro Shag_no
   Reset N1 : Reset N2 : Reset N3 : Reset N4
End Macro

Macro Shag_0
   Set N1 : Reset N2 : Reset N3 : Reset N4
End Macro

Macro Shag_1
   Set N1 : Set N2 : Reset N3 : Reset N4
End Macro

Macro Shag_2
   Reset N1 : Set N2 : Reset N3 : Reset N4
End Macro

Macro Shag_3
   Reset N1 : Set N2 : Set N3 : Reset N4
End Macro

Macro Shag_4
   Reset N1 : Reset N2 : Set N3 : Reset N4
End Macro

Macro Shag_5
   Reset N1 : Reset N2 : Set N3 : Set N4
End Macro

Macro Shag_6
   Reset N1 : Reset N2 : Reset N3 : Set N4
End Macro

Macro Shag_7
   Set N1 : Reset N2 : Reset N3 : Set N4
End Macro


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub 28byj(byval Shag As Dword , Byval Napr As Byte)         'shag -  это колличество
                                                               'пройденных шагов
                                                               'Napr - направление движения
                                                               '0 - по часовой 1 - против часовой
   A = 0
   If Napr = 0 Then
   For A = 0 To Shag Step 1
   Shag_com
   28byj_48
   Waitms T
   Next A
   Else
   For A = 0 To Shag Step 1
   Shag_com2
   28byj_48
   Waitms T
   Next A
   End If
End Sub


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub 28byj_48
If Shag_const = 0 Then
Select Case Bit_shag
Case 0
 Shag_0
Case 1
 Shag_1
Case 2
 Shag_2
Case 3
 Shag_3
Case 4
 Shag_4
Case 5
 Shag_5
Case 6
 Shag_6
Case 7
 Shag_7
End Select
Else
Select Case Bit_shag
Case 0
 Shag_0
Case 1
 Shag_2
Case 2
 Shag_4
Case 3
 Shag_6
End Select
End If
End Sub