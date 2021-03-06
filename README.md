# StataLinux

Sublime Text 3 plugin that adds basic support for Stata (all versions) in Linux.

- Language definitions for `do` and `ado` files
- Commands for sending a selection of lines or the whole file to Stata.
See [usage](#usage) for more details. 

![screencast_functions.gif](https://raw.githubusercontent.com/acarril/StataLinux/master/img/screencast_functions.gif "StataLinux in action!")

## Background

I needed a minimal yet robust plugin for sending code from Sublime Text into Stata.
Since none of the plugins in the Package Control was specifically tailored for Linux, and none of the maintainers seem to want to add Linux support to theirs, I wrote my own.
This plugin is originally based on [StataEnhanced](https://github.com/andrewheiss/SublimeStataEnhanced), and also on [these notes](https://github.com/cwitt2013/SublimeText_Stata_Linux).

This plugin aims for robustness over bells and whistles, and almost all the decisions were taken with that philosophy in mind.
It basically creates a temporary file with either the currently selected lines or the entire do-file to be executed in Stata. In the background `xdotool` is used to call the temporary file from the command pane in Stata. 

## Dependency

- `xdotool`

This package is likely already in your system.
You can check their presence by typing each name with the `--version` option in your terminal.
For example,
```bash
xdotool --version
```
If the output is something like `xdotool version 3.20160805.1`, then it's installed.
If you get an error, then the package is not installed.
Use your system's package manager to install them.
For example,

### Arch(-based)
```bash
sudo pacman -S xdotool
```

### Ubuntu(-based)
```bash
sudo apt install xdotool
```
etc.



## Installation

There are two ways to install this plugin:

1. Search for "StataLinux" on Package Control, or
2. Copy/clone the entire plugin folder (this repository) to `~/.config/sublime-text-3/Packages/`.

Make sure you have installed the [dependency](#dependency) listed above before using it.

## Usage

Make sure you have one instance of Stata open.
Open a `.do` (or `.ado`) file in ST3.
You have two keybindings for executing code:

1. `ctrl+alt+d` executes the current line, or the selected lines if a selection is made, and
2. `crtl+alt+shift+d` executes the entire file.

These actions may also be called using the Command Palette: after invoking it with `ctrl+shit+p`, type "StataLinux" and select an action.
Additionally, these actions are accessible in the main menu under `Tools > Packages > StataLinux`.

The default keybinding can be changed by including the following in your `sublime-keymap` file. This file can be viewed and edited by clicking on `Key Bindings` under `Preferences > Package Settings > Stata Linux`. Here is a example using `ctrl`+`enter` to run selected lines: 

```
    // StataLinux
    { "keys": ["ctrl+enter"], "command": "stata_linux", "context":
        [{ "key": "selector", "operator": "equal", "operand": "source.stata", "match_all": true }]
```

The `stata_linux_all` command, which runs the entire file can be also adjusted accordingly. 

## Other features

### Comments

Comment toggling for entire lines works with the default ST3 keybinding, `ctrl+\`.
Arbitary blocks can be commented out with `ctrl+shift+\`.

![comments_basic.gif](https://raw.githubusercontent.com/acarril/StataLinux/master/img/comments_basic.gif "Comments in action!")

### Locals

Typing a backtick `` ` `` anywhere in the code will immediately put a closing tick after it, with the cursor inside.
Typing a backtick with a `word` selected will yield `` `word' ``.

![locals.gif](https://raw.githubusercontent.com/acarril/StataLinux/master/img/locals.gif "Locals in action!")

### Options 

The following options be found in the main menu under `Preferences > Package Settings > StataLinux > Settings`. 
    
- `save_before_run_all` (default = true): Automatically saves the current file before "Send All" command.

- `always_extract_full_line` (default = true): Always extracts whole line (true) or only exact selection (false). If nothing is selected then whole line under cursor is extracted. The default behavior mimics Stata's for familiarity but there are situations where running a partial line might save some time, so setting it to `false` allows you to quickly run a command with and then without an `if` condition or a `by` statement.  If the current selection is empty, this plugin will run the whole line and **not** the whole do-file. Although this is different to Stata's default behavior, we don't think it was a good design choice and one can always explicitly use `Run all` functionality in such cases.

- `remove_temp_file` (default: false): Deletes the temporary file after running it.

## Stata versions, flavors and instances

Make sure you have an instance of Stata *with GUI* open (`xstata`, or its various flavors); this plugin doesn't work with Stata's CLI.
No additional configuration needs to be added to indicate version or flavor, since the program will detect any running instance automatically.
If you have more than one instance of Stata open, the plugin will default to choosing the most recently opened one (internally, it looks for the result of `xdotool search --name --limit 1 "Stata/(IC|SE|MP)? 1[0-9]\.[0-9]"`).


## Known issues

1. ~~Currently, there is an [issue](https://github.com/jordansissel/xdotool/issues/43) with `xdotool`'s `clearmodifiers` option.
This has the consequence that the plugin will fail to operate correctly if any keyboard modifiers (e.g. Caps Lock) are not manually turned off.~~
Now not an issue, since I'm using `xdotool` with the `--window`, which seems cleaner than focusing and refocusing windows, and has the added bonus of disregarding any active modifiers.

2. There is currently no option for switching focus to the Stata window.
This is because there are good reasons to use `xdotool` with the `--window` option (see issue #1), so I don't plan on implementing this.
Window focus is a task for window managers, anyway.
