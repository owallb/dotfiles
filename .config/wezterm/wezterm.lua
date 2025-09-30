local wezterm = require("wezterm")

local config = wezterm.config_builder()

local ENABLE_MULTIPLEXING = false

-- quickstart: https://wezfurlong.org/wezterm/config/files.html
-- spec: https://wezfurlong.org/wezterm/config/lua/general.html

-- General settings

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.audible_bell = "Disabled"
config.warn_about_missing_glyphs = false

-- Settings below get overriden if multiplexing is enabled
config.window_decorations = "TITLE|RESIZE"
config.enable_tab_bar = false
config.enable_scroll_bar = false
config.check_for_updates = false

if string.find(wezterm.target_triple, "windows") then
    -- config.default_prog = { "wsl", "--cd", "~" }
    config.default_prog = { "pwsh" }
else
    config.default_prog = { "zsh" }
end

-- Colors

config.color_scheme = "onedark"

-- Fonts

local fonts = require("fonts")

config.font = fonts.regular
config.font_size = 12
config.font_rules = {
    fonts.rules.italic,
    fonts.rules.bold,
    fonts.rules.bolditalic,
}
config.harfbuzz_features = { "calt=0" }

-- Keybinding

local bindings = require("bindings")

if ENABLE_MULTIPLEXING then
    config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
    config.enable_tab_bar = true
    config.enable_scroll_bar = true
    config.use_fancy_tab_bar = true
    config.show_new_tab_button_in_tab_bar = false
    config.leader = { key = "z", mods = "CTRL", timeout_milliseconds = 1000 }

    config.window_frame = {
        -- active_titlebar_bg = "#181b20",
        -- inactive_titlebar_bg = "#323641",
    }

    config.colors = {
        tab_bar = {
            inactive_tab_edge = "#282c34",
            active_tab = {
                bg_color = "#1f2329",
                fg_color = "#a0a8b7",
            },
            inactive_tab = {
                bg_color = "#282c34",
                fg_color = "#a0a8b7",
            },
            inactive_tab_hover = {
                bg_color = "#282c34",
                fg_color = "#a0a8b7",
            },
        },
    }

    bindings.enable_multiplexing()
end

config.disable_default_key_bindings = true
config.keys = bindings.keys
config.key_tables = bindings.key_tables
config.disable_default_mouse_bindings = true
config.mouse_bindings = bindings.mouse_bindings

require("events").setup()

return config
