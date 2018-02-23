

; #FUNCTION# ====================================================================================================================
; Name...........:	_PlaySystemSound()
; Description ...:	Spielt einen Systemklang, welcher in der Registry oder der Win.ini definiert ist.
; Syntax.........:	_PlaySystemSound($sSoundName[, $bAsync])
; Parameters ....:	$sSoundName							- Name des SystemSound's
;					| SystemAsterisk    		- Stern / Asterisk                                                      
;					| Default           		- Standardton Warnsignal / Default Beep                                 
;					| EmptyRecycleBin   		- Löschen des Papierkorbs / when recycle bin is emptied                 
;					| SystemExclamation 		- Hinweis / when windows shows a warning                                
;					| SystemExit        		- Windows beenden / when Windows shuts down                             
;					| Maximize          		- Maximieren / when a program is maximized                              
;					| MenuCommand       		- Menübefehl / when a menu item is clicked on                           
;					| MenuPopup         		- Menü-Popup / when a (sub)menu pops up                                 
;					| Minimize          		- Minimieren / when a program is minimized to taskbar                   
;					| MailBeep          		- Posteingangsbenachrichtigung / when email is received                 
;					| Open              		- Programm öffnen / when a program is opened                            
;					| SystemHand        		- Kritischer Abbruch / when a critical stop occurs                      
;					| AppGPFault        		- Programmfehler / when a program causes an error                       
;					| SystemQuestion    		- Frage / when a system question occurs                                 
;					| RestoreDown       		- Verkleinern / when a program is minimized to taskbar                  
;					| RestoreUp         		- Vergrößern / when a program is restored to normal size from taskbar   
;					| SystemStart       		- Windows starten / when Windows starts up                              
;					| Close             		- Programm schließen / when program is closed                           
;					| Ringout           		- Freizeichen / when (fax) call is made outbound and the line is ringing
;					| RingIn            		- Eingehender Anruf / incoming (fax) call                               
;					| DeiviceConnect			- Geräteanschluß / when a device is connect                                
;					| DeviceDisconnect			- Gerätetrennung / when a device is disconnect                           
;					| DeviceFail				- Geräteanschluß fehlgeschlagen / when a deviceconnect is fail                
;					| CriticalBatteryAlarm		- Alarm bei kritischem Batteriestand / when battery is critical       
;					| LowBatteryAlarm			- Alarm bei niedrigem Batteriestand / when battery is low                 
;					| MailBeep					- Posteingangsbenachrichtigung / when a mail is arrived                        
;					| PrintComplete				- Druckvorgang abgeschlossen / when a printjob is completed
;					| WindowsLogon				- Windows-Anmeldung / when a user logs on
;					| WindowsLogoff				- Windows-Abmeldung / when a user logs off
;					$bAsync						- Abspielen erfolgt Syncron
; Return values .:	-----
; Author ........:	micha_he (AutoIt.de)
; Informations...:	weitere System-Event-Namen können Sie unter folgendem Registryzweigen finden bzw. hinzufügen:
;					- HKEY_USERS\.DEFAULT\AppEvents\EventLabels\
;					- HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default                
; ===============================================================================================================================
Func _PlaySystemSound($sSoundName, $bAsync = FALSE)
	Local Const $SND_ALIAS = 0x10000
    Local Const $SND_ASYNC = 0x1
    Local $flags
    $flags = $SND_ALIAS
    If $bAsync Then $flags = BitOr($flags, $SND_ASYNC)
    DllCall('winmm.dll', 'int', 'PlaySoundA', 'str', $sSoundName, 'int', 0, 'int', $flags)
EndFunc ; ==> _PlaySystemSound()