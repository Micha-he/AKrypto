#pragma compile(ProductName, "AKrypto")
#pragma compile(ProductVersion, 0.56.0.5)
#pragma compile(LegalCopyright, © Michael Schröder)
#pragma compile(Icon, .\AKrypto.ico)
#pragma compile(Out, AKrypto.exe)

#cs Copyright, Infos, History
	****************************************************************************
	Titel:			AKrypto.au3
	Autor:			micha_he@autoit.de
	Datum:			11.03.2022
	
	Ideen &
	Hilfen:			spudw2k@autoitscript.com (Tree-/ListView)
	Oscar@autoit.de (Drag 'n Drop, ListView-Sort)
	Ward@autoitscript.com (AES UDF)
	SkinnyWhiteGuy@autoitscript.com (Blowfish UDF)
	Mikeytown2@autoitscript.com (neue Base64 UDF)
	blindwig@autoitscript.com (neue Base64 UDF)
	Ascend4nt@autoitscript.com (_ShellExecuteEx)
	MrCreatoR@autoitscript.com (_ShellExecuteEx)
	Foxnolds@autoitscript.com (_MsgBoxEx)
	Larry@autoitscript.com(_GetTotalScreenResolution)
	BrettF@autoitscript.com(_GetTotalScreenResolution)
	Info:
	
	AutoIt-Version:	3.3.14.5
	
	History
	V0.56.0.5
		Anpassung der Funktion __InitGUIs() an AutoIt V3.3.16.0
		(Auswählen und Ausklappen des Root-Items).
	V0.56.0.4
		Variablendeklaration per 3. Assign-Parameter in der Funktion
		__LanguageIni_Read_Data() realisiert. Dies spart eine gesonderte
		Deklaration im Header.
	V0.56.0.3
		Diverse ungenutze Variablen entfernt
		Sprachanpassung im Unterverzeichnis '\Language' integriert. INI-
			Dateien sollten im UTF-16-Format sein.
		Neu-Laden der Benutzeroberfläche beim Sprachwechsel
	V0.56.0.2
		Initialisierung der Oberfläche in Funktionen aufgeteilt
	V0.56.0.1
		Versions-Nummerierung geändert: major.minor.build (build0=beta)
		Funktion _StartFile2() um eine Ausnahme für RJTextEd erweitert, damit
			dieser immer im Multi-Modus startet.
	V0.552
		HotKeySet für DEL beim Umbenennen & Anlegen von Dateien und Ordnern
		temporär deaktiviert.
	V0.551
		Wartezeit am Programmende nochmals modifiziert.
	V0.55
		Verschieben der Trennlinie zwische TreeView und ListView, nur wenn
		die vertikale Position der Maus im Bereich der Trennline ist
		Optionale Wartezeit beim Programmende eingefügt, in der geschlossene
		Sub-Anwendungen ordnungsgemäß enden können.
	V0.54
		Handling bei Verschieben der Trennlinie TreeView/Listview
		verbessert. Cursor sollte nun immer angepasst werden.
		Funktion __GUICtrlListView_GetSortedColumn() wieder entfernt
		Funktion __GUICtrlListView_SortItems() angepasst, damit eine initiale
			Sortierung per Rückgabe von GUICtrlGetState() des ListView-
			Controls (gibt -1 vorm dem 1. Anklicken mit der Maus aus)
			trotzdem funktioniert
		Funktion __GUICtrlListView_SortItems() angepasst, damit das Sortieren
			eines leeren ListViews nicht zum Wechsel der Sortierrichtung
			führt
	V0.53
		Programm warnt nun, wenn es beendet werden soll, aber noch Dateien
		in externen Anwendungen geöffnet sind.
		Kurzinfo beim 1.Start und im Kontextmenü hinzugefügt
		Funktion _MsgBoxEx() in der UDF um einen Parameter für das
		Deaktivieren des System-Sounds erweitert
		INI-Datei wird beim Beenden nur dann gespeichert, wenn vorher auch
		ein gültiges Passwort eingegeben wurde
		Position des TreeView minimal angepasst
	V0.52
		Anpassungen an AutoIt V3.3.14.5
		Verarbeitung der Dateinamen-Erweiterung in der Funktion
			__Decrypt_Name() korrigiert
		Funktion __GetDecryptedLinkTarget() hinzugefügt
		Funktion __DecryptExecute() auf die Verarbeitung von verknüpften
			Ordnern & Dateien erweitert
		Splash-Anzeige um Zusatzinformationen erweitert, welche den
			aktuellen Ordner bei ver- und entschlüsseln Anzeigen
		Anpassungsfehler der GUI-Elemente beim Verschieben des versteckten
			Fensters, durch Einfügen von GUISetState beim Generieren der
			Hauptoberfläche am Start beseitigt.
		GUI-Resize-Message an eigene Move-Funktion registriert, um beim
			ändern der Größe die Fensterpositionsdaten im globalen Array
			zu aktualisieren. Dabei auch die Verschiebung der Splash-GUI
			in diese Funktion verlagert und dabei einen Berechnungsfehler 
			korrigiert.
		Funktion __ShowFolder() Arraybehandlung optimiert
		Funktion __FileGetIcon() auf Array-Rückgabe umgestellt
		Rückgabewerte der Funktionen __DirCopy_Crypt_Recursiv() und
			__FileCopy_Crypt() neu strukturiert. Unnötige Meldungen
			unterbunden.
		Funktion __DeleteObjects() im Abbruchfall optimiert
		Fehlergrenze bei der Länge des kryptierten Pfades von 260 auf 259
			korrigiert und aussagekräftige Fehlermeldung eingefügt.
		Fehler beim 'letzten' Ordner für den Dekryptierungsvorgang korrigiert
		Icon aus EXE-Dateien werden nach 'VaultTemp' entpackt und für die
			Darstellung im ListView genutzt
		Sortierung TreeView & ListView verbessert
		Positionsermittlung TreeView/ListView beim Verändern der GUI
		Überflüssige Funktion _GUICtrlListView_ReSortItems() entfernt
		Modifiziert Funktion __GUICtrlListView_SortItems() ins Skript
			eingefügt. Diese benutzt anstatt der Spalte 0 die Spalte 4
			zu Sortierung um Verzeichnisse und Dateien zu trennen.
			Die Funktion um ReSort-Parameter erweitert.
		Diverse Variablennamen in Funktionen aussagekräftiger bezeichnet
		__GUICtrlTreeView_Sort() mit korrigierter Array-Elementenanzahl
			eingefügt
		Funktion _SearchFolder() in __SearchFolder() umbenannt und rekursiv
			verschachtelt. Daher ist die Funktion _FolderFunc() entfallen
		Diverse Variablen und Funktionsnamen angepasst
		Funktion __FileGetIcon() erweitert um Icons auf Basis eines
			Shell-IconHandlers zu ermitteln
		Spaltenanpassung bei Änderung GUI/ListView-Größe
	V0.512
		Fehler der sich bei der Anpasssung in der V0.511 einge-
		schlichen hat (Root des TreeView wurde beim Start nicht
		automatisch erweitert), wieder korrigiert.
	V0.511
		Fehler bei Nutzung von AutoIt V3.3.10.2 beseitigt.
		Versionüberprüfung auf Basis "_VersionCompare()" aus
		der Misc.au3-UDF.
		#pragma-Direktiven für Programname, Programversion,
		Copyright und Programmicon hinzugefügt.
		Icon (Freeware) dem Quellcodepaket hinzugefügt.
	V0.510
		Abbruchfehler beim Neuanlegen einer Datei beseitigt.
		Fehler bei der Passwortabfrage (geändert in V0.505)
		korrigiert.
		_ShellExecuteEx() durch neue Funktion __StartFile2()
		ersetzt.
		Fehlerbehandlung bei 0-Byte-Dateien integriert.
		Dateitypen-Bezeichnung eingedeutscht.
		Fehler in der relative Adressierung auf GUI-Objekte in
		der Funktion __ShowFolder() korrigiert.
		Umbenennen von Dateien/Ordnern per Kontextmenü
		integriert.
		Läuft jetzt auch im 64bit-Mode.
		FileOpen-Fehler in UDF "_AESFile.au3" eingefügt, damit
		die Funktion __DecryptAll() darauf reagieren kann.
	V0.507
		Vor dem Löschen der temporären Dateien, werden diese mit
		einem Standardmuster überschrieben, damit ein unter
		Umständen anschließendes eingesetztes Undelete-Tool die
		Originaldatei nicht wieder herstellen kann.
	V0.506
		Anpassungen an AutoIt-Version >= 3.3.8.0 vorgenommen.
		Fehler in einer Stringverknüpfungen korrigiert.
		Variablen-Deklarationen vervollständigt.
	V0.505
		Bestimmung der GUI-Position korrigiert, wenn die Task-
		leiste rechts/links angeordnet ist oder der Desktop aus
		mehreren Monitoren besteht.
		Passwort kann als Parameter nach dem Muster "/pw xxx"
		übergeben werden, wobei xxx dem Passwort entspricht.
	V0.504
		Messageboxen werden relativ zum GUI ausgerichtet.
		Komplett auf globales Array "$aWinPos" umgestellt.
	V0.503
		AutoIt-Icon aus dem Systeminfo-Bereich der Taskleiste
		entfernt.
	V0.502
		Ordner zum Entpacken wird in INI gesichert.
	V0.501
		Informationen/Darstellung per SplashGUI verbessert.
	V0.500
		ListView wird sortiert. Kann per Maus umgeschaltet
		werden.
	V0.400
		Veränderte Dateien können bei Schließen der Anwendung
		wieder in den verschlüsselten Bereich zurückkopiert
		werden.
	V0.300
		Base64-UDF gewechselt, da die alte UDF einen
		sporadischen Fehler aufwies.
	V0.200
		Verschlüsselung der Datei- & Ordnernamen auf BlowFish &
		Base64 umgestellt.
	V0.100
		Verschlüsselung (Namen & Inhalt) mit AES.
	
	TODO,1:			%-Fortschrittsanzeige beim Ver- / Entschlüsseln
	TODO,2:			automatisches Entpacken alle Dateien & UV zum Start
					eines Programms
	TODO,2:			Windows-Dateisystembeschränkung auf 248 Zeichen beim
					Ordner-Komplett-Pfad und 259 Zeichen Komplettpfad inkl.
					Dateiname umgehen.
	
	****************************************************************************
#ce

#NoTrayIcon

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <TreeViewConstants.au3>
#include <ListViewconstants.au3>
#include <GuiListView.au3>
#include <GUITreeView.au3>
#include <File.au3>
#include <Misc.au3>
#include <String.au3>
#include <Array.au3>
#include <WinAPIShellEx.au3>
#include <WinAPIIcons.au3>
#include <WinAPIGdi.au3>
#include "_AESFile.au3"
#include "_Blowfish.au3"
#include "_Base64.au3"
#include "_MsgBoxExDe.au3"

Opt("MustDeclareVars", 1)

; Icon sizes for shell-imagelist
Global Const $SHIL_LARGE      = 0x0 ; 32x32 pixels
Global Const $SHIL_SMALL      = 0x1 ; 16x16 pixels
Global Const $SHIL_EXTRALARGE = 0x2 ; 48x48 pixels
Global Const $SHIL_SYSSMALL   = 0x3 ; GetSystemMetrics for SM_CXSMICON and SM_CYSMICON
Global Const $SHIL_JUMBO      = 0x4 ; 256x256 pixels, Vista+

Global $aFileIcons[1] = ["shell32.dll"]
Global $aDropFiles[1]
Global $sIniFile = @ScriptDir & "\AKrypto.ini"
Global $sIdent = "*AK*"
Global $sDecryptTarget, $idLVItemRename
Global $aMousePos, $aTreePos, $aListPos, $bSnap = False, $bCursorSwitched = False
Global $sIniFile, $iWinXPos, $iWinYPos, $iWinWidth, $iWinHeight
Global $iFreeX, $iFreeY
Global $hSplashGUI, $idGUIGetMsg
Global $sVaultTemp, $sVaultDir, $aInVault, $hMainGui, $idMainGroup
Global $idTreeView, $idListView, $idLVContextMenu, $idLVNewFolder
Global $idLVNewFile, $idLVSelectAll, $idLVSelectNone, $idLVItemDelete
Global $hTVImageList, $aWinPos, $aTrayPos, $iTreeWidth, $sKey
Global $iNewTreeWidth, $idLVDecryptAll, $idSplashLabel, $idSplashLabelAddInfo
Global $idLVGetShortInfo, $aStartedFiles[1][3]
Global $aDesktopData, $bInitSort, $idTreeViewRootItem
Global $hLanguageMenue, $aLanguage[0][0], $sSelectedLanguageIni
Global $aLangIniData, $iFindLngIni
Global $Version = FileGetVersion(@ScriptFullPath, "ProductVersion")
If _VersionCompare(@AutoItVersion, "3.3.8.0") = -1 Then Global Const $WM_DROPFILES = 0x233

__LanguageIni_Read_List($aLanguage)
If @Error Then
	_MsgBoxEx(49, "Fehler", "Keine gültige Sprachdateien im Unterordner '\Language\' gefunden !" & @CRLF & "(No valid language-file in subfolder '\Language\' found !)")
	Exit 1
EndIf

; Zuletzt verwendete Sprache ermitteln oder Default (De -> En -> erste gefundene) festlegen
$sSelectedLanguageIni = IniRead($sIniFile, "Options", "SelectedLanguage", "")
If $sSelectedLanguageIni = "" or _ArraySearch($aLanguage, $sSelectedLanguageIni, 0, 0, 0, 0, 1, 1) < 0 Then
	If _ArraySearch($aLanguage, "de.ini", 0, 0, 0, 0, 1, 1) >= 0 Then
		$sSelectedLanguageIni = "de.ini"
	Else
		If _ArraySearch($aLanguage, "en.ini", 0, 0, 0, 0, 1, 1) >= 0 Then
			$sSelectedLanguageIni = "en.ini"
		Else
			$sSelectedLanguageIni = $aLanguage[0][1]
		EndIf
	EndIf
EndIf

; Maße kompletter virtueller Windows-Screen ermitteln
$aDesktopData = __GetTotalScreenResolution()

__InitGUIs()

HotKeySet("{DEL}", "__DeleteObjects")

While True
	If WinActive($hMainGui) Then
		$aMousePos = GUIGetCursorInfo($hMainGui)
		; Cursur für Verschiebung der Trennlinie umschalten
		If $aMousePos[0] >= ($aTreePos[0] + $aTreePos[2] - 4) And $aMousePos[0] <= ($aListPos[0] + 4) And $aMousePos[1] >= $aTreePos[1] And $aMousePos[1] <= ($aTreePos[1] + $aTreePos[3]) Then
			If $bCursorSwitched = False Then
				GUISetCursor(13, 1, $hMainGui)
				$bCursorSwitched = True
			EndIf
		Else
			If $bCursorSwitched = True Then
				GUISetCursor(2, 1, $hMainGui)
				$bCursorSwitched = False
			EndIf
		EndIf
		; Verschieben der Trennlinie zwischen TreeView und ListView
		If $aMousePos[2] = True Then ; linke Maustaste gedrückt ?
			If $bSnap = False And $bCursorSwitched = True Then
				$bSnap = True
			EndIf
			If $bSnap = True Then
				$iNewTreeWidth = $aMousePos[0] - $aTreePos[0]
				If $iNewTreeWidth < 20 Then $iNewTreeWidth = 20
				If $iNewTreeWidth > ($aTreePos[2] + $aListPos[2]) - 20 Then $iNewTreeWidth = ($aTreePos[2] + $aListPos[2]) - 20
				ControlMove($hMainGui, "", $idTreeView, $aTreePos[0], $aTreePos[1], $iNewTreeWidth)
				ControlMove($hMainGui, "", $idListView, $aTreePos[0] + $iNewTreeWidth, $aListPos[1], ($aTreePos[2] + $aListPos[2]) - $iNewTreeWidth)
				$aTreePos = ControlGetPos($hMainGui, "", $idTreeView)
				$aListPos = ControlGetPos($hMainGui, "", $idListView)
				__ColumnResize($idListView)
			EndIf
		Else
			If $bSnap = True Then
				$bSnap = False
				GUICtrlSetPos($idTreeView, $aTreePos[0], $aTreePos[1])
				GUICtrlSetPos($idListView, $aListPos[0], $aListPos[1])
				__ColumnResize($idListView)
			EndIf
		EndIf
	EndIf
	; Prüfe auf beendete Anwendungen
	__CheckStartedFiles()
	
	; Hauptauswahl
	$idGUIGetMsg = GUIGetMsg()
	Switch $idGUIGetMsg
		
		Case $GUI_EVENT_CLOSE
			__ExitApp()
			
		Case $GUI_EVENT_DROPPED
			__AddNewObjects()
			
		Case $idLVGetShortInfo
			__ShowShortInfo()
			
		Case $idLVItemRename
			__RenameObjects()
			
		Case $idLVItemDelete
			__DeleteObjects()
			
		Case $idLVSelectAll
			_GUICtrlListView_SetItemSelected($idListView, -1, True)
			
		Case $idLVSelectNone
			_GUICtrlListView_SetItemSelected($idListView, -1, False)
			
		Case $idLVNewFolder
			__AddNewFolder()
			
		Case $idLVNewFile
			__AddNewFile()
			
		Case $idLVDecryptAll
			__DecryptAll()
			
		Case $idListView
			__GUICtrlListView_SortItems($idListView, GUICtrlGetState($idListView))
		
		Case $aLanguage[0][2] To $aLanguage[UBound($aLanguage) -1][2]
			$iFindLngIni = _ArraySearch($aLanguage, $idGUIGetMsg, 0, 0, 0, 0, 1, 2)
			If Not @error and $sSelectedLanguageIni <> $aLanguage[$iFindLngIni][1] Then __GUI_LanguageMenu_Change($aLanguage[$iFindLngIni][1])
			
	EndSwitch
WEnd


Func __ColumnResize(ByRef $hWnd) ;Resize Listview Column routine
	Local $__aListViewPos = ControlGetPos("","",$hWnd)
	If IsArray($__aListViewPos) Then
		_GUICtrlListView_SetColumnWidth($hWnd, 0, $__aListViewPos[2] * .5)
		_GUICtrlListView_SetColumnWidth($hWnd, 1, $__aListViewPos[2] * .145)
		_GUICtrlListView_SetColumnWidth($hWnd, 2, $__aListViewPos[2] * .145)
		_GUICtrlListView_SetColumnWidth($hWnd, 3, $__aListViewPos[2] * .2)
	EndIf
EndFunc   ;==>__ColumnResize


Func __FileGetIcon($sTargetItem)
	; Get Icon for Files - Special Thanks to MrCreator
	; http://www.autoitscript.com/forum/index.ph...st&p=421467
	; angepasst Micha_he@AutoIt.de (Icon für verknüpfte & verschlüsselte Ordner/Dateien)
	Local $szRegDefault, $szDefIcon, $sFileExtension, $sLinkTargetName
	Local $szRegDefault, $aValueSplit, $sExeNameDecrypted, $sFileName, $iRet
	Local $aReturnIconInfo[2]
	Local $sIconName, $__hSysIL
	$sFileExtension = StringMid($sTargetItem, StringInStr($sTargetItem, '.', 0, -1))
	
	If $sFileExtension = '.lnk' Then
		$sLinkTargetName = __GetDecryptedLinkTarget($sTargetItem)
		If Not @error Then
			If Not FileExists($sLinkTargetName) Then
				; Icon (rote Kreuz) für fehlendes Element zurückgeben
				$aReturnIconInfo[0] = "shell32.dll"
				$aReturnIconInfo[1] = 132
				Return $aReturnIconInfo
			Else
				If Not StringInStr(FileGetAttrib($sLinkTargetName), "D") Then $sFileExtension = StringMid($sLinkTargetName, StringInStr($sLinkTargetName, '.', 0, -1))
				$sTargetItem = $sLinkTargetName
			EndIf
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	
	If $sFileExtension = '.exe' Then
		If Not FileExists($sVaultTemp) Then DirCreate($sVaultTemp)
		If FileGetSize($sTargetItem) <= 0 Then
			; Default-Exe-Icon zurückgeben, da 0-Byte-Datei
			$aReturnIconInfo[0] = "shell32.dll"
			$aReturnIconInfo[1] = 3
			Return $aReturnIconInfo
		EndIf
		$sExeNameDecrypted = __Decrypt_Name($sTargetItem)
		If StringInStr($sExeNameDecrypted, "\") Then
			$sFileName = StringMid($sExeNameDecrypted, StringInStr($sExeNameDecrypted, "\", 0, -1) +1)
		Else
			$sFileName = $sExeNameDecrypted
		EndIf
		$iRet = _AesDecryptFile($sKey, $sTargetItem, $sVaultTemp & "\" & $sFileName, "CFB")
		If $iRet Then
			FileSetAttrib($sVaultTemp & "\" & $sFileName, "-A")
			$sIconName = StringReplace($sFileName, ".exe", ".ico", -1)
			_WinAPI_SaveHICONToFile($sVaultTemp & "\" & $sIconName, _WinAPI_Create32BitHICON(_WinAPI_ShellExtractIcon($sVaultTemp & "\" & $sFileName, 0, 32, 32), False))
			If Not @error Then
				$aReturnIconInfo[0] = $sVaultTemp & "\" & $sIconName
				$aReturnIconInfo[1] = 1
			Else
				$aReturnIconInfo[0] = "shell32.dll"
				$aReturnIconInfo[1] = 3
			EndIf
			__Secure_FileDelete($sVaultTemp & "\" & $sFileName)
			Return $aReturnIconInfo
		EndIf
	EndIf
	
	If StringInStr(FileGetAttrib($sTargetItem), "D") Then $sFileExtension = "Folder" ; wenn Ordner dann neue Erweiterung für die Registrysuche festlegen
	
	If $sFileExtension = '.htm' Or $sFileExtension = '.html' Then
		; Icon für HTM/HTML zurückgeben. Kann entfallen, wenn die Ermittlung per Registry klappt
		$aReturnIconInfo[0] = "shell32.dll"
		$aReturnIconInfo[1] = -221
		Return $aReturnIconInfo
	EndIf
	
	; Ansonsten Versuch der Ermittliung per Registry
	; Ermittlung aus CurrentUser
	$szRegDefault = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" & $sFileExtension, "ProgID")
	If $szRegDefault = "" Then
		$szRegDefault = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" & $sFileExtension & "\UserChoice", "ProgID")
		If Not @error Then
			$szDefIcon = RegRead("HKCR\" & $szRegDefault & "\shell\open\command", "")
			If Not @error Then
				;$szDefIcon = StringReplace(StringReplace($szDefIcon,'"', ''),' %1', ',0')
				If StringLeft($szDefIcon, 1) = '"' Then $szDefIcon = StringTrimLeft($szDefIcon, 1)
				If StringInStr($szDefIcon, '" ') Then
					$szDefIcon = StringLeft($szDefIcon, StringInStr($szDefIcon, '" ') -1) & ",0"
				Else
					If StringInStr($szDefIcon, '"') Then
						$szDefIcon = StringLeft($szDefIcon, StringInStr($szDefIcon, '"') -1) & ",0"
					EndIf
				EndIf
			Else
				$szDefIcon = ""
			EndIf
		EndIf
	EndIf
	; ansonsten aus ClassesRoot
	If $szDefIcon = "" Then
		$szRegDefault = RegRead("HKCR\" & $sFileExtension, "")
		If Not @error Then
			$szDefIcon = RegRead("HKCR\" & $szRegDefault & "\DefaultIcon", "")
		EndIf
	EndIf
	If $szDefIcon = "" Then
		$szRegDefault = RegRead("HKCR\" & $szRegDefault & "\CurVer", "")
		If Not @error Then
			$szDefIcon = RegRead("HKCR\" & $szRegDefault & "\DefaultIcon", "")
		EndIf
	EndIf
	; Icon-Dummy setzen, wenn keines in der Registry gefunden wurde
	If $szDefIcon = "" Then
		$aReturnIconInfo[0] = "shell32.dll"
		$aReturnIconInfo[1] = 1
	Else
		If $szDefIcon = "%1" Or $szDefIcon = '"%1"' Then
			;Icon per Shell-IconHandler ermitteln aus der System-ImageList
			If Not FileExists($sVaultTemp) Then DirCreate($sVaultTemp)
			$__hSysIL = __GetSystemImageList($SHIL_LARGE)
			$szDefIcon = __GetIcon_ShellHandler($sVaultTemp & "\~" & StringTrimLeft($sFileExtension, 1) & $sFileExtension, $__hSysIL) & ",0"
		EndIf
		; nun noch Icon-Filename und Icon-Index trennen und im Array ablegen
		$aValueSplit = StringSplit($szDefIcon, ",")
		If IsArray($aValueSplit) Then
			$aReturnIconInfo[0] = $aValueSplit[1]
			If $aValueSplit[0] > 1 Then
				If $aValueSplit[2] > 0 Then $aValueSplit[2] +=1
				$aReturnIconInfo[1] = -($aValueSplit[2])
			EndIf
		Else
			Return SetError(1, 0, 0)
		EndIf
			
	EndIf
	Return $aReturnIconInfo
EndFunc   ;==>__FileGetIcon


Func __TreeView_FillFolder(ByRef $hWnd) ;Fill Folder in TreeView
	Local $IsExpanded, $hSelectedItem, $sPathEncrypted
	$hSelectedItem = _GUICtrlTreeView_GetSelection($hWnd)
	If $hSelectedItem = 0x00000000 Then Return
	$IsExpanded = _GUICtrlTreeView_GetExpanded($hWnd, $hSelectedItem)
	If _GUICtrlTreeView_GetChildCount($hWnd, $hSelectedItem) > 0 Then _GUICtrlTreeView_DeleteChildren($idTreeView, $hSelectedItem)
	_GUICtrlTreeView_BeginUpdate($idTreeView)
	$sPathEncrypted = __Encrypt_Name(__TreeView_GetFullPath($hWnd, $hSelectedItem))
	__SearchFolder($sPathEncrypted, $hSelectedItem)
	If $IsExpanded = True Then
		If $hSelectedItem = $idTreeViewRootItem Then
			_SendMessage(GUICtrlGetHandle($idTreeView), $TVM_EXPAND, $TVE_EXPAND, $idTreeViewRootItem, 0, "wparam", "handle") ; TreeView nur Root erweitern (öffnen)
		Else
			_GUICtrlTreeView_Expand($hWnd, $hSelectedItem)
		EndIf
	EndIf
	_GUICtrlTreeView_EndUpdate($idTreeView)
	__GUICtrlTreeView_Sort($idTreeView)
EndFunc   ;==>__TreeView_FillFolder


Func __SearchFolder($sPath, $hParentItem, $iLevel = 0) ;Recursive Folder Search for Source Treeview/Listview
	Local $hNewSubItem
	Local $aSubFolders = _FileListToArray($sPath, "*", $FLTA_FOLDERS)
	If @error then Return
	;_GUICtrlTreeView_SetChildren($idTreeView, $hParentItem)
	For $i = 1 To $aSubFolders[0]
		$hNewSubItem = _GUICtrlTreeView_AddChild($idTreeView, $hParentItem, __Decrypt_Name($aSubFolders[$i]), 0, 1)
		__SearchFolder($sPath & "\" & $aSubFolders[$i], $hNewSubItem, $iLevel + 1)
	Next

EndFunc   ;==>__SearchFolder


Func __FriendlyDate($date) ;Convert Date for Readability
	If Not IsArray($date) Then Return ""
	Local $datetime = ""
	For $i = 0 To 5
		$datetime &= $date[$i]
		If $i < 2 Then $datetime &= "-"
		If $i = 2 Then $datetime &= " "
		If $i > 2 And $i < 5 Then $datetime &= ":"
	Next
	Return $datetime
EndFunc   ;==>__FriendlyDate


Func __ListView_GetSelectedItems($hWnd, $__id_LV, $__id_TV) ;Get list of Selected Items in Source ListView
	Local $items
	$items = _GUICtrlListView_GetSelectedIndices($__id_LV, True)
	For $i = 1 To $items[0]
		$items[$i] = __TreeView_GetFullPath($__id_TV, _GUICtrlTreeView_GetSelection($__id_TV)) & "\" & _GUICtrlListView_GetItemText(ControlGetHandle($hWnd, "", $__id_LV), $items[$i], 0)
	Next
	Return $items
EndFunc   ;==>__ListView_GetSelectedItems


Func __ReduceMemory($i_PID = -1) ;Reduces Memory Usage -- Special thanks to w0uter and jftuga
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $ai_Return[0]
EndFunc   ;==>__ReduceMemory


Func __ShowFolder(ByRef $__id_TV, ByRef $__id_LV) ;Show folder in Source Folder
	Local $arrCurrentFolder[1][_GUICtrlListView_GetColumnCount($idListView)]
	Local $item, $path, $filefolder, $size, $idx, $strExtension, $found
	Local $aFileFolderItems, $iFileFolderType
	Local $aIconInfo, $aFoundData, $sDecryptedName
	$item = _GUICtrlTreeView_GetSelection($__id_TV)
	If $item = 0x000000 Then Return 0
	_GUICtrlListView_BeginUpdate($__id_LV)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($__id_LV))
	$path = __Encrypt_Name(__TreeView_GetFullPath($__id_TV, $item))
	For $iFileFolderType = 1 To 2 ; 1=Ordner 2=Dateien
		If $iFileFolderType = 1 Then $aFileFolderItems = _FileListToArray($path, "*", $FLTA_FOLDERS)
		If $iFileFolderType = 2 Then $aFileFolderItems = _FileListToArray($path, "*", $FLTA_FILES)
		If Not @error Then
			ReDim $arrCurrentFolder[$aFileFolderItems[0] +1][_GUICtrlListView_GetColumnCount($idListView)]
			For $i = 1 To $aFileFolderItems[0]
				If $iFileFolderType = 1 Then
					$filefolder = $sFolderDescription
					$size = " "
				Else
					$filefolder = StringUpper(StringRight($aFileFolderItems[$i], StringLen($aFileFolderItems[$i]) - StringInStr($aFileFolderItems[$i], ".", 0, -1))) & $sFileSuffix
					$size = FileGetSize($path & "\" & $aFileFolderItems[$i])
				EndIf
				$arrCurrentFolder[$i][0] = $aFileFolderItems[$i]
				$arrCurrentFolder[$i][1] = $filefolder
				$arrCurrentFolder[$i][2] = $size
				$arrCurrentFolder[$i][3] = __FriendlyDate(FileGetTime($path & "\" & $aFileFolderItems[$i]))
			Next
			If $iFileFolderType = 1 Then
				For $x = 0 To UBound($arrCurrentFolder) - 1
					If $arrCurrentFolder[$x][0] Then
						$sDecryptedName = __Decrypt_Name($arrCurrentFolder[$x][0])
						$idx = GUICtrlCreateListViewItem($sDecryptedName & "|" & $arrCurrentFolder[$x][1] & "|" & $arrCurrentFolder[$x][2] & "|" & $arrCurrentFolder[$x][3] & "|" & "0_" & $sDecryptedName, $__id_LV)
						$aIconInfo = __FileGetIcon($path & "\" & $arrCurrentFolder[$x][0])
						If Not @error Then GUICtrlSetImage($idx, $aIconInfo[0], $aIconInfo[1])
					EndIf
				Next
				$arrCurrentFolder = 0
				Dim $arrCurrentFolder[1][_GUICtrlListView_GetColumnCount($idListView)]
			EndIf
			If $iFileFolderType = 2 Then
				For $x = 0 To UBound($arrCurrentFolder) - 1
					If $arrCurrentFolder[$x][0] Then
						$sDecryptedName = __Decrypt_Name($arrCurrentFolder[$x][0])
						$idx = GUICtrlCreateListViewItem($sDecryptedName & "|" & $arrCurrentFolder[$x][1] & "|" & $arrCurrentFolder[$x][2] & "|" & $arrCurrentFolder[$x][3] & "|" & "1_" & $sDecryptedName, $__id_LV)
						$strExtension = StringTrimLeft($arrCurrentFolder[$x][0], StringInStr($arrCurrentFolder[$x][0], ".", 0, -1) - 1)
						If Not StringInStr($strExtension, ".lnk", 0, 0, 0, 1) Then
							$found = _ArraySearch($aFileIcons, $arrCurrentFolder[$x][0], 0, 0, 0, 1)
						Else
							$found = _ArraySearch($aFileIcons, $strExtension, 0, 0, 0, 1)
						EndIf
						If $found <> -1 Then
							$aFoundData = StringSplit($aFileIcons[$found], "|")
							GUICtrlSetImage($idx, $aFoundData[2], $aFoundData[3])
						Else
							$aIconInfo = __FileGetIcon($path & "\" & $arrCurrentFolder[$x][0])
							If Not @error Then
								ReDim $aFileIcons[UBound($aFileIcons) + 1]
								$aFileIcons[UBound($aFileIcons) - 1] = $path & "\" & $arrCurrentFolder[$x][0] & "|" & StringReplace($aIconInfo[0], Chr(34), "") & "|" & StringReplace($aIconInfo[1], Chr(34), "")
								GUICtrlSetImage($idx, $aIconInfo[0], $aIconInfo[1])
							EndIf
						EndIf
					EndIf
				Next
			EndIf
		EndIf
	Next
	$aFileFolderItems = 0
	$arrCurrentFolder = 0
	$aIconInfo = 0
	If $bInitSort = True Then ; Listview initial sortieren (neue Version)
		__GUICtrlListView_SortItems($idListView, 0)
		$bInitSort = False
	Else
		__GUICtrlListView_SortItems($idListView, GUICtrlGetState($idListView), True); Listview erneut (identisch) sortieren
	EndIf
	_GUICtrlListView_HideColumn ($idListView, 4)
	_GUICtrlListView_EndUpdate($__id_LV)
	__ReduceMemory()
EndFunc   ;==>__ShowFolder


Func __TreeView_GetFullPath($hWnd, $hItem) ;Determine full path of selected item in TreeView
	Local $sItemText, $hParentItem
	$sItemText = _GUICtrlTreeView_GetText($hWnd, $hItem)
	Do
		$hParentItem = _GUICtrlTreeView_GetParentHandle($hWnd, $hItem)
		If $hParentItem <> 0 Then
			$sItemText = _GUICtrlTreeView_GetText($hWnd, $hParentItem) & "\" & $sItemText
			$hItem = $hParentItem
		EndIf
	Until $hParentItem = 0
	Return $sItemText
EndFunc   ;==>__TreeView_GetFullPath


Func __ExitApp($__bSaveIni = True)
	Local $__hSearch, $__aTreePos, $__sTempFileName
	Local $__iTStart
	__SplashGUI_SetState(@SW_SHOW, $sPrgEnded)
	$__iTStart = TimerInit()
	While $aStartedFiles[0][0] > 0 And TimerDiff($__iTStart) < 3000
		Sleep(100)
		__CheckStartedFiles()
	Wend
	__CheckStartedFiles()
	If $aStartedFiles[0][0] > 0 Then
		__SplashGUI_SetState(@SW_HIDE)
		If _MsgBoxEx(52, $sAttention, Execute($sExtFilesAreOpened), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = $IDNO Then Return SetError(1,0,0)
	EndIf
	__SplashGUI_SetState(@SW_SHOW)
	_GUICtrlListView_UnRegisterSortCallBack($idListView)
	If FileExists($sVaultTemp) Then
		$__hSearch = FileFindFirstFile($sVaultTemp & "\*.*")
		While 1
			$__sTempFileName = FileFindNextFile($__hSearch)
			If @error Then ExitLoop
			__Secure_FileDelete($sVaultTemp & "\" & $__sTempFileName)
		Wend
		DirRemove($sVaultTemp, 1)
	EndIf
	If $__bSaveIni = True Then
		$__aTreePos = ControlGetPos($hMainGui, "", $idTreeView)
		; Fensterposition speichern, wenn nicht minimiert (= -32000)
		If $aWinPos[0] <> -32000 Then IniWrite($sIniFile, "MainGUI", "WinXPos", $aWinPos[0])
		If $aWinPos[1] <> -32000 Then IniWrite($sIniFile, "MainGUI", "WinYPos", $aWinPos[1])
		If $aWinPos[1] <> -32000 Then IniWrite($sIniFile, "MainGUI", "WinWidth", $aWinPos[2])
		If $aWinPos[1] <> -32000 Then IniWrite($sIniFile, "MainGUI", "WinHeight", $aWinPos[3])
		If $__aTreePos[2] >= 20 Then IniWrite($sIniFile, "MainGUI", "TreeWidth", $__aTreePos[2])
		If $sDecryptTarget <> "" Then IniWrite($sIniFile, "Options", "DecryptTarget", $sDecryptTarget)
		If $sSelectedLanguageIni <> "" Then IniWrite($sIniFile, "Options", "SelectedLanguage", $sSelectedLanguageIni)
	EndIf
	__SplashGUI_SetState(@SW_HIDE)
	Exit
EndFunc   ;==>__ExitApp


Func __AddNewObjects() ; Add new Objects to Treeview/Listview with Drag 'n Drop
	__SplashGUI_SetState(@SW_SHOW, "Objekte werden verschlüsselt...")
	For $i = 0 To UBound($aDropFiles) - 1
		If StringInStr(FileGetAttrib($aDropFiles[$i]), "D") Then
			If __DirCopy_Crypt_Recursiv($aDropFiles[$i], __TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & StringMid($aDropFiles[$i], StringInStr($aDropFiles[$i], "\", 0, -1) + 1)) = 0 And $i < UBound($aDropFiles) - 1 Then
				If _MsgBoxEx(52, $sError, Execute($sFolderNotCopied), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
			EndIf
		Else
			If __FileCopy_Crypt($aDropFiles[$i], __TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & StringMid($aDropFiles[$i], StringInStr($aDropFiles[$i], "\", 0, -1) + 1)) = 0 Then
				If _MsgBoxEx(52, $sError, Execute($sFileNotCopied), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
			EndIf
		EndIf
	Next
	__TreeView_FillFolder($idTreeView)
	__ShowFolder($idTreeView, $idListView)
	__SplashGUI_SetState(@SW_HIDE)
EndFunc   ;==>__AddNewObjects


Func __RenameObjects()
	Local $aSelItems, $sNewName, $bRescan = False
	Local $iInputWidth = 250
	Local $iInputHeight = 190
	Local $sObjectToRename
	$aSelItems = _GUICtrlListView_GetSelectedIndices($idListView, True)
	If $aSelItems[0] > 0 Then
		For $i = 1 To $aSelItems[0]
			$sNewName = _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
			If StringInStr(FileGetAttrib(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i]))), "D") Then
				; Umbenennen von Ordnern
				Do
					HotKeySet("{DEL}")
					$sObjectToRename = _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
					$sNewName = InputBox($sInputNewName, Execute($sInputNewFolderName), $sNewName, "", $iInputWidth, $iInputHeight, ($aWinPos[0] + ($aWinPos[2] / 2)) - ($iInputWidth / 2), ($aWinPos[1] + ($aWinPos[3] / 2)) - ($iInputHeight / 2))
					HotKeySet("{DEL}", "__DeleteObjects")
					If @error = 1 Then ExitLoop 2
					If $sNewName <> "" And $sNewName <> _GUICtrlListView_GetItemText($idListView, $aSelItems[$i]) Then
						If FileExists(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & $sNewName)) Then
							If _MsgBoxEx(52, $sError, Execute($sFolderOverwrite), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
								If DirRemove(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & $sNewName), 1) = 0 Then
									If _MsgBoxEx(52, $sError, Execute($sFolderNotOverwrite), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then
										ExitLoop 2
									Else
										$sNewName = ""
									EndIf
								EndIf
								ExitLoop
							EndIf
						Else
							ExitLoop
						EndIf
					EndIf
				Until $sNewName = _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
				If $sNewName <> _GUICtrlListView_GetItemText($idListView, $aSelItems[$i]) Then
					If DirMove(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])), __Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & $sNewName)) = 0 Then
						$sObjectToRename = _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
						If _MsgBoxEx(52, $sError, Execute($sFolderNotRenamed), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
					Else
						$bRescan = True
					EndIf
				EndIf
			Else
				; Umbenennen von Dateien
				Do
					HotKeySet("{DEL}")
					$sObjectToRename = _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
					$sNewName = InputBox($sInputNewName, Execute($sInputNewFilename), $sNewName, "", $iInputWidth, $iInputHeight, ($aWinPos[0] + ($aWinPos[2] / 2)) - ($iInputWidth / 2), ($aWinPos[1] + ($aWinPos[3] / 2)) - ($iInputHeight / 2))
					HotKeySet("{DEL}", "__DeleteObjects")
					If @error = 1 Then ExitLoop 2
					If $sNewName <> "" And $sNewName <> _GUICtrlListView_GetItemText($idListView, $aSelItems[$i]) Then
						If FileExists(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & $sNewName)) Then
							If _MsgBoxEx(52, $sError, Execute($sFileOverwrite), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
								If FileDelete(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & $sNewName)) = 0 Then
									If _MsgBoxEx(52, $sError, Execute($sFileNotOverwrite), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then
										ExitLoop 2
									Else
										$sNewName = ""
									EndIf
								EndIf
								ExitLoop
							EndIf
						Else
							ExitLoop
						EndIf
					EndIf
				Until $sNewName = _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
				If $sNewName <> _GUICtrlListView_GetItemText($idListView, $aSelItems[$i]) Then
					If FileMove(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])), __Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & $sNewName)) = 0 Then
						$sObjectToRename = _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
						If _MsgBoxEx(52, $sError, Execute($sFileNotRenamed) , "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
					Else
						$bRescan = True
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	If $bRescan = True Then
		__TreeView_FillFolder($idTreeView)
		__ShowFolder($idTreeView, $idListView)
	EndIf
EndFunc   ;==>__RenameObjects


Func __DeleteObjects() ; Delete selected Objects in Listview
	Local $aSelItems
	Local $sObjectToDelete
	If WinActive($hMainGui) Then
		$aSelItems = _GUICtrlListView_GetSelectedIndices($idListView, True)
		If $aSelItems[0] > 0 And _MsgBoxEx(52, $sRequest, $sObjectsDelete, "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
			__SplashGUI_SetState(@SW_SHOW, $sObjectsAreDeleted)
			For $i = 1 To $aSelItems[0]
				If StringInStr(FileGetAttrib(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i]))), "D") Then
					If DirRemove(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])), 1) = 0 Then
						$sObjectToDelete = __TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
						If _MsgBoxEx(52, $sError, Execute($sFolderNotDeleted), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
					EndIf
					_GUICtrlTreeView_Delete($idTreeView, _GUICtrlTreeView_FindItem($idTreeView, _GUICtrlListView_GetItemText($idListView, $aSelItems[$i]), False, _GUICtrlTreeView_GetSelection($idTreeView)))
				Else
					If FileDelete(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i]))) = 0 Then
						$sObjectToDelete = __TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
						If _MsgBoxEx(52, $sError, Execute($sFileNotDeleted), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
					EndIf
				EndIf
			Next
			__TreeView_FillFolder($idTreeView)
			__ShowFolder($idTreeView, $idListView)
			__SplashGUI_SetState(@SW_HIDE)
		EndIf
	Else
		HotKeySet("{DEL}")
		Send("{DEL}")
		HotKeySet("{DEL}", "__DeleteObjects")
	EndIf
EndFunc   ;==>__DeleteObjects


Func __AddNewFolder() ; Add new Folder to Treeview/Listview with Contextmenue
	Local $FolderName, $FolderNameC
	HotKeySet("{DEL}")
	$FolderName = InputBox($sInputNewFolder, " ", $sInputDefaultFolder)
	HotKeySet("{DEL}", "__DeleteObjects")
	If $FolderName <> "" Then
		__SplashGUI_SetState(@SW_SHOW, $sFolderEncrypted)
		$FolderNameC = __Encrypt_Name($FolderName)
		If FileExists(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView))) & "\" & $FolderNameC) Then
			__SplashGUI_SetState(@SW_HIDE)
			_MsgBoxEx(49, $sError, Execute($sFolderExists), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
			Return SetError(1, 0, 0)
		EndIf
		If DirCreate(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView))) & "\" & $FolderNameC) = 0 Then
			__SplashGUI_SetState(@SW_HIDE)
			_MsgBoxEx(49, $sError, Execute($sFolderNotCreated), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
			Return SetError(1, 0, 0)
		Else
			__SplashGUI_SetState(@SW_HIDE)
			__TreeView_FillFolder($idTreeView)
			__ShowFolder($idTreeView, $idListView)
			Return SetError(0, 0, 1)
		EndIf
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>__AddNewFolder


Func __AddNewFile() ; Add new File to Listview with Contextmenue
	Local $FileName
	HotKeySet("{DEL}")
	$FileName = InputBox($sInputNewFile, " ", $sInputDefaultFile)
	HotKeySet("{DEL}", "__DeleteObjects")
	If $FileName <> "" Then
		If FileExists(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & $FileName)) Then
			__SplashGUI_SetState(@SW_HIDE)
			_MsgBoxEx(48, $sError, Execute($sFileExists), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
			Return SetError(1, 0, 0)
		EndIf
		__SplashGUI_SetState(@SW_SHOW, $sFileEncrypted)
		If FileWrite(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & $FileName), "") = 0 Then
			__SplashGUI_SetState(@SW_HIDE)
			_MsgBoxEx(48, $sError, Execute($sFileNotCreated), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
		Else
			__SplashGUI_SetState(@SW_HIDE)
			__TreeView_FillFolder($idTreeView)
			__ShowFolder($idTreeView, $idListView)
			Return SetError(0, 0, 1)
		EndIf
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>__AddNewFile


Func __DirCopy_Crypt_Recursiv($sSource, $sDestination, $bOverwrite = False)
	; Rückgabe im Fehlerfall ist 0 und @error ist:
	;	1-3	=	Fehlercode der Sub-Funktion FileCopy_Crypt()
	;	4	=	Keine Quelle oder kein Ziel
	;	5	=	Kryptierter Ordner konnte nicht erzeugt werden
	Local $hSearch, $sObject, $Ret, $sDestinationC, $sItemDisplay
	If $sSource = "" Or $sDestination = "" Then Return SetError(4, 0, 0)
	If StringRight($sDestination, 1) <> "\" Then $sDestination &= "\"
	If StringRight($sSource, 1) <> "\" Then $sSource &= "\"
	$sDestinationC = __Encrypt_Name($sDestination)
	$sItemDisplay = StringTrimRight($sSource, 1)
	If StringLen($sItemDisplay) > 45  Then $sItemDisplay = "..." & StringRight($sItemDisplay, 42)
	If Not FileExists($sDestinationC) Then
		__SplashGUI_SetState(@SW_SHOW, $sObjectsEncrypted, $sFolderPrefix & " " & $sItemDisplay) ; Ordner-Anzeige aktualisieren
		$Ret = DirCreate($sDestinationC)
		If $Ret = 0 Then
			If _MsgBoxEx($MB_YESNO, $sError, $sErrFolderCreatePrefix & @CRLF & @CRLF & $sDestinationC & @CRLF & @CRLF & $sContinue, "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = $IDNO Then
				Return SetError(5,0,0)
			EndIf
		EndIf
	EndIf
	$hSearch = FileFindFirstFile($sSource & "*.*")
	While 1
		$sObject = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If $sObject = "." Or $sObject = ".." Then ContinueLoop
		If StringInStr(FileGetAttrib($sSource & $sObject), "D") > 0 Then
			$Ret = __DirCopy_Crypt_Recursiv($sSource & $sObject, $sDestination & $sObject, $bOverwrite)
			If $Ret = 0 Then
				Return SetError(@error, 0, 0)
			EndIf
		Else
			$Ret = __FileCopy_Crypt($sSource & $sObject, $sDestination & $sObject, $bOverwrite)
			If $Ret = 0 Then
				Switch @error
					Case 1
						Return SetError(1, 0, 0)
					Case 2
						If _MsgBoxEx($MB_YESNO, $sPathLength, $sCryptPathToLong & @CRLF & @CRLF & $sObject & @CRLF & @CRLF & $sContinue, "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = $IDNO Then
							Return SetError(2, 0, 0)
						EndIf
					Case 3
						If _MsgBoxEx($MB_YESNO, $sError, $sCopyFileErrorGeneral & @CRLF & @CRLF & $sObject & @CRLF & @CRLF & $sContinue, "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = $IDNO Then
							Return SetError(3, 0, 0)
						EndIf
				EndSwitch
			EndIf
		EndIf
	WEnd
	FileClose($hSearch)
	Return SetError(0, 0, 1)
EndFunc   ;==>__DirCopy_Crypt_Recursiv


Func __FileCopy_Crypt($sSource, $sDestination, $bOverwrite = False)
	; Rückgabewert im Fehlerfall ist 0 und @error ist:
	;	1	=	Keine Quelle oder kein Ziel
	;	2	=	Kryptierter Pfad inkl. Dateiname ist > 259 Zeichen
	;			(NTFS-Grenze)
	;	3	=	Kryptieren der Datei fehlgeschlagen
	Local $Ret, $sDestinationC
	If $sSource = "" Or $sDestination = "" Then Return SetError(1, 0, 0)
	$sDestinationC = __Encrypt_Name($sDestination)
	If StringLen($sDestinationC) > 259 Then Return SetError(2, 0, 0)
	Select
		Case FileExists($sDestinationC) = True And $bOverwrite = False
			If _MsgBoxEx(36, $sOverWrite, Execute($sFileExistsOverwrite), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
				FileDelete($sDestinationC)
				If FileGetSize($sSource) > 0 Then
					$Ret = _AesEncryptFile($sKey, $sSource, $sDestinationC, "CFB")
				Else
					$Ret = FileCopy($sSource, $sDestinationC)
				EndIf
			EndIf
		Case FileExists($sDestinationC) = True And $bOverwrite = True
			FileDelete($sDestinationC)
			If FileGetSize($sSource) > 0 Then
				$Ret = _AesEncryptFile($sKey, $sSource, $sDestinationC, "CFB")
			Else
				$Ret = FileCopy($sSource, $sDestinationC)
			EndIf
		Case FileExists($sDestinationC) = False
			If FileGetSize($sSource) > 0 Then
				$Ret = _AesEncryptFile($sKey, $sSource, $sDestinationC, "CFB")
			Else
				$Ret = FileCopy($sSource, $sDestinationC)
			EndIf
	EndSelect
	If $Ret = 0 Then Return SetError(3, 0, 0)
	Return SetError(0, 0, 1)
EndFunc   ;==>__FileCopy_Crypt


Func __DecryptExecute($object)
	Local $posBS, $FileName, $objectC, $Ret, $iPID, $aLinkDetails
	__SplashGUI_SetState(@SW_SHOW, $sFileDecrypted)
	If Not FileExists($sVaultTemp) Then DirCreate($sVaultTemp)
	$posBS = StringInStr($object, "\", 0, -1)
	If $posBS > 0 Then
		$FileName = StringMid($object, $posBS + 1)
	Else
		$FileName = $object
	EndIf
	$objectC = __Encrypt_Name($object)
	If FileGetSize($objectC) > 0 Then
		$Ret = _AesDecryptFile($sKey, $objectC, $sVaultTemp & "\" & $FileName, "CFB")
	Else
		$Ret = FileCopy($objectC, $sVaultTemp & "\" & $FileName, 1)
	EndIf
	If $Ret Then
		FileSetAttrib($sVaultTemp & "\" & $FileName, "-A")
		If StringRight($FileName, 4) = ".lnk" Then
			$aLinkDetails = FileGetShortcut($sVaultTemp & "\" & $FileName)
			If Not @error And FileExists($aLinkDetails[0]) Then
				$iPID = __StartFile2($aLinkDetails[0])
			Else
				__Secure_FileDelete($sVaultTemp & "\" & $FileName)
				__SplashGUI_SetState(@SW_SHOW, $sDestinationNotAvailable)
				Sleep(1000)
			EndIf
		Else		
			$iPID = __StartFile2($sVaultTemp & "\" & $FileName)
		EndIf
		If $iPID > 0 Then
			ReDim $aStartedFiles[$aStartedFiles[0][0] + 2][3]
			$aStartedFiles[0][0] += 1
			$aStartedFiles[$aStartedFiles[0][0]][0] = $iPID
			$aStartedFiles[$aStartedFiles[0][0]][1] = $sVaultTemp & "\" & $FileName
			$aStartedFiles[$aStartedFiles[0][0]][2] = $object
		EndIf
	Else
		__SplashGUI_SetState(@SW_HIDE)
		_MsgBoxEx(48, $sError, Execute($sFileNotDecrypted), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
	EndIf
	__SplashGUI_SetState(@SW_HIDE)
EndFunc   ;==>__DecryptExecute


Func __CheckPW()
	Local $bCheck = False
	Local $aInVault = DirGetSize($sVaultDir, 1)
	Local $search, $object, $sSecondPW
	If Not IsArray($aInVault) Or ($aInVault[1] + $aInVault[2]) < 1 Then __ShowShortInfo()
	Do
		$sKey = ""
		; Passwort als Parameter übergeben ?
		If $cmdline[0] <> 0 Then
			For $i = 1 To $cmdline[0]
				If $cmdline[$i] = "/pw" And $i <> $cmdline[0] And StringLeft($cmdline[$i + 1], 1) <> "/" Then $sKey = $cmdline[$i + 1]
			Next
		EndIf
		; Kein Passwort als Parameter, dann abfragen...
		If $sKey = "" Then
			Do
				$sKey = InputBox($sInputPassword, $sInputPleasePassword, "", "*", -1, -1, $aWinPos[0] + ($aWinPos[2] - 250) / 2, $aWinPos[1] + ($aWinPos[3] - 190) / 2)
			Until $sKey <> "" Or _MsgBoxEx(53, $sError, $sWithoutPwNotCrypted, "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 2
		EndIf
		If $sKey = "" Then __ExitApp(False)
		If IsArray($aInVault) And ($aInVault[1] + $aInVault[2]) > 0 Then
			$search = FileFindFirstFile($sVaultDir & "\*.*")
			$object = FileFindNextFile($search)
			If StringRight($object, 1) <> "\" Then
				If StringInStr($object, ".") > 0 Then
					$object = StringLeft($object, StringInStr($object, ".", 0, -1) - 1)
				EndIf
			EndIf
			If StringLeft(Blowfish($sKey, BinaryToString(_Base64Decode(StringReplace(StringReplace($object, "_", "/"), "-", "+"))), 1), StringLen($sIdent)) = $sIdent Then $bCheck = True
		Else
			$sSecondPW = InputBox($sInputCheck, $sInputPleasePasswordSecond, "", "*", -1, -1, $aWinPos[0] + ($aWinPos[2] - 250) / 2, $aWinPos[1] + ($aWinPos[3] - 190) / 2)
		EndIf
	Until $bCheck = True Or $sSecondPW = $sKey Or _MsgBoxEx(53, $sPasswordError, $sWrongPasswordAgain, "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 2
	If $bCheck = False And $sSecondPW <> $sKey Then __ExitApp(False)
EndFunc   ;==>__CheckPW


Func __Encrypt_Name($sName)
	Local $Ret, $sOut, $aPathSplits, $iPoiPos, $sTrailing
	If StringInStr($sName, $sVaultDir) Then
		$sName = StringReplace($sName, $sVaultDir, "")
		$sOut &= $sVaultDir
	EndIf
	If StringLen($sName) > 0 Then
		If StringInStr($sName, "\") = 0 Then
			If $sTrailing = "" And StringInStr($sName, ".") > 0 Then
				$sTrailing = StringMid($sName, StringInStr($sName, ".", 0, -1))
				$sName = StringLeft($sName, StringInStr($sName, ".", 0, -1) - 1)
			EndIf
			$sOut = StringReplace(StringReplace(_Base64Encode(Blowfish($sKey, $sIdent & $sName), False), "+", "-"), "/", "_")
		Else
			If StringLeft($sName, 1) = "\" Then
				$sName = StringMid($sName, 2)
				$sOut &= "\"
			EndIf
			If StringRight($sName, 1) = "\" Then
				$sTrailing = "\"
				$sName = StringTrimRight($sName, 1)
			EndIf
			$aPathSplits = StringSplit($sName, "\")
			If $aPathSplits[0] > 0 Then
				If $sTrailing = "" And StringInStr($aPathSplits[UBound($aPathSplits) - 1], ".") > 0 Then
					$sTrailing = StringMid($aPathSplits[UBound($aPathSplits) - 1], StringInStr($aPathSplits[UBound($aPathSplits) - 1], ".", 0, -1))
					$aPathSplits[UBound($aPathSplits) - 1] = StringLeft($aPathSplits[UBound($aPathSplits) - 1], StringInStr($aPathSplits[UBound($aPathSplits) - 1], ".", 0, -1) - 1)
				EndIf
				For $i = 1 To $aPathSplits[0]
					$Ret = StringReplace(StringReplace(_Base64Encode(Blowfish($sKey, $sIdent & $aPathSplits[$i]), False), "+", "-"), "/", "_")
					If StringLen($Ret) = "" Then Return SetError(1, 0, 0)
					$sOut &= $Ret & "\"
					$Ret = ""
				Next
				$sOut = StringTrimRight($sOut, 1)
			EndIf
		EndIf
		If $sTrailing <> "" Then $sOut &= $sTrailing
	EndIf
	If StringLen($sOut) > 0 Then Return $sOut
	Return SetError(1, 0, 0)
EndFunc   ;==>__Encrypt_Name


Func __Decrypt_Name($sName)
	Local $Ret, $sOut, $iPoiPos, $iLenIdent = StringLen($sIdent)
	Local $sTrailing, $aPathSplits
	If StringInStr($sName, $sVaultDir) Then
		$sName = StringReplace($sName, $sVaultDir, "")
		$sOut &= $sVaultDir
	EndIf
	If StringLen($sName) > 0 Then
		If $sTrailing = "" And StringInStr($sName, ".") > 0 Then
			$sTrailing = StringMid($sName, StringInStr($sName, ".", 0, -1))
			$sName = StringLeft($sName, StringInStr($sName, ".", 0, -1) - 1)
		EndIf
		If StringInStr($sName, "\") = 0 Then
			$Ret = Blowfish($sKey, BinaryToString(_Base64Decode(StringReplace(StringReplace($sName, "_", "/"), "-", "+"))), 1)
			If StringLen($Ret) > $iLenIdent And StringLeft($Ret, $iLenIdent) = $sIdent Then
				$sOut &= StringMid($Ret, $iLenIdent + 1)
			EndIf
		Else
			If StringLeft($sName, 1) = "\" Then
				$sName = StringMid($sName, 2)
				$sOut &= "\"
			EndIf
			If StringRight($sName, 1) = "\" Then
				$sTrailing = "\"
				$sName = StringTrimRight($sName, 1)
			EndIf
			$aPathSplits = StringSplit($sName, "\")
			If $aPathSplits[0] > 0 Then
				For $i = 1 To $aPathSplits[0]
					$Ret = Blowfish($sKey, BinaryToString(_Base64Decode(StringReplace(StringReplace($aPathSplits[$i], "_", "/"), "-", "+"))), 1)
					If StringLen($Ret) > $iLenIdent And StringLeft($Ret, $iLenIdent) = $sIdent Then
						$sOut &= StringMid($Ret, $iLenIdent + 1) & "\"
					EndIf
				Next
				$sOut = StringTrimRight($sOut, 1)
			EndIf
		EndIf
	EndIf
	If $sTrailing <> "" Then $sOut &= $sTrailing
	If StringLen($sOut) > 0 Then Return $sOut
	Return SetError(1, 0, 0)
EndFunc   ;==>__Decrypt_Name


Func __DecryptAll() ; Decrypt all selected Objects in Listview
	Local $aSelItems, $bErrorDetect = False, $sDecryptTargetNew
	Local $sObjectToDecrypt
	$aSelItems = _GUICtrlListView_GetSelectedIndices($idListView, True)
	If $aSelItems[0] > 0 Then
		$sDecryptTargetNew = FileSelectFolder($sSelectFolder, $sDecryptTarget, 7, $sDecryptTarget)
		If $sDecryptTargetNew = "" Then Return SetError(1, 0, 0)
		$sDecryptTarget = $sDecryptTargetNew
		If StringRight($sDecryptTarget, 1) <> "\" Then $sDecryptTarget &= "\"
		__SplashGUI_SetState(@SW_SHOW, $sObjectsDecrypted)
		For $i = 1 To $aSelItems[0]
			If StringInStr(FileGetAttrib(__Encrypt_Name(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i]))), "D") Then
				If FileExists($sDecryptTarget & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])) Then
					$sObjectToDecrypt = $sDecryptTarget & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
					If _MsgBoxEx(36, $sUseTarget, Execute($sDecryptFolderExistsUsed), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then
						$bErrorDetect = True
						ExitLoop
					EndIf
				EndIf
				If __DecryptFolder_Recursiv(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i]), $sDecryptTarget & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])) = 0 Then
					$bErrorDetect = True
					$sObjectToDecrypt = __TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
					If _MsgBoxEx(52, $sError, Execute($sDecryptFolderExistsContinue), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
				EndIf
			Else
				If __DecryptFile(__TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i]), $sDecryptTarget) = 0 Then
					$bErrorDetect = True
					$sObjectToDecrypt = __TreeView_GetFullPath($idTreeView, _GUICtrlTreeView_GetSelection($idTreeView)) & "\" & _GUICtrlListView_GetItemText($idListView, $aSelItems[$i])
					If _MsgBoxEx(52, $sError, Execute($sDecryptFileExistsContinue), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
				EndIf
			EndIf
		Next
	EndIf
	If $bErrorDetect = False Then
		__SplashGUI_SetState(@SW_SHOW, $sDecryptSuccessful)
	Else
		__SplashGUI_SetState(@SW_SHOW, $sDecryptWithError)
	EndIf
	Sleep(2000)
	__SplashGUI_SetState(@SW_HIDE)
EndFunc   ;==>__DecryptAll


Func __DecryptFile($sSource, $sDestination, $bOverwrite = False)
	Local $Ret, $sSourceC, $iPosBS, $sFilename
	Local $sObjectToDecrypt
	If $sSource = "" Or $sDestination = "" Then Return SetError(1, 0, 0)
	$iPosBS = StringInStr($sSource, "\", 0, -1)
	If $iPosBS > 0 Then
		$sFileName = StringMid($sSource, $iPosBS + 1)
	Else
		$sFileName = $sSource
	EndIf
	$sSourceC = __Encrypt_Name($sSource)
	Select
		Case FileExists($sDestination & "\" & $sFileName) = True And $bOverwrite = False
			$sObjectToDecrypt = $sDestination & "\" & $sFileName
			If _MsgBoxEx(36, $sOverWrite, Execute($sDecryptFileExistsOverwrite), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
				FileDelete($sDestination & "\" & $sFileName)
				If FileGetSize($sSourceC) > 0 Then
					$Ret = _AesDecryptFile($sKey, $sSourceC, $sDestination & "\" & $sFileName, "CFB")
				Else
					$Ret = FileCopy($sSourceC, $sDestination & "\" & $sFileName)
				EndIf
			EndIf
		Case FileExists($sDestination & "\" & $sFileName) = True And $bOverwrite = True
			FileDelete($sDestination & "\" & $sFileName)
			If FileGetSize($sSourceC) > 0 Then
				$Ret = _AesDecryptFile($sKey, $sSourceC, $sDestination & "\" & $sFileName, "CFB")
			Else
				$Ret = FileCopy($sSourceC, $sDestination & "\" & $sFileName)
			EndIf
		Case FileExists($sDestination & "\" & $sFileName) = False
			If FileGetSize($sSourceC) > 0 Then
				$Ret = _AesDecryptFile($sKey, $sSourceC, $sDestination & "\" & $sFileName, "CFB")
			Else
				$Ret = FileCopy($sSourceC, $sDestination & "\" & $sFileName)
			EndIf
	EndSelect
	If $Ret = 0 Then Return SetError(1, 0, 0)
	Return SetError(0, 0, 1)
EndFunc   ;==>__DecryptFile


Func __DecryptFolder_Recursiv($sSource, $sDestination, $bOverwrite = False)
	Local $hSearch, $sObject, $sObjectC, $Ret, $sSourceC, $sItemDisplay
	If StringRight($sDestination, 1) <> "\" Then $sDestination &= "\"
	If StringRight($sSource, 1) <> "\" Then $sSource &= "\"
	If Not FileExists($sDestination) Then
		DirCreate($sDestination)
		Sleep(100)
	EndIf
	$sSourceC = __Encrypt_Name($sSource)
	$sItemDisplay = StringTrimRight($sSource, 1)
	If StringLen($sItemDisplay) > 45  Then $sItemDisplay = "..." & StringRight($sItemDisplay, 42)
	__SplashGUI_SetState(@SW_SHOW, $sObjectsDecrypted, $sFolderPrefix & " " & $sItemDisplay)
	$hSearch = FileFindFirstFile($sSourceC & "*.*")
	While 1
		$sObjectC = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If $sObjectC = "." Or $sObjectC = ".." Then ContinueLoop
		$sObject = __Decrypt_Name($sObjectC)
		If StringInStr(FileGetAttrib($sSourceC & $sObjectC), "D") > 0 Then
			$Ret = __DecryptFolder_Recursiv($sSource & $sObject, $sDestination & $sObject, $bOverwrite)
			If $Ret = 0 Then Return SetError(1, 0, 0)
		Else
			$Ret = __DecryptFile($sSource & $sObject, $sDestination, $bOverwrite)
		EndIf
	WEnd
	FileClose($hSearch)
	Return SetError(0, 0, 1)
EndFunc   ;==>__DecryptFolder_Recursiv


Func __WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam) ;Notify func
	Local $item, $filefolder, $idx, $found
	Local $__h_TV = ControlGetHandle($hwnd, "", $idTreeView)
	Local $__h_LV = ControlGetHandle($hwnd, "", $idListView)
	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	Local $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	Local $iCode = DllStructGetData($tNMHDR, "Code")
	If $iCode = -12 Or $iCode = -17 Then Return False
	Switch $hWndFrom
		Case $__h_LV
			$item = __ListView_GetSelectedItems($hMainGui, $idListView, $idTreeView)
			Switch $iCode
				Case $NM_DBLCLK
					If $item[0] <> 0 Then
						$filefolder = _GUICtrlListView_GetSelectedIndices($idListView, True)
						If _GUICtrlListView_GetItemText($idListView, $filefolder[1], 1) = $sFolderDescription Or _GUICtrlListView_GetItemText($idListView, $filefolder[1], 1) = "Folder" Then
							$idx = _GUICtrlTreeView_GetSelection($idTreeView)
							$item = StringTrimLeft($item[1], StringInStr($item[1], "\", 0, -1))
							$found = _GUICtrlTreeView_FindItem($idTreeView, $item, False, $idx)
							_GUICtrlTreeView_SelectItem($idTreeView, $found)
							__TreeView_FillFolder($idTreeView)
							__ShowFolder($idTreeView, $idListView)
						Else
							__DecryptExecute($item[1])
						EndIf
					EndIf
					Return True
			EndSwitch
		Case $__h_TV
			Switch $iCode
				Case $NM_RCLICK
					Local $tPOINT = _WinAPI_GetMousePos(True, $__h_TV)
					Local $iX = DllStructGetData($tPOINT, "X")
					Local $iY = DllStructGetData($tPOINT, "Y")
					Local $hItem = _GUICtrlTreeView_HitTestItem($__h_TV, $iX, $iY)
					If $hItem <> 0 Then _GUICtrlTreeView_SelectItem($__h_TV, $hItem, $TVGN_CARET)
				Case $TVN_SELCHANGEDW
					__ShowFolder($idTreeView, $idListView)
					Return True
			EndSwitch
		Case Else
			Switch $iCode
				Case $NM_CLICK ; The user has clicked the left mouse button within the control
					_SendMessage($hMainGui, $WM_SYSCOMMAND, 0xF012, 2, 1)
			EndSwitch
	EndSwitch
EndFunc   ;==>__WM_NOTIFY


Func __WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
	Local $nSize, $pFileName
	Local $nAmt = DllCall('shell32.dll', 'int', 'DragQueryFileW', 'hwnd', $wParam, 'int', 0xFFFFFFFF, 'ptr', 0, 'int', 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall('shell32.dll', 'int', 'DragQueryFileW', 'hwnd', $wParam, 'int', $i, 'ptr', 0, 'int', 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate('wchar[' & $nSize & ']')
		DllCall('shell32.dll', 'int', 'DragQueryFileW', 'hwnd', $wParam, 'int', $i, 'ptr', DllStructGetPtr($pFileName), 'int', $nSize)
		ReDim $aDropFiles[$i + 1]
		$aDropFiles[$i] = DllStructGetData($pFileName, 1)
		$pFileName = 0
	Next
EndFunc   ;==>__WM_DROPFILES_FUNC


Func __WM_Move()
	$aWinPos = WinGetPos($hMainGui)
	Local $aPosChild = WinGetPos($hSplashGUI)
	If IsArray($aPosChild) Then
	Local $iXDiff = ($aWinPos[2] - $aPosChild[2]) / 2
	Local $iYDiff = ($aWinPos[3] - $aPosChild[3]) / 2
	WinMove($hSplashGUI, '', $aWinPos[0] + $iXDiff, $aWinPos[1] + $iYDiff)
	$aTreePos = ControlGetPos($hMainGui, "", $idTreeView)
	$aListPos = ControlGetPos($hMainGui, "", $idListView)
	__ColumnResize($idListView)
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>__WM_Move


Func __CheckStartedFiles()
	Local $sFileName
	Local $i = 1
	While $i <= UBound($aStartedFiles) - 1
		If Not ProcessExists($aStartedFiles[$i][0]) Then
			If StringInStr(FileGetAttrib($aStartedFiles[$i][1]), "A") > 0 Then
				If StringInStr($aStartedFiles[$i][1], "\") > 0 Then
					$sFileName = StringMid($aStartedFiles[$i][1], StringInStr($aStartedFiles[$i][1], "\", 0, -1) + 1)
				Else
					$sFileName = $aStartedFiles[$i][1]
				EndIf
				If _MsgBoxEx(36, $sWriteBack, Execute($sFileEncryptNew), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
					__SplashGUI_SetState(@SW_SHOW, $sFileUpdated)
					__FileCopy_Crypt($aStartedFiles[$i][1], $aStartedFiles[$i][2], True)
					Sleep(100)
					__SplashGUI_SetState(@SW_HIDE)
					__ShowFolder($idTreeView, $idListView)
				EndIf
			EndIf
			__Secure_FileDelete($aStartedFiles[$i][1])
			_ArrayDelete($aStartedFiles, $i)
			$aStartedFiles[0][0] -= 1
		Else
			$i += 1
		EndIf
	WEnd
EndFunc   ;==>__CheckStartedFiles


Func __SplashGUI_SetState($State = @SW_SHOW, $sText = "", $sAddInfo = "")
	If $State = @SW_SHOW Then
		If $sText <> "" Then GUICtrlSetData($idSplashLabel, $sText)
		GUICtrlSetData($idSplashLabelAddInfo, $sAddInfo)
	Else
		GUICtrlSetData($idSplashLabel, $sActionExecuted)
		GUICtrlSetData($idSplashLabelAddInfo, "")
	EndIf
	GUISetState($State, $hSplashGUI)
	Sleep(100)
EndFunc   ;==>__SplashGUI_SetState


Func __GetTotalScreenResolution()
	Local $aRet[2], $VirtualDesktopWidth, $VirtualDesktopHeight
	Global Const $SM_VIRTUALWIDTH = 78
	Global Const $SM_VIRTUALHEIGHT = 79
	$VirtualDesktopWidth = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALWIDTH)
	$aRet[0] = $VirtualDesktopWidth[0]
	$VirtualDesktopHeight = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALHEIGHT)
	$aRet[1] = $VirtualDesktopHeight[0]
	Return $aRet
EndFunc   ;==>__GetTotalScreenResolution


Func __Secure_FileDelete($sFile)
	Local $iSize, $hFile
	Local $sDummy = "01"
	If Not FileExists($sFile) Then Return 0
	$iSize = FileGetSize($sFile)
	Do
		$sDummy &= $sDummy
	Until StringLen($sDummy) > $iSize
	$sDummy = StringLeft($sDummy, $iSize)
	$hFile = FileOpen($sFile, 2)
	FileWrite($hFile, $sDummy)
	FileClose($hFile)
	Return FileDelete($sFile)
EndFunc   ;==>__Secure_FileDelete


; #FUNCTION# ======================================================================================
; Name ..........: __StartFile2()
; Description ...: Ruft Dateien ähnlich Shellexecute auf und gibt die ProzessID zurück
; Syntax ........: StartFile2($sFilePath, Const[ $sParams = '', Const[ $WorkDir = @WorkingDir, Const[ $sVerb = "open", Const[ $show_Flag = @SW_SHOW, Const[ $opt_flag = 0]]]]])
; Parameters ....: $sFilePath       - Pfad zur aufzurufenden Datei
;                  Const $sParams   - [optional] Parameter für die Datei (default:'')
;                  Const $WorkDir   - [optional] Arbeitsverzeichnis für den Programmaufruf (default:@WorkingDir)
;                  Const $sVerb     - [optional] Der zu verwendende Folgebefehl (open, edit, print, properties) (default:"open")
;                  Const $show_Flag - [optional] Anzeige-Flag des ausgeführten Programms ( siehe Run()) (default:@SW_SHOW)
;                  Const $opt_flag  - [optional] verschiedene Optionen für STDIO (siehe Run()) (default:0)
; Return values .: Success: Return PID
;                  Failure: Return 0 and sets @error
; Author ........: micha_he@Autoit.de (Original from: AspirinJunkie@autoit.de)
; =================================================================================================
Func __StartFile2($sFilePath, Const $sParams = '', Const $WorkDir = @WorkingDir, Const $sVerb = "open", Const $show_Flag = @SW_SHOW, Const $opt_flag = 0)
	; Umschaltung, damit Windows-Umgebungsvariablen direkt verwendet werden können
	; Alter Wert wird gespeichert
	Local Const $iOldOpt = Opt("ExpandEnvStrings", 1)
	Local $sFileEnd, $sFileType, $sRunStatement, $iExtended
	Local $iPID, $iError, $sFileTypeClass, $sFileTypeCmd
	$sFilePath = FileGetLongName($sFilePath)
	; Wenn weder eine Datei noch ein Ordner mit dem Namen existiert
	If Not FileExists($sFilePath) Then Return SetError(1, Opt("ExpandEnvStrings", $iOldOpt), 0)
	; Wenn die Datei ein Verzeichnisname ist....
	If StringInStr(FileGetAttrib($sFilePath), "D") Then Return SetError(0, Opt("ExpandEnvStrings", $iOldOpt), Run('explorer.exe "' & $sFilePath & '"', $WorkDir, $show_Flag, $opt_flag))
	; Dateiendung ermitteln
	$sFileEnd = StringRight($sFilePath, StringLen($sFilePath) - StringInStr($sFilePath, '.', 2, -1) + 1)
	; Kein Punkt im Dateinamen - unbekannter Dateityp
	If $sFileEnd = $sFilePath Then Return SetError(2, Opt("ExpandEnvStrings", $iOldOpt), 0)
	; Prüfe User-Explorer-FileExts-Application
	If $sFileTypeCmd = "" Then
		$sFileTypeClass = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" & $sFileEnd, "Application")
		If $sFileTypeClass <> "" Then
			; Versuche passende Applikation im Userpfad zu ermitteln
			$sFileTypeCmd = RegRead("HKCU\Software\Classes\Applications\" & $sFileTypeClass & "\shell\" & $sVerb & "\command", "")
			; Wenn nicht im Userpfad gefunden, dann ermitteln der Applikation in den Root-Classes
			If $sFileTypeCmd = "" Then $sFileTypeCmd = RegRead("HKCR\Applications\" & $sFileTypeClass & "\shell\" & $sVerb & "\command", "")
		EndIf
	EndIf
	; Prüfe User-Explorer-FileExts-ProgID
	If $sFileTypeCmd = "" Then
		$sFileTypeClass = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" & $sFileEnd, "ProgID")
		If $sFileTypeClass <> "" Then
			; Versuche passende Applikation im Userpfad zu ermitteln
			$sFileTypeCmd = RegRead("HKCU\Software\Classes\" & $sFileTypeClass & "\shell\" & $sVerb & "\command", "")
			; Wenn nicht im Userpfad gefunden, dann ermitteln der Applikation in den Root-Classes
			If $sFileTypeCmd = "" Then $sFileTypeCmd = RegRead("HKCR\" & $sFileTypeClass & "\shell\" & $sVerb & "\command", "")
		EndIf
	EndIf
	; Prüfe User-Explorer-FileExts-ProgID unter Windows7
	If $sFileTypeCmd = "" Then
		$sFileTypeClass = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" & $sFileEnd & "\UserChoice", "Progid")
		If $sFileTypeClass <> "" Then
			; Versuche passende Applikation im Userpfad zu ermitteln
			$sFileTypeCmd = RegRead("HKCU\Software\Classes\" & $sFileTypeClass & "\shell\" & $sVerb & "\command", "")
			; Wenn nicht im Userpfad gefunden, dann ermitteln der Applikation in den Root-Classes
			If $sFileTypeCmd = "" Then $sFileTypeCmd = RegRead("HKCR\" & $sFileTypeClass & "\shell\" & $sVerb & "\command", "")
		EndIf
	EndIf
	; wenn bisher erfolglos, prüfe User-Software-Classes
	If $sFileTypeCmd = "" Then
		$sFileTypeClass = RegRead("HKCU\Software\Classes\" & $sFileEnd, "")
		If $sFileTypeClass <> "" Then
			; Versuche passende Applikation im Userpfad zu ermitteln
			$sFileTypeCmd = RegRead("HKCU\Software\Classes\Applications\" & $sFileTypeClass & "\shell\" & $sVerb & "\command", "")
			; Wenn nicht im Userpfad gefunden, dann ermitteln der Applikation in den Root-Classes
			If $sFileTypeCmd = "" Then $sFileTypeCmd = RegRead("HKCR\Applications\" & $sFileTypeClass & "\shell\" & $sVerb & "\command", "")
		EndIf
	EndIf
	; wenn bisher erfolglos, prüfe Root-Classes
	If $sFileTypeCmd = "" Then
		$sFileTypeClass = RegRead("HKCR\" & $sFileEnd, "")
		If $sFileTypeClass <> "" Then
			; Versuche Applikation in den Root-Classes zu ermitteln
			$sFileTypeCmd = RegRead("HKCR\" & $sFileTypeClass & "\shell\" & $sVerb & "\command", "")
		EndIf
	EndIf
	; es konnte keine passende Applikation zur Dateiendung gefunden werden
	If $sFileTypeCmd = "" Then Return SetError(4, Opt("ExpandEnvStrings", $iOldOpt), 0)
	; Anpassung für RJTextEd damit immer ein eigenes Fenster geöffnet wird
	If StringInStr($sFileTypeCmd, '\TextEd.exe') Then $sFileTypeCmd=StringReplace($sFileTypeCmd, ' "%1"', ' /multi "%1"')
	; die Platzhalter werden möglichst mit dem übergebenen Dateinamen ersetzt
	; Platzhalter "/dde" ist bei Microsoft Excel 2010 notwendig
	$sRunStatement = FileGetLongName(StringRegExpReplace($sFileTypeCmd, '("?(?:%1|%L|/dde)"?)', StringReplace('"' & $sFilePath & '"', "\", "\\")))
	; an die Funktion übergeben Parameter werden möglichst eingefügt
	$sRunStatement = FileGetLongName(StringReplace($sRunStatement, '%*', $sParams))
	; Programm wird gestartet
	$iPID = Run($sRunStatement, $WorkDir, $show_Flag, $opt_flag)
	$iError = @error
	$iExtended = @extended
	; Option wird wieder auf den alten Wert gesetzt
	Opt("ExpandEnvStrings", $iOldOpt)
	Return SetError($iError, $iExtended, $iPID)
EndFunc   ;==>__StartFile2


Func __GetDecryptedLinkTarget($sLinkCrypted)
	; Entschlüsselt den Namen einer Verknüpfung, entpackt diese und
	; ermittelt das dazu gehörige unverschlüsselte Ziel
	Local $posBS, $FileName, $sLinkClear, $Ret, $aLinkDetails
	If Not FileExists($sVaultTemp) Then DirCreate($sVaultTemp)
	$sLinkClear = __Decrypt_Name($sLinkCrypted)
	$posBS = StringInStr($sLinkClear, "\", 0, -1)
	If $posBS > 0 Then
		$FileName = StringMid($sLinkClear, $posBS + 1)
	Else
		$FileName = $sLinkClear
	EndIf
	If FileGetSize($sLinkCrypted) > 0 Then
		$Ret = _AesDecryptFile($sKey, $sLinkCrypted, $sVaultTemp & "\" & $FileName, "CFB")
	Else
		$Ret = FileCopy($sLinkCrypted, $sVaultTemp & "\" & $FileName, 1)
	EndIf
	If $Ret Then
		FileSetAttrib($sVaultTemp & "\" & $FileName, "-A")
		$aLinkDetails = FileGetShortcut($sVaultTemp & "\" & $FileName)
		__Secure_FileDelete($sVaultTemp & "\" & $FileName)
		If Not @error Then Return $aLinkDetails[0]
		Return SetError(2,0,0)
	Else
		__Secure_FileDelete($sVaultTemp & "\" & $FileName)
		Return SetError(1,0,0)
	EndIf
EndFunc   ;==>__GetDecryptedLinkTarget


; #FUNCTION# ====================================================================================================================
; Modified version of original _GUICtrlListView_SortItems()-function
; Author ........: Gary Frost (gafrost)
; Modified.......: Micha_he@AutoIt.de (Sort file/folder with col#4)
; ===============================================================================================================================
Func __GUICtrlListView_SortItems($hWnd, $iCol, $__bReSort = False)
	Local $iRet, $iIndex, $pFunction, $hHeader, $iFormat
	Local $bColChanged = False
	If $iCol = -1 Then $iCol = 0
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Local $__iItemCount = _GUICtrlListView_GetItemCount ($hWnd)
	For $x = 1 To $__g_aListViewSortInfo[0][0]
		If $hWnd = $__g_aListViewSortInfo[$x][1] Then
			$iIndex = $x
			ExitLoop
		EndIf
	Next
	If $iCol = 0 Then ; statt nach Spalte 0 wird Spalte 4 (versteckt) sorteiert, welche für Ordner/Dateien ein spezielles Suffix enthält
		$bColChanged = True
		$iCol = 4
	EndIf
	$pFunction = DllCallbackGetPtr($__g_aListViewSortInfo[$iIndex][2]) ; get pointer to call back
	If $__g_aListViewSortInfo[$iIndex][3] <> $iCol Then ; set clicked column if  changed and set direction to ascending
		$__g_aListViewSortInfo[$iIndex][3] = $iCol
		$__g_aListViewSortInfo[$iIndex][5] = 1
	EndIf
	$__g_aListViewSortInfo[$iIndex][7] = 0
	$__g_aListViewSortInfo[$iIndex][4] = $__g_aListViewSortInfo[$iIndex][6]
	If $__bReSort = True And $__iItemCount > 1 Then ; change direction if resort is requested and >=1 items available
		$__g_aListViewSortInfo[$iIndex][5] *= -1
	Else
		If $__bReSort = False And $__iItemCount <= 1 Then $__g_aListViewSortInfo[$iIndex][5] = 1 ; set direction to ascending if a normal sort is requested and there are less or equal than 1 item available
	EndIf
	$iRet = _SendMessage($hWnd, $LVM_SORTITEMSEX, $hWnd, $pFunction, 0, "hwnd", "ptr")
	If $bColChanged = True Then
		$iCol = 0
		$bColChanged = False
	EndIf
	If $iRet <> 0 Then
		If $__g_aListViewSortInfo[$iIndex][9] Then ; Use arrow in header
			$hHeader = $__g_aListViewSortInfo[$iIndex][10]
			For $x = 0 To _GUICtrlHeader_GetItemCount($hHeader) - 1
				$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $x)
				If BitAND($iFormat, $HDF_SORTDOWN) Then
					_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTDOWN))
				ElseIf BitAND($iFormat, $HDF_SORTUP) Then
					_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTUP))
				EndIf
			Next
			$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $iCol)
			If $__g_aListViewSortInfo[$iIndex][5] = 1 Then ; ascending
				_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTUP))
			Else ; descending
				_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTDOWN))
			EndIf
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>__GUICtrlListView_SortItems


; #FUNCTION# ====================================================================================================================
; Author ........: Gary Frost (gafrost)
; Modified.......: mlipok, guinness, gillesg, Micha_he@AutoIt.de
; ===============================================================================================================================
Func __GUICtrlTreeView_Sort($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Local $iItemCount = _GUICtrlTreeView_GetCount($hWnd)
	If $iItemCount Then
		Local $aTreeView[$iItemCount +1], $i = 0
		; get only A child at each level
		Local $hHandle = _GUICtrlTreeView_GetFirstItem($hWnd)
		$aTreeView[1] = $hHandle
		$aTreeView[0] = 2
		__GUICtrlTreeView_SortGetFirstChild($hWnd, $hHandle, $aTreeView)
		ReDim $aTreeView[$aTreeView[0]]
		$aTreeView[0] = 0

		For $i = 0 To UBound($aTreeView) - 1
			_SendMessage($hWnd, $TVM_SORTCHILDREN, 0, $aTreeView[$i], 0, "wparam", "handle") ; Sort the items in root
		Next
	EndIf

EndFunc   ;==>__GUICtrlTreeView_Sort


Func __GetIcon_ShellHandler($__sIconNamePathAndExt, ByRef $__hImageList)
	; Errorcodes:
	;	0	=	Success ! Return icon in specified filepath with ico-extension
	;	1	=	no Extension found
	;	2	=	no valid ImageList-handle
	;	3	=	icon could not get from SystemImageList
	;	4	=	icon could not convert & save to output iconfile
	;	5	=	tempfile could not be created
	If Not StringInStr($__sIconNamePathAndExt, ".") Then Return SetError(1,0,0)
	If Not IsPtr($__hImageList) Then Return SetError(2,0,0)
	Local $__hIcon, $__iRet
	Local $__sExt = StringMid($__sIconNamePathAndExt, StringInStr($__sIconNamePathAndExt, ".", 0, -1))
	Local $__sOutputName = StringReplace($__sIconNamePathAndExt, $__sExt, ".ico")
	If FileWrite($__sIconNamePathAndExt, "") Then
		$__hIcon = _GUIImageList_GetIcon($__hImageList, __GetIconIndex($__sIconNamePathAndExt))
		If $__hIcon <> 0 Then
			$__iRet = _WinAPI_SaveHICONToFile($__sOutputName, _WinAPI_Create32BitHICON($__hIcon, False))
			If Not $__iRet Then Return SetError(4,0,0)
			FileDelete($__sIconNamePathAndExt)
			_WinAPI_DestroyIcon ($__hIcon)
		Else
			FileDelete($__sIconNamePathAndExt)
			Return SetError(3,0,0)
		EndIf
	Else
		Return SetError(5,0,0)
	EndIf
	Return $__sOutputName
EndFunc


Func __GetSystemImageList( $iIconSize )
	Local Static $sIID_IImageList = "{46EB5926-582E-4017-9FDF-E8998DAA0950}"
	Local Static $tRIID_IImageList = _WinAPI_GUIDFromString( $sIID_IImageList )
	Local $aRet = DllCall( "shell32.dll", "uint", "SHGetImageList", "int", $iIconSize, "ptr", DllStructGetPtr( $tRIID_IImageList ), "ptr*", 0 )
	If @error Then Return SetError(@error,@extended,0)
	If $aRet[0] Then Return SetError($aRet[0],0,0)
	Return $aRet[3]
EndFunc


Func __GetIconIndex($sFileName)
	_WinAPI_CoInitialize()
	Local $pPIDL = _WinAPI_ShellILCreateFromPath($sFileName)
	Local $tSHFILEINFO = DllStructCreate($tagSHFILEINFO)
	Local $iFlags = BitOr($SHGFI_PIDL, $SHGFI_SYSICONINDEX)
	__ShellGetFileInfo($pPIDL, $iFlags, 0, $tSHFILEINFO)
	Local $iIcon = DllStructGetData($tSHFILEINFO, "iIcon")
	_WinAPI_CoTaskMemFree( $pPIDL )
	_WinAPI_CoUninitialize()
	Return $iIcon
EndFunc


Func __ShellGetFileInfo($pPIDL, $iFlags, $iAttributes, ByRef $tSHFILEINFO)
	Local $aRet = DllCall('shell32.dll', 'dword_ptr', 'SHGetFileInfoW', 'ptr', $pPIDL, 'dword', $iAttributes, 'struct*', $tSHFILEINFO, 'uint', DllStructGetSize($tSHFILEINFO), 'uint', $iFlags)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aRet[0]
EndFunc


Func __ShowShortInfo()
	_MsgBoxEx(48, $sInfo, Execute($sInfoText), "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1, 0, False)
EndFunc


Func __InitGUIs($bReInit = False) ; GUI & SplashGUI initialisieren oder neu initialisieren
	Local $__aTreePos
	$bInitSort = True
	
	If $bReInit=True Then ; Positionen merken und alte GUI löschen
		If $hMainGui Then
			$aWinPos = WinGetPos($hMainGui)
			$iWinXPos = $aWinPos[0]
			$iWinYPos = $aWinPos[1]
			$iWinWidth = $aWinPos[2]
			$iWinHeight = $aWinPos[3]
			$__aTreePos = ControlGetPos($hMainGui, "", $idTreeView)
			$iTreeWidth = $__aTreePos[2]
			_GUICtrlListView_UnRegisterSortCallBack($idListView)
			GUIDelete($hMainGui)
		EndIf
	EndIf

	__LanguageIni_Read_Data($sSelectedLanguageIni)
	If @Error Then
		__LanguageIni_Read_List($aLanguage)
		__LanguageIni_Read_Data($sSelectedLanguageIni)
	EndIf
		
	
	; Haupt-Oberfläche generieren
	$hMainGui = GUICreate("AKrypto V" & $Version, 780, 370, -1, -1, $WS_SIZEBOX, BitOR($WS_EX_CLIENTEDGE, $WS_EX_ACCEPTFILES))
	__GUI_LanguageMenu_Init()
	$idMainGroup = GUICtrlCreateGroup("", 8, 2, 764, 318, $WS_CLIPSIBLINGS)
	GUICtrlSetResizing($idMainGroup, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
	$idTreeView = GUICtrlCreateTreeView(15, 10, 250, 308, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS, $WS_GROUP, $WS_TABSTOP, $WS_BORDER))
	GUICtrlSetResizing($idTreeView, $GUI_DOCKAUTO)
	$idListView = GUICtrlCreateListView($sListViewHeader, 265, 10, 502, 308, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS, $WS_BORDER))
	GUICtrlSetState($idListView, $GUI_DROPACCEPTED)
	GUICtrlSetResizing($idListView, $GUI_DOCKAUTO)
	_GUICtrlListView_HideColumn ($idListView, 4)
	_GUICtrlListView_RegisterSortCallBack($idListView, 2, True)
	; Position der Haupt-Oberfläche ermitteln, da variabel bei der Ersterstellung
	$aWinPos = WinGetPos($hMainGui)
	; Position & Größe der Taskleiste ermitteln
	$aTrayPos = WinGetPos("[CLASS:Shell_TrayWnd]", "")
	$idLVContextMenu = GUICtrlCreateContextMenu($idListView)
	$idLVGetShortInfo = GUICtrlCreateMenuItem($sPrgShortInfo, $idLVContextMenu)
	GUICtrlCreateMenuItem("", $idLVContextMenu)
	$idLVNewFolder = GUICtrlCreateMenuItem($sNewFolder, $idLVContextMenu)
	$idLVNewFile = GUICtrlCreateMenuItem($sNewFile, $idLVContextMenu)
	$idLVDecryptAll = GUICtrlCreateMenuItem($sDecompressTo, $idLVContextMenu)
	$idLVSelectAll = GUICtrlCreateMenuItem($sMarkAll, $idLVContextMenu)
	$idLVSelectNone = GUICtrlCreateMenuItem($sMarkNone, $idLVContextMenu)
	$idLVItemRename = GUICtrlCreateMenuItem($sRename, $idLVContextMenu)
	$idLVItemDelete = GUICtrlCreateMenuItem($sDelete, $idLVContextMenu)
	GUISetState(@SW_HIDE, $hMainGui) ; notwendig (obwohl aktuell nicht sichtbar) damit WinMove & AutoResize von TV/LV funktionieren
	
	; SplashText-Oberfläche generieren
	If $hSplashGUI Then GUIDelete($hSplashGUI) ; alte SplashGUI bei Bedarf löschen
	$hSplashGUI = GUICreate("", 350, 55, $aWinPos[0] + (($aWinPos[2] - 350) / 2), $aWinPos[1] + (($aWinPos[3] - 25) / 2), $WS_POPUP, Default, $hMainGui)
	GUISetBkColor(0xFFFC70, $hSplashGUI)
	$idSplashLabel = GUICtrlCreateLabel($sActionPerformed, 5, 5, 340, 25, 1)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, 0xFFFC70)
	GUICtrlSetFont(-1, 14, 400, -1, "Comic Sans MS")
	$idSplashLabelAddInfo = GUICtrlCreateLabel("", 5, 30, 340, 20, 1)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, 0xFFFC70)
	GUICtrlSetFont(-1, 8.5, 400, -1, "Comic Sans MS")
	
	; ImageList für TreeView erzeugen
	$hTVImageList = _GUIImageList_Create(16, 16, 5, 2) ;Treeview Icon Image List
	_GUIImageList_AddIcon($hTVImageList, @SystemDir & "\shell32.dll", 3) ;Folder
	_GUIImageList_AddIcon($hTVImageList, @SystemDir & "\shell32.dll", 4) ;Folder Open
	_GUIImageList_AddIcon($hTVImageList, @SystemDir & "\shell32.dll", 181) ;Cdr
	_GUIImageList_AddIcon($hTVImageList, @SystemDir & "\shell32.dll", 8) ;Fixed
	_GUIImageList_AddIcon($hTVImageList, @SystemDir & "\shell32.dll", 7) ;Removable
	_GUIImageList_AddIcon($hTVImageList, @SystemDir & "\shell32.dll", 9) ;Network
	_GUIImageList_AddIcon($hTVImageList, @SystemDir & "\shell32.dll", 11) ;CDRom
	_GUIImageList_AddIcon($hTVImageList, @SystemDir & "\shell32.dll", 109) ;No Symbol for Burner
	_GUICtrlTreeView_SetNormalImageList($idTreeView, $hTVImageList)
	
	GUIRegisterMsg($WM_DROPFILES, '__WM_DROPFILES_FUNC')
	GUIRegisterMsg($WM_NOTIFY, "__WM_NOTIFY")
	GUIRegisterMsg($WM_MOVE, '__WM_Move')
	GUIRegisterMsg($WM_SIZE, '__WM_Move')
	
	; Bei Erstinitialisierung Voreinstellungen versuchen aus INI zu laden
	If $bReInit = False Then
		$iWinXPos = IniRead($sIniFile, "MainGUI", "WinXPos", "")
		$iWinYPos = IniRead($sIniFile, "MainGUI", "WinYPos", "")
		$iWinWidth = IniRead($sIniFile, "MainGUI", "WinWidth", "")
		$iWinHeight = IniRead($sIniFile, "MainGUI", "WinHeight", "")
		$iTreeWidth = IniRead($sIniFile, "MainGUI", "TreeWidth", "")
		$sVaultDir = IniRead($sIniFile, "Options", "VaultDir", @ScriptDir & "\Vault")
		If StringRight($sVaultDir, 1) = "\" Then $sVaultDir = StringLeft($sVaultDir, StringLen($sVaultDir) - 1)
		$sVaultTemp = IniRead($sIniFile, "Options", "VaultTemp", @ScriptDir & "\VaultTemp")
		If StringLeft($sVaultTemp, 1) = "@" Then $sVaultTemp = Execute($sVaultTemp)
		If StringRight($sVaultTemp, 1) = "\" Then $sVaultTemp = StringTrimRight($sVaultTemp, 1)
		$sDecryptTarget = IniRead($sIniFile, "Options", "DecryptTarget", "")
	EndIf
	; Anhand der bisherigen oder der geladenen Daten, das Fenster ggf. neu positionieren
	If $iWinXPos <> "" And $iWinYPos <> "" Then
		If $iWinXPos < 0 Then $iWinXPos = 0
		If $iWinYPos < 0 Then $iWinYPos = 0
		If $iWinWidth < 200 Then $iWinWidth = 200
		If $iWinHeight < 100 Then $iWinHeight = 100
		If $iWinWidth > $aDesktopData[0] Then $iWinWidth = $aDesktopData[0]
		If $iWinHeight > $aDesktopData[1] Then $iWinHeight = $aDesktopData[1]
		$iFreeX = $aDesktopData[0] - $iWinWidth
		$iFreeY = $aDesktopData[1] - $iWinHeight
		If $aTrayPos[1] = 0 And $aTrayPos[2] > 0 Then
			$iFreeX = $aDesktopData[0] - $aTrayPos[2] - $iWinWidth
		EndIf
		If $aTrayPos[0] = 0 And $aTrayPos[3] > 0 Then
			$iFreeY = $aDesktopData[1] - $aTrayPos[3] - $iWinHeight
		EndIf
		If $iWinXPos > ($iFreeX) Then $iWinXPos = $iFreeX
		If $iWinYPos > ($iFreeY) Then $iWinYPos = $iFreeY
		WinMove($hMainGui, "", $iWinXPos, $iWinYPos, $iWinWidth, $iWinHeight)
		GUISetState(@SW_SHOW, $hMainGui)
		$aWinPos = WinGetPos($hMainGui)
		If $iTreeWidth <> "" Then
			If $iTreeWidth < 20 Then $iTreeWidth = 20
			If $iTreeWidth > ($aListPos[0] + $aListPos[2] - 20) Then $iTreeWidth = ($aListPos[0] + $aListPos[2] - 20)
			GUICtrlSetPos($idTreeView, $aTreePos[0], $aTreePos[1], $iTreeWidth)
			GUICtrlSetPos($idListView, $aTreePos[0] + $iTreeWidth, $aListPos[1], $aListPos[2] + $aTreePos[2] - $iTreeWidth)
		EndIf
	Else
		GUISetState(@SW_SHOW, $hMainGui)
	EndIf
	
	; ListView Spaltenbreiten anpassen
	__ColumnResize($idListView)
	
	; Neue Positionsinformationen für das TreeView- & ListView-Element
	; ermitteln, da sich diese nach dem Verschieben oder ändern der Größe
	; verändert haben können (Auto-Resizing der beiden Elemente)
	$aTreePos = ControlGetPos($hMainGui, "", $idTreeView)
	$aListPos = ControlGetPos($hMainGui, "", $idListView)
	
	; Frage nach Passwort beim ersten Start und prüfe dies
	If $sKey = "" Then __CheckPW()
	
	; Lege Unterverzeichnis 'Vault' an, das TreeView mit dem ggf. bereits
	; gefüllten Vault-Ordner füllen, sortieren, anschließend den Wurzel-
	; Ordner auswählen und die erste Ebene erweitern(aufklappen)
	If Not FileExists($sVaultDir) Then DirCreate($sVaultDir)
	$idTreeViewRootItem = _GUICtrlTreeView_AddChild($idTreeView, "", $sVaultDir, 0, 1)
	_GUICtrlTreeView_SelectItem($idTreeView, $idTreeViewRootItem)
	__TreeView_FillFolder($idTreeView)
	__GUICtrlTreeView_Sort($idTreeView)
	__GUICtrlTreeView_ExpandOneLevel($idTreeView)
EndFunc


Func __LanguageIni_Read_List(ByRef $__aLng, $__LngIniPath = "")
	; Liste der vorhandenen Sprach-INI-Dateien für das Sprachen-Menü einlesen
	Local $__hLangIniFind, $__sLngIniFileName, $__sLngName
	If $__LngIniPath = "" Then $__LngIniPath = @ScriptDir & "\Language\"
	If UBound($__aLng) > 0 Then ReDim $__aLng[0]
	$__hLangIniFind = FileFindFirstFile($__LngIniPath & "*.ini")
	If $__hLangIniFind <> -1 Then
		While 1
			$__sLngIniFileName = FileFindNextFile($__hLangIniFind)
			If @error then ExitLoop
			$__sLngName = IniRead($__LngIniPath & $__sLngIniFileName, "AKryptoLanguage", "aLanguage", "")
			If $__sLngName <> "" Then
				ReDim $__aLng[UBound($__aLng) +1][3]
				$__aLng[UBound($__aLng) -1][0] = $__sLngName
				$__aLng[UBound($__aLng) -1][1] = $__sLngIniFileName
			EndIf
		Wend
	EndIf
	FileClose($__hLangIniFind)
	If UBound($__aLng) < 1 Then Return SetError(1,0,0)
	Return SetError(0,0,1)
EndFunc


Func __LanguageIni_Read_Data($__sLngIni = "")
	; Sprachdaten aus INI-Datei einlesen und den Variablen zuweisen
	If $__sLngIni = "" Then Return SetError(1,0,0)
	If Not FileExists($__sLngIni) Then
		$__sLngIni = @ScriptDir & "\Language\" & $__sLngIni
	EndIf
	If Not FileExists($__sLngIni) Then Return SetError(2,0,0)
	$aLangIniData = IniReadSection($__sLngIni, "data")
	If Not IsArray($aLangIniData) Then Return SetError(3,0,0)
	; Eingelesene Sprachdaten den Variablen zuweisen
	For $i = 1 To $aLangIniData[0][0]
		Assign($aLangIniData[$i][0], BinaryToString(StringToBinary($aLangIniData[$i][1]), 1), 2)
	Next
	Return SetError(0,0,1)
EndFunc


Func __GUI_LanguageMenu_Change($__sNewLngIni)
	; Wechsel zu einer anderen aufgeführten Sprache, soweit möglich
	If $__sNewLngIni = "" Then Return SetError(1,0,0)
	__LanguageIni_Read_List($aLanguage)
	If @Error Then
		_MsgBoxEx(49, "Fehler", "Keine gültige Sprachdateien im Unterordner '\Language\' gefunden !" & @CRLF & "(No valid language-file in subfolder '\Language\' found !)")
		Return SetError(2,0,0)
	EndIf
	If _ArraySearch($aLanguage, $__sNewLngIni, 0, 0, 0, 0, 1, 1) >= 0 Then
		$sSelectedLanguageIni = $__sNewLngIni
		__InitGUIs(True)
	Else
		__GUI_LanguageMenu_Init()
	EndIf
	Return SetError(0,0,1)
EndFunc


Func __GUI_LanguageMenu_Init()
	; Sprachmenü der GUI erstellen/erneuern
	If $sMenueLanguage = "" Then Return SetError(1,0,0)
	If $hLanguageMenue Then GUICtrlDelete($hLanguageMenue)
	$hLanguageMenue = GUICtrlCreateMenu("&" & $sMenueLanguage)
	If UBound($aLanguage) <= 0 Then Return SetError(2,0,0)
    For $i = 0 To UBound($aLanguage) -1
    	$aLanguage[$i][2] = GUICtrlCreateMenuItem($aLanguage[$i][0], $hLanguageMenue, -1, 1)
    	If $sSelectedLanguageIni = $aLanguage[$i][1] Then GUICtrlSetState(-1, $GUI_CHECKED)
    Next
    Return SetError(0,0,1)
EndFunc


;==================================================================================================
; Function Name:   _GUICtrlTreeView_ExpandOneLevel($hTreeView [, $hParentItem=0])
; Description::    Ausklappen nur EINER Ebene eines Items, analog zum Mausklick auf '+'
; Parameter(s):    $hTreeView     Handle des TreeView
;                  $hParentItem   Handle des Auszuklappenden Parent-Items
;                                 Standard 0 ==> Handle des ersten Item im TreeView
; Return:          Erfolg         nichts
;                  Fehler         @error 1  -  TreeView enthält kein Item
;                                 @error 2  -  Item hat keine Child-Item
; Note:            Die Funktion sollte zwischen _GUICtrlTreeView_BeginUpdate() und _GUICtrlTreeView_EndUpdate()
;                  ausgeführt werden um ein Flackern zu verhindern
; Author(s):       BugFix (bugfix@autoit.de)   
;==================================================================================================
Func __GUICtrlTreeView_ExpandOneLevel($hTreeView, $hParentItem=0)
    If $hParentItem < 1 Then
        Local $hCurrentItem = _GUICtrlTreeView_GetFirstItem($hTreeView)
    Else
        Local $hCurrentItem = $hParentItem
    EndIf
    If $hCurrentItem = 0 Then Return SetError(1)
    Local $hChild
    Local $countChild = _GUICtrlTreeView_GetChildCount($hTreeView, $hCurrentItem)
    If $countChild = 0 Then Return SetError(2)
    _GUICtrlTreeView_Expand($hTreeView, $hCurrentItem)
    For $i = 1 To $countChild
        If $i = 1 Then 
            $hChild = _GUICtrlTreeView_GetFirstChild($hTreeView, $hCurrentItem)
        Else
            $hChild = _GUICtrlTreeView_GetNextSibling($hTreeView, $hChild)
        EndIf
        If _GUICtrlTreeView_GetChildren($hTreeView, $hChild) Then _GUICtrlTreeView_Expand($hTreeView, $hChild, False)
    Next
EndFunc  ;==>_GUICtrlTreeView_ExpandOneLevel
