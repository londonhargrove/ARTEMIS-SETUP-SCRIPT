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

echo -e "${YELLOW}Module: Professional Workstation Installer${NC}"
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
#   ACTION SUMMARY
# ============================
echo -e "${CYAN}This module will install the following professional tools:${NC}"
echo -e "${BLUE} • VSCodium"
echo -e " • Git + GitHub CLI"
echo -e " • Python 3 + pip"
echo -e " • Node.js + npm"
echo -e " • Java (OpenJDK)"
echo -e " • C/C++ build tools (gcc, g++, make, cmake)"
echo -e " • VirtualBox"
echo -e " • OBS Studio"
echo -e " • Blender"
echo -e " • GIMP"
echo -e " • LibreOffice"
echo -e " • GParted"
echo -e " • Neofetch"
echo -e " • qBittorrent"
echo -e " • SQLite${NC}"
echo ""
echo -e "${CYAN}A system update can be run or skipped.${NC}"
echo ""

# ============================
#   CONFIRMATION PROMPT (Y/S/N)
# ============================
echo -e "${YELLOW}Install this module?${NC}"
echo -e "${GREEN}Y = Yes (run update + install)${NC}"
echo -e "${CYAN}S = Yes, but skip system update${NC}"
echo -e "${RED}N = No (cancel)${NC}"
read -rsn1 choice

if [[ "$choice" =~ [Nn] ]]; then
    echo -e "${RED}Operation cancelled.${NC}"
    sleep 1
    bash setup.sh
    exit 0
fi

SKIP_UPDATE=false
if [[ "$choice" =~ [Ss] ]]; then
    SKIP_UPDATE=true
fi

echo ""

# ============================
#   DETECT PACKAGE MANAGER
# ============================
if command -v apt >/dev/null 2>&1; then
    PM="apt"
elif command -v dnf >/dev/null 2>&1; then
    PM="dnf"
elif command -v yum >/dev/null 2>&1; then
    PM="yum"
elif command -v pacman >/dev/null 2>&1; then
    PM="pacman"
elif command -v zypper >/dev/null 2>&1; then
    PM="zypper"
else
    echo -e "${RED}Unsupported distro — no known package manager found.${NC}"
    exit 1
fi

echo -e "${CYAN}Detected package manager: ${GREEN}$PM${NC}"
sleep 1
echo ""

# ============================
#   1. SYSTEM UPDATE
# ============================
if [[ "$SKIP_UPDATE" == false ]]; then
    echo -e "${YELLOW}Step 1: Updating system...${NC}"
    case $PM in
        apt) sudo apt update && sudo apt upgrade -y ;;
        dnf) sudo dnf upgrade -y ;;
        yum) sudo yum update -y ;;
        pacman) sudo pacman -Syu --noconfirm ;;
        zypper) sudo zypper refresh && sudo zypper update -y ;;
    esac
    echo -e "${GREEN}System update complete.${NC}"
else
    echo -e "${YELLOW}Skipping system update as requested.${NC}"
fi

echo ""

# ============================
#   INSTALL HELPER FUNCTION
# ============================
install_native() {
    PKG="$1"
    CMD="$2"

    if ! command -v "$CMD" >/dev/null 2>&1; then
        echo -e "${CYAN}Installing $PKG...${NC}"
        case $PM in
            apt) sudo apt install -y "$PKG" ;;
            dnf) sudo dnf install -y "$PKG" ;;
            yum) sudo yum install -y "$PKG" ;;
            pacman) sudo pacman -Sy --noconfirm "$PKG" ;;
            zypper) sudo zypper install -y "$PKG" ;;
        esac
    else
        echo -e "${GREEN}$PKG already installed.${NC}"
    fi
}

# ============================
#   2. INSTALL DEVELOPMENT TOOLS
# ============================
echo -e "${YELLOW}Step 2: Installing development tools...${NC}"

install_native codium codium
install_native git git
install_native gh gh
install_native python3 python3
install_native pip pip
install_native node node
install_native npm npm
install_native javac javac
install_native gcc gcc
install_native g++ g++
install_native make make
install_native cmake cmake
install_native sqlite3 sqlite3

echo ""
echo -e "${GREEN}Development tools installed.${NC}"
echo ""

# ============================
#   3. INSTALL VIRTUALIZATION
# ============================
echo -e "${YELLOW}Step 3: Installing VirtualBox...${NC}"
install_native virtualbox virtualbox

echo ""
echo -e "${GREEN}Virtualization tools installed.${NC}"
echo ""

# ============================
#   4. INSTALL PROFESSIONAL APPS
# ============================
echo -e "${YELLOW}Step 4: Installing professional applications...${NC}"

install_native obs-studio obs
install_native blender blender
install_native gimp gimp
install_native libreoffice libreoffice
install_native gparted gparted
install_native neofetch neofetch
install_native qbittorrent qbittorrent

echo ""
echo -e "${GREEN}Professional applications installed.${NC}"
echo ""

# ============================
#   MODULE FOOTER
# ============================
echo ""
echo -e "${GREEN}Professional workstation setup complete!${NC}"
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

