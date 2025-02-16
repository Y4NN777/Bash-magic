
clean_except() {
    local backup_mode=0

    # Parse options: currently only -b for backup mode
    while getopts ":b" opt; do
        case $opt in
            b)
                backup_mode=1
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                echo "Usage: clean_except [-b] [directory] <item1> <item2>..."
                return 1
                ;;
        esac
    done
    shift $((OPTIND - 1))

    # Check if the first argument is a directory.
    local TARGET_DIR
    if [ -d "$1" ]; then
        TARGET_DIR="$1"
        shift
    else
        TARGET_DIR="."
    fi

    local KEEP_ITEMS=("$@")

    # Always keep essential hidden directories
    KEEP_ITEMS+=(".git")

    if [ ${#KEEP_ITEMS[@]} -eq 0 ]; then
        echo "Usage: clean_except [-b] [directory] <item1> <item2>..."
        return 1
    fi

    # Enable dotglob to include hidden files/directories.
    shopt -s dotglob

    # If backup mode is enabled, create a backup directory.
    local backup_dir=""
    if [ "$backup_mode" -eq 1 ]; then
        backup_dir="$TARGET_DIR/.backup_$(date +%Y%m%d%H%M%S)"
        mkdir -p "$backup_dir"
        echo "Backup mode enabled. Files will be moved to: $backup_dir"
    fi

    # Process each item in the target directory.
    for item in "$TARGET_DIR"/*; do
        local item_name
        item_name=$(basename "$item")
        if [[ ! " ${KEEP_ITEMS[@]} " =~ " $item_name " ]]; then
            if [ "$backup_mode" -eq 1 ]; then
                mv "$item" "$backup_dir/"
                echo "Moved to backup: $item"
            else
                rm -rf "$item"
                echo "Deleted: $item"
            fi
        else
            echo "Kept: $item"
        fi
    done

    # Disable dotglob to restore default behavior.
    shopt -u dotglob

    echo "Cleanup complete!"
    if [ "$backup_mode" -eq 1 ]; then
        echo "To revert, move the files from $backup_dir back to $TARGET_DIR."
    fi
}
