#!/bin/bash

#Script : Installmonium 
#Author: David "Davalo" Ramirez 
# Date 8/12/2024 


#Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

#Variables to check installed Packages
UPDATE_COMPLETED=false
UPGRADE_COMPLETED=false
NETEXEC_Installed=false
Golang_Installed=false
Ldapnomnom_Installed=false
mitm6_Installed=false
seclists_Installed=false

#Function of checking
is_installed() {
        dpkg -l | grep -qw "$1"
}

# Function to display the checklist
display_checklist() {
    clear
    # Update and Upgrade status 
    echo -e "${GREEN}Update and Upgrade status:... ${NC}"
    if $UPDATE_COMPLETED; then
        echo -e "${GREEN}[✔] ${BOLD}System update${NC}${GREEN} completed.${NC}"
    else
        echo -e "${RED}[✘] ${BOLD}System update{NC}${RED} pending...${NC}"
    fi

    if $UPGRADE_COMPLETED; then
        echo -e "${GREEN}[✔] ${BOLD}System upgrade${NC}${GREEN} completed.${NC}"
    else
        echo -e "${RED}[✘]  ${BOLD}System upgrade${NC}${RED} pending...${NC}"
    fi
    # Installers status 
    echo -e "${GREEN}Installation Checklist:${NC}"

        if $NETEXEC_Installed; then
        echo -e "${GREEN}[✔]  ${BOLD}${CYAN}netexec${NC}${GREEN} installed successfully.${NC}"
    else
        echo -e "${RED}[✘]  ${BOLD}${YELLOW}netexec${NC}${RED} installation pending...${NC}"
    fi

        if $Golang_Installed; then
        echo -e "${GREEN}[✔]  ${BOLD}${MAGENTA}Golang${NC}${GREEN} installed successfully.${NC}"
    else
        echo -e "${RED}[✘]  ${BOLD}${RED}Golang${NC}${RED} installation pending...${NC}"
    fi
        if $mitm6_Installed; then
        echo -e "${GREEN}[✔]  ${BOLD}${BLUE}mitm6${NC}${GREEN} installed successfully.${NC}"
    else
        echo -e "${RED}[✘]  ${BOLD}${YELLOW}mitm6${NC}${RED} installation pending...${NC}"
    fi
        if $seclists_Installed; then
        echo -e "${GREEN}[✔]  ${BOLD}${GREEN}Seclists${NC}${GREEN} installed successfully.${NC}"
    else
        echo -e "${RED}[✘]  ${BOLD}${YELLOW}Seclists${NC}${RED} installation pending...${NC}"
    fi
          if $Ldapnomnom_Installed; then
        echo -e "${GREEN}[✔]  ${BOLD}${WHITE}ldapnomnom${NC}${GREEN} installed successfully.${NC}"
    else
        echo -e "${RED}[✘]  ${BOLD}${YELLOW}ldapnomnom${NC}${RED} installation pending...${NC}"
    fi
}

# Update and upgrade the system
display_checklist
echo -e "${YELLOW}Updating the system...${NC}"
if sudo apt update; then
    UPDATE_COMPLETED=true
fi
display_checklist

echo -e "${YELLOW}Upgrading the system...${NC}"
if sudo apt upgrade -y; then
    UPGRADE_COMPLETED=true
fi
display_checklist
# Install netexec
if is_installed "netexec"; then
    NETEXEC_Installed=true
    display_checklist
    echo -e "${GREEN}netexec is already installed. Skipping...${NC}"
else
    echo -e "${GREEN}Installing netexec...${NC}"
    if sudo apt install -y netexec; then
        NETEXEC_Installed=true
    fi
    display_checklist
fi

# Install Golang
if is_installed "golang"; then
    Golang_Installed=true
    display_checklist
    echo -e "${GREEN}Golang is already installed. Skipping...${NC}"
else
    echo -e "${GREEN}Installing Golang...${NC}"
    if sudo apt install -y golang; then
        # Adding .bashrc
        export PATH=$PATH:/usr/local/go/bin
        # Reload
        source ~/.bashrc
        Golang_Installed=true
    fi
    display_checklist
fi


# Install mitm6

if is_installed "mitm6"; then 
        mitm6_Installed=true
    display_checklist
    echo -e "${GREEN}Mitm6 is already installed. Skipping...${NC}"
else
    echo -e "${GREEN}Installing Mitm6...${NC}"
    if pip install mitm6; then
        mitm6_Installed=true
    fi
    display_checklist
fi

#Install Seclists 

if is_installed "seclists"; then 
        seclists_Installed=true
    display_checklist
    echo -e "${GREEN}Seclists is already installed. Skipping...${NC}"
else
    echo -e "${GREEN}Installing Seclists...${NC}"
    if sudo apt install -y seclists; then
        seclists_Installed=true
    fi
    display_checklist
fi


# Install ldapnomnom
#echo -e "${RED}Installing ldapnomnom... This can take a while${NC}"
# sudo go install github.com/lkarlslund/ldapnomnom@latest

#cd /usr/share
#sudo mkdir ldapnomnom
#cd ldapnomnom
#sudo wget https://github.com/lkarlslund/ldapnomnom/releases/download/v1.3.0/ldapnomnom-linux-x64
#sudo chmod +x ldapnomnom-linux-arm64
#sudo mv ldapnomnom-linux-arm64 /usr/local/bin/

if command -v ldapnomnom-linux-x64 &> /dev/null; then
    Ldapnomnom_Installed=true
    display_checklist
    echo -e "${GREEN}ldapnomnom is already installed. Skipping...${NC}"
else
    echo -e "${GREEN}Installing ldapnomnom...${NC}"
    cd /usr/share && sudo mkdir ldapnomnom && cd ldapnomnom && \
    sudo wget https://github.com/lkarlslund/ldapnomnom/releases/download/v1.3.0/ldapnomnom-linux-x64 && \
    sudo chmod +x ldapnomnom-linux-x64 && \
    sudo mv ldapnomnom-linux-x64 /usr/local/bin/
    
    if command -v ldapnomnom-linux-x64 &> /dev/null; then
        Ldapnomnom_Installed=true
    fi
    display_checklist
fi


# Clean up
echo -e "${GREEN}Cleaning up...${NC}"
sudo apt autoremove -y
sudo apt clean

# Final checklist display
display_checklist
echo -e "${GREEN}All done! :) ${NC}"
