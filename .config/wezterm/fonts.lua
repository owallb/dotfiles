local wezterm = require("wezterm")

local fonts = {}

local family = "Iosevka Custom"

fonts.regular = wezterm.font({
    family = family,
    weight = "Regular",
    stretch = "Normal",
    style = "Normal"
})
fonts.italic = wezterm.font({
    family = family,
    weight = "Regular",
    stretch = "Normal",
    style = "Italic"
})
fonts.bold = wezterm.font({
    family = family,
    weight = "Bold",
    stretch = "Normal",
    style = "Normal"
})
fonts.bolditalic = wezterm.font({
    family = family,
    weight = "Bold",
    stretch = "Normal",
    style = "Italic"
})

fonts.rules = {
    italic = {
        intensity = "Normal",
        italic = true,
        font = fonts.italic
    },
    bold = {
        intensity = "Bold",
        italic = false,
        font = fonts.bold
    },
    bolditalic = {
        intensity = "Bold",
        italic = true,
        font = fonts.bolditalic
    },
}


return fonts
