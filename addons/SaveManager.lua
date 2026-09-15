--[[
    ==============================================================================
    🌸 VRS ARTELIER — SAVE MANAGER ADDON
    ==============================================================================
    Design: VRS Artelier Cyber-Dark, 100% Signature Neon Magenta Pink (#FF408C)
    Matches Obsidian/Linoria Addon Architecture.
    Handles configuration persistence (JSON saving/loading) to executor filesystem.
    ==============================================================================
]]

local cloneref = (cloneref or clonereference or function(i) return i end)
local HttpService = cloneref(game:GetService("HttpService"))

local SaveManager = {
    Library = nil,
    Folder = "VRSArtelier/configs",
    AutoSave = false,
    CurrentConfig = "default",
}

function SaveManager:SetLibrary(library)
    self.Library = library
end

function SaveManager:SetFolder(folder)
    self.Folder = folder
    if makefolder and isfolder and not isfolder(folder) then
        pcall(makefolder, folder)
    end
end

function SaveManager:GetConfigPath(name)
    return self.Folder .. "/" .. (name or self.CurrentConfig) .. ".json"
end

function SaveManager:Save(name)
    if not (writefile and isfolder) then return false end
    name = name or self.CurrentConfig
    self:SetFolder(self.Folder)

    local data = {}
    if self.Library and self.Library.Modules then
        for modId, mod in pairs(self.Library.Modules) do
            data[modId] = {
                Enabled = mod.Enabled or false,
                Values = mod.Values or {}
            }
        end
    end

    local json = HttpService:JSONEncode(data)
    local s, err = pcall(writefile, self:GetConfigPath(name), json)
    if s and self.Library then
        self.Library:Notify({
            Title = "Config Saved",
            Description = "Successfully saved configuration: " .. name,
            Duration = 2.5,
            Icon = "lucide-save"
        })
    end
    return s
end

function SaveManager:Load(name)
    if not (readfile and isfile) then return false end
    name = name or self.CurrentConfig
    local path = self:GetConfigPath(name)
    if not isfile(path) then return false end

    local s, content = pcall(readfile, path)
    if not s or not content then return false end

    local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok or typeof(data) ~= "table" then return false end

    if self.Library and self.Library.Modules then
        for modId, modData in pairs(data) do
            local mod = self.Library.Modules[modId]
            if mod then
                if mod.SetState and modData.Enabled ~= nil then
                    mod:SetState(modData.Enabled)
                end
                if mod.SetValues and modData.Values then
                    mod:SetValues(modData.Values)
                end
            end
        end
    end

    if self.Library then
        self.Library:Notify({
            Title = "Config Loaded",
            Description = "Loaded configuration: " .. name,
            Duration = 2.5,
            Icon = "lucide-file-check"
        })
    end
    return true
end

function SaveManager:BuildConfigSection(tab)
    if not tab then return end
    tab:AddSection("Configuration Manager")

    tab:AddDropdown({
        Name = "Select Config",
        Options = { "default", "legit", "rage", "custom" },
        Default = "default",
        Callback = function(v) self.CurrentConfig = v end
    })

    tab:AddButton({
        Name = "Save Config",
        Callback = function() self:Save() end
    })

    tab:AddButton({
        Name = "Load Config",
        Callback = function() self:Load() end
    })
end

return SaveManager
