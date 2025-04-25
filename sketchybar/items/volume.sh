#!/bin/bash

sketchybar --add item volume right \
            --set volume script="$PLUGIN_DIR/volume.sh" \
                        background.drawing=off \
            --subscribe volume volume_change \
#
