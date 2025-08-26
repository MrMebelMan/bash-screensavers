#!/usr/bin/env bash
#
# Library of Voices
#
# A collection of bash functions for adding voice to your screensavers.
# This library provides tools for text-to-speech (TTS) synthesis.
#
# The `lov_` prefix is used to avoid conflicts with other scripts.
#
# Usage:
#   source library-of-voices.sh
#   lov_detect_engine
#   lov_say "Hello, world!"
#
# Version: 0.0.1
#

# --- Text-to-Speech (TTS) Helper ---
LOV_TTS_ENGINE=""
LOV_SPEAK_PID=0
LOV_SAY_VOICES=()

# Get voices for macOS 'say' command
#
# Output: LOV_SAY_VOICES - array of voice names
lov_get_voices_say() {
    if ! command -v say &>/dev/null; then
        return
    fi
    local raw_voices
    raw_voices=$(say -v '?')
    if [[ -z "$raw_voices" ]]; then
        return
    fi
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local line_no_comment="${line%%#*}"
        local locale
        locale=$(awk '{ for (i=NF; i>0; i--) { if ($i ~ /^[a-z][a-z]_[A-Z][A-Z]$/) { print $i; exit } } }' <<<"$line_no_comment")
        [[ -z "$locale" ]] && continue
        local voice
        voice=$(awk -v loc="$locale" '{ for (i=1; i<=NF; i++) { if ($i == loc) { for (j=1; j<i; j++) { printf "%s%s", $j, (j<i-1 ? OFS : "") }; exit } } }' <<<"$line_no_comment")
        if [[ -n "$voice" ]]; then
            # Filter for English and approved bilingual voices.
            # Some non-English voices are surprisingly good with English phrases,
            # and some English voices are... not. This is a curated list.
            if [[ "$locale" == en* ]] ||
               [[ "$voice" == "Emilio" ]] ||
               [[ "$voice" == "Valeria" ]] ||
               [[ "$voice" == "Rod" ]] ||
               [[ "$voice" == "Rodrigo" ]]; then
                LOV_SAY_VOICES+=("$voice")
            fi
        fi
    done <<<"$raw_voices"
}

lov_detect_engine() {
    LOV_TTS_ENGINE=""
    if command -v say &>/dev/null; then
        LOV_TTS_ENGINE="say"
        lov_get_voices_say
    elif command -v spd-say &>/dev/null; then LOV_TTS_ENGINE="spd-say";
    elif command -v espeak &>/dev/null; then LOV_TTS_ENGINE="espeak";
    elif command -v festival &>/dev/null; then LOV_TTS_ENGINE="festival";
    elif command -v flite &>/dev/null; then LOV_TTS_ENGINE="flite";
    elif command -v gtts-cli &>/dev/null && command -v aplay &>/dev/null; then LOV_TTS_ENGINE="gtts-cli";
    elif command -v pico2wave &>/dev/null && command -v aplay &>/dev/null; then LOV_TTS_ENGINE="pico2wave";
    elif command -v powershell.exe &>/dev/null; then LOV_TTS_ENGINE="powershell";
    elif command -v cscript &>/dev/null; then
        local lib_dir; lib_dir=$(dirname "${BASH_SOURCE[0]}")
        local vbs_path="$lib_dir/tts.vbs"
        if [ -f "$vbs_path" ]; then LOV_TTS_ENGINE="cscript"; fi
    fi
}

lov_say() {
    if [ -z "$LOV_TTS_ENGINE" ]; then return; fi
    local phrase="$1"; local phrase_ps; phrase_ps=$(echo "$phrase" | sed "s/'/''/g")
    case "$LOV_TTS_ENGINE" in
        "say")
            if [ ${#LOV_SAY_VOICES[@]} -gt 0 ]; then
                local random_voice=${LOV_SAY_VOICES[$RANDOM % ${#LOV_SAY_VOICES[@]}]}
                say -v "$random_voice" "$phrase" &
            else
                say "$phrase" &
            fi
            ;;
        "spd-say")    spd-say -r -20 "$phrase" & ;;
        "espeak")     espeak "$phrase" & ;;
        "flite")      flite -t "$phrase" & ;;
        "festival")   echo "$phrase" | festival --tts & ;;
        "gtts-cli")   gtts-cli -l en - --output - "$phrase" | aplay & ;;
        "pico2wave")
            local tmpfile
            tmpfile=$(mktemp /tmp/speaky_tts.XXXXXX.wav)
            pico2wave -l en-US -w "$tmpfile" "$phrase" && aplay "$tmpfile" && rm "$tmpfile" & ;;
        "powershell")
            powershell.exe -Command "Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('$phrase_ps')" & ;;
        "cscript")
            local lib_dir; lib_dir=$(dirname "${BASH_SOURCE[0]}")
            local vbs_path="$lib_dir/tts.vbs"
            cscript //nologo /E:vbscript "$vbs_path" "$phrase" & ;;
    esac
    LOV_SPEAK_PID=$!
}

lov_kill_speech() {
    if [ "$LOV_SPEAK_PID" -ne 0 ]; then
        # Kill the process and any children
        if command -v pkill &>/dev/null; then
            pkill -P "$LOV_SPEAK_PID" &>/dev/null
        else
            # Fallback for systems without pkill (like Cygwin)
            kill $(ps -ef | awk -v ppid="$LOV_SPEAK_PID" '$3==ppid {print $2}') &>/dev/null
        fi
        kill "$LOV_SPEAK_PID" &>/dev/null
        wait "$LOV_SPEAK_PID" &>/dev/null
    fi
}
