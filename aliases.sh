#!/bin/bash

# ============================
#   COLORS
# ============================
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear

# ============================
#   ASCII ART BANNER
# ============================
echo -e "${CYAN}"
echo "    █████╗ ████████╗██████╗ ███████╗███╗   ███╗██╗███╗   ███╗███████╗"
echo "   ██╔══██╗╚══██╔══╝██╔══██╗██╔════╝████╗ ████║██║████╗ ████║██╔════╝"
echo "   ███████║   ██║   ██████╔╝█████╗  ██╔████╔██║██║██╔████╔██║███████╗"
echo "   ██╔══██║   ██║   ██╔══██╗██╔══╝  ██║╚██╔╝██║██║██║╚██╔╝██║╚════██║"
echo "   ██║  ██║   ██║   ██║  ██║███████╗██║ ╚═╝ ██║██║██║ ╚═╝ ██║███████║"
echo "   ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚═╝╚═╝     ╚═╝╚══════╝"
echo -e "${NC}"

echo "======================================================="
echo "            Artemis Power Scripts v1.5"
echo -e "${BLUE}          https://github.com/londonhargrove${NC}"
echo "======================================================="
echo ""
echo -e "${YELLOW}Module: Windows/DOS Alias Installer${NC}"
echo -e "${GREEN}Press ESC to quit, or B to return to Artemis Setup.${NC}"
echo ""

# ============================
#   INPUT HANDLER
# ============================
read -rsn1 -t 1 key
if [[ $key == $'\e' ]]; then
    echo -e "${RED}Exiting module...${NC}"
    exit 0
elif [[ $key == "b" || $key == "B" ]]; then
    echo -e "${CYAN}Returning to Artemis Setup...${NC}"
    sleep 1
    bash setup.sh
    exit 0
fi

# ============================
#   ALIAS PACK DEFINITION
# ============================
ALIAS_FILE="$HOME/.bash_aliases"
touch "$ALIAS_FILE"

read -r -d '' ALIAS_BLOCK << 'EOF'
# ARTEMIS_ALIAS_PACK_START

# Windows/DOS‑style aliases
alias cls='clear'
alias dir='ls'
alias copy='cp -i'
alias del='rm -i'
alias move='mv -i'
alias md='mkdir'
alias rd='rmdir'

alias ver='uname -a'
alias systeminfo='neofetch'

alias tasklist='ps aux'
alias taskkill='killall'

alias tracert='traceroute'
alias where='which'

# Useful Linux aliases
alias edit='xdg-open'
alias notepad='xdg-open'

# ARTEMIS_ALIAS_PACK_END
EOF

# ============================
#   CHECK EXISTING INSTALL
# ============================
echo -e "${CYAN}Checking existing alias pack...${NC}"

PACK_STATE="missing"

if grep -q "# ARTEMIS_ALIAS_PACK_START" "$ALIAS_FILE"; then
    EXISTING_BLOCK=$(sed -n '/# ARTEMIS_ALIAS_PACK_START/,/# ARTEMIS_ALIAS_PACK_END/p' "$ALIAS_FILE")
    if [[ "$EXISTING_BLOCK" == "$ALIAS_BLOCK" ]]; then
        PACK_STATE="up_to_date"
        echo -e "${GREEN}Alias pack already installed and up to date.${NC}"
    else
        PACK_STATE="outdated"
        echo -e "${YELLOW}Existing alias pack found but differs from current version.${NC}"
    fi
else
    echo -e "${YELLOW}No alias pack found.${NC}"
fi

echo ""

# ============================
#   ACTION SUMMARY
# ============================
echo -e "${CYAN}This module will:${NC}"
echo -e "${BLUE} • Remove any existing Artemis alias pack"
echo -e " • Install the Artemis Windows/DOS-style alias pack"
echo -e " • Reload your Bash configuration${NC}"
echo ""

# ============================
#   CONFIRMATION PROMPT (WITH REINSTALL OPTION)
# ============================
if [[ "$PACK_STATE" == "up_to_date" ]]; then
    echo -e "${YELLOW}Alias pack is already installed. Reinstall anyway? (Y/N)${NC}"
else
    echo -e "${YELLOW}Do you want to install or update the alias pack? (Y/N)${NC}"
fi

read -rsn1 confirm

if [[ "$confirm" =~ [Nn] ]]; then
    echo -e "${RED}Operation cancelled.${NC}"
    sleep 1
    bash setup.sh
    exit 0
fi

echo ""

# ============================
#   INSTALL / UPDATE ALIAS PACK
# ============================
echo -e "${CYAN}Removing old alias pack (if present)...${NC}"
sed -i '/# ARTEMIS_ALIAS_PACK_START/,/# ARTEMIS_ALIAS_PACK_END/d' "$ALIAS_FILE"

echo -e "${CYAN}Installing new alias pack...${NC}"
echo "$ALIAS_BLOCK" >> "$ALIAS_FILE"

echo -e "${GREEN}Alias pack installed successfully.${NC}"
echo ""

# ============================
#   RELOAD BASH CONFIG
# ============================
echo -e "${CYAN}Reloading Bash configuration...${NC}"
if [ -n "$BASH_VERSION" ]; then
    # shellcheck source=/dev/null
    source "$HOME/.bashrc"
fi
echo -e "${GREEN}Done.${NC}"

# ============================
#   MODULE FOOTER
# ============================
echo ""
echo -e "${GREEN}Alias module complete!${NC}"
echo -e "${YELLOW}Press B to return to Artemis Setup, or ESC to quit.${NC}"

while true; do
    read -rsn1 key
    if [[ $key == $'\e' ]]; then
        echo -e "${RED}Exiting Artemis...${NC}"
        exit 0
    elif [[ $key == "b" || $key == "B" ]]; then
        echo -e "${CYAN}Returning to Artemis Setup...${NC}"
        sleep 1
        bash setup.sh
        exit 0
    fi
done

