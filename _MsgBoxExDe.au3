; Include Version:1.01 (15 August 2006)
; Change Language to German (micha_he@autoit.de, 29.04.2010)
; Horizontal & Vertical Center-Coordinates for MsgBox (micha_he@autoit.de, 30.04.2010)
;
#include-once
;
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.133+
; Language:       English
; Description:    Alternative to MsgBox() with extended functionality.
;
; ------------------------------------------------------------------------------
Global $ghMBEX = 0, $giMBEX_Secs = 0, $gaMBEX_SecLines[6][2], $gsMBEX_Text, $giMBEX_PrevOnEventMode
Global $ghMBEX_Button1, $ghMBEX_Button2, $ghMBEX_Button3, $ghMBEX_Button, $giMBEX_ButtonFlag 
Global $gsMBEX_ButtonText, $gsMBEX_CallBack, $giMBEX_RtnVal, $gaMBEX_BT[4], $gbMBEX_ButtonHasCD
Global $giMBEX_TmrStart, $giMBEX_TmrEnd
;
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include "_PlaySystemSound.au3"
;
;
;===============================================================================
;
; Function Name:  _MsgBoxEx() and _MsgBoxExCreate()
; Description:    Extensions to the inbuilt MsgBox() Function.
;                 Adds a drop in replacement or Event driven Mode 
;                 Adds CountDown of Timeout to Default Buttons and|or Text.
;                 Adds Bolding of up to 5 text lines
; Author(s):      Foxnolds <foxnolds at ewise dot com>
;
;===============================================================================

