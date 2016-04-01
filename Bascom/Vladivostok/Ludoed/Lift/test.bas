$regfile = "m32def.dat"
$crystal = 16000000
$hwstack = 40
$swstack = 40
$framesize = 40

Led Alias Portd.2
Config Led = Output
Led = 1

Ir Alias Pina.0 : Config Ir = Input                         '0-белый 1-черный


Do
If Ir = 1 Then Led = 0 Else Led = 1
Loop