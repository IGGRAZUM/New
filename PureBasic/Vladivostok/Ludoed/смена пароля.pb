Input$ = InputRequester("����� ������", "������� ������ �� ����� ������:", "****.",#PB_InputRequester_Password)

  If Input$ = "529012"
    Input$ = InputRequester("������", "������� ����� ������:", "****.",#PB_InputRequester_Password)
    If Input$ = ""
      MessageRequester("������", "������ �� ����� ���� ������", 0)
      Else
    If CreatePreferences(GetTemporaryDirectory()+"Preferences_pass.prefs")
  PreferenceGroup("������")
    WritePreferenceString("������", Input$)
    ClosePreferences();
    MessageRequester("����� ������", "������ ������", 0)
  EndIf               ;for line-feed
  EndIf
  Else  
    MessageRequester("����� ������", "������ �� ������ ������", 0)
  EndIf

; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 17
; EnableXP
; UseIcon = TCP_ip\icon_app\ico\favicon(4).ico
; Executable = ..\..\Users\Admin\Desktop\exeшники\смена пароля.exe