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

# Dynamically generate the list of target files.
# The goal is to select the files that are most prominent on the repo's main page.
# The logic is as follows:
# 1. List all files and directories in the root, directories first, excluding .git.
# 2. For each directory, find a representative file to modify.
#    - For `.github`, we look for `.yml` workflow files in the `workflows` subdir.
#    - For other directories, this is `README.md`.
# 3. For each file in the root, use the file itself.
TARGETS=()
while IFS= read -r item; do
    path="$REPO_ROOT/$item"
    if [[ -d "$path" ]]; then
        if [[ "$item" == ".github" ]]; then
            # Find all .yml files in the .github/workflows directory.
            # Use process substitution to avoid creating a subshell for the while loop,
            # which would prevent the TARGETS array from being modified.
            while IFS= read -r -d '' yml_file; do
                TARGETS+=("$yml_file")
            done < <(find "$path/workflows" -name "*.yml" -print0)
        else
            # For other directories, look for a README.md
            if [[ -f "$path/README.md" ]]; then
                TARGETS+=("$path/README.md")
            fi
        fi
    else
        # If it's a file, add it to the list
        TARGETS+=("$path")
    fi
done < <(cd "$REPO_ROOT" && ls -A --group-directories-first | grep -v '^\.git$')

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
    cat <<EOF
# Trivial commit logic for '$target'
# Count trailing blank lines (lines with only whitespace)
trailing_lines=\$(awk 'BEGIN{c=0} {if (\$0 ~ /[^[:space:]]/) {c=0} else {c++}} END{print c}' "$target")
case \$trailing_lines in
    0)
        # 0 trailing blank lines, add one
        echo "" >> "$target"
        ;;
    1)
        # 1 trailing blank line, add one more
        echo "" >> "$target"
        ;;
    *)
        # 2 or more trailing blank lines, reduce to 1.
        # This is done by stripping all trailing blank lines and then adding one back.
        # A temp file is used to ensure sed portability (avoiding -i).
        sed -e :a -e '/^\\s*\$/{\$d;N;};/\\n\$/ba' "$target" > "$target.tmp" && mv "$target.tmp" "$target"
        echo "" >> "$target"
        ;;
esac
EOF

    # Generate the git commands
    echo "git add \"$target\""
    echo "git commit -m \"$message\""
    echo ""
done

echo "# Run the commands above to spread the word!"
