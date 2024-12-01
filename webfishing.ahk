#Requires AutoHotkey v2.0

SetDefaultMouseSpeed(0)
CoordMode("Mouse", "Client")
CoordMode("ToolTip", "Client")


; #Include Peep.v2.ahk
TraySetIcon("icon.ico")

; explanation of formats
; array format, an array containing 1-9 arrays, each referring to a preset. only used by the code, not users
; text format, space and newline delimited string, each space seperates one note, each line seperates one preset
; if a line starts with a #, its a comment.
; lines past the first 9 are ignored if they do not start with a # (be careful for songs that haven't got all 9 presets set!), but can be used for metadata not needed ingame, eg the source of the presets etc
; eg
; 0 1 D# A#2 C F (newline)
; F A# D# G# C F
; # this is a comment
; 0 0 0 0 0 0
; etc..
;
; notes / numbers
; numbers start at 1, or the default very top note
; 0 means it is muted, there is no note on that column
; letter notes format can have numbers in them,
; but they should really only be used for muted and default
; unless the whole thing is numbers to avoid confusion
;


; notes := [
;     ["E", "A", "D", "G", "B", "E"],
;     ["F", "A#", "D#", "G#", "C", "F"],
;     ["F#", "B", "E", "A", "C#", "F#"],
;     ["G", "C", "F", "A#", "D", "G"],
;     ["G#", "C#", "F#", "B", "D#", "G#"],
;     ["A", "D", "G", "C", "E", "A"],
;     ["A#", "D#", "G#", "C#", "F", "A#"],
;     ["B", "E", "A", "D", "F#", "B"],
;     ["C", "F", "A#", "D#", "G", "C"],
;     ["C#", "F#", "B", "E", "G#", "C#"],
;     ["D", "G", "C", "F", "A", "D"],
;     ["D#", "G#", "C#", "F#", "A#", "D#"],
;     ["E2", "A2", "D2", "G2", "B2", "E2"],
;     ["F2", "A#2", "D#2", "G#2", "C2", "F2"],
;     ["F#2", "B2", "E2", "A2", "C#2", "F#2"],
;     ["G2", "C2", "F2", "A#2", "D2", "G2"]
; ]

; array of note letters suffixed with 2 for the second note of same letter on each string
notes := [
    ["E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E2", "F2", "F#2", "G2"],
    ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A2", "A#2", "B2", "C2"],
    ["D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D2", "D#2", "E2", "F2"],
    ["G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G2", "G#2", "A2", "A#2"],
    ["B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B2", "C2", "C#2", "D2"],
    ["E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E2", "F2", "F#2", "G2"]
]
info := "f6 - reload script`nf7 - clear tooltip`nf8 - run setup`nf9 - close script`nf10 - open window"

; first launch info
MsgBox("Webfishing Guitar Helper started!`nHotkeys:`n" info)


waitEnter() {
    KeyWait("Enter", "D")
    KeyWait("Enter")
}

checkIfGameRunning() {
    if (!WinExist("ahk_exe webfishing.exe")) {
        a := MsgBox("Webfishing isn't running, but the autohotkey guitar script still is.`nExit the script?`n(press no and you can still add/export presets)", "Webfishing Guitar Helper", "0x4")
        if (a == "Yes") {
            BlockInput ("MouseMoveOff") ; always ensure mouse movement is re-enabled. probably not needed
            ExitApp()
        }
    }
}

