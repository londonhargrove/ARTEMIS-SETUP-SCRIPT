#!/bin/bash

# Detect package manager
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
    echo "Unsupported distro — no known package manager found."
    exit 1
fi

echo "Using package manager: $PM"

# -----------------------------
# 1. SYSTEM UPDATE
# -----------------------------
echo "Updating system..."

case $PM in
    apt)
        sudo apt update && sudo apt upgrade -y
        ;;
    dnf)
        sudo dnf upgrade -y
        ;;
    yum)
        sudo yum update -y
        ;;
    pacman)
        sudo pacman -Syu --noconfirm
        ;;
    zypper)
        sudo zypper refresh && sudo zypper update -y
        ;;
esac

# -----------------------------
# 2. INSTALL FLATPAK
# -----------------------------
if ! command -v flatpak >/dev/null 2>&1; then
    echo "Installing Flatpak..."

    case $PM in
        apt)
            sudo apt install -y flatpak
            ;;
        dnf)
            sudo dnf install -y flatpak
            ;;
        yum)
            sudo yum install -y flatpak
            ;;
        pacman)
            sudo pacman -Sy --noconfirm flatpak
            ;;
        zypper)
            sudo zypper install -y flatpak
            ;;
    esac
else
    echo "Flatpak already installed."
fi

# Add Flathub if missing
if ! flatpak remote-list | grep -q flathub; then
    echo "Adding Flathub..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# -----------------------------
# 3. INSTALL DISCORD (Flatpak)
# -----------------------------
if ! flatpak list | grep -qi discord; then
    echo "Installing Discord (Flatpak)..."
    flatpak install -y flathub com.discordapp.Discord
else
    echo "Discord already installed."
fi

# -----------------------------
# 4. INSTALL NATIVE PACKAGES
# -----------------------------
install_native() {
    PKG="$1"
    CMD="$2"

    if ! command -v "$CMD" >/dev/null 2>&1; then
        echo "Installing $PKG..."

        case $PM in
            apt)
                sudo apt install -y "$PKG"
                ;;
            dnf)
                sudo dnf install -y "$PKG"
                ;;
            yum)
                sudo yum install -y "$PKG"
                ;;
            pacman)
                sudo pacman -Sy --noconfirm "$PKG"
                ;;
            zypper)
                sudo zypper install -y "$PKG"
                ;;
        esac
    else
        echo "$PKG already installed."
    fi
}

# Install apps
install_native steam steam
install_native lutris lutris
install_native qbittorrent qbittorrent
install_native gparted gparted
install_native neofetch neofetch

echo "All tasks complete!"

