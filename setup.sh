#!/usr/bin/env zsh

set -e

DISTRO="$(sed -n 's/^NAME="\([^"]\+\)"/\1/p' /etc/os-release)"

SCRIPT_FILE="$(readlink -f -- "$0")"
SCRIPT_NAME="$(basename -- "$SCRIPT_FILE")"
SCRIPT_DIR="$(dirname -- "$SCRIPT_FILE")"

SOURCE_DIR="$SCRIPT_DIR"
DEST_DIR="$HOME"

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
    "fish"
)

# Define paths to symlink
typeset -a SYMLINKS
SYMLINKS=(
    ".Xresources"
    ".xinitrc"
    ".xinit-scripts"
    ".gtkrc-2.0"
    ".config/tmux"
    ".config/alacritty"
    ".config/fish"
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

typeset -A SYMLINK_MAP
SYMLINK_MAP[zsh/rc]=".zshrc"

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

remove_symlink() {
    local link src
    link="${DEST_DIR}/$1"

    if test -L "$link"; then
        src="$(readlink -f -- "$link")"
        echo "Removing symlink: $link -> $src"
        rm "$link"
    elif test -e "$link"; then
        error "object to be removed is not a symlink:"
        error "${link}: $(stat -c '%F' -- "$link")"

        return
    fi
}

remove_all_symlinks() {
    for link in "${SYMLINKS[@]}"; do
        remove_symlink "$link"
    done

    for src dst in ${(kv)SYMLINK_MAP}; do
        remove_symlink "$dst"
    done
}

create_symlink() {
    local src dst dst_parent

    if test -z "$1"; then
        error "missing src argument:"
        error "$0 $1 $2"
        return
    fi

    if test -z "$2"; then
        error "missing dst argument:"
        error "$0 $1 $2"
        return
    fi

    src="${SCRIPT_DIR}/$1"
    dst="${DEST_DIR}/$2"
    dst_parent="$(dirname -- "$dst")"
    
    if ! test -e "$src"; then
        error "the following source path does not exist:"
        error "$src"
        return
    fi
    
    if ! test -d "$dst_parent"; then
        echo "Creating $dst_parent"
        mkdir -p "$dst_parent"
    fi

    if test -s "$dst"; then
        if $IGNORE_EXISTING; then
            remove_symlink "$2"
        else
            error "path already exists:"
            error "$dst"
            return
        fi
    elif test -e "$dst"; then
        error "path already exists and is not a symlink:"
        error "${dst}: $(stat -c '%F' -- "$dst")"
        return
    fi
    
    echo "Creating link: $dst -> $src"
    ln -s "$src" "$dst"
}

create_all_symlinks() {
    for link in "${SYMLINKS[@]}"; do
        create_symlink "$link" "$link"
    done

    for src dst in ${(kv)SYMLINK_MAP}; do
        create_symlink "$src" "$dst"
    done
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
    remove_all_symlinks
else
    check_terminfo
    check_packages_installed
    create_all_symlinks
fi

if $ERROR; then
    exit 1
fi