setup() {
    ToolTip("Starting setup, open the guitar!`nWe will now setup the note positions..`nPress enter to proceed. Or f6 to cancel.")
    waitEnter()
    ToolTip("Now click on the top right button to set the whole row to 'EADGBE', and position your mouse in the centre of that button.`nPress enter when done")
    waitEnter()
    MouseGetPos(&topButtonX, &topButtonY)
    ToolTip("Done...")
    loop 6 {
        Send("{Left}")
        Sleep(10)
        Send("{Enter}")
        Sleep(100)
    }
    ToolTip("Now position your mouse in the centre of the top left 'E'.`nPress enter when done")
    loop 5 {
        Sleep(500)
        Send("{Enter}")
    }
    waitEnter()
    MouseGetPos(&topLeftX, &topLeftY)
    ToolTip("Now position your mouse in the centre of the bottom right 'G'.`nPress enter when done")
    Send("{Down 15}")
    Send("{Right 5}")
    Sleep(200)
    loop 5 {
        Sleep(500)
        Send("{Enter}")
    }
    waitEnter()
    MouseGetPos(&bottomRightX, &bottomRightY)

    WinGetPos(, , &winWidth, &winHeight, "ahk_exe webfishing.exe")

    ToolTip("")
    MsgBox("got values:`n" topButtonX ", " topButtonY "`n" topLeftX ", " topLeftY "`n" bottomRightX ", " bottomRightY, winWidth, winHeight)
    data :=
        "topButtonX = " topButtonX / winWidth
        . "`ntopButtonY = " topButtonY / winHeight
        . "`ntopLeftX = " topLeftX / winWidth
        . "`ntopLeftY = " topLeftY / winHeight
        . "`nbottomRightX = " bottomRightX / winWidth
        . "`nbottomRightY = " bottomRightY / winHeight
    ; error here can be ignored.
    IniWrite(data, "config.ini", "Button_Positions")

}
~f6:: {
    checkIfGameRunning()
    BlockInput ("MouseMoveOff") ; always ensure mouse movement is re-enabled. probably not needed
    Reload()
}

~f7:: {
    checkIfGameRunning()
    BlockInput ("MouseMoveOff") ; always ensure mouse movement is re-enabled. probably not needed
    ToolTip()
    ToolTip(, , , 2)
}
~f8:: {
    checkIfGameRunning()
    setup()
}

~f9:: {
    BlockInput ("MouseMoveOff") ; always ensure mouse movement is re-enabled. probably not needed
    ExitApp()
}

SendInputForNotes(array) {
    ; first figure out where everything is
    ToolTip()
    topButtonX := IniRead("config.ini", "Button_Positions", "topButtonX", 0)
    topButtonY := IniRead("config.ini", "Button_Positions", "topButtonY", 0)
    topLeftX := IniRead("config.ini", "Button_Positions", "topLeftX", 0)
    topLeftY := IniRead("config.ini", "Button_Positions", "topLeftY", 0)
    bottomRightX := IniRead("config.ini", "Button_Positions", "bottomRightX", 0)
    bottomRightY := IniRead("config.ini", "Button_Positions", "bottomRightY", 0)
    if (
        topButtonX <= 0 ||
        topButtonY <= 0 ||
        topLeftX <= 0 ||
        topLeftY <= 0 ||
        bottomRightX <= 0 ||
        bottomRightY <= 0
    ) {
        MsgBox("the button positions are not set or invalid, run setup first!")
        Return
    }

    a := (bottomRightX - topLeftX) / 5

    columns := [
        (topLeftX + (0 * a)),
        (topLeftX + (1 * a)),
        (topLeftX + (2 * a)),
        (topLeftX + (3 * a)),
        (topLeftX + (4 * a)),
        (topLeftX + (5 * a)),
    ]


    b := (bottomRightY - topLeftY) / 15

    rows := [
        (topLeftY + (0 * b)),
        (topLeftY + (1 * b)),
        (topLeftY + (2 * b)),
        (topLeftY + (3 * b)),
        (topLeftY + (4 * b)),
        (topLeftY + (5 * b)),
        (topLeftY + (6 * b)),
        (topLeftY + (7 * b)),
        (topLeftY + (8 * b)),
        (topLeftY + (9 * b)),
        (topLeftY + (10 * b)),
        (topLeftY + (11 * b)),
        (topLeftY + (12 * b)),
        (topLeftY + (13 * b)),
        (topLeftY + (14 * b)),
        (topLeftY + (15 * b)),
    ]

    ; Peep(rows)
    ; for i, v in rows {
    ;     ToolTip (Text := "a " String(v * winHeight), 500, v * winHeight)
    ;     Sleep(1000)
    ; }

    ; Peep(columns)
    ; Peep(rows)


    window := WinExist("ahk_exe webfishing.exe")

    if (!window) {
        MsgBox("webfishing not open? lol")
        return
    } else {
        while (!WinActive("ahk_exe webfishing.exe")) {
            ToolTip("please focus webfishing!")
            Sleep(500)
        }
        BlockInput ("MouseMove")
        WinGetPos(, , &winWidth, &winHeight, "ahk_exe webfishing.exe")


        ToolTip("")
        for id, value IN array
        {
            Sleep(100)
            Send("{" id " Down}")
            Sleep(100)
            Send("{" id " Up}")
            Sleep(100)
            while (value.Length < 6) {
                value.Push(0)
            }

            ; for each row, id 0 - 6, row 0-15 (0 = none)
            for id, row in value
            {
                sleep(100)
                ; first click on another row, so it doesn't mute it if its already set
                if (row == 0 || !row) {
                    ; ToolTip(columns[id] " " rows[1])
                    ; muted
                    Click(columns[id] * winWidth " " rows[2] * winHeight)
                    Sleep(20)
                    Click(columns[id] * winWidth " " rows[1] * winHeight)
                    Sleep(20)
                    Click(columns[id] * winWidth " " rows[1] * winHeight)
                    Sleep(20)
                } else {
                    if (row == 16) {
                        Click(columns[id] * winWidth " " rows[15] * winHeight)
                        Sleep(30)
                        Click(columns[id] * winWidth " " rows[16] * winHeight)
                    } else {
                        Click(columns[id] * winWidth " " rows[row + 1] * winHeight)
                        Sleep(30)
                        Click(columns[id] * winWidth " " rows[row] * winHeight)
                        Sleep(30)

                    }
                }
            }
        }
    }
    BlockInput ("MouseMoveOff")

}


