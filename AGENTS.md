# 🤖 Agent Instructions

This file contains instructions for AI agents on how to interact with and contribute to this repository.

## 📜 General Agent Guidance

This section outlines the universal rules and expectations for any AI agent working within this repository.

* **Safety and Quality First:** The highest priority is to produce secure, well-documented, and high-quality code. Do not introduce vulnerabilities, hardcoded secrets, or unreadable code.

* **Propose a Plan:** For any new task, first provide a brief plan of action. This plan should clearly outline the intended changes and the rationale behind them.

* **Maintain Context:** Before making any changes, an agent must read and understand the relevant files, including the project's main documentation and existing code structure.

* **Clear Contributions:** All contributions must be submitted via a pull request with a clear, concise commit message and a brief description of the changes.

## 📝 Project-Specific Guidelines

### Tone and Style

*   **Art Gallery with Humor:** The overall tone of the project, especially in user-facing documentation like READMEs, should be that of a slightly quirky art gallery curator. Think "art gallery with a bit of humor".

### Bash Compatibility

*   **Bash v3.2 is the target**: The main `screensaver.sh` script must be compatible with Bash v3.2. This is to ensure it runs on a wide variety of systems, including older macOS versions.
*   **Individual screensavers**: Individual screensavers can use newer bash features, but it's good practice to stick to v3.2 if possible.
*   **Cross-platform**: All scripts should be written to be cross-platform, working on macOS, Linux, WSL, Cygwin, etc. Avoid using platform-specific commands without fallbacks.

### Screen Handling

*   **`tput` is your friend**: Use `tput` for all screen manipulations, such as moving the cursor, changing colors, and clearing the screen. This ensures that the scripts are portable across different terminal types.
*   **Colors**: Use `tput setaf` (foreground) and `tput setab` (background) for colors. The standard 8-color palette is the most portable.
*   **Animations**: Animations are created by a loop of clearing the screen (or parts of it), drawing the next frame, and then sleeping for a short period. `sleep 0.1` is a common choice.

### Project Structure

*   **`screensaver.sh`**: The main entry point. It displays a menu of screensavers and runs the chosen one.
*   **`gallery/`**: Each subdirectory in `gallery/` is a screensaver.
    *   `<name>/<name>.sh`: The main script for the screensaver.
    *   `<name>/config.sh`: Metadata for the screensaver (name, tagline, etc.).
*   **`spotlight/`**: Contains helper scripts for generating previews and other marketing materials.
*   **`jury/`**: Contains the `bats` test suite.

### General Tips

*   **Cleanup is crucial**: Always use `trap` to ensure that the terminal is restored to a usable state when the user presses `Ctrl+C`. This includes showing the cursor again (`tput cnorm`), resetting colors (`tput sgr0`), and clearing the screen.
*   **Subshells for safety**: The main `screensaver.sh` script runs each screensaver in a subshell. This is to prevent the screensaver from accidentally exiting the main menu.
*   **Tools**: This project uses `asciinema` to record terminal sessions as `.cast` files and `agg` to convert those `.cast` files into animated GIFs. The `spotlight/smile-for-the-camera.sh` script automates this process.

## 🧪 Testing

The tests for this project are written using the `bats` testing framework. Here are some key things to know about the test suite:

*   **Dependencies**: The tests require `bats`, `bats-support`, and `bats-assert`. These are not checked in to the repository and need to be installed. It is better to download the release tarballs and extract them rather than cloning with `git`.
*   **Test Structure**: The main test file is `jury/tests.bats`. It is responsible for testing the main `screensaver.sh` script. There are also individual test files for each screensaver in the `jury` directory.
*   **Running Tests**: The tests should be run from the root of the repository using the command `bats jury`. This will execute all the `.bats` files in the `jury` directory.
*   **Paths**: The test scripts are written with the assumption that they are being run from the root of the repository. All paths in the test files should be relative to the root.
*   **`timeout` and Assertions**: Many of the tests use `timeout` to run the screensavers for a short period. Since the screensavers are designed to run indefinitely, `timeout` will kill them, resulting in a non-zero exit code. Therefore, the tests should use `assert_failure` to check for this expected failure, not `assert_success`.
*   **Environment Limitations**: The testing environment can be restrictive. Commands like `cd`, `pwd`, and `git restore` may not work as expected. It's important to be aware of these limitations and find workarounds when necessary.

---
# 👨‍💻 Jules's Corner

This section contains notes and learnings specific to the agent Jules.

## Learnings on `tour-the-gallery.sh`

This document summarizes the issues I encountered and the solutions I implemented while debugging the `spotlight/tour-the-gallery.sh` script.

### Key Issues and Resolutions

1.  **Non-Standard Timeout Function:**
    *   **Issue:** The script initially used a custom `run_with_timeout` function which was not accessible within the subshell created by `asciinema rec`, causing recording failures.
    *   **Resolution:** I replaced the custom function with the standard Linux `timeout` command for better portability and reliability.

