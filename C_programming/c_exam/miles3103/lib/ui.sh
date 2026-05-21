#!/usr/bin/env bash
# lib/ui.sh — All display/UI components

# ── Shared helpers ─────────────────────────────────────────────────────────
press_enter() {
    printf "  ${C_MUTED}Press Enter to continue...${RESET}"
    read -r _ < /dev/tty
}

# ── Splash / Header ────────────────────────────────────────────────────────
show_splash() {
    clear
    local sess
    sess=$(get_session)
    echo ""
    echo -e "${BOLD}${BCYAN}"
    cat << 'BANNER'
  ███╗   ███╗██╗██╗     ███████╗███████╗██████╗  ██╗ ██████╗ ██████╗
  ████╗ ████║██║██║     ██╔════╝██╔════╝╚════██╗███║██╔═████╗╚════██╗
  ██╔████╔██║██║██║     █████╗  ███████╗ █████╔╝╚██║██║██╔██║ █████╔╝
  ██║╚██╔╝██║██║██║     ██╔══╝  ╚════██║ ╚═══██╗ ██║████╔╝██║ ╚═══██╗
  ██║ ╚═╝ ██║██║███████╗███████╗███████║██████╔╝ ██║╚██████╔╝██████╔╝
  ╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚══════╝╚═════╝  ╚═╝ ╚═════╝ ╚═════╝
BANNER
    echo -e "${RESET}"
    echo -e "  ${BOLD}${BCYAN}C Low-Level Mastery Shell${RESET}  ${C_MUTED}v15.0 · Professional Edition${RESET}"
    echo -e "  ${C_MUTED}60 Levels · C Intro → Pointers · Session #${sess}${RESET}"
    echo ""
    hr "─" 70
    echo ""
    sleep 0.6
}

