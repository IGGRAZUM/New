;
; ------------------------------------------------------------
;
;   PureBasic - Network (Client) example file
;
;    (c) Fantaisie Software
;
; ------------------------------------------------------------
;

If InitMovie() = 0
  MessageRequester("Error", "Can't initialize movie playback !", 0) 
  End
EndIf
Global ports.s="9999"
Global    ipc.s="192.168.4.1" 
Global       temn.s="d:\лифт\темница.mp3"
Global       cab.s="d:\лифт\кабинет врача.mp3"
Global       lift.s="d:\лифт\лифт.mp3"
Global       kor.s="d:\лифт\коридор.mp3"
Global send_data2
;Global port1.s  
;Global port2.s
Global *Buffer = AllocateMemory(1024)
;Global ConnectionID
;Global getData$
;Global dat.s
Global q
;Global volue_info

Structure txt_in_tcp
  tcp_txt2$
  ipcon$
  portcon$
EndStructure
*tcp_txt.txt_in_tcp = AllocateMemory(SizeOf(txt_in_tcp))


    Procedure DateStatusBar(*x) 
Repeat
  Time.s = FormatDate("%hh:%ii:%ss", Date() ) ; Узнаём текущее время
  StatusBarText(12, 0,Time) ; Выводим его на строку состояния
  Delay(1000)
ForEver
EndProcedure 



Procedure play_mp3(mp3_txt.s , mp3_name.s)
  If LoadMovie(0, mp3_txt)
    PlayMovie(0, WindowID(0))
    If InitMovie() >0
    
      volume= GetGadgetState(14)
      MovieAudio(0, volume, 0)
    Delay(100)
    
    q=1
    StatusBarText(12, 1, "Играет:")
    StatusBarText(12, 2, mp3_name)
    EndIf
    EndIf
EndProcedure

Procedure stop_mp3()
  q=0
  StopMovie(0)
  StatusBarText(12, 1,"Стоп!")
  StatusBarText(12, 2,"")
EndProcedure

Procedure AlertThread()
  
   Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(ipc, Val(ports))
  If ConnectionID  
  SendNetworkString(ConnectionID, "off")
If OpenFile(0, "log_lift_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Send 192.168.4.1:9999 "+tims+" : off")
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf
CloseNetworkConnection(ConnectionID)
KillTimer_(WindowID(0), 1)
EndIf
 EndProcedure 


Procedure send_tcp(*tcp_txt.txt_in_tcp)
  ;*Buffer = AllocateMemory(1024)
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(ipc, Val(ports))
  If ConnectionID  
  SendNetworkString(ConnectionID, *tcp_txt\tcp_txt2$)
If OpenFile(0, "log_lift_"+daydat+".txt")    ; opens an existing file or creates one, if it does not exist yet
    FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
    WriteStringN(0, "Send "+*tcp_txt\ipcon$+":"+*tcp_txt\portcon$+" "+tims+" : "+*tcp_txt\tcp_txt2$)
    WriteStringN(0, "------------------------------------------------------------")
    CloseFile(0)
  EndIf
  
CloseNetworkConnection(ConnectionID)
EndIf
If *tcp_txt\tcp_txt2$="on"
  SetTimer_(WindowID(0),1,2000,@AlertThread())
  EndIf
EndProcedure

 
     
