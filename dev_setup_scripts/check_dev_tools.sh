# === Function: check_dev_tools ===
# Description: Checks for commonly used developer tools on Linux systems
# Usage: check_dev_tools
# Requires: bash, standard GNU utilities
# Tested on: Ubuntu 24.04 LTS

function check_dev_tools() {
    echo -e "\n🐧 Development Environment Audit Tool\n"

    echo -e "📦 OS Version:"
    if ! lsb_release -a 2>/dev/null | awk '{print "  "$0}'; then
        echo "  Unable to retrieve OS info"
    fi

    echo -e "\n🔧 Git:"
    if ! git --version 2>&1 | sed 's/^/  /'; then
        echo "  Git not found"
    fi

    echo -e "\n🐍 Python & Pip:"
    if ! python3 --version 2>&1 | sed 's/^/  /'; then
        echo "  Python not found"
    fi
    if ! pip3 --version 2>&1 | sed 's/^/  /'; then
        echo "  Pip not found"
    fi
    python3 -c "import sys; print('  Current Python Path:', sys.executable)" 2>/dev/null

    echo -e "\n🟢 Node.js & NPM:"
    if ! nodejs --version 2>&1 | sed 's/^/  /'; then
        echo "  Node.js not found"
    fi
    if ! npm --version 2>&1 | sed 's/^/  /'; then
        echo "  NPM not found"
    fi

    echo -e "\n☕ Java:"
    if ! java --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  Java runtime not found"
    fi
    if ! javac --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  Java compiler not found"
    fi

    echo -e "\n🐋 Docker:"
    if ! docker --version 2>&1 | sed 's/^/  /'; then
        echo "  Docker not found"
    fi
    if ! docker-compose --version 2>&1 | sed 's/^/  /'; then
        echo "  Docker Compose not found"
    fi

    echo -e "\n🗄️ Databases:"
    if ! mysql --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  MySQL not found"
    fi
    if ! psql --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  PostgreSQL not found"
    fi
    if ! mongo --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  MongoDB not found"
    fi

    echo -e "\n🇨 C/C++ Toolchain:"
    if ! gcc --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  GCC not found"
    fi
    if ! g++ --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  G++ not found"
    fi
    if ! make --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  Make not found"
    fi
    if ! cmake --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  CMake not found"
    fi

    echo -e "\n📄 Editors & IDEs:"
    if ! code --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  VS Code not found"
    fi
    if ! nvim --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  Neovim not found"
    fi
    if ! vim --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  Vim not found"
    fi
    if ! subl --version 2>&1 | sed 's/^/  /'; then
        echo "  Sublime Text not found"
    fi

    echo -e "\n🐝 API Tools:"
    # if ! postman --version 2>&1 | sed 's/^/  /'; then
    #     echo "  Postman not found"
    # fi
    if snap list | grep -qi "postman" 2>&1 | sed 's/^/  /'; then
        echo -e "${GREEN}✅ Postman is installed.${NC}"
    else
        echo "  Postman not found"
    fi

    echo -e "\n📓 Jupyter Notebook:"
    if ! jupyter notebook --version 2>&1 | sed 's/^/  /'; then
        echo "  Jupyter Notebook not found"
    fi

    echo -e "\n🐚 Shell Info:"
    echo "  Current shell: $SHELL"
    if ! zsh --version 2>&1 | sed 's/^/  /'; then
        echo "  Zsh not found"
    fi

    echo -e "\n📦 Package Managers:"
    if ! apt --version 2>&1 | head -n1 | sed 's/^/  /'; then
        echo "  APT not found"
    fi
    if ! snap version 2>&1 | grep -i version | sed 's/^/  /'; then
        echo "  Snap not found"
    fi
    if ! flatpak --version 2>&1 | sed 's/^/  /'; then
        echo "  Flatpak not found"
    fi

    echo -e "\n⚙️ Version Managers:"
    if nvm --version &>/dev/null; then
        echo "  nvm found"
    else
        echo "  nvm not found"
    fi
    if rbenv --version &>/dev/null; then
        echo "  rbenv found"
    else
        echo "  rbenv not found"
    fi
    if pyenv --version &>/dev/null; then
        echo "  pyenv found"
    else
        echo "  pyenv not found"
    fi

    echo -e "\n🟨 PHP & Laravel Stack:"
    if ! php --version 2>&1 | sed 's/^/  /'; then
        echo "  PHP not found"
    fi
    if ! composer --version 2>&1 | sed 's/^/  /'; then
        echo "  Composer not found"
    fi

    echo -e "\n📱 Flutter & Mobile Dev:"
    if ! flutter --version 2>&1 | sed 's/^/  /'; then
        echo "  Flutter not found"
    fi

    echo -e "\n🧬 System Info:"
    echo "  Kernel: $(uname -r)"
    echo "  Architecture: $(arch)"
    echo "  Free Memory:" && free -h | awk 'NR==1 || NR==2' | sed 's/^/    /'
    echo "  Disk Space (root):" && df -h / | awk 'NR==1 || NR==2' | sed 's/^/    /'

    echo -e "\n✅ Dev tool audit complete.\n"
} 