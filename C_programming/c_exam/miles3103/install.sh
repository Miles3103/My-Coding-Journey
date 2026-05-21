#!/usr/bin/env bash
# install.sh — Miles3103 C Mastery Shell installer

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

INSTALL_DIR="${HOME}/.local/share/miles3103"
BIN_DIR="${HOME}/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "${BOLD}${CYAN}Miles3103 — C Mastery Shell v15.0${RESET}"
echo -e "${CYAN}Installing Professional Edition...${RESET}"
echo ""

# ── Check bash version ─────────────────────────────────────────────────────
if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo -e "${RED}✗ bash 4+ required (you have $BASH_VERSION)${RESET}"
    echo "  On macOS: brew install bash"
    exit 1
fi
echo -e "  ${GREEN}✓${RESET} bash ${BASH_VERSION}"

# ── Check gcc ──────────────────────────────────────────────────────────────
if ! command -v gcc &>/dev/null; then
    echo -e "  ${RED}✗ gcc not found${RESET}"
    echo "  Install with: sudo apt install gcc  (Ubuntu/Debian)"
    echo "             or: sudo dnf install gcc  (Fedora/RHEL)"
    exit 1
fi
echo -e "  ${GREEN}✓${RESET} gcc $(gcc --version | head -1)"

# ── Check editor ───────────────────────────────────────────────────────────
EDITOR_FOUND=""
for ed in "$EDITOR" nano vim vi; do
    [ -z "$ed" ] && continue
    if command -v "$ed" &>/dev/null; then
        EDITOR_FOUND="$ed"
        break
    fi
done
if [ -n "$EDITOR_FOUND" ]; then
    echo -e "  ${GREEN}✓${RESET} editor: $EDITOR_FOUND"
else
    echo -e "  ${YELLOW}⚠${RESET} No editor found — set \$EDITOR or install nano/vim"
fi

# ── Install files ──────────────────────────────────────────────────────────
echo ""
echo -e "  ${CYAN}Installing to ${INSTALL_DIR}${RESET}"
mkdir -p "$INSTALL_DIR" "$BIN_DIR"
cp -r "$SCRIPT_DIR/." "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/miles3103.sh"

# ── Create launcher ────────────────────────────────────────────────────────
cat > "$BIN_DIR/miles3103" << LAUNCHER
#!/usr/bin/env bash
exec "${INSTALL_DIR}/miles3103.sh" "\$@"
LAUNCHER
chmod +x "$BIN_DIR/miles3103"
echo -e "  ${GREEN}✓${RESET} Launcher created: ${BIN_DIR}/miles3103"

# ── PATH check ─────────────────────────────────────────────────────────────
if [[ ":$PATH:" != *":${BIN_DIR}:"* ]]; then
    echo ""
    echo -e "  ${YELLOW}⚠  ${BIN_DIR} is not in your PATH${RESET}"
    echo "  Add this line to your ~/.bashrc or ~/.zshrc:"
    echo ""
    echo -e "  ${BOLD}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
    echo ""
    echo "  Then run: source ~/.bashrc"
else
    echo -e "  ${GREEN}✓${RESET} ${BIN_DIR} is in PATH"
fi

# ── Done ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}  ✓ Installation complete!${RESET}"
echo ""
echo -e "  Start the exam:  ${BOLD}miles3103${RESET}"
echo -e "  Or run directly: ${BOLD}${INSTALL_DIR}/miles3103.sh${RESET}"
echo ""
