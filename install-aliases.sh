#!/bin/bash

# Location of alias file
ALIAS_FILE="$HOME/.bash_aliases"

# Create file if it doesn't exist
touch "$ALIAS_FILE"

echo "Checking for neofetch..."

# Install neofetch if missing
if ! command -v neofetch >/dev/null 2>&1; then
    echo "Neofetch not found. Installing..."

    if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y neofetch

    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y neofetch

    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y neofetch

    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm neofetch

    elif command -v zypper >/dev/null 2>&1; then
        sudo zypper install -y neofetch

    else
        echo "Unsupported distro — please install neofetch manually."
    fi
else
    echo "Neofetch is already installed."
fi

# Remove old versions of these aliases to avoid duplicates
for a in cls dir copy del move md rd ver systeminfo tasklist taskkill tracert where edit notepad; do
    sed -i "/alias $a=/d" "$ALIAS_FILE"
done

# Append your alias pack
cat << 'EOF' >> "$ALIAS_FILE"

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

EOF

echo "Aliases installed into $ALIAS_FILE"

# Reload shell
if [ -n "$BASH_VERSION" ]; then
    source "$HOME/.bashrc"
    echo "Bash configuration reloaded."
fi

