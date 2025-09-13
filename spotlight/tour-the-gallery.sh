#!/usr/bin/env bash
#
# tour-the-gallery.sh
#
# This script creates an overview of all screensavers.
#

# --- Helper Functions ---

validate_cast() {
    local cast_file="$1"
    if [[ ! -s "$cast_file" ]]; then
        echo "Error: Cast file is empty: $cast_file"
        exit 1
    fi
    if ! head -n 1 "$cast_file" | grep -q '^{.*}$'; then
        echo "Error: Invalid JSON header in cast file: $cast_file"
        cat "$cast_file" >&2
        exit 1
    fi
}

check_deps() {
    if ! command -v asciinema &> /dev/null; then
        echo "Error: asciinema not found. Please install it."
        exit 1
    fi
    if ! command -v agg &> /dev/null; then
        echo "Error: agg not found. Please install it."
        exit 1
    fi
}



# --- Main Logic ---

main() {
    check_deps

    local gallery_dir="gallery"
    local output_dir="."
    local all_casts=()

    echo "Creating overview cast..."

    # 1. Loop through screensavers and collect cast files
    echo "-> Collecting screensaver casts..."
    for screensaver_dir in "$gallery_dir"/*/; do
        if [[ -d "$screensaver_dir" ]]; then
            local name
            name=$(basename "$screensaver_dir")
            local run_script="${screensaver_dir%/}/$name.sh"

            if [[ -f "$run_script" ]]; then
                local cast_file="${screensaver_dir%/}/$name.cast"
                local gif_file="${screensaver_dir%/}/$name.gif"

                if [ ! -s "$cast_file" ] || [ ! -s "$gif_file" ]; then
                    echo "  - Cast or GIF file missing for $name. Generating..."
                    bash spotlight/smile-for-the-camera.sh "$screensaver_dir"
                fi

                # Add the existing cast file
                if [[ -f "$cast_file" ]]; then
                    echo "  - Adding $name.cast"
                    validate_cast "$cast_file"
                    all_casts+=("$cast_file")
                else
                    echo "Warning: Cast file not found for $name, skipping."
                fi
            fi
        fi
    done
    echo "<- Finished collecting casts."

    # 2. Concatenate all casts
    echo "  - Concatenating all casts..."
    local overview_cast="$output_dir/overview.cast"
    asciinema cat "${all_casts[@]}" > "$overview_cast"
    echo "  - Concatenation complete."

    # 5. Convert to GIF
    echo "  - Converting to GIF..."
    validate_cast "$overview_cast"
    local overview_gif="$output_dir/overview.gif"
    agg "$overview_cast" "$overview_gif"
    echo "  - Conversion to GIF complete."
    # 6. Clean up
    echo "  - Cleaning up..."
    #rm -rf "$temp_dir"

    echo "Done! Overview saved to $overview_cast and $overview_gif"
}

main "$@"
