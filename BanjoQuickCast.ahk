;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

IniRead winX, C:\Users\%A_UserName%\Documents\AHKWinPos.ini, BanjoQC, X 
IniRead winY, C:\Users\%A_UserName%\Documents\AHKWinPos.ini, BanjoQC, Y

W = Disabled
Q = Disabled
R = Disabled
Caps = Enabled

runGui:
Gui,+LastFound +AlwaysOnTop +Caption
Gui,Color, F2FAFD
Gui,Add,Text, x33 y10, Hotkey
Gui,Add,Text, x120 y10, Status
if W = Enabled
	Gui,Font, cgreen
else 
	Gui,Font, cred
Gui,Add,Text, x115 y35, %W%
if Q = Enabled
	Gui,Font, cgreen
else 
	Gui,Font, cred
Gui,Add,Text, x115 y70, %Q%

if R = Enabled
	Gui,Font, cgreen
else 
	Gui,Font, cred
Gui,Add,Text, x115 y105, %R%
Gui,Font, cblack
Gui,Add,Button, x30  y30  w40 h25 gtoggleW, W
Gui,Add,Button, x30  y65  w40 h25 gtoggleQ, Q
Gui,Add,Button, x30  y100  w40 h25 gtoggleR, R
Gui,Add,Button, x126  y134  w15 h15, ?

Gui,Add,Checkbox, x30 y135 gtoggleCaps vCapsCheck Checked, Caps Lock Only
if Caps = Enabled
	GuiControl,, CapsCheck, 1
if Caps = Disabled
	GuiControl,, CapsCheck, 0
Gui,Font, underline cblue
Gui,Add,Text, x32 y155 gContactURL, Contact
Gui,Add,Text, x118 y155 gDonateURL, Donate
Gui,Font, norm cblack s6 italic
Gui,Add,Text, x173 y170, v1.2
if (winX is number) && (winY is number)
	Gui,Show,w190 h180 x%winX% y%winY%,Banjo QC
else
	Gui,Show,w190 h180,Banjo QC
OnMessage(0x200, "Help")
return

Help(wParam, lParam, Msg) 
{	
	MouseGetPos,,,, OutputVarControl
	IfEqual, OutputVarControl, Button4
	Help := "QuickCast will only work when Caps Lock is on so you can chat in-game normally."
	ToolTip % Help
}	
	
toggleW:
if W = Enabled
	W = Disabled
else 
	W = Enabled
Gui,Destroy
Goto, runGui
return

toggleQ:
if Q = Enabled
	Q = Disabled
else
	Q = Enabled
Gui,Destroy
Goto, runGui
return

toggleR:
if R = Enabled
	R = Disabled
else
	R = Enabled
Gui,Destroy
Goto, runGui
return

toggleCaps:
if Caps = Enabled
	Caps = Disabled
else
	Caps = Enabled
return

DonateURL:
Run https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=BN2NEKFM26VY4&currency_code=EUR&source=url
return
ContactURL:
Run https://discordapp.com/users/215931228849700875
return

#If WinActive("Warcraft III")
{
	$W::
	state := GetKeyState("Capslock", "T")  ; 1 if CapsLock is ON, 0 otherwise.	
	if W = Enabled
	{
		if (state = 1) || (Caps = "Disabled")
		{
			While GetKeyState("w","P") && WinActive("Warcraft III")
			{
				SendInput, w
				MouseClick, Left
			}
		}
		else
		{
			if state = 1
				SendInput W
			else
				SendInput w
		}
	}
	else
	{	
		if state = 1
			SendInput W
		else
			SendInput w
	}
	return
}
return

#If WinActive("Warcraft III")
{
	$Q::
	state := GetKeyState("Capslock", "T")  ; 1 if CapsLock is ON, 0 otherwise.
	if Q = Enabled
	{
		if (state = 1) || (Caps = "Disabled")
		{
			While GetKeyState("q","P") && WinActive("Warcraft III")
			{
				SendInput, q
				MouseClick, Left
				;SendInput 1
			}
		}
		else
		{
			if state = 1
				SendInput Q
			else
				SendInput q
		}
	}
	else
	{	
		if state = 1
			SendInput Q
		else
			SendInput q
	}
	return
}
return

#If WinActive("Warcraft III")
{
	$R::
	state := GetKeyState("Capslock", "T")  ; 1 if CapsLock is ON, 0 otherwise.
	if R = Enabled
	{
		if (state = 1) || (Caps = "Disabled")
		{
			While GetKeyState("r","P") && WinActive("Warcraft III")
			{
				SendInput, r
				MouseClick, Left
			}
		}
		else
		{
			if state = 1
				SendInput R
			else
				SendInput r
		}
	}
	else
	{	
		if state = 1
			SendInput R
		else
			SendInput r
	}
	return
}
return

GuiClose:
WinGetPos, winX, winY, winW, winH, %title%
IniWrite %winX%, C:\Users\%A_UserName%\Documents\AHKWinPos.ini, BanjoQC, X 
IniWrite %winY%, C:\Users\%A_UserName%\Documents\AHKWinPos.ini, BanjoQC, Y 
Gui, Destroy