2.  **Hidden Dependency (`bc`):**
    *   **Issue:** The `speaky.sh` screensaver failed because it depends on the `bc` command-line calculator, which was not installed in the environment.
    *   **Resolution:** I identified and installed the `bc` package to satisfy the dependency.

3.  **Unsupported `asciinema` Subcommand:**
    *   **Issue:** The script used the `asciinema cut` subcommand, which is not available in the version of `asciinema` present in the execution environment.
    *   **Resolution:** I refactored the recording logic. Instead of recording a long 10-second clip and cutting a 3-second snippet, the script now directly records a 3-second snippet after a 3-second pause (`sleep 3; timeout 3s ...`), eliminating the need for the `cut` command.

4.  **Interactive Scripts in Non-Interactive Environment:**
    *   **Issue:** Several screensavers (e.g., `cutesaver.sh`, `life.sh`) used interactive `read` commands to pause between frames or wait for user input. This caused the main script to hang indefinitely.
    *   **Resolution:** I replaced the interactive `read` commands in the affected screensavers with non-interactive `sleep` commands.

### Unresolved Issues & Final State

*   **Persistent Timeouts:** Despite the fixes above, the `tour-the-gallery.sh` script continues to time out during the final step of converting the concatenated `.cast` file into a `.gif` using the `agg` command.
*   **Hypothesis:** The timeout is likely caused by one of two things:
    1.  The `agg` command is extremely slow when processing the large, concatenated `overview.cast` file.
    2.  One of the screensavers is still producing a subtly malformed `.cast` file that isn't caught by the validation logic, causing `agg` to hang or fail silently (by creating an empty GIF).

## Learnings on `agg` Installation

The `spotlight/smile-for-the-camera.sh` script requires the `agg` tool to generate GIFs. During my work on this project, I encountered significant difficulties installing `agg` in the provided environment. This section documents the issues for future reference.

*   **`pip install agg`:** The `pip` package for `agg` does not seem to install an executable, but rather a library. This means that `command -v agg` will fail even after a successful `pip` installation.
*   **Pre-built Binaries:** The official documentation for `agg` recommends downloading a pre-built binary from the GitHub releases page. However, I was unable to find a direct download link for the correct architecture (`x86_64-unknown-linux-gnu`) on the releases page. My attempts to guess the URL resulted in 404 errors.
*   **`x-cmd`:** I found a third-party tool called `x-cmd` that simplifies the installation of command-line tools. However, `x-cmd` itself is not installed in this environment, so I was unable to use it.

Due to these issues, I was unable to get a working version of `agg` installed. The tasks related to fixing the GIF generation for the `pipes` and `life` screensavers have been postponed until this issue can be resolved.

## Learnings on the Bats Test Environment

This section documents the issues encountered while attempting to fix the `bats` test suite in the `jury/` directory.

### Key Issues and Resolutions

1.  **Dependency Management:**
    *   **Issue:** The `bats` test dependencies (`bats-core`, `bats-support`, `bats-assert`) are not checked into the repository.
    *   **Resolution:** I created a setup script at `jury/assemble-the-jury.sh` to automate the download and extraction of these dependencies into a `jury/test_libs/` directory. I also added this directory to the `.gitignore` file.

2.  **Filesystem Persistence in the Environment:**
    *   **Issue:** The execution environment appears to have issues with filesystem persistence between separate `run_in_bash_session` tool calls. Changes made in one call (like downloading a file) were not always present in the next call, leading to "No such file or directory" errors.
    *   **Workaround:** To get a consistent result, I had to chain all commands (dependency download, extraction, and test execution) into a single, long `run_in_bash_session` command using `&&`.

### Unresolved Issues & Final State

*   **Path Loading in Bats:** The primary blocker is an issue with how `bats` loads dependency files. The test scripts use relative paths (e.g., `load 'libs/bats-support/load'`). My attempts to correct these paths to point to the new `jury/test_libs` directory were unsuccessful.
*   **Hypothesis:** The `bats` executable, when run from the repository root, seems to have an unexpected behavior in this environment when resolving the relative `load` paths from within the test files. For example, my attempts to change the path to `jury/test_libs/bats-support/load` resulted in `bats` looking for `/app/jury/jury/test_libs/...`, indicating a misinterpretation of the path. All attempts to modify the files programmatically resulted in corrupted paths.
*   **Final State:** The test environment setup is now automated via `jury/assemble-the-jury.sh`. However, the tests themselves are still not runnable due to the path loading issue. The `.bats` files have been restored to their original, incorrect state. A future developer should focus on fixing the `load` paths within the `.bats` files, perhaps by experimenting with different relative paths (`../test_libs`) or other `bats` loading mechanisms.