;===============================================================================
;  +++ This is to emulate a Modal MsgBox($iFlag, $sTitle, $sText [, $iTimeout]) +++
; _MsgBoxEx($iFlag, $sTitle, $sText [, $iTimeout [, $sReturnCallBack [, $iLeft [, $iTop [, $hParent]]]]])
;
;  +++ This is the call to use if you have your own EventLoop where you call _MBEX_TickTock() +++
; _MsgBoxExCreate($iFlag, $sTitle, $sText [, $iTimeout [, $sReturnCallBack [, $iLeft [, $iTop [, $hParent]]]]])
; __________________________________________________________________________________________________________________
; $iFlag			The flag indicates the type of message box and the possible button combinations. See remarks. 
; $sTitle			The title of the message box. 
; $sText			The text of the message box. "<b>" and/or "</b>" will Bold Text of whole Line only.
;					Upto 5 lines may have <##> text replaced with the current second countdown value.
; $iTimeout			[optional] 	Timeout in seconds. After the timeout has elapsed the message box will be closed.
;								Default value of 0 will disable timeout.
; $sReturnCallBack 	[optional] 	The name of a function you provide that takes a single argument, the ReturnCode.
;								Default value is Null String "" which is replaced with internal handler when
;								_MsgBoxEx() funcion called.
;								If using _MsgBoxExCreate(),
;									you MUST register your own ReturnCallBack function here...
;									And in your Event Loop, you need to call _MBEX_TickTock() to update timers.
; $iLeft			[optional] 	X Position of Dialog, default of -1 centers dialog horizontally.
;								< -1 horizontal Center-Coordinate for MsgBox 
; $iTop				[optional] 	Y Position of Dialog, default of -1 centers dialog vertically.
;								< -1 vertical Center-Coordinate for MsgBox
; $hParent			[optional] 	Handle to a Parent Window, defaults to 0.
; __________________________________________________________________________________________________________________
;
; Note, as this is Modeless, this version does not support multiple instances which can be invoked.
;       The code uses the Dialog handle of non-zero to test if another is running already.
;
; Failure: Returns -1 if the message box timed out.
;  
; Button Pressed Return Value sent to $gsMBEX_CallBack function you provide   
; OK				1
; CANCEL			2
; ABORT				3
; RETRY				4
; IGNORE			5
; YES				6
; NO				7
; TRY AGAIN **		10
; CONTINUE **		11
; LOCK PC			12		- You have to do the locking...
; CLOSE				13		- New Return code
; _____________________________________________________________________
;
; The flag parameter can be a combination of the following values:
;
; decimal flag	Button-related 					Result hexadecimal flag 
; 0 			OK button								0x0 
; 1 			OK and Cancel 							0x1 
; 2 			Abort, Retry, and Ignore				0x2 
; 3 			Yes, No, and Cancel 					0x3 
; 4 			Yes and No 								0x4 
; 5 			Retry and Cancel 						0x5 
; 6 ** 			Cancel, Try Again, Continue				0x6
; 7	++			+++ See Note7 +++						0x7
; 8	++			Lock PC, Cancel							0x8
;
; +++ Note7 +++ User sets the Global Array Variables Before Calling this Function
;				$gaMBEX_BT[0] = 1, 2 or 3
;				$gaMBEX_BT[1] = "Left Button"
;				$gaMBEX_BT[2] = "Right Button"
;				$gaMBEX_BT[3] = "Middle Button"
; _____________________________________________________________________
; decimal flag	Icon-related 					Result hexadecimal flag 
; 0 			(No icon) 								0x0
; 16 			Stop-sign icon 							0x10
; 32 			Question-mark icon 						0x20
; 48 			Exclamation-point icon 					0x30
; 64 			Information-sign icon consisting of an 'i' in a circle 0x40
; _____________________________________________________________________
; decimal flag	Default-related 				Result hexadecimal flag
; 0 			First button is default button 			0x0
; 256	 		Second button is default button 		0x100
; 512 			Third button is default button 			0x200
; 1024	+++		Default Button has CountDown text		0x400
; _____________________________________________________________________
; decimal flag Modality-related 				Result hexadecimal flag 
; 0 			Application  							0x0 
; 4096 ++		System modal (dialog has an icon) 		0x1000 
; 8192 --		Task modal - Not supported				0x2000 
; _____________________________________________________________________
; decimal flag	Miscellaneous-related 			Result hexadecimal flag 
; 0 			(nothing else special) 					0x0 
; 262144 		MsgBox has top-most attribute set 		0x40000 
; 524288 --		title and text are right-justified 		0x80000 
;
; ** was Only valid on Windows 2000/XP and above.
; ________________________________________________________________
; 
;===============================================================================
;  +++ This is to emulate a Modal MsgBox($iFlag, $sTitle, $sText [, $iTimeout]) +++
; _MsgBoxEx($iFlag, $sTitle, $sText [, $iTimeout [, $sReturnCallBack [, $iLeft [, $iTop [, $hParent]]]]])
;
; Function Entry for backwards compatability for MsgBox() is really a
; Local EventLoop to service this _MsgBoxEx UDF.
; Usually you would use your own EventLoop but this will do if none other.
;===============================================================================
Func _MsgBoxEx($piFlag, $psTitle, $psText, $piTimeout = 0, $psReturnCallBack = "", $piLeft = -1, $piTop = -1, $phParent = 0)
	_MsgBoxExCreate($piFlag, $psTitle, $psText, $piTimeout, $psReturnCallBack, $piLeft, $piTop, $phParent)
	; Local Event Loop for Timer CountDown Tick
	While $giMBEX_RtnVal == 0
		Sleep(250) 			; Allow events to happen...
		_MBEX_TickTock(True)	; Do CountDown display as required
	WEnd
	; Restore Previous OnEventMode
	Opt("GUIOnEventMode", $giMBEX_PrevOnEventMode)	; 0=disabled, 1=OnEvent mode enabled
	Return $giMBEX_RtnVal
EndFunc

