#!/bin/bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME label.highlight=on background.drawing=on
else
    sketchybar --set $NAME label.highlight=off background.drawing=off
fi
