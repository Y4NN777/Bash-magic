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
    
    # Check if the first argument is a directory (that exists and isn't in the current directory)
    local TARGET_DIR="."
    if [ $# -gt 0 ] && [ -d "$1" ] && [ "$(basename "$1")" != "$(basename "$(pwd)/$1")" ]; then
        TARGET_DIR="$1"
        shift
    fi
    
    # Items to keep
    local KEEP_ITEMS=("$@")
    
    # Always keep essential hidden directories
    KEEP_ITEMS+=(".git")
    
    # Check if we have any items to keep
    if [ ${#KEEP_ITEMS[@]} -eq 0 ]; then
        echo "Usage: clean_except [-b] [directory] <item1> <item2>..."
        return 1
    fi
    
    echo "Target directory: $TARGET_DIR"
    echo "Items to keep: ${KEEP_ITEMS[*]}"
    
    # Enable dotglob to include hidden files/directories
    shopt -s dotglob
    
    # Prepare backup directory if needed
    local backup_dir=""
    if [ "$backup_mode" -eq 1 ]; then
        backup_dir="$TARGET_DIR/.backup_$(date +%Y%m%d%H%M%S)"
        mkdir -p "$backup_dir"
        echo "Backup mode enabled. Files will be moved to: $backup_dir"
    fi
    
    # Process each item in the target directory
    for item in "$TARGET_DIR"/*; do
        # Skip if the glob doesn't match any files
        [ ! -e "$item" ] && continue
        
        local item_name
        item_name=$(basename "$item")
        
        # Check if this item should be kept
        local should_keep=0
        for keep_item in "${KEEP_ITEMS[@]}"; do
            if [ "$item_name" = "$keep_item" ]; then
                should_keep=1
                break
            fi
        done
        
        # Process the item
        if [ "$should_keep" -eq 0 ]; then
            if [ "$backup_mode" -eq 1 ]; then
                mv "$item" "$backup_dir/"
                echo "Moved to backup: $item_name"
            else
                rm -rf "$item"
                echo "Deleted: $item_name"
            fi
        else
            echo "Kept: $item_name"
        fi
    done
    
    # Disable dotglob to restore default behavior
    shopt -u dotglob
    
    echo "Cleanup complete!"
    if [ "$backup_mode" -eq 1 ]; then
        echo "To revert, move the files from $backup_dir back to $TARGET_DIR."
    fi
}