;===============================================================================
;  +++ This is the call to use if you have your own EventLoop where you call _MBEX_TickTock() +++
; _MsgBoxExCreate($iFlag, $sTitle, $sText [, $iTimeout [, $sReturnCallBack [, $iLeft [, $iTop [, $hParent]]]]])
;===============================================================================
Func _MsgBoxExCreate($piFlag, $psTitle, $psText, $piTimeout = 0, $psReturnCallBack = "", $piLeft = -1, $piTop = -1, $phParent = 0)
	Local $liPrevCoordMode, $laText, $li, $liMaxStrLen = 0, $liTextWidth, $lsValue, $liStyle, $liStyleEx, $lbTabs
	Local $liIconOffset, $liIconIndex, $liXpos, $lbBold, $liButtonWidth, $liBoldVOffset = 0, $liHeight, $lbButton1Centered
	Local $liNumOfButtons, $lsButton1Text, $lsButton2Text, $lsButton3Text, $liDefButtonNum, $liLeftGrow, $liRightGrow

	Local Const $lciCharWidth  = 5,  $lciBtnCharWidth = 7,  $lciButtonWidth  = 70, $lciBoldWidth  = 7
	Local Const $lciCharHeight = 15, $lciLineHeight   = 20, $lciButtonHeight = 25, $lciBoldHeight = 16 
	
	If $ghMBEX Then Return 0  ; Already displayed!

	If $psReturnCallBack == "" Then $psReturnCallBack = "_MBEX_DefaultReturnCallBack"	; No CallBack provided - Mandatory!
	$gsMBEX_CallBack = $psReturnCallBack

	$liPrevCoordMode = Opt("GUICoordMode", 1)	; 1 = absolute coordinates (default) still relative to the dialog box.
												; 0 = relative position to the start of the last control (upper left corner).
												; 2 = cell positionining relative to current cell.
												;     A -1 for left or top parameter don't increment the start.
												;	  So next line is -1,offset; next cell is offset,-1; current cell is -1,-1.
	$giMBEX_PrevOnEventMode  = Opt("GUIOnEventMode", 1)	; 0=disabled, 1=OnEvent mode enabled

	$gaMBEX_SecLines[0][0] = 0	; Initialse Counter of Lines needing SECONDS update <##> to Zero
	$gaMBEX_SecLines[0][1] = ""

	$giMBEX_Secs = $piTimeout
	$gsMBEX_Text = " (<##> secs)"
	$laText = StringSplit($psText, @LF, 1)
	$liMaxStrLen = 0
	For $li = 1 To $laText[0]
		$lbBold = False
		$lbTabs = False
		$liTextWidth = StringLen($laText[$li])
		If StringInStr($laText[$li], "<b>", 0, 1) > 0 OR StringInStr($laText[$li], "</b>", 0, 1) > 0 Then $lbBold = True
		If StringInStr($laText[$li], @TAB, 0, 1) > 0 Then
			; Expand TAB characters.. to 4-Char boundary
			$lbTabs = True
			Local $liLen = 0, $c = ""
			For $liIconOffset = 1 to $liTextWidth
				$c = StringMid($laText[$li], $liIconOffset, 1)
				If $c == @TAB Then
					If Mod($liLen, 4) == 0 Then
						$liLen += 4
					Else
						$liLen += Mod($liLen, 4)
					EndIf
				Else
					$liLen += 1
				EndIf
			Next
			$liTextWidth = $liLen
		EndIf
		If $lbBold Then
			$liTextWidth = $liTextWidth * $lciBoldWidth
			$liBoldVOffset = $liBoldVOffset + $lciBoldHeight - $lciLineHeight
		ElseIf $lbTabs Then
			$liTextWidth = $liTextWidth * $lciBoldWidth
		Else
			$liTextWidth = $liTextWidth * $lciCharWidth
		EndIf
		If $liTextWidth > $liMaxStrLen Then $liMaxStrLen = $liTextWidth
	Next
	$liTextWidth = 250
	If $liMaxStrLen > $liTextWidth Then $liTextWidth = $liMaxStrLen
	
	; Set up Button info
	$lbButton1Centered = False
	Select
		Case BitAND($piFlag, 8) == 8 ; Lock PC, Cancel
			$liNumOfButtons = 2
			$lsButton1Text = "PC verriegeln"
			$lsButton2Text = "Abbruch"
			$lsButton3Text = ""
			$giMBEX_ButtonFlag = 8
		Case BitAND($piFlag, 7) == 7 ; User Defined
			; User sets the Global Variables Before Calling this Function
			$liNumOfButtons = $gaMBEX_BT[0]	; 1, 2 or 3
			$lsButton1Text = $gaMBEX_BT[1]		; "Left Button"
			$lsButton2Text = $gaMBEX_BT[2]		; "Right Button"
			$lsButton3Text = $gaMBEX_BT[3]		; "Middle Button"
			$giMBEX_ButtonFlag = 7
			If $liNumOfButtons == 1 Then $lbButton1Centered = True
		Case BitAND($piFlag, 6) == 6 ; Cancel, Try Again, Continue
			$liNumOfButtons = 3
			$lsButton1Text = "Abbruch"
			$lsButton2Text = "Weiter"
			$lsButton3Text = "Nochmal"
			$giMBEX_ButtonFlag = 6
		Case BitAND($piFlag, 5) == 5 ; Retry and Cancel
			$liNumOfButtons = 2
			$lsButton1Text = "Wiederholen"
			$lsButton2Text = "Abbruch"
			$lsButton3Text = ""
			$giMBEX_ButtonFlag = 5
		Case BitAND($piFlag, 4) == 4 ; Yes and No
			$liNumOfButtons = 2
			$lsButton1Text = "Ja"
			$lsButton2Text = "Nein"
			$lsButton3Text = ""
			$giMBEX_ButtonFlag = 4
		Case BitAND($piFlag, 3) == 3 ; Yes, No, and Cancel
			$liNumOfButtons = 3
			$lsButton1Text = "Ja"
			$lsButton2Text = "Abbruch"
			$lsButton3Text = "Nein"
			$giMBEX_ButtonFlag = 3
		Case BitAND($piFlag, 2) == 2 ; Abort, Retry, and Ignore
			$liNumOfButtons = 3
			$lsButton1Text = "Abbruch"
			$lsButton2Text = "Ignorieren"
			$lsButton3Text = "Wiederholen"
			$giMBEX_ButtonFlag = 2
		Case BitAND($piFlag, 1) == 1 ; OK and Cancel
			$liNumOfButtons = 2
			$lsButton1Text = "Ok"
			$lsButton2Text = "Abbruch"
			$lsButton3Text = ""
			$giMBEX_ButtonFlag = 1
		Case Else ;	OK button
			$liNumOfButtons = 1
			$lsButton1Text = "Ok"
			$lsButton2Text = ""
			$lsButton3Text = ""
			$lbButton1Centered = True
			$giMBEX_ButtonFlag = 0
	EndSelect

	; Select default Button to Count Down
	$liDefButtonNum = 1	; First button is default button
	$gsMBEX_ButtonText = $lsButton1Text
	If BitAND($piFlag, 256) == 256 Then
		; Second button is default button
		If $liNumOfButtons == 2 Then
			$liDefButtonNum = 2 ; Second of 2
			$gsMBEX_ButtonText = $lsButton2Text
		ElseIf $liNumOfButtons == 3 Then
			$liDefButtonNum = 3 ; The Middle button
			$gsMBEX_ButtonText = $lsButton3Text
		Else
			$liDefButtonNum = 1	; First button is default button
			$gsMBEX_ButtonText = $lsButton1Text
		EndIf
	ElseIf BitAND($piFlag, 512) == 512 Then
		; Third button is default button
		If $liNumOfButtons == 3 Then
			$liDefButtonNum = 2 ; Button 2 is always the RHS one.
			$gsMBEX_ButtonText = $lsButton2Text
		ElseIf $liNumOfButtons == 2 Then
			$liDefButtonNum = 2 ; Button 2 is always the RHS one.
			$gsMBEX_ButtonText = $lsButton2Text
		ElseIf $liNumOfButtons == 1 Then
			$liDefButtonNum = 1 ; Button 1 is the only one.
			$gsMBEX_ButtonText = $lsButton1Text
		EndIf
	EndIf

	; Look for CoutDown text on Default Button request
	$gbMBEX_ButtonHasCD = False
	If BitAND($piFlag, 1024) == 1024 Then $gbMBEX_ButtonHasCD = True

	; Look for Icon Index
	$liIconOffset = 10
	$liIconIndex  = 0
	If BitAND($piFlag, 48) == 48 Then
		$liIconIndex  = -2 ;  48x48 WinXP Icon - 48 - Exclamation
		$liIconOffset = 60
	ElseIf BitAND($piFlag, 16) == 16 Then
		$liIconIndex  = -4 ; 48x48 WinXP Icon - 16 - Stop Sign
		$liIconOffset = 60
	ElseIf BitAND($piFlag, 32) == 32 Then
		$liIconIndex  = -3 ; 48x48 WinXP Icon - 32 - Ques Mark
		$liIconOffset = 60
	ElseIf BitAND($piFlag, 64) == 64 Then
		$liIconIndex  = -5 ; 48x48 WinXP Icon - 64 - Information
		$liIconOffset = 60
	EndIf

	; Test for enough room for 3 standard Buttons
	If $liNumOfButtons == 3 And $gbMBEX_ButtonHasCD AND ($liTextWidth + $liIconOffset) < 290 Then
		$liTextWidth = 290 - $liIconOffset
	EndIf
	; redo width calculation incase User Defined Button text is large?
	If $giMBEX_ButtonFlag == 7 Then
		$liMaxStrLen = StringLen($lsButton1Text) + StringLen($gsMBEX_Text) + 2
		If $liNumOfButtons > 1 Then	$liMaxStrLen += StringLen($lsButton2Text) + 2
		If $liNumOfButtons > 2 Then	$liMaxStrLen += StringLen($lsButton3Text) + 2
		$liMaxStrLen = ($liMaxStrLen * $lciBtnCharWidth) - $liIconOffset	; buttons can use Icon horizontal space
		If $liMaxStrLen > $liTextWidth Then $liTextWidth = $liMaxStrLen
	EndIf

	; Get Topmost flag
	$liStyleEx = -1
	If BitAND($piFlag, 262144) == 262144 Then $liStyleEx = $WS_EX_TOPMOST
	$liStyle = BitOr($WS_CAPTION, $WS_POPUP)
	If BitAND($piFlag, 4096) == 4096 Then $liStyle = BitOr($WS_CAPTION, $WS_POPUP, $WS_MINIMIZEBOX, $WS_SYSMENU) ; System Modal has Icon..
	If BitAND($piFlag, 524288) == 524288 Then $liStyle = BitOr($liStyle, $SS_RIGHT)
	If $piLeft < -1 AND $piTop < -1 Then ; Koordinaten sind Mittelpunkte und müssen abhängig der GUI-Größe berechnet werden
		$piLeft = Abs($piLeft) - ($liTextWidth + $liIconOffset + 10) / 2
		$piTop = Abs($piTop) - (55 + ($laText[0] * $lciLineHeight) + $liBoldVOffset) / 2
	EndIf
	If $phParent == 0 Then
		$ghMBEX = GuiCreate($psTitle, $liTextWidth + $liIconOffset + 10, 55 + ($laText[0] * $lciLineHeight) + $liBoldVOffset, $piLeft, $piTop, $liStyle, $liStyleEx)
	Else
		$ghMBEX = GuiCreate($psTitle, $liTextWidth + $liIconOffset + 10, 55 + ($laText[0] * $lciLineHeight) + $liBoldVOffset, $piLeft, $piTop, $liStyle, $liStyleEx, $phParent)
	EndIf
	If @Compiled Then GUISetIcon(@AutoItExe, 0)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_MBEX_SpecialEvents")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "_MBEX_SpecialEvents")
	GUISetOnEvent($GUI_EVENT_RESTORE, "_MBEX_SpecialEvents")
	
	If $liIconIndex < 0 Then GUICtrlCreateIcon(@SystemDir & "\user32.dll", $liIconIndex, 10, 10)
	
	$liBoldVOffset = 0
	For $li = 1 To $laText[0]
		$lbBold = False
		$lsValue = StringStripCR($laText[$li])
		If StringInStr($lsValue, "<b>", 0, 1) > 0 Then
			$lbBold = True
			$lsValue = StringReplace($lsValue, "<b>", "", 0, 0)
		EndIf
		If StringInStr($lsValue, "</b>", 0, 1) > 0 Then
			$lbBold = True
			$lsValue = StringReplace($lsValue, "</b>", "", 0, 0)
		EndIf
		$liHeight = $lciCharHeight
		If $lbBold Then $liHeight = $lciBoldHeight
		$liStyle = -1
		If BitAND($piFlag, 524288) == 524288 Then $liStyle = BitOr($liStyle, $SS_RIGHT)
		If StringInStr($lsValue, "<##>", 0, 1) > 0 And $gaMBEX_SecLines[0][0] < 5 Then
			; Update Counter of Lines needing SECONDS update <##>
			$gaMBEX_SecLines[0][0] = $gaMBEX_SecLines[0][0] + 1
			$gaMBEX_SecLines[$gaMBEX_SecLines[0][0]][1] = $lsValue
			$lsValue = StringReplace($lsValue, "<##>", $giMBEX_Secs, 0, 0)
			$gaMBEX_SecLines[$gaMBEX_SecLines[0][0]][0] = GUICtrlCreateLabel($lsValue, $liIconOffset, ((($li-1) * $lciLineHeight) + 10 + $liBoldVOffset), $liTextWidth, $liHeight, $liStyle)
		Else
			GUICtrlCreateLabel($lsValue, $liIconOffset, ((($li-1) * $lciLineHeight) + 10 + $liBoldVOffset), $liTextWidth, $liHeight, $liStyle)
		EndIf
		If $lbBold Then
			GUICtrlSetFont(-1, 11, 800)
			$liBoldVOffset = $liBoldVOffset + $lciBoldHeight - $lciLineHeight
		EndIf
	Next

	; Set Button1 Text
	$lsValue = $lsButton1Text
	If $giMBEX_Secs > 0 AND $liDefButtonNum == 1 AND $gbMBEX_ButtonHasCD Then
		$lsValue = StringReplace($gsMBEX_ButtonText & $gsMBEX_Text, "<##>", $giMBEX_Secs, 0, 0)
	EndIf
	; Get Button Width
	$liButtonWidth = StringLen($lsValue) * $lciBtnCharWidth
	If $liButtonWidth < $lciButtonWidth Then $liButtonWidth = $lciButtonWidth
	$liLeftGrow = $liButtonWidth - $lciButtonWidth
	
	; Set Button1 Position
	If $lbButton1Centered Then
		$liXpos = Int(($liTextWidth + $liIconOffset + 10) / 2) - Int($liButtonWidth / 2) ; Centered
	Else
		$liXpos = 10 ; $liIconOffset
	EndIf

	; Set Defult Button action
	If $liDefButtonNum == 1 Then
		$liStyle = $BS_DEFPUSHBUTTON
	Else
		$liStyle = -1
	EndIf
	$ghMBEX_Button1 = GUICtrlCreateButton($lsValue, $liXpos, ($laText[0] * $lciLineHeight) + 25 + $liBoldVOffset, $liButtonWidth, $lciButtonHeight, $liStyle)
	GUICtrlSetOnEvent(-1, "_MBEX_Button1_Pressed")
	If $liDefButtonNum == 1 Then $ghMBEX_Button = $ghMBEX_Button1
	
	If $liNumOfButtons > 1 Then
		; Set Button2 Text
		$lsValue = $lsButton2Text
		If $giMBEX_Secs > 0 AND $liDefButtonNum == 2 AND $gbMBEX_ButtonHasCD Then
			$lsValue = StringReplace($gsMBEX_ButtonText & $gsMBEX_Text, "<##>", $giMBEX_Secs, 0, 0)
		EndIf
		; Get Button Width
		$liButtonWidth = StringLen($lsValue) * $lciBtnCharWidth
		If $liButtonWidth < $lciButtonWidth Then $liButtonWidth = $lciButtonWidth
		$liRightGrow = $liButtonWidth - $lciButtonWidth
		; Set Defult Button action
		If $liDefButtonNum == 2 Then
			$liStyle = $BS_DEFPUSHBUTTON
		Else
			$liStyle = -1
		EndIf
		$ghMBEX_Button2 = GUICtrlCreateButton($lsValue, $liTextWidth + $liIconOffset - $liButtonWidth, ($laText[0] * $lciLineHeight) + 25 + $liBoldVOffset, $liButtonWidth, $lciButtonHeight, $liStyle)
		GUICtrlSetOnEvent(-1, "_MBEX_Button2_Pressed")
		If $liDefButtonNum == 2 Then $ghMBEX_Button = $ghMBEX_Button2
	EndIf

	If $liNumOfButtons > 2 Then
		; Set Button3 Text
		$lsValue = $lsButton3Text
		If $giMBEX_Secs > 0 AND $liDefButtonNum == 3 AND $gbMBEX_ButtonHasCD Then
			$lsValue = StringReplace($gsMBEX_ButtonText & $gsMBEX_Text, "<##>", $giMBEX_Secs, 0, 0)
		EndIf
		; Get Button Width
		$liButtonWidth = StringLen($lsValue) * $lciBtnCharWidth
		If $liButtonWidth < $lciButtonWidth Then $liButtonWidth = $lciButtonWidth
		; Set Defult Button action
		If $liDefButtonNum == 3 Then
			$liStyle = $BS_DEFPUSHBUTTON
		Else
			$liStyle = -1
		EndIf
		$liXpos = Int(($liTextWidth + $liIconOffset + 10) / 2) - Int($liButtonWidth / 2) + Int($liLeftGrow / 2) - Int($liRightGrow / 2) ; Centered
		$ghMBEX_Button3 = GUICtrlCreateButton($lsValue, $liXpos, ($laText[0] * $lciLineHeight) + 25 + $liBoldVOffset, $liButtonWidth, $lciButtonHeight, $liStyle)
		GUICtrlSetOnEvent(-1, "_MBEX_Button3_Pressed")
		If $liDefButtonNum == 3 Then $ghMBEX_Button = $ghMBEX_Button3
	EndIf
	
	
	; GUI MESSAGE LOOP is performed by Main Dialog loop
	GuiSetState()
	Opt("GUICoordMode", $liPrevCoordMode)

	$giMBEX_RtnVal = 0
	$giMBEX_TmrStart = TimerInit()
	$giMBEX_TmrEnd = ($giMBEX_Secs * 1000)	; Total Duration in millisecs

	GUICtrlSetState($ghMBEX_Button, $GUI_FOCUS)
	
	_PlaySystemSound("Default",True)
	
	return $ghMBEX
