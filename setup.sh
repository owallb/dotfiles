#!/usr/bin/env zsh

set -e

DISTRO="$(sed -n 's/^NAME="\([^"]\+\)"/\1/p' /etc/os-release)"

SCRIPT_FILE="$(readlink -f -- "$0")"
SCRIPT_NAME="$(basename -- "$SCRIPT_FILE")"
SCRIPT_DIR="$(dirname -- "$SCRIPT_FILE")"

SOURCE_DIR="$SCRIPT_DIR"
DEST_DIR="$HOME"

PRINT_HELP=false
FORCE=false
REMOVE_EXISTING=false
IGNORE_EXISTING=false
ERROR=false

# Define packages
typeset -a PKGS
PKGS=(
    "alacritty"
    "dunst"
    "fish"
    "i3"
    "i3lock"
    "i3status"
    "jq"
    "lf"
    "picom"
    "rofi"
    "startx"
    "tmux"
    "zsh"
)

# Define paths to symlink
typeset -a SYMLINKS
SYMLINKS=(
    ".config/alacritty"
    ".config/dolphinrc"
    ".config/dunst"
    ".config/fish"
    ".config/foot"
    ".config/frogminer"
    ".config/i3"
    ".config/i3status"
    ".config/lf"
    ".config/kde-mimeapps.list"
    ".config/kglobalshortcutsrc"
    ".config/picom"
    ".config/rofi"
    ".config/tmux"
    ".config/wezterm"
    ".config/yay"
    ".local/bin"
    ".local/share/fonts"
    ".local/share/konsole"
    ".vimrc"
    ".xinit-scripts"
    ".xinitrc"
    ".Xresources"
)

typeset -a COPIES
COPIES=(
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".gtkrc-2.0"
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

        return 1
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
    local rel_src rel_dst src dst dst_parent

    rel_src="$1"
    rel_dst="$2"

    if test -z "$rel_src"; then
        error "missing src argument:"
        error "$0 $@"
        return 1
    fi

    if test -z "$rel_dst"; then
        error "missing dst argument:"
        error "$0 $@"
        return 1
    fi

    src="${SCRIPT_DIR}/$rel_src"
    dst="${DEST_DIR}/$rel_dst"
    dst_parent="$(dirname -- "$dst")"
    
    if ! test -e "$src"; then
        error "the following source path does not exist:"
        error "$src"
        return 1
    fi
    
    if ! test -d "$dst_parent"; then
        echo "Creating parent: $dst_parent"
        mkdir -p "$dst_parent"
    fi

    if test -L "$dst"; then
        if $FORCE; then
            if test "$(readlink -f "$dst")" != "$src"; then
                remove_symlink "$2"
            else
                return 0
            fi
        elif $IGNORE_EXISTING; then
            return 0
        else
            error "symbolic link already exists:"
            error "$dst"
            return 1
        fi
    elif test -e "$dst"; then
        error "path already exists that is not a symlink:"
        error "${dst}: $(stat -c '%F' -- "$dst")"
        return 1
    fi

    echo "Creating link: $dst -> $rel_src"
    ln -s "$src" "$dst"
}

remove_path() {
    local target
    target="$1"

    echo "Trashing item: $target"
    gio trash "$target"
}

copy_item() {
    local rel_src rel_dst src dst dst_parent

    rel_src="$1"
    rel_dst="$2"

    if test -z "$rel_src"; then
        error "missing src argument:"
        error "$0 $@"
        return 1
    fi

    if test -z "$rel_dst"; then
        error "missing dst argument:"
        error "$0 $@"
        return 1
    fi

    src="${SCRIPT_DIR}/$rel_src"
    dst="${DEST_DIR}/$rel_dst"
    dst_parent="$(dirname -- "$dst")"
    
    if ! test -e "$src"; then
        error "the following source path does not exist:"
        error "$src"
        return 1
    fi
    
    if ! test -d "$dst_parent"; then
        echo "Creating parent: $dst_parent"
        mkdir -p "$dst_parent"
    fi

    if test -e "$dst"; then
        if $FORCE; then
            remove_path "$dst"
        elif $IGNORE_EXISTING; then
            return 0
        else
            error "path already exists:"
            error "${dst}"
            return 1
        fi
    fi

    echo "Copying item: from $rel_src to ${dst_parent}/"
    cp -r "$src" "${dst_parent}/"
}

create_all_symlinks() {
    for link in "${SYMLINKS[@]}"; do
        create_symlink "$link" "$link"
    done

    for src dst in ${(kv)SYMLINK_MAP}; do
        create_symlink "$src" "$dst"
    done
}

copy_all_items() {
    for item in "${COPIES[@]}"; do
        copy_item "$item" "$item"
    done
}

check_terminfo() {
    if ! infocmp tmux-256color > /dev/null; then
        error "Missing terminfo for tmux-256color. Try installing ncurses-term."
        return 1
    fi
}


print_help() {
    echo "Usage: $SCRIPT_NAME [...]"
    echo ""
    echo "Options:"
    echo "    -h, --help                Print this help message"
    echo "    -f, --force               Overwrite any existing links"
    echo "    -i, --ignore-existing     Ignore existing symlinks"
    echo "    -r, --remove-existing     Remove any existing symlinks"
}

while [ $# -gt 0 ]; do
    case $1 in
        -h|--help)
            PRINT_HELP=true
            shift
            ;;
        -f|--force)
            FORCE=true
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
    copy_all_items
fi

if $ERROR; then
    exit 1
fi
