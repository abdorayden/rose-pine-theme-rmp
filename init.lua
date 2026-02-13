local api = require("rmp.rmp")

-- ROSE-PINE THEME COLORS:
-- Rose Pine is a soho color scheme inspired by the beauty of the English shire
-- MAIN VARIANT (dark):
-- Title text: Rose Pine Foam (#f2ebe9) - Brights.White equivalent
-- Title background: Rose Pine Base (#191724) - NoBrights.Black
-- Border color: Rose Pine Text (#e0def4) - Brights.White
-- Background: Rose Pine Base (#191724) - NoBrights.Black
-- Primary content: Rose Pine Pine (#31748f) - NoBrights.Green
-- Secondary content: Rose Pine Water (#9ccfd8) - NoBrights.Blue
-- Accent elements: Rose Pine Love (#eb6f92) - NoBrights.Red
-- Highlight: Rose Pine Gold (#f6c177) - NoBrights.Yellow
-- Muted elements: Rose Pine Iris (#c4a7e7) - NoBrights.Magenta

-- MOON VARIANT (light):
-- Title text: Rose Pine Moon Text (#56526e) - NoBrights.Black
-- Title background: Rose Pine Moon Base (#232136) - Brights.White
-- Border color: Rose Pine Moon Muted (#6e6a86) - NoBrights.White
-- Background: Rose Pine Moon Base (#232136) - Brights.White
-- Primary content: Rose Pine Moon Pine (#56949f) - NoBrights.Green
-- Secondary content: Rose Pine Moon Water (#86e1a0) - NoBrights.Blue
-- Accent elements: Rose Pine Moon Love (#eb98a3) - NoBrights.Red
-- Highlight: Rose Pine Moon Gold (#f6d5a8) - NoBrights.Yellow
-- Muted elements: Rose Pine Moon Iris (#c8c0d8) - NoBrights.Magenta

-- DAWN VARIANT (light):
-- Title text: Rose Pine Dawn Text (#575279) - NoBrights.Black
-- Title background: Rose Pine Dawn Base (#faf4ed) - Brights.White
-- Border color: Rose Pine Dawn Muted (#9893a5) - NoBrights.White
-- Background: Rose Pine Dawn Base (#faf4ed) - Brights.White
-- Primary content: Rose Pine Dawn Pine (#286983) - NoBrights.Green
-- Secondary content: Rose Pine Dawn Water (#56949f) - NoBrights.Blue
-- Accent elements: Rose Pine Dawn Love (#d7827e) - NoBrights.Red
-- Highlight: Rose Pine Dawn Gold (#ea9d34) - NoBrights.Yellow
-- Muted elements: Rose Pine Dawn Iris (#907aa9) - NoBrights.Magenta

local VARIANT = "main"

local rose_pine = {
    main = {
        BackGround = "#191724",
        BorderColor = "#e0def4",
        TitleBackGround = "#191724",
        TitleText = "#f2ebe9",
        PrimaryContent = "#31748f",
        SecondaryContent = "#9ccfd8",
        AccentElements = "#eb6f92",
        Highlight = "#f6c177",
        MutedElements = "#c4a7e7"
    },
    moon = {
        BackGround = "#232136",
        BorderColor = "#6e6a86",
        TitleBackGround = "#232136",
        TitleText = "#56526e",
        PrimaryContent = "#56949f",
        SecondaryContent = "#86e1a0",
        AccentElements = "#eb98a3",
        Highlight = "#f6d5a8",
        MutedElements = "#c8c0d8"
    },
    dawn = {
        BackGround = "#faf4ed",
        BorderColor = "#9893a5",
        TitleBackGround = "#faf4ed",
        TitleText = "#575279",
        PrimaryContent = "#286983",
        SecondaryContent = "#56949f",
        AccentElements = "#d7827e",
        Highlight = "#ea9d34",
        MutedElements = "#907aa9"
    }
}

local function apply(tha_template)
    for _, component in ipairs(tha_template) do
        if component.title then
            if type(component.title) == "string" then
                local val = component.title
                component.title = {
                    value = val,
                    foregroundColor = api.colorFromHex(rose_pine[VARIANT].TitleText, api.FG),
                    backgroundColor = api.colorFromHex(rose_pine[VARIANT].TitleBackGround, api.BG),
                }
            elseif type(component.title) == "table" then
                component.title.foregroundColor = api.colorFromHex(rose_pine[VARIANT].TitleText, api.FG)
                component.title.backgroundColor = api.colorFromHex(rose_pine[VARIANT].TitleBackGround, api.BG)
            else
                ---- unreachable
                component.table = nil
            end
        end
        component.foregroundColor = api.colorFromHex(rose_pine[VARIANT].BorderColor, api.FG)
        component.backgroundColor = api.colorFromHex(rose_pine[VARIANT].BackGround, api.BG)
        if component.children then
            apply(component.children)
        end
    end
end

return function()
    local vt = api.VirtualTerminal.new(1, 1) -- sins i don't have to render shit

    -- getting the configurations
    vt:onConfiguration(function(cfg)
        if cfg then
            local conf = cfg:get("rose-pine-theme-rmp")
            if conf and conf.VARIANT then
                -- Maybe add more fields to configurations like choose specific window id to apply something
                -- main | moon | dawn
                VARIANT = conf.VARIANT
            end
        end
    end)

    -- local apply = nil
    -- vt:addEventListener(api.EventType.TransformDataGet, function(data)
    --     if data and data.themeUtil and data.themeUtil.applyTheme and type(data.themeUtil.applyTheme) == "function" then
    --         apply = data.themeUtil.applyTheme
    --     end
    -- end)
    --
    -- apply the theme on the template
    vt:onTemplate(function(template)
        if template then
            if apply then
                apply(template)
            end
        end
    end)

    -- share the current theme
    -- all plugins can get the theme and use it as their theme
    vt:addEventListener(api.EventType.TransformDataPut, function()
        return {
            theme = rose_pine[VARIANT]
        }
    end)

    return vt
end