convertNotesArrayToText(array) {
    ; Peep(array)
    for row in array {
        rowText := ""  ; Initialize a string to store the current row
        for element in row {
            rowText .= element . ","
            spaces := 3 - StrLen(element)
            loop spaces {
                rowText := rowText . " "
            }
        }
        ; Remove the last comma and space from the rowText
        rowText := SubStr(rowText, 1, -2)
        text .= "[" rowText "], `n"  ; Append the row text to the final text
    }
    ; remove final newline
    text := SubStr(text, 1, -2)
    return text
}

f10:: {
    checkIfGameRunning()
    ; static so isnt reset
    ; show gui
    static mainGui := Gui()
    disablebuttons := 1
    ListBox := mainGui.Add("ListBox", "x10 y8 w195 h160",)
    ButtonAdd := mainGui.Add("Button", "x210 y8 w80 h23", "Add...")
    ButtonRemove := mainGui.Add("Button", "x210 y32 w80 h23 Disabled" disablebuttons, "Remove")
    ButtonExport := mainGui.Add("Button", "x210 y56 w80 h23 Disabled" disablebuttons, "Export")
    ButtonTooltip := mainGui.Add("Button", "x210 y110 w80 h32 Disabled" disablebuttons, "Show Tooltip Again")

    ButtonChoose := mainGui.Add("Button", "x210 y144 w80 h23 Disabled" disablebuttons, "&Choose")

    mainGui.Add("Text", "x10 y180 w315 h2 +0x10")
    Note := mainGui.Add("Text", "x10 y185 w150 h125", "Hotkeys for this script: `n" info)
    Note2 := mainGui.Add("Text", "x160 y185 w140 h125", "Note: this script continues running even after you close the game. You can always press f9 to exit, or close it in the tray.")


    ListBox.OnEvent("Change", OnChange)

    ButtonAdd.OnEvent("Click", OnAdd)
    ButtonRemove.OnEvent("Click", OnDelete)
    ButtonExport.OnEvent("Click", OnExport)
    ButtonTooltip.OnEvent("Click", OnTooltip)

    ButtonChoose.OnEvent("Click", OnChoose)
    mainGui.Title := "Window"

    OnChange(*) {
        ButtonRemove.Opt("-Disabled")
        ButtonExport.Opt("-Disabled")
        ButtonChoose.Opt("-Disabled")
    }

    OnDelete(*) {
        ToolTip("this isn't implemented yet. you can delete presets from the 'songs/' folder for now!")
        SetTimer () => ToolTip(), -5000 ; tooltip timer
    }

    OnTooltip(*) {
        filePath := A_ScriptDir "/songs/" ListBox.Text
        mainGui.Minimize()
        ; start
        ToolTip()
        notes := FileRead(filePath)
        ; ToolTip("File: " filePath)
        Sleep(100)
        array := textToArray(notes)
        ; Peep(array)
        MouseGetPos(&oldX, &oldY)
        MouseMove(0, 0, 1)
        Sleep(50)
        ToolTip(getComments(notes), , , 2)
        Sleep(50)
        MouseMove(oldX, oldY, 2)
    }

    OnExport(*) {
        filePath := A_ScriptDir "/songs/" ListBox.Text
        ; ToolTip("Exporting file to clipboard..")
        myGui3 := Gui()
        myGui3.Opt("+Owner" mainGui.Hwnd)
        mainGui.Opt("+Disabled")  ; Force the user to dismiss this window before returning to the main window.
        myGui3.AddText("r1 x10 y5", "Exporting file " . filePath)
        DropDown := myGui3.AddDropDownList("x10 y24 w180", ["Letters (Suggested)", "Numbers"])
        DropDown.Value := 1
        ButtonCopy := myGui3.Add("Button", "x10 y48 w80 h23", "&Copy")
        myGui3.Add("Text", "x10 y80 w270 h50", "You can also share the files in the songs folder manually")
        ButtonCopy.OnEvent("Click", OnCopy)

        myGui3.OnEvent('Close', (*) =>
            mainGui.Opt("-Disabled")
            ControlFocus(mainGui.Hwnd))

        myGui3.Title := "Export..."
        myGui3.Show("w640 h250")

        OnCopy(*) {
            option := DropDown.Value
            ; ToolTip("selected" . option)
            ; read the file
            contents := FileRead(filePath)
            ; ToolTip("File: " filePath)
            Sleep(100)

            arrayOfText := StrSplit(Trim(contents), "`n", "`r")

            presetcount := 1
            text := ""

            for i, v in arrayOfText {
                ; for each line

                ; Peep(v)
                if (SubStr(Trim(v), 1, 1 == "#")) {
                    ; if its a comment, dont increase presetcount
                    ; but still output
                    text .= v "`n"
                } else {
                    ; this *should* be a preset if presetcount <= 9
                    if (presetcount <= 9) {
                        ; this is a preset
                        ; read the line and convert to letters

                        array := convertOneLineToArray(v)
                        res := normaliseNotesArrayToNumbersOnce(array)
                        ; Peep(res)
                        text .= ConvertNumbersToLettersOnce(res.array) "`n"

                        ; Peep(text)
                        presetcount++
                    } else {
                        ; this is a hidden (file only) comment
                        ; so still output it for exporting!
                        text .= v "`n"
                    }
                }
            }

            ;;;;;; instead of all this faff, why not just store them as letters and return the file? i dont like this format anyway!
            ; array := textToArray(contents)
            ; ; Peep(array)
            ; text := ""

            ; switch (option) {
            ;     case 1:
            ;     {
            ;         ; if "Letters" selected
            ;         letters := ConvertNumbersToLetters(array)
            ;         text .= letters "`n"
            ;     }
            ;     case 2:
            ;     {
            ;         ; if "Numbers" selected
            ;         text .= arrayToSpaces(array, 1)
            ;     }
            ; }
            ; text .= getComments(contents, true)
            A_Clipboard := text
            ToolTip("Copied to clipboard!")
            myGui3.Destroy()
            mainGui.Opt("-Disabled")
            ControlFocus(mainGui.Hwnd)
            SetTimer () => ToolTip(), -5000
        }
    }

    OnChoose(*) {
        filePath := A_ScriptDir "/songs/" ListBox.Text
        mainGui.Minimize()
        ; MsgBox("Remember to not move your mouse while the guitar is being set!`nClose this popup then open the guitar and press enter.`nFile: " filePath)
        ToolTip("Open the guitar, then press enter!`nOr f6 to cancel")
        key := KeyWait("Enter", "D T6")
        if (key) {
            ; start
            ToolTip()
            notes := FileRead(filePath)
            ; ToolTip("File: " filePath)
            Sleep(100)
            array := textToArray(notes)
            ; Peep(array)
            MouseGetPos(&oldX, &oldY)
            SendInputForNotes(array)
            MouseMove(0, 0, 1)
            Sleep(50)
            ToolTip(getComments(notes), , , 2)
            Sleep(50)
            MouseMove(oldX, oldY, 2)
            ButtonTooltip.Opt("-Disabled")
        } else {
            ToolTip("Cancelled!")
            Sleep(5000)
            ToolTip()
        }
    }

    OnAdd(*) {
        ; show another gui popup.
        myGui2 := Gui()
        myGui2.Opt("+Owner" mainGui.Hwnd)
        mainGui.Opt("+Disabled")  ; Force the user to dismiss this window before returning to the main window.
        ; add components
        myGui2.AddText("r1 x10 y5", "Name:")
        EditNameInput := myGui2.Add("Edit", "r1 x10 y20 w100 h20")
        myGui2.AddText("r1 x10 y45", "Notes:")
        myGui2.AddText("r1 x150 y45", "Notes:")
        myGui2.AddText("r1 x360 y45", "Notes:")
        EditNotesInput := myGui2.Add("Edit", "r9 x10 y60 w130 +Multi")
        EditNotesPreview := myGui2.Add("Edit", "ReadOnly r9 x150 y60 w190")
        EditNotesPreview2 := myGui2.Add("Edit", "ReadOnly r9 x360 y60 w190")
        EditNotesPreview.SetFont(, "Consolas")
        EditNotesPreview2.SetFont(, "Consolas")
        ; ButtonCheck := myGui2.Add("Button", "x144 y180 w80 h23 Disabled", "Check")
        ButtonAdd2 := myGui2.Add("Button", "10 y200 w80 h23", "&Add")

        ; events
        EditNotesInput.OnEvent("Change", OnEdit)
        ; ButtonCheck.OnEvent("Click", OnEdit)
        ButtonAdd2.OnEvent("Click", OnSave)
        myGui2.OnEvent('Close', (*) =>
            mainGui.Opt("-Disabled")
            ControlFocus(mainGui.Hwnd))


        ; show window
        myGui2.Title := "Window"
        myGui2.Show("w640 h250")
        newNotesArray := []


        OnEdit(*) {
            ; ToolTip(EditNotesInput.Text)
            notestext := EditNotesInput.Text
            notesArray := []
            ; if array format
            ; if (InStr(notestext, "[")) {
            ;     ToolTip("you cant use arrays here!")
            ; } else {
            ; assume text format, convert to array
            notesArray := textToArray(notestext)
            ; convert array to numbers
            newNotesArray := normaliseNotesArrayToNumbers(notesArray)
            EditNotesPreview.Value := Trim(arrayToSpacesPretty(newNotesArray))
            EditNotesPreview2.Value := Trim(ConvertNumbersToLetters(newNotesArray))
            ; }
        }
        ; when add button clicked..
        OnSave(*) {
            filePath := A_ScriptDir "\songs\" Trim(EditNameInput.Value) ".txt"
            if (FileExist(filepath)) {
                MsgBox("File already exists! " filePath)
                return
            }
            if (StrLen(EditNameInput.Value) < 1) {
                MsgBox("You must set a file name!")
                return
            }

            presetcount := 1
            text := ""
            fulltext := EditNotesInput.Text
            linesarray := StrSplit(Trim(fulltext), "`n", "`r")

            for linenum, line in linesarray {

                ; similar to oncopy
                ; for each line

                ; Peep(v)
                if (SubStr(Trim(fulltext), 1, 1 == "#")) {
                    ; if its a comment, dont increase presetcount
                    ; but still output
                    text .= line "`n"
                } else {
                    ; this *should* be a preset if presetcount <= 9
                    if (presetcount <= 9) {
                        ; this is a preset
                        ; read the line and convert to letters

                        array := convertOneLineToArray(line)
                        res := normaliseNotesArrayToNumbersOnce(array)
                        text .= arrayToSpacesOnce(res.array) "`n"
                        ; Peep(text)
                        presetcount++
                    } else {
                        ; this is a hidden (file only) comment
                        ; so still output it for exporting!
                        text .= line "`n"
                    }
                }


            }
            ; valueSpaced := Trim(arrayToSpaces(newNotesArray))
            FileAppend(text, filePath)
            myGui2.Destroy()
            mainGui.Opt("-Disabled")
            ControlFocus(mainGui.Hwnd)
            ; refresh listbox
            ListBox.Delete()
            loop files A_ScriptDir "\songs\*.txt" {
                ListBox.Add([A_LoopFileName])
            }
        }
    }


    mainGui.Show("w300 h280")
    ListBox.Delete()
    loop files A_ScriptDir "\songs\*.txt" {
        ListBox.Add([A_LoopFileName])
    }
}


