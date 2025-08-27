#!/usr/bin/env bash
#
# spread-the-word.sh
#
# This script generates git commands to create a spotlight message
# on the GitHub project page.
#

# Determine the repository root directory, regardless of where the script is run from
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO_ROOT=$(dirname "$SCRIPT_DIR")

# The 14 files/directories that are most likely to be at the top of the repo page.
# This list is hardcoded and can be customized by editing this script.
TARGETS=(
    "$REPO_ROOT/.github/workflows/create.release.for.tag.yml"
    "$REPO_ROOT/gallery/README.md"
    "$REPO_ROOT/jury/README.md"
    "$REPO_ROOT/library/README.md"
    "$REPO_ROOT/spotlight/README.md"
    "$REPO_ROOT/.editorconfig"
    "$REPO_ROOT/.gitattributes"
    "$REPO_ROOT/.gitignore"
    "$REPO_ROOT/AGENTS.md"
    "$REPO_ROOT/CONTRIBUTING.md"
    "$REPO_ROOT/LICENSE"
    "$REPO_ROOT/README.md"
    "$REPO_ROOT/jules.md"
    "$REPO_ROOT/screensaver.sh"
)

# The message file
MESSAGE_FILE="$REPO_ROOT/spotlight/message.txt"

# Check if the message file exists
if [ ! -f "$MESSAGE_FILE" ]; then
    echo "Message file not found: $MESSAGE_FILE"
    exit 1
fi

# Read the messages into an array
mapfile -t MESSAGES < "$MESSAGE_FILE"

# Check if we have enough messages
if [ "${#MESSAGES[@]}" -lt "${#TARGETS[@]}" ]; then
    echo "Not enough messages in $MESSAGE_FILE"
    echo "Found ${#MESSAGES[@]} messages, but need ${#TARGETS[@]}."
    exit 1
fi

# Generate the git commands
for i in "${!TARGETS[@]}"; do
    target="${TARGETS[$i]}"
    message="${MESSAGES[$i]}"

    # Generate the command to make a trivial change to the file
    echo "echo ' ' >> \"$target\""

    # Generate the git commands
    echo "git add \"$target\""
    echo "git commit -m \"$message\""
    echo ""
done

echo "# Run the commands above to spread the word!"
