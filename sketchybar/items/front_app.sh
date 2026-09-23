#!/bin/bash

sketchybar --add item front_app left \
           --set front_app       background.color=$ACCENT_COLOR \
                                 background.corner_radius=12 \
                                 background.height=28 \
                                 icon.color=$ITEM_BG_COLOR \
                                 icon.font="sketchybar-app-font:Regular:16.0" \
                                 icon.padding_left=10 \
                                 label.color=$ITEM_BG_COLOR \
                                 label.font.style=Semibold \
                                 script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched
