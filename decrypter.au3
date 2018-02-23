#pragma compile(ProductName, "AKrypto")
#pragma compile(ProductVersion, 0.512)
#pragma compile(LegalCopyright, © Michael Schröder)
#pragma compile(Icon, .\AKrypto.ico)


#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <TreeViewConstants.au3>
#include <ListViewconstants.au3>
#include <GuiListView.au3>
#include <GUITreeView.au3>
#include <File.au3>
#include <Misc.au3>
#include <String.au3>
#include "_AESFile.au3"
#include "_Blowfish.au3"
#include "_Base64.au3"
#include "_MsgBoxExDe.au3"
#include <Array.au3>

Global $aFileIcons[1] = ["shell32.dll"], $sortdir = 0
Global $aDropFiles[1]
Global $sIniFile = @ScriptDir & "\AKrypto.ini"
Global $sIdent = "*AK*"
Global $sDecryptTarget, $hLVItemRename
Global $aMousePos, $aTreePos, $aListPos, $bSnap = False, $bCursorSwitched = False
Global $sIniFile, $iWinXPos, $iWinYPos, $iWinWidth, $iWinHeight
Global $iFreeX, $iFreeY
Global $hSplashGUI, $aPosChild, $iXDiff, $iYDiff
Global $sVaultTemp, $sVaultDir, $aInVault, $hMainGui, $hMainGroup
Global $hTreeView, $hListView, $hLVContextMenu, $hLVNewFolder
Global $hLVNewFile, $hLVSelectAll, $hLVSelectNone, $hLVItemDelete
Global $tImage, $aWinPos, $aTrayPos, $iTreeWidth, $sKey
Global $iNewTreeWidth, $hLVDecryptAll, $hSplashLabel
Global $aStartedFiles[1][3]
Global $aDesktopData
Global $Version = FileGetVersion(@ScriptFullPath, "ProductVersion")
Global $sDir
If _VersionCompare(@AutoItVersion, "3.3.8.0") = -1 Then Global $WM_DROPFILES = 0x233

