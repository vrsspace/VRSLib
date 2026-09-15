--[[
    ==============================================================================
    🌸 VRS ARTELIER — THEME MANAGER ADDON
    ==============================================================================
    Design: VRS Artelier Cyber-Dark, 100% Signature Neon Magenta Pink (#FF408C)
    Matches Obsidian/Linoria Addon Architecture.
    Allows runtime accent customization, theme preset switching, and auto-apply.
    ==============================================================================
]]

local cloneref = (cloneref or clonereference or function(i) return i end)
local HttpService = cloneref(game:GetService("HttpService"))

local ThemeManager = {
    Library = nil,
    Folder = "VRSArtelier/themes",
    CurrentTheme = "VRS Neon Pink",
    CustomThemes = {}
}

function ThemeManager:SetLibrary(library)
    self.Library = library
end

function ThemeManager:SetFolder(folder)
    self.Folder = folder
    if makefolder and not isfolder(folder) then
        pcall(makefolder, folder)
    end
end

function ThemeManager:ApplyTheme(themeName)
    if not self.Library then return end
    local themeMod = self.Library.Theme
    if not themeMod then return end

    if themeMod.Presets and themeMod.Presets[themeName] then
        local preset = themeMod.Presets[themeName]
        if preset.Accent then
            themeMod:SetAccent(preset.Accent)
            self.CurrentTheme = themeName
            self.Library:Notify({
                Title = "Theme Applied",
                Description = "Switched theme to " .. themeName,
                Duration = 2,
                Icon = "lucide-palette"
            })
        end
    end
end

function ThemeManager:SetCustomAccent(color)
    if not self.Library then return end
    local themeMod = self.Library.Theme
    if themeMod and themeMod.SetAccent then
        themeMod:SetAccent(color)
    end
end

function ThemeManager:ApplyToTab(tab)
    if not tab then return end
    
    tab:AddSection("Theme & Accents")
    
    tab:AddDropdown({
        Name = "Theme Preset",
        Options = { "VRS Neon Pink", "Cyber Amethyst", "VRS Rose" },
        Default = "VRS Neon Pink",
        Callback = function(selected)
            self:ApplyTheme(selected)
        end
    })
end

return ThemeManager
