#!/bin/sh

rotation="$(xrandr -q --verbose | grep 'connected' | egrep -o  '\) (normal|left|inverted|right) \(' | egrep -o '(normal|left|inverted|right)')"
case "$rotation" in
	normal)
		xrandr -o left && sleep 1 && xrandr --dpi 96
		xinput set-prop "Wacom ISDv4 E6 Pen stylus" --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
		xinput set-prop "SynPS/2 Synaptics TouchPad" --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
		xinput set-prop "Wacom ISDv4 E6 Finger touch" --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
		xinput set-prop "TPPS/2 IBM TrackPoint" --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
		xinput set-prop "Wacom ISDv4 E6 Pen eraser" --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
	;;
	left)
		xrandr -o inverted && sleep 1 && xrandr --dpi 96
		xinput set-prop "Wacom ISDv4 E6 Pen stylus" --type=float "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
		xinput set-prop "SynPS/2 Synaptics TouchPad" --type=float "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
		xinput set-prop "Wacom ISDv4 E6 Finger touch" --type=float "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
		xinput set-prop "TPPS/2 IBM TrackPoint" --type=float "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
		xinput set-prop "Wacom ISDv4 E6 Pen eraser" --type=float "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
	;;
	inverted)
		xrandr -o right && sleep 1 && xrandr --dpi 96
		xinput set-prop "Wacom ISDv4 E6 Pen stylus" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
		xinput set-prop "SynPS/2 Synaptics TouchPad" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
		xinput set-prop "Wacom ISDv4 E6 Finger touch" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
		xinput set-prop "TPPS/2 IBM TrackPoint" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
		xinput set-prop "Wacom ISDv4 E6 Pen eraser" --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
	;;
	right)
		xrandr -o normal && sleep 1 && xrandr --dpi 96
		xinput set-prop "Wacom ISDv4 E6 Pen stylus" --type=float "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 0
		xinput set-prop "SynPS/2 Synaptics TouchPad" --type=float "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 0
		xinput set-prop "Wacom ISDv4 E6 Finger touch" --type=float "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 0
		xinput set-prop "TPPS/2 IBM TrackPoint" --type=float "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 0
		xinput set-prop "Wacom ISDv4 E6 Pen eraser" --type=float "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 0
	;;
esac
