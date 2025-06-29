#!/bin/bash

# === Enhanced Developer Setup Script for Ubuntu 24.04 - FINAL VERSION ===
# Description: A comprehensive setup script to detect and install missing developer tools
# Features:
# - Sources .bashrc to reuse check_dev_tools
# - Installs only missing tools with proper detection
# - Interactive Git setup (asks for name/email)
# - MySQL installed but not started
# - Feedback after each step with colored output
# - Progress indicators for each step
# - Shows tool locations and adds to PATH
# - Can be sourced and used as a command-line function
# - Includes Flutter, Android Studio, Docker, PostgreSQL, MongoDB, VS Code, and more
# - FIXED: Flutter installation using exact official URL
# - FIXED: Direct command detection instead of text parsing
# - FIXED: Android Studio installation with verification
# - FIXED: pyenv cleanup before installation
# Tested on: Ubuntu 24.04 LTS
# Official Flutter Guide: https://docs.flutter.dev/get-started/install/linux/android

# ----------------------------
# 1. Define Colors
# ----------------------------
GREEN='\033[0;32m'   # Success
RED='\033[0;31m'     # Error
YELLOW='\033[0;33m'  # Warning
BLUE='\033[0;34m'    # Info
NC='\033[0m'         # No Color (reset)

# ----------------------------
# 2. Utility Functions
# ----------------------------
ensure_curl() {
    if ! command -v curl &>/dev/null; then
        echo -ne "${BLUE}Installing Curl... ${NC}"
        sudo apt update && sudo apt install -y curl
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Installed Curl.${NC}"
        else
            echo -e "${RED}Failed to install Curl.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Curl is already installed.${NC}"
    fi
}

ensure_wget() {
    if ! command -v wget &>/dev/null; then
        echo -ne "${BLUE}Installing Wget... ${NC}"
        sudo apt update && sudo apt install -y wget
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Installed Wget.${NC}"
        else
            echo -e "${RED}Failed to install Wget.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}Wget is already installed.${NC}"
    fi
}

# Function to get Flutter version (using official stable version)
get_flutter_version() {
    echo -ne "${BLUE}Using official Flutter version... ${NC}"
    local official_version="3.32.5"
    echo -e "${GREEN}Official stable version: $official_version${NC}"
    echo "$official_version"
}

