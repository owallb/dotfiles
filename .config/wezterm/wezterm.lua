local wezterm = require("wezterm")

local config = wezterm.config_builder()

local ENABLE_MULTIPLEXING = false

-- quickstart: https://wezfurlong.org/wezterm/config/files.html
-- spec: https://wezfurlong.org/wezterm/config/lua/general.html

-- General settings

config.window_padding = {
    left = 6,
    right = 6,
    top = 6,
    bottom = 6,
}
config.audible_bell = "Disabled"
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

config.color_scheme = "moonfly"

-- Fonts

local fonts = require("fonts")

config.font = fonts.regular
config.font_size = 11
config.font_rules = {
    fonts.rules.italic,
    fonts.rules.bold,
    fonts.rules.bolditalic,
}
config.harfbuzz_features = { 'calt=0' }

-- Keybinding

local bindings = require("bindings")

if ENABLE_MULTIPLEXING then
    config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
    config.enable_tab_bar = true
    config.enable_scroll_bar = true
    config.use_fancy_tab_bar = false
    config.show_new_tab_button_in_tab_bar = false
    config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
    bindings.enable_multiplexing()
end

config.disable_default_key_bindings = true
config.keys = bindings.keys
config.key_tables = bindings.key_tables
config.disable_default_mouse_bindings = true
config.mouse_bindings = bindings.mouse_bindings

require("events").setup()

return config
