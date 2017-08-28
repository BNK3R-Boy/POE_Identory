#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#InstallMouseHook
#InstallKeybdHook
Menu, Tray, Icon, %A_ScriptDir%\poe.ico
CoordMode, Mouse, Window
CoordMode, ToolTip, Window
SetDefaultMouseSpeed, 0

Global tlx:=1293
Global tly:=611

Global ibw:=53
Global ibh:=53

Global worldsleeps:=100                 ; If u have a high ping u need a higher value like 250
Global itoggle:=false

#IfWinActive, ahk_class POEWindowClass

+F5::
  itoggle:=!itoggle

  If itoggle
    SetTimer, identify_inventory, 0
  Else
    SetTimer, identify_inventory, Off

Return


identify_inventory:
  MouseGetPos, xpos, ypos

  ToolTip, ... abait abait ...,tlx,tly-80
  Send, {Shift Down}
  MouseClick, right, tlx, tly
  Sleep, worldsleeps

  Loop, 5
  {
    row:=a_index
    ny:=((row-1)*ibh)+tly

    Loop, 12
    {
      col:=a_index
      nx:=((col-1)*ibw)+tlx

      If !(row==1 AND (col==1 OR col==2))
      {
        PixelSearch, Px, Py, nx, ny, nx, ny, 0x080808, 3, Fast
        found1:=ErrorLevel

        If found1 AND itoggle
        {

          If (row > 3)
          {
            chkHigh:=3*ibh
          }
          Else
          {
            chkHigh:=row*ibh
          }

          If (col == 11) OR (col == 12)
          {
            chkX:=ibw*2
          }
          Else
          {
            chkX:=0
          }

          MouseMove, nx, ny

          PixelSearch, Px, Py, nx-20-chkX, ny-chkHigh, nx-10-chkX, ny, 0x0000D2, 10, Fast
          found2:=ErrorLevel

          IF !found2
          {
            Send, {Shift Down}
            MouseClick, left, nx, ny
            Sleep, worldsleeps
          }
        }
      }

      If !itoggle
        Break
    }

    If !itoggle
      Break
  }

  Send, {Shift Up}
  MouseClick, left, tlx, 0
  MouseMove, xpos, ypos

  itoggle:=false
  SetTimer, identify_inventory, Off

  ToolTip, ... Fettich! ...,tlx,tly-80
  Sleep, 1000
  ToolTip,
Return