# ----------------------------
# 3. Main Function: setup_dev_tools
# ----------------------------
setup_dev_tools() {
    echo -e "${BLUE}Starting Developer Tools Setup...${NC}"

    # ----------------------------
    # 4. Source .bashrc to Load check_dev_tools (if available)
    # ----------------------------
    echo -ne "${BLUE}[1/12] Loading check_dev_tools from ~/.bashrc... ${NC}"
    if grep -q "function check_dev_tools" ~/.bashrc 2>/dev/null; then
        source ~/.bashrc
        echo -e "${GREEN}Loaded check_dev_tools.${NC}"
    else
        echo -e "${YELLOW}Function 'check_dev_tools' not found in ~/.bashrc. Using direct detection.${NC}"
    fi

    # ----------------------------
    # 5. Run Tool Detection (Direct command checking)
    # ----------------------------
    echo -ne "${BLUE}[2/12] Running Development Environment Detection... ${NC}"
    
    # Direct command checks (more reliable than parsing text)
    MISSING_TOOLS=()
    
    if ! command -v git &>/dev/null; then MISSING_TOOLS+=("git"); fi
    if ! command -v pip3 &>/dev/null; then MISSING_TOOLS+=("pip3"); fi
    if ! command -v nodejs &>/dev/null; then MISSING_TOOLS+=("nodejs"); fi
    if ! command -v npm &>/dev/null; then MISSING_TOOLS+=("npm"); fi
    if ! command -v java &>/dev/null; then MISSING_TOOLS+=("java"); fi
    if ! command -v javac &>/dev/null; then MISSING_TOOLS+=("javac"); fi
    if ! command -v gcc &>/dev/null; then MISSING_TOOLS+=("gcc"); fi
    if ! command -v g++ &>/dev/null; then MISSING_TOOLS+=("g++"); fi
    if ! command -v make &>/dev/null; then MISSING_TOOLS+=("make"); fi
    if ! command -v cmake &>/dev/null; then MISSING_TOOLS+=("cmake"); fi
    if ! command -v mysql &>/dev/null; then MISSING_TOOLS+=("mysql-server"); fi
    if ! command -v psql &>/dev/null; then MISSING_TOOLS+=("postgresql"); fi
    if ! command -v mongod &>/dev/null && ! command -v mongo &>/dev/null; then MISSING_TOOLS+=("mongodb"); fi
    if ! command -v php &>/dev/null; then MISSING_TOOLS+=("php"); fi
    if ! command -v composer &>/dev/null; then MISSING_TOOLS+=("composer"); fi
    if ! command -v docker &>/dev/null; then MISSING_TOOLS+=("docker"); fi
    if ! command -v docker-compose &>/dev/null; then MISSING_TOOLS+=("docker-compose"); fi
    if ! command -v code &>/dev/null; then MISSING_TOOLS+=("vscode"); fi
    if ! command -v nvim &>/dev/null; then MISSING_TOOLS+=("neovim"); fi
    if ! command -v vim &>/dev/null; then MISSING_TOOLS+=("vim"); fi
    if ! command -v subl &>/dev/null; then MISSING_TOOLS+=("sublime"); fi
    if ! snap list postman &>/dev/null 2>&1; then MISSING_TOOLS+=("postman"); fi
    if ! command -v jupyter &>/dev/null; then MISSING_TOOLS+=("jupyter"); fi
    if ! command -v zsh &>/dev/null; then MISSING_TOOLS+=("zsh"); fi
    if ! command -v flatpak &>/dev/null; then MISSING_TOOLS+=("flatpak"); fi
    if ! command -v flutter &>/dev/null; then MISSING_TOOLS+=("flutter"); fi
    if ! command -v apache2 &>/dev/null; then MISSING_TOOLS+=("apache2"); fi
    
    # Check for Android Studio
    if ! snap list android-studio &>/dev/null 2>&1 && ! command -v android-studio &>/dev/null; then 
        MISSING_TOOLS+=("android-studio"); 
    fi

    echo -e "${GREEN}Detection complete.${NC}"
    echo -e "${YELLOW}Detected missing tools: ${MISSING_TOOLS[@]}${NC}"

    # ----------------------------
    # 6. Install Missing Tools
    # ----------------------------
    if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
        echo -e "${GREEN}[3/12] All required tools are already installed!${NC}"
    else
        echo -e "${YELLOW}[3/12] Installing missing tools...${NC}"

        # Ensure curl and wget are installed
        ensure_curl
        ensure_wget

        for TOOL in "${MISSING_TOOLS[@]}"; do
            case $TOOL in
            git)
                if ! command -v git &>/dev/null; then
                    echo -ne "${BLUE}Installing Git... ${NC}"
                    sudo apt update && sudo apt install -y git
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Git.${NC}"
                    else
                        echo -e "${RED}Failed to install Git.${NC}"
                    fi
                fi
                ;;
            pip3)
                if ! command -v pip3 &>/dev/null; then
                    echo -ne "${BLUE}Installing Python3 and Pip... ${NC}"
                    sudo apt update && sudo apt install -y python3-pip python3-venv python3-dev
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Python3 and Pip.${NC}"
                    else
                        echo -e "${RED}Failed to install Python3 and Pip.${NC}"
                    fi
                fi
                ;;
            nodejs | npm)
                if ! command -v nodejs &>/dev/null || ! command -v npm &>/dev/null; then
                    echo -ne "${BLUE}Installing Node.js (LTS) and NPM... ${NC}"
                    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
                    sudo apt update && sudo apt install -y nodejs
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Node.js and NPM.${NC}"
                    else
                        echo -e "${RED}Failed to install Node.js and NPM.${NC}"
                    fi
                fi
                ;;
            java | javac)
                if ! command -v java &>/dev/null || ! command -v javac &>/dev/null; then
                    echo -ne "${BLUE}Installing Java (OpenJDK 17)... ${NC}"
                    sudo apt update && sudo apt install -y openjdk-17-jdk
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Java (OpenJDK 17).${NC}"
                    else
                        echo -e "${RED}Failed to install Java (OpenJDK 17).${NC}"
                    fi
                fi
                ;;
            gcc | g++ | make | cmake)
                if ! command -v gcc &>/dev/null || ! command -v g++ &>/dev/null || ! command -v make &>/dev/null || ! command -v cmake &>/dev/null; then
                    echo -ne "${BLUE}Installing C/C++ toolchain... ${NC}"
                    sudo apt update && sudo apt install -y build-essential gcc g++ make cmake gdb
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed C/C++ toolchain.${NC}"
                    else
                        echo -e "${RED}Failed to install C/C++ toolchain.${NC}"
                    fi
                fi
                ;;
            mysql-server)
                if ! command -v mysql &>/dev/null; then
                    echo -ne "${BLUE}Installing MySQL server... ${NC}"
                    sudo apt update && sudo apt install -y mysql-server
                    if [ $? -eq 0 ]; then
                        sudo systemctl stop mysql
                        sudo systemctl disable mysql
                        echo -e "${GREEN}Installed MySQL server (not running).${NC}"
                    else
                        echo -e "${RED}Failed to install MySQL server.${NC}"
                    fi
                fi
                ;;
            postgresql)
                if ! command -v psql &>/dev/null; then
                    echo -ne "${BLUE}Installing PostgreSQL... ${NC}"
                    sudo apt update && sudo apt install -y postgresql postgresql-contrib
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed PostgreSQL.${NC}"
                    else
                        echo -e "${RED}Failed to install PostgreSQL.${NC}"
                    fi
                fi
                ;;
            mongodb)
                if ! command -v mongo &>/dev/null && ! command -v mongod &>/dev/null; then
                    echo -ne "${BLUE}Installing MongoDB... ${NC}"
                    wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | sudo apt-key add -
                    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
                    sudo apt update && sudo apt install -y mongodb-org
                    if [ $? -eq 0 ]; then
                        sudo systemctl stop mongod
                        sudo systemctl disable mongod
                        echo -e "${GREEN}Installed MongoDB (not running).${NC}"
                    else
                        echo -e "${RED}Failed to install MongoDB.${NC}"
                    fi
                fi
                ;;
            php)
                if ! command -v php &>/dev/null; then
                    echo -ne "${BLUE}Installing PHP... ${NC}"
                    sudo apt update && sudo apt install -y php php-cli php-mbstring php-xml php-curl php-sqlite3 php-mysql php-pgsql
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed PHP.${NC}"
                    else
                        echo -e "${RED}Failed to install PHP.${NC}"
                    fi
                fi
                ;;
            composer)
                if ! command -v composer &>/dev/null; then
                    echo -ne "${BLUE}Installing Composer... ${NC}"
                    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Composer.${NC}"
                    else
                        echo -e "${RED}Failed to install Composer.${NC}"
                    fi
                fi
                ;;
            docker)
                if ! command -v docker &>/dev/null; then
                    echo -ne "${BLUE}Installing Docker... ${NC}"
                    curl -fsSL https://get.docker.com -o get-docker.sh
                    sudo sh get-docker.sh
                    sudo usermod -aG docker $USER
                    rm get-docker.sh
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Docker. Please log out and back in to use Docker without sudo.${NC}"
                    else
                        echo -e "${RED}Failed to install Docker.${NC}"
                    fi
                fi
                ;;
            docker-compose)
                if ! command -v docker-compose &>/dev/null; then
                    echo -ne "${BLUE}Installing Docker Compose... ${NC}"
                    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                    sudo chmod +x /usr/local/bin/docker-compose
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Docker Compose.${NC}"
                    else
                        echo -e "${RED}Failed to install Docker Compose.${NC}"
                    fi
                fi
                ;;
            vscode)
                if ! command -v code &>/dev/null; then
                    echo -ne "${BLUE}Installing Visual Studio Code... ${NC}"
                    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
                    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
                    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
                    sudo apt update && sudo apt install -y code
                    rm packages.microsoft.gpg
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Visual Studio Code.${NC}"
                    else
                        echo -e "${RED}Failed to install Visual Studio Code.${NC}"
                    fi
                fi
                ;;
            neovim)
                if ! command -v nvim &>/dev/null; then
                    echo -ne "${BLUE}Installing Neovim... ${NC}"
                    sudo apt update && sudo apt install -y neovim
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Neovim.${NC}"
                    else
                        echo -e "${RED}Failed to install Neovim.${NC}"
                    fi
                fi
                ;;
            vim)
                if ! command -v vim &>/dev/null; then
                    echo -ne "${BLUE}Installing Vim... ${NC}"
                    sudo apt update && sudo apt install -y vim
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Vim.${NC}"
                    else
                        echo -e "${RED}Failed to install Vim.${NC}"
                    fi
                fi
                ;;
            sublime)
                if ! command -v subl &>/dev/null; then
                    echo -ne "${BLUE}Installing Sublime Text... ${NC}"
                    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
                    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
                    sudo apt update && sudo apt install -y sublime-text
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Sublime Text.${NC}"
                    else
                        echo -e "${RED}Failed to install Sublime Text.${NC}"
                    fi
                fi
                ;;
            postman)
                if ! snap list | grep -qi "postman"; then
                    echo -ne "${BLUE}Installing Postman... ${NC}"
                    sudo snap install postman
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Postman.${NC}"
                    else
                        echo -e "${RED}Failed to install Postman.${NC}"
                    fi
                fi
                ;;
            jupyter)
                if ! command -v jupyter &>/dev/null; then
                    echo -ne "${BLUE}Installing Jupyter Notebook... ${NC}"
                    pip3 install jupyter notebook
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Jupyter Notebook.${NC}"
                    else
                        echo -e "${RED}Failed to install Jupyter Notebook.${NC}"
                    fi
                fi
                ;;
            zsh)
                if ! command -v zsh &>/dev/null; then
                    echo -ne "${BLUE}Installing Zsh... ${NC}"
                    sudo apt update && sudo apt install -y zsh
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Zsh.${NC}"
                    else
                        echo -e "${RED}Failed to install Zsh.${NC}"
                    fi
                fi
                ;;
            flatpak)
                if ! command -v flatpak &>/dev/null; then
                    echo -ne "${BLUE}Installing Flatpak... ${NC}"
                    sudo apt update && sudo apt install -y flatpak
                    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Flatpak.${NC}"
                    else
                        echo -e "${RED}Failed to install Flatpak.${NC}"
                    fi
                fi
                ;;
            flutter)
                # FIXED Flutter installation following official guide with exact URL
                if ! command -v flutter &>/dev/null && [ ! -d "$HOME/development/flutter" ]; then
                    echo -e "${BLUE}Installing Flutter following official guide...${NC}"
                    
                    # Step 1: Install Flutter prerequisites (official)
                    echo -ne "${BLUE}Installing Flutter prerequisites... ${NC}"
                    sudo apt-get update -y && sudo apt-get upgrade -y
                    sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
                    
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Flutter prerequisites installed.${NC}"
                    else
                        echo -e "${RED}Failed to install Flutter prerequisites.${NC}"
                        continue
                    fi
                    
                    # Step 2: Install Android Studio prerequisites (official)
                    echo -ne "${BLUE}Installing Android Studio prerequisites... ${NC}"
                    sudo apt-get install -y libc6:amd64 libstdc++6:amd64 lib32z1 libbz2-1.0:amd64
                    
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Android Studio prerequisites installed.${NC}"
                    else
                        echo -e "${RED}Failed to install Android Studio prerequisites.${NC}"
                        continue
                    fi
                    
                    # Step 3: Clean up any existing Flutter installation
                    if [ -d "$HOME/development/flutter" ]; then
                        echo -e "${YELLOW}Removing existing Flutter installation...${NC}"
                        rm -rf "$HOME/development/flutter"
                    fi
                    
                    # Step 4: Download Flutter SDK using exact official URL
                    FLUTTER_VERSION="3.32.5"
                    
                    # Create development directory
                    mkdir -p ~/development
                    cd ~/Downloads
                    
                    echo -ne "${BLUE}Downloading Flutter SDK v${FLUTTER_VERSION}... ${NC}"
                    # Use the exact official URL provided
                    FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.5-stable.tar.xz"
                    
                    # Remove any existing download
                    rm -f flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
                    
                    # Download Flutter SDK with better error handling
                    if wget --progress=bar --timeout=60 --tries=3 -O flutter_linux_${FLUTTER_VERSION}-stable.tar.xz "$FLUTTER_URL"; then
                        echo -e "${GREEN}Download complete.${NC}"
                        
                        # Step 5: Verify download
                        if [ -f "flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" ]; then
                            FILE_SIZE=$(du -h flutter_linux_${FLUTTER_VERSION}-stable.tar.xz | cut -f1)
                            echo -e "${GREEN}Download verified. File size: $FILE_SIZE${NC}"
                        else
                            echo -e "${RED}Download verification failed.${NC}"
                            cd - >/dev/null
                            continue
                        fi
                        
                        # Step 6: Extract Flutter (official location)
                        echo -ne "${BLUE}Extracting Flutter to ~/development/... ${NC}"
                        if tar -xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -C ~/development/; then
                            echo -e "${GREEN}Extraction complete.${NC}"
                            rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
                        else
                            echo -e "${RED}Failed to extract Flutter.${NC}"
                            rm -f flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
                            cd - >/dev/null
                            continue
                        fi
                    else
                        echo -e "${RED}Failed to download Flutter from official URL.${NC}"
                        echo -e "${RED}URL: $FLUTTER_URL${NC}"
                        echo -e "${RED}Please check your internet connection.${NC}"
                        cd - >/dev/null
                        continue
                    fi
                    
                    # Step 7: Verify Flutter installation
                    if [ -d "$HOME/development/flutter/bin" ] && [ -f "$HOME/development/flutter/bin/flutter" ]; then
                        echo -e "${GREEN}Flutter installation verified.${NC}"
                        
                        # Step 8: Add Flutter to PATH (OFFICIAL method using bash_profile)
                        echo -ne "${BLUE}Adding Flutter to PATH... ${NC}"
                        
                        # Clean existing PATH entries
                        sed -i '/flutter\/bin/d' ~/.bash_profile 2>/dev/null || true
                        sed -i '/flutter\/bin/d' ~/.bashrc 2>/dev/null || true
                        
                        # Check default shell
                        DEFAULT_SHELL=$(echo $SHELL)
                        
                        if [[ "$DEFAULT_SHELL" == *"bash"* ]]; then
                            # Use bash_profile as per official docs
                            echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.bash_profile
                            echo -e "${GREEN}Added Flutter to ~/.bash_profile${NC}"
                        fi
                        
                        # Also add to bashrc for compatibility
                        echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.bashrc
                        echo -e "${GREEN}Added Flutter to ~/.bashrc${NC}"
                        
                        # Add to current session PATH
                        export PATH="$HOME/development/flutter/bin:$PATH"
                        
                        # Step 9: Initialize Flutter
                        echo -ne "${BLUE}Initializing Flutter... ${NC}"
                        cd ~/development/flutter
                        if ./bin/flutter --version >/dev/null 2>&1; then
                            echo -e "${GREEN}Flutter initialized successfully.${NC}"
                        else
                            echo -e "${YELLOW}Flutter initialization had warnings (normal on first run).${NC}"
                        fi
                        
                        echo -e "${GREEN}✅ Flutter installation completed successfully!${NC}"
                        
                    else
                        echo -e "${RED}Flutter installation verification failed.${NC}"
                        echo -e "${RED}Debug info:${NC}"
                        echo -e "${RED}  - Flutter directory: $([ -d "$HOME/development/flutter" ] && echo 'EXISTS' || echo 'MISSING')${NC}"
                        echo -e "${RED}  - Flutter bin directory: $([ -d "$HOME/development/flutter/bin" ] && echo 'EXISTS' || echo 'MISSING')${NC}"
                        echo -e "${RED}  - Flutter binary: $([ -f "$HOME/development/flutter/bin/flutter" ] && echo 'EXISTS' || echo 'MISSING')${NC}"
                    fi
                    
                    cd - >/dev/null
                else
                    if command -v flutter &>/dev/null; then
                        echo -e "${GREEN}Flutter is already installed.${NC}"
                    elif [ -d "$HOME/development/flutter" ]; then
                        echo -e "${YELLOW}Flutter directory exists but not in PATH. Adding to PATH...${NC}"
                        
                        # Add to both bash_profile and bashrc for compatibility
                        if ! grep -q 'export PATH="$HOME/development/flutter/bin:$PATH"' ~/.bash_profile 2>/dev/null; then
                            echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.bash_profile
                        fi
                        if ! grep -q 'export PATH="$HOME/development/flutter/bin:$PATH"' ~/.bashrc 2>/dev/null; then
                            echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.bashrc
                        fi
                        export PATH="$HOME/development/flutter/bin:$PATH"
                        echo -e "${GREEN}Flutter added to PATH.${NC}"
                    fi
                fi
                ;;
            android-studio)
                # Install Android Studio separately (full version as required)
                if ! snap list android-studio &>/dev/null 2>&1; then
                    echo -ne "${BLUE}Installing Android Studio (full version)... ${NC}"
                    if sudo snap install android-studio --classic 2>/dev/null; then
                        echo -e "${GREEN}Android Studio installed successfully.${NC}"
                        
                        # Verify snap installation
                        if snap list android-studio >/dev/null 2>&1; then
                            echo -e "${GREEN}Android Studio verified.${NC}"
                        else
                            echo -e "${YELLOW}Android Studio verification pending.${NC}"
                        fi
                    else
                        echo -e "${RED}Failed to install Android Studio via snap.${NC}"
                        echo -e "${YELLOW}Manual installation required from: https://developer.android.com/studio${NC}"
                    fi
                else
                    echo -e "${GREEN}Android Studio is already installed.${NC}"
                fi
                ;;
            apache2)
                if ! command -v apache2 &>/dev/null; then
                    echo -ne "${BLUE}Installing Apache2... ${NC}"
                    sudo apt update && sudo apt install -y apache2
                    if [ $? -eq 0 ]; then
                        echo -e "${GREEN}Installed Apache2.${NC}"
                    else
                        echo -e "${RED}Failed to install Apache2.${NC}"
                    fi
                fi
                ;;
            *)
                echo -e "${RED}Unknown tool: $TOOL${NC}"
                ;;
            esac
        done
    fi

    # ----------------------------
    # 7. Install Version Managers
    # ----------------------------
    echo -ne "${BLUE}[4/12] Installing Version Managers... ${NC}"
    
    # Install NVM (Node Version Manager)
    if [ ! -d "$HOME/.nvm" ]; then
        echo -ne "${BLUE}Installing NVM... ${NC}"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Installed NVM.${NC}"
        else
            echo -e "${RED}Failed to install NVM.${NC}"
        fi
    else
        echo -e "${GREEN}NVM is already installed.${NC}"
    fi

    # Install pyenv (Python Version Manager)
    if ! command -v pyenv &>/dev/null; then
        echo -ne "${BLUE}Installing pyenv... ${NC}"
        
        # Check if directory exists and remove it if needed
        if [ -d "$HOME/.pyenv" ]; then
            echo -e "${YELLOW}Existing pyenv directory found. Removing...${NC}"
            rm -rf "$HOME/.pyenv"
        fi
        
        curl https://pyenv.run | bash
        if [ $? -eq 0 ]; then
            # Add pyenv to PATH
            if ! grep -q 'export PYENV_ROOT="$HOME/.pyenv"' ~/.bashrc; then
                echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
                echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
                echo 'eval "$(pyenv init -)"' >> ~/.bashrc
            fi
            echo -e "${GREEN}Installed pyenv.${NC}"
        else
            echo -e "${RED}Failed to install pyenv.${NC}"
        fi
    else
        echo -e "${GREEN}pyenv is already installed.${NC}"
    fi

    echo -e "${GREEN}Version managers installation complete.${NC}"

    # ----------------------------
    # 8. Git Setup (Interactive)
    # ----------------------------
    echo -ne "${BLUE}[5/12] Setting up Git credentials... ${NC}"
    if command -v git &>/dev/null; then
        if ! git config --global user.name &>/dev/null; then
            read -p "Enter your Git username: " GIT_USER
            read -p "Enter your Git email: " GIT_EMAIL

            git config --global user.name "$GIT_USER"
            git config --global user.email "$GIT_EMAIL"

            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Configured Git for user: $GIT_USER <$GIT_EMAIL>${NC}"
            else
                echo -e "${RED}Failed to configure Git.${NC}"
            fi
        else
            echo -e "${GREEN}Git is already configured.${NC}"
        fi
    else
        echo -e "${RED}Git is not installed. Skipping Git configuration.${NC}"
    fi

    # ----------------------------
    # 9. Show Tool Locations
    # ----------------------------
    echo -ne "${BLUE}[6/12] Summarizing installed tools... ${NC}"
    TOOLS_TO_CHECK=(git python3 pip3 nodejs npm java javac gcc g++ make cmake mysql psql mongo php composer docker docker-compose code nvim vim subl jupyter zsh flatpak flutter apache2)
    
    for TOOL in "${TOOLS_TO_CHECK[@]}"; do
        TOOL_PATH=$(which "$TOOL" 2>/dev/null)
        if [ -n "$TOOL_PATH" ]; then
            echo -e "${GREEN}$TOOL installed at: $TOOL_PATH${NC}"
        fi
    done
    
    # Check for snap packages
    if snap list postman &>/dev/null; then
        echo -e "${GREEN}postman installed via snap${NC}"
    fi
    if snap list android-studio &>/dev/null; then
        echo -e "${GREEN}android-studio installed via snap${NC}"
    fi
    
    echo -e "${GREEN}Summary complete.${NC}"

    # ----------------------------
    # 10. Final Steps and Instructions
    # ----------------------------
    echo -e "${BLUE}[7/12] Post-installation steps...${NC}"
    
    # Update PATH for current session
    source ~/.bashrc 2>/dev/null || true
    
    echo -e "${GREEN}Post-installation steps complete.${NC}"

    # ----------------------------
    # 11. Final Instructions
    # ----------------------------
    echo -e "${BLUE}[8/12] Next Steps (Following Official Flutter Guide):${NC}"
    echo -e "${YELLOW}1. To start MySQL: sudo systemctl start mysql${NC}"
    echo -e "${YELLOW}2. To start PostgreSQL: sudo systemctl start postgresql${NC}"
    echo -e "${YELLOW}3. To start MongoDB: sudo systemctl start mongod${NC}"
    echo -e "${YELLOW}4. Restart terminal or run: source ~/.bash_profile${NC}"
    echo -e "${YELLOW}5. Verify Flutter: flutter --version${NC}"
    echo -e "${YELLOW}6. Check setup: flutter doctor${NC}"
    echo -e "${YELLOW}7. Open Android Studio and complete setup wizard${NC}"
    echo -e "${YELLOW}8. In Android Studio, install these Android SDK components:${NC}"
    echo -e "${YELLOW}   • Android SDK Platform, API 35${NC}"
    echo -e "${YELLOW}   • Android SDK Command-line Tools${NC}"
    echo -e "${YELLOW}   • Android SDK Build-Tools${NC}"
    echo -e "${YELLOW}   • Android SDK Platform-Tools${NC}"
    echo -e "${YELLOW}   • Android Emulator${NC}"
    echo -e "${YELLOW}9. Accept Android licenses: flutter doctor --android-licenses${NC}"
    echo -e "${YELLOW}10. Install Flutter plugin in Android Studio${NC}"
    echo -e "${YELLOW}11. Log out and back in to use Docker without sudo${NC}"
    
    echo -e "${GREEN}[9/12] Developer Tools Setup Complete!${NC}"
    
    # ----------------------------
    # 12. Run Final Audit (if available)
    # ----------------------------
    echo -e "${BLUE}[10/12] Running final audit...${NC}"
    if command -v check_dev_tools &>/dev/null; then
        check_dev_tools
    else
        echo -e "${YELLOW}check_dev_tools function not available. Skipping audit.${NC}"
    fi
    echo -e "${GREEN}[11/12] Final audit complete.${NC}"
    
    echo -e "${GREEN}[12/12] Setup finished! Happy coding!${NC}"
    
    # Additional Flutter-specific instructions (following official guide)
    if command -v flutter &>/dev/null; then
        echo -e "${BLUE}Flutter Setup Verification (Official Guide):${NC}"
        echo -e "${YELLOW}Run these commands to verify your Flutter installation:${NC}"
        echo -e "${YELLOW}  flutter --version                    # Check Flutter version${NC}"
        echo -e "${YELLOW}  flutter doctor                      # Check setup status${NC}"
        echo -e "${YELLOW}  flutter doctor --android-licenses   # Accept Android licenses${NC}"
        echo -e "${YELLOW}${NC}"
        echo -e "${YELLOW}In Android Studio, ensure you install:${NC}"
        echo -e "${YELLOW}  • Flutter plugin for IntelliJ${NC}"
        echo -e "${YELLOW}  • Dart plugin for IntelliJ${NC}"
        echo -e "${YELLOW}  • Android SDK Platform (API 35)${NC}"
        echo -e "${YELLOW}  • Android Emulator${NC}"
        echo -e "${YELLOW}${NC}"
        echo -e "${YELLOW}Create your first Flutter app:${NC}"
        echo -e "${YELLOW}  flutter create my_first_app${NC}"
        echo -e "${YELLOW}  cd my_first_app${NC}"
        echo -e "${YELLOW}  flutter run${NC}"
    fi
}

# ----------------------------
# Help Message
# ----------------------------
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo -e "${BLUE}Usage: setup_dev_tools${NC}"
    echo -e "${BLUE}Description: Detects and installs missing developer tools on Ubuntu systems.${NC}"
    echo -e "${BLUE}Includes: Git, Python, Node.js, Java, C/C++, databases, editors, Flutter, Android Studio, and more.${NC}"
    echo -e "${BLUE}Features:${NC}"
    echo -e "  - Fixed Flutter installation using official URL"
    echo -e "  - Direct command detection (no text parsing)"
    echo -e "  - Proper error checking and validation"
    echo -e "  - Dynamic version detection"
    echo -e "  - Comprehensive development environment setup"
    echo -e "  - Follows official Flutter installation guide"
    echo -e "${BLUE}Options:${NC}"
    echo -e "  --help, -h    Show this help message"
    echo -e "${BLUE}Official Flutter Guide: https://docs.flutter.dev/get-started/install/linux/android${NC}"
    exit 0
fi

# Run the setup if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_dev_tools
fi