EndFunc ;==>_MsgBoxEx

;===============================================================================
; Updates CountDown Text if second has changed.
; Returns CountDown Value in seconds
;===============================================================================
Func _MBEX_TickTock($pbUseInternalTimer = True)
	Local $li, $lsValue, $liTmrDiff, $liCountDownSecs, $lbSecChanged
; ConsoleWrite(@LF & "in _MBEX_TickTock() - $ghMBEX=" & $ghMBEX) 
	If Not $ghMBEX Then Return 0	; incase users leave this call permanently in their own EventLoop

	If $giMBEX_Secs > 0 Then
		If $pbUseInternalTimer Then
			$liTmrDiff = Int(TimerDiff($giMBEX_TmrStart))	; Elapsed time in milliseconds
			; $giMBEX_TmrEnd == Total Duration in millisecs
			$liCountDownSecs = Round(($giMBEX_TmrEnd - $liTmrDiff) / 1000, 0)
			If $liCountDownSecs < 0 Then $liCountDownSecs = 0
			; Only update display on second value change..
			If $liCountDownSecs <> $giMBEX_Secs Then
				$giMBEX_Secs = $liCountDownSecs	; Decrament CountDown secs - $giMBEX_Secs -= 1
				$lbSecChanged = True
			EndIf
		Else
			$giMBEX_Secs -= 1
			$lbSecChanged = True
		EndIf
		If $lbSecChanged Then
			If $giMBEX_Secs < 0 Then $giMBEX_Secs = 0
			If $ghMBEX Then
				If $gbMBEX_ButtonHasCD Then
					$lsValue = StringReplace($gsMBEX_ButtonText & $gsMBEX_Text, "<##>", $giMBEX_Secs, 0, 0)
					GUICtrlSetData($ghMBEX_Button, $lsValue)
				EndIf
				If $gaMBEX_SecLines[0][0] > 0 Then
					For $li = 1 To $gaMBEX_SecLines[0][0]
						$lsValue = StringReplace($gaMBEX_SecLines[$li][1], "<##>", $giMBEX_Secs, 0, 0)
						GUICtrlSetData($gaMBEX_SecLines[$li][0], $lsValue)
					Next
				EndIf
			EndIf
			If $giMBEX_Secs <= 0 Then
				If $ghMBEX Then
					GUIDelete($ghMBEX)
					$ghMBEX = 0
				EndIf
				$giMBEX_Secs = 0 ; stop the clock!
				Call($gsMBEX_CallBack, -1) ; -1 == Timedout
			EndIf
		EndIf
	EndIf

	Return $giMBEX_Secs
