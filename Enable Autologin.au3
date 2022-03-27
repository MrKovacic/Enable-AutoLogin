#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ico.ico
#AutoIt3Wrapper_Outfile_x64=Enable AutoLogin.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
$un = @UserName
$dm = @LogonDomain
$Form1 = GUICreate("Enable AutoLogin", 236, 287, 192, 124)
GUICtrlCreateLabel("AutoLogon Script", 48, 16, 500, 17)
GUICtrlCreateLabel("Username", 56, 56, 100, 17)
GUICtrlCreateLabel("Password", 56, 120, 100, 17)
GUICtrlCreateLabel("Domain", 56, 184, 100, 17)
$Username = GUICtrlCreateInput($un, 56, 80, 121, 21)
$Password = GUICtrlCreateInput("", 56, 144, 121, 21)
$Domain = GUICtrlCreateInput($dm, 56, 208, 121, 21)
$add = GUICtrlCreateButton("Enable AutoLogin", 56 - 20, 240, 81, 25)
$remove = GUICtrlCreateButton("Kill AutoLogin", 146 - 20, 240, 81, 25)
GUISetState(@SW_SHOW)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $add
			setautoadminlogin()
		Case $remove
			removeautologin()
	EndSwitch
WEnd

Func setautoadminlogin()
	If ValidatePW() = False Then
		MsgBox(16, "Error", "Invalid Credentials")
	Else
		RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa", "LmCompatabilityLevel", "REG_DWORD", "2")
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AutoAdminLogon", "REG_SZ", "1")
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "ForceAutoLogon", "REG_SZ", "1")
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultUserName", "REG_SZ", GUICtrlRead($Username))
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultPassword", "REG_SZ", GUICtrlRead($Password))
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultDomainName", "REG_SZ", GUICtrlRead($Domain))
		MsgBox(0, "All Set", "AutoLogin has been activated for " & GUICtrlRead($Domain) & "\" & GUICtrlRead($Username))
	EndIf
EndFunc   ;==>setautoadminlogin
Func removeautologin()
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AutoAdminLogon", "REG_SZ", "0")
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "ForceAutoLogon", "REG_SZ", "0")
	RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultUserName")
	RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultPassword")
	RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultDomainName")
	RegDelete("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa", "LmCompatabilityLevel")
EndFunc   ;==>removeautologin

Func ValidatePW();
	$un = StringStripWS(GUICtrlRead($Username), 8)
	$pw = StringStripWS(GUICtrlRead($Domain), 8)
	$dm = StringStripWS(GUICtrlRead($Password), 8)
	$iPID = RunAs($un, $pw, $dm, 0, "notepad.exe", "", @SW_HIDE)
	If @error Then
		Return False
	Else
		Return True
		ProcessClose($iPID)
	EndIf
EndFunc   ;==>ValidatePW


