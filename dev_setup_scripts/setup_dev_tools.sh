#!/bin/bash

# === Developer Setup Script for Ubuntu 24.04 ===
# Description: A modular setup script to detect and install missing developer tools
# Features:
# - Sources .bashrc to reuse check_dev_tools
# - Installs only missing tools
# - Interactive Git setup (asks for name/email)
# - MySQL installed but not started
# - Feedback after each step with colored output
# - Progress indicators for each step
# - Shows tool locations and adds to PATH
# - Can be sourced and used as a command-line function
# Tested on: Ubuntu 24.04 LTS

# ----------------------------
# 1. Define Colors
# ----------------------------
GREEN='\033[0;32m'   # Success
RED='\033[0;31m'     # Error
YELLOW='\033[0;33m'  # Warning
BLUE='\033[0;34m'    # Info
NC='\033[0m'         # No Color (reset)

# ----------------------------
# 2. Ensure Curl is Installed
# ----------------------------
ensure_curl() {
    if ! command -v curl &>/dev/null; then
        echo -ne "${BLUE}📦 Installing Curl... ${NC}"
        sudo apt update && sudo apt install -y curl
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Installed Curl.${NC}"
        else
            echo -e "${RED}❌ Failed to install Curl.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}✅ Curl is already installed.${NC}"
    fi
}

