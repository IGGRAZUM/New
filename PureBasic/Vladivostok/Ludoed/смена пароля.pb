Input$ = InputRequester("Смена пароля", "Введите пароль от смены пароля:", "****.",#PB_InputRequester_Password)

  If Input$ = "529012"
    Input$ = InputRequester("Пароль", "Введите новый пароль:", "****.",#PB_InputRequester_Password)
    If Input$ = ""
      MessageRequester("Пароль", "Пароль не может быть пустым", 0)
      Else
    If CreatePreferences(GetTemporaryDirectory()+"Preferences_pass.prefs")
  PreferenceGroup("пароль")
    WritePreferenceString("пароль", Input$)
    ClosePreferences();
    MessageRequester("Смена пароля", "Пароль изменён", 0)
  EndIf               ;for line-feed
  EndIf
  Else  
    MessageRequester("Смена пароля", "Введен не верный пароль", 0)
  EndIf

; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 17
; EnableXP
; UseIcon = TCP_ip\icon_app\ico\favicon(4).ico
; Executable = ..\..\Users\Admin\Desktop\exeС€РЅРёРєРё\СЃРјРµРЅР° РїР°СЂРѕР»СЏ.exe