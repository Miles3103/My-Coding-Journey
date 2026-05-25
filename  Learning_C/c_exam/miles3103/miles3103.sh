#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║           MILES3103 — C Low-Level Mastery Shell  v15.0                 ║
# ║           60 Levels · C Intro → Pointers                               ║
# ║           Professional Edition                                          ║
# ╚══════════════════════════════════════════════════════════════════════════╝

set -euo pipefail
IFS=$'\n\t'

# ── Guard: bash 4+ required ───────────────────────────────────────────────
if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "ERROR: bash 4+ required (you have $BASH_VERSION)" >&2
    exit 1
fi

# ── Resolve script directory ──────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ── Source modules ────────────────────────────────────────────────────────
source lib/colors.sh
source lib/data.sh
source lib/state.sh
source lib/ui.sh
source lib/grader.sh
source lib/subjects.sh
source lib/commands.sh

# ── Bootstrap ─────────────────────────────────────────────────────────────
init_dirs
init_state
generate_subjects

# ── Main loop ─────────────────────────────────────────────────────────────
main_loop