$sDir = FileSelectFolder("Wählen","")
If $sDir = "" Then Exit
$sKey = "tresor"
Global $aRet [10000]
Global $i = 0
Local $hSearch = FileFindFirstFile($sDir & "\*.*")
If $hSearch <> -1 Then
    While 1
        $sFileName = FileFindNextFile($hSearch)
        If @error Then ExitLoop
        _AesDecryptFile($sKey, $sDir & "\" & $sFileName, "D:\Test3\" & $sFileName, "CFB")
    WEnd
	FileClose($hSearch)
	Redim $aRet [$i]
EndIf
Exit



Func _ColumnResize(ByRef $hWnd, $type = 0) ;Resize Listview Column routine
	; Local $aWinPos=WinGetPos($hMainGui) unnötig da aktuelle Position im globalen Array vorhanden ist
	_GUICtrlListView_SetColumnWidth($hWnd, 0, $aWinPos[2] * .2375)
	_GUICtrlListView_SetColumnWidth($hWnd, 1, $aWinPos[2] * .12)
	_GUICtrlListView_SetColumnWidth($hWnd, 2, $aWinPos[2] * .1)
	_GUICtrlListView_SetColumnWidth($hWnd, 3, $aWinPos[2] * .16)
EndFunc   ;==>_ColumnResize

Func _FileGetIcon(ByRef $szIconFile, ByRef $nIcon, $szFile) ;Get Icon for Files - Special Thanks to MrCreator - http://www.autoitscript.com/forum/index.ph...st&p=421467
	Local $szRegDefault, $szDefIcon, $szExt, $details, $szRegDefault, $arSplit
	$szExt = StringMid($szFile, StringInStr($szFile, '.', 0, -1))
	If $szExt = '.lnk' Then
		$details = FileGetShortcut($szIconFile)
		$szIconFile = $details[0]
		$szExt = StringMid($details[0], StringInStr($details[0], '.', 0, -1))
	EndIf
	$szRegDefault = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" & $szExt, "ProgID")
	If $szRegDefault = "" Then $szRegDefault = RegRead("HKCR\" & $szExt, "")
	If $szRegDefault <> "" Then $szDefIcon = RegRead("HKCR\" & $szRegDefault & "\DefaultIcon", "")
	If $szDefIcon = "" Then $szRegDefault = RegRead("HKCR\" & $szRegDefault & "\CurVer", "")
	If $szRegDefault <> "" Then $szDefIcon = RegRead("HKCR\" & $szRegDefault & "\DefaultIcon", "")
	If $szDefIcon = "" Then
		$szIconFile = "shell32.dll"
	ElseIf $szDefIcon <> "%1" Then
		$arSplit = StringSplit($szDefIcon, ",")
		If IsArray($arSplit) Then
			$szIconFile = $arSplit[1]
			If $arSplit[0] > 1 Then $nIcon = $arSplit[2]
		Else
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	Return SetError(0, 0, 1)
EndFunc   ;==>_FileGetIcon

Func _FillFolder(ByRef $hWnd) ;Fill Folder in TreeView
	Local $IsExpanded, $item, $txt
	$item = _GUICtrlTreeView_GetSelection($hWnd)
	$IsExpanded = _GUICtrlTreeView_GetExpanded($hWnd, $item)
	If _GUICtrlTreeView_GetChildCount($hWnd, $item) > 0 Then _GUICtrlTreeView_DeleteChildren($hTreeView, $item)
	_GUICtrlTreeView_BeginUpdate($hTreeView)
	$txt = _Encrypt_Name(_TreePath($hWnd, $item))
	_SearchFolder($txt, $item)
	If $IsExpanded Then _GUICtrlTreeView_Expand($hWnd, $item)
	_GUICtrlTreeView_EndUpdate($hTreeView)
EndFunc   ;==>_FillFolder

Func _FolderFunc($folders, $folder, $parent, $level) ;Add Folder to Source TreeView
	Local $parentitem
	If $parent = 0x00000000 Then Return
	For $i = 1 To UBound($folders) - 1
		$parentitem = _GUICtrlTreeView_AddChild($hTreeView, $parent, _Decrypt_Name($folders[$i]), 0, 1)
		_SearchFolder($folder & "\" & $folders[$i], $parentitem, $level + 1)
	Next
EndFunc   ;==>_FolderFunc

Func _FriendlyDate($date) ;Convert Date for Readability
	If Not IsArray($date) Then Return ""
	Local $datetime = ""
	For $i = 0 To 5
		$datetime &= $date[$i]
		If $i < 2 Then $datetime &= "-"
		If $i = 2 Then $datetime &= " "
		If $i > 2 And $i < 5 Then $datetime &= ":"
	Next
	Return $datetime
EndFunc   ;==>_FriendlyDate

Func _GetSelectedItems($hWnd, $list, $tree) ;Get list of Selected Items in Source ListView
	Local $items
	$items = _GUICtrlListView_GetSelectedIndices($list, True)
	For $i = 1 To $items[0]
		$items[$i] = _TreePath($tree, _GUICtrlTreeView_GetSelection($tree)) & "\" & _GUICtrlListView_GetItemText(ControlGetHandle($hWnd, "", $list), $items[$i], 0)
	Next
	Return $items
EndFunc   ;==>_GetSelectedItems

Func _ReduceMemory($i_PID = -1) ;Reduces Memory Usage -- Special thanks to w0uter and jftuga
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func _SearchFolder($folder, $parent, $level = 0) ;Recursive Folder Search for Source Treeview/Listview
	Local $folders
	If $level >= 1 Then Return
	$folders = _FileListToArray($folder, "*", 2)
	_FolderFunc($folders, $folder, $parent, $level)
EndFunc   ;==>_SearchFolder

Func _ShowFolder(ByRef $tree, ByRef $list, ByRef $hWnd, $sort = 0) ;Show folder in Source Folder
	Local $arrCurrentFolder[1][4]
	Local $item, $path, $filefolder, $size, $idx, $nIcon, $szIconFile, $strExtension, $found, $icon
	$item = _GUICtrlTreeView_GetSelection($tree)
	If $item = 0x000000 Then Return 0
	_GUICtrlListView_BeginUpdate($list)
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($list))
	$path = _Encrypt_Name(_TreePath($tree, $item))
	For $type = 1 To 2
		Local $Sch
		If $type = 1 Then $Sch = _FileListToArray($path, "*", 2)
		If $type = 2 Then $Sch = _FileListToArray($path, "*", 1)
		If UBound($Sch) > 0 Then
			For $i = 1 To $Sch[0]
				ReDim $arrCurrentFolder[UBound($arrCurrentFolder) + 1][4]
				If $type = 1 Then
					$filefolder = "Ordner"
					$size = " "
				Else
					$filefolder = StringUpper(StringRight($Sch[$i], StringLen($Sch[$i]) - StringInStr($Sch[$i], ".", 0, -1))) & "-Datei"
					$size = FileGetSize($path & "\" & $Sch[$i])
				EndIf
				$arrCurrentFolder[UBound($arrCurrentFolder) - 1][0] = $Sch[$i]
				$arrCurrentFolder[UBound($arrCurrentFolder) - 1][1] = $filefolder
				$arrCurrentFolder[UBound($arrCurrentFolder) - 1][2] = $size
				$arrCurrentFolder[UBound($arrCurrentFolder) - 1][3] = _FriendlyDate(FileGetTime($path & "\" & $Sch[$i]))
			Next
			If $type = 1 And $sort <> 3 Then
				_ArraySort($arrCurrentFolder, $sortdir, 0, 0, 0)
			Else
				_ArraySort($arrCurrentFolder, $sortdir, 0, 0, $sort)
			EndIf
			If $type = 1 Then
				For $x = 0 To UBound($arrCurrentFolder) - 1
					If $arrCurrentFolder[$x][0] Then
						$idx = GUICtrlCreateListViewItem(_Decrypt_Name($arrCurrentFolder[$x][0]) & "|" & $arrCurrentFolder[$x][1] & "|" & $arrCurrentFolder[$x][2] & "|" & $arrCurrentFolder[$x][3], $list)
						GUICtrlSetImage($idx, $aFileIcons[0], -4)
					EndIf
				Next
				$arrCurrentFolder = 0
				Dim $arrCurrentFolder[1][4]
			EndIf
			If $type = 2 Then
				For $x = 0 To UBound($arrCurrentFolder) - 1
					If $arrCurrentFolder[$x][0] Then
						$idx = GUICtrlCreateListViewItem(_Decrypt_Name($arrCurrentFolder[$x][0]) & "|" & $arrCurrentFolder[$x][1] & "|" & $arrCurrentFolder[$x][2] & "|" & $arrCurrentFolder[$x][3], $list)
						If StringRight($arrCurrentFolder[$x][0], 4) = ".exe" Then
							$found = _ArraySearch($aFileIcons, $arrCurrentFolder[$x][0], 0, 0, 0, 1)
							If $found <> -1 Then
								GUICtrlSetImage($idx, $aFileIcons[$found], 0)
							Else
								If GUICtrlSetImage($idx, $path & "\" & $arrCurrentFolder[$x][0], 0) = 0 Then
									GUICtrlSetImage($idx, $aFileIcons[0], -3)
								Else
									ReDim $aFileIcons[UBound($aFileIcons) + 1]
									$aFileIcons[UBound($aFileIcons) - 1] = $path & "\" & $arrCurrentFolder[$x][0]
									GUICtrlSetImage($idx, $aFileIcons[UBound($aFileIcons) - 1], 0)
								EndIf
							EndIf
						ElseIf StringRight($arrCurrentFolder[$x][0], 3) = "htm" Or StringRight($arrCurrentFolder[$x][0], 3) = "html" Then
							GUICtrlSetImage($idx, $aFileIcons[0], -221)
						Else
							$strExtension = StringTrimLeft($arrCurrentFolder[$x][0], StringInStr($arrCurrentFolder[$x][0], ".", 0, -1) - 1)
							If Not StringInStr($strExtension, ".lnk", 0, 0, 0, 1) Then
								$found = _ArraySearch($aFileIcons, $arrCurrentFolder[$x][0], 0, 0, 0, 1)
							Else
								$found = _ArraySearch($aFileIcons, $strExtension, 0, 0, 0, 1)
							EndIf
							If $found <> -1 Then
								$icon = StringTrimLeft($aFileIcons[$found], StringInStr($aFileIcons[$found], "|", 0, -2))
								$icon = StringLeft($icon, StringInStr($icon, "|") - 1)
								$nIcon = StringRight($aFileIcons[$found], StringLen($aFileIcons[$found]) - StringInStr($aFileIcons[$found], "|", 0, -1))
								GUICtrlSetImage($idx, $icon, $nIcon)
							Else
								Local $szIconFile = $path & "\" & $arrCurrentFolder[$x][0], $nIcon = 0
								_FileGetIcon($szIconFile, $nIcon, $arrCurrentFolder[$x][0])
								If $nIcon <> 0 Then $nIcon = -$nIcon
								ReDim $aFileIcons[UBound($aFileIcons) + 1]
								$aFileIcons[UBound($aFileIcons) - 1] = $path & "\" & $arrCurrentFolder[$x][0] & "|" & StringReplace($szIconFile, Chr(34), "") & "|" & StringReplace($nIcon, Chr(34), "")
								GUICtrlSetImage($idx, $szIconFile, $nIcon)
							EndIf
						EndIf
					EndIf
				Next
			EndIf
		EndIf
	Next
	$Sch = 0
	$nIcon = 0
	$szIconFile = 0
	$arrCurrentFolder = 0
	_GUICtrlListView_ReSortItems($list, GUICtrlGetState($list))
	_GUICtrlListView_EndUpdate($list)
	_ReduceMemory()
EndFunc   ;==>_ShowFolder

Func _TreePath($hWnd, $item) ;Determine full path of selected item in TreeView
	Local $txt, $parent
	$txt = _GUICtrlTreeView_GetText($hWnd, $item)
	Do
		$parent = _GUICtrlTreeView_GetParentHandle($hWnd, $item)
		If $parent <> 0 Then
			$txt = _GUICtrlTreeView_GetText($hWnd, $parent) & "\" & $txt
			$item = $parent
		EndIf
	Until $parent = 0
	Return $txt
EndFunc   ;==>_TreePath

Func _ExitApp()
	_GUICtrlListView_UnRegisterSortCallBack($hListView)
	If FileExists($sVaultTemp) Then DirRemove($sVaultTemp, 1)
	;Local $aWinPos = WinGetPos($hMainGui) unnötig da aktuelle Position im globalen Array vorhanden ist
	Local $aTreePos = ControlGetPos($hMainGui, "", $hTreeView)
	; Fensterposition speichern, wenn nicht minimiert (= -32000)
	If $aWinPos[0] <> -32000 Then IniWrite($sIniFile, "MainGUI", "WinXPos", $aWinPos[0])
	If $aWinPos[1] <> -32000 Then IniWrite($sIniFile, "MainGUI", "WinYPos", $aWinPos[1])
	If $aWinPos[1] <> -32000 Then IniWrite($sIniFile, "MainGUI", "WinWidth", $aWinPos[2])
	If $aWinPos[1] <> -32000 Then IniWrite($sIniFile, "MainGUI", "WinHeight", $aWinPos[3])
	If $aTreePos[2] >= 20 Then IniWrite($sIniFile, "MainGUI", "TreeWidth", $aTreePos[2])
	If $sDecryptTarget <> "" Then IniWrite($sIniFile, "Options", "DecryptTarget", $sDecryptTarget)
	Exit
EndFunc   ;==>_ExitApp

Func _AddNewObjects() ; Add new Objects to Treeview/Listview with Drag 'n Drop
	Local $SrcName
	_SplashGUI_SetState(@SW_SHOW, "Objekte werden verschlüsselt...")
	For $i = 0 To UBound($aDropFiles) - 1
		If StringInStr(FileGetAttrib($aDropFiles[$i]), "D") Then
			If _DirCopy_Crypt_Recursiv($aDropFiles[$i], _TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & StringMid($aDropFiles[$i], StringInStr($aDropFiles[$i], "\", 0, -1) + 1)) = 0 And $i < UBound($aDropFiles) - 1 Then
				If _MsgBoxEx(52, "Fehler", "Der Ordner '" & $aDropFiles[$i] & "' konnte nicht fehlerfrei kopiert werden. Fortfahren ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
			EndIf
		Else
			If _FileCopy_Crypt($aDropFiles[$i], _TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & StringMid($aDropFiles[$i], StringInStr($aDropFiles[$i], "\", 0, -1) + 1)) = 0 Then
				If _MsgBoxEx(52, "Fehler", "Die Datei '" & $aDropFiles[$i] & "' konnte nicht fehlerfrei kopiert werden. Fortfahren ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
			EndIf
		EndIf
	Next
	_FillFolder($hTreeView)
	_ShowFolder($hTreeView, $hListView, $hMainGui)
	_SplashGUI_SetState(@SW_HIDE)
EndFunc   ;==>_AddNewObjects

Func _RenameObjects()
	Local $aSelItems, $sNewName, $bRescan = False
	Local $iInputWidth = 250
	Local $iInputHeight = 190
	$aSelItems = _GUICtrlListView_GetSelectedIndices($hListView, True)
	If $aSelItems[0] > 0 Then
		For $i = 1 To $aSelItems[0]
			$sNewName = _GUICtrlListView_GetItemText($hListView, $aSelItems[$i])
			If StringInStr(FileGetAttrib(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]))), "D") Then
				; Umbenennen von Ordnern
				Do
					$sNewName = InputBox("Neuer Name", "Bitte geben sie einen neuen Namen für den Ordner '" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) & "' ein :", $sNewName, "", $iInputWidth, $iInputHeight, ($aWinPos[0] + ($aWinPos[2] / 2)) - ($iInputWidth / 2), ($aWinPos[1] + ($aWinPos[3] / 2)) - ($iInputHeight / 2))
					If @error = 1 Then ExitLoop 2
					If $sNewName <> "" And $sNewName <> _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) Then
						If FileExists(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & $sNewName)) Then
							If _MsgBoxEx(52, "Fehler", "Der Ordner '" & $sNewName & "' existiert bereits ! Soll er überschrieben werden ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
								If DirRemove(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & $sNewName), 1) = 0 Then
									If _MsgBoxEx(52, "Fehler", "Der Ordner '" & $sNewName & "' konnte nicht überschrieben werden. Fortfahren ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then
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
				Until $sNewName = _GUICtrlListView_GetItemText($hListView, $aSelItems[$i])
				If $sNewName <> _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) Then
					If DirMove(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i])), _Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & $sNewName)) = 0 Then
						If _MsgBoxEx(52, "Fehler", "Der Ordner '" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) & "' konnte nicht umbenannt werden. Fortfahren ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
					Else
						$bRescan = True
					EndIf
				EndIf
			Else
				; Umbenennen von Dateien
				Do
					$sNewName = InputBox("Neuer Name", "Bitte geben sie einen neuen Namen für die Datei '" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) & "' ein :", $sNewName, "", $iInputWidth, $iInputHeight, ($aWinPos[0] + ($aWinPos[2] / 2)) - ($iInputWidth / 2), ($aWinPos[1] + ($aWinPos[3] / 2)) - ($iInputHeight / 2))
					If @error = 1 Then ExitLoop 2
					If $sNewName <> "" And $sNewName <> _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) Then
						If FileExists(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & $sNewName)) Then
							If _MsgBoxEx(52, "Fehler", "Die Datei '" & $sNewName & "' existiert bereits ! Soll sie überschrieben werden ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
								If FileDelete(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & $sNewName)) = 0 Then
									If _MsgBoxEx(52, "Fehler", "Die Datei '" & $sNewName & "' konnte nicht überschrieben werden. Fortfahren ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then
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
				Until $sNewName = _GUICtrlListView_GetItemText($hListView, $aSelItems[$i])
				If $sNewName <> _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) Then
					If FileMove(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i])), _Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & $sNewName)) = 0 Then
						If _MsgBoxEx(52, "Fehler", "Die Datei '" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) & "' konnte nicht umbenannt werden. Fortfahren ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
					Else
						$bRescan = True
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	If $bRescan = True Then
		_FillFolder($hTreeView)
		_ShowFolder($hTreeView, $hListView, $hMainGui)
	EndIf
