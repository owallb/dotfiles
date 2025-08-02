#!/usr/bin/env python3

import argparse
import platform
import shutil
import subprocess
import sys
from pathlib import Path


class InstallerError(BaseException): ...


class Installer:
    def __init__(self, profile: str) -> None:
        """Initialize a new installer."""
        self.script_file = Path(__file__).resolve()
        self.script_name = self.script_file.name
        self.script_dir = self.script_file.parent
        self.source_dir = self.script_dir
        self.dest_dir = Path.home()
        self.distro = platform.freedesktop_os_release().get("NAME", "Unknown")
        self.profile = profile
        self.has_error = False
        self.pkg_query = {"Arch Linux": self._pkg_query_arch}
        self.pkgs = {
            "Arch Linux base": [
                "alacritty",
                "tmux",
                "zsh",
                "vim",
                "unzip",
                "npm",
                "nvim",
                "firefox",
            ],
            "Arch Linux hyprland": [
                "libnewt",
                "hyprland",
                "uwsm",
                "fnott",
                "pipewire",
                "wireplumber",
                "hyprpolkitagent",
                "qt5-wayland",
                "qt6-wayland",
                "hyprlock",
                "hypridle",
                "xdg-desktop-portal-hyprland",
                "xdg-desktop-portal-gtk",
                "hyprland-qt-support",
                "waybar",
                "rofi",
                "wl-clipboard",
                "nautilus",
                "pasystray",
                "playerctl",
                "brightnessctl",
                "breeze",
                "pavucontrol",
                "otf-font-awesome",
            ],
        }
        self.symlinks = [
            ".config/alacritty",
            ".config/dolphinrc",
            ".config/dunst",
            ".config/fish",
            ".config/fnott",
            ".config/foot",
            ".config/frogminer",
            ".config/ghostty",
            ".config/hypr",
            ".config/i3",
            ".config/i3status",
            ".config/lf",
            ".config/kde-mimeapps.list",
            ".config/kdeglobals",
            ".config/kglobalshortcutsrc",
            ".config/klipperrc",
            ".config/kwinrc",
            ".config/picom",
            ".config/rofi",
            ".config/strawberry",
            ".config/tmux",
            ".config/uwsm",
            ".config/waybar",
            ".config/wezterm",
            ".config/xdg-desktop-portal",
            ".config/yay",
            ".config/zed",
            ".local/bin",
            ".local/share/fonts",
            ".local/share/konsole",
            ".local/share/kxmlgui5/dolphin/dolphinui.rc",
            ".vimrc",
            ".xinit-scripts",
            ".xinitrc",
            ".Xresources",
            ".zprofile",
        ]
        self.copies = [
            ".config/gtk-3.0",
            ".config/gtk-4.0",
            ".gtkrc-2.0",
        ]
        self.symlink_map = {"zsh/rc": ".zshrc"}
        self.gsettings = [
            ["org.gnome.desktop.interface", "color-scheme", "prefer-dark"]
        ]

    @staticmethod
    def _pkg_query_arch(package: str) -> bool:
        """
        Check if package is installed on Arch Linux using pacman.

        Returns:
            True if package is found, otherwise False.
        """
        result = subprocess.run(
            ["pacman", "-Qi", package],
            capture_output=True,
            text=True,
            check=False,
        )
        return result.returncode == 0

    def error(self, msg: str) -> None:
        """Print error message and set error flag."""
        self.has_error = True
        print(f"Error: {msg}", file=sys.stderr)

    def check_packages_installed(self) -> None:
        """Check if required packages are installed."""
        profile = f"{self.distro} {self.profile}"
        if profile not in self.pkgs:
            self.error(f"No package list defined for {profile}")
            return

        if self.distro not in self.pkg_query:
            self.error(f"No package query function for {self.distro}")
            return

        pkg_list: list[str] = []

        if self.profile != "base":
            base = f"{self.distro} base"
            if base in self.pkgs:
                pkg_list.extend(self.pkgs[base])

        pkg_list.extend(self.pkgs[profile])
        print("Package list:", pkg_list)
        query_func = self.pkg_query[self.distro]

        missing: list[str] = []
        for pkg in pkg_list:
            if not query_func(pkg):
                missing.append(pkg)

        if missing:
            self.error(f"missing {len(missing)} packages: {' '.join(missing)}")

    def remove_symlink(self, rel_path: str) -> None:
        """
        Remove a symlink.

        Raises:
            InstallerError: on error
        """
        link_path = self.dest_dir / rel_path
        if link_path.is_symlink():
            src = link_path.resolve()
            print(f"Removing symlink: {link_path} -> {src}")
            link_path.unlink()
        elif link_path.exists():
            raise InstallerError(
                f"object to be removed is not a symlink: {link_path}"
            )

    def remove_all_symlinks(self) -> None:
        """Remove all symlinks."""
        for link in self.symlinks:
            self.remove_symlink(link)

        for dst in self.symlink_map.values():
            self.remove_symlink(dst)

    def create_symlink(
        self,
        rel_src: str,
        rel_dst: str,
        force: bool = False,
        ignore: bool = False,
    ) -> None:
        """
        Create a symlink.

        Raises:
            InstallerError: on error
        """
        if not rel_src or not rel_dst:
            raise InstallerError(
                f"missing src or dst argument: src='{rel_src}', dst='{rel_dst}'"
            )

        src = self.script_dir / rel_src
        dst = self.dest_dir / rel_dst
        dst_parent = dst.parent

        if not src.exists():
            raise InstallerError(f"source path does not exist: {src}")

        # Create parent directory if needed
        if not dst_parent.exists():
            print(f"Creating parent: {dst_parent}")
            dst_parent.mkdir(parents=True, exist_ok=True)

        if dst.is_symlink():
            if ignore or dst.resolve() == src:
                return

            if force:
                self.remove_symlink(rel_dst)
            else:
                raise InstallerError(f"symbolic link already exists: {dst}")
        elif dst.exists():
            raise InstallerError(
                f"path already exists and is not a symlink: {dst}"
            )

        print(f"Creating link: {dst} -> {rel_src}")
        dst.symlink_to(src)

    @staticmethod
    def remove_path(target: Path) -> None:
        """Remove path using gio trash if available, otherwise rm."""
        print(f"Trashing item: {target}")
        subprocess.run(["gio", "trash", str(target)], check=True)

    def copy_item(
        self,
        rel_src: str,
        rel_dst: str,
        force: bool = False,
        ignore_existing: bool = False,
    ) -> None:
        """
        Copy an item.

        Raises:
            InstallerError: on error
        """
        if not rel_src or not rel_dst:
            raise InstallerError(
                f"missing src or dst argument: src='{rel_src}', dst='{rel_dst}'"
            )

        src = self.script_dir / rel_src
        dst = self.dest_dir / rel_dst
        dst_parent = dst.parent

        if not src.exists():
            raise InstallerError(f"source path does not exist: {src}")

        # Create parent directory if needed
        if not dst_parent.exists():
            print(f"Creating parent: {dst_parent}")
            dst_parent.mkdir(parents=True, exist_ok=True)

        if dst.exists():
            if force:
                self.remove_path(dst)
            elif ignore_existing:
                return
            else:
                raise InstallerError(f"path already exists: {dst}")

        print(f"Copying item: from {rel_src} to {dst_parent}/")
        if src.is_dir():
            shutil.copytree(src, dst)
        else:
            shutil.copy2(src, dst)

    def create_all_symlinks(
        self, force: bool = False, ignore_existing: bool = False
    ) -> None:
        """Create all symlinks."""
        for link in self.symlinks:
            self.create_symlink(link, link, force, ignore_existing)

        for src, dst in self.symlink_map.items():
            self.create_symlink(src, dst, force, ignore_existing)

    def copy_all_items(
        self, force: bool = False, ignore_existing: bool = False
    ) -> None:
        """Copy all items."""
        for item in self.copies:
            self.copy_item(item, item, force, ignore_existing)

    def check_terminfo(self) -> None:
        """Check if tmux-256color terminfo is available."""
        try:
            result = subprocess.run(
                ["infocmp", "tmux-256color"],
                capture_output=True,
                text=True,
                check=False,
            )
            if result.returncode != 0:
                self.error(
                    "Missing terminfo for tmux-256color. Try installing ncurses-term."
                )
        except FileNotFoundError:
            self.error("infocmp command not found")

    def set_gsettings(self) -> None:
        """Set gsettings."""
        for setting in self.gsettings:
            result = subprocess.run(
                ["gsettings", "set", *setting],
                capture_output=True,
                text=True,
                check=False,
            )
            if result.returncode != 0:
                self.error(f"Failed to set gsettings: {setting}")

    def run(
        self,
        force: bool = False,
        ignore: bool = False,
        remove: bool = False,
    ) -> None:
        """Run main run function."""
        if remove:
            self.remove_all_symlinks()
            return

        self.check_packages_installed()
        self.check_terminfo()
        self.create_all_symlinks(force, ignore)
        self.copy_all_items(force, ignore)
        self.set_gsettings()


def main() -> None:
    """Run installer."""
    parser = argparse.ArgumentParser(
        description="Linux dotfiles setup script",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "profile",
        nargs="?",
        default="hyprland",
        help="Profile to install (default: hyprland)",
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="Overwrite any existing links",
    )
    parser.add_argument(
        "-i",
        "--ignore",
        action="store_true",
        help="Ignore existing symlinks",
    )
    parser.add_argument(
        "-r",
        "--remove",
        action="store_true",
        help="Remove any existing symlinks",
    )

    args = parser.parse_args()

    installer = Installer(args.profile)
    try:
        installer.run(
            force=args.force,
            ignore=args.ignore,
            remove=args.remove,
        )
    except InstallerError as e:
        installer.error(str(e))

    if installer.has_error:
        sys.exit(1)


if __name__ == "__main__":
    main()
