local wezterm = require("wezterm")

local M = {}

function M.setup()
    wezterm.on(
        'format-tab-title',
        function(tab, _, _, _, _, _)
            local title = tab.tab_title
            if not title or #title <= 0 then
                title = tab.active_pane.title
            end
            title = " " .. tab.tab_index + 1 .. ": " .. title
            if tab.is_active then
                title = title .. "*"
            else
                title = title .. " "
            end
            return {
                { Text = title },
            }
        end
    )
end

return M
