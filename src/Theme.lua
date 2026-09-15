--[[
    ==============================================================================
    🌸 VRS ARTELIER — THEME MODULE
    ==============================================================================
    Design: VRS Artelier Cyber-Dark, 100% Signature Neon Magenta Pink (#FF408C)
    Provides centralized color tokens, font definitions, and dynamic theme support.
    ==============================================================================
]]

local Theme = {
    Current = {
        Background      = Color3.fromRGB(13, 14, 19),   -- Cyber Dark (#0D0E13)
        Sidebar         = Color3.fromRGB(16, 17, 24),   -- Sidebar dark navy (#101118)
        Header          = Color3.fromRGB(13, 14, 19),
        Card            = Color3.fromRGB(20, 21, 30),   -- Module Card background (#14151E)
        CardHover       = Color3.fromRGB(28, 30, 44),
        CardStroke      = Color3.fromRGB(30, 32, 46),
        CardStrokeHover = Color3.fromRGB(255, 64, 140), -- VRS Signature Pink Stroke
        InputBackground = Color3.fromRGB(18, 19, 28),
        InputStroke     = Color3.fromRGB(34, 36, 52),
        Accent          = Color3.fromRGB(255, 64, 140), -- VRS Signature Neon Magenta Pink (#FF408C)
        AccentHover     = Color3.fromRGB(255, 96, 160),
        AccentGlow      = Color3.fromRGB(255, 64, 140),
        Outline         = Color3.fromRGB(28, 30, 44),
        TextPrimary     = Color3.fromRGB(242, 244, 252),
        TextMuted       = Color3.fromRGB(120, 125, 150),
        BadgeBackground = Color3.fromRGB(24, 25, 38),
        BadgeText       = Color3.fromRGB(165, 170, 195),
        SwitchOff       = Color3.fromRGB(34, 36, 50),
        SwitchOffKnob   = Color3.fromRGB(115, 120, 140),
        SwitchOnKnob    = Color3.fromRGB(255, 255, 255),
        ActionBtn       = Color3.fromRGB(46, 18, 34),   -- Dark pink tint button
        ActionBtnHover  = Color3.fromRGB(70, 26, 52),
        ActionBtnIcon   = Color3.fromRGB(255, 64, 140), -- Pink Action Icon
        ResizeGrip      = Color3.fromRGB(120, 125, 150),
    },

    Presets = {
        ["VRS Neon Pink"] = {
            Accent          = Color3.fromRGB(255, 64, 140),
            AccentHover     = Color3.fromRGB(255, 96, 160),
            CardStrokeHover = Color3.fromRGB(255, 64, 140),
        },
        ["Cyber Amethyst"] = {
            Accent          = Color3.fromRGB(180, 70, 255),
            AccentHover     = Color3.fromRGB(205, 115, 255),
            CardStrokeHover = Color3.fromRGB(180, 70, 255),
        },
        ["VRS Rose"] = {
            Accent          = Color3.fromRGB(255, 45, 110),
            AccentHover     = Color3.fromRGB(255, 80, 140),
            CardStrokeHover = Color3.fromRGB(255, 45, 110),
        }
    }
}

function Theme:Get(key)
    return self.Current[key]
end

function Theme:SetAccent(color)
    self.Current.Accent = color
    self.Current.AccentHover = Color3.fromHSV(
        select(1, Color3.toHSV(color)),
        math.clamp(select(2, Color3.toHSV(color)) - 0.1, 0, 1),
        math.clamp(select(3, Color3.toHSV(color)) + 0.15, 0, 1)
    )
    self.Current.CardStrokeHover = color
    self.Current.ActionBtnIcon = color
end

return Theme