EndFunc

;===============================================================================
;===============================================================================
Func _MBEX_Button1_Pressed()
	Local $liRtnVal
	; @GUI_CTRLID contains $ghMBEX_Button1 when called directly by GUICtrlSetOnEvent()
	; and @GUI_WINHANDLE would equal $ghMBEX
	$giMBEX_Secs = 0 ; stop the clock!
	If $ghMBEX Then
		GUIDelete($ghMBEX)
		$ghMBEX = 0
	EndIf
	Switch $giMBEX_ButtonFlag
		Case 0 ; OK
			$liRtnVal = 1
		Case 1 ; OK
			$liRtnVal = 1
		Case 2 ; Abort
			$liRtnVal = 3
		Case 3 ; Yes
			$liRtnVal = 6
		Case 4 ; Yes
			$liRtnVal = 6
		Case 5 ; Retry
			$liRtnVal = 4
		Case 6 ; Cancel
			$liRtnVal = 2
		Case 7 ; UserDef
			$liRtnVal = 1 ; Button Number
		Case 8 ; Lock PC
			$liRtnVal = 12
		Case Else
			$liRtnVal = -1
	EndSwitch
	Call($gsMBEX_CallBack, $liRtnVal)
EndFunc ;==>_MBEX_Button1_Pressed

