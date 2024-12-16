#!/bin/bash

# Color codes and icons
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

ICON_TELEGRAM="🚀"
ICON_INSTALL="🛠️"
ICON_STOP="⏹️"
ICON_RES="🫡"
ICON_EXIT="🚪"
ICON_DEL="❌"

# Function to display ASCII logo and social links
display_ascii() {
echo -e " ${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${RESET}"
echo -e " ${MAGENTA}~ ${RED}_   _  ___  ____  _____ ________ _     _        _    ${MAGENTA}~"
echo -e " ${MAGENTA}~${GREEN}| \\ | |/ _ \\|  _ \\| ____|__  /_ _| |   | |      / \\   ${MAGENTA}~"
echo -e " ${MAGENTA}~${YELLOW}|  \\| | | | | | | |  _|   / / | || |   | |     / _ \\  ${MAGENTA}~"
echo -e " ${MAGENTA}~${CYAN}| |\\  | |_| | |_| | |___ / /_ | || |___| |___ / ___ \\ ${MAGENTA}~"
echo -e " ${MAGENTA}~${BLUE}|_| \\_|\\___/|____/|_____/____|___|_____|_____/_/   \\_\\ ${MAGENTA}~"
echo -e " ${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${RESET}"
echo -e " ${MAGENTA}🚀 Join Nodzillaz on Telegram: https://t.me/nodezilla101 ${RESET}"
echo -e " ${MAGENTA}📢 Join Nodzillaz on Discord: https://discord.gg/RAEnTZSEVh ${RESET}"
}

# Check and install Docker and Docker Compose
install_docker() {
    echo -e "${GREEN}${ICON_INSTALL} Installing Docker and Docker Compose...${RESET}"
    sudo apt update && sudo apt upgrade -y
    if ! command -v docker &> /dev/null; then
        sudo apt install docker.io -y
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
    if ! command -v docker-compose &> /dev/null; then
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    echo -e "${GREEN}Docker and Docker Compose are installed.${RESET}"
    read -p "Press enter to continue..."
}

# Main installation and setup process
install_browser() {
    echo -e "${YELLOW}Configure environment variables for the browser:${RESET}"
    read -p "Enter USERNAME: " USERNAME
    read -p "Enter PASSWORD: " PASSWORD
    read -p "Specify HOME directory (default is current): " HOME_DIR
    HOME_DIR=${HOME_DIR:-$(pwd)}
    read -p "Enter PORT (default is 10000): " PORT
    PORT=${PORT:-10000}

    echo -e "${GREEN}Starting Docker container for the browser...${RESET}"
    docker run -d --name=Nodezilla101_browser \
        -p ${PORT}:3000 \
        -e TITLE=Nodezilla101 \
        -e DISPLAY=:1 \
        -e PUID=1000 \
        -e PGID=1000 \
        -e CUSTOM_USER=${USERNAME} \
        -e PASSWORD=${PASSWORD} \
        -e LANGUAGE=en_US.UTF-8 \
        -v ${HOME_DIR}/chromium/config:/config \
        --shm-size=4gb \
        --restart unless-stopped \
        lscr.io/linuxserver/chromium:latest
    echo -e "${GREEN}✅ Browser successfully installed and running on port ${PORT}.${RESET}"
    read -p "Press enter to continue..."
}

# Restart the Docker container
restart_browser(){
    echo -e "${YELLOW}Restarting browser...${RESET}"
    docker restart Nodezilla101_browser
    echo -e "${GREEN}✅ Browser restarted.${RESET}"
    read -p "Press enter to continue..."
}

# Stop the Docker container
stop_browser() {
    echo -e "${YELLOW}Stopping the browser...${RESET}"
    docker stop Nodezilla101_browser && docker rm Nodezilla101_browser
    echo -e "${GREEN}✅ Browser stopped and container removed.${RESET}"
    read -p "Press enter to continue..."
}

# Delete the Docker container completely
delete_browser() {
    echo -e "${YELLOW}Deleting the browser Docker container...${RESET}"
    docker stop Nodezilla101_browser && docker rm -v Nodezilla101_browser
    echo -e "${GREEN}✅ Browser Docker container and associated volumes deleted.${RESET}"
    read -p "Press enter to continue..."
}

# Main menu
while true; do
    clear
    display_ascii
    echo -e "${CYAN}1.${RESET} ${ICON_INSTALL} Install browser"
    echo -e "${CYAN}2.${RESET} ${ICON_STOP} Stop browser"
    echo -e "${CYAN}3.${RESET} ${ICON_RES} Restart browser"
    echo -e "${CYAN}4.${RESET} ${ICON_EXIT} Exit"
    echo -e "${CYAN}5.${RESET} ${ICON_DEL} Delete browser (completely)"
    echo -ne "${YELLOW}Choose an option [1-5]:${RESET} "
    read choice

    case $choice in
        1)
            install_docker
            install_browser
            ;;
        2)
            stop_browser
            ;;
        3)
            restart_browser
            ;;
        4)
            echo -e "${RED}Exiting...${RESET}"
            exit 0
            ;;
        5)
            delete_browser
            ;;
        *)
            echo -e "${RED}Invalid input. Please try again.${RESET}"
            read -p "Press enter to continue..."
            ;;
    esac
done