If OpenWindow(0, 0, 0, 440, 380, "Управление лифтом и звуковым сопровождением", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;


  If CreateMenu(0, WindowID(0))
    MenuTitle("Файл")     
      MenuBar()
      OpenSubMenu("Треки")
        MenuItem( 1, "Темница")
        MenuItem( 2, "Кабинет врача")
        MenuItem( 3, "Флюрография")
        MenuItem( 4, "Коридор")
        CloseSubMenu()
      OpenSubMenu("Соединение")
        MenuItem( 5, "IP адрес")
        MenuItem( 6, "Порт")
        CloseSubMenu()
         MenuBar()
         MenuItem( 7, "&Quit")
        MenuTitle("Разблокировать") 
         MenuItem(8, "Пароль") 
          EndIf
  
 

  top=10 : is=200
    TextGadget(0,10,top,is,15,"Управление комнатой", #PB_Text_Center) :top+30
    ButtonGadget(1, 10, top,is, 20, "Отправить флюрографию") :top+30
    ButtonGadget(2, 10, top,is, 20, "Возвратить флюрографию") :top+50
     ButtonGadget(3, 10, top,is, 20, "Эмуляция таблицы дальтоников") :top+50
     ButtonGadget(4, 10, top,is, 20, "Открыть дверь") :top+30
     ButtonGadget(5, 10, top,is, 20, "Открыть люк") :top+30
     
    top=10 : is=200
    TextGadget(6,230,top,is,15,"Звуковое сопровождение", #PB_Text_Center) :top+30
    ButtonGadget(7, 230, top,is, 20, "Темница") :top+30
    ButtonGadget(8, 230, top,is, 20, "Кабинет врача") :top+30
     ButtonGadget(9, 230, top,is, 20, "Флюрография") :top+30
     ButtonGadget(10, 230, top,is, 20, "Коридор") :top+40
     TextGadget(13,230,top,is,15,"Громкость : 100%", #PB_Text_Center) :top+20
     TrackBarGadget  (14,  230, top,is,20, 0, 100):top+30
     ButtonGadget(11, 230, top,is, 20, "Стоп") :top+30
     
     
SetGadgetColor(2, #PB_Gadget_BackColor, $00FFFF)
     SetGadgetColor(3, #PB_Gadget_BackColor, $00FF00)
   
   CreateStatusBar(12, WindowID(0))
   AddStatusBarField(80)
   AddStatusBarField(60)
   AddStatusBarField(100)
   AddStatusBarField(#PB_Ignore)
    
  CreateThread( @DateStatusBar(),0) ; Запуск процедуры в отдельном потоке
    If InitNetwork()
  Else
    End
    EndIf
  
 
   mp3_file.s="" 
   mp3_txt.s=""
   
   q=0
   Define Pref.s = GetTemporaryDirectory() + "ar\Preferences.prefs"
   If FileSize(GetTemporaryDirectory() + "ar\") = -2
     If FileSize(Pref) <= 0
   If CreatePreferences(Pref,#PB_Preference_NoSpace)
   PreferenceGroup("MP3")
   WritePreferenceString("Темница", temn)
   WritePreferenceString("Кабинет", cab)
   WritePreferenceString("Лифт", lift)
   WritePreferenceString("Коридор", kor)
   WritePreferenceLong("Громкость", volume) 
   PreferenceGroup("Сеть")
   WritePreferenceString("IP", ipc)
   WritePreferenceString("Порт", ports)
   PreferenceGroup("пароль")
   WritePreferenceString("пароль", "8888")
   ClosePreferences()
   EndIf
 Else
   If OpenPreferences(Pref,#PB_Preference_NoSpace)
     PreferenceGroup("MP3")
   temn= ReadPreferenceString("Темница", "")
   cab= ReadPreferenceString("Кабинет", "")
   lift= ReadPreferenceString("Лифт", "")
   kor= ReadPreferenceString("Коридор", "")
   volume= ReadPreferenceLong("Громкость", 0) 
   PreferenceGroup("Сеть")
   ipc =ReadPreferenceString("IP", "")
   ports=ReadPreferenceString("Порт", "")
   ClosePreferences()
 EndIf
 EndIf
 Else
   CreateDirectory(GetTemporaryDirectory() + "ar\")   
  If CreatePreferences(Pref,#PB_Preference_NoSpace)
   PreferenceGroup("MP3")
   WritePreferenceString("Темница", temn)
   WritePreferenceString("Кабинет", cab)
   WritePreferenceString("Лифт", lift)
   WritePreferenceString("Коридор", kor)
   WritePreferenceLong("Громкость", volume) 
   PreferenceGroup("Сеть")
   WritePreferenceString("IP", ipc)
   WritePreferenceString("Порт", ports)
   PreferenceGroup("пароль")
   WritePreferenceString("пароль", "8888")
   ClosePreferences()
   EndIf
   EndIf  
       *tcp_txt\portcon$=ports  
       *tcp_txt\ipcon$=ipc
       StatusBarText(12, 3, ipc+":"+ports,#PB_StatusBar_Right |#PB_StatusBar_BorderLess)
      SetGadgetText(13, "Громкость : "+Str(volume)+"%")
      SetGadgetState(14, volume) 
      
      DisableGadget(1, 1) 
    DisableGadget(2, 1)
    DisableGadget(3, 1)
    DisableGadget(4, 1)
    DisableGadget(5, 1)
      ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
     Repeat
       If q=1
       Result.q = MovieStatus(0)
       If result=0 
         Select mp3_txt
     Case temn
       mp3_name.s="Кабинет врача"
       mp3_txt=cab 
       play_mp3(mp3_txt , mp3_name) 
     Case cab
       mp3_name.s="Флюрография"
       mp3_txt=lift 
       play_mp3(mp3_txt , mp3_name) 
     Case lift
       mp3_name.s="Коридор"
       mp3_txt=kor 
       play_mp3(mp3_txt , mp3_name) 
     Case kor
       MessageRequester("Треки", "Музыка не играет! Треки кончились", 0)
       mp3_txt=""
       q=0
       stop_mp3()
       SetGadgetText(17, "Стоп")
        SetGadgetState(15, 0) 
       EndSelect
         
         EndIf
       EndIf
       
    ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\   
  Event=WaitWindowEvent()  
  Select Event
    Case #PB_Event_Gadget
    Select EventGadget()        
      Case 1
       *tcp_txt\tcp_txt2$="d"
       CreateThread(@send_tcp(),*tcp_txt)       
       mp3_name.s="Флюрография"
       mp3_txt=lift
       ;MessageRequester("Флюрография", "Флюрография отправлена", 0)
       play_mp3(mp3_txt , mp3_name) 
       Case 2
       *tcp_txt\tcp_txt2$="u"
       CreateThread(@send_tcp(),*tcp_txt)
       ;MessageRequester("Флюрография", "Флюрография сейчас будет возвращена", 0)
       Case 3
       *tcp_txt\tcp_txt2$="on"
       CreateThread(@send_tcp(),*tcp_txt)
       ;MessageRequester("Флюрография", "Таблица сработала", 0)
       Case 4
       *tcp_txt\tcp_txt2$="D"
       CreateThread(@send_tcp(),*tcp_txt)
       ;MessageRequester("Флюрография", "Дверь открыта", 0)
       Case 5
       *tcp_txt\tcp_txt2$="H"
       CreateThread(@send_tcp(),*tcp_txt)
      ; MessageRequester("Флюрография", "Люк открыт", 0)
     Case 7
       mp3_name.s="Темница"
       mp3_txt=temn 
       play_mp3(mp3_txt , mp3_name) 
     Case 8
       mp3_name.s="Кабинет врача"
       mp3_txt=cab 
       play_mp3(mp3_txt , mp3_name) 
     Case 9
       mp3_name.s="Флюрография"
       mp3_txt=lift 
       play_mp3(mp3_txt , mp3_name) 
     Case 10
       mp3_name.s="Коридор"
       mp3_txt=kor 
       play_mp3(mp3_txt , mp3_name) 
       Case 11
         stop_mp3()
       Case 14         
         volume= GetGadgetState(14) 
         SetGadgetText(13, "Громкость : "+Str(volume)+"%")
         If OpenPreferences(Pref)
  PreferenceGroup("MP3")
    WritePreferenceLong("Громкость", volume)
    ClosePreferences()
    EndIf
         If q=1
           MovieAudio(0, volume, 0)
           EndIf
         
       EndSelect
       
Case #PB_Event_Menu
  Select EventMenu()
      Case 1
        MovieName$ = OpenFileRequester("Выбор файла для проигрования", "", "Audio files|*.mp3;*.wav|All Files|*.*", 0)
        temn=MovieName$
          If OpenPreferences(Pref)
  PreferenceGroup("MP3")
    WritePreferenceString("Темница", temn)
  ClosePreferences()
EndIf
      Case 2
       MovieName$ = OpenFileRequester("Выбор файла для проигрования", "", "Audio files|*.mp3;*.wav|All Files|*.*", 0)
       cab=MovieName$
        If OpenPreferences(Pref)
  PreferenceGroup("MP3")
    WritePreferenceString("Кабинет", cab)
    ClosePreferences()
    EndIf
     Case 3
       MovieName$ = OpenFileRequester("Выбор файла для проигрования", "", "Audio files|*.mp3;*.wav|All Files|*.*", 0)
       lift=MovieName$
        If OpenPreferences(Pref)
  PreferenceGroup("MP3")
    WritePreferenceString("Лифт", lift)
    ClosePreferences()
    EndIf
     Case 4
       MovieName$ = OpenFileRequester("Выбор файла для проигрования", "", "Audio files|*.mp3;*.wav|All Files|*.*", 0)
       kor=MovieName$
        If OpenPreferences(Pref)
  PreferenceGroup("MP3")
    WritePreferenceString("Коридор", kor)
    ClosePreferences()
  EndIf
  Case 5
  Input$ = InputRequester("Ввод", "IP адрес:", ipc)

  If Input$ < "192.168."
    a$ = "Введите правильно! Пример:192.168.1.1. А вы ввели:" + Chr(10)  ; Chr(10) only needed
    a$ + Input$                                                  ; for line-feed
    MessageRequester("Information", a$, 0)
  Else
    If OpenPreferences(Pref)
  PreferenceGroup("Сеть")
    WritePreferenceString("IP", Input$)
    ClosePreferences()
    ipc=Input$
    *tcp_txt\ipcon$=ipc
       StatusBarText(12, 3, ipc+":"+ports,#PB_StatusBar_Right |#PB_StatusBar_BorderLess)
  EndIf
  
EndIf
Case 6
 Input$ = InputRequester("Ввод", "Порт:", ports)

  If Input$ < "."
    a$ = "Введите правильно! Пример:9999. А вы ввели:" + Chr(10)  ; Chr(10) only needed
    a$ + Input$                                                  ; for line-feed
    MessageRequester("Information", a$, 0)
  Else
    If OpenPreferences(Pref)
  PreferenceGroup("Сеть")
    WritePreferenceString("Порт", Input$)
    ClosePreferences()
    ports=Input$
    *tcp_txt\portcon$=ports
     StatusBarText(12, 3, ipc+":"+ports,#PB_StatusBar_Right |#PB_StatusBar_BorderLess)
  EndIf
  
EndIf 

Case 7
  Quit = 1
Case 8
  Input$ = InputRequester("Ввод", "Пароль:", "******",#PB_InputRequester_Password)
  
If OpenPreferences(Pref)
  PreferenceGroup("пароль")
  If Input$ =ReadPreferenceString("пароль", "")
    DisableGadget(1, 0) 
    DisableGadget(2, 0)
    DisableGadget(3, 0)
    DisableGadget(4, 0)
    DisableGadget(5, 0); for line-feed
   
  Else
    MessageRequester("Разблокировка", "Пароль введен не верно", 0)
   DisableGadget(1, 1) 
    DisableGadget(2, 1)
    DisableGadget(3, 1)
    DisableGadget(4, 1)
    DisableGadget(5, 1)
EndIf 
ClosePreferences()
EndIf
      EndSelect   
       EndSelect
       

  Until Event = #PB_Event_CloseWindow  Or Quit = 1
  
EndIf 

End
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 209
; FirstLine = 125
; Folding = g
; EnableXP
; UseIcon = D:\fixiki\Basic\TCP_ip\icon_app\ico\result.ico
; Executable = Р»РёС„С‚\РЈРїСЂР°РІР»РµРЅРёРµ Р»РёС„С‚РѕРј v0.3.exe