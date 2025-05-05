local my_colors = {
    foreground = "#b2b2b2",
    background = "#000000",
    cursor_fg = "#000000",
    cursor_bg = "#b2b2b2",
    cursor_border = "#b2b2b2",
    selection_fg = "#000000",
    selection_bg = "#b2b2b2",
    scrollbar_thumb = "#000000",
    split = "#000000",
    ansi = {
        "#2e3436", -- black
        "#cc5555", -- red
        "#4e9a06", -- green
        "#c4a000", -- yellow
        "#6465a4", -- blue
        "#75507b", -- magenta
        "#06989a", -- cyan
        "#b2b2b2", -- white
    },
    brights = {
        "#555753", -- black
        "#ff5555", -- red
        "#8ae234", -- green
        "#fce94f", -- yellow
        "#739fcf", -- blue
        "#ad7fa8", -- magenta
        "#34e2e2", -- cyan
        "#d3d7cf", -- white
    },
    compose_cursor = "orange",
    tab_bar = {
        -- The color of the strip that goes along the top of the window
        -- (does not apply when fancy tab bar is in use)
        background = "#000000",

        -- The active tab is the one that has focus in the window
        active_tab = {
            -- The color of the background area for the tab
            bg_color = "#000000",
            -- The color of the text for the tab
            fg_color = "#c0c0c0",
        },

        -- Inactive tabs are the tabs that do not have focus
        inactive_tab = {
            bg_color = "#000000",
            fg_color = "#808080",
        },

        -- You can configure some alternate styling when the mouse pointer
        -- moves over inactive tabs
        inactive_tab_hover = {
            bg_color = "#000000",
            fg_color = "#c0c0c0",

            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `inactive_tab_hover`.
        },

        -- The new tab button that let you create new tabs
        new_tab = {
            bg_color = "#000000",
            fg_color = "#808080",
        },

        new_tab_hover = {
            bg_color = "#000000",
            fg_color = "#c0c0c0",
        },
    },
}

return my_colors
