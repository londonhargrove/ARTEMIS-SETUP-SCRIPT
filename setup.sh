#!/bin/bash

clear

BLUE='\033[0;34m'
NC='\033[0m'

echo "======================================================="
echo "            Artemis Setup Script v1.1.0"
echo -e "${BLUE}          https://github.com/londonhargrove${NC}"
echo "======================================================="
echo ""
echo "Welcome to the Artemis Setup Wizard."
echo ""
echo "This tool provides modular setup utilities to enhance your Linux system."
echo "Choose a module below to continue."
echo ""

# Build an array of scripts
scripts=()
for script in *.sh; do
    if [ "$script" != "$(basename "$0")" ]; then
        scripts+=("$script")
    fi
done

# Optional: descriptions for known scripts
declare -A descriptions
descriptions["aliases.sh"]="Adds Windows/DOS-style terminal aliases"
descriptions["poweruser.sh"]="Installs both professional and gaming applications"
descriptions["professional.sh"]="Installs only professional productivity tools"
descriptions["gaming.sh"]="Installs only gaming-related tools"

# Display numbered list with descriptions
for i in "${!scripts[@]}"; do
    script="${scripts[$i]}"
    desc="${descriptions[$script]}"
    if [ -z "$desc" ]; then
        desc="No description available"
    fi
    printf "%d) %-25s - %s\n" $((i+1)) "$script" "$desc"
done

echo ""
read -p "Enter the number of the script you want to run: " choice

# Validate input
if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a number."
    exit 1
fi

index=$((choice-1))

if [ "$index" -ge 0 ] && [ "$index" -lt "${#scripts[@]}" ]; then
    selected="${scripts[$index]}"
    echo ""
    echo "Launching: $selected"
    echo "-------------------------------------------------------"
    sleep 1
    bash "$selected"
else
    echo "Invalid selection."
    exit 1
fi