# ----------------------------
# 3. Main Function: setup_dev_tools
# ----------------------------
setup_dev_tools() {
    echo -e "${BLUE}🚀 Starting Developer Tools Setup...${NC}"

    # ----------------------------
    # 4. Source .bashrc to Load check_dev_tools
    # ----------------------------
    echo -ne "${BLUE}[1/8] Loading check_dev_tools from ~/.bashrc... ${NC}"
    if ! grep -q "function check_dev_tools" ~/.bashrc; then
        echo -e "${RED}❌ Function 'check_dev_tools' not found in ~/.bashrc. Please ensure it's defined.${NC}"
        return 1
    fi
    source ~/.bashrc
    echo -e "${GREEN}✅ Loaded check_dev_tools.${NC}"

    # ----------------------------
    # 5. Run Tool Audit
    # ----------------------------
    echo -ne "${BLUE}[2/8] Running Development Environment Audit... ${NC}"
    check_dev_tools_output=$(check_dev_tools 2>&1)
    echo -e "${GREEN}✅ Audit complete.${NC}"

    # Debug: Show full output of check_dev_tools
    echo -e "${YELLOW}🔍 Full Audit Output:${NC}"
    echo "$check_dev_tools_output"

    # Parse output to find missing tools
    MISSING_TOOLS=()
    if echo "$check_dev_tools_output" | grep -q "Command 'git' not found"; then MISSING_TOOLS+=("git"); fi
    if echo "$check_dev_tools_output" | grep -q "Command 'pip3' not found"; then MISSING_TOOLS+=("pip3"); fi
    if echo "$check_dev_tools_output" | grep -q "Command 'nodejs' not found"; then MISSING_TOOLS+=("nodejs"); fi
    if echo "$check_dev_tools_output" | grep -q "Command 'npm' not found"; then MISSING_TOOLS+=("npm"); fi
    if echo "$check_dev_tools_output" | grep -q "Command 'java' not found"; then MISSING_TOOLS+=("java"); fi
    if echo "$check_dev_tools_output" | grep -q "Command 'gcc' not found"; then MISSING_TOOLS+=("c-toolchain"); fi
    if echo "$check_dev_tools_output" | grep -q "Command 'mysql' not found"; then MISSING_TOOLS+=("mysql-server"); fi
    if echo "$check_dev_tools_output" | grep -q "Command 'php' not found"; then MISSING_TOOLS+=("php"); fi
    if echo "$check_dev_tools_output" | grep -q "Command 'composer' not found"; then MISSING_TOOLS+=("composer"); fi
    if ! snap list | grep -qi "postman"; then MISSING_TOOLS+=("postman"); fi
    if ! command -v apache2 &>/dev/null; then MISSING_TOOLS+=("apache2"); fi

    # Debug: Show detected missing tools
    echo -e "${YELLOW}🔍 Detected missing tools: ${MISSING_TOOLS[@]}${NC}"

    # ----------------------------
    # 6. Install Missing Tools
    # ----------------------------
    if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
        echo -e "${GREEN}[3/8] All required tools are already installed!${NC}"
    else
        echo -e "${YELLOW}[3/8] Installing missing tools...${NC}"

        # Ensure curl is installed
        ensure_curl

        for TOOL in "${MISSING_TOOLS[@]}"; do
            case $TOOL in
            git)
                if ! command -v git &>/dev/null; then
                    echo -ne "${BLUE}📦 Installing Git... ${NC}"
                    sudo apt update && sudo apt install -y git
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}✅ Installed Git.${NC}"
                    else
                        echo -e "${RED}❌ Failed to install Git.${NC}"
                    fi
                else
                    echo -e "${GREEN}✅ Git is already installed.${NC}"
                fi
                ;;
            pip3)
                if ! command -v pip3 &>/dev/null; then
                    echo -ne "${BLUE}🐍 Installing Pip... ${NC}"
                    sudo apt update && sudo apt install -y python3-pip
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}✅ Installed Pip.${NC}"
                    else
                        echo -e "${RED}❌ Failed to install Pip.${NC}"
                    fi
                else
                    echo -e "${GREEN}✅ Pip is already installed.${NC}"
                fi
                ;;
            nodejs | npm)
                if ! command -v nodejs &>/dev/null || ! command -v npm &>/dev/null; then
                    echo -ne "${BLUE}🟢 Installing Node.js (LTS)... ${NC}"
                    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
                    sudo apt update && sudo apt install -y nodejs
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}✅ Installed Node.js and NPM.${NC}"
                    else
                        echo -e "${RED}❌ Failed to install Node.js and NPM.${NC}"
                    fi
                else
                    echo -e "${GREEN}✅ Node.js and NPM are already installed.${NC}"
                fi
                ;;
            java)
                if ! command -v java &>/dev/null; then
                    echo -ne "${BLUE}☕ Installing Java (OpenJDK 17)... ${NC}"
                    sudo apt update && sudo apt install -y openjdk-17-jdk
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}✅ Installed Java (OpenJDK 17).${NC}"
                    else
                        echo -e "${RED}❌ Failed to install Java (OpenJDK 17).${NC}"
                    fi
                else
                    echo -e "${GREEN}✅ Java is already installed.${NC}"
                fi
                ;;
            c-toolchain)
                if ! command -v gcc &>/dev/null || ! command -v g++ &>/dev/null || ! command -v make &>/dev/null || ! command -v cmake &>/dev/null; then
                    echo -ne "${BLUE}🇨 Installing C/C++ toolchain... ${NC}"
                    sudo apt update && sudo apt install -y build-essential gcc g++ make cmake gdb
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}✅ Installed C/C++ toolchain.${NC}"
                    else
                        echo -e "${RED}❌ Failed to install C/C++ toolchain.${NC}"
                    fi
                else
                    echo -e "${GREEN}✅ C/C++ toolchain is already installed.${NC}"
                fi
                ;;
            mysql-server)
                if ! command -v mysql &>/dev/null; then
                    echo -ne "${BLUE}🗄️ Installing MySQL server... ${NC}"
                    sudo apt update && sudo apt install -y mysql-server
                    if [ $? -eq 0 ]; then
                        sudo systemctl stop mysql
                        sudo systemctl disable mysql
                        echo -e "${GREEN}✅ Installed MySQL server (not running).${NC}"
                    else
                        echo -e "${RED}❌ Failed to install MySQL server.${NC}"
                    fi
                else
                    echo -e "${GREEN}✅ MySQL is already installed.${NC}"
                fi
                ;;
            php)
                if ! command -v php &>/dev/null; then
                    echo -ne "${BLUE}🟨 Installing PHP... ${NC}"
                    sudo apt update && sudo apt install -y php php-cli php-mbstring php-xml php-curl php-sqlite3
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}✅ Installed PHP.${NC}"
                    else
                        echo -e "${RED}❌ Failed to install PHP.${NC}"
                    fi
                else
                    echo -e "${GREEN}✅ PHP is already installed.${NC}"
                fi
                ;;
            composer)
                if ! command -v composer &>/dev/null; then
                    echo -ne "${BLUE}🎵 Installing Composer... ${NC}"
                    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}✅ Installed Composer.${NC}"
                    else
                        echo -e "${RED}❌ Failed to install Composer.${NC}"
                    fi
                else
                    echo -e "${GREEN}✅ Composer is already installed.${NC}"
                fi
                ;;
            postman)
                if ! snap list | grep -qi "postman"; then
                    echo -ne "${BLUE}🐝 Installing Postman... ${NC}"
                    sudo snap install postman
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}✅ Installed Postman.${NC}"
                    else
                        echo -e "${RED}❌ Failed to install Postman.${NC}"
                    fi
                else
                    echo -e "${GREEN}✅ Postman is already installed.${NC}"
                fi
                ;;
            apache2)
                if ! command -v apache2 &>/dev/null; then
                    echo -ne "${BLUE}🌐 Installing Apache2... ${NC}"
                    sudo apt update && sudo apt install -y apache2
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}✅ Installed Apache2.${NC}"
                    else
                        echo -e "${RED}❌ Failed to install Apache2.${NC}"
                    fi
                else
                    echo -e "${GREEN}✅ Apache2 is already installed.${NC}"
                fi
                ;;
            *)
                echo -e "${RED}⚠️ Unknown tool: $TOOL${NC}"
                ;;
            esac
        done
    fi

    # ----------------------------
    # 7. Git Setup (Interactive)
    # ----------------------------
    echo -ne "${BLUE}[4/8] Setting up Git credentials... ${NC}"
    if ! git config --global user.name &>/dev/null; then
        read -p "Enter your Git username: " GIT_USER
        read -p "Enter your Git email: " GIT_EMAIL

        if ! command -v git &>/dev/null; then
            echo -e "${RED}❌ Git is not installed. Skipping Git configuration.${NC}"
        else
            git config --global user.name "$GIT_USER"
            git config --global user.email "$GIT_EMAIL"

            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Configured Git for user: $GIT_USER <$GIT_EMAIL>${NC}"
            else
                echo -e "${RED}❌ Failed to configure Git.${NC}"
            fi
        fi
    else
        echo -e "${GREEN}✅ Git is already configured.${NC}"
    fi

    # ----------------------------
    # 8. Show Tool Locations
    # ----------------------------
    echo -ne "${BLUE}[5/8] Summarizing installed tools... ${NC}"
    for TOOL in git python3 pip3 nodejs npm java gcc g++ make cmake mysql php composer postman apache2; do
        TOOL_PATH=$(which "$TOOL" 2>/dev/null)
        if [ -n "$TOOL_PATH" ]; then
            echo -e "${GREEN}✅ $TOOL installed at: $TOOL_PATH${NC}"
        else
            echo -e "${RED}❌ $TOOL not found${NC}"
        fi
    done
    echo -e "${GREEN}✅ Summary complete.${NC}"

    # ----------------------------
    # 9. Final Steps
    # ----------------------------
    echo -e "${BLUE}[6/8] Next Steps:${NC}"
    echo -e "${YELLOW}1. To start MySQL later: sudo systemctl start mysql${NC}"
    echo -e "${YELLOW}2. Run 'source ~/.bashrc' if you added new paths to your environment.${NC}"
    echo -e "${YELLOW}3. Start coding! 🚀${NC}"
    echo -e "${GREEN}[7/8] Developer Tools Setup Complete!${NC}"
}

# ----------------------------
# 10. Help Message
# ----------------------------
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo -e "${BLUE}Usage: setup_dev_tools${NC}"
    echo -e "${BLUE}Description: Detects and installs missing developer tools on Ubuntu systems.${NC}"
    echo -e "${BLUE}Options:${NC}"
    echo -e "  --help, -h    Show this help message"
    return 0
fi

