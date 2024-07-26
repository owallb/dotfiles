#!/usr/bin/env zsh

set -e

DISTRO="$(sed -n 's/^NAME="\([^"]\+\)"/\1/p' /etc/os-release)"

SCRIPT_FILE="$(readlink -f -- "$0")"
SCRIPT_NAME="$(basename -- "$SCRIPT_FILE")"
SCRIPT_DIR="$(dirname -- "$SCRIPT_FILE")"

SOURCE_DIR="$SCRIPT_DIR"
TARGET_DIR="$HOME"

PRINT_HELP=false
REMOVE_EXISTING=false
IGNORE_EXISTING=false
ERROR=false

# Define packages
typeset -a PKGS
PKGS=(
    "zsh"
    "tmux"
    "alacritty"
    "i3"
    "i3status"
    "i3lock"
    "picom"
    "dunst"
    "rofi"
    "startx"
    "lf"
    "jq"
)

# Define paths to symlink
typeset -a SYMLINKS
SYMLINKS=(
    ".Xresources"
    ".xinitrc"
    ".xinit-scripts"
    ".zshrc"
    ".p10k.zsh"
    ".gtkrc-2.0"
    ".config/tmux"
    ".config/alacritty"
    ".config/i3"
    ".config/i3status"
    ".config/rofi"
    ".config/picom"
    ".config/dunst"
    ".config/lf"
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".config/yay"
    ".local/bin"
    ".local/share/fonts"
)

error() {
    msg="$1"
    ERROR=true
    echo "Error: $msg" >&2
}

check_packages_installed() {
    for pkg in "${PKGS[@]}"; do
        if ! type "$pkg" >/dev/null; then
            error "missing $pkg"
        fi
    done
}

create_symlinks() {
    for link in "${SYMLINKS[@]}"; do
        SOURCE_PATH="${SOURCE_DIR}/$link"

        # Check source exists
        if ! test -e "$SOURCE_PATH"; then
            error "the following source path does not exist:"
            error "$SOURCE_PATH"
            continue
        fi

        TARGET_LINK="${TARGET_DIR}/$link"
        TARGET_LINK_PARENT="$(dirname -- "$TARGET_LINK")"

        # Create parent dirs if necessary
        if ! test -d "$TARGET_LINK_PARENT"; then
            echo "Creating $TARGET_LINK_PARENT"
            mkdir -p "$TARGET_LINK_PARENT"
        fi

        # Check if already exists as a symlink
        if test -s "$TARGET_LINK"; then
            if ! $IGNORE_EXISTING; then
                error "target link already exists:"
                error "$TARGET_LINK"
            fi
            continue
        elif test -e "$TARGET_LINK"; then
            error "target path already exists and is not a symlink:"
            error "$TARGET_LINK"
            continue
        fi

        # Create link
        echo "Linking $SOURCE_PATH -> $TARGET_LINK"
        ln -s "$SOURCE_PATH" "$TARGET_LINK"
    done
}

remove_existing() {
    for link in "${SYMLINKS[@]}"; do
        TARGET_LINK="${TARGET_DIR}/$link"
        TARGET_LINK_PARENT="$(dirname -- "$TARGET_LINK")"

        if test -s "$TARGET_LINK"; then\
            echo "Removing symlink $TARGET_LINK"
            rm "$TARGET_LINK"
        elif test -e "$TARGET_LINK"; then
            error "target path already exists and is not a symlink:"
            error "$TARGET_LINK"
        fi
    done

    if $ERROR; then
        exit 1
    fi
}

check_terminfo() {
    if ! infocmp tmux-256color > /dev/null; then
        error "Missing terminfo for tmux-256color. Try installing ncurses-term."
    fi

    if $ERROR; then
        exit 1
    fi
}


print_help() {
    echo "Usage: $SCRIPT_NAME [...]"
    echo ""
    echo "Options:"
    echo "    -h, --help             Print this help message"
    echo "    -i, --ignore-existing  Ignore existing symlinks"
    echo "    -r, --remove-existing  Remove any existing symlinks"
}

while [ $# -gt 0 ]; do
    case $1 in
        -h|--help)
            PRINT_HELP=true
            shift
            ;;
        -r|--remove-existing)
            REMOVE_EXISTING=true
            shift
            ;;
        -i|--ignore-existing)
            IGNORE_EXISTING=true
            shift
            ;;
        *)
            error "unknown option: $1"
            PRINT_HELP=true
            shift
            ;;
    esac
done

if $PRINT_HELP; then
    print_help
elif $REMOVE_EXISTING; then
    remove_existing
else
    check_terminfo
    check_packages_installed
    create_symlinks
fi

if $ERROR; then
    exit 1
fi
