[![CircleCI](https://circleci.com/gh/dnasseri/fir.svg?style=svg&circle-token=547487bfcc46230ec60829366533cbbad14524ee)](https://circleci.com/gh/dnasseri/fir)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Description

Fir is a ruby repl that is an alternative to IRB. Fir aims to bring some of the friendly features that the [fish](https://github.com/fish-shell/fish-shell) project brought to shells to a ruby repl. Though I originally intended Fir to be a full blown replacement for pry, it is unlikely that you can use it in that capacity, since pry offers so many damn good features that this project does not replicate.

Fir does bring some features to the table that pry and other REPL's do not have. The key difference between pry, IRB, Ripl, etc, and Fir is that fir puts stdin into raw mode which allows us to provide features like autosuggestion a la fish, and automatically indenting/dedenting code as you type. Below is a gif of fir in action:

![Fir in Action](fir-example.gif?raw=true "Fir in action")

As the video demonstrates, fir is able to indent your code as soon as it is typed, not just when you hit enter. It also can suggest lines from your history file as you type as well!

## Install

## Usage
```
$ fir
(fir)> ...
```

### Key Commands
Fir aims to bring familiar bash keyboard shortcuts that we all know and love, however many editing commands remain unimplemented. Below is a list of keycommands, what they do, and whether they are implemented.

| Command | Alt | Description | Status |
| --- | --- | --- | --- |
| Ctrl + a | N/A | Move cursor to the beginning of the line | Implemented |
| Ctrl + e | N/A | Move cursor to the end of the line | Implemented |
| Ctrl + c | N/A | Clear current state, and step out of the block. | Implemented |
| Ctrl + d | N/A | Exit program. | Implemented |
| Ctrl + v | N/A | Paste from system clipboard. | Implemented |
| Ctrl + z | N/A | Put the running fir process in the background. | Implemented |
| Ctrl + p | Up Arrow | Previous command in history (i.e. walk back through the command history). | Implemented |
| Ctrl + n | Down Arrow | Next command in history (i.e. walk forward through the command history). | Implemented |
| Ctrl + b | Left Arrow | Backward one character. | Implemented |
| Ctrl + f | Right Arrow | Forward one character. | Implemented |
| Ctrl + u | N/A | Cut the line before the cursor position               | Not implemented |
| Ctrl + d | N/A | Delete character under the cursor                     | Not implemented |
| Ctrl + h | N/A | Delete character before the cursor (backspace)        | Not implemented |
| Ctrl + w | N/A | Cut the Word before the cursor to the clipboard       | Not implemented |
| Ctrl + k | N/A | Cut the Line after the cursor to the clipboard        | Not implemented |
| Ctrl + t | N/A | Swap the last two characters before the cursor (typo) | Not implemented |
| Ctrl + y | N/A | Paste the last thing to be cut (yank)                 | Not implemented |
| Сtrl + _ | N/A | Undo                                                  | Not implemented |








## Future Ideas
Below is a list of ideas/features that I would like to eventually add.

* Break points a la `binding.pry`
* Configurability via `.firrc` file
* Command line options
	* -r: load module (same as ruby -r)
	* -e, --exec: A line of code to execute in context before the session starts
	* --no-history: Disable history loading
	* --no-prompt: Disable prompt
* Suggesting methods, local variables, instance variables, and global variables that are in scope as you type
* Colorization
