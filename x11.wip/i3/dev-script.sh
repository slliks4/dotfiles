#!/usr/bin/env bash

i3-msg "workspace 0"

# --- helper ---
wait_for_window() {
    local query="$1"
    while ! i3-msg -t get_tree | jq -e "$query" >/dev/null; do
        sleep 0.05
    done
}

# -----------------------------
# OPEN MAIN
# -----------------------------
i3-msg 'exec alacritty --title main-terminal'

wait_for_window '.. | objects | select(.window_properties.class? == "Alacritty" and .name? == "main-terminal")'

i3-msg '[title="main-terminal"] mark main'

# -----------------------------
# OPEN ASIDE TERMINALS
# -----------------------------
i3-msg 'exec alacritty --title aside-terminal-1'
i3-msg 'exec alacritty --title aside-terminal-2'

wait_for_window '.. | objects | select(.window_properties.class? == "Alacritty" and .name? == "aside-terminal-2")'

# Mark aside (just use one as anchor)
i3-msg '[title="aside-terminal-1"] mark aside'

# -----------------------------
# MAKE EVERYTHING STACKED
# -----------------------------
i3-msg 'layout stacking'

# -----------------------------
# EXTRACT MAIN → RIGHT
# -----------------------------
i3-msg '[con_mark="main"] focus'
i3-msg 'split h'
i3-msg 'move right'

# -----------------------------
# ENSURE ASIDE STACK
# -----------------------------
i3-msg '[con_mark="aside"] focus'
i3-msg 'layout stacking'

# # -----------------------------
# # Helper: check if window exists
# # -----------------------------
# win_exists() {
#     i3-msg -t get_tree | jq -e "$1" >/dev/null
# }
#
# # -----------------------------
# # MAIN TERMINAL (Alacritty)
# # -----------------------------
# if win_exists '.. | objects | select(.window_properties.class? == "Alacritty" and .name? == "main-terminal")'; then
#     # Move existing main terminal
#     i3-msg '[class="Alacritty" title="main-terminal"] move to workspace 0'
#     i3-msg '[con_mark="main"] focus'
#     i3-msg '[class="Alacritty" title="main-terminal"] move container to mark main'
# else
#     # Spawn with correct title
#     i3-msg '[con_mark="main"] focus; exec alacritty --title main-terminal'
# fi
#
# # -----------------------------
# # FIREFOX DEV
# # -----------------------------
# if win_exists '.. | objects | select(.window_properties.class? == "Firefox Developer Edition")'; then
#     # Move existing firefox to aside
#     i3-msg '[class="Firefox Developer Edition"] move to workspace 0'
#     i3-msg '[con_mark="aside"] focus'
#     i3-msg '[class="Firefox Developer Edition"] move container to mark aside'
# else
#     # Spawn new firefox in aside
#     i3-msg '[con_mark="aside"] focus; exec firefox-developer-edition'
# fi
