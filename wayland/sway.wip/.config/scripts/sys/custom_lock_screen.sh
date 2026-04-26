#!/bin/bash

# Custom lockscreen using swaylock-effects
swaylock --screenshots \
	--clock \
	--indicator \
	--indicator-radius 150 \
	--indicator-thickness 8 \
	--effect-blur 7x5 \
	--effect-vignette 0.5:0.5 \
	--ring-color bb9af7 \
	--key-hl-color 7aa2f7 \
	--line-color 00000000 \
	--inside-color 00000088 \
	--separator-color 00000000 \
	--fade-in 0.2 \
	--timestr "%H:%M" \
	--font "FiraCode Nerd Font" \
	--datestr " %d %B"
