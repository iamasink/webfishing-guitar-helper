#Requires AutoHotkey v2.0

SetDefaultMouseSpeed(1)

#Include Peep.v2.ahk

; explanation of formats
; array format, an array containing 1-9 arrays, each referring to a preset
; text format, space and newline delimited string, each space seperates one note, each line seperates one preset
; eg
; 0 1 D# A#2 C F (newline)
; F A# D# G# C F
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
rows := [130, 210, 290, 375, 450, 540, 620, 700, 790, 870, 950, 1035, 1110, 1200, 1280, 1360]
; x 460 -> 680
columns := [460, 500, 550, 590, 640, 680]

f12:: {
    text := ""
    ; for each of 1-9 presets:
    for id, value IN tuning
    {
        ToolTip(id)
        Send("{" id " Down}")
        Sleep(100)
        Send("{" id " Up}")
        text := text "`n" id " : "
        while (value.Length != 6) {
            value.Push(0)
        }

        ; for each column, id 0 - 6, column 0-15 (0 = none)
        for id, column in value
        {
            text := text "`n" id " : " column
            if (column == 0 || !column) {
                ; ToolTip(columns[id] " " rows[1])
                Click(columns[id] " " rows[1])
                Sleep(50)
                Click(columns[id] " " rows[1])
                Sleep(10)
            } else {
                ToolTip(columns[id] " " rows[column])
                if (column == 1) {
                    Click(columns[id] " " rows[2])
                    Sleep(10)
                    Click(columns[id] " " rows[1])
                } else {
                    Click(columns[id] " " rows[column - 1])
                    Sleep(50)
                    Click(columns[id] " " rows[column])
                    Sleep(10)

                }
            }
        }

    }
    ; Click(columns[column])
    ; ToolTip(text)
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
    ListBox := myGui.Add("ListBox", "x8 y8 w120 h160",)
    ButtonChoose := myGui.Add("Button", "x136 y144 w80 h23", "&Choose")
    ButtonAdd := myGui.Add("Button", "x136 y8 w80 h23", "Add...")
    ButtonRemove := myGui.Add("Button", "x136 y32 w80 h23", "Remove")
    ButtonChoose.OnEvent("Click", OnEventHandler)
    ButtonAdd.OnEvent("Click", OnAdd)
    ButtonRemove.OnEvent("Click", OnEventHandler)
    myGui.Title := "Window"

    OnEventHandler(*) {
        ToolTip("Click! This is a sample action.`n"
            . "Active GUI element values include:`n"
            . "ButtonChoose => " ButtonChoose.Text "`n"
            . "ButtonAdd => " ButtonAdd.Text "`n"
            . "ButtonRemove => " ButtonRemove.Text "`n", 77, 277)
        SetTimer () => ToolTip(), -3000 ; tooltip timer
    }

    OnAdd(*) {

        ; show another gui popup.
        myGui2 := Gui()
        myGui2.Opt("+Owner" myGui.Hwnd)
        myGui.Opt("+Disabled")  ; Force the user to dismiss this window before returning to the main window.
        ; add components
        EditNameInput := myGui2.Add("Edit", "r1 x8 y8 w100 h20")
        EditNotesInput := myGui2.Add("Edit", "r9 x8 y40 w131 h121 +Multi")
        EditNotesPreview := myGui2.Add("Edit", "ReadOnly r9 x144 y40 w180 h121")
        EditNotesPreview2 := myGui2.Add("Edit", "ReadOnly r9 x320 y40 w180 h121")
        EditNotesPreview.SetFont(, "Consolas")
        EditNotesPreview2.SetFont(, "Consolas")
        ; ButtonCheck := myGui2.Add("Button", "x144 y180 w80 h23 Disabled", "Check")
        ButtonAdd2 := myGui2.Add("Button", "x144 y200 w80 h23", "&Add")

        ; events
        EditNotesInput.OnEvent("Change", OnEdit)
        ; ButtonCheck.OnEvent("Click", OnEdit)
        ButtonAdd2.OnEvent("Click", OnAdd)
        myGui2.OnEvent('Close', (*) => myGui.Opt("-Disabled"))


        ; show window
        myGui2.Title := "Window"
        myGui2.Show("w400 h250")

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
                EditNotesPreview.Value := Trim(convertNotesArrayToText(newNotesArray))
                EditNotesPreview2.Value := Trim(arrayToSpacesPretty(newNotesArray))
            }
        }
        ; when add button clicked..
        OnAdd(*) {
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

f9:: {
    text := A_Clipboard
    Peep(textToArray(text))
    ; A_Clipboard := text
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
    output := [
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
    ]
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
                notenumber := value

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
        output[i] := newarray
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

arrayToSpaces(array) {
    for row in array {
        rowText := ""  ; Initialize a string to store the current row
        for element in row {
            rowText .= element . " "
            spaces := 3 - StrLen(element)
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
    ; remove final newline
    text := SubStr(text, 1, -2)
    return text
}

; convert a space and newline delimited string into an array of arrays containing the text
textToArray(text) {
    text := Trim(text)
    ; split by newlines
    arrayOfText := StrSplit(Trim(text), "`n", "`r")
    newArray := [
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
    ]
    ; for each array split by newline
    for i, v in arrayOfText {
        if (i > 9) {
            continue
        }
        ; add to newArray
        line := StrSplit(Trim(arrayOfText[i]), " ")
        while (line && line.Length > 6) {
            line.Pop()
        }
        newArray[i] := line
    }
    ; Peep(newArray)
    return newArray
}

; quick reload when editing
; #HotIf WinActive(A_ScriptName " ahk_exe Code.exe")
; ~^s::
; {
;     ; Send("^s")
;     ToolTip("Reloading " A_ScriptName ".", A_ScreenWidth / 2, A_ScreenHeight / 2)
;     Sleep(250)
;     Reload()
;     ; MsgBox("reloading !")
;     Return
; }
