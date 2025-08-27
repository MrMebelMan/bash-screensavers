# Bash Screensavers Libraries

This directory contains reusable libraries for the Bash Screensavers project.

---

## `library-of-visualizations.sh`

Welcome, aspiring terminal artist, to the Library of Visualizations! Think of this as your personal art supply store for the command line. Instead of oils and acrylics, we offer a curated collection of bash functions to paint your terminal with dazzling displays. Whether you need to splash some color, move things around, or just make your script exit with a bit of flair, this is the place to be. No smocks required.

---

### Function Reference

#### Cleanup and Setup

### `lov_die_with_honor()`
*   **Description:** Cleans up the terminal and exits the script. This function is intended to be called by a `trap` on `EXIT`, making sure that the terminal is restored to a usable state.
*   **Inputs:** None
*   **Outputs:** None
*   **Return Codes:** None

### `lov_cleanup()`
*   **Description:** Restores the terminal to a sane state. It shows the cursor and resets any color or text attributes.
*   **Inputs:** None
*   **Outputs:** Restores terminal settings.
*   **Return Codes:** None

#### Cursor Control

### `lov_hide_cursor()`
*   **Description:** Hides the terminal cursor.
*   **Inputs:** None
*   **Outputs:** Hides the cursor.
*   **Return Codes:** None

### `lov_show_cursor()`
*   **Description:** Shows the terminal cursor. This is the normal state. `lov_cleanup` also calls this function.
*   **Inputs:** None
*   **Outputs:** Shows the cursor.
*   **Return Codes:** None

### `lov_move_cursor()`
*   **Description:** Moves the cursor to a specific position on the screen.
*   **Inputs:**
    *   `$1`: The row number (0-based).
    *   `$2`: The column number (0-based).
*   **Outputs:** Moves the cursor.
*   **Return Codes:** None

### `lov_move_cursor_random()`
*   **Description:** Moves the cursor to a random position on the screen. **NOTE:** `lov_get_terminal_size` must be called first to set the `LOV_TERM_HEIGHT` and `LOV_TERM_WIDTH` global variables.
*   **Inputs:** None
*   **Outputs:** Moves the cursor to a random position.
*   **Return Codes:** None

#### Screen and Terminal

### `lov_get_terminal_size()`
*   **Description:** Gets the current terminal size and stores it in global variables.
*   **Inputs:** None
*   **Outputs:** Sets the following global variables:
    *   `LOV_TERM_HEIGHT`: The height of the terminal in rows.
    *   `LOV_TERM_WIDTH`: The width of the terminal in columns.
*   **Return Codes:** None

### `lov_clear_screen()`
*   **Description:** Clears the entire terminal screen.
*   **Inputs:** None
*   **Outputs:** Clears the screen.
*   **Return Codes:** None

#### Color Control

### `lov_fore_color()`
*   **Description:** Sets the foreground color.
*   **Inputs:**
    *   `$1`: The color number (0-7). `0=black`, `1=red`, `2=green`, `3=yellow`, `4=blue`, `5=magenta`, `6=cyan`, `7=white`
*   **Outputs:** Sets the terminal foreground color.
*   **Return Codes:** None

### `lov_back_color()`
*   **Description:** Sets the background color.
*   **Inputs:**
    *   `$1`: The color number (0-7). `0=black`, `1=red`, `2=green`, `3=yellow`, `4=blue`, `5=magenta`, `6=cyan`, `7=white`
*   **Outputs:** Sets the terminal background color.
*   **Return Codes:** None

### `lov_fore_color_random()`
*   **Description:** Sets the foreground to a random color from the standard 8-color palette.
*   **Inputs:**
    *   `$1` (optional): If set to `"no_black"`, the color black (0) will be excluded.
*   **Outputs:** Sets the terminal foreground color.
*   **Return Codes:** None

### `lov_back_color_random()`
*   **Description:** Sets the background to a random color from the standard 8-color palette.
*   **Inputs:** None
*   **Outputs:** Sets the terminal background color.
*   **Return Codes:** None

#### Randomization and Utilities

### `lov_get_random_int()`
*   **Description:** Generates a random integer within a specified range (inclusive).
*   **Inputs:**
    *   `$1`: The minimum value of the range.
    *   `$2`: The maximum value of the range.
*   **Outputs:** Prints the random integer to `stdout`.
*   **Return Codes:** None
*   **Example:**
    ```bash
    local my_rand=$(lov_get_random_int 1 10)
    ```

### `lov_print_random_char_from_string()`
*   **Description:** Prints a single random character from the provided string.
*   **Inputs:**
    *   `$1`: The string to select a character from.
*   **Outputs:** Prints one random character to `stdout`, without a trailing newline.
*   **Return Codes:** None

---

## `library-of-voices.sh`

Step right up and lend an ear to the Library of Voices! This isn't your typical dusty, silent library. This is a sonic workshop, a collection of bash functions dedicated to giving your screensavers a voice. Whether you want your creations to whisper sweet nothings, shout existential questions into the void, or just say "hello," this library is your backstage pass to the world of Text-to-Speech (TTS).

---

### Function Reference

#### Core Functions

### `lov_detect_engine()`
*   **Description:** Detects the available TTS engine on the system and stores it in the `LOV_TTS_ENGINE` global variable. This function should be called once at the beginning of your script. It checks for a variety of engines, from `say` on macOS to `espeak` on Linux and even a `cscript` fallback for Windows.
*   **Inputs:** None
*   **Outputs:** Sets the `LOV_TTS_ENGINE` global variable.
*   **Return Codes:** None

### `lov_say()`
*   **Description:** Speaks the given text using the detected TTS engine. The speech is run as a background process. The process ID is stored in the `LOV_SPEAK_PID` global variable.
*   **Inputs:**
    *   `$1`: The phrase to be spoken.
*   **Outputs:**
    *   Initiates the TTS process.
    *   Sets the `LOV_SPEAK_PID` global variable to the process ID of the speech command.
*   **Return Codes:** None

### `lov_kill_speech()`
*   **Description:** Stops any currently running speech process that was started by `lov_say()`. This is useful for cleaning up when your script exits or when you want to interrupt the speech.
*   **Inputs:** None
*   **Outputs:** None
*   **Return Codes:** None

#### macOS Specific

### `lov_get_voices_say()`
*   **Description:** Fetches the list of available voices for the `say` command on macOS. This function is called automatically by `lov_detect_engine()` if the `say` command is found. The voices are stored in the `LOV_SAY_VOICES` global array.
*   **Inputs:** None
*   **Outputs:** Populates the `LOV_SAY_VOICES` array.
*   **Return Codes:** None
 
 
 
