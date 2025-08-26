#!/usr/bin/env bash

# --- cleanup and exit ---
_cleanup_and_exit() {
  tput cnorm # show the cursor again
  tput sgr0  # reset all attributes
  clear
  echo
  exit 0
}
trap _cleanup_and_exit SIGINT # Catch Ctrl-C

# --- resize handler ---
handle_resize() {
    width=$(tput cols)
    height=$(tput lines)
    clear
    draw_background
}
trap handle_resize SIGWINCH

# --- draw the background ---
draw_background() {
    local x y
    for ((y=0; y<height; y++)); do
        for ((x=0; x<width; x++)); do
            tput cup "$y" "$x"
            if (( (x + y) % 2 == 0 )); then
                tput setab 232 # dark grey
            else
                tput setab 233 # darker grey
            fi
            echo -n " "
        done
    done
}

# --- main animation loop ---
animate() {
    tput civis # Hide cursor
    handle_resize # initial draw

    while true; do
        tput cup "$((RANDOM % height))" "$((RANDOM % width))"
        tput setaf $((RANDOM % 8)) # random foreground color
        echo -n "*"
        sleep 0.1
    done
}

animate
