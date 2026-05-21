#!/usr/bin/env bash
# lib/commands.sh — Command dispatcher & main loop

# ── goto ───────────────────────────────────────────────────────────────────
cmd_goto() {
    local target="$1"
    if [[ ! "$target" =~ ^[0-9]+$ ]] || [ "$target" -gt "$MAX_LEVEL" ]; then
        printf "  ${C_FAIL}Invalid level. Use 0–%s${RESET}\n" "$MAX_LEVEL"
        sleep 1
        return
    fi
    set_level "$target"
    printf "  ${C_WARN}Jumped to level %s.${RESET}\n" "$target"
    sleep 0.8
}

# ── open ───────────────────────────────────────────────────────────────────
cmd_open() {
    local level
    level=$(get_level)
    local fname
    fname=$(get_filename "$level")
    local dname
    dname=$(get_dirname "$level")
    local fpath="$RENDU_DIR/$dname/$fname"
    mkdir -p "$RENDU_DIR/$dname"
    if [ ! -f "$fpath" ]; then
        # Pre-populate with a starter template
        cat > "$fpath" << TEMPLATE
/* ************************************************************************** */
/*                                                                            */
/*   ${fname}$(printf '%*s' $(( 68 - ${#fname} )) '')*/
/*                                                                            */
/*   Level: ${level} — $(get_topic "$level") [$(get_subtask "$level")/3]$(printf '%*s' $(( 45 - ${#level} - $(echo "$(get_topic "$level")" | wc -c) )) '')*/
/*                                                                            */
/* ************************************************************************** */

#include <unistd.h>
#include <stdio.h>

int\tmain(void)
{
\t/* your code here */
\treturn (0);
}
TEMPLATE
    fi
    ${EDITOR:-nano} "$fpath"
}

# ── cat ────────────────────────────────────────────────────────────────────
cmd_cat() {
    local level
    level=$(get_level)
    local fname
    fname=$(get_filename "$level")
    local dname
    dname=$(get_dirname "$level")
    local fpath="$RENDU_DIR/$dname/$fname"
    echo ""
    if [ -f "$fpath" ]; then
        tbox_top 70
        tbox_line "  ${C_FILE}${fpath}${RESET}" 70
        tbox_sep 70
        local n=1
        while IFS= read -r line; do
            printf "${C_MUTED}│${RESET}  ${GRAY}%3s${RESET}  %s\n" "$n" "$line"
            (( n++ )) || true
        done < "$fpath"
        tbox_bottom 70
    else
        printf "  ${C_FAIL}File not found:${RESET} %s\n" "$fpath"
        printf "  Use ${C_CMD}open${RESET} to create it.\n"
    fi
    echo ""
    press_enter
}

# ── skip ───────────────────────────────────────────────────────────────────
cmd_skip() {
    local level
    level=$(get_level)
    printf "  ${C_WARN}Skip level %s (no points awarded)? [y/N]:${RESET} " "$level"
    local confirm
    read -r confirm < /dev/tty
    if [[ "${confirm,,}" == "y" ]]; then
        set_level $(( level + 1 ))
        printf "  ${C_MUTED}Skipped.${RESET}\n"
        sleep 0.8
    fi
}

# ── diff (show last) ───────────────────────────────────────────────────────
cmd_diff() {
    if [ -z "$LAST_LEVEL" ]; then
        printf "  ${C_MUTED}No grading run yet. Type ${C_CMD}grademe${RESET}${C_MUTED} first.${RESET}\n\n"
        press_enter
        return
    fi
    echo ""
    printf "  ${BOLD}Last diff — Level %s${RESET}\n" "$LAST_LEVEL"
    show_diff "$LAST_EXPECTED" "$LAST_OUTPUT" "$LAST_LEVEL"
    press_enter
}

# ── prompt ─────────────────────────────────────────────────────────────────
show_prompt_line() {
    local level
    level=$(get_level)
    local score
    score=$(get_score)
    local streak
    streak=$(get_streak)

    echo -e "${C_MUTED}  ────────────────────────────────────────────────────────────${RESET}"
    printf "  ${C_CMD}grademe${RESET}  ${BCYAN}hint${RESET}  ${C_CMD}open${RESET}  ${C_CMD}cat${RESET}  ${C_CMD}diff${RESET}  "
    printf "${BCYAN}score${RESET}  ${BCYAN}stats${RESET}  ${BMAGENTA}save${RESET}  ${BMAGENTA}load${RESET}  ${C_CMD}help${RESET}\n"
    echo -e "${C_MUTED}  ────────────────────────────────────────────────────────────${RESET}"
    printf "  ${BOLD}${C_PROMPT}exam${RESET}[${BYELLOW}lvl%s${RESET}|${C_SCORE}%s/60${RESET}|${C_STREAK}streak:%s${RESET}]${BOLD}> ${RESET}" \
        "$level" "$score" "$streak"
}

# ── Main loop ──────────────────────────────────────────────────────────────
main_loop() {
    show_splash

    while true; do
        local level
        level=$(get_level)
        local fname
        fname=$(get_filename "$level")

        # Check completion
        if [ "$level" -gt "$MAX_LEVEL" ]; then
            show_completion
            exit 0
        fi

        show_header "$level"
        show_subject "$level"
        show_prompt_line

        local input=""
        read -r input < /dev/tty

        case "$input" in

            grademe|grade|g)
                grade_me
                ;;

            score|scoreboard|sb)
                show_scoreboard
                ;;

            stats|st)
                show_stats
                ;;

            saves|savelist|sl)
                list_saves
                ;;

            save)
                do_save "quicksave"
                sleep 1
                ;;

            save\ *)
                do_save "${input#save }"
                sleep 1
                ;;

            load)
                do_load "quicksave"
                ;;

            load\ *)
                do_load "${input#load }"
                ;;

            deletesave\ *)
                delete_save "${input#deletesave }"
                ;;

            hint|subject|h|s)
                # Already shown — just pause
                printf "  ${C_MUTED}(subject already displayed above)${RESET}\n"
                press_enter
                ;;

            open|o|edit|e)
                cmd_open
                ;;

            cat|c)
                cmd_cat
                ;;

            diff|d)
                cmd_diff
                ;;

            history|hist)
                show_history "$level"
                ;;

            skip)
                cmd_skip
                ;;

            goto\ *|go\ *)
                local target
                target="${input#* }"
                cmd_goto "$target"
                ;;

            reset)
                do_reset_level
                ;;

            resetscore|resetall)
                do_reset_all
                ;;

            help|"?"|"")
                show_help
                ;;

            exit|quit|q|bye)
                echo ""
                printf "  ${C_MUTED}Progress saved. Level: %s  Score: %s/60  Streak: %s${RESET}\n" \
                    "$(get_level)" "$(get_score)" "$(get_streak)"
                printf "  ${C_MUTED}Come back and keep going. Goodbye.${RESET}\n\n"
                exit 0
                ;;

            *)
                printf "  ${C_FAIL}Unknown command:${RESET} '%s'  — type ${C_CMD}help${RESET} for the list.\n" "$input"
                sleep 1
                ;;

        esac
    done
}
