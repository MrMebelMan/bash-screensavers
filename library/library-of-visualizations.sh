#!/usr/bin/env bash
#
# Library of Visualizations
#
# A collection of bash functions for creating stunning visual displays in
# the terminal. This library provides tools for screen handling, color
# manipulation, and other visual effects.
#
#
# The `lov_` prefix is used to avoid conflicts with other scripts.
#
# Usage:
#   source library-of-visualizations.sh
#   lov_init
#   trap lov_die_with_honor EXIT
#   # Your amazing visualization code here...
#
# Version: 0.0.1
#

# Stop executing if any command fails
set -e

#
# Function: lov_die_with_honor
#
# Description:
#   Cleans up the terminal and exits the script. This function is intended
#   to be called by a trap on EXIT, making sure that the terminal is
#   restored to a usable state.
#
# Inputs:
#   None
#
# Outputs:
#   None
#
# Return Codes:
#   None
#
lov_die_with_honor() {
  lov_cleanup
  exit 0
}

#
# Function: lov_cleanup
#
# Description:
#   Restores the terminal to a sane state. It shows the cursor and resets
#   any color or text attributes.
#
# Inputs:
#   None
#
# Outputs:
#   Restores terminal settings.
#
# Return Codes:
#   None
#
lov_cleanup() {
  tput sgr0  # Reset text attributes
  tput cnorm # Restore cursor
  # tput clear # Optional: clear the screen
}

#
# Function: lov_hide_cursor
#
# Description:
#   Hides the terminal cursor.
#
# Inputs:
#   None
#
# Outputs:
#   Hides the cursor.
#
# Return Codes:
#   None
#
lov_hide_cursor() {
  tput civis
}

#
# Function: lov_show_cursor
#
# Description:
#   Shows the terminal cursor. This is the normal state. `lov_cleanup` also
#   calls this function.
#
# Inputs:
#   None
#
# Outputs:
#   Shows the cursor.
#
# Return Codes:
#   None
#
lov_show_cursor() {
  tput cnorm
}

#
# Function: lov_get_terminal_size
#
# Description:
#   Gets the current terminal size and stores it in global variables.
#
# Inputs:
#   None
#
# Outputs:
#   Sets the following global variables:
#   - LOV_TERM_HEIGHT: The height of the terminal in rows.
#   - LOV_TERM_WIDTH: The width of the terminal in columns.
#
# Return Codes:
#   None
#
lov_get_terminal_size() {
  LOV_TERM_HEIGHT=$(tput lines)
  LOV_TERM_WIDTH=$(tput cols)
}

#
# Function: lov_fore_color
#
# Description:
#   Sets the foreground color.
#
# Inputs:
#   $1: The color number (0-7).
#       0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white
#
# Outputs:
#   Sets the terminal foreground color.
#
# Return Codes:
#   None
#
lov_fore_color() {
  tput setaf "$1"
}

#
# Function: lov_back_color
#
# Description:
#   Sets the background color.
#
# Inputs:
#   $1: The color number (0-7).
#       0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white
#
# Outputs:
#   Sets the terminal background color.
#
# Return Codes:
#   None
#
lov_back_color() {
  tput setab "$1"
}

#
# Function: lov_clear_screen
#
# Description:
#   Clears the entire terminal screen.
#
# Inputs:
#   None
#
# Outputs:
#   Clears the screen.
#
# Return Codes:
#   None
#
lov_clear_screen() {
  tput clear
}

#
# Function: lov_move_cursor
#
# Description:
#   Moves the cursor to a specific position on the screen.
#
# Inputs:
#   $1: The row number (0-based).
#   $2: The column number (0-based).
#
# Outputs:
#   Moves the cursor.
#
# Return Codes:
#   None
#
lov_move_cursor() {
  tput cup "$1" "$2"
}

#
# Function: lov_get_random_int
#
# Description:
#   Generates a random integer within a specified range (inclusive).
#
# Inputs:
#   $1: The minimum value of the range.
#   $2: The maximum value of the range.
#
# Outputs:
#   Prints the random integer to stdout.
#
# Return Codes:
#   None
#
# Example:
#   local my_rand=$(lov_get_random_int 1 10)
#
lov_get_random_int() {
  local min=$1
  local max=$2
  local range=$((max - min + 1))
  local rand=$((RANDOM % range + min))
  echo $rand
}

