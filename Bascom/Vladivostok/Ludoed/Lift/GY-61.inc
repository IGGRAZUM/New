$nocompile
Dim Xx As Integer , Yy As Integer , Zz As Integer


Dim Xs As Single , Ys As Single , Zs As Single

Sub Init_gy61

 Xx = Getadc(x)
 Yy = Getadc(y)
 Zz = Getadc(z)


Xx = Xx - 410
Xs = Xx * 0.9
Xx = Xs

Yy = Yy - 410
Ys = Yy * 0.9
Yy = Ys


Zz = Zz - 425
Zs = Zz * 0.9
Zz = Zs
End Sub

Sub Init_kalibr_vertical

End Sub

Sub Init_kalibr_gorizont

End Sub