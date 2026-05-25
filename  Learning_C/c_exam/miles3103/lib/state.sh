#!/usr/bin/env bash
# lib/state.sh — Persistent state management

DATA_DIR="$SCRIPT_DIR/.data"
SAVES_DIR="$SCRIPT_DIR/saves"
RENDU_DIR="$SCRIPT_DIR/rendu"
TRACES_DIR="$SCRIPT_DIR/traces"
SUBJECTS_DIR="$SCRIPT_DIR/subjects"

# ── Init ───────────────────────────────────────────────────────────────────
init_dirs() {
    mkdir -p "$DATA_DIR" "$SAVES_DIR" "$RENDU_DIR" "$TRACES_DIR" "$SUBJECTS_DIR"
    # Init state files if missing
    [[ -f "$DATA_DIR/level"    ]] || echo "0"  > "$DATA_DIR/level"
    [[ -f "$DATA_DIR/score"    ]] || echo "0"  > "$DATA_DIR/score"
    [[ -f "$DATA_DIR/streak"   ]] || echo "0"  > "$DATA_DIR/streak"
    [[ -f "$DATA_DIR/best"     ]] || echo "0"  > "$DATA_DIR/best"
    [[ -f "$DATA_DIR/passed"   ]] || touch        "$DATA_DIR/passed"
    [[ -f "$DATA_DIR/attempts" ]] || touch        "$DATA_DIR/attempts"
    [[ -f "$DATA_DIR/session"  ]] || echo "0"  > "$DATA_DIR/session"
    # Bump session counter
    local sess
    sess=$(cat "$DATA_DIR/session")
    echo $(( sess + 1 )) > "$DATA_DIR/session"
}

init_state() {
    # Called after init_dirs — nothing else needed, reads happen on demand
    :
}

# ── Accessors ──────────────────────────────────────────────────────────────
get_level()   { cat "$DATA_DIR/level"; }
get_score()   { cat "$DATA_DIR/score"; }
get_streak()  { cat "$DATA_DIR/streak"; }
get_best()    { cat "$DATA_DIR/best"; }
get_session() { cat "$DATA_DIR/session"; }

set_level()  { echo "$1" > "$DATA_DIR/level"; }
set_score()  { echo "$1" > "$DATA_DIR/score"; }
set_streak() { echo "$1" > "$DATA_DIR/streak"; }
set_best()   { echo "$1" > "$DATA_DIR/best"; }

add_score() {
    local cur
    cur=$(get_score)
    echo $(( cur + $1 )) > "$DATA_DIR/score"
}

inc_streak() {
    local s=$(( $(get_streak) + 1 ))
    echo "$s" > "$DATA_DIR/streak"
    local b
    b=$(get_best)
    [ "$s" -gt "$b" ] && echo "$s" > "$DATA_DIR/best"
}

reset_streak() { echo "0" > "$DATA_DIR/streak"; }

already_passed() { grep -qx "$1" "$DATA_DIR/passed" 2>/dev/null; }
mark_passed()    { echo "$1" >> "$DATA_DIR/passed"; }

get_passed_count() { wc -l < "$DATA_DIR/passed" 2>/dev/null | tr -d ' ' || echo 0; }

# ── Attempt tracking ───────────────────────────────────────────────────────
add_attempt() {
    local lvl="$1" result="$2"
    echo "${lvl}:${result}:$(date '+%H:%M:%S')" >> "$DATA_DIR/attempts"
}

get_attempts_for() {
    grep -c "^${1}:" "$DATA_DIR/attempts" 2>/dev/null || echo 0
}

get_passes_for() {
    grep -c "^${1}:PASS:" "$DATA_DIR/attempts" 2>/dev/null || echo 0
}

get_fails_for() {
    grep -c "^${1}:FAIL:" "$DATA_DIR/attempts" 2>/dev/null || echo 0
}

get_total_pass() {
    grep -c ":PASS:" "$DATA_DIR/attempts" 2>/dev/null || echo 0
}

get_total_fail() {
    grep -c ":FAIL:" "$DATA_DIR/attempts" 2>/dev/null || echo 0
}

get_total_attempts() {
    wc -l < "$DATA_DIR/attempts" 2>/dev/null | tr -d ' ' || echo 0
}

