#!/bin/bash
# Dependencies: xdotool

# Assign 'do <filename>' to a string variable
do_filename='do "'$1'"'

# Get Stata window ID (first window that matches the regex)
#winid_stata=$(xdotool search --name --limit 1 "Stata/(IC|SE|MP)? 1[0-9]\.[0-9]")
winid_stata=$2

# Send string to Stata's command pane replacing previous text if any 
# Note: Should there be some issues, try rasing the --delay slightly. 
if [ ! -z "$winid_stata" ]; then
	xdotool key    --window $winid_stata --delay 50 --clearmodifiers ctrl+a
	xdotool type   --window $winid_stata --delay 10 "${do_filename}"
	xdotool key    --window $winid_stata Return
	xdotool keyup  --window $winid_stata --delay 5 ctrl a
else
	echo "No Stata window open."
	exit 1
fi