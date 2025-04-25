#!/bin/bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME label.highlight=on label.font.style=Bold
else
    sketchybar --set $NAME label.highlight=off label.font.style=Regular
fi