;===============================================================================
;===============================================================================
Func _MBEX_Button2_Pressed()
	Local $liRtnVal
	; @GUI_CTRLID contains $ghMBEX_Button2 when called directly by GUICtrlSetOnEvent()
	; and @GUI_WINHANDLE would equal $ghMBEX
	$giMBEX_Secs = 0 ; stop the clock!
	If $ghMBEX Then
		GUIDelete($ghMBEX)
		$ghMBEX = 0
	EndIf
	Switch $giMBEX_ButtonFlag
		Case 1 ; Cancel
			$liRtnVal = 2
		Case 2 ; Ignore
			$liRtnVal = 5
		Case 3 ; Cancel
			$liRtnVal = 2
		Case 4 ; No
			$liRtnVal = 7
		Case 5 ; Cancel
			$liRtnVal = 2
		Case 6 ; Continue
			$liRtnVal = 11
		Case 7 ; UserDef
			$liRtnVal = 2 ; Button Number
		Case 8 ; Cancel
			$liRtnVal = 2
		Case Else
			$liRtnVal = -1
	EndSwitch
	Call($gsMBEX_CallBack, $liRtnVal)
EndFunc ;==>_MBEX_Button2_Pressed

;===============================================================================
;===============================================================================
Func _MBEX_Button3_Pressed()
	Local $liRtnVal
	; @GUI_CTRLID contains $ghMBEX_Button2 when called directly by GUICtrlSetOnEvent()
	; and @GUI_WINHANDLE would equal $ghMBEX
	$giMBEX_Secs = 0 ; stop the clock!
	If $ghMBEX Then
		GUIDelete($ghMBEX)
		$ghMBEX = 0
	EndIf
	Switch $giMBEX_ButtonFlag
		Case 2 ; Retry
			$liRtnVal = 4
		Case 3 ; No
			$liRtnVal = 7
		Case 6 ; Try Again
			$liRtnVal = 10
		Case 7 ; UserDef
			$liRtnVal = 3 ; Button Number
		Case Else
			$liRtnVal = -1
	EndSwitch
	Call($gsMBEX_CallBack, $liRtnVal)