EndFunc   ;==>_RenameObjects

Func _DelObjects() ; Delete selected Objects in Listview
	Local $aSelItems
	$aSelItems = _GUICtrlListView_GetSelectedIndices($hListView, True)
	If $aSelItems[0] > 0 And _MsgBoxEx(52, "Nachfrage", "Sollen die markierten Dateien/Ordner wirklich gelöscht werden ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
		_SplashGUI_SetState(@SW_SHOW, "Objekte werden gelöscht...")
		For $i = 1 To $aSelItems[0]
			If StringInStr(FileGetAttrib(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]))), "D") Then
				If DirRemove(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i])), 1) = 0 Then
					If _MsgBoxEx(52, "Fehler", "Der Ordner '" & _TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) & "' konnte nicht gelöscht werden. Fortfahren ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
				EndIf
				_GUICtrlTreeView_Delete($hTreeView, _GUICtrlTreeView_FindItem($hTreeView, _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]), False, _GUICtrlTreeView_GetSelection($hTreeView)))
			Else
				If FileDelete(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]))) = 0 Then
					If _MsgBoxEx(52, "Fehler", "Die Datei '" & _TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) & "' konnte nicht gelöscht werden. Fortfahren ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
				EndIf
			EndIf
		Next
	EndIf
	_FillFolder($hTreeView)
	_ShowFolder($hTreeView, $hListView, $hMainGui)
	_SplashGUI_SetState(@SW_HIDE)