getComments(text, includeAll := false) {
    output := ""
    arrayOfText := StrSplit(Trim(text), "`n", "`r")
    for i, v in arrayOfText {
        if (includeAll) {
            if (SubStr(v, 1, 1) == "#") {
                ; this is a comment
                ; strip #
                output .= Trim(SubStr(v, 2)) "`n"
            }

        } else {
            if (SubStr(v, 1, 1) == "#" || i > 9) {
                output .= v "`n"
            }
        }
    }
    return output
}


getArrayValueIndex(arr, val) {
    Loop arr.Length {
        if (arr[A_Index] == Trim(val))
            return A_Index
    }
    return -1
}

; convert letters to array of array of note numbers
normaliseNotesArrayToNumbers(array) {
    issues := []
    output := []
    for i, v in array {
        row := v
        res := normaliseNotesArrayToNumbersOnce(row)
        newarray := res.array
        if (res.issues) {
            issues.Push(res.issues)
        }
        output.push(newarray)
    }
    ; if (StrLen(issues) > 1) {
    ; Peep(issues)

    if (issues.Length) {
        text := ""
        for i, v in issues {
            text .= v "`n"
        }
        ToolTip("issues: " text, , , 2)
    } else {
        ToolTip(, , , 2)
    }
    ; }
    return output
}

