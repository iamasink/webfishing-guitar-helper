#Requires AutoHotkey v2.0

SetDefaultMouseSpeed(1)

; 0 -> 15
; columns := [0, 0, 0, 1, 13]
dango := [
    [0, 0, 0, 1, 13, 0],
    [0, 0, 0, 0, 11, 11],
    [0, 0, 0, 0, 1, 13],
    [0, 0, 0, 0, 0, 15],
    [],
    [],
    [],
    [],
    [],
]

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


sweden := [
    [3, 8, 6, 5, 11, 8],
    [8, 11, 13, 12, 4, 1],
    [4, 10, 8, 7, 8, 6],
    [4, 6, 8, 7, 6, 15],
    [0, 8, 6, 5, 13, 0],
    [8, 11, 13, 12, 15, 14],
    [4, 10, 8, 7, 15, 11],
    [0, 6, 8, 7, 10, 11],
    [8, 10, 8, 7, 8, 8],
]

wethands := [
    [6, 5, 3, 3, 1, 0],
    [0, 0, 0, 0, 3, 1],
    [0, 0, 1, 3, 3, 1],
    [4, 3, 1, 1, 0, 0],
    [0, 0, 5, 3, 0, 0],
    [0, 3, 1, 0, 0, 3],
    [0, 0, 5, 3, 3, 0],
    [],
    [],
]

stillalive1 := [
    [1, 1, 10, 3, 4, 3],
    [1, 1, 8, 5, 6, 4],
    [1, 1, 0, 8, 7,],
    [0, 0, 4, 0, 4, 2],
    [4, 4, 3, 1, 2, 1],
    [2, 4, 4, 3, 2, 2],
    [2, 1, 1, 3, 4, 2],
    [1, 1, 1, 3, 4, 1],
    [1, 3, 0, 5, 1, 1],
]

stillalive2 := [
    [1, 13, 13, 10, 8, 4],
    [1, 13, 12, 8, 6, 3],
    [1, 1, 10, 3, 4, 3],
    [1, 1, 11, 8, 6, 2],
    [1, 13, 9, 6, 8, 2],
    [1, 1, 13, 10, 7, 4],
    [1, 1, 16, 13, 11, 7],
    [1, 1, 15, 12, 9, 6],
    [1, 1, 13, 12, 11, 8],
]

tuning := dango
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

f11:: {
    ; convert letters with numbers to numbers
    ; eg [0,"E1","G1",0,0,0] to [0,1,11,0,0,0]
    text := ""

    for row in converty() {
        rowText := ""  ; Initialize a string to store the current row
        for element in row {
            ; Check if the element is a string, otherwise leave it as a number
            rowText .= element . ", "  ; Leave numbers as they are

        }
        ; Remove the last comma and space from the rowText
        rowText := SubStr(rowText, 1, StrLen(rowText) - 2)
        text .= "[" rowText "], `n"  ; Append the row text to the final text
    }

    A_Clipboard := text  ; Display the converted text in a tooltip
}

f10:: {
    ; show gui
    myGui := Gui()
    myGui.Title := "Window"
    Edit1 := myGui.Add("Edit", "x40 y64 w224 h182 +Multi")
    myGui.Show("w409 h288")
}

converty() {
    ; data := [
    ;     [1, 1, "B1", "A1", "D1", "F#1"],
    ;     [1, 1, "A1", "B1", "E1", "G1"],
    ;     [1, 1, "A#1", "D1", "F1", "A#1"],
    ;     [0, "A#1", "F1", "A#1", "D1", "F1"],
    ;     ["G1", "C1", "E1", 1, "C1", 1],
    ;     ["F1", "C1", "F1", "A1", "C1", "F1"],
    ;     ["F1", 1, 1, "A1", "D1", "F1"],
    ;     [1, 1, 1, "A1", "D1", 1],
    ;     [1, "B1", "F#1", "B1", 1, 1]
    ; ]
    data := [
        [1, "a2", "d2", "e", "f#", "g1"],
        [1, "a2", "c#1", "d1", "e", "f#"],
        [1, 1, "b", "a", "d", "f#"],
        [1, 1, "c", "d", "e", "f"],
        [1, "a2", "a#", "c", "f#", "f"],
        [1, 1, "D2", "e", "f", "g",],
        [1, 1, "f2", "g2", "a", "a#"],
        [1, 1, "e2", "f#", "g1", "a"],
        [1, 1, "d2", "f#", "a1", "b1"],
    ]
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
    for i, v in data {
        output[i] := convertLetters(v)
    }
    return output
}

getArrayValueIndex(arr, val) {
    Loop arr.Length {
        if (arr[A_Index] == val)
            return A_Index
    }
    MsgBox("unknown" val)
}

convertLetters(array) {
    newarray := []
    for index, value in array {
        value := StrUpper(value)
        noteletter := value
        notenumber := 0
        ; MsgBox(index " : " value)
        ; handle 1 character
        if (StrLen(String(value)) == 1) {
            MsgBox(StrLen(value))
            if (value == 0) {
                notenumber := 0
            } else if (value == 1) {
                notenumber := 1
            }
            else {
                noteletter := value
                notenumber := getArrayValueIndex(notes[index], noteletter)
            }
        }
        else if (StrLen(value) == 2) {
            MsgBox(StrLen(value))
            ; if the string is like "E#"
            if (SubStr(value, 2, 1) == "#") {
                ; all is well
                noteletter := SubStr(value, 1, 2)
            }
            else if (SubStr(value, 2, 1) == "1") {
                noteletter := SubStr(value, 1, 1)
            }
            else if (SubStr(value, 2, 1) == "2") {
                noteletter := SubStr(value, 1, 2)
            } else {
                ; invalid letter
                MsgBox("invalid: " value " / " noteletter)
                noteletter := 0
            }
            notenumber := getArrayValueIndex(notes[index], noteletter)
        } else if (StrLen(value) == 3) {
            MsgBox(StrLen(value))
            if (SubStr(value, 3, 1) == "1") {
                noteletter := SubStr(value, 1, 2)
                MsgBox(noteletter)
            }
            else if (SubStr(value, 3, 1) == "2") {
                noteletter := SubStr(value, 1, 3)
            } else {
                ; invalid
                MsgBox("invalid: " value " / " noteletter)
                noteletter := 0
            }
            notenumber := getArrayValueIndex(notes[index], noteletter)
        }
        newarray.Push(notenumber)
    }
    return newarray
}


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