# ── Main header (per-loop) ─────────────────────────────────────────────────
show_header() {
    local level="$1"
    local score
    score=$(get_score)
    local rank
    rank=$(get_rank "$score")
    local rank_color
    rank_color=$(get_rank_color "$score")
    local streak
    streak=$(get_streak)
    local topic
    topic=$(get_topic "$level")
    local fname
    fname=$(get_filename "$level")
    local subtask
    subtask=$(get_subtask "$level")
    local total_fail
    total_fail=$(get_total_fail)
    local passed_count
    passed_count=$(get_passed_count)

    clear
    echo ""
    # ── Top bar ──────────────────────────────────────────────────────────
    box_top 70
    printf "${C_BORDER}║${RESET}  ${BOLD}${BCYAN}MILES3103${RESET} — C Mastery Exam  ${C_MUTED}v15.0${RESET}%*s${C_BORDER}║${RESET}\n" 28 ""
    box_sep 70

    # Score row
    local bar
    bar=$(score_bar "$score" 24)
    printf "${C_BORDER}║${RESET}  Score  ${C_SCORE}${BOLD}%2s${RESET}/60  [${C_SCORE}%s${C_MUTED}%s${RESET}]  %b%s%b  %*s${C_BORDER}║${RESET}\n" \
        "$score" \
        "$(echo "$bar" | head -c $(( score * 24 / 60 )))" \
        "$(echo "$bar" | tail -c $(( 24 - score * 24 / 60 + 1 )))" \
        "$rank_color" "$rank" "$RESET" \
        0 ""
    # Simpler reliable version:
    local filled=$(( score * 24 / 60 ))
    local empty=$(( 24 - filled ))
    local bar_str=""
    for (( i=0; i<filled; i++ )); do bar_str="${bar_str}█"; done
    for (( i=0; i<empty;  i++ )); do bar_str="${bar_str}░"; done

    printf "${C_BORDER}║${RESET}  ${BOLD}Score${RESET}  ${C_SCORE}${BOLD}%2s${RESET}/60  [${C_SCORE}%s${C_MUTED}%s${RESET}]  ${rank_color}%s${RESET}%*s${C_BORDER}║${RESET}\n" \
        "$score" \
        "$(printf '%0.s█' $(seq 1 $filled) 2>/dev/null || printf "${bar_str:0:$filled}")" \
        "$(printf '%0.s░' $(seq 1 $empty)  2>/dev/null || printf "${bar_str:$filled}")" \
        "$rank" \
        $(( 70 - 2 - 2 - 5 - 2 - 2 - 2 - 24 - 2 - ${#rank} - 2 )) ""

    box_sep 70
    # Level info row
    printf "${C_BORDER}║${RESET}  ${BOLD}Level${RESET}   ${BYELLOW}%2s${RESET} / %s     ${BOLD}Topic${RESET}  ${C_TOPIC}%-14s${RESET}  ${C_MUTED}Task %s/3${RESET}%*s${C_BORDER}║${RESET}\n" \
        "$level" "$MAX_LEVEL" "$topic" "$subtask" \
        $(( 70 - 2 - 2 - 5 - 2 - 2 - 5 - 2 - 2 - 5 - 2 - ${#topic} - 2 - 6 - 2 )) ""
    # File row
    printf "${C_BORDER}║${RESET}  ${BOLD}File${RESET}    ${C_FILE}rendu/%s/%s${RESET}%*s${C_BORDER}║${RESET}\n" \
        "$(get_dirname "$level")" "$fname" \
        $(( 70 - 2 - 2 - 4 - 4 - ${#fname} - ${#fname%.*} - 1 - 2 )) ""
    box_sep 70
    # Stats row
    local fails_here
    fails_here=$(get_fails_for "$level")
    local passes_here
    passes_here=$(get_passes_for "$level")
    printf "${C_BORDER}║${RESET}  Attempts  ${C_PASS}%s✓${RESET}  ${C_FAIL}%s✗${RESET}  this level" \
        "$passes_here" "$fails_here"
    printf "     All-time fails ${C_FAIL}%s${RESET}   Streak ${C_STREAK}%s${RESET}%*s${C_BORDER}║${RESET}\n" \
        "$total_fail" "$streak" 2 ""
    box_bottom 70
    echo ""
    # Progress bar
    echo -ne "  ${C_MUTED}[${RESET}"
    level_bar "$level"
    echo -e "${C_MUTED}]${RESET}  ${C_MUTED}${passed_count}/60 cleared${RESET}"
    echo ""
}

# ── Subject display ────────────────────────────────────────────────────────
show_subject() {
    local level="$1"
    local file="$SUBJECTS_DIR/lvl${level}.txt"
    [ ! -f "$file" ] && return
    echo ""
    tbox_top 70
    local hdr="  ${BOLD}${BCYAN}LEVEL ${level}${RESET} — $(get_topic "$level") [$(get_subtask "$level")/3]"
    tbox_line "$hdr" 70
    tbox_sep 70
    while IFS= read -r line; do
        if   echo "$line" | grep -qiE "^(Expected output|Tip):"; then
            tbox_line "  ${BYELLOW}${line}${RESET}" 70
        elif echo "$line" | grep -q "^FILE:"; then
            tbox_line "  ${C_FILE}${line}${RESET}" 70
        elif echo "$line" | grep -q "^==="; then
            : # skip redundant header lines
        else
            tbox_line "  ${line}" 70
        fi
    done < "$file"
    tbox_bottom 70
    echo ""
}

# ── Diff display ───────────────────────────────────────────────────────────
show_diff() {
    local expected="$1"
    local got="$2"
    local level="$3"

    # Special case: dynamic output
    if [ "$level" -eq 54 ]; then
        echo ""
        printf "  ${C_WARN}Note:${RESET} Addresses vary per run — checking label format only.\n"
        printf "  ${C_PASS}Expected:${RESET} global: 0x...  /  stack: 0x...  /  heap: 0x...\n"
        echo ""
        return
    fi

    echo ""
    # Header
    printf "  ${C_MUTED}┌──────────────────────────────────┬──────────────────────────────────┐${RESET}\n"
    printf "  ${C_MUTED}│${RESET}  ${C_PASS}%-32s${RESET}${C_MUTED}│${RESET}  ${C_FAIL}%-32s${RESET}${C_MUTED}│${RESET}\n" "EXPECTED" "YOUR OUTPUT"
    printf "  ${C_MUTED}├──────────────────────────────────┼──────────────────────────────────┤${RESET}\n"

    local exp_lines got_lines idx=0 first_diff_line="" first_diff_exp="" first_diff_got=""
    IFS=$'\n' read -r -d '' -a exp_lines <<< "${expected}" || true
    IFS=$'\n' read -r -d '' -a got_lines <<< "${got}"      || true
    local total_exp=${#exp_lines[@]}
    local total_got=${#got_lines[@]}
    local total=$(( total_exp > total_got ? total_exp : total_got ))

    for (( i=0; i<total; i++ )); do
        local eL="${exp_lines[$i]:-}"
        local gL="${got_lines[$i]:-}"
        local mark status_e status_g
        if [ "$eL" = "$gL" ]; then
            mark="${C_PASS}✓${RESET}"
            status_e="${C_PASS}"
            status_g="${C_PASS}"
        else
            mark="${C_FAIL}✗${RESET}"
            status_e="${C_PASS}"
            status_g="${C_FAIL}"
            if [ -z "$first_diff_exp" ] && [ "$idx" -eq 0 ]; then
                first_diff_exp="$eL"
                first_diff_got="$gL"
                first_diff_line=$(( i + 1 ))
                idx=1
            fi
        fi
        local eDisp="${eL:0:30}"
        local gDisp="${gL:0:30}"
        [ -z "$gL" ] && gDisp="(empty)"
        printf "  ${C_MUTED}│${RESET}  ${status_e}%-32s${RESET}${C_MUTED}│${RESET}  ${status_g}%-32s${RESET}${C_MUTED}│${RESET} %b\n" \
            "${eDisp:-(empty)}" "${gDisp}" "$mark"
    done
    printf "  ${C_MUTED}└──────────────────────────────────┴──────────────────────────────────┘${RESET}\n"

    # Line count
    if [ "$total_exp" -ne "$total_got" ]; then
        printf "\n  ${C_FAIL}Line count mismatch: expected %s, got %s${RESET}\n" "$total_exp" "$total_got"
    fi

    # Char-level hint
    if [ -n "$first_diff_exp" ] || [ "$first_diff_line" != "" ]; then
        echo ""
        printf "  ${BOLD}First difference — line %s:${RESET}\n" "${first_diff_line:-?}"
        local elen="${#first_diff_exp}" glen="${#first_diff_got}"
        local maxl=$(( elen > glen ? elen : glen ))
        local pos=0
        for (( c=0; c<maxl; c++ )); do
            if [ "${first_diff_exp:$c:1}" != "${first_diff_got:$c:1}" ]; then
                pos=$c; break
            fi
            pos=$(( c + 1 ))
        done
        local ec="${first_diff_exp:$pos:1}" gc="${first_diff_got:$pos:1}"
        [ -z "$ec" ] && ec="(end)"
        [ -z "$gc" ] && gc="(end)"
        printf "  ${C_PASS}Expected char @ pos %s: '%s'${RESET}\n" "$pos" "$ec"
        printf "  ${C_FAIL}Got char      @ pos %s: '%s'${RESET}\n" "$pos" "$gc"
        echo ""
        printf "  ${C_PASS}%s${RESET}\n" "${first_diff_exp}"
        printf "  ${C_FAIL}%s${RESET}\n" "${first_diff_got}"
        local arrow
        arrow="$(printf '%*s' "$pos" '')^"
        printf "  ${BYELLOW}%s${RESET}\n" "$arrow"
    fi
    echo ""
}

# ── Output block ───────────────────────────────────────────────────────────
show_output() {
    local output="$1"
    echo ""
    tbox_top 70
    tbox_line "  ${BOLD}Program Output${RESET}" 70
    tbox_sep 70
    if [ -z "$output" ]; then
        tbox_line "  ${C_MUTED}(no output)${RESET}" 70
    else
        while IFS= read -r line; do
            tbox_line "  ${C_MUTED}│${RESET} ${line}" 66
        done <<< "$output"
    fi
    tbox_bottom 70
}

# ── Pass/Fail banners ──────────────────────────────────────────────────────
show_pass_banner() {
    local level="$1" score="$2" streak="$3" is_new="$4"
    echo ""
    echo -e "${C_PASS}  ╔══════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${C_PASS}  ║                                                          ║${RESET}"
    printf   "${C_PASS}  ║   ✓  PASS  —  Level %-3s cleared!%-24s║${RESET}\n" "$level" ""
    echo -e "${C_PASS}  ║                                                          ║${RESET}"
    echo -e "${C_PASS}  ╚══════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    if [ "$is_new" -eq 1 ]; then
        printf "  ${C_SCORE}+1 point awarded!${RESET}  Total score: ${BOLD}%s/60${RESET}\n" "$score"
    else
        printf "  ${C_MUTED}(already cleared — no extra point)${RESET}  Score: ${BOLD}%s/60${RESET}\n" "$score"
    fi
    if [ "$streak" -ge 5 ]; then
        printf "  ${BYELLOW}⚡ %s win streak — on fire!${RESET}\n" "$streak"
    elif [ "$streak" -ge 3 ]; then
        printf "  ${C_STREAK}🔥 %s win streak!${RESET}\n" "$streak"
    fi
    echo ""
}

show_fail_banner() {
    local level="$1" attempts="$2" fails="$3" total_fail="$4"
    echo ""
    echo -e "${C_FAIL}  ╔══════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${C_FAIL}  ║                                                          ║${RESET}"
    printf   "${C_FAIL}  ║   ✗  FAIL  —  Level %-3s%-36s║${RESET}\n" "$level" ""
    echo -e "${C_FAIL}  ║                                                          ║${RESET}"
    echo -e "${C_FAIL}  ╚══════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    printf "  Attempt ${BOLD}#%s${RESET} on level ${BOLD}%s${RESET}  —  " "$attempts" "$level"
    printf "Fails this level: ${C_FAIL}%s${RESET}  |  All-time fails: ${C_FAIL}%s${RESET}\n" "$fails" "$total_fail"
    echo ""
}

# ── Attempt tips ───────────────────────────────────────────────────────────
show_fail_tips() {
    local attempts="$1" level="$2"
    if [ "$attempts" -eq 1 ]; then
        printf "  ${C_TIP}Tip:${RESET} Compare your output letter-by-letter with the expected.\n"
    elif [ "$attempts" -eq 2 ]; then
        printf "  ${C_TIP}Tip:${RESET} Check for extra spaces, missing newlines, or wrong spelling.\n"
    elif [ "$attempts" -ge 3 ]; then
        printf "  ${C_TIP}Tip:${RESET} Type ${C_CMD}hint${RESET} to re-read the subject. Attempt #%s.\n" "$attempts"
    fi
    echo ""
    printf "  ${BOLD}Next steps:${RESET}\n"
    printf "  · ${C_CMD}hint${RESET}    — re-read the subject\n"
    printf "  · ${C_CMD}open${RESET}    — open your file in \$EDITOR\n"
    printf "  · ${C_CMD}diff${RESET}    — show last diff again\n"
    printf "  · ${C_CMD}skip${RESET}    — skip this level (no points)\n"
    echo ""
}

# ── Scoreboard ─────────────────────────────────────────────────────────────
show_scoreboard() {
    local score
    score=$(get_score)
    local level
    level=$(get_level)
    local streak
    streak=$(get_streak)
    local best
    best=$(get_best)
    local passed_count
    passed_count=$(get_passed_count)
    local pct=$(( score * 100 / 60 ))
    local rank
    rank=$(get_rank "$score")
    local rank_color
    rank_color=$(get_rank_color "$score")
    local tp tf ta wr
    tp=$(get_total_pass)
    tf=$(get_total_fail)
    ta=$(get_total_attempts)
    wr=$(get_win_rate)

    echo ""
    box_top 62
    box_line "  ${BOLD}${BCYAN}◆  SCOREBOARD  ◆${RESET}" 62
    box_sep 62
    printf "${C_BORDER}║${RESET}  %-18s ${BOLD}${C_SCORE}%s${RESET} / 60 points%*s${C_BORDER}║${RESET}\n" \
        "Total Score" "$score" $(( 62 - 2 - 18 - 2 - ${#score} - 10 - 2 )) ""
    printf "${C_BORDER}║${RESET}  %-18s ${BYELLOW}%s%%${RESET} complete%*s${C_BORDER}║${RESET}\n" \
        "Progress" "$pct" $(( 62 - 2 - 18 - 2 - ${#pct} - 1 - 9 - 2 )) ""
    printf "${C_BORDER}║${RESET}  %-18s ${BOLD}%s${RESET} / 60%*s${C_BORDER}║${RESET}\n" \
        "Levels Passed" "$passed_count" $(( 62 - 2 - 18 - 2 - ${#passed_count} - 4 - 2 )) ""

    local bar
    bar=$(score_bar "$score" 30)
    printf "${C_BORDER}║${RESET}  Bar              [${C_SCORE}%s${C_MUTED}%s${RESET}]%*s${C_BORDER}║${RESET}\n" \
        "${bar:0:$(( score * 30 / 60 ))}" \
        "${bar:$(( score * 30 / 60 ))}" \
        4 ""
    printf "${C_BORDER}║${RESET}  Rank             ${rank_color}${BOLD}%s${RESET}%*s${C_BORDER}║${RESET}\n" \
        "$rank" $(( 62 - 2 - 18 - 1 - ${#rank} - 2 )) ""

    box_sep 62
    printf "${C_BORDER}║${RESET}  Win Streak       ${C_STREAK}${BOLD}%-4s${RESET}  Best: ${C_STREAK}${BOLD}%s${RESET}%*s${C_BORDER}║${RESET}\n" \
        "$streak" "$best" $(( 62 - 2 - 18 - 4 - 8 - ${#best} - 2 )) ""
    printf "${C_BORDER}║${RESET}  Attempts         ${C_MUTED}%s${RESET} total%*s${C_BORDER}║${RESET}\n" \
        "$ta" $(( 62 - 2 - 18 - ${#ta} - 6 - 2 )) ""
    printf "${C_BORDER}║${RESET}  Passes           ${C_PASS}%-4s${RESET} (${C_PASS}%s%%${RESET} win rate)%*s${C_BORDER}║${RESET}\n" \
        "$tp" "$wr" $(( 62 - 2 - 18 - 4 - 2 - ${#wr} - 1 - 10 - 2 )) ""
    printf "${C_BORDER}║${RESET}  Failures         ${C_FAIL}%-4s${RESET}%*s${C_BORDER}║${RESET}\n" \
        "$tf" $(( 62 - 2 - 18 - 4 - 2 )) ""

    box_sep 62
    if [ "$passed_count" -gt 0 ]; then
        local passed_list
        passed_list=$(sort -n "$DATA_DIR/passed" | tr '\n' ' ')
        box_line "  ${C_PASS}Cleared:${RESET} ${passed_list}" 62
    else
        box_line "  ${C_MUTED}No levels cleared yet.${RESET}" 62
    fi
    box_bottom 62
    echo ""
    press_enter
}

# ── Per-level stats table ──────────────────────────────────────────────────
show_stats() {
    local current
    current=$(get_level)
    echo ""
    box_top 66
    box_line "  ${BOLD}${BCYAN}◆  PER-LEVEL STATS  ◆${RESET}" 66
    box_sep 66
    printf "${C_BORDER}║${RESET}  ${BOLD}%-4s  %-22s  %-14s  %4s  %4s  %-8s${RESET}  ${C_BORDER}║${RESET}\n" \
        "Lvl" "File" "Topic" "Pass" "Fail" "Status"
    box_sep 66
    local total_p=0 total_f=0
    for (( i=0; i<=$(( current > MAX_LEVEL ? MAX_LEVEL : current )); i++ )); do
        local fname
        fname=$(get_filename "$i")
        local p f
        p=$(get_passes_for "$i")
        f=$(get_fails_for  "$i")
        total_p=$(( total_p + p ))
        total_f=$(( total_f + f ))
        local status color
        if already_passed "$i"; then
            if [ "$f" -eq 0 ]; then status="✓ clean";   color="$C_PASS"
            else                    status="✓ +${f}retry"; color="$BYELLOW"
            fi
        elif [ "$i" -eq "$current" ]; then status="► active"; color="$BCYAN"
        elif [ "$p" -eq 0 ] && [ "$f" -eq 0 ]; then status="─ untried"; color="$GRAY"
        else status="✗ stuck"; color="$C_FAIL"
        fi
        local short="${fname:0:22}"
        local topic
        topic=$(get_topic "$i")
        printf "${C_BORDER}║${RESET}  ${color}%-4s  %-22s  %-14s  %4s  %4s  %-8s${RESET}  ${C_BORDER}║${RESET}\n" \
            "$i" "$short" "$topic" "$p" "$f" "$status"
    done
    box_sep 66
    printf "${C_BORDER}║${RESET}  ${BOLD}%-41s  ${C_PASS}%4s${RESET}  ${C_FAIL}%4s${RESET}%*s${C_BORDER}║${RESET}\n" \
        "TOTAL (0–${current})" "$total_p" "$total_f" 12 ""
    box_bottom 66
    echo ""
    press_enter
}

# ── History ────────────────────────────────────────────────────────────────
show_history() {
    local level="$1"
    echo ""
    tbox_top 50
    tbox_line "  ${BOLD}Attempt history — Level $level${RESET}" 50
    tbox_sep 50
    local found=0
    while IFS=: read -r lvl result time; do
        if [ "$lvl" = "$level" ]; then
            found=1
            if [ "$result" = "PASS" ]; then
                tbox_line "  ${C_PASS}✓ PASS${RESET}  at ${time}" 50
            else
                tbox_line "  ${C_FAIL}✗ FAIL${RESET}  at ${time}" 50
            fi
        fi
    done < "$DATA_DIR/attempts" 2>/dev/null || true
    [ "$found" -eq 0 ] && tbox_line "  ${C_MUTED}No attempts yet.${RESET}" 50
    tbox_bottom 50
    echo ""
    press_enter
}

# ── Help ───────────────────────────────────────────────────────────────────
show_help() {
    echo ""
    box_top 64
    box_line "  ${BOLD}${BCYAN}◆  COMMANDS  ◆${RESET}" 64
    box_sep 64
    box_line "  ${C_PASS}grademe${RESET}         compile & grade your solution" 64
    box_line "  ${BCYAN}hint${RESET}            re-read the current level subject" 64
    box_line "  ${C_CMD}open${RESET}            open your .c file in \$EDITOR" 64
    box_line "  ${C_CMD}cat${RESET}             print your .c file to screen" 64
    box_line "  ${C_CMD}diff${RESET}            show last output diff" 64
    box_sep 64
    box_line "  ${BCYAN}score${RESET}           full scoreboard" 64
    box_line "  ${BCYAN}stats${RESET}           per-level pass/fail breakdown" 64
    box_line "  ${BCYAN}history${RESET}         attempt log for current level" 64
    box_sep 64
    box_line "  ${BMAGENTA}save [name]${RESET}     save progress to named slot" 64
    box_line "  ${BMAGENTA}load [name]${RESET}     restore a named save slot" 64
    box_line "  ${BMAGENTA}saves${RESET}           list all save slots" 64
    box_line "  ${BMAGENTA}deletesave N${RESET}    delete a save slot" 64
    box_sep 64
    box_line "  ${BYELLOW}skip${RESET}            skip level (no credit)" 64
    box_line "  ${BYELLOW}goto N${RESET}          jump to level N (0-59)" 64
    box_line "  ${BRED}reset${RESET}           reset level counter (score kept)" 64
    box_line "  ${BRED}resetscore${RESET}      full reset — all progress erased" 64
    box_line "  ${C_MUTED}exit / q${RESET}        quit (progress auto-saved)" 64
    box_bottom 64
    echo ""
    press_enter
}

# ── Completion screen ──────────────────────────────────────────────────────
show_completion() {
    local score
    score=$(get_score)
    clear
    echo ""
    echo -e "${BOLD}${BGREEN}"
    cat << 'EOF'
  ╔══════════════════════════════════════════════════════════════╗
  ║                                                              ║
  ║          E X A M   C O M P L E T E                          ║
  ║          C   M A S T E R Y   A C H I E V E D                ║
  ║                                                              ║
  ╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
    printf "  ${BOLD}Final Score: ${C_SCORE}%s${RESET}${BOLD} / 60${RESET}\n\n" "$score"
    printf "  ${C_MUTED}Topics mastered:${RESET}\n"
    printf "  Intro · Syntax · Output · Comments · Variables\n"
    printf "  Data Types · Type Conv · Constants · Operators\n"
    printf "  Booleans · If/Else · Switch · While · For\n"
    printf "  Break/Continue · Arrays · Strings · User Input\n"
    printf "  Memory Addresses · Pointers\n\n"
    printf "  ${BYELLOW}You are ready. Ship it.${RESET}\n\n"
}
