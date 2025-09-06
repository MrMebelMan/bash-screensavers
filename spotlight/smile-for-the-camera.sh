#!/usr/bin/env bash
#
# smile-for-the-camera.sh
#
# This script creates animated GIF previews for each screensaver.
#
# Dependencies:
#   - asciinema
#   - agg
#
# Installation:
#
# macOS:
#   brew install asciinema agg
#
# Debian/Ubuntu:
#   sudo apt-get install asciinema
#   # agg needs to be installed from source or a package manager like pip
#   pip install --user agg
#
# Arch Linux:
#   sudo pacman -S asciinema agg
#
# Cygwin:
#   Follow instructions on the websites for asciinema and agg

ROWS=20
COLS=80

# --- Helper Functions ---

# Check for dependencies
check_deps() {
    if ! command -v asciinema &> /dev/null; then
        echo "Error: asciinema not found. Please install it."
        exit 1
    fi

    if ! command -v agg &> /dev/null; then
        echo "Warning: agg not found. GIF generation will be skipped."
        echo "  To install agg, follow the instructions at https://docs.asciinema.org/manual/agg/installation/"
    fi
}

# Process a single screensaver
# $1: screensaver_dir
# $2: temp_dir
process_screensaver() {
    local screensaver_dir="$1"
    local temp_dir="$2"

    if [[ ! -d "$screensaver_dir" ]]; then
        return
    fi

    local name
    name=$(basename "$screensaver_dir")
    local run_script="${screensaver_dir%/}/$name.sh"
    local output_path_base="${screensaver_dir%/}/$name"

    if [[ ! -f "$run_script" ]]; then
        return
    fi

    echo "  - Creating preview for $name..."

    mkdir -p "${screensaver_dir%/}"

    tput setab 0 # black background
    clear
    tput civis # no cursor

    stty rows "$ROWS" cols "$COLS"
    printf '\e[8;%d;%dt' "$ROWS" "$COLS"

    local raw_cast_file="$temp_dir/$name.raw.cast"
    rm -f "$raw_cast_file"
    asciinema rec --command="bash -c 'tput civis; timeout 10s env SHELL=/bin/bash $run_script'" "$raw_cast_file"

    local cast_file="${output_path_base}.cast"
    awk 'NR==1{print;next} /^\[/ && substr($1,2)+0 > 0.5' "$raw_cast_file" > "$cast_file"

    local gif_file="${output_path_base}.gif"
    if command -v agg &> /dev/null; then
        agg "$cast_file" "$gif_file"
        echo "    - Saved to $cast_file and $gif_file"
    else
        echo "    - Saved to $cast_file"
    fi
}


# --- Main Logic ---

main() {
    check_deps

    local temp_dir
    temp_dir=$(mktemp -d)

    # a trap to clean up the temporary directory
    trap 'rm -rf "$temp_dir"' EXIT

    if [ -n "$1" ]; then
        # A single screensaver directory is provided as an argument
        if [ -d "$1" ]; then
            echo "Creating preview for $1..."
            process_screensaver "$1" "$temp_dir"
        else
            echo "Error: Directory not found: $1"
            exit 1
        fi
    else
        # No argument, process all screensavers in the gallery
        echo "Creating previews for all screensavers..."
        for screensaver_dir in gallery/*/; do
            process_screensaver "$screensaver_dir" "$temp_dir"
        done
    fi

    tput cnorm       # show the cursor again
    tput sgr0

    echo "Done!"
}

main "$@"
