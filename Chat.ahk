#noenv
#singleinstance, force
#persistent

path = C:\Users\%A_UserName%\Dropbox\Chat
Menu, tray, Icon , %path%\chaticon.ico, 1, 1 ;Changes GUI icon in the top-left corner to the DJ logo

IfNotExist, %path%\MSG\default.ini
{
	MsgBox, default.ini not found in: %path%/MSG/default.ini
}
IfNotExist, %path%\MSG\%A_UserName%.ini
{
	Array := [] 
	
	Loop, Read, %path%\MSG\default.ini ; This loop retrieves each line from the file, one at a time.
	{		 
		Array.Push(A_LoopReadLine) 
	}
	for index, element in Array 
	{
		StringReplace, element, element, [, , All
		StringReplace, element, element, ], , All
		StringLower, element, element
		if element not contains MSG
		{
			IniWrite, read, %path%\MSG\%element%.ini, %A_UserName%, MSG 
		}
	}
	IniWrite, read, %path%\MSG\default.ini, %A_UserName%, MSG
	FileCopy, %path%/MSG/default.ini, %path%/MSG/%A_UserName%.ini	
}

setbatchlines, 10ms
settimer, emptymem, 600000 ;minimize ram use every 10 minutes.
settimer, readmessages, 1000 ;check time every second.


global r1 := ""
global r2 := ""
global OutputMSG := ""
global element := ""
global Sender := ""
global WinStatus := ""
global Key := "Glupa"
global SalvagedMSG := ""
global LastWindow := ""
global NewMSG = False
global NewMSGText := ""

Array := [] 

Loop, Read, %path%\MSG\%A_UserName%.ini ; This loop retrieves each line from the file, one at a time.
{		 
	Array.Push(A_LoopReadLine) 
}

^!c:: 
Goto, Menu
return

