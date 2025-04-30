# clean_except.sh 🧹

A useful Bash script to delete all files and directories in a given directory except the ones you specify. Optionally, you can enable backup mode to move deleted files to a backup folder instead of permanently deleting them.

## 📌 Features

- **Delete everything** except specified files and directories.
- **Backup mode**: Move deleted files to a backup directory to allow recovery.
- **Support for hidden files/directories** (like `.git`).
- **Linux and Windows (WSL) support**.

## 📂 Installation

To use the script, you first need to clone the repository and give it execution permissions.

### On Linux:

1. Clone the repository:
   ```bash
   git clone https://github.com/Y4NN/bash-magic.git
   cd bash-magic/clean_except
   ```

2. Give execution permissions:
   ```bash
   chmod +x clean_except.sh
   ```

### On Windows (using WSL):

1. Open your WSL terminal and clone the repository:
   ```bash
   git clone https://github.com/Y4NN/bash-magic.git
   cd bash-useful-scripts/clean_except
   ```

2. Give execution permissions:
   ```bash
   chmod +x clean_except.sh
   ```

## 📝 Usage

### Basic Usage (Delete files except the ones you specify)

To delete everything in the current directory (except the ones you specify), run the script as follows:

```bash
./clean_except.sh [directory] <item1> <item2> ...
```

* `[directory]` (optional): The directory to clean. Default is the current directory (`.`).
* `<item1> <item2> ...`: The names of files or directories you want to **keep**.

By default, the script will **always keep** the `.git` directory.

Example:
```bash
./clean_except.sh . README.md
```

This will delete all files and directories in the current directory except `README.md` and the `.git` directory (which is kept by default).

### Enable Backup Mode (Move deleted items to a backup folder)

To prevent permanent deletion, enable **backup mode** by adding the `-b` option. Deleted files will be moved to a backup folder in the target directory.

```bash
./clean_except.sh -b [directory] <item1> <item2> ...
```

Example:
```bash
./clean_except.sh -b . README.md
```

This will move deleted files and directories to a `.backup_TIMESTAMP` folder in the current directory, but will keep `.git` and `README.md`.

Example Output:
```bash
Backup mode enabled. Files will be moved to: ./clean_except/.backup_20230315123045
Kept: README.md
Kept: .git
Deleted: temp.txt
Moved to backup: old_backup/
Deleted: log_file.log
Cleanup complete!
To revert, move the files from ./clean_except/.backup_20230315123045 back to ./clean_except.
```

## 🛠️ Options

* `-b`: Enable backup mode. Files will be moved to a backup directory rather than permanently deleted.
* `[directory]`: The target directory where you want to delete files (defaults to the current directory `.`).
* `<item1> <item2> ...`: Files or directories to keep.

## Notes:

* If no items are specified, the script will prompt you with usage instructions.
* The script automatically **keeps** the `.git` directory by default.
* The script supports **hidden files** (like `.git`, `.env`, etc.) when using the `dotglob` shell option in Bash.

## 🖥️ Compatibility

* **Linux**: Fully compatible.
* **Windows**: Compatible with **WSL (Windows Subsystem for Linux)**. To use this script on native Windows, you would need to install a Bash shell like Git Bash or WSL.

## 📜 License

This script is open-source and distributed under the MIT License.

Feel free to modify, improve, and contribute to this script!

### Recent Changes:
1. **Default .git folder**: The .git folder is kept by default, and this is now clearly stated in the usage section.
2. **Example**: The example demonstrates that .git is kept even without being explicitly mentioned in the command.