EndFunc   ;==>_DelObjects

Func _AddNewFolder() ; Add new Folder to Treeview/Listview with Contextmenue
	Local $FolderName, $FolderNameC
	$FolderName = InputBox("Ordnername ?", " ", "Neuer Ordner")
	If $FolderName <> "" Then
		_SplashGUI_SetState(@SW_SHOW, "Ordner wird verschlüsselt...")
		$FolderNameC = _Encrypt_Name($FolderName)
		If FileExists(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView))) & "\" & $FolderNameC) Then
			_SplashGUI_SetState(@SW_HIDE)
			_MsgBoxEx(49, "Fehler", "Der Ordner '" & $FolderName & "' existiert bereits !", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
			Return SetError(1, 0, 0)
		EndIf
		If DirCreate(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView))) & "\" & $FolderNameC) = 0 Then
			_SplashGUI_SetState(@SW_HIDE)
			_MsgBoxEx(49, "Fehler", "Der Ordner '" & $FolderName & "' konnte nicht erzeugt werden !", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
			Return SetError(1, 0, 0)
		Else
			_SplashGUI_SetState(@SW_HIDE)
			_FillFolder($hTreeView)
			_ShowFolder($hTreeView, $hListView, $hMainGui)
			Return SetError(0, 0, 1)
		EndIf
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_AddNewFolder


Func _AddNewFile() ; Add new File to Listview with Contextmenue
	Local $FileName
	$FileName = InputBox("Dateiname ?", " ", "Neu.txt")
	If $FileName <> "" Then
		If FileExists(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & $FileName)) Then
			_SplashGUI_SetState(@SW_HIDE)
			_MsgBoxEx(48, "Fehler", "Die Datei '" & $FileName & "' existiert bereits !", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
			Return SetError(1, 0, 0)
		EndIf
		_SplashGUI_SetState(@SW_SHOW, "Datei wird verschlüsselt...")
		If FileWrite(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & $FileName), "") = 0 Then
			_SplashGUI_SetState(@SW_HIDE)
			_MsgBoxEx(48, "Fehler", "Die Datei '" & $FileName & "' konnte nicht angelegt werden !", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
		Else
			_SplashGUI_SetState(@SW_HIDE)
			_FillFolder($hTreeView)
			_ShowFolder($hTreeView, $hListView, $hMainGui)
			Return SetError(0, 0, 1)
		EndIf
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_AddNewFile


Func _DirCopy_Crypt_Recursiv($sSource, $sDestination, $bOverwrite = False)
	Local $hSearch, $sObject, $Ret, $sDestinationC
	If StringRight($sDestination, 1) <> "\" Then $sDestination &= "\"
	If StringRight($sSource, 1) <> "\" Then $sSource &= "\"
	$sDestinationC = _Encrypt_Name($sDestination)
	If Not FileExists($sDestinationC) Then $Ret = DirCreate($sDestinationC)
	If $Ret = 0 Then _MsgBoxEx(0, "Fehler", "Fehler beim Erzeugen vom Ordner: " & $sDestinationC, "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
	$hSearch = FileFindFirstFile($sSource & "*.*")
	While 1
		$sObject = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If $sObject = "." Or $sObject = ".." Then ContinueLoop
		If StringInStr(FileGetAttrib($sSource & $sObject), "D") > 0 Then
			$Ret = _DirCopy_Crypt_Recursiv($sSource & $sObject, $sDestination & $sObject, $bOverwrite)
			If $Ret = 0 Then
				_MsgBoxEx(0, "Fehler", $sSource & $sObject, "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
				Return SetError(1, 0, 0)
			EndIf
		Else
			$Ret = _FileCopy_Crypt($sSource & $sObject, $sDestination & $sObject, $bOverwrite)
			If $Ret = 0 Then
				_MsgBoxEx(0, "Fehler", $sSource & $sObject, "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
				Return SetError(1, 0, 0)
			EndIf
		EndIf
	WEnd
	FileClose($hSearch)
	Return SetError(0, 0, 1)
EndFunc   ;==>_DirCopy_Crypt_Recursiv

Func _FileCopy_Crypt($sSource, $sDestination, $bOverwrite = False)
	Local $Ret, $sDestinationC
	If $sSource = "" Or $sDestination = "" Then Return SetError(1, 0, 0)
	$sDestinationC = _Encrypt_Name($sDestination)
	Select
		Case FileExists($sDestinationC) = True And $bOverwrite = False
			If _MsgBoxEx(36, "Überschreiben ?", "Die Datei '" & $sDestination & "' existiert bereits. Soll sie überschrieben werden ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
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
	If $Ret = 0 Then Return SetError(1, 0, 0)
	Return SetError(0, 0, 1)
EndFunc   ;==>_FileCopy_Crypt

Func _DecryptExecute($object)
	Local $posBS, $FileName, $objectC, $Ret, $iPID
	_SplashGUI_SetState(@SW_SHOW, "Datei wird entschlüsselt...")
	If Not FileExists($sVaultTemp) Then DirCreate($sVaultTemp)
	$posBS = StringInStr($object, "\", 0, -1)
	If $posBS > 0 Then
		$FileName = StringMid($object, $posBS + 1)
	Else
		$FileName = $object
	EndIf
	$objectC = _Encrypt_Name($object)
	If FileGetSize($objectC) > 0 Then
		$Ret = _AesDecryptFile($sKey, $objectC, $sVaultTemp & "\" & $FileName, "CFB")
	Else
		$Ret = FileCopy($objectC, $sVaultTemp & "\" & $FileName, 1)
	EndIf
	If $Ret Then
		FileSetAttrib($sVaultTemp & "\" & $FileName, "-A")
		$iPID = _StartFile2($sVaultTemp & "\" & $FileName)
		If $iPID > 0 Then
			ReDim $aStartedFiles[$aStartedFiles[0][0] + 2][3]
			$aStartedFiles[0][0] += 1
			$aStartedFiles[$aStartedFiles[0][0]][0] = $iPID
			$aStartedFiles[$aStartedFiles[0][0]][1] = $sVaultTemp & "\" & $FileName
			$aStartedFiles[$aStartedFiles[0][0]][2] = $object
		EndIf
	Else
		_MsgBoxEx(48, "Fehler", "Die Datei '" & $FileName & "' konnte nicht entschlüsselt werden !", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1)
	EndIf
	_SplashGUI_SetState(@SW_HIDE)
EndFunc   ;==>_DecryptExecute

Func _CheckPW()
	Local $bCheck = False
	Local $aInVault = DirGetSize($sVaultDir, 1)
	Local $search, $object, $sSecondPW
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
				$sKey = InputBox("Passwort ?", "Bitte geben Sie das Passwort ein:", "", "*", -1, -1, $aWinPos[0] + ($aWinPos[2] - 250) / 2, $aWinPos[1] + ($aWinPos[3] - 190) / 2)
			Until $sKey <> "" Or _MsgBoxEx(53, "Fehler", "Ohne ein Passwort kann nicht verschlüsselt werden !", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 2
		EndIf
		If $sKey = "" Then _ExitApp()
		
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
			$sSecondPW = InputBox("Prüfung ?", "Bitte geben Sie das Passwort zur Überprüfung ein zweites mal ein:", "", "*", -1, -1, $aWinPos[0] + ($aWinPos[2] - 250) / 2, $aWinPos[1] + ($aWinPos[3] - 190) / 2)
			
		EndIf
		
	Until $bCheck = True Or $sSecondPW = $sKey Or _MsgBoxEx(53, "Passwortfehler", "Eingegebene Passwörter sind nicht korrekt ! Wiederholen ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 2
	If $bCheck = False And $sSecondPW <> $sKey Then _ExitApp()
EndFunc   ;==>_CheckPW

Func _Encrypt_Name($sName)
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
EndFunc   ;==>_Encrypt_Name

Func _Decrypt_Name($sName)
	Local $Ret, $sOut, $iPoiPos, $iLenIdent = StringLen($sIdent)
	Local $sTrailing, $aPathSplits
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
EndFunc   ;==>_Decrypt_Name

Func _DecryptAll() ; Decrypt all selected Objects in Listview
	Local $aSelItems, $bErrorDetect = False
	$aSelItems = _GUICtrlListView_GetSelectedIndices($hListView, True)
	If $aSelItems[0] > 0 Then
		$sDecryptTarget = FileSelectFolder("Bitte Zielordner wählen", "", 7, $sDecryptTarget)
		If $sDecryptTarget = "" Then Return SetError(1, 0, 0)
		If StringRight($sDecryptTarget, 1) <> "\" Then $sDecryptTarget &= "\"
		_SplashGUI_SetState(@SW_SHOW, "Objekte werden entschlüsselt...")
		For $i = 1 To $aSelItems[0]
			If StringInStr(FileGetAttrib(_Encrypt_Name(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]))), "D") Then
				If FileExists($sDecryptTarget & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i])) Then
					If _MsgBoxEx(36, "Ziel nutzen ?", "Die Zielordner '" & $sDecryptTarget & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) & "' existiert bereits. Soll er für den Entschlüsselungsvorgang genutzt werden ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then
						$bErrorDetect = True
						ExitLoop
					EndIf
				EndIf
				If _DecryptFolder_Recursiv(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]), $sDecryptTarget & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i])) = 0 Then
					$bErrorDetect = True
					If _MsgBoxEx(52, "Fehler", "Der Ordner '" & _TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) & "' konnte nicht entschlüsselt werden. Fortfahren ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
				EndIf
			Else
				If _DecryptFile(_TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]), $sDecryptTarget) = 0 Then
					$bErrorDetect = True
					If _MsgBoxEx(52, "Fehler", "Die Datei '" & _TreePath($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & "\" & _GUICtrlListView_GetItemText($hListView, $aSelItems[$i]) & "' konnte nicht entschlüsselt werden. Fortfahren ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 7 Then ExitLoop
				EndIf
			EndIf
		Next
	EndIf
	If $bErrorDetect = False Then
		_SplashGUI_SetState(@SW_SHOW, "Entschlüsselung erfolgreich beendet !")
	Else
		_SplashGUI_SetState(@SW_SHOW, "Entschlüsselung mit Fehlern beendet !")
	EndIf
	Sleep(2000)
	_SplashGUI_SetState(@SW_HIDE)
EndFunc   ;==>_DecryptAll

Func _DecryptFile($sSource, $sDestination, $bOverwrite = False)
	Local $Ret, $sSourceC, $iPosBS, $sFilename
	If $sSource = "" Or $sDestination = "" Then Return SetError(1, 0, 0)
	$iPosBS = StringInStr($sSource, "\", 0, -1)
	If $iPosBS > 0 Then
		$sFileName = StringMid($sSource, $iPosBS + 1)
	Else
		$sFileName = $sSource
	EndIf
	$sSourceC = _Encrypt_Name($sSource)
	Select
		Case FileExists($sDestination & "\" & $sFileName) = True And $bOverwrite = False
			If _MsgBoxEx(36, "Überschreiben ?", "Die Datei '" & $sDestination & "\" & $sFileName & "' existiert bereits. Soll sie überschrieben werden ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
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
EndFunc   ;==>_DecryptFile

Func _DecryptFolder_Recursiv($sSource, $sDestination, $bOverwrite = False)
	Local $hSearch, $sObject, $sObjectC, $Ret, $sSourceC
	If StringRight($sDestination, 1) <> "\" Then $sDestination &= "\"
	If StringRight($sSource, 1) <> "\" Then $sSource &= "\"
	If Not FileExists($sDestination) Then
		DirCreate($sDestination)
		Sleep(100)
	EndIf
	$sSourceC = _Encrypt_Name($sSource)
	$hSearch = FileFindFirstFile($sSourceC & "*.*")
	While 1
		$sObjectC = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If $sObjectC = "." Or $sObjectC = ".." Then ContinueLoop
		$sObject = _Decrypt_Name($sObjectC)
		If StringInStr(FileGetAttrib($sSourceC & $sObjectC), "D") > 0 Then
			$Ret = _DecryptFolder_Recursiv($sSource & $sObject, $sDestination & $sObject, $bOverwrite)
			If $Ret = 0 Then Return SetError(1, 0, 0)
		Else
			$Ret = _DecryptFile($sSource & $sObject, $sDestination, $bOverwrite)
		EndIf
	WEnd
	FileClose($hSearch)
	Return SetError(0, 0, 1)
EndFunc   ;==>_DecryptFolder_Recursiv

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam) ;Notify func
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR
	Local $srctree, $srclist, $item, $filefolder
	Local $idx, $found
	$srctree = ControlGetHandle($hwnd, "", $hTreeView)
	$srclist = ControlGetHandle($hwnd, "", $hListView)
	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	If $iCode = -12 Or $iCode = -17 Then Return False
	Switch $hWndFrom
		Case $srclist
			$item = _GetSelectedItems($hMainGui, $hListView, $hTreeView)
			Switch $iCode
				Case $NM_DBLCLK
					If $item[0] <> 0 Then
						$filefolder = _GUICtrlListView_GetSelectedIndices($hListView, True)
						If _GUICtrlListView_GetItemText($hListView, $filefolder[1], 1) = "Ordner" Or _GUICtrlListView_GetItemText($hListView, $filefolder[1], 1) = "Folder" Then
							$idx = _GUICtrlTreeView_GetSelection($hTreeView)
							$item = StringTrimLeft($item[1], StringInStr($item[1], "\", 0, -1))
							$found = _GUICtrlTreeView_FindItem($hTreeView, $item, False, $idx)
							_GUICtrlTreeView_SelectItem($hTreeView, $found)
							_FillFolder($hTreeView)
							_ShowFolder($hTreeView, $hListView, $hMainGui)
						Else
							_DecryptExecute($item[1])
						EndIf
					EndIf
					Return True
			EndSwitch
		Case $srctree
			Switch $iCode
				Case $NM_RCLICK
					Local $tPOINT = _WinAPI_GetMousePos(True, $srctree)
					Local $iX = DllStructGetData($tPOINT, "X")
					Local $iY = DllStructGetData($tPOINT, "Y")
					Local $hItem = _GUICtrlTreeView_HitTestItem($srctree, $iX, $iY)
					If $hItem <> 0 Then _GUICtrlTreeView_SelectItem($srctree, $hItem, $TVGN_CARET)
				Case -451
					_FillFolder($hTreeView)
					_ShowFolder($hTreeView, $hListView, $hMainGui)
					Return True
			EndSwitch

		Case Else
			Switch $iCode
				Case $NM_CLICK ; The user has clicked the left mouse button within the control
					_SendMessage($hMainGui, $WM_SYSCOMMAND, 0xF012, 2, 1)
			EndSwitch
	EndSwitch
EndFunc   ;==>WM_NOTIFY

Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
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
EndFunc   ;==>WM_DROPFILES_FUNC

Func WM_Move()
	$aWinPos = WinGetPos($hMainGui)
	WinMove($hSplashGUI, '', $aWinPos[0] + $iXDiff, $aWinPos[1] + $iYDiff)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_Move

Func _CheckStartedFiles()
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
				If _MsgBoxEx(36, "Zurückschreiben ?", "Die Datei '" & $sFileName & "' wurde verändert ! Soll sie neu verschlüsselt werden ?", "", "", ($aWinPos[0] + ($aWinPos[2] / 2)) * -1, ($aWinPos[1] + ($aWinPos[3] / 2)) * -1) = 6 Then
					_SplashGUI_SetState(@SW_SHOW, "Datei wird aktualisiert...")
					_FileCopy_Crypt($aStartedFiles[$i][1], $aStartedFiles[$i][2], True)
					Sleep(100)
					_SplashGUI_SetState(@SW_HIDE)
					_ShowFolder($hTreeView, $hListView, $hMainGui)
				EndIf
			EndIf
			_Secure_FileDelete($aStartedFiles[$i][1])
			_ArrayDelete($aStartedFiles, $i)
			$aStartedFiles[0][0] -= 1
		Else
			$i += 1
		EndIf
	WEnd
EndFunc   ;==>_CheckStartedFiles


Func _GUICtrlListView_ReSortItems($hWnd, $iCol)
	Local $iRet, $iIndex, $pFunction, $hHeader, $iFormat
	Local $SortOld
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If $iCol = -1 Then $iCol = 0
	
	For $x = 1 To $aListViewSortInfo[0][0]
		If $hWnd = $aListViewSortInfo[$x][1] Then
			$iIndex = $x
			ExitLoop
		EndIf
	Next

	$pFunction = DllCallbackGetPtr($aListViewSortInfo[$iIndex][2]) ; get pointer to call back
	$aListViewSortInfo[$iIndex][3] = $iCol ; $nColumn = column clicked
	$aListViewSortInfo[$iIndex][7] = 0 ; $bSet
	$aListViewSortInfo[$iIndex][4] = $aListViewSortInfo[$iIndex][6] ; nCurCol = $nCol
	$SortOld = $aListViewSortInfo[$iIndex][5]
	$iRet = _SendMessage($hWnd, $LVM_SORTITEMS, $hWnd, $pFunction, 0, "hwnd", "ptr")
	If $iRet <> 0 Then
		If $aListViewSortInfo[$iIndex][9] Then ; Use arrow in header
			$hHeader = $aListViewSortInfo[$iIndex][10]
			For $x = 0 To _GUICtrlHeader_GetItemCount($hHeader) - 1
				$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $x)
				If BitAND($iFormat, $HDF_SORTDOWN) Then
					_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTDOWN))
				ElseIf BitAND($iFormat, $HDF_SORTUP) Then
					_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTUP))
				EndIf
			Next
			$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $iCol)
			If $aListViewSortInfo[$iIndex][5] = 1 Then ; ascending
				_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTUP))
			Else ; descending
				_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTDOWN))
			EndIf
		EndIf
	EndIf
	If $SortOld <> $aListViewSortInfo[$iIndex][5] Then
		$aListViewSortInfo[$iIndex][3] = $iCol ; $nColumn = column clicked
		$aListViewSortInfo[$iIndex][7] = 0 ; $bSet
		$aListViewSortInfo[$iIndex][4] = $aListViewSortInfo[$iIndex][6] ; nCurCol = $nCol
		$iRet = _SendMessage($hWnd, $LVM_SORTITEMS, $hWnd, $pFunction, 0, "hwnd", "ptr")
		If $iRet <> 0 Then
			If $aListViewSortInfo[$iIndex][9] Then ; Use arrow in header
				$hHeader = $aListViewSortInfo[$iIndex][10]
				For $x = 0 To _GUICtrlHeader_GetItemCount($hHeader) - 1
					$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $x)
					If BitAND($iFormat, $HDF_SORTDOWN) Then
						_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTDOWN))
					ElseIf BitAND($iFormat, $HDF_SORTUP) Then
						_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTUP))
					EndIf
				Next
				$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $iCol)
				If $aListViewSortInfo[$iIndex][5] = 1 Then ; ascending
					_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTUP))
				Else ; descending
					_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTDOWN))
				EndIf
			EndIf
		EndIf
	EndIf
	$SortOld = ""
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_ReSortItems