ChatGui()
{
	NewMSG = False
	;GuiControlGet, OutputMSG
	;MsgBox 1 - %SalvagedMSG%
	Gui,1: Destroy
	Gui,2:Destroy
 	Gui,1: Color, F2FAFD
	Gui,1: Add,Text,x20 y20 w350 h125, %r2%`n%r1%
	Gui,1: Add,Button,x380 y20 w43 h23 gMenu ,Menu
	Gui,1: Add,Edit,x20 y160 w350 h21 vOutputMSG, %SalvagedMSG%
	Gui,1: Font, cDA4F49									
	Gui,1: Add,Text, x350 y5 w75 h15 vNewMSGText +Hidden, New Messages
	GuiControl,1: Focus,OutputMSG
	Gui,1: Add,Button,x380 y160 w43 h23 gSendMessage +Default,Send
	
	If (WinStatus = "Menu" || WinStatus = "Sent")
	{
		Gui,1: Show,w430 h200,secret chat - %Sender%
	}
	Else if WinStatus = SameActive
	{
		Gui,1: Show,w430 h200,secret chat - %Sender%
		Gui,1: Flash
	}
	Else if WinStatus = SameOpen
	{
		Gui,1: Show,w430 h200,secret chat - %Sender%
		Gui,1: Flash
		SoundPlay, %path%\chatnotification.mp3
		WinActivate %LastWindow%
	}
	Else if WinStatus = SameMinimized
	{
		Gui,1: Show,w430 h200 minimize,secret chat - %Sender%
		Gui,1: Flash
		SoundPlay, %path%\chatnotification.mp3
	}
	Else
	{
		Gui,1: Show,w430 h200 minimize,secret chat - %Sender%
		Gui,1: Flash
		SoundPlay, %path%\chatnotification.mp3
	}	
	SalvagedMSG := "" 
	
	
	;If NewMsg = True
	;{
		;GuiControl,Show, test123
	;}
	;return
	
}
return

;GuiEscape:
;GuiClose:
;GuiControlGet, OutputMSG
;MsgBox %OutputMSG%
;return


readmessages:
{
	Array := [] 
	
	Loop, Read, %path%\MSG\%A_UserName%.ini ; This loop retrieves each line from the file, one at a time.
	{		 
		Array.Push(A_LoopReadLine) 
	}
	
	for index, element in Array 
	{
		StringReplace, element, element, [, , All
		StringReplace, element, element, ], , All
		if element not contains MSG
		{
			Text = element
			IniRead Text, %path%\MSG\%A_UserName%.ini, %element%, MSG
			if !(Text = "ERROR"|| Text = "read"|| Text = ""|| Text = "MSG =read")
			{
				StringLower, element, element
				IfWinExist secret chat - %element%
				{
					Gui,1: submit, NoHide
					GuiControlGet, OutputMSG
					SalvagedMSG := OutputMSG
					Goto, ReceiveMessage
				}
				Else IfWinExist secret chat -
				{
					If NewMsg != True
					{
						Gui,1: Flash
						GuiControl,1:Show, NewMSGText
						SoundPlay, %path%\chatnotification.mp3
						NewMSG = True
					}
					
				}
				Else
				{
					Goto, ReceiveMessage
				}
			}
		}
	}
	return
}
return

ReceiveMessage:
{
	String := Text
	Decoded := XOR_String_Minus(String, Key)
	
	if !(Text = "ERROR"|| Text = "read"|| Text = ""|| Text = "MSG =read")
	{
		Sender := element
		StringLower, element, element
		r1 := Decoded
		
		WinGet, OutputVar , MinMax, secret chat, 
		IfWinExist, secret chat - %element%
		{
			IfWinActive, secret chat
			{
				WinStatus = SameActive
			}
			Else If OutputVar = 0 
			{
				WinStatus = SameOpen
				WinGetTitle, LastWindow, A
			}
			Else
			{
				WinStatus = SameMinimized
			}
			
		}
		Else IfWinExist, secret chat
		{
			IfWinActive, secret chat
			{
				WinStatus = DifActive
			}
			Else If OutputVar = 0 
			{
				WinStatus = DifOpen
				WinGetTitle, LastWindow, A
			}
			Else
			{
				WinStatus = DifMinimized
			}
			
		}
		Else
		{
			WinStatus = Closed
		}
		
		ChatGui()
		IniWrite read, %path%\MSG\%A_UserName%.ini, %element%, MSG
		SalvagedMSG := ""
	}
	XOR_String_Minus(String,Key)
	{
		Key_Pos := 1
		Loop, Parse, String
		{
			String_XOR .= Chr(((Asc(A_LoopField) - 15) ^ Asc(SubStr(Key,Key_Pos,1))))
			Key_Pos += 1
			if (Key_Pos > StrLen(Key))
				Key_Pos := 1
		}
		return String_XOR
	}
}
return

SendMessage:
{
	Gui, Submit, hide
	{
		if !(OutputMSG = "ERROR"|| OutputMSG = "read"|| OutputMSG = ""|| OutputMSG = "MSG =read")
		{	
			IniRead PrevMSG, %path%\MSG\%Sender%.ini, %A_UserName%, MSG
			if !(PrevMSG = "ERROR"|| PrevMSG = "read"|| PrevMSG = ""|| PrevMSG = " ")
			{
				String := PrevMSG
				PrevMSGDecoded := XOR_String_Minus(String, Key)
				r1 := % PrevMSGDecoded " - " OutputMSG
			}
			else
			{
				r1 := OutputMSG
			}
			WinStatus = Sent
			ChatGui()
			WinStatus = Unknown
			Goto, Encode
		}
	}
}
return

Encode:
{
	IniRead PrevMSG, %path%\MSG\%Sender%.ini, %A_UserName%, MSG
	if !(PrevMSG = "ERROR"|| PrevMSG = "read"|| PrevMSG = ""|| PrevMSG = " ")
	{
		String := PrevMSG
		PrevMSGDecoded := XOR_String_Minus(String, Key)
		String := % PrevMSGDecoded " - " OutputMSG
		
	}
	else
		String := % A_UserName ": " OutputMSG
	
	Coded := XOR_String_Plus(String, Key)
	IniWrite "%Coded%`", %path%\MSG\%Sender%.ini, %A_UserName%, MSG

	XOR_String_Plus(String,Key)
	{
		Key_Pos := 1
		Loop, Parse, String
		{
			String_XOR .= Chr((Asc(A_LoopField) ^ Asc(SubStr(Key,Key_Pos,1))) + 15)
			Key_Pos += 1
			if (Key_Pos > StrLen(Key))
				Key_Pos := 1
		}
		return String_XOR
	}	
}
return

Menu:
Gui,1:Destroy
Gui,2:Destroy
Gui,2:Color, F2FAFD
Gui,2:Font, Underline
r1 = 
r2 = 
Items = 0
yaxis = 15
for index, element in Array 
{
	StringReplace, element, element, [, , All
	StringReplace, element, element, ], , All
	StringLower, element, element
	if element not contains MSG
	{
		if Items = 0
		{
			xaxis = 10
			yaxis = 15
		}
		else if Items = 6
		{
			xaxis = 135
			yaxis = 15
		}
		else if Items = 12
		{
			xaxis = 260
			yaxis = 15
		}
		Gui,2:Add, Text,x%xaxis% y%yaxis% gStartChat, %element%
		Items++
		yaxis += 20
	}
}
Gui,2:Show,,secret chat
return

StartChat:
{
	WinStatus = Menu
	Sender = %A_GuiControl%
	StringLower, Sender, Sender
	ChatGui()
	WinStatus = Unknown
}
return

emptymem:
{
	dllcall("psapi.dll\EmptyWorkingSet", "UInt", -1) ;tells Windows to minimize memory use for this script.
}
return