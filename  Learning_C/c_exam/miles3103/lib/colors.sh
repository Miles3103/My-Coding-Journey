#!/usr/bin/env bash
# lib/colors.sh — Terminal color & theme system

# ── Detect color support ───────────────────────────────────────────────────
COLORS=0
if [ -t 1 ] && command -v tput &>/dev/null; then
    NCOLORS=$(tput colors 2>/dev/null || echo 0)
    [ "$NCOLORS" -ge 8 ] && COLORS=1
fi

if [ "$COLORS" -eq 1 ]; then
    # Base
    RESET='\033[0m'
    BOLD='\033[1m'
    DIM='\033[2m'
    ITALIC='\033[3m'
    UNDERLINE='\033[4m'

    # Foreground
    BLACK='\033[30m'
    RED='\033[31m'
    GREEN='\033[32m'
    YELLOW='\033[33m'
    BLUE='\033[34m'
    MAGENTA='\033[35m'
    CYAN='\033[36m'
    WHITE='\033[37m'
    GRAY='\033[90m'

    # Bright foreground
    BRED='\033[91m'
    BGREEN='\033[92m'
    BYELLOW='\033[93m'
    BBLUE='\033[94m'
    BMAGENTA='\033[95m'
    BCYAN='\033[96m'
    BWHITE='\033[97m'

    # Background
    BG_BLACK='\033[40m'
    BG_RED='\033[41m'
    BG_GREEN='\033[42m'
    BG_YELLOW='\033[43m'
    BG_BLUE='\033[44m'
    BG_MAGENTA='\033[45m'
    BG_CYAN='\033[46m'
    BG_WHITE='\033[47m'
    BG_GRAY='\033[100m'
else
    RESET='' BOLD='' DIM='' ITALIC='' UNDERLINE=''
    BLACK='' RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' CYAN='' WHITE='' GRAY=''
    BRED='' BGREEN='' BYELLOW='' BBLUE='' BMAGENTA='' BCYAN='' BWHITE=''
    BG_BLACK='' BG_RED='' BG_GREEN='' BG_YELLOW='' BG_BLUE=''
    BG_MAGENTA='' BG_CYAN='' BG_WHITE='' BG_GRAY=''
fi

# ── Semantic aliases ───────────────────────────────────────────────────────
C_PASS="$BGREEN"
C_FAIL="$BRED"
C_WARN="$BYELLOW"
C_INFO="$BCYAN"
C_MUTED="$GRAY"
C_FILE="$BWHITE"
C_TOPIC="$BMAGENTA"
C_SCORE="$BGREEN"
C_RANK="$BYELLOW"
C_STREAK="$BYELLOW"
C_PROMPT="$BCYAN"
C_CMD="$BWHITE"
C_TIP="$CYAN"
C_BORDER="$CYAN"

# ── Box-drawing helpers ────────────────────────────────────────────────────
# Usage: box_line "text" width [color]
box_line() {
    local text="$1" width="${2:-60}" color="${3:-$C_BORDER}"
    # Strip ANSI for length calculation
    local clean
    clean=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local tlen=${#clean}
    local padding=$(( width - tlen - 4 ))
    [ "$padding" -lt 0 ] && padding=0
    printf "${color}║${RESET} %b%*s ${color}║${RESET}\n" "$text" "$padding" ""
}

box_top()    { local w="${1:-60}" c="${2:-$C_BORDER}"; printf "${c}╔%s╗${RESET}\n" "$(printf '═%.0s' $(seq 1 $((w-2))))"; }
box_sep()    { local w="${1:-60}" c="${2:-$C_BORDER}"; printf "${c}╠%s╣${RESET}\n" "$(printf '═%.0s' $(seq 1 $((w-2))))"; }
box_bottom() { local w="${1:-60}" c="${2:-$C_BORDER}"; printf "${c}╚%s╝${RESET}\n" "$(printf '═%.0s' $(seq 1 $((w-2))))"; }
box_empty()  { local w="${1:-60}" c="${2:-$C_BORDER}"; printf "${c}║%*s║${RESET}\n" "$((w-2))" ""; }

# Thin box variant
tbox_top()    { local w="${1:-60}" c="${2:-$C_MUTED}"; printf "${c}┌%s┐${RESET}\n" "$(printf '─%.0s' $(seq 1 $((w-2))))"; }
tbox_sep()    { local w="${1:-60}" c="${2:-$C_MUTED}"; printf "${c}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 $((w-2))))"; }
tbox_bottom() { local w="${1:-60}" c="${2:-$C_MUTED}"; printf "${c}└%s┘${RESET}\n" "$(printf '─%.0s' $(seq 1 $((w-2))))"; }
tbox_line()   {
    local text="$1" width="${2:-60}" color="${3:-$RESET}"
    local clean
    clean=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local tlen=${#clean}
    local padding=$(( width - tlen - 4 ))
    [ "$padding" -lt 0 ] && padding=0
    printf "${C_MUTED}│${RESET} %b%*s ${C_MUTED}│${RESET}\n" "$text" "$padding" ""
}

# ── Print helpers ──────────────────────────────────────────────────────────
print_center() {
    local text="$1" width="${2:-60}" color="${3:-$RESET}"
    local clean
    clean=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local tlen=${#clean}
    local pad=$(( (width - tlen) / 2 ))
    printf "%*s%b%*s\n" "$pad" "" "${color}${text}${RESET}" "$pad" ""
}

hr() {
    local char="${1:-─}" width="${2:-60}" color="${3:-$C_MUTED}"
    printf "${color}%s${RESET}\n" "$(printf "${char}%.0s" $(seq 1 "$width"))"
}

# ── Spinner ────────────────────────────────────────────────────────────────
spinner_frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
spinner_pid=0

spinner_start() {
    local msg="${1:-Working...}"
    (
        local i=0
        while true; do
            printf "\r${C_INFO}${spinner_frames[$((i % 10))]}${RESET} ${msg}" >&2
            sleep 0.08
            (( i++ )) || true
        done
    ) &
    spinner_pid=$!
    disown "$spinner_pid" 2>/dev/null || true
}

spinner_stop() {
    if [ "$spinner_pid" -ne 0 ]; then
        kill "$spinner_pid" 2>/dev/null || true
        spinner_pid=0
        printf "\r%*s\r" 60 "" >&2
    fi
}
