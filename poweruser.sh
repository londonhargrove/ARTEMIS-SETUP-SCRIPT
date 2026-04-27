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

echo -e "${YELLOW}Module: Power User Super Installer${NC}"
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
echo -e "${CYAN}This module will install the following tools:${NC}"
echo -e "${BLUE} • Flatpak + Flathub"
echo -e " • Discord (Flatpak)"
echo -e " • Heroic Games Launcher (Flatpak)"
echo -e " • Steam, Lutris, OBS Studio"
echo -e " • VSCodium, Git, GitHub CLI"
echo -e " • Python3 + pip, Node.js + npm"
echo -e " • Java (OpenJDK)"
echo -e " • C/C++ build tools (gcc, g++, make, cmake)"
echo -e " • VirtualBox"
echo -e " • Blender, GIMP, LibreOffice"
echo -e " • GParted, Neofetch, qBittorrent"
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
#   2. INSTALL FLATPAK + FLATHUB
# ============================
echo -e "${YELLOW}Step 2: Checking Flatpak...${NC}"

if ! command -v flatpak >/dev/null 2>&1; then
    echo -e "${CYAN}Installing Flatpak...${NC}"
    case $PM in
        apt) sudo apt install -y flatpak ;;
        dnf) sudo dnf install -y flatpak ;;
        yum) sudo yum install -y flatpak ;;
        pacman) sudo pacman -Sy --noconfirm flatpak ;;
        zypper) sudo zypper install -y flatpak ;;
    esac
else
    echo -e "${GREEN}Flatpak already installed.${NC}"
fi

if ! flatpak remote-list | grep -q flathub; then
    echo -e "${CYAN}Adding Flathub...${NC}"
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    echo -e "${GREEN}Flathub already configured.${NC}"
fi

echo ""

# ============================
#   3. INSTALL FLATPAK APPS
# ============================
echo -e "${YELLOW}Step 3: Installing Flatpak apps...${NC}"

if ! flatpak list | grep -qi com.discordapp.Discord; then
    flatpak install -y flathub com.discordapp.Discord
else
    echo -e "${GREEN}Discord already installed.${NC}"
fi

if ! flatpak list | grep -qi com.heroicgameslauncher.hgl; then
    flatpak install -y flathub com.heroicgameslauncher.hgl
else
    echo -e "${GREEN}Heroic already installed.${NC}"
fi

echo ""

# ============================
#   4. INSTALL NATIVE PACKAGES
# ============================
echo -e "${YELLOW}Step 4: Installing native applications...${NC}"

install_native steam steam
install_native lutris lutris
install_native obs-studio obs
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
install_native virtualbox virtualbox
install_native blender blender
install_native gimp gimp
install_native libreoffice libreoffice
install_native gparted gparted
install_native neofetch neofetch
install_native qbittorrent qbittorrent

echo ""
echo -e "${GREEN}All Power User tools installed!${NC}"

# ============================
#   MODULE FOOTER
# ============================
echo ""
echo -e "${GREEN}Power User module complete!${NC}"
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

