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
        Background      = Color3.fromRGB(15, 16, 20),   -- Modern Matte Obsidian (#0F1014)
        Sidebar         = Color3.fromRGB(12, 13, 16),   -- Deep Navy Obsidian (#0C0D10)
        Header          = Color3.fromRGB(15, 16, 20),
        Card            = Color3.fromRGB(21, 22, 28),   -- Sleek Card background (#15161C)
        CardHover       = Color3.fromRGB(28, 30, 40),
        CardStroke      = Color3.fromRGB(32, 34, 44),   -- Subtle dark border
        CardStrokeHover = Color3.fromRGB(255, 64, 140), -- VRS Signature Pink Stroke
        InputBackground = Color3.fromRGB(16, 17, 22),   -- Inner input background
        InputStroke     = Color3.fromRGB(34, 36, 48),
        Accent          = Color3.fromRGB(255, 64, 140), -- VRS Signature Neon Magenta Pink (#FF408C)
        AccentHover     = Color3.fromRGB(255, 96, 160),
        AccentGlow      = Color3.fromRGB(255, 64, 140),
        Outline         = Color3.fromRGB(28, 30, 38),
        TextPrimary     = Color3.fromRGB(255, 255, 255),
        TextMuted       = Color3.fromRGB(140, 145, 165),
        BadgeBackground = Color3.fromRGB(32, 20, 30),
        BadgeText       = Color3.fromRGB(255, 140, 190),
        SwitchOff       = Color3.fromRGB(36, 38, 48),
        SwitchOffKnob   = Color3.fromRGB(130, 135, 150),
        SwitchOnKnob    = Color3.fromRGB(255, 255, 255),
        ActionBtn       = Color3.fromRGB(28, 30, 38),   -- Action button background
        ActionBtnHover  = Color3.fromRGB(38, 40, 52),
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
        },
        ["Sakura Pink"] = {
            Accent          = Color3.fromRGB(255, 105, 180),
            AccentHover     = Color3.fromRGB(255, 140, 200),
            CardStrokeHover = Color3.fromRGB(255, 105, 180),
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
