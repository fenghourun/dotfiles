sketchybar --add event aerospace_workspace_change

workspace_items=()

for sid in $(aerospace list-workspaces --all); do
    item_name="space.$sid"
    workspace_items+=("$item_name")

    sketchybar --add item space.$sid q                                         \
               --set       "$item_name" background.drawing=off                  \
                                        label.highlight_color=$ACCENT_COLOR     \
                                        label.color=$WHITE                      \
                                        label="$sid"                            \
                                        label.font.style=Regular                \
                                        label.padding_left=5                    \
                                        label.padding_right=13                  \
                                        click_script="aerospace workspace $sid" \
                                        script="$PLUGIN_DIR/aerospace.sh $sid"  \
               --subscribe "$item_name" aerospace_workspace_change
    
    apps=$(aerospace list-windows --workspace $sid | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
    icon_strip=" "
    if [ "${apps}" != "" ]; then
      while read -r app
      do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map.sh "$app")"
      done <<< "${apps}"
    else
      icon_strip=" —"
    fi

    sketchybar --set space.$sid label="$sid $icon_strip"
done

sketchybar --add item workspaces_icon q                        \
           --set      workspaces_icon background.drawing=off   \
                                      icon="􀢌"                 \
                                      icon.color=$ACCENT_COLOR \
                                      label.padding_right=0

sketchybar --add bracket workspaces_bracket front_app                               \
                                            workspaces                              \
                                            "${workspace_items[@]}"                 \
           --set         workspaces_bracket background.color=$ITEM_BG_COLOR         \
                                            background.corner_radius=12             \
                                            background.height=30                    \
                                            drawing=on

