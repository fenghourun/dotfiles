sketchybar --add event aerospace_workspace_change

workspace_items=()
for sid in $(aerospace list-workspaces --all); do
    item_name="space.$sid"
    workspace_items+=("$item_name")

    sketchybar --add item  "$item_name" q                                       \
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
done

sketchybar --add item workspaces q                        \
           --set      workspaces background.drawing=off   \
                                 icon.padding_right=10    \
                                 icon.padding_left=10     \
                                 icon="􀢌"                 \
                                 icon.color=$ACCENT_COLOR \
                                 label.padding_right=0

sketchybar --add bracket spaces_bracket workspaces "${workspace_items[@]}" \
           --set         spaces_bracket background.color=$ITEM_BG_COLOR    \
                                        background.corner_radius=12        \
                                        background.height=30               \
                                        drawing=on

