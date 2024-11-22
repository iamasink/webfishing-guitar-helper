# webfishing-guitar-helper  
  
## What is this?  
This is a way to save and load presets of *Saved Chord Shapes* in webfishing :D  
  
Current hotkeys: press **f10** to open the add/selection gui, **f9** to kill the app   
and press **f8** to run the setup but you shouldnt need to do this at normal resolutions and aspect ratios (1080p, 1440p, 4k at 16:9 is the default)  
and **f7** to clear any tooltips that are showing  
  
It also allows you to use the numpad to switch presets.  
  
This does not allow you to play songs automatically or with a MIDI device. Check [this](https://steamcommunity.com/sharedfiles/filedetails/?id=3352573634) out if that's what you want.  
  
  
  
Feel free to contribute!  


## How to download
click the green code button, then download as zip or click this    
https://github.com/iamasink/webfishing-guitar-helper/archive/refs/heads/main.zip  
then unzip it and run the .ahk or the .exe :3  


# explanation of formats
Notes as letters and numbers..  

The guitar's notes are as such:
| String->| 1   | 2   | 3   | 4   | 5   |6    |
| ------- | --- | --- | --- | --- | --- | --- |
| Row 1   | E   | A   | D   | G   | B   | E   |
| Row 2   | F   | A#  | D#  | G#  | C   | F   |
| Row 3   | F#  | B   | E   | A   | C#  | F#  |
| Row 4   | G   | C   | F   | A#  | D   | G   |
| Row 5   | G#  | C#  | F#  | B   | D#  | G#  |
| Row 6   | A   | D   | G   | C   | E   | A   |
| Row 7   | A#  | D#  | G#  | C#  | F   | A#  |
| Row 8   | B   | E   | A   | D   | F#  | B   |
| Row 9   | C   | F   | A#  | D#  | G   | C   |
| Row 10  | C#  | F#  | B   | E   | G#  | C#  |
| Row 11  | D   | G   | C   | F   | A   | D   |
| Row 12  | D#  | G#  | C#  | F#  | A#  | D#  |
| Row 13  | E2  | A2  | D2  | G2  | B2  | E2  |
| Row 14  | F2  | A#2 | D#2 | G#2 | C2  | F2  |
| Row 15  | F#2 | B2  | E2  | A2  | C#2 | F#2 |
| Row 16  | G2  | C2  | F2  | A#2 | D2  | G2  |
| Row 0*  |     |     |     |     |     |     |

_*Row 0 = muted_  
So for an example preset of  
`1 1 16 13 0 7`  
would be the notes  
`E A F2 G2 x A#`  
for strings 1-6 respectively  
(x is 0 / muted)  