normaliseNotesArrayToNumbersOnce(array) {
    newarray := []
    issues := ""
    for index, value in array {
        value := Trim(StrUpper(value))
        ; noteletter := value
        notenumber := 0
        ; MsgBox(index " : " value)
        ; if it is already a number
        if (IsNumber(value)) {
            if (value > 16 || value < 0) {
                issues .= value " invalid (0)`n"
                notenumber := 0
            } else {
                notenumber := value
            }
        } else {
            ; handle 1 character
            if (StrLen(value) == 1) {
                if (value == "X") {
                    ; unset note
                    notenumber := 0
                } else {
                    noteletter := value
                    arrayIndex := getArrayValueIndex(notes[index], noteletter)
                    if (arrayIndex == -1) {
                        issues .= value " invalid (1)`n"
                        notenumber := 0
                    } else {
                        notenumber := arrayIndex
                    }
                }
            }

            ; two character
            else if (StrLen(value) == 2) {
                ; if the string is like "E#"
                if (SubStr(value, 2, 1) == "#") {
                    ; all is well
                    noteletter := SubStr(value, 1, 2)
                }
                ; if it has a 1, remove it
                else if (SubStr(value, 2, 1) == "1") {
                    noteletter := SubStr(value, 1, 1)
                }
                ; if it has a 2, keep it
                else if (SubStr(value, 2, 1) == "2") {
                    noteletter := SubStr(value, 1, 2)
                } else {
                    ; invalid letter
                    ; MsgBox("invalid: " value " / " value)
                    issues .= value " invalid (2, 1)`n"

                    noteletter := 0
                }
                arrayIndex := getArrayValueIndex(notes[index], noteletter)
                if (arrayIndex == -1) {
                    issues .= value " invalid (2, 2)`n"
                    notenumber := 0
                } else {
                    notenumber := arrayIndex
                }

                ; 3 character
            } else if (StrLen(value) == 3) {
                if (SubStr(value, 3, 1) == "1") {
                    noteletter := SubStr(value, 1, 2)
                    ; MsgBox(noteletter)
                }
                else if (SubStr(value, 3, 1) == "2") {
                    noteletter := SubStr(value, 1, 3)
                } else {
                    ; invalid
                    ; MsgBox("invalid: " value " / " noteletter)
                    issues .= value " invalid (3, 1)`n"
                    noteletter := 0
                }
                arrayIndex := getArrayValueIndex(notes[index], noteletter)
                if (arrayIndex == -1) {
                    issues .= value " invalid (3, 2)`n"

                    notenumber := 0
                } else {
                    notenumber := arrayIndex
                }
            } else {
                ; MsgBox("' " value " ' Is Invalid!!")
                issues .= value " invalid`n"
                notenumber := 0
            }


        }
        newarray.Push(notenumber)
    }
    return { array: newarray, issues: issues }
}

