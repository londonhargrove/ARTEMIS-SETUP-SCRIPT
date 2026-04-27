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

# ============================
#   VERSION CHECK
# ============================
LOCAL_VERSION=$(cat version.txt 2>/dev/null || echo "0")
REMOTE_VERSION=$(curl -s https://raw.githubusercontent.com/londonhargrove/ARTEMIS-SETUP-SCRIPT/main/version.txt)

if [[ -z "$REMOTE_VERSION" ]]; then
    echo -e "${RED}Warning: Could not check for updates (network issue).${NC}"
else
    if [[ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]]; then
        echo -e "${YELLOW}A new version of Artemis is available!${NC}"
        echo -e "${BLUE}Local version:${NC}  $LOCAL_VERSION"
        echo -e "${BLUE}Remote version:${NC} $REMOTE_VERSION"
        echo ""
        echo -e "${YELLOW}Update all modules now? (Y/N)${NC}"
        read -rsn1 update_choice

        if [[ "$update_choice" =~ [Yy] ]]; then
            echo ""
            echo -e "${CYAN}Updating Artemis to version $REMOTE_VERSION...${NC}"
            FILES=("setup.sh" "aliases.sh" "poweruser.sh" "professional.sh" "gaming.sh" "version.txt")

            for FILE in "${FILES[@]}"; do
                echo -e "${CYAN}Downloading $FILE...${NC}"
                curl -s -o "$FILE" "https://raw.githubusercontent.com/londonhargrove/ARTEMIS-SETUP-SCRIPT/main/$FILE"
                chmod +x "$FILE"
            done

            echo ""
            echo -e "${GREEN}Update complete! Restarting Artemis...${NC}"
            sleep 1
            exec bash setup.sh
            exit 0
        else
            echo -e "${YELLOW}Skipping update.${NC}"
        fi
    fi
fi

# ============================
#   MODULE DESCRIPTIONS
# ============================
declare -A descriptions
descriptions["aliases.sh"]="Adds Windows/DOS-style terminal aliases"
descriptions["poweruser.sh"]="Installs all professional + gaming tools"
descriptions["professional.sh"]="Installs only professional software"
descriptions["gaming.sh"]="Installs only gaming tools"

# ============================
#   FIXED MODULE ORDER
# ============================
scripts=(
    "aliases.sh"
    "poweruser.sh"
    "professional.sh"
    "gaming.sh"
)

echo -e "${YELLOW}Available Modules:${NC}"
echo ""

i=1
for script in "${scripts[@]}"; do
    desc="${descriptions[$script]}"
    printf "${GREEN}%2d${NC}) ${CYAN}%-25s${NC} - %s\n" \
        "$i" "$script" "$desc"
    ((i++))
done

echo ""
printf "${RED} 0${NC}) Exit Artemis Setup\n"
echo ""

# ============================
#   USER INPUT
# ============================
read -p "Enter your choice: " choice

if [[ "$choice" == "0" ]]; then
    echo -e "${RED}Exiting Artemis Setup...${NC}"
    exit 0
fi

if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}Invalid input. Please enter a number.${NC}"
    exit 1
fi

index=$((choice-1))

if [[ "$index" -ge 0 && "$index" -lt "${#scripts[@]}" ]]; then
    selected="${scripts[$index]}"
    echo ""
    echo -e "${GREEN}Launching:${NC} $selected"
    echo "-------------------------------------------------------"
    sleep 1
    bash "$selected"
else
    echo -e "${RED}Invalid selection.${NC}"
    exit 1
fi