#
# Function: lov_move_cursor_random
#
# Description:
#   Moves the cursor to a random position on the screen.
#   NOTE: `lov_get_terminal_size` must be called first to set the
#   `LOV_TERM_HEIGHT` and `LOV_TERM_WIDTH` global variables.
#
# Inputs:
#   None
#
# Outputs:
#   Moves the cursor to a random position.
#
# Return Codes:
#   None
#
lov_move_cursor_random() {
  local rand_row=$(lov_get_random_int 0 $((LOV_TERM_HEIGHT - 1)))
  local rand_col=$(lov_get_random_int 0 $((LOV_TERM_WIDTH - 1)))
  lov_move_cursor $rand_row $rand_col
}

#
# Function: lov_fore_color_random
#
# Description:
#   Sets the foreground to a random color from the standard 8-color palette.
#
# Inputs:
#   $1 (optional): If set to "no_black", the color black (0) will be excluded.
#
# Outputs:
#   Sets the terminal foreground color.
#
# Return Codes:
#   None
#
lov_fore_color_random() {
  local min=0
  if [[ "$1" == "no_black" ]]; then
    min=1
  fi
  local color=$(lov_get_random_int $min 7)
  lov_fore_color $color
}

#
# Function: lov_back_color_random
#
# Description:
#   Sets the background to a random color from the standard 8-color palette.
#
# Inputs:
#   None
#
# Outputs:
#   Sets the terminal background color.
#
# Return Codes:
#   None
#
lov_back_color_random() {
  local color=$(lov_get_random_int 0 7)
  lov_back_color $color
}

#
# Function: lov_print_random_char_from_string
#
# Description:
#   Prints a single random character from the provided string.
#
# Inputs:
#   $1: The string to select a character from.
#
# Outputs:
#   Prints one random character to stdout, without a trailing newline.
#
# Return Codes:
#   None
#
lov_print_random_char_from_string() {
  local str="$1"
  local len=${#str}
  local index=$(lov_get_random_int 0 $((len - 1)))
  echo -n "${str:$index:1}"
}

#
# Function: lov_animate_text_rainbow
#
# Description:
#   Animates a string of text at a random position on the screen, with each
#   character displayed in a different color from a provided palette.
#
# Inputs:
#   $1: The string of text to animate.
#   $2: A string containing the space-separated list of colors to use.
#   $3 (optional): The maximum time in seconds the animation should take.
#                  Defaults to 10.
#
# Outputs:
#   Displays the animated text on the screen.
#
# Dependencies:
#   - `bc` for floating point calculations.
#   - `lov_get_terminal_size`, `lov_get_random_int`, `lov_move_cursor`,
#     `lov_fore_color` from this same library.
#
lov_animate_text_rainbow() {
    local phrase="$1"
    local colors_str="$2"
    local max_display_time="${3:-10}" # Default to 10 seconds

    local -a colors=($colors_str)
    if [ ${#colors[@]} -eq 0 ]; then return; fi # Do nothing if no colors

    lov_get_terminal_size
    local len=${#phrase}
    if [ "$len" -eq 0 ]; then return; fi # Do nothing if phrase is empty

    # Calculate random position, ensuring the phrase fits on screen
    local x=$(lov_get_random_int 0 $((LOV_TERM_WIDTH - len)))
    local y=$(lov_get_random_int 0 $((LOV_TERM_HEIGHT - 1)))

    lov_move_cursor "$y" "$x"

    # Approximate sleep duration based on phrase length
    local sleep_duration
    # Calculate sleep duration to fit within max_display_time
    sleep_duration=$(awk "BEGIN {print $max_display_time / $len}")
    # But don't let it be too slow for short phrases
    if (( $(echo "$sleep_duration > 0.1" | bc -l) )); then
        sleep_duration=0.1
    fi

    for (( i=0; i<len; i++ )); do
        local char="${phrase:$i:1}"
        # Cycle through the provided colors
        local color_index=$(( (i + RANDOM) % ${#colors[@]} ))
        lov_fore_color "${colors[$color_index]}"
        printf "%s" "$char"
        sleep "$sleep_duration"
    done
}
