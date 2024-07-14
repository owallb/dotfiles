local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

M.keys = {
    { key = 'Enter', mods = 'ALT',        action = act.ToggleFullScreen },
    { key = '=',     mods = 'CTRL',       action = act.IncreaseFontSize },
    { key = '-',     mods = 'CTRL',       action = act.DecreaseFontSize },
    { key = '0',     mods = 'CTRL',       action = act.ResetFontSize },
    { key = 'C',     mods = 'SHIFT|CTRL', action = act.CopyTo("Clipboard") },
    { key = 'V',     mods = 'SHIFT|CTRL', action = act.PasteFrom("Clipboard") },
    { key = 'P',     mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
    { key = 'R',     mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
    { key = 'F12',   mods = 'NONE',       action = act.ShowDebugOverlay },
}

M.mouse_bindings = {
    -- Open links
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.OpenLinkAtMouseCursor,
    },

    -- Select text
    {
        event = { Down = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.SelectTextAtMouseCursor("Cell"),
    },
    {
        event = { Drag = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.ExtendSelectionToMouseCursor("Cell"),
    },
    {
        event = { Down = { streak = 1, button = 'Left' } },
        mods = 'CTRL|SHIFT',
        action = act.ExtendSelectionToMouseCursor("Cell"),
    },

    -- Select text in block mode
    {
        event = { Down = { streak = 1, button = 'Left' } },
        mods = 'CTRL|ALT',
        action = act.SelectTextAtMouseCursor("Block"),
    },
    {
        event = { Drag = { streak = 1, button = 'Left' } },
        mods = 'CTRL|ALT',
        action = act.ExtendSelectionToMouseCursor("Block"),
    },
    {
        event = { Down = { streak = 1, button = 'Left' } },
        mods = 'CTRL|ALT|SHIFT',
        action = act.ExtendSelectionToMouseCursor("Block"),
    },
}

M.key_tables = wezterm.gui.default_key_tables()

-- table.insert(M.key_tables.copy_mode, {
--     key = 'y',
--     mods = 'NONE',
--     action = act.Multiple({
--         act.CopyTo("Clipboard"),
--         act.CopyMode("ClearSelectionMode"),
--     })
-- })

function M.enable_multiplexing()
    table.insert(M.keys, { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") })
    table.insert(M.keys, { key = '%', mods = "LEADER|SHIFT", action = act.SplitPane({ direction = "Down" }) })
    table.insert(M.keys, { key = '"', mods = "LEADER|SHIFT", action = act.SplitPane({ direction = "Right" }) })
    table.insert(M.keys, { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) })
    table.insert(M.keys, { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) })
    table.insert(M.keys, { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) })
    table.insert(M.keys, { key = "h", mods = "LEADER", action = act.ActivatePaneDirection('Left') })
    table.insert(M.keys, { key = "l", mods = "LEADER", action = act.ActivatePaneDirection('Right') })
    table.insert(M.keys, { key = "k", mods = "LEADER", action = act.ActivatePaneDirection('Up') })
    table.insert(M.keys, { key = "j", mods = "LEADER", action = act.ActivatePaneDirection('Down') })
    table.insert(M.keys, { key = "[", mods = "LEADER", action = act.ActivateCopyMode })
    table.insert(M.keys, { key = '?', mods = 'LEADER|SHIFT', action = act.Search("CurrentSelectionOrEmptyString") })

    for i = 1, 9 do
        table.insert(M.keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) })
    end

    table.insert(M.mouse_bindings, {
        event = { Down = { streak = 1, button = { WheelUp = 1 } } },
        mods = 'NONE',
        action = act.ScrollByLine(-3)
    })
    table.insert(M.mouse_bindings, {
        event = { Down = { streak = 1, button = { WheelDown = 1 } } },
        mods = 'NONE',
        action = act.ScrollByLine(3)
    })
    table.insert(M.mouse_bindings, {
        event = { Down = { streak = 1, button = { WheelUp = 1 } } },
        mods = 'ALT',
        action = act.ScrollByPage(-1)
    })
    table.insert(M.mouse_bindings, {
        event = { Down = { streak = 1, button = { WheelDown = 1 } } },
        mods = 'ALT',
        action = act.ScrollByPage(1)
    })
end

return M
