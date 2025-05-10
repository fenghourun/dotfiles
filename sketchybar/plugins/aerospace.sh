#!/bin/bash

workspace_id="$1"

# Fetch apps in the current workspace using aerospace
apps=()
while IFS="|" read -r app_workspace_id app_name app_details; do
    apps+=("$app_name")
    # apps+=($($CONFIG_DIR/plugins/icon_map.sh "${app_name}"))
done < <(aerospace list-windows --workspace "$workspace_id")


if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME label.highlight=on label.font.style=Bold
else
    sketchybar --set $NAME label.highlight=off label.font.style=Regular
fi