get_win_rate() {
    local tp tf ta
    tp=$(get_total_pass)
    ta=$(get_total_attempts)
    if [ "$ta" -gt 0 ]; then
        echo $(( tp * 100 / ta ))
    else
        echo 0
    fi
}

get_level_history() {
    local lvl="$1"
    grep "^${lvl}:" "$DATA_DIR/attempts" 2>/dev/null || true
}

# ── Rank ───────────────────────────────────────────────────────────────────
get_rank() {
    local s="$1"
    if   [ "$s" -ge 54 ]; then echo "★★★  C MASTER"
    elif [ "$s" -ge 42 ]; then echo "★★☆  Advanced Programmer"
    elif [ "$s" -ge 24 ]; then echo "★☆☆  Intermediate Coder"
    elif [ "$s" -ge 12 ]; then echo "☆☆☆  Junior Developer"
    else                        echo "☆☆☆  Apprentice"
    fi
}

get_rank_color() {
    local s="$1"
    if   [ "$s" -ge 54 ]; then echo "$BYELLOW"
    elif [ "$s" -ge 42 ]; then echo "$BMAGENTA"
    elif [ "$s" -ge 24 ]; then echo "$BCYAN"
    elif [ "$s" -ge 12 ]; then echo "$BWHITE"
    else                        echo "$GRAY"
    fi
}

# ── Progress bar ───────────────────────────────────────────────────────────
score_bar() {
    local score="$1" width="${2:-30}"
    local filled=$(( score * width / 60 ))
    local bar=""
    for (( i=1; i<=width; i++ )); do
        if [ "$i" -le "$filled" ]; then
            bar="${bar}█"
        else
            bar="${bar}░"
        fi
    done
    echo "$bar"
}

level_bar() {
    local level="$1"
    local bar=""
    for (( i=0; i<=MAX_LEVEL; i++ )); do
        if already_passed "$i"; then
            bar="${bar}${C_PASS}█${RESET}"
        elif [ "$i" -eq "$level" ]; then
            bar="${bar}${C_WARN}▶${RESET}"
        else
            bar="${bar}${C_MUTED}·${RESET}"
        fi
    done
    echo -e "$bar"
}

# ── Save/Load ──────────────────────────────────────────────────────────────
do_save() {
    local slot="${1:-quicksave}"
    slot=$(echo "$slot" | tr -cd '[:alnum:]_-')
    [ -z "$slot" ] && slot="quicksave"
    local dir="$SAVES_DIR/$slot"
    mkdir -p "$dir"
    cp "$DATA_DIR/level"    "$dir/"
    cp "$DATA_DIR/score"    "$dir/"
    cp "$DATA_DIR/streak"   "$dir/"
    cp "$DATA_DIR/best"     "$dir/"
    cp "$DATA_DIR/passed"   "$dir/"
    cp "$DATA_DIR/attempts" "$dir/"
    date '+%Y-%m-%d %H:%M:%S' > "$dir/timestamp"
    printf "level=%s score=%s passed=%s\n" \
        "$(get_level)" "$(get_score)" "$(get_passed_count)" > "$dir/meta"
    echo ""
    printf "  ${C_PASS}✓${RESET} Saved to slot ${BOLD}%s${RESET}  " "$slot"
    printf "(level=%s  score=%s/60  passed=%s)\n" \
        "$(get_level)" "$(get_score)" "$(get_passed_count)"
}

auto_save() {
    do_save "autosave" &>/dev/null || true
}

