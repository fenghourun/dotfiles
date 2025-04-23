# Aerospace window manager
sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item space.$sid q \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        background.corner_radius=5 \
        background.color=$ACCENT_COLOR \
        background.height=20 \
        background.drawing=off \
        label.highlight_color=$BACKGROUND_COLOR \
        label="$sid" \
        label.padding_left=5 \
        label.padding_right=13 \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospace.sh $sid"
done

sketchybar --add item workspaces q \
  --set workspaces \
  label.padding_right=0 \
  icon.padding_right=0 \
  icon="􀢌"
