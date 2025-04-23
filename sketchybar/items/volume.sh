#!/bin/bash

sketchybar --add item volume right \
            --set volume script="$PLUGIN_DIR/volume.sh" \
                        background.color=$BACKGROUND_COLOR \
            --subscribe volume volume_change \
#