do_load() {
    local slot="${1:-quicksave}"
    slot=$(echo "$slot" | tr -cd '[:alnum:]_-')
    [ -z "$slot" ] && slot="quicksave"
    local dir="$SAVES_DIR/$slot"
    if [ ! -d "$dir" ]; then
        printf "  ${C_FAIL}✗${RESET} No save found: '${BOLD}%s${RESET}'. Use ${C_CMD}saves${RESET} to list.\n" "$slot"
        return 1
    fi
    local ts meta
    ts=$(cat "$dir/timestamp" 2>/dev/null || echo "unknown")
    meta=$(cat "$dir/meta" 2>/dev/null || echo "")
    echo ""
    printf "  ${C_WARN}Load save '${BOLD}%s${RESET}${C_WARN}' — %s (saved %s)?${RESET}\n" "$slot" "$meta" "$ts"
    printf "  ${C_WARN}This will overwrite current progress. Continue? [y/N]:${RESET} "
    local confirm
    read -r confirm < /dev/tty
    if [[ "${confirm,,}" == "y" ]]; then
        cp "$dir/level"    "$DATA_DIR/"
        cp "$dir/score"    "$DATA_DIR/"
        cp "$dir/streak"   "$DATA_DIR/"
        cp "$dir/best"     "$DATA_DIR/"
        cp "$dir/passed"   "$DATA_DIR/"
        cp "$dir/attempts" "$DATA_DIR/"
        printf "  ${C_PASS}✓${RESET} Loaded '${BOLD}%s${RESET}'  →  level=%s  score=%s/60\n" \
            "$slot" "$(get_level)" "$(get_score)"
        sleep 1
    else
        printf "  ${C_MUTED}Cancelled.${RESET}\n"
    fi
}

list_saves() {
    echo ""
    box_top 62
    box_line "  $(printf '%b' "${BOLD}${C_INFO}◆  SAVE SLOTS${RESET}")" 62
    box_sep 62
    local found=0
    for dir in "$SAVES_DIR"/*/; do
        [ -d "$dir" ] || continue
        found=1
        local slot ts meta
        slot=$(basename "$dir")
        ts=$(cat "$dir/timestamp"  2>/dev/null || echo "no date")
        meta=$(cat "$dir/meta" 2>/dev/null || echo "")
        local marker=""
        [[ "$slot" == "autosave" ]] && marker=" ${C_MUTED}[auto]${RESET}"
        box_line "  ${BOLD}${slot}${RESET}${marker}  ${C_MUTED}${meta}${RESET}  ${GRAY}${ts}${RESET}" 62
    done
    [ "$found" -eq 0 ] && box_line "  ${C_MUTED}No saves yet.${RESET}" 62
    box_sep 62
    box_line "  ${C_CMD}save [name]${RESET}   ${C_CMD}load [name]${RESET}   ${BRED}deletesave [name]${RESET}" 62
    box_bottom 62
    echo ""
    press_enter
}

delete_save() {
    local slot="${1:-}"
    [ -z "$slot" ] && { printf "  ${C_FAIL}Usage: deletesave <name>${RESET}\n"; return 1; }
    slot=$(echo "$slot" | tr -cd '[:alnum:]_-')
    local dir="$SAVES_DIR/$slot"
    if [ ! -d "$dir" ]; then
        printf "  ${C_FAIL}✗${RESET} No slot named '${BOLD}%s${RESET}'.\n" "$slot"
        return 1
    fi
    printf "  ${C_WARN}Delete save '${BOLD}%s${RESET}${C_WARN}'? [y/N]:${RESET} " "$slot"
    local confirm
    read -r confirm < /dev/tty
    if [[ "${confirm,,}" == "y" ]]; then
        rm -rf "$dir"
        printf "  ${BRED}Deleted${RESET} save slot '${BOLD}%s${RESET}'.\n" "$slot"
        sleep 1
    else
        printf "  ${C_MUTED}Cancelled.${RESET}\n"
    fi
}

# ── Reset ──────────────────────────────────────────────────────────────────
do_reset_level() {
    printf "  ${C_WARN}Reset level counter to 0? Score is kept. [y/N]:${RESET} "
    local confirm
    read -r confirm < /dev/tty
    if [[ "${confirm,,}" == "y" ]]; then
        set_level 0
        printf "  ${C_WARN}Level reset to 0.${RESET}\n"
        sleep 1
    fi
}

do_reset_all() {
    printf "  ${BRED}${BOLD}FULL RESET — erase ALL progress, score, streaks? [y/N]:${RESET} "
    local confirm
    read -r confirm < /dev/tty
    if [[ "${confirm,,}" == "y" ]]; then
        echo "0" > "$DATA_DIR/level"
        echo "0" > "$DATA_DIR/score"
        echo "0" > "$DATA_DIR/streak"
        echo "0" > "$DATA_DIR/best"
        > "$DATA_DIR/passed"
        > "$DATA_DIR/attempts"
        printf "  ${BRED}Full reset complete.${RESET}\n"
        sleep 1
    fi
}
