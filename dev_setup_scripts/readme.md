# Check & Setup Scripts 🛠️

This folder contains two Bash scripts designed to audit and manage developer tools on an Ubuntu-based system. These scripts are modular, easy to use, and ensure a consistent development environment.

---

## 📂 Folder Contents

1. **`check_dev_tools.sh`**  
   A script to audit your development environment. It checks for commonly used developer tools and provides detailed feedback about their installation status, versions, and configurations.

2. **`setup-dev-tools.sh`**  
   A script to detect and install missing developer tools based on the output of `check_dev_tools.sh`. It supports interactive Git configuration and provides step-by-step feedback during execution.

---

## 🔧 How the Scripts Work

### 1. **`check_dev_tools.sh`**
- **Purpose**: Audits your system to identify installed and missing developer tools.
- **Output**:
  - `"✅ Tool Installed: version"` if the tool is installed.
  - `"❌ Tool not found"` if the tool is missing.
- **Tools Checked**:
  - Git
  - Python & Pip
  - Node.js & NPM
  - Java
  - Docker
  - MySQL, PostgreSQL, MongoDB
  - C/C++ Toolchain (GCC, G++, Make, CMake)
  - Editors (VS Code, Neovim, Vim, Sublime Text)
  - Postman
  - Jupyter Notebook
  - Apache2
  - PHP & Composer
  - Flutter
  - And more...

### 2. **`setup-dev-tools.sh`**
- **Purpose**: Installs missing tools detected by `check_dev_tools.sh`.
- **Features**:
  - Installs only the tools that are missing from your system.
  - Configures Git interactively with your username and email.
  - Ensures tools like Apache2, MySQL, and PHP are properly configured after installation.
- **Tools Supported**:
  - Same as `check_dev_tools.sh`.

---

## 📝 Usage

### 1. Audit Your Development Environment
Run `check_dev_tools.sh` to perform a detailed audit of your system:
```bash
./check_dev_tools.sh
```

#### Example Output:
```bash
🔧 Git:
  ❌ Git Not found

🐍 Python & Pip:
  ✅ Python Installed: Python 3.12.3
  ✅ Pip Installed: pip 24.0 from /usr/lib/python3/dist-packages/pip (python 3.12)

🟢 Node.js & NPM:
  ✅ Node.js Installed: v22.15.0
  ✅ NPM Installed: 10.9.2
```

### 2. Install Missing Developer Tools
Run `setup-dev-tools.sh` to install any missing tools detected by `check_dev_tools.sh`:
```bash
./setup-dev-tools.sh
```

#### Example Output:
```bash
[1/8] Loading check_dev_tools from ~/.bashrc... ✅ Loaded check_dev_tools.
[2/8] Running Development Environment Audit... ✅ Audit complete.
[3/8] Installing missing tools...
📦 Installing Git... ✅ Installed Git.
🐍 Installing Python3... ✅ Python3 is already installed.
🟢 Installing Node.js... ✅ Node.js is already installed.
```

---

## 🛠️ Adding Scripts to `.bashrc` for Direct Command-Line Access

To make these scripts available as commands directly in your terminal:

1. Open your `.bashrc` file:
   ```bash
   nano ~/.bashrc
   ```

2. Add the following lines:
   ```bash
   alias check_dev_tools="bash ~/bash-magic/check-and-setup/check_dev_tools.sh"
   alias setup_dev_tools="bash ~/bash-magic/check-and-setup/setup-dev-tools.sh"
   ```

3. Reload your `.bashrc`:
   ```bash
   source ~/.bashrc
   ```

Now you can run the scripts directly:
```bash
check_dev_tools
setup_dev_tools
```

---

## 🌟 Contributions Welcome!

If you use additional tools in your workflow, feel free to extend the scripts. Here’s how:

1. **Edit `check_dev_tools.sh`:**
   - Add a new section to check for the tool using its command-line interface.
   - Example:
     ```bash
     echo -e "\n📦 New Tool:"
     if new_tool_version=$(new-tool --version 2>/dev/null); then
         echo "  ✅ New Tool Installed: $new_tool_version"
     else
         echo "  ❌ New Tool not found"
     fi
     ```

2. **Edit `setup-dev-tools.sh`:**
   - Add logic to install the new tool if it’s missing.
   - Example:
     ```bash
     if echo "$check_dev_tools_output" | grep -q "  ❌ New Tool not found"; then MISSING_TOOLS+=("new-tool"); fi

     case $TOOL in
     new-tool)
         if ! command -v new-tool &>/dev/null; then
             echo -ne "${BLUE}📦 Installing New Tool... ${NC}"
             sudo apt update && sudo apt install -y new-tool
             if [ $? -eq 0 ]; then
                 echo -e "${GREEN}✅ Installed New Tool.${NC}"
             else
                 echo -e "${RED}❌ Failed to install New Tool.${NC}"
             fi
         else
             echo -e "${GREEN}✅ New Tool is already installed.${NC}"
         fi
         ;;
     esac
     ```

3. Test your changes and submit a pull request.

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](../LICENSE) file in the parent directory for details.

---

Let me know if this version better reflects the scripts and provides the clarity you’re looking for! 😊