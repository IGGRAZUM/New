UseSQLiteDatabase()
;{ global
Global Tim.s
Global thread
Global thread_time
Global fm=0
Global fd=0
Global flag_test=0
Global flag_igr=0
Global flag_start=0
Global flag_exit=0
Global Counts=0
Global MD5$
Global pass_put.s
Global pass_igr.s
Global pass_put_def.s
Global pass_igr_def.s
#AdressDB = 0
#frm_Main = 0
Global md.s
Global daydat_in.s
Global ids.s
Global Dim other.b(1)
Global Dim other_old.b(1)
Global clock_start.s
Global clock_stop.s
Global Dim clock_in.d(4)
Global Dim clock_in_old.d(4)
Global NewMap clock.s()
Global toch.s
Global door.b=0
Global q
Global n=0
Global log_ftp.s
Global volume
Global ip_esp.s="192.168.1.40"
Global port_esp.s="80"
;}
;{ clock
clock("252")="0"
clock("96")="1"
clock("218")="2"
clock("242")="3"
clock("102")="4"
clock("182")="5"
clock("190")="6"
clock("224")="7"
clock("254")="8"
clock("246")="9"
clock("238")="A"
clock("110")="H"
clock("156")="C"
clock("16")="_"
clock("0")="  "
;}
;{ init movie
If InitMovie() = 0
  MessageRequester("Error", "Кодеки не работают!!!", 0) 
  End
EndIf
;}
;{ define
Define db_name.s = GetTemporaryDirectory() + "Adr0.db"
Define SQL.s
Global temn.s="d:\лифт\темница.mp3"
Global cab.s="d:\лифт\лифт окон.mp3"
Global lift.s="d:\лифт\лифт.mp3"
Global kor.s="d:\лифт\коридор.mp3"
Global mp3_txt.s
Global mp3_txt_old.s
Global mp3_name.s=""
Structure txt_in_get
  get_txt2$
  ipcon$
  portcon$
EndStructure

*get_txt.txt_in_get = AllocateMemory(SizeOf(txt_in_get))
*get_txt\ipcon$=ip_esp
Global Port = 6666
Global buf.s
Global buf2.s
Global byte1
Global byte2
Global clock1
Global clock2
Global clock3
Global clock4
;}
Declare im(colors.b)   
Procedure ping(in_ip.s) 
  Protected *host.hostent, ret.l 
  host.s = in_ip 
  *host = gethostbyname_(host) 
  If *host 
    ret = PeekL(PeekL(*host\h_addr_list)) 
  Else 
    ret = *host 
  EndIf 
  sel_ip = ret  
  ResultSize.l = SizeOf(ICMP_ECHO_REPLY) + 255 
  *Result = AllocateMemory(ResultSize) 
  
  hFile.l = IcmpCreateFile_() 
  lngResult.l = IcmpSendEcho_(hFile, sel_ip, Space(255), 255, 0, *Result, ResultSize, 2000) 
  If lngResult 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
  
  IcmpCloseHandle_(hFile) 
  FreeMemory(*Result) 
  
EndProcedure 
Procedure AlertThread()
  
  
  KillTimer_(WindowID(0), 1)
  
  ;CreateThread(@AlertThread2(),*dats_txt)  
