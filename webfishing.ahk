#Requires AutoHotkey v2.0

SetDefaultMouseSpeed(0)
CoordMode("Mouse", "Client")
CoordMode("ToolTip", "Client")


#Include Peep.v2.ahk
TraySetIcon("icon.ico")

; explanation of formats
; array format, an array containing 1-9 arrays, each referring to a preset. only used by the code, not users
; text format, space and newline delimited string, each space seperates one note, each line seperates one preset
; if a line starts with a #, its ignored as a comment.
; lines past the first 9 are also ignored. (be careful for songs that haven't got all 9 presets set!)
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


; 0 -> 15
; columns := [0, 0, 0, 1, 13]


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

; left to right, top to bottom
; array of note letters suffixed with 2 for the second on each string
notes := [
    ["E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E2", "F2", "F#2", "G2"],
    ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A2", "A#2", "B2", "C2"],
    ["D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D2", "D#2", "E2", "F2"],
    ["G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G2", "G#2", "A2", "A#2"],
    ["B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B2", "C2", "C#2", "D2"],
    ["E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "D#", "E2", "F2", "F#2", "G2"]
]


tuning := ""
; y 130 -> 1360
; rows := [130, 210, 290, 375, 450, 540, 620, 700, 790, 870, 950, 1035, 1110, 1200, 1280, 1360]
; rows := [0.09027777777777778,
;     0.14,
;     0.20,
;     0.26,
;     0.31,
;     0.37,
;     0.43,
;     0.48,
;     0.54,
;     0.60,
;     0.65,
;     0.71,
;     0.77,
;     0.83,
;     0.88,
;     0.94]
; ; x 460 -> 680
; ; columns := [460, 500, 550, 590, 640, 680]
; columns :=
;     [0.179, 0.195, 0.214, 0.23, 0.25, 0.265]
waitEnter() {
    KeyWait("Enter", "D")
    KeyWait("Enter")
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
    MsgBox("got values:`n" topButtonX ", " topButtonY "`n" topLeftX ", " topLeftY "`n" bottomRightX ", " bottomRightY)
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
f6:: {
    Reload()
}

f7:: {
    ToolTip()
    ToolTip(, , , 2)
}
f8:: {
    setup()
}

f9:: {
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
        topButtonX >= 0 ||
        topButtonY >= 0 ||
        topLeftX >= 0 ||
        topLeftY >= 0 ||
        bottomRightX >= 0 ||
        bottomRightY >= 0
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
    ; show gui
    myGui := Gui()
    ListBox := myGui.Add("ListBox", "x10 y8 w120 h160",)
    ButtonChoose := myGui.Add("Button", "x136 y144 w80 h23", "&Choose")
    ButtonAdd := myGui.Add("Button", "x136 y8 w80 h23", "Add...")
    ButtonRemove := myGui.Add("Button", "x136 y32 w80 h23", "Remove")
    ButtonExport := myGui.Add("Button", "x136 y56 w80 h23", "Export")
    ButtonChoose.OnEvent("Click", OnChoose)
    ButtonAdd.OnEvent("Click", OnAdd)
    ButtonRemove.OnEvent("Click", OnDelete)
    ButtonExport.OnEvent("Click", OnExport)
    myGui.Title := "Window"

    OnDelete(*) {
        ToolTip("this isn't implemented yet. you can delete presets from the 'songs/' folder for now!")
        SetTimer () => ToolTip(), -5000 ; tooltip timer
    }

    OnExport(*) {
        filePath := A_ScriptDir "/songs/" ListBox.Text
        ToolTip("Exporting file to clipboard..")
        myGui3 := Gui()
        myGui3.Opt("+Owner" myGui.Hwnd)
        myGui.Opt("+Disabled")  ; Force the user to dismiss this window before returning to the main window.
        myGui3.AddText("r1 x10 y5", "Exporting file " . filePath)
        DropDown := myGui3.AddDropDownList("x10 y24 w180", ["Letters (Suggested)", "Numbers"])
        DropDown.Value := 1
        ButtonCopy := myGui3.Add("Button", "x10 y48 w80 h23", "&Copy")
        ButtonCopy.OnEvent("Click", OnCopy)

        myGui3.Title := "Window"
        myGui3.Show("w640 h250")

        OnCopy(*) {
            option := DropDown.Value
            ToolTip("selected" . option)
            ; read the file
            notes := FileRead(filePath)
            ; ToolTip("File: " filePath)
            Sleep(100)
            array := textToArray(notes)
            Peep(array)

            switch (option) {
                case 1:
                {
                    ; if "Letters" selected
                    letters := ConvertNumbersToLetters(array)
                    A_Clipboard := letters
                }
                case 2:
                {
                    ; if "Numbers" selected
                    A_Clipboard := arrayToSpaces(array, 1)
                }
            }
        }


    }

    OnChoose(*) {
        filePath := A_ScriptDir "/songs/" ListBox.Text
        myGui.Destroy()
        ; MsgBox("Remember to not move your mouse while the guitar is being set!`nClose this popup then open the guitar and press enter.`nFile: " filePath)
        ToolTip("Open the guitar, then press enter!")
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
            Sleep(10)
            ToolTip(getComments(notes), , , 2)
            Sleep(10)
            MouseMove(oldX, oldY, 2)
        } else {
            ToolTip("Cancelled!")
            Sleep(5000)
            ToolTip()
        }
    }

    OnAdd(*) {
        ; show another gui popup.
        myGui2 := Gui()
        myGui2.Opt("+Owner" myGui.Hwnd)
        myGui.Opt("+Disabled")  ; Force the user to dismiss this window before returning to the main window.
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
        myGui2.OnEvent('Close', (*) => myGui.Opt("-Disabled"))


        ; show window
        myGui2.Title := "Window"
        myGui2.Show("w640 h250")
        newNotesArray := []


        OnEdit(*) {
            ; ToolTip(EditNotesInput.Text)
            notestext := EditNotesInput.Text
            notesArray := []
            ; if array format
            if (InStr(notestext, "[")) {
                ToolTip("you cant use arrays here!")
            } else {
                ; assume text format, convert to array
                notesArray := textToArray(notestext)
                ; convert array to numbers
                newNotesArray := convertLetters(notesArray)
                EditNotesPreview.Value := Trim(arrayToSpacesPretty(newNotesArray))
                EditNotesPreview2.Value := Trim(arrayToSpaces(newNotesArray))
            }
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

            valueSpaced := Trim(arrayToSpaces(newNotesArray))
            FileAppend(valueSpaced, filePath)
            myGui.Opt("-Disabled")
            myGui2.Destroy()
            ; refresh listbox
            ListBox.Delete()
            loop files A_ScriptDir "\songs\*.txt" {
                ListBox.Add([A_LoopFileName])
            }
        }
    }


    myGui.Show("w223 h176")
    ListBox.Delete()
    loop files A_ScriptDir "\songs\*.txt" {
        ListBox.Add([A_LoopFileName])
    }
}


getComments(text) {
    output := ""
    arrayOfText := StrSplit(Trim(text), "`n", "`r")
    for i, v in arrayOfText {
        if (SubStr(v, 1, 1) == "#") {
            ; this is a comment
            ; strip #
            output .= Trim(SubStr(v, 2)) "`n"
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
convertLetters(array) {
    issues := ""
    output := []
    for i, v in array {
        row := v
        newarray := []
        for index, value in row {
            value := Trim(StrUpper(value))
            ; noteletter := value
            notenumber := 0
            ; MsgBox(index " : " value)
            ; if it is already a number
            if (IsNumber(value)) {
                if (value > 16 || value < 0) {
                    issues := issues value " invalid (0)`n"
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
                            issues := issues value " invalid (1)`n"
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
                        issues := issues value " invalid (2, 1)`n"

                        noteletter := 0
                    }
                    arrayIndex := getArrayValueIndex(notes[index], noteletter)
                    if (arrayIndex == -1) {
                        issues := issues value " invalid (2, 2)`n"
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
                        issues := issues value " invalid (3, 1)`n"
                        noteletter := 0
                    }
                    arrayIndex := getArrayValueIndex(notes[index], noteletter)
                    if (arrayIndex == -1) {
                        issues := issues value " invalid (3, 2)`n"

                        notenumber := 0
                    } else {
                        notenumber := arrayIndex
                    }
                } else {
                    ; MsgBox("' " value " ' Is Invalid!!")
                    issues := issues value " invalid`n"
                    notenumber := 0
                }


            }
            newarray.Push(notenumber)
        }
        output.push(newarray)
    }
    ; if (StrLen(issues) > 1) {
    if (StrLen(issues)) {
        ToolTip("issues: " issues, , , 2)
    } else {
        ToolTip(, , , 2)
    }
    ; }
    return output
}

arrayToSpaces(array, maxSpaces := 3) {
    while (array.Length < 9) {
        array.Push([0, 0, 0, 0, 0, 0])
    }
    num := 0
    loop 9 {
        num += 1
        row := array[num]
        rowText := ""  ; Initialize a string to store the current row
        for element in row {
            rowText .= element . " "
            spaces := maxSpaces - StrLen(element)
            loop spaces {
                rowText := rowText . " "
            }
        }
        text .= rowText "`n"  ; Append the row text to the final text
    }
    ; remove final newline
    text := SubStr(text, 1, -2)
    return text
}

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
    text := Trim(text, "     `n`r`t")
    ; split by newlines
    arrayOfText := StrSplit(Trim(text), "`n", "`r")
    ; Peep(arrayOfText)
    newArray := []

    linenumber := 1
    ; for each array split by newline
    for i, v in arrayOfText {
        ; if its too high, dont do anything
        if (linenumber > 9) {
            continue
        }
        ; ignore comments
        if (SubStr(Trim(arrayOfText[i]), 1, 1) == "#")
        {
            continue
        }

        ; add to newArray
        line := StrSplit(Trim(arrayOfText[i]), " ")
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
        newArray.push(line)
        linenumber += 1
    }
    ; Peep(newArray)
    return newArray
}

ConvertNumbersToLetters(array, spaceChar := " ") {
    text := ""
    ; 1-9 for each preset
    for i, notespreset in array {
        Peep(notespreset)
        ; i is index 1-9
        ; notes is the array of note strings
        rowText := ""  ; Initialize a string to store the current row
        ; for each note
        for i, note in notespreset {
            if (note == 0) {
                letternote := "x"
            } else {
                column := notes[i]
                letternote := column[Integer(note)]
            }
            rowText .= letternote
            spaces := 3 - StrLen(letternote)
            loop spaces {
                rowText .= spaceChar
            }
            Peep(rowText)
        }

        ; add space
        ; rowText .= " "

        text .= rowText "`n"  ; Append the row text to the final text
    }
    ; if (StrLen(text) == 0) {

    ; } else {
    ; remove final newline
    text := SubStr(text, 1, -2)
    ; }
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