# Bash Screensavers Libraries

This directory contains reusable libraries for the Bash Screensavers project.

---

## `library-of-visualizations.sh`

Welcome, aspiring terminal artist, to the Library of Visualizations! Think of this as your personal art supply store for the command line. Instead of oils and acrylics, we offer a curated collection of bash functions to paint your terminal with dazzling displays. Whether you need to splash some color, move things around, or just make your script exit with a bit of flair, this is the place to be. No smocks required.

To use it, source it in your script:
`bash
# Make sure to get the path to the library correctly
source /path/to/library/library-of-visualizations.sh
`
Function Reference
Cleanup and Setup
lov_die_with_honor()
Description: Cleans up the terminal and exits the script. This function is intended to be called by a trap on EXIT, making sure that the terminal is restored to a usable state.
Inputs: None
Outputs: None
Return Codes: None
lov_cleanup()
Description: Restores the terminal to a sane state. It shows the cursor and resets any color or text attributes.
Inputs: None
Outputs: Restores terminal settings.
Return Codes: None
Cursor Control
lov_hide_cursor()
Description: Hides the terminal cursor.
Inputs: None
Outputs: Hides the cursor.
Return Codes: None
lov_show_cursor()
Description: Shows the terminal cursor. This is the normal state. lov_cleanup also calls this function.
Inputs: None
Outputs: Shows the cursor.
Return Codes: None
lov_move_cursor()
Description: Moves the cursor to a specific position on the screen.
Inputs:
$1: The row number (0-based).
$2: The column number (0-based).
Outputs: Moves the cursor.
Return Codes: None
lov_move_cursor_random()
Description: Moves the cursor to a random position on the screen. NOTE: lov_get_terminal_size must be called first to set the LOV_TERM_HEIGHT and LOV_TERM_WIDTH global variables.
Inputs: None
Outputs: Moves the cursor to a random position.
Return Codes: None
Screen and Terminal
lov_get_terminal_size()
Description: Gets the current terminal size and stores it in global variables.
Inputs: None
Outputs: Sets the following global variables:
LOV_TERM_HEIGHT: The height of the terminal in rows.
LOV_TERM_WIDTH: The width of the terminal in columns.
Return Codes: None
lov_clear_screen()
Description: Clears the entire terminal screen.
Inputs: None
Outputs: Clears the screen.
Return Codes: None
Color Control
lov_fore_color()
Description: Sets the foreground color.
Inputs:
$1: The color number (0-7). 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white
Outputs: Sets the terminal foreground color.
Return Codes: None
lov_back_color()
Description: Sets the background color.
Inputs:
$1: The color number (0-7). 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white
Outputs: Sets the terminal background color.
Return Codes: None
lov_fore_color_random()
Description: Sets the foreground to a random color from the standard 8-color palette.
Inputs:
$1 (optional): If set to "no_black", the color black (0) will be excluded.
Outputs: Sets the terminal foreground color.
Return Codes: None
lov_back_color_random()
Description: Sets the background to a random color from the standard 8-color palette.
Inputs: None
Outputs: Sets the terminal background color.
Return Codes: None
Randomization and Utilities
lov_get_random_int()
Description: Generates a random integer within a specified range (inclusive).
Inputs:
$1: The minimum value of the range.
$2: The maximum value of the range.
Outputs: Prints the random integer to stdout.
Return Codes: None
Example:
local my_rand=$(lov_get_random_int 1 10)
lov_print_random_char_from_string()
Description: Prints a single random character from the provided string.
Inputs:
$1: The string to select a character from.
Outputs: Prints one random character to stdout, without a trailing newline.
Return Codes: None