; convert array to text with spaces
arrayToSpaces(array, maxSpaces := 3) {
    while (array.Length < 9) {
        array.Push([0, 0, 0, 0, 0, 0])
    }
    text := ""
    num := 0
    loop 9 {
        num += 1
        row := array[num]
        text .= arrayToSpacesOnce(row, maxSpaces) "`n"
    }
    ; remove final newline
    text := SubStr(text, 1, -2)
    return text
}
arrayToSpacesWithComments(array, maxSpaces := 3) {

}

arrayToSpacesOnce(array, maxSpaces := 3) {
    rowText := ""  ; Initialize a string to store the current row
    for element in array {
        rowText .= element . " "
        spaces := maxSpaces - StrLen(element)
        loop spaces {
            rowText := rowText . " "
        }
    }
    return rowText  ; Append the row text to the final text
}

; used for gui with numbers per line
arrayToSpacesPretty(array) {
    text := ""
    for i, row in array {
        rowText := ""  ; Initialize a string to store the current row
        for element in row {
            rowText .= element . " "
            spaces := 3 - StrLen(element)
            loop spaces {
                rowText := rowText . " "
            }
        }
        text .= i ": " rowText "`n"  ; Append the row text to the final text
    }
    ; if (StrLen(text) == 0) {

    ; } else {
    ; remove final newline
    text := SubStr(text, 1, -2)
    ; }
    return text
}