EndFunc ;==>_MBEX_Button3_Pressed

;===============================================================================
;===============================================================================
Func _MBEX_DefaultReturnCallBack($piReturnVal)
	$giMBEX_RtnVal = $piReturnVal ; Breaks Local Event Loop when not Zero
EndFunc

;===============================================================================
;===============================================================================
Func _MBEX_SpecialEvents()
	Local $liRtnVal
	Select
		Case @GUI_CTRLID = $GUI_EVENT_CLOSE
			$giMBEX_Secs = 0 ; stop the clock!
			If $ghMBEX Then
				GUIDelete($ghMBEX)
				$ghMBEX = 0
			EndIf
			Switch $giMBEX_ButtonFlag
				Case 1 ; Cancel
					$liRtnVal = 2
				Case 2 ; Ignore
					$liRtnVal = 5
				Case 3 ; Cancel
					$liRtnVal = 2
				Case 4 ; No
					$liRtnVal = 7
				Case 5 ; Cancel
					$liRtnVal = 2
				Case 6 ; Continue
					$liRtnVal = 11
				Case 7 ; UserDef
					$liRtnVal = 2 ; Button Number 2
				Case 8 ; Cancel
					$liRtnVal = 2
				Case Else
					$liRtnVal = -1
			EndSwitch
			Call($gsMBEX_CallBack, 13)	; Hard Code Close == 13
		Case @GUI_CTRLID = $GUI_EVENT_MINIMIZE
			Return
		Case @GUI_CTRLID = $GUI_EVENT_RESTORE
            Return
	EndSelect
EndFunc ;==>_MBEX_SpecialEvents