Func _SplashGUI_SetState($State = @SW_SHOW, $sText = "")
	If $State = @SW_SHOW Then
		If $sText <> "" Then GUICtrlSetData($hSplashLabel, $sText)
	Else
		GUICtrlSetData($hSplashLabel, "Aktion wird durchgeführt...")
	EndIf
	GUISetState($State, $hSplashGUI)
	Sleep(100)
EndFunc   ;==>_SplashGUI_SetState


Func _GetTotalScreenResolution()
	Local $aRet[2], $VirtualDesktopWidth, $VirtualDesktopHeight
	Global Const $SM_VIRTUALWIDTH = 78
	Global Const $SM_VIRTUALHEIGHT = 79
	$VirtualDesktopWidth = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALWIDTH)
	$aRet[0] = $VirtualDesktopWidth[0]
	$VirtualDesktopHeight = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALHEIGHT)
	$aRet[1] = $VirtualDesktopHeight[0]
	Return $aRet
EndFunc   ;==>_GetTotalScreenResolution


Func _Secure_FileDelete($sFile)
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
EndFunc   ;==>_Secure_FileDelete


; #FUNCTION# ======================================================================================
; Name ..........: _StartFile2()
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
Func _StartFile2($sFilePath, Const $sParams = '', Const $WorkDir = @WorkingDir, Const $sVerb = "open", Const $show_Flag = @SW_SHOW, Const $opt_flag = 0)
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
	; die Platzhalter werden möglichst mit dem übergebenen Dateinamen ersetzt
	$sRunStatement = FileGetLongName(StringRegExpReplace($sFileTypeCmd, '("?(?:%1|%L)"?)', StringReplace('"' & $sFilePath & '"', "\", "\\")))
	; an die Funktion übergeben Parameter werden möglichst eingefügt
	$sRunStatement = FileGetLongName(StringReplace($sRunStatement, '%*', $sParams))
	; Programm wird gestartet
	$iPID = Run($sRunStatement, $WorkDir, $show_Flag, $opt_flag)
	$iError = @error
	$iExtended = @extended
	; Option wird wieder auf den alten Wert gesetzt
	Opt("ExpandEnvStrings", $iOldOpt)
	Return SetError($iError, $iExtended, $iPID)
EndFunc   ;==>_StartFile2