; convert a space and newline delimited string into an array of arrays containing the text
textToArray(text) {
    text := Trim(text, " `n`r`t")
    ; split by newlines
    arrayOfText := StrSplit(Trim(text), "`n", "`r")
    ; Peep(arrayOfText)
    newArray := []

    linenumber := 1
    ; for each array split by newline
    for i, v in arrayOfText {
        ; if its after 9th row, dont do anything
        if (linenumber > 9) {
            continue
        }
        ; ignore comments
        if (SubStr(Trim(arrayOfText[i]), 1, 1) == "#")
        {
            continue
        }

        newArray.push(convertOneLineToArray(arrayOfText[i]))
        linenumber += 1
    }
    ; Peep(newArray)
    return newArray
}

convertOneLineToArray(text) {
    ; add to newArray
    line := StrSplit(Trim(text), " ")
    ; ensure any unnecessary spaces are removed
    newline := []
    for i, v in line {
        if (StrLen(v) > 0) {
            newline.Push(v)
        }
    }
    line := newline

    ; ensure line is exactly 6 long
    while (line.Length < 6) {
        line.Push(0)
    }
    while (line && line.Length > 6) {
        line.Pop()
    }
    return line
}

; converts numbers in an array to letters as text
ConvertNumbersToLetters(array, spaceChar := " ", spacelen := 4) {
    text := ""
    ; 1-9 for each preset
    for i, notespreset in array {
        text .= ConvertNumbersToLettersOnce(notespreset, spaceChar, spacelen) "`n"  ; Append the row text to the final text
    }
    ; if (StrLen(text) == 0) {

    ; } else {
    ; remove final newline
    text := SubStr(text, 1, -2)
    ; }
    return text
}

ConvertNumbersToLettersOnce(array, spaceChar := " ", spacelen := 4) {
    text := ""
    ; Peep(notespreset)
    ; i is index 1-9
    ; notes is the array of note strings
    ; for each note
    for i, note in array {
        if (note == 0) {
            letternote := "x"
        } else {
            column := notes[i]
            letternote := column[Integer(note)]
        }
        text .= letternote
        spaces := spacelen - StrLen(letternote)
        loop spaces {
            text .= spaceChar
        }
        ; Peep(rowText)
    }

    ; add space
    ; text .= " "

    return text
}

; rebind numpad to number keys
#HotIf WinActive('WEBFISHING')
SC04F::1
SC050::2
SC051::3
SC04B::4
SC04C::5
SC04D::6
SC047::7
SC048::8
SC049::9
SC052::0

; quick reload when editing
#HotIf WinActive(A_ScriptName " ahk_exe Code.exe")
~^s::
{
    ; Send("^s")
    ToolTip("Reloading " A_ScriptName ".", A_ScreenWidth / 2, A_ScreenHeight / 2)
    Sleep(250)
    Reload()
    ; MsgBox("reloading !")
    Return
}