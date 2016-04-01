Global Button_0
EnableExplicit
 InitNetwork()
UseSQLiteDatabase()
 
#AdressDB = 0
#frm_Main = 0
 
Enumeration ; Gadgets
  #gad_Panel
  #gad_ListAnschrift
  #gad_Container
  #gad_strName
  #gad_strVorname
  #gad_strStrasse
  #gad_strPLZ
  #gad_strOrt
  #gad_strTelefon
  #gad_btnHinzufuegen
  #gad_btnAendern
  #gad_btnLoeschen
  #gad_btnSortieren
  #gad_btndown
  #Button_0
  #Button_1
  #Window_1
EndEnumeration
Declare CreateFormMain()
Declare DatenSatzHinzufuegen()
Declare DatenSatzAendern()
Declare DatenSatzLoeschen()
Declare ListFuellen()
Global rez
  If ExamineDirectory(0, GetTemporaryDirectory() +"ar\", "")=0
    CreateDirectory(GetTemporaryDirectory() +"ar\")
  EndIf


Declare resive_sql()
Declare conect_ftp()
Declare close_ftp()
Declare send_pref_ftp()
Global log_ftp.s
Procedure resive_sql()   
  Define pass.s = GetTemporaryDirectory() +"ar\Adr1.sqlite"   
  conect_ftp()
  If log_ftp="Conn"
  If SetFTPDirectory(0,"Sahalin")
    If ReceiveFTPFile(0,"Adr1.sqlite",pass) 
      Repeat
        Until FTPProgress(0)=#PB_FTP_Finished Or FTPProgress(0)=#PB_FTP_Error
                EndIf                      
              EndIf 
              close_ftp()  
              EndIf
EndProcedure
Procedure conect_ftp()
  If OpenFTP(0, "node0.net2ftp.ru", "igrazum2015@yandex.ru", "55fde0a4", 21)     
          log_ftp="Conn"
        Else
          log_ftp="Closs"
       EndIf
EndProcedure
Procedure close_ftp()
  If IsFTP(0)<>0
      CloseFTP(0)      
    EndIf
    log_ftp="Closs"
EndProcedure
Procedure update()  
  Define db_name.s = GetTemporaryDirectory() +"ar\Adr1.sqlite"
  Define SQL.s
  resive_sql()
; �� ��������� , ���������� �� ���DB , ���� ���,����� DB ������ .
If FileSize(db_name) <= 0
  If CreateFile(0, db_name)
    CloseFile(0)
    If OpenDatabase(#AdressDB, db_name, "", "", #PB_Database_SQLite)
      ; �� ������� ������ ������� , ������������ SQL :
      ; " CREATE TABLE table_name ( ��� ���� [��� ] ���_���� [ TYPE] , ...) " ��������
      ; ��� ���� , ��� �������, ������������� �� SQLite, ��� ��� �� , ��� �������, �������� ��� ����.
      ; ����������� �� ����� ������� ������������������ ������������� �BLOB. ��� ������ ���� INTEGER, ��� BLOB
      ; ��������� ��� ���� ID : ���_���� INTEGER PRIMARY KEY AUTOINCREMENT
      ; �������������, �������������� SQL ��������� �� ��������� �����.
      SQL = "CREATE TABLE adressen (id INTEGER PRIMARY KEY AUTOINCREMENT,"
      SQL + " day, nachalo, konech, vrem, notizen, fotodata BLOB, fotosize INTEGER)"
      
      ; ���� �� ����� ��������� , �� ����������: ���������� ���� ������ (ID , SQL ���������)
      ; � ��������� ������ ������� ���� ������ ( ID , SQL ��������� ), ������� �� ������ �����.
      If DatabaseUpdate(#AdressDB, SQL) = #False
        Debug DatabaseError()+"1"
        End
      EndIf
    Else
      Debug DatabaseError()
      End
    EndIf
  Else
    Debug db_name + " �� ����� ���� ������."
    End
  EndIf
Else ; ���� ������ ��� ���������� � ������.
  If OpenDatabase(#AdressDB, db_name, "", "",#PB_Database_SQLite) = #False
    Debug DatabaseError()
    End
  EndIf
EndIf
 
; ����� ���� ��� �� ������� ���� ���� ������ (���� �� ������ ��� ��� � ���������� )
; �� ������� ������ ������� ����
 
CreateFormMain()
 

 
; ������ ���� ListIconGadget ����������� �������
ListFuellen()
EndProcedure
Procedure send_pref_ftp()
  Define pass.s = GetTemporaryDirectory() + "configp.cfg"

  If OpenPreferences(pass)
      PreferenceGroup("Passwords")
      WritePreferenceString("baza", "del")
      ClosePreferences()
    EndIf
    conect_ftp()
    If log_ftp="Conn"
  If SetFTPDirectory(0,"Sahalin")
    If SendFTPFile(0,pass,GetFilePart(pass))
      Repeat
       rez= FTPProgress(0)
        Until rez=#PB_FTP_Finished Or rez=#PB_FTP_Error
      EndIf   
      If rez=#PB_FTP_Finished
        MessageRequester("��������", "���� ����� ������� � ������� ��������� �����.", #PB_MessageRequester_Ok)
      ElseIf rez=#PB_FTP_Error
        MessageRequester("Error", "������ ����������!", #PB_MessageRequester_Ok)
      EndIf
    Else
      MessageRequester("Error", "������ ����������!", #PB_MessageRequester_Ok)
  EndIf 
EndIf
close_ftp()
EndProcedure
; ��� � ���������� ���� MainLoop .
Define i
update()
Repeat
  Select WaitWindowEvent()
  
    Case #PB_Event_CloseWindow
      CloseDatabase(#AdressDB)
      Break
      
    Case #PB_Event_Gadget
      Select EventGadget()
 
        Case #gad_ListAnschrift
          Select EventType()
            Case #PB_EventType_Change
              i = GetGadgetState(#gad_ListAnschrift)
              If i > -1
                SetGadgetText(#gad_strName, GetGadgetItemText(#gad_ListAnschrift, i, 1))
                SetGadgetText(#gad_strVorname, GetGadgetItemText(#gad_ListAnschrift, i, 2))
                SetGadgetText(#gad_strStrasse, GetGadgetItemText(#gad_ListAnschrift, i, 3))
                SetGadgetText(#gad_strPLZ, GetGadgetItemText(#gad_ListAnschrift, i, 4))
              Else
                SetGadgetText(#gad_strName, "")
                SetGadgetText(#gad_strVorname, "")
                SetGadgetText(#gad_strStrasse, "")
                SetGadgetText(#gad_strPLZ, "")              
              EndIf
          EndSelect
        Case #gad_btnHinzufuegen ; �������� ������
          DatenSatzHinzufuegen()
        
        Case #gad_btnAendern
          If GetGadgetState(#gad_ListAnschrift)  > -1
            DatenSatzAendern()
          Else
            MessageRequester("SQLite �������", "����������, ��������  ������ ��� ���������� !")
          EndIf
          
        Case #gad_btnLoeschen
          send_pref_ftp()
        Case #gad_btnSortieren
          ListFuellen()
        Case #gad_btndown
         update() 
      EndSelect
  EndSelect
ForEver
End
 
Procedure ListFuellen()
  ; ������ ��� ListIconGadget ����������� �������
  ; ��� ���� ������������� SQL SELECT ����� ���������������. * ������������� ���� � ����� �� ����������� �������
  ; ORDER BY ��� ���� ������������ ���������� !
  Protected itemtext.s, i
  
  ClearGadgetItems(#gad_ListAnschrift)
  
  If DatabaseQuery(#AdressDB, "SELECT * FROM adressen ORDER BY day")
    While NextDatabaseRow(#AdressDB)
      itemtext = GetDatabaseString(#AdressDB, 0) ; ��� ������� ���������� �������������,
      For i = 1 To 4 ; ��� � ������� !
        itemtext + #LF$ + GetDatabaseString(#AdressDB, i)
      Next
      AddGadgetItem(#gad_ListAnschrift, -1, itemtext)
    Wend
    FinishDatabaseQuery(#AdressDB); ��� ������� ������ ����������� ��� ������� !
  Else
    Debug DatabaseError()+"2"
  EndIf
EndProcedure
 
Procedure DatenSatzHinzufuegen()
  Protected.s SQL, id, day, nachalo, konech, vrem, ort, telefon, itemtext
  
  day = GetGadgetText(#gad_strName)
  nachalo = GetGadgetText(#gad_strVorname)
  konech= GetGadgetText(#gad_strStrasse)
  vrem = GetGadgetText(#gad_strPLZ)
  
  ; ������������ SQL : " INSERT INTO ... " �������� !
  SQL = "INSERT INTO adressen (day, nachalo, konech, vrem) "
  SQL + "VALUES ('"
  SQL + day + "','"
  SQL + nachalo + "','"
  SQL + konech + "','"
  SQL + vrem +  "')"
  
  If DatabaseUpdate(#AdressDB, SQL) ; ������� � �� .
    ; ������ ��� ����� ������������� ��������� ������������� , ����� ������ ��� � ����� ������
    If DatabaseQuery(#AdressDB, "SELECT last_insert_rowid()")
      NextDatabaseRow(#AdressDB)
      id = GetDatabaseString(#AdressDB, 0)
      FinishDatabaseQuery(#AdressDB)
      
      itemtext = id + #LF$ + day + #LF$ + nachalo + #LF$ + konech + #LF$ + vrem 
      AddGadgetItem(#gad_ListAnschrift, -1, itemtext)
    EndIf
  Else
    Debug DatabaseError()+" 3"
  EndIf
EndProcedure
 
Procedure DatenSatzAendern()
  Protected.s SQL, id, day, nachalo, konech, vrem, ort, telefon, itemtext
  Protected item
  
  day = GetGadgetText(#gad_strName)
  nachalo = GetGadgetText(#gad_strVorname)
  konech = GetGadgetText(#gad_strStrasse)
  vrem = GetGadgetText(#gad_strPLZ)
  ; ���������� ID ��������� ������
  item = GetGadgetState(#gad_ListAnschrift)
  id = GetGadgetItemText(#gad_ListAnschrift, item, 0)
 
  ; ����� �������� , �� ���������� SQL ���������: " UPDATE table_name SET "
  SQL = "UPDATE adressen SET "
  SQL + "day = '" + day + "',"
  SQL + "nachalo = '" + nachalo + "',"
  SQL + "konech = '" + konech + "',"
  SQL + "vrem = '" + vrem + "'"
  SQL + "WHERE id = " + id
 
  If DatabaseUpdate(#AdressDB, SQL) = #False
    Debug DatabaseError()+ "4"
  Else
    SetGadgetItemText(#gad_ListAnschrift, item, day, 1)
    SetGadgetItemText(#gad_ListAnschrift, item, nachalo, 2)
    SetGadgetItemText(#gad_ListAnschrift, item, konech, 3)
    SetGadgetItemText(#gad_ListAnschrift, item, vrem, 4)
  EndIf
EndProcedure
 
Procedure DatenSatzLoeschen()
  Protected.s SQL, id
  Protected item
  
  item = GetGadgetState(#gad_ListAnschrift)
  id = GetGadgetItemText(#gad_ListAnschrift, item, 0)
  SQL = "DELETE FROM adressen WHERE id = " + id
  
  If DatabaseUpdate(#AdressDB, SQL) = #False
    Debug DatabaseError() + " 5"
  Else
    RemoveGadgetItem(#gad_ListAnschrift, item)
  EndIf
EndProcedure
 
Procedure CreateFormMain()
  Protected ListIconFlags = #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    ListIconFlags | #PB_ListIcon_AlwaysShowSelection
  CompilerEndIf
  OpenWindow(0,200,305,490,486,"����",#PB_Window_SystemMenu| #PB_Window_MinimizeGadget| #PB_Window_MaximizeGadget) 
  ContainerGadget(#gad_Container, 0, 0, 490, 60)
  StringGadget(#gad_strName, 5, 0, 150, 25, "")
  SetGadgetColor(#gad_strName, #PB_Gadget_FrontColor,RGB(0,0,255))
  SetGadgetColor(#gad_strName, #PB_Gadget_BackColor,RGB(242,252,186))
 
  StringGadget(#gad_strVorname, 165, 0, 95, 25, "")
  StringGadget(#gad_strStrasse, 260, 0, 95, 25, "")
  StringGadget(#gad_strPLZ, 355, 0, 120, 25, "")
  ButtonGadget(#gad_btnHinzufuegen, 5, 30, 100, 25, "��������")
  ButtonGadget(#gad_btnAendern, 115, 30, 80, 25, "��������")
  ButtonGadget(#gad_btnLoeschen, 205, 30, 80, 25, "�������")
  ButtonGadget(#gad_btnSortieren, 290, 30, 80, 25, "�����������")
  ButtonGadget(#gad_btndown, 380, 30, 80, 25, "�������")
  CloseGadgetList()
  SetWindowColor(0, RGB(37,162,254))
  PanelGadget(#gad_Panel, 0, 70, 490, 415)
  AddGadgetItem(#gad_Panel, -1, "��������")
  
 
      ListIconGadget(#gad_ListAnschrift, 5, 5, GetGadgetAttribute(#gad_Panel, #PB_Panel_ItemWidth) - 10, GetGadgetAttribute(#gad_Panel, #PB_Panel_ItemHeight) - 10, "id", 1, ListIconFlags)
      ; ������ ������� ��������� ���������� ������������� � �� ����� !
      AddGadgetColumn(#gad_ListAnschrift, 1, "�����", 150)
      AddGadgetColumn(#gad_ListAnschrift, 2, "������", 95)
      AddGadgetColumn(#gad_ListAnschrift, 3, "�����", 95)
      AddGadgetColumn(#gad_ListAnschrift, 4, "�����������������", 120)
      CloseGadgetList()
      ;***************************************************************************
      
      ;OpenWindow(1,200,200,490,80,"Dialogfenster",#PB_Window_SystemMenu| #PB_Window_MinimizeGadget| #PB_Window_MaximizeGadget) 
     
  
 
EndProcedure
End
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 140
; FirstLine = 61
; Folding = Q5
; EnableXP
; Executable = ..\Сахалин\База игр.exe