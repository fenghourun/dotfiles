#!/bin/bash

workspace_id="$1"

# Fetch apps in the current workspace using aerospace
apps=()
while IFS="|" read -r app_workspace_id app_name app_details; do
    app_name=$(echo "$app_name" | xargs)
    if [ "${app_name}" != "" ]; then
      apps+=($($CONFIG_DIR/plugins/icon_map.sh "${app_name}"))
    fi
done < <(aerospace list-windows --workspace "$workspace_id")


if [ -z "$apps" ]; then
    label_output="$workspace_id"
else
    label_output="$workspace_id ${apps[@]}"
fi

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME label.highlight=on     \
                           label.font.style=Bold
                           # label.string="$label_output"
else
    sketchybar --set $NAME label.highlight=off    \
                           label.font.style=Regular 
                         # label.string="$label_output"
fi
