#!/bin/bash

#Script : Installnation 
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
PURPLE='\033[0;35m'
ORANGE='\033[0;33m'
LIGHT_MAGENTA='\033[1;35m'
LIGHT_GREEN='\033[1;32m'
LIGHT_YELLOW='\033[1;33m'
LIGHT_RED='\033[1;31m'

#Variables to check installed Packages
UPDATE_COMPLETED=false
UPGRADE_COMPLETED=false
NETEXEC_Installed=false
Golang_Installed=false
Ldapnomnom_Installed=false
mitm6_Installed=false
seclists_Installed=false
Kerbrute_Installed=false
credmaster_Installed=false
nessus_Installed=false 
bloodhound_Installed=false

#Function of checking
is_installed() {
        dpkg -l | grep -qw "$1"
}

# Function to display the checklist
display_checklist() {
    clear
    # Update and Upgrade status 
    echo -e "${GREEN}Update and Upgrade status:...${NC}"
    if $UPDATE_COMPLETED; then
        echo -e "${GREEN}[✔] ${BOLD}System update${NC}${GREEN} completed.${NC}"
    else
        echo -e "${RED}[✘] ${BOLD}System update${NC}${RED} pending...${NC}"
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
        if $Kerbrute_Installed; then
        echo -e "${GREEN}[✔]  ${BOLD}${ORANGE}Kerbrute${NC}${GREEN} installed successfully.${NC}"
    else
        echo -e "${RED}[✘]  ${BOLD}${YELLOW}Kerbrute${NC}${RED} installation pending...${NC}"
    fi
        if $credmaster_Installed; then
        echo -e "${GREEN}[✔]  ${BOLD}${LIGHT_MAGENTA}Credmaster${NC}${GREEN} installed successfully in ${BOLD}${LIGHT_MAGENTA}/usr/share/credmaster.${NC}"
    else
        echo -e "${RED}[✘]  ${BOLD}${YELLOW}Credmaster${NC}${RED} installation pending...${NC}"
    fi
            if $bloodhound_Installed; then
        echo -e "${GREEN}[✔]  ${BOLD}${LIGHT_RED}Bloodhound-Python${NC}${GREEN} installed successfully.${NC}"
    else
        echo -e "${RED}[✘]  ${BOLD}${YELLOW}Bloodhound-Python${NC}${RED} installation pending...${NC}"
    fi
        if $nessus_Installed; then
        echo -e "${GREEN}[✔]  ${BOLD}${PURPLE}Nessus${NC}${GREEN} installed successfully.${NC}"
    else
        echo -e "${RED}[✘]  ${BOLD}${YELLOW}Nessus${NC}${RED} installation pending...${NC}"
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

#Ldapnomnom Installation 

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

# Installing Kerbrute

if command -v kerbrute_linux_amd64 &> /dev/null; then
    Kerbrute_Installed=true
    display_checklist
    echo -e "${GREEN}Kerbrute is already installed. Skipping...${NC}"
else
    echo -e "${GREEN}Installing Kerbrute...${NC}"
    cd /usr/share && sudo mkdir Kerbrute && cd Kerbrute && \
    sudo wget https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 && \
    sudo chmod +x kerbrute_linux_amd64 && \
    sudo mv kerbrute_linux_amd64 /usr/local/bin/
    
    if command -v kerbrute_linux_amd64 &> /dev/null; then
        Kerbrute_Installed=true
    fi
    display_checklist
fi



# Installing Credmaster 

if  [ -d "/usr/share/CredMaster" ]; then
    credmaster_Installed=true
    display_checklist
    echo -e "${GREEN}Credmaster is already installed. Skipping...${NC}"
else
    cd /usr/share && \
    git clone https://github.com/knavesec/CredMaster && \
    cd CredMaster && \
    pip3 install -r requirements.txt && \
    credmaster_Installed=true
    display_checklist
fi

#Bloodhound-Python 

if command -v bloodhound-python &> /dev/null; then
    bloodhound_Installed=true
    display_checklist
    echo -e "${GREEN}Bloodhound is already installed. Skipping...${NC}"
else
    pip install bloodhound
    bloodhound_Installed=true
    display_checklist
fi


# Nessus Installation and Setup 

if systemctl is-active --quiet nessusd; then
    nessus_Installed=true
    display_checklist
    echo -e "${GREEN}Nessus is already installed and running. Skipping...${NC}"
else
    echo -e "${GREEN}Installing Nessus...${NC}"
    cd /tmp && \
    curl --request GET \
  --url 'https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.8.1-ubuntu1604_amd64.deb' \
  --output 'Nessus-10.8.1-ubuntu1604_amd64.deb'
    sudo dpkg -i Nessus-10.8.1-ubuntu1604_amd64.deb && \
    sudo systemctl start nessusd && \
    sudo systemctl enable nessusd
    
    if systemctl is-active --quiet nessusd; then
        nessus_Installed=true
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