EndProcedure    
Declare play_mp3()
Procedure test_get()
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(ip_esp,  Val(port_esp))
  If ConnectionID 
    *Buffer2 = AllocateMemory(65536)
    getData$ = "GET /"+"60"+" HTTP/1.1"+#CRLF$
    getData$ + "Host:"+ip_esp+#CRLF$
    getData$ + #CRLF$
    SendNetworkString(ConnectionID, getData$, #PB_UTF8)
    ReceiveNetworkData(ConnectionID, *Buffer2, 65536)
    CloseNetworkConnection(ConnectionID)
    ;AddGadgetItem(11, 0, "Send: "+*get_txt\ipcon$+":"+*get_txt\portcon$+" "+tims+" : "+getData$)
    If OpenFile(0, GetTemporaryDirectory() + "ar\log_"+daydat+".log")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                                                ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Send "+ip_esp+":"+port_esp +tims+" : "+getData$)
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    ;AddGadgetItem(11, 3, "------------------------------------------------------------")
    ;AddGadgetItem(11, 3, "Resive: "+ tims+" : "+PeekS(*Buffer2, -1, #PB_UTF8 ))
    
    If OpenFile(0, GetTemporaryDirectory() + "ar\log_"+daydat+".log")    ; opens an existing file or creates one, if it does not exist yet
      FileSeek(0, Lof(0))                                                ; jump to the end of the file (result of Lof() is used)
      WriteStringN(0, "Resive "+ tims+" : "+PeekS(*Buffer2, -1, #PB_UTF8 ))
      WriteStringN(0, "------------------------------------------------------------")
      CloseFile(0)
    EndIf
    ;AddGadgetItem(11, 3, "------------------------------------------------------------") 
    FreeMemory(*Buffer2)
    im(7)
    flag_igr=1
  Else
    ;Beep_(700,600)
    im(0)
    MessageRequester("Error", "Квест не отвечает!", 0)
    flag_igr=0
    ;End 
  EndIf
  
EndProcedure  
Procedure im(colors.b)
  If StartDrawing(ImageOutput(0))
    DrawingMode(#PB_2DDrawing_Default)
    DrawImage(ImageID(1), 0, 0)
    DrawingMode(#PB_2DDrawing_AlphaBlend )
    If colors&4  
      Box( 0,  260, 290, 150, RGBA($00,$FF,$00,$3A))
    Else
      Box( 0,  260, 290, 150, RGBA($FF,$00,$00,$3A))
    EndIf
    If colors&2  
      Box( 130,  10, 180, 250, RGBA($00,$FF,$00,$3A))
    Else
      Box( 130,  10, 180, 250, RGBA($FF,$00,$00,$3A))
    EndIf
    If colors&1  
      Box( 0,  10, 125, 250, RGBA($00,$FF,$00,$3A))
    Else
      Box( 0,  10, 125, 250, RGBA($FF,$00,$00,$3A))
    EndIf
    
    ;DrawingMode(#PB_2DDrawing_Default)
    ;Дверь в кабинет врача
    ;X=240:Y=102:gr=45
    ;LineXY(X, Y, X+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;LineXY(X+1, Y, X+1+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;LineXY(X+2, Y, X+2+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;Дверь в коридор
    ;X=240:Y=261
    ;LineXY(X, Y, X+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;LineXY(X+1, Y, X+1+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;LineXY(X+2, Y, X+2+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;Дверь выход
    ;X=115:Y=116:gr=135
    ;LineXY(X, Y, X+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;LineXY(X+1, Y, X+1+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;LineXY(X+2, Y, X+2+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00))
    ;Дверь холодильник
    ;X=16:Y=116:gr=45
    ;LineXY(X, Y, X+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;LineXY(X+1, Y, X+1+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;LineXY(X+2, Y, X+2+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00))
    ;Дверь в морг
    ;X=121:Y=343:gr=225
    ;LineXY(X, Y, X+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;LineXY(X+1, Y, X+1+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    ;LineXY(X+2, Y, X+2+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00))
    StopDrawing()
    If flag_start=0
      SetGadgetState(200,ImageID(0)):SetGadgetState(201,ImageID(0)):SetGadgetState(202,ImageID(0))
    Else
      SetGadgetState(200,ImageID(0))
    EndIf
  EndIf
EndProcedure
Procedure mm()
  If StartDrawing(ImageOutput(0))
    DrawingMode(#PB_2DDrawing_Default)
    ;DrawImage(MapLabel, 0, 0)
    DrawImage(ImageID(1), 0, 0)
    DrawingMode(#PB_2DDrawing_AlphaBlend )
    StopDrawing()
    If flag_start=0
      SetGadgetState(200,ImageID(0)):SetGadgetState(201,ImageID(0)):SetGadgetState(202,ImageID(0))
    Else
      SetGadgetState(200,ImageID(0))
    EndIf
  EndIf  
EndProcedure
Procedure idoor()  
  If StartDrawing(ImageOutput(0))
    DrawingMode(#PB_2DDrawing_Default)
    DrawImage(ImageID(1), 0, 0)
    If other(0)&16
      ;Дверь в кабинет врача
      gr=45
    Else 
      gr=0
    EndIf
    X=240:Y=102
    LineXY(X, Y, X+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+1, Y, X+1+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+2, Y, X+2+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    
    If other(0)&8
      ;Дверь в коридор
      gr=45
      If q=1 And mp3_txt <> kor And fm=0
        fm=1
        mp3_name="Коридор"
        mp3_txt_old=mp3_txt
        mp3_txt=kor  
        play_mp3()
      EndIf
    Else 
      gr=0
    EndIf    
    X=240:Y=261
    LineXY(X, Y, X+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+1, Y, X+1+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+2, Y, X+2+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    
    If other(0)&4
      ;Планшет
      BackColor( RGB($ff,$00,$ff)) ; Change the text back and front colour
      FrontColor( RGB($00,$FF,$00))
      
      DrawText(173, 140, "Линзар")
      
    EndIf
    
    If other(0)&2
      ;Телефон
      BackColor( RGB($ff,$00,$ff)) ; Change the text back and front colour
      FrontColor( RGB($00,$FF,$00))
      
      DrawText(173, 140, "Звенит телефон")
      
    EndIf
    
    If other(1)&4      
      gr=135      
    Else 
      gr=180
    EndIf
    ;Дверь выход
    X=115:Y=116
    LineXY(X, Y, X+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+1, Y, X+1+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+2, Y, X+2+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00))
    
    If other(0)&128
      gr=45
    Else 
      gr=0
    EndIf
    ;Дверь холодильник
    X=16:Y=116
    LineXY(X, Y, X+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+1, Y, X+1+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+2, Y, X+2+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00))
    
    If other(0)&32
      gr=225
    Else 
      gr=270
    EndIf
    ;Дверь в морг
    X=121:Y=343
    LineXY(X, Y, X+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+1, Y, X+1+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+2, Y, X+2+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00))
    
    If other(0)&64
      gr=315
    Else
      gr=270                
    EndIf
    ;Дверь в пыточную
    X=45:Y=237
    LineXY(X, Y, X+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+1, Y, X+1+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00)) 
    LineXY(X+2, Y, X+2+Cos(Radian(gr))*20, Y+Sin(Radian(gr))*20 ,RGB($00,$00,$00))
    
    
    If other(1)&2
      gr=225
    Else
      gr=270                
    EndIf
    ;Дверь в полку с оргонами
    X=47:Y=90
    LineXY(X, Y, X+Cos(Radian(gr))*10, Y+Sin(Radian(gr))*10 ,RGB($00,$00,$00)) 
    LineXY(X+1, Y, X+1+Cos(Radian(gr))*10, Y+Sin(Radian(gr))*10 ,RGB($00,$00,$00)) 
    LineXY(X+2, Y, X+2+Cos(Radian(gr))*10, Y+Sin(Radian(gr))*10 ,RGB($00,$00,$00))
    BackColor( RGB($ff,$00,$ff)) ; Change the text back and front colour
    FrontColor( RGB($00,$FF,$00))
    
    DrawText(173, 102, Tim)
    StopDrawing()  
    ;StartDrawing(WindowOutput(0))
    If flag_start=0
      SetGadgetState(200,ImageID(0)):SetGadgetState(201,ImageID(0)):SetGadgetState(202,ImageID(0))
    Else
      SetGadgetState(200,ImageID(0))
    EndIf
  EndIf
EndProcedure
Procedure tims() 
  clock_in_old(0)= clock_in(0) :  clock_in_old(1)= clock_in(1) :  clock_in_old(2)= clock_in(2) : clock_in_old(3)= clock_in(3)
  clock_in_old(4)= clock_in(4)
  toch2.s=toch
  Select clock_in(1)
    Case 238
      toch=" "
    Case 110
      toch=" "
    Case 156
      toch=" "
    Case 16
      toch=" "
    Case 0
      toch=" "
    Default
      toch=":"
  EndSelect
  If toch=toch2 
    Tim = clock(Str(clock_in(0)))+clock(Str(clock_in(1)))+toch+clock(Str(clock_in(2)))+clock(Str(clock_in(3)))+" "
  Else
    idoor()
    Tim = clock(Str(clock_in(0)))+clock(Str(clock_in(1)))+toch+clock(Str(clock_in(2)))+clock(Str(clock_in(3)))+" "
  EndIf
  If clock_in(1) <> 0
    If q=1 And mp3_txt <> cab And fm=0
      mp3_name="Кабинет врача"
      mp3_txt_old=mp3_txt
      mp3_txt=cab 
      play_mp3()
    EndIf
  EndIf
  idoor()
EndProcedure
Procedure obr(*x)      
  
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ;   logs.s = GetTemporaryDirectory() +"ar\logs"+daydat+".log" 
  ;   logs2.s = GetTemporaryDirectory() +"ar\logs_inget"+daydat+".log" 
  ;   If FileSize(logs) <= 0
  ;     CreateFile(0,logs)  
  ;     CloseFile(0)
  ;   EndIf  
  ;   If FileSize(logs) <= 0
  ;     CreateFile(1,logs2)  
  ;     CloseFile(1)
  ;   EndIf 
  If CountString(buf, "hc165")
    Dats.s="Client 192.168.1.40  has send a packet ! "+#CRLF$+"String: "+buf+#CRLF$
    Position = FindString(buf, " ", 1)
    Position2 = FindString(buf, "/", 1)
    buf=Mid(buf, Position, Position2-Position)
    cont= CountString(buf, ",")          
    Position3 = FindString(buf, ",", 1)
    Dats + "Байт№1= "+Mid(buf, 1, Position3-1)+#CRLF$
    For k = 2 To cont 
      buf=Mid(buf, Position3+1, (Position2-Position3))
      Position3 = FindString(buf, ",", 1)
      Dats + "Байт№"+k+"= "+Mid(buf, 1, Position3-1)+#CRLF$
    Next
    
  ElseIf CountString(buf, "hc595")
    Dats.s="Client 192.168.1.40  has send a packet ! "+#CRLF$+"String: "+buf+#CRLF$
    other_old(0)=other(0)
    other_old(1)=other(1)
    Position = FindString(buf, " ", 1)
    Position2 = FindString(buf, "/", 1)
    buf=Mid(buf, Position, Position2-Position)
    cont= CountString(buf, ",") -1         
    Position3 = FindString(buf, ",", 1)
    Dats + "Байт№4= "+Mid(buf, 1, Position3-1)+#CRLF$
    other(0)=Val(Mid(buf, 1, Position3-1))
    buf=Mid(buf, Position3+1, (Position2-Position3))
    Position3 = FindString(buf, ",", 1)
    Dats + "Байт№5= "+Mid(buf, 1, Position3-1)+#CRLF$
    other(1)=Val(Mid(buf, 1, Position3-1))
    im=0
    For k = 2 To cont 
      buf=Mid(buf, Position3+1, (Position2-Position3))
      Position3 = FindString(buf, ",", 1)
      Dats + "Байт№"+k+"= "+Mid(buf, 1, Position3-1)+#CRLF$
      clock_in(im)=Val(Mid(buf, 1, Position3-1))
      im=im+1
    Next
  EndIf
  If CountString(buf2, "hc595")
    Dats2.s="Client 192.168.1.40  has send a packet ! "+#CRLF$+"String: "+buf2+#CRLF$
    other_old(0)=other(0)
    other_old(1)=other(1)
    ln=FindString(buf2, "hc595", 1)
    buf2=Mid(buf2, ln)
    Position = FindString(buf2, " ", 1)
    Position2 = FindString(buf2, "/", 1)
    buf2=Mid(buf2, Position, Position2-Position)
    cont= CountString(buf2, ",") -1         
    Position3 = FindString(buf2, ",", 1)
    Dats2 + "Байт№4= "+Mid(buf2, 1, Position3-1)+#CRLF$
    other(0)=Val(Mid(buf2, 1, Position3-1))
    buf2=Mid(buf2, Position3+1, (Position2-Position3))
    Position3 = FindString(buf2, ",", 1)
    Dats2 + "Байт№5= "+Mid(buf2, 1, Position3-1)+#CRLF$
    other(1)=Val(Mid(buf2, 1, Position3-1))
    im=0
    For k = 2 To cont 
      buf2=Mid(buf2, Position3+1, (Position2-Position3))
      Position3 = FindString(buf2, ",", 1)
      Dats2 + "Байт№"+k+"= "+Mid(buf2, 1, Position3-1)+#CRLF$
      clock_in(im)=Val(Mid(buf2, 1, Position3-1))
      im=im+1
    Next
  EndIf
  
  If flag_exit=0
    If other_old(0)<>other(0) Or other_old(1)<>other(1)
      idoor()
      tims() 
    EndIf
    If clock_in_old(0)<> clock_in(0) Or  clock_in_old(1)<>clock_in(1) Or  clock_in_old(2)<> clock_in(2) Or clock_in_old(3)<>clock_in(3) Or  clock_in_old(4)<> clock_in(4)
      tims() 
    EndIf
  EndIf
  ;   If Dats<>""
  ;   If OpenFile(0,logs)
  ;     FileSeek(0, Lof(0))         ; jump to the end of the file (result of Lof() is used)
  ;     WriteStringN(0, "Resive "+ tims+" : "+Dats)
  ;     CloseFile(0)
  ;   EndIf 
  ;   EndIf
  ;   If Dats2<>""
  ;   If OpenFile(1,logs2)
  ;     FileSeek(1, Lof(1))         ; jump to the end of the file (result of Lof() is used)
  ;     WriteStringN(1, "Resive in get "+ tims+" : "+Dats2)
  ;     CloseFile(1)
  ;   EndIf
  ;   EndIf
EndProcedure
Procedure send_get(*get_txt.txt_in_get)
  
  Tims.s = FormatDate("%hh:%ii:%ss", Date() )
  daydat.s=FormatDate("%yy.%mm.%dd", Date())
  ConnectionID = OpenNetworkConnection(*get_txt\ipcon$, Val(*get_txt\portcon$))
  If ConnectionID 
    *Buffer2 = AllocateMemory(65536)
    getData$ = "GET /"+*get_txt\get_txt2$+" HTTP/1.1"+#CRLF$
    getData$ + "Host:"+*get_txt\ipcon$+#CRLF$
    getData$ + #CRLF$
    SendNetworkString(ConnectionID, getData$, #PB_UTF8)
    ReceiveNetworkData(ConnectionID, *Buffer2, 65536)
    buf2=PeekS(*Buffer2, -1, #PB_UTF8)    
    CloseNetworkConnection(ConnectionID)
    CreateThread( @obr(),0) ; Запуск процедуры в отдельном потоке
                            ;AddGadgetItem(11, 0, "Send: "+*get_txt\ipcon$+":"+*get_txt\portcon$+" "+tims+" : "+getData$)
                            ;     If OpenFile(2, GetTemporaryDirectory() + "ar\logs_"+daydat+".log")    ; opens an existing file or creates one, if it does not exist yet
                            ;       FileSeek(2, Lof(2))                                                ; jump to the end of the file (result of Lof() is used)
                            ;       WriteStringN(2, "Send "+*get_txt\ipcon$+":"+*get_txt\portcon$+" "+tims+" : "+getData$)
                            ;       WriteStringN(2, "------------------------------------------------------------")
                            ;       CloseFile(2)
                            ;     EndIf
                            ;     ;AddGadgetItem(11, 3, "------------------------------------------------------------")
                            ;     ;AddGadgetItem(11, 3, "Resive: "+ tims+" : "+PeekS(*Buffer2, -1, #PB_UTF8 ))
                            ;     
                            ;     If OpenFile(2, GetTemporaryDirectory() + "ar\logs_"+daydat+".log")    ; opens an existing file or creates one, if it does not exist yet
                            ;       FileSeek(2, Lof(2))                                                ; jump to the end of the file (result of Lof() is used)
                            ;       WriteStringN(2, "Resive "+ tims+" : "+PeekS(*Buffer2, -1, #PB_UTF8 ))
                            ;       WriteStringN(2, "------------------------------------------------------------")
                            ;       CloseFile(2)
                            ;     EndIf
                            ;AddGadgetItem(11, 3, "------------------------------------------------------------") 
    FreeMemory(*Buffer2)
  Else
    MessageRequester("Error", "Квест не отвечает!", 0)
    ;End 
  EndIf
  
EndProcedure 
Procedure server(*x)
  
  If CreateNetworkServer(0, Port)
    ;AddGadgetItem(1,0, "Server created (Port "+Str(Port)+").")
    Repeat
      
      SEvent = NetworkServerEvent()
      
      If SEvent 
        ClientID = EventClient()  
        Select SEvent      
          Case #PB_NetworkEvent_Connect          
            ;AddGadgetItem(1, 1, "A new client has connected !")          
          Case #PB_NetworkEvent_Data
            coun=0
            *Buffer3 = AllocateMemory(65536)
            ReceiveNetworkData(ClientID, *Buffer3, 65536)
            buf=PeekS(*Buffer3, -1, #PB_UTF8)
            SendNetworkString(ClientID, "http 200 Ok!"+#CRLF$)
            ;RTrim(buf, #CRLF$)
            ;AddGadgetItem(1, 2, "edit= "+buf)           
            
          Case #PB_NetworkEvent_Disconnect
            ;FreeMemory(*Buffer)
            If coun=0
              coun=coun+1
              ;AddGadgetItem(1, 2, Dats)
              CreateThread( @obr(),0) ; Запуск процедуры в отдельном потоке
              FreeMemory(*Buffer3)
            EndIf        
        EndSelect 
      EndIf
    ForEver 
    CloseNetworkServer(0)
  Else
    MessageRequester("Error", "Сервер не запущен!", 0)
  EndIf
EndProcedure
Procedure DateStatusBar(*x)   
  Repeat
    Time.s = FormatDate("%hh:%ii:%ss", Date() ) ; Узнаём текущее время
    StatusBarText(12, 0,Time)                   ; Выводим его на строку состояния
    Delay(1000)
  ForEver
EndProcedure 
Procedure start()
  fm=0
  flag_start=1
  clock_start=FormatDate("%hh:%ii:%ss", Date() ); Узнаём текущее время
  fm=0
  OpenGadgetList(1)
  ClearGadgetItems(1)
  AddGadgetItem(1, -1, "Игра")
  ImageGadget(200, 125, 30, 290, 380, ImageID(0))
  top=10 : is=100
  TextGadget(6,10,top,is,20,"Открытие дверей", #PB_Text_Center | #PB_Text_Border) :top+25
  ButtonGadget(7, 10, top,is, 20, "Кабинет врача",#PB_Button_Toggle) :top+25
  ButtonGadget(22, 10, top,is, 20, "Планшет") :top+25
  GadgetToolTip(22, "Эмуляция работы планшета. Работает только, когда включится цифровая головоломка.")
  ButtonGadget(8, 10, top,is, 20, "Коридор",#PB_Button_Toggle) :top+25
  ButtonGadget(9, 10, top,is, 20, "Морг",#PB_Button_Toggle) :top+25
  ButtonGadget(10, 10, top,is, 20, "Пыточная",#PB_Button_Toggle) :top+25
  ButtonGadget(11, 10, top,is, 20, "Холодильник",#PB_Button_Toggle) :top+25
  ButtonGadget(14, 10, top,is, 20, "Полка с органами",#PB_Button_Toggle) :top+25
  ButtonGadget(13, 10, top,is, 20, "Выход",#PB_Button_Toggle) :top+50
  TextGadget(16,10,top,is,20,"Остальное", #PB_Text_Center | #PB_Text_Border) :top+25
  ButtonGadget(15, 10, top,is, 20, "Стоп") :top=30:is+200
  GadgetToolTip(15, "Останавливает игру. При остановке закрывает все двери и выводит сколько времени шла игра.")
  TextGadget(18,430,top,is,15,"Громкость : "+volume+"%", #PB_Text_Center) :top+30
  TrackBarGadget  (17,  430, top,is,20, 0, 100):top+50
  GadgetToolTip(17, "Настройка громкости звука трека.")
  TextGadget  (29, 430,top,is,15,"Системная громкость", #PB_Text_Center):top+30:is-200
  ButtonGadget  (30,  480, top,is,20,  "Тише")
  GadgetToolTip(30, "Делает тише звук компьютера.")
  ButtonGadget  (31,  580, top,is,20,  "Громче"):top+60:is+200
  GadgetToolTip(31, "Делает громче звук компьютера.")
  SetGadgetState(17, volume)
  TextGadget  (32, 430,top,is,15,"Треки", #PB_Text_Center):top+30
  ButtonGadget  (33,  430, top,is,20,  "Темница"):top+25
  ButtonGadget  (34,  430, top,is,20,  "Кабинет врача"):top+25
  ButtonGadget  (35,  430, top,is,20,  "Лифт"):top+25
  ButtonGadget  (36,  430, top,is,20,  "Коридор"):top+25
  ButtonGadget  (37,  430, top,is,20,  "Стоп")
  GadgetToolTip(37, "Останавливает проигрывание треков.")
  CloseGadgetList()
  
  
EndProcedure
Procedure stop()  
  clock_stop=FormatDate("%hh:%ii:%ss", Date() ); Узнаём текущее время
  OpenGadgetList(1)
  ClearGadgetItems(1)
  AddGadgetItem(1, -1, "Стартовая")
  ImageGadget(200, 125, 30, 290, 380, ImageID(0))
  top=10 : is=100
  ButtonGadget(2, 10, top,is, 20, "Проверка") :top+25
  GadgetToolTip(2, "Проверка соединения с квестом и интернетом, а также перезапуск служб для корректной работы системы.")
  ButtonGadget(3, 10, top,is, 20, "Старт") :top+25
  GadgetToolTip(3, "Начало игры")
  ButtonGadget(28, 10, top,is, 20, "Тестовая") :top+25
  ButtonGadget(4, 10, top,is, 20, "Настройка") :top+25
  ButtonGadget(5, 10, top,is, 20, "Сборка") :top+60
  ButtonGadget(19, 10, top,is, 20, "Закрыть") :top+50
  GadgetToolTip(19, "Выход из программы. Закрывает корректор голоса.")
  ;ImageGadget(0, 125, 30, 290, 380, ImageID(0))
  
  AddGadgetItem(1, -1, "Настройки")
  ImageGadget(201, 125, 30, 290, 380, ImageID(0))
  top=10 : is=100
  TextGadget(27,10,top,is,20,"Музыка", #PB_Text_Center | #PB_Text_Border) :top+25
  ButtonGadget(23, 10, top,is, 20, "Темница") :top+25
  ButtonGadget(24, 10, top,is, 20, "Кабинет врача") :top+25
  ButtonGadget(25, 10, top,is, 20, "Лифт") :top+25
  ButtonGadget(26, 10, top,is, 20, "Коридор") :top+60
  AddGadgetItem(1, -1, "Сборка")
  ImageGadget(202, 125, 30, 290, 380, ImageID(0))
  top=10 : is=100
  TextGadget(6,10,top,is,20,"Открытие дверей", #PB_Text_Center | #PB_Text_Border) :top+25
  ButtonGadget(7, 10, top,is, 20, "Кабинет врача",#PB_Button_Toggle) :top+25
  ButtonGadget(8, 10, top,is, 20, "Коридор",#PB_Button_Toggle) :top+25
  ButtonGadget(9, 10, top,is, 20, "Морг",#PB_Button_Toggle) :top+25
  ButtonGadget(10, 10, top,is, 20, "Пыточная",#PB_Button_Toggle) :top+25
  ButtonGadget(11, 10, top,is, 20, "Холодильник",#PB_Button_Toggle) :top+25
  ButtonGadget(14, 10, top,is, 20, "Полка с органами",#PB_Button_Toggle) :top+25
  ButtonGadget(13, 10, top,is, 20, "Выход",#PB_Button_Toggle) :top+50 
  ButtonGadget(20, 10, top,is, 20, "Открыть всё") :top+25
  GadgetToolTip(20, "Открывает все двери в квесте.")
  ButtonGadget(21, 10, top,is, 20, "Закрыть всё") :top+25
  GadgetToolTip(21, "Закрывает все двери в квесте.")
  CloseGadgetList()
  SetGadgetState(1, 0):DisableGadget(28, 1):DisableGadget(3, 1):DisableGadget(7, 1) :DisableGadget(8, 1):DisableGadget(9, 1):DisableGadget(10, 1)
  DisableGadget(11, 1):DisableGadget(14, 1):DisableGadget(13, 1):DisableGadget(20, 1):DisableGadget(21, 1)
  DisableGadget(19, 1):DisableGadget(2, 1)         
EndProcedure
Procedure igr_time()
  If Val(Mid(clock_stop, 4, 2))>=Val(Mid(clock_start, 4, 2))
    md=Str(Val(Mid(clock_stop, 1, 2))-Val(Mid(clock_start, 1, 2)))+":"
    If Val(Mid(clock_stop, 7, 2))>=Val(Mid(clock_start, 7, 2))
      md+Str(Val(Mid(clock_stop, 4, 2))-Val(Mid(clock_start, 4, 2)))+":"
      md+Str(Val(Mid(clock_stop, 7, 2))-Val(Mid(clock_start, 7, 2)))
    Else
      md+Str(Val(Mid(clock_stop, 4, 2))-Val(Mid(clock_start, 4, 2))-1)+":"
      md+Str(Val(Mid(clock_stop, 7, 2))-Val(Mid(clock_start, 7, 2))+60)
    EndIf
  Else   
    If (Val(Mid(clock_stop, 1, 2))-Val(Mid(clock_start, 1, 2))-1)>=0
      md.s=Str(Val(Mid(clock_stop, 1, 2))-Val(Mid(clock_start, 1, 2))-1)+":"
    ElseIf (Val(Mid(clock_stop, 1, 2))-Val(Mid(clock_start, 1, 2))-1)<0        
      md.s=Str(Val(Mid(clock_stop, 1, 2))-Val(Mid(clock_start, 1, 2))+23)+":"
    EndIf
    If Val(Mid(clock_stop, 7, 2))>=Val(Mid(clock_start, 7, 2))
      md+Str(Val(Mid(clock_stop, 4, 2))-Val(Mid(clock_start, 4, 2))+60)+":"
      md+Str(Val(Mid(clock_stop, 7, 2))-Val(Mid(clock_start, 7, 2)))
    Else
      md+Str(Val(Mid(clock_stop, 4, 2))-Val(Mid(clock_start, 4, 2))+59)+":"
      md+Str(Val(Mid(clock_stop, 7, 2))-Val(Mid(clock_start, 7, 2))+60)
    EndIf
  EndIf
  MessageRequester("Игра", "Продолжительность игры:  "+md, 0)
EndProcedure      
Procedure init()
  ; DisableGadget(28, 1):DisableGadget(3, 1)
  AddGadgetItem(1, -1, "Стартовая")
  top=10 : is=100
  ButtonGadget(2, 10, top,is, 20, "Проверка") :top+25
  GadgetToolTip(2, "Проверка соединения с квестом и интернетом, а также перезапуск служб для корректной работы системы.")
  ButtonGadget(3, 10, top,is, 20, "Старт") :top+25
  GadgetToolTip(3, "Начало игры")
  ButtonGadget(28, 10, top,is, 20, "Тестовая") :top+25
  ButtonGadget(4, 10, top,is, 20, "Настройка") :top+25
  ButtonGadget(5, 10, top,is, 20, "Сборка") :top+60
  ButtonGadget(19, 10, top,is, 20, "Закрыть") :top+50
  GadgetToolTip(19, "Выход из программы. Закрывает корректор голоса.")
  ;ImageGadget(0, 125, 30, 290, 380, ImageID(0))
  ImageGadget(200, 125, 30, 290, 380, ImageID(0))
  AddGadgetItem(1, -1, "Настройки")
  top=10 : is=100
  TextGadget(27,10,top,is,20,"Музыка", #PB_Text_Center | #PB_Text_Border) :top+25
  ButtonGadget(23, 10, top,is, 20, "Темница") :top+25
  ButtonGadget(24, 10, top,is, 20, "Кабинет врача") :top+25
  ButtonGadget(25, 10, top,is, 20, "Лифт") :top+25
  ButtonGadget(26, 10, top,is, 20, "Коридор") :top+60
  ImageGadget(201, 125, 30, 290, 380, ImageID(0))
  AddGadgetItem(1, -1, "Сборка")
  top=10 : is=100
  TextGadget(6,10,top,is,20,"Открытие дверей", #PB_Text_Center | #PB_Text_Border) :top+25
  ButtonGadget(7, 10, top,is, 20, "Кабинет врача",#PB_Button_Toggle) :top+25
  ButtonGadget(8, 10, top,is, 20, "Коридор",#PB_Button_Toggle) :top+25
  ButtonGadget(9, 10, top,is, 20, "Морг",#PB_Button_Toggle) :top+25
  ButtonGadget(10, 10, top,is, 20, "Пыточная",#PB_Button_Toggle) :top+25
  ButtonGadget(11, 10, top,is, 20, "Холодильник",#PB_Button_Toggle) :top+25
  ButtonGadget(14, 10, top,is, 20, "Полка с органами",#PB_Button_Toggle) :top+25
  ButtonGadget(13, 10, top,is, 20, "Выход",#PB_Button_Toggle) :top+50 
  ButtonGadget(20, 10, top,is, 20, "Открыть всё") :top+25
  GadgetToolTip(20, "Открывает все двери в квесте.")
  ButtonGadget(21, 10, top,is, 20, "Закрыть всё") :top+25
  GadgetToolTip(21, "Закрывает все двери в квесте.")
  ImageGadget(202, 125, 30, 290, 380, ImageID(0))
  CloseGadgetList()
  SetGadgetState(1, 0):DisableGadget(28, 1):DisableGadget(3, 1):DisableGadget(7, 1) :DisableGadget(8, 1):DisableGadget(9, 1):DisableGadget(10, 1)
  DisableGadget(11, 1):DisableGadget(14, 1):DisableGadget(13, 1):DisableGadget(20, 1):DisableGadget(21, 1)
  DisableGadget(19, 1):DisableGadget(2, 1)      
EndProcedure
Declare stop_mp3()
Procedure play_mp3()
  If FileSize(mp3_txt) <= 0
    mp3_name.s="Стоп!"
              mp3_txt=""
              q=0
              stop_mp3()
    MessageRequester("Error", "Файл не существует!", 0)
  Else    
  If LoadMovie(0, mp3_txt)
    PlayMovie(0, WindowID(0))
    If InitMovie() >0
      mp3_txt_old=mp3_txt      
      MovieAudio(0, volume, 0)
      Delay(100)
      
      q=1
      StatusBarText(12, 1, "Играет:")
      StatusBarText(12, 2, mp3_name)
    EndIf
  EndIf
  EndIf
EndProcedure
Declare stop_mp3()
Procedure stop_mp3()
  q=0
  StopMovie(0)
  StatusBarText(12, 1,"Стоп!")
  StatusBarText(12, 2,"")
EndProcedure


Enumeration 
  #window 
EndEnumeration 
;{ declare
Declare CreateFormMain()
Declare send_sql()
Declare DatenSatzAendern()
Declare DatenSatzLoeschen()
Declare ListFuellen()
Declare conect_sql_sart()
Declare conect_sql_stop()
;}
Procedure conect_sql()
  Define db_name.s = GetTemporaryDirectory() + "Adr1.sqlite"
  
  
  Protected.s SQL
  ; Мы проверяем , существует ли ужеDB , если нет,пусто DB создан .
  If FileSize(db_name) <= 0
    If CreateFile(0, db_name)
      CloseFile(0)
      If OpenDatabase(#AdressDB, db_name, "", "",#PB_Database_SQLite)
        ; Мы создаем адреса таблицы , этозаявление SQL :
        ; " CREATE TABLE table_name ( имя поля [Тип ] имя_поля [ TYPE] , ...) " отвечает
        ; Тип поля , как правило, дополнительно на SQLite, так что мы , как правило, опускать это тоже.
        ; Исключением из этого правила являетсяуникальный идентификатор иBLOB. Это всегда типа INTEGER, или BLOB
        ; Синтаксис для поля ID : имя_поля INTEGER PRIMARY KEY AUTOINCREMENT
        ; Рекомендуется, чтобызаявление SQL разделить на несколько строк.
        SQL = "CREATE TABLE adressen (id INTEGER PRIMARY KEY AUTOINCREMENT,"
        SQL + " day, nachalo, konech, vrem, notizen, fotodata BLOB, fotosize INTEGER)"
        
        ; Если мы нужен результат , мы используем: обновление базы данных (ID , SQL заявление)
        ; в противном случае запроса базы данных ( ID , SQL заявление ), который мы увидим позже.
        If DatabaseUpdate(#AdressDB, SQL) = #False
          End
        EndIf
      Else
        End
      EndIf
    Else
      Debug db_name + " не может быть создан."
      End
    EndIf
  Else ; База данных уже существует и открыт.
    If OpenDatabase(#AdressDB, db_name, "", "",#PB_Database_SQLite) = #False
      Debug DatabaseError()
      End
    EndIf
  EndIf
EndProcedure
; После того как мы открыли нашу базу данных (будь то пустой или уже с содержимым )
; мы создаем первый главное окно

Procedure send_sql_start()
  Protected.s SQL, id, day, nachalo, konech, vrem, ort, telefon, itemtext
  conect_sql()
  If flag_test=0 
    fl$=""
  ElseIf flag_test=1 
    fl$=" Test"
  EndIf
  daydat_in=FormatDate("%dd.%mm.%yy", Date())
  day = daydat_in+fl$
  nachalo = clock_start
  konech= ""
  vrem = ""
  
  ; Этозаявление SQL : " INSERT INTO ... " отвечает !
  SQL = "INSERT INTO adressen (day, nachalo, konech, vrem) "
  SQL + "VALUES ('"
  SQL + day + "','"
  SQL + nachalo + "','"
  SQL + konech + "','"
  SQL + vrem +  "')"
  
  If DatabaseUpdate(#AdressDB, SQL) ; Введите в БД .
                                    ; Теперь нам нужен автоматически созданный идентификатор , чтобы ввести его в нашем списке
    If DatabaseQuery(#AdressDB, "SELECT last_insert_rowid()")
      NextDatabaseRow(#AdressDB)
      ids = GetDatabaseString(#AdressDB, 0)
      FinishDatabaseQuery(#AdressDB)
      
    EndIf
  Else
    Debug DatabaseError()+" 3"
  EndIf
  CloseDatabase(#AdressDB)
EndProcedure

Procedure send_sql_stop()  
  Protected.s SQL, id, day, nachalo, konech, vrem, ort, telefon, itemtext
  conect_sql()
  If flag_test=0 
    fl$=""
  ElseIf flag_test=1 
    fl$=" Test"
  EndIf
  day = daydat_in+fl$
  nachalo = clock_start
  konech= clock_stop
  vrem = md
  
  
  ;Чтобы изменить , мы используем SQL заявление: " UPDATE table_name SET "
  SQL = "UPDATE adressen SET "
  SQL + "day = '" + day + "',"
  SQL + "nachalo = '" + nachalo + "',"
  SQL + "konech = '" + konech + "',"
  SQL + "vrem = '" + vrem + "'"
  SQL + "WHERE id = " + ids
  
  If DatabaseUpdate(#AdressDB, SQL) = #False
    Debug DatabaseError()+ "4" 
  EndIf
  CloseDatabase(#AdressDB)
EndProcedure
;{ declare
;Declare resive_pref()
Declare send_sql_ftp()
Declare send_pref_ftp()
Declare conect_ftp()
Declare close_ftp()
Declare write_pref()
Declare read_pref()
Declare sql_del()
;}
Procedure sql_del()
  Define pass.s = GetTemporaryDirectory() +"ar\configp.cfg" 
  Define db_name_old.s =GetTemporaryDirectory() + "Adr1arch"+daydat_in+".sqlite"
  Protected.s SQL
  Define db_name.s = GetTemporaryDirectory() + "Adr1.sqlite"
  daydat_in=FormatDate("%dd%mm%yy", Date())
  If CopyFile(db_name, db_name_old)
    If SendFTPFile(0,db_name_old,GetFilePart(db_name_old))
      Repeat
        re= FTPProgress(0)
      Until re=#PB_FTP_Finished Or re=#PB_FTP_Error
    EndIf
    DeleteFile(db_name)
    If CreateFile(0, db_name)
      CloseFile(0)
      If OpenDatabase(#AdressDB, db_name, "", "",#PB_Database_SQLite)
        SQL = "CREATE TABLE adressen (id INTEGER PRIMARY KEY AUTOINCREMENT,"
        SQL + " day, nachalo, konech, vrem, notizen, fotodata BLOB, fotosize INTEGER)"
        If DatabaseUpdate(#AdressDB, SQL) = #False
          End
        EndIf
      Else
        End
      EndIf
    EndIf
    If OpenPreferences(pass)
      PreferenceGroup("Passwords")
      WritePreferenceString("baza", "ok")
      ClosePreferences()
    EndIf
    send_pref_ftp()
    send_sql_ftp()
  EndIf
EndProcedure

Procedure resive_pref(*x)  
  Define pass.s = GetTemporaryDirectory() +"ar\configp.cfg"   
  read_pref()
  If FileSize(pass) <= 0
    If CreatePreferences(pass)
      PreferenceGroup("Passwords")
      WritePreferenceString("pass_put", "ce35f8657b61b37655d7b60021271f35")
      WritePreferenceString("pass_igr", "21d49bcf108faf010892542753d9ded5")
      WritePreferenceString("pass_put_def", "8de93839158c81631546eedb86092fbf")
      WritePreferenceString("pass_igr_def", "8de93839158c81631546eedb86092fbf")
      WritePreferenceString("baza", "ok")
      ClosePreferences()
    EndIf
  EndIf
  If OpenPreferences(pass)
    PreferenceGroup("Passwords")
    pass_put= ReadPreferenceString("pass_put", "")
    pass_igr= ReadPreferenceString("pass_igr", "")
    pass_put_def= ReadPreferenceString("pass_put_def", "")
    pass_igr_def= ReadPreferenceString("pass_igr_def", "")
    ClosePreferences()
  EndIf 
  If OpenPreferences(pass)
    PreferenceGroup("Passwords")
    pass_igr_old.s= ReadPreferenceString("pass_igr", "")    
    ClosePreferences()
  EndIf  
  conect_ftp()
  If log_ftp="Conn" 
    If SetFTPDirectory(0,"Sahalin") 
      If ReceiveFTPFile(0,"configp.cfg",pass) 
        Repeat
          re= FTPProgress(0)
        Until re=#PB_FTP_Finished Or re=#PB_FTP_Error
      EndIf 
      If OpenPreferences(pass)
        PreferenceGroup("Passwords")
        pass_put= ReadPreferenceString("pass_put", "")
        pass_igr= ReadPreferenceString("pass_igr", "")
        pass_put_def= ReadPreferenceString("pass_put_def", "")
        pass_igr_def= ReadPreferenceString("pass_igr_def", "")
        baza_inf.s=ReadPreferenceString("baza", "")
        ClosePreferences()
      EndIf
      If pass_igr_old <> pass_igr
        Counts=0     
        write_pref()   
      EndIf  
      If baza_inf="del" 
        sql_del() 
      Else
        send_sql_ftp()
      EndIf    
    EndIf
  EndIf 
  If OpenPreferences(pass)
    PreferenceGroup("Passwords")
    pass_put= ReadPreferenceString("pass_put", "")
    pass_igr= ReadPreferenceString("pass_igr", "")
    pass_put_def= ReadPreferenceString("pass_put_def", "")
    pass_igr_def= ReadPreferenceString("pass_igr_def", "")
    baza_inf=ReadPreferenceString("baza", "")
    ClosePreferences()
  EndIf         
  If flag_igr=1
    DisableGadget(28, 0):DisableGadget(3, 0):DisableGadget(7, 0) :DisableGadget(8, 0):DisableGadget(9, 0):DisableGadget(10, 0)
    DisableGadget(11, 0):DisableGadget(14, 0):DisableGadget(13, 0):DisableGadget(20, 0):DisableGadget(21, 0) 
    flag_igr=1
  EndIf
  DisableGadget(19, 0):DisableGadget(2, 0)
EndProcedure
Procedure send_sql_ftp()
  Define db_name.s = GetTemporaryDirectory() + "Adr1.sqlite"  
  If SendFTPFile(0,db_name,GetFilePart(db_name))
    Repeat
      re= FTPProgress(0)
    Until re=#PB_FTP_Finished Or re=#PB_FTP_Error
  EndIf 
EndProcedure
Procedure send_pref_ftp()
  Define pass.s = GetTemporaryDirectory() + "ar\configp.cfg"
  conect_ftp()
  If OpenPreferences(pass)
    PreferenceGroup("Passwords")
    WritePreferenceString("pass_put", pass_put)
    WritePreferenceString("pass_igr", pass_igr)
    WritePreferenceString("pass_put_def", pass_put_def)
    WritePreferenceString("pass_igr_def", pass_igr_def)
    ClosePreferences()  
  EndIf
  If log_ftp="Conn"         
    If SetFTPDirectory(0,"Sahalin")      
      If SendFTPFile(0,pass,GetFilePart(pass))
        Repeat
          re= FTPProgress(0)
        Until re=#PB_FTP_Finished Or re=#PB_FTP_Error
      EndIf 
    EndIf  
  EndIf
  ;close_ftp()
EndProcedure
Procedure conect_ftp()
  If OpenFTP(0, "node0.net2ftp.ru", "igrazum2015@yandex.ru", "55fde0a4", 21)     
    log_ftp="Conn"        
  Else
    If flag_igr=0
      ;Beep_(700,600)
      MessageRequester("Error", "Интернет отсутствует!", 0)      
      im(0) 
    EndIf 
    log_ftp="Closs"    
  EndIf  
EndProcedure
Procedure close_ftp()
  If IsFTP(0)<>0
    CloseFTP(0)      
  EndIf
  log_ftp="Closs"
EndProcedure
Procedure read_pref()  
  Define Music.s = GetTemporaryDirectory() + "ar\configm.cfg"  
  If FileSize(Music) <= 0
    If CreatePreferences(Music)
      PreferenceGroup("MP3")
      WritePreferenceString("Темница", "d:\лифт\темница.mp3")
      WritePreferenceString("Кабинет", "d:\лифт\лифт окон.mp3")
      WritePreferenceString("Лифт", "d:\лифт\лифт.mp3")
      WritePreferenceString("Коридор", "d:\лифт\коридор.mp3")
      WritePreferenceLong("Громкость", 50)
      PreferenceGroup("igr")
      WritePreferenceLong("Counts", 0)
      ClosePreferences()
    EndIf
  Else
    If OpenPreferences(Music,#PB_Preference_NoSpace)
      PreferenceGroup("MP3")
      temn= ReadPreferenceString("Темница", "")
      cab= ReadPreferenceString("Кабинет", "")
      lift= ReadPreferenceString("Лифт", "")
      kor= ReadPreferenceString("Коридор", "")
      volume= ReadPreferenceLong("Громкость", 0)
      PreferenceGroup("igr")
      Counts= ReadPreferenceLong("Counts", 0)
      ClosePreferences()
    EndIf
  EndIf 
EndProcedure
Procedure write_pref()    
  Define Music.s = GetTemporaryDirectory() + "ar\configm.cfg"
  If OpenPreferences(Music,#PB_Preference_NoSpace)
    PreferenceGroup("MP3")
    WritePreferenceString("Темница", temn)
    WritePreferenceString("Кабинет", cab)
    WritePreferenceString("Лифт", lift)
    WritePreferenceString("Коридор", kor)
    WritePreferenceLong("Громкость", volume)
    PreferenceGroup("igr")
    WritePreferenceLong("Counts", Counts)
    ClosePreferences()
  EndIf
EndProcedure
Procedure md5(str.s)
  *Buffer = AllocateMemory(500)    
  If *Buffer
    ;PokeS(*Buffer, "The quick brown fox jumps over the lazy dog.")
    PokeS(*Buffer, str)
    MD5$ = MD5Fingerprint(*Buffer, MemorySize(*Buffer))    
    FreeMemory(*Buffer)  ; would also be done automatically at the end of the program
  EndIf
EndProcedure
Procedure send_ftp(*x)
  ;send_sql_ftp() 
  ;send_pref_ftp()
  ;resive_pref()
EndProcedure
Procedure send_ftp2(*x) 
  ;resive_pref()
EndProcedure
;{ open window
If InitNetwork() = 1
  If ExamineDirectory(0, GetTemporaryDirectory() +"ar\", "")=0
    CreateDirectory(GetTemporaryDirectory() +"ar\")
  EndIf 
  hw.u=820 : lw.u=640 
  If OpenWindow(#window, #PB_Any, #PB_Any, hw, lw, "Канибал", #PB_Window_ScreenCentered | #PB_Window_BorderLess | #WS_POPUP | #PB_Window_Invisible|#PB_Window_Maximize) 
    SetWindowLong_(WindowID(#window), #GWL_EXSTYLE, #WS_EX_TOOLWINDOW|GetWindowLong_(WindowID(#window), #GWL_EXSTYLE) | $00080000)
    SetLayeredWindowAttributes_(WindowID(Window), 0, 230, 2)
    HideWindow(#window, 0) 
    StickyWindow(#window, 1) 
    
    ;LoadImage(1, MapLabel)
    CreateStatusBar(12, WindowID(0))
    AddStatusBarField(80)
    AddStatusBarField(60)
    AddStatusBarField(100)
    AddStatusBarField(#PB_Ignore)
    CreateThread( @DateStatusBar(),0) ; Запуск процедуры в отдельном потоке
    CreateThread( @resive_pref(),0)
    ;CreateThread(@send_ftp2(),0)
    
    
    thread = CreateThread(@server(),0)
    
    *get_txt\portcon$=port_esp
    pid =RunProgram("MorphVOXPro.exe","","C:\Program Files (x86)\Screaming Bee\MorphVOX Pro\", #PB_Program_Open|#PB_Program_Hide)
    
    If CreateImage(0, 290, 380, 32) And   StartDrawing(ImageOutput(0))
      DrawingMode(#PB_2DDrawing_Default)
      ;DrawImage(ImageID(1), 0, 0) 
      
      StopDrawing()
      
    EndIf
    
    
    PanelGadget (1, 300, 70, hw, lw-20)
    If CatchImage(1, ?MapLabel)
      If CreateImage(0, 290, 380, 32) 
        If  StartDrawing(ImageOutput(0))
          DrawingMode(#PB_2DDrawing_Default)
          ;DrawImage(ImageID(1), 0, 0) 
          DrawImage(ImageID(1), 0, 0, 290, 380)
          StopDrawing()
          ;ImageGadget(200, 130, 50, 290, 380, ImageID(0))
          ;DrawImage(ImageID(0), 425, 100)
          
        EndIf
      EndIf
    EndIf
    init()
    
    fl=0
    ;im(0)
    door.b=64
    idoor()
    q=0
    ;}  
    ;{ repeat
    Repeat 
      ;{ Mp3 треки
      If q=1
        If mp3_txt_old<>mp3_txt And n=1
          play_mp3() 
        EndIf
        Result.q = MovieStatus(0)
        If result=0 
          If clock_in(1) <> 0   And fm=0             
      mp3_name="Кабинет врача"
      mp3_txt_old=mp3_txt
      mp3_txt=cab 
      play_mp3()
  Else
          Select mp3_txt
            Case temn
              mp3_name.s="Кабинет врача"
              mp3_txt=cab 
              play_mp3() 
            Case cab
              mp3_name.s="Коридор"
              mp3_txt=kor 
              play_mp3() 
            Case lift
              mp3_name.s="Коридор"
              mp3_txt=kor 
              play_mp3() 
            Case kor
              MessageRequester("Треки", "Музыка не играет! Треки кончились", 0)
              mp3_name.s="Стоп!"
              mp3_txt=""
              q=0
              stop_mp3()
              ;SetGadgetText(17, "Стоп")
              ;SetGadgetState(15, 0) 
          EndSelect
          EndIf
        EndIf
      EndIf
      ;}
      ;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\  
      Event=WaitWindowEvent()
      
      Select Event
          
          
        Case #PB_Event_Gadget 
          ;{ Select gadget
          Select EventGadget()
            Case 2 ;проверка
                   ;If thread                  
                   ;KillThread(thread)
                   ; Delay(50)
                   ;  ;thread = CreateThread(@server(),0)ButtonGadget(7, 10, top,is, 20, "Кабинет врача",#PB_Button_Toggle) :top+25 
                   ;EndIf
              DisableGadget(19, 1):DisableGadget(2, 1):DisableGadget(28, 1):DisableGadget(3, 1) :DisableGadget(8, 1)
              DisableGadget(9, 1):DisableGadget(10, 1):DisableGadget(11, 1):DisableGadget(14, 1):DisableGadget(13, 1)
              DisableGadget(20, 1):DisableGadget(21, 1)
              If ping (ip_esp)
                flag_igr=1
                test_get()            
                
              Else             
                ;Beep_(700,600)
                im(0)
                MessageRequester("Error", "Отсутствует соединение к квесту!", 0)            
                flag_igr=0
                DisableGadget(28, 1):DisableGadget(3, 1):DisableGadget(7, 1) :DisableGadget(8, 1):DisableGadget(9, 1):DisableGadget(10, 1)
                DisableGadget(11, 1):DisableGadget(14, 1):DisableGadget(13, 1):DisableGadget(20, 1):DisableGadget(21, 1)            
              EndIf         
              CreateThread( @resive_pref(),0)
            Case 3 ;старт
              flag_test=0
              n=1
              start()
              mp3_name="Темница":  mp3_txt=temn: play_mp3() 
              *get_txt\get_txt2$="61"
              CreateThread(@send_get(),*get_txt)
              idoor()
              fl=0
              send_sql_start()  
            Case 4 ; настройка
              SetGadgetState(1, 1)
              idoor()
              fl=0
            Case 1 ;панель гаджет
              idoor()
            Case 5 ;сборка
              *get_txt\get_txt2$="60"
              CreateThread(@send_get(),*get_txt)
              SetGadgetState(1, 2)
              idoor()
              fl=0         
            Case 7 ;кабинет врача
              If GetGadgetState(7)=1
                *get_txt\get_txt2$="2041"
                CreateThread(@send_get(),*get_txt)
              Else
                *get_txt\get_txt2$="2040"
                CreateThread(@send_get(),*get_txt)
              EndIf
              
            Case 8 ;Коридор 
              If GetGadgetState(8)=1
                *get_txt\get_txt2$="2031"
                CreateThread(@send_get(),*get_txt)
              Else
                *get_txt\get_txt2$="2030"
                CreateThread(@send_get(),*get_txt)
              EndIf
              
            Case 9 ;Морг
              If GetGadgetState(9)=1
                *get_txt\get_txt2$="2051"
                CreateThread(@send_get(),*get_txt)
              Else
                *get_txt\get_txt2$="2050"
                CreateThread(@send_get(),*get_txt)
              EndIf
              
            Case 10 ;Пыточная
              If GetGadgetState(10)=1
                *get_txt\get_txt2$="2061"
                CreateThread(@send_get(),*get_txt)
              Else
                *get_txt\get_txt2$="2060"
                CreateThread(@send_get(),*get_txt)
              EndIf
              
            Case 11 ;Холодильник
              If GetGadgetState(11)=1
                *get_txt\get_txt2$="2071"
                CreateThread(@send_get(),*get_txt)
              Else
                *get_txt\get_txt2$="2070"
                CreateThread(@send_get(),*get_txt)
              EndIf
              
            Case 13 ;Выход
              If GetGadgetState(13)=1
                *get_txt\get_txt2$="2121"
                CreateThread(@send_get(),*get_txt)
              Else
                *get_txt\get_txt2$="2120"
                CreateThread(@send_get(),*get_txt)
              EndIf
              
            Case 14 ;Полка с органами
              If GetGadgetState(14)=1
                *get_txt\get_txt2$="2111"
                CreateThread(@send_get(),*get_txt)
              Else
                *get_txt\get_txt2$="2110"
                CreateThread(@send_get(),*get_txt)
              EndIf
              
            Case 15 ;Стоп
              flag_start= 0: flag_igr=0: n=0 : fm=0: stop()
              *get_txt\get_txt2$="60"
              CreateThread(@send_get(),*get_txt)
              idoor(): fl=0: stop_mp3()
              igr_time()
              send_sql_stop()
              CreateThread(@resive_pref(),0)
            Case 17 ;Громкость
              
              volume= GetGadgetState(17) 
              SetGadgetText(18, "Громкость : "+Str(volume)+"%")         
              write_pref()
              If q=1
                MovieAudio(0, volume, 0)
              EndIf
            Case 19 ;{Закрыть
              str$=InputRequester("Закрытие приложения", "Введите пароль:", "8888",#PB_InputRequester_Password)
              md5(str$)
              If MD5$=pass_put 
                flag_exit=1
                pass_put=pass_put_def
                *get_txt\get_txt2$="60"
                CreateThread(@send_get(),*get_txt)
                write_pref() 
                send_pref_ftp()
                close_ftp()
                KillProgram(pid)
                CloseProgram(pid)
                Delay(100)
                End
              ElseIf MD5$=pass_put_def
                flag_exit=1
                *get_txt\get_txt2$="60"
                CreateThread(@send_get(),*get_txt)
                KillProgram(pid)
                CloseProgram(pid) 
                Delay(100)
                End
              Else
                Beep_(800,300)
                MessageRequester("Error", "Неверный пароль!", 0)
              EndIf
              ;}
            Case 20 ;Открыть всё
              *get_txt\get_txt2$="4"
              CreateThread(@send_get(),*get_txt)
            Case 21 ; закрыть всё
              *get_txt\get_txt2$="3"
              CreateThread(@send_get(),*get_txt)
            Case 22 ;Коридор 
              *get_txt\get_txt2$="5"
              CreateThread(@send_get(),*get_txt)
            Case 23 ;Темница
              temn = OpenFileRequester("Выбор файла для проигрования", "", "Audio files|*.mp3;*.wav|All Files|*.*", 0)
              write_pref()
            Case 24 ;Кабинет врача
              cab = OpenFileRequester("Выбор файла для проигрования", "", "Audio files|*.mp3;*.wav|All Files|*.*", 0)
              write_pref()
            Case 25 ;Лифт
              lift = OpenFileRequester("Выбор файла для проигрования", "", "Audio files|*.mp3;*.wav|All Files|*.*", 0)
              write_pref()
            Case 26 ;Коридор
              kor = OpenFileRequester("Выбор файла для проигрования", "", "Audio files|*.mp3;*.wav|All Files|*.*", 0)
              write_pref()
              
            Case 28 ;{Тестовая
              str$=InputRequester("Тестовая игра", "Введите пароль:", "8888",#PB_InputRequester_Password)
              md5(str$)
              If MD5$=pass_igr Or MD5$=pass_igr_def
                If Counts<3 And MD5$=pass_igr           
                  flag_test=1
                  n=1
                  start()
                  mp3_name="Темница":  mp3_txt=temn: play_mp3() 
                  *get_txt\get_txt2$="61"
                  CreateThread(@send_get(),*get_txt)
                  idoor()
                  fl=0          
                  send_sql_start()
                  Counts=Counts+1
                  write_pref()
                ElseIf Counts<4 And MD5$=pass_igr_def
                  flag_test=1
                  n=1
                  start()
                  mp3_name="Темница":  mp3_txt=temn: play_mp3() 
                  *get_txt\get_txt2$="61"
                  CreateThread(@send_get(),*get_txt)
                  idoor()
                  fl=0
                  send_sql_start()
                  Counts=Counts+1
                  write_pref()
                Else
                  Beep_(600,400)
                  MessageRequester("Error", "Тестовые игры кончились!", 0)
                EndIf
              Else
                Beep_(800,400)
                MessageRequester("Error", "Неверный пароль!", 0)
              EndIf
              ;}
            Case 30
              keybd_event_(#VK_VOLUME_DOWN, 0, 0, 0)
            Case 31 
              keybd_event_(#VK_VOLUME_UP, 0, 0, 0)
            Case 33 ;Темница     
              mp3_name.s="Темница"
              mp3_txt=temn 
              play_mp3() 
            Case 34 ; Кабинет врача
              fm=0
              mp3_name.s="Кабинет врача"
              mp3_txt=cab 
              play_mp3() 
            Case 35 ; Лифт
              mp3_name.s="Лифт"
              mp3_txt=lift 
              play_mp3() 
            Case 36 ; Коридор
              mp3_name.s="Коридор"
              mp3_txt=kor 
              play_mp3() 
            Case 37 ; Стоп
              stop_mp3() 
              ;{
            Case 200 To 202 ; ImageGadget
              If flag_igr=1
                If EventType() = #PB_EventType_LeftClick
                  If WindowMouseX(#window) >GadgetX(200) + 530 And WindowMouseX(#window) <GadgetX(200) + 570 And WindowMouseY(#window) >GadgetY(200) +180 And WindowMouseY(#window) <GadgetY(200) +220
                    If other(0)&16
                      ;Дверь в кабинет врача
                      *get_txt\get_txt2$="2040"
                      CreateThread(@send_get(),*get_txt)
                    Else 
                      *get_txt\get_txt2$="2041"
                      CreateThread(@send_get(),*get_txt)
                    EndIf
                  ElseIf WindowMouseX(#window) >GadgetX(200) + 530 And WindowMouseX(#window) <GadgetX(200) + 570 And WindowMouseY(#window) >GadgetY(200) +320 And WindowMouseY(#window) <GadgetY(200) +360
                    If other(0)&8
                      ;Дверь в коридор 
                      *get_txt\get_txt2$="2030"
                      CreateThread(@send_get(),*get_txt)
                    Else 
                      *get_txt\get_txt2$="2031"
                      CreateThread(@send_get(),*get_txt)
                    EndIf
                  ElseIf WindowMouseX(#window) >GadgetX(200) + 343 And WindowMouseX(#window) <GadgetX(200) + 362 And WindowMouseY(#window) >GadgetY(200) +170 And WindowMouseY(#window) <GadgetY(200) +190
                    If other(1)&2
                      ;Дверь в полку с оргонами
                      *get_txt\get_txt2$="2110"
                      CreateThread(@send_get(),*get_txt)
                    Else 
                      *get_txt\get_txt2$="2111"
                      CreateThread(@send_get(),*get_txt)
                    EndIf
                  ElseIf WindowMouseX(#window) >GadgetX(200) + 414 And WindowMouseX(#window) <GadgetX(200) + 440 And WindowMouseY(#window) >GadgetY(200) +410 And WindowMouseY(#window) <GadgetY(200) +440
                    If other(0)&32
                      ;Дверь в морг
                      *get_txt\get_txt2$="2050"
                      CreateThread(@send_get(),*get_txt)
                    Else 
                      *get_txt\get_txt2$="2051"
                      CreateThread(@send_get(),*get_txt)
                    EndIf
                  ElseIf WindowMouseX(#window) >GadgetX(200) + 335 And WindowMouseX(#window) <GadgetX(200) + 365 And WindowMouseY(#window) >GadgetY(200) +300 And WindowMouseY(#window) <GadgetY(200) +335
                    If other(0)&64
                      ;Дверь в пыточную
                      *get_txt\get_txt2$="2060"
                      CreateThread(@send_get(),*get_txt)
                    Else 
                      *get_txt\get_txt2$="2061"
                      CreateThread(@send_get(),*get_txt)
                    EndIf
                  ElseIf WindowMouseX(#window) >GadgetX(200) + 395 And WindowMouseX(#window) <GadgetX(200) + 425 And WindowMouseY(#window) >GadgetY(200) +190 And WindowMouseY(#window) <GadgetY(200) +225
                    If other(1)&4
                      ;Дверь выход
                      *get_txt\get_txt2$="2120"
                      CreateThread(@send_get(),*get_txt)
                    Else 
                      *get_txt\get_txt2$="2121"
                      CreateThread(@send_get(),*get_txt)
                    EndIf
                  ElseIf WindowMouseX(#window) >GadgetX(200) + 315 And WindowMouseX(#window) <GadgetX(200) + 342 And WindowMouseY(#window) >GadgetY(200) +190 And WindowMouseY(#window) <GadgetY(200) +225
                    If other(0)&128
                      ;Дверь холодильник
                      *get_txt\get_txt2$="2070"
                      CreateThread(@send_get(),*get_txt)
                    Else 
                      *get_txt\get_txt2$="2071"
                      CreateThread(@send_get(),*get_txt)
                    EndIf
                  Else 
                    ;Debug "x="+Str(WindowMouseX(#window)-GadgetX(200))+" y="+Str(WindowMouseY(#window)-GadgetY(200))
                  EndIf 
                  
                EndIf  
              EndIf
              ;}
          EndSelect
          ;}
      EndSelect
      
      
      
      ;Until Event = #PB_Event_CloseWindow 
      ;CloseNetworkServer(0)
    ForEver 
    ;}
  EndIf
  ;End
Else
  Beep_(700,600)
  MessageRequester("Error", "Отсутствует соединение к сети!", 0)
  End
EndIf

DataSection
  MapLabel: 
  IncludeBinary "map.bmp"
  ;IncludeBinary "D:\fixiki\людоед\BMP\map.bmp"
EndDataSection 

; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 1058
; FirstLine = 57
; Folding = AAAIAEQ9
; EnableThread
; EnableXP
; UseIcon = TCP_ip\icon_app\ico\result.ico
; Executable = Р РЋР В°РЎвЂ¦Р В°Р В»Р С‘Р Р…\Р вЂєРЎР‹Р Т‘Р С•Р ВµР Т‘ Р РЋР В°РЎвЂ¦Р В°Р В»Р С‘Р Р…_v1.7.exe