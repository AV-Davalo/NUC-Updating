#!/bin/bash

# Script : NUC Installation Script
# Author: David "Davalo" Ramirez @ Avertium
# Date 11/22/2024

# Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m' 

# Banner (InstallMonium)
print_banner(){
    echo -e "${GREEN}${BOLD}"
    echo "  ██  ███▄    █   ██████ ▄▄▄█████▓ ▄▄▄       ██▓     ██▓     ███▄ ▄███▓ ▒█████   ███▄    █   ██▓ █    ██  ███▄ ▄███▓"
    echo "▒▓██  ██ ▀█   █ ▒██    ▒ ▓  ██▒ ▓▒▒████▄    ▓██▒    ▓██▒    ▓██▒▀█▀ ██▒▒██▒  ██▒ ██ ▀█   █ ▒▓██▒ ██  ▓██▒▓██▒▀█▀ ██▒"
    echo "░▒██▓ ██  ▀█ ██▒░ ▓██▄   ▒ ▓██░ ▒░▒██  ▀█▄  ▒██░    ▒██░    ▓██    ▓██░▒██░  ██▒▓██  ▀█ ██▒▒▒██▒▓██  ▒██░▓██    ▓██░"
    echo " ░██▓ ██▒  ▐▌██▒  ▒   ██▒░ ▓██▓ ░ ░██▄▄▄▄██ ▒██░    ▒██░    ▒██    ▒██ ▒██   ██░▓██▒  ▐▌██▒░░██░▓▓█  ░██░▒██    ▒██ "
    echo " ░██▒ ██░   ▓██░▒██████▒▒  ▒██▒ ░ ▒▓█   ▓██▒░██████▒░██████▒▒██▒   ░██▒░ ████▓▒░▒██░   ▓██░░░██░▒▒█████▓ ▒██▒   ░██▒"
    echo " ░▓ ░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░  ▒ ░░   ░▒▒   ▓▒█░░ ▒░▓  ░░ ▒░▓  ░░ ▒░   ░  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒  ░▓  ░▒▓▒ ▒ ▒ ░ ▒░   ░  ░"
    echo "  ▒ ░ ░░   ░ ▒░░ ░▒  ░ ░    ░    ░ ░   ▒▒ ░░ ░ ▒  ░░ ░ ▒  ░░  ░      ░  ░ ▒ ▒░ ░ ░░   ░ ▒░░ ▒ ░░░▒░ ░ ░ ░  ░      ░"
    echo "  ▒    ░   ░ ░ ░  ░  ░    ░        ░   ▒     ░ ░     ░ ░   ░      ░   ░ ░ ░ ▒     ░   ░ ░ ░ ▒ ░ ░░░ ░ ░ ░      ░   "
    echo "  ░          ░       ░                 ░  ░    ░  ░    ░  ░       ░       ░ ░           ░   ░     ░            ░  "
    echo -e "${NC}"
}

print_banner

# Constant for Releaseas only (this can be updated to add any realeases package)
GOWITNESS_URL="https://github.com/sensepost/gowitness/releases/download/2.5.1/gowitness-2.5.1-linux-amd64"
LDAPNOMNOM_URL="https://github.com/lkarlslund/ldapnomnom/releases/download/v1.3.0/ldapnomnom-linux-x64"
KERBRUTE_URL="https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64"

declare -A tools
tools=(
    ["Gowitness"]="wget $GOWITNESS_URL -O gowitness && sudo mv gowitness /usr/local/bin/gowitness && sudo chmod +x /usr/local/bin/gowitness"
    ["Netexec"]="sudo apt install -y netexec"
    ["Golang"]="sudo apt install -y golang && export PATH=\$PATH:/usr/local/go/bin && source ~/.bashrc"
    ["Mitm6"]="pip install mitm6"
    ["Seclists"]="sudo apt install -y seclists"
    ["Ldapnomnom"]="wget $LDAPNOMNOM_URL -O ldapnomnom && sudo mv ldapnomnom /usr/local/bin/ && sudo chmod +x /usr/local/bin/ldapnomnom"
    ["Kerbrute"]="wget $KERBRUTE_URL -O kerbrute && sudo mv kerbrute /usr/local/bin/ && sudo chmod +x /usr/local/bin/kerbrute"
    ["Credmaster"]="git clone https://github.com/knavesec/CredMaster /usr/share/CredMaster && pip3 install -r /usr/share/CredMaster/requirements.txt"
    ["Bloodhound"]="pip install bloodhound"
    ["Nessus"]="curl -L 'https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.8.1-ubuntu1604_amd64.deb' -o Nessus.deb && sudo dpkg -i Nessus.deb && sudo systemctl start nessusd && sudo systemctl enable nessusd"
)

declare -A statuses

# Function to display the installation checklist at the end 
display_checklist() {
    clear
    echo -e "${GREEN}${BOLD}Installation Checklist:${NC}"
    printf "%-15s %-10s\n" "Tool" "Status"
    for tool in "${!tools[@]}"; do
        if [[ ${statuses[$tool]} == true ]]; then
            printf "%-15s ${GREEN}[✔] Installed${NC}\n" "$tool"
        else
            printf "%-15s ${RED}[✘] Not Installed${NC}\n" "$tool"
        fi
    done
}

# Function to install all tools in iteration 
install_tool() {
    local tool_name=$1
    local install_command=$2

    echo -e "${YELLOW}Installing $tool_name...${NC}"
    if eval "$install_command"; then
        statuses[$tool_name]=true
        echo -e "${GREEN}$tool_name installed successfully.${NC}"
    else
        statuses[$tool_name]=false
        echo -e "${RED}Failed to install $tool_name.${NC}"
    fi
}

# Function to check if a tool is installed
is_installed() {
    local tool_name=$1
    case $tool_name in
        "Gowitness") command -v gowitness &> /dev/null ;;
        "Netexec") dpkg -l | grep -qw netexec ;;
        "Golang") dpkg -l | grep -qw golang ;;
        "Mitm6") pip show mitm6 &> /dev/null ;;
        "Seclists") dpkg -l | grep -qw seclists ;;
        "Ldapnomnom") command -v ldapnomnom &> /dev/null ;;
        "Kerbrute") command -v kerbrute &> /dev/null ;;
        "Credmaster") [[ -d "/usr/share/CredMaster" ]] ;;
        "Bloodhound") pip show bloodhound &> /dev/null ;;
        "Nessus") systemctl is-active --quiet nessusd ;;
    esac
}

# Update && upgrade -y 
echo -e "${YELLOW}Updating and upgrading the system...${NC}"
sudo apt update && sudo apt DEBIAN_FRONTEND=noninteractive upgrade -y

#Iteration for installation
for tool in "${!tools[@]}"; do
    if is_installed "$tool"; then
        statuses[$tool]=true
        echo -e "${GREEN}$tool is already installed. Skipping...${NC}"
    else
        install_tool "$tool" "${tools[$tool]}"
    fi
done

# Clean the installs and autoremove
trap 'echo -e "${YELLOW}Cleaning up...${NC}"; sudo apt autoremove -y; sudo apt clean' EXIT

# end
display_checklist
echo -e "${GREEN}Installation process completed.${NC}"
