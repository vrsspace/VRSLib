--[[
    ==============================================================================
    🌸 VRSLib V2 SHOWCASE — 1:1 RECREATION OF TARGET SCREENSHOT
    ==============================================================================
    Execute this script in your favorite executor or test environment.
    Features signature Matte Obsidian (#0F1015) + Neon Pink (#FF408C) theme!
    ==============================================================================
]]

-- Anti-multi execution
if _G.VRSV2_UNLOAD then pcall(_G.VRSV2_UNLOAD) end

-- 1. Load VRSLibV2 (Local file fallback for instant execution + Raw GitHub fallback)
local VRSLibV2
pcall(function()
    if readfile then
        local localCode = readfile("VRSLibV2.lua")
        if localCode and #localCode > 0 then
            VRSLibV2 = loadstring(localCode)()
        end
    end
end)
if not VRSLibV2 then
    pcall(function()
        local raw = game:HttpGet("https://raw.githubusercontent.com/vrsspace/VRSLib/main/VRSLibV2.lua?v=" .. tick())
        VRSLibV2 = loadstring(raw)()
    end)
end
if not VRSLibV2 then
    error("[VRSLibV2] Unable to load VRSLibV2 engine.")
end

-- 2. Create Window
local Window = VRSLibV2:CreateWindow({
    Title    = "auto", -- Otomatis menjadi "Welcome to <GameName>!"
    SubTitle = "v0.141",
    Size     = UDim2.fromOffset(1020, 620),
    Accent   = Color3.fromRGB(255, 64, 140), -- VRS Signature Neon Pink (#FF408C)
    Keybind  = Enum.KeyCode.RightControl
})

Window.OnUnload = function()
    _G.VRSV2_ACTIVE = false
    print("[VRSLibV2] Unloaded successfully.")
end
_G.VRSV2_UNLOAD = Window.OnUnload
_G.VRSV2_ACTIVE = true

-- ==============================================================================
-- 3. SIDEBAR TABS (Matching Screenshot 1 & 2)
-- ==============================================================================
local TabHome     = Window:AddTab({ Name = "Home",     Icon = "home",     LayoutOrder = 1 })
local TabClan     = Window:AddTab({ Name = "Clan",     Icon = "users",    LayoutOrder = 2 })
local TabFarm     = Window:AddTab({ Name = "Farm",     Icon = "swords",   LayoutOrder = 3 })
local TabSettings = Window:AddTab({ Name = "Settings", Icon = "settings", LayoutOrder = 4 })

-- ==============================================================================
-- 4. HOME TAB (Screenshot 1: 100% Identical Recreation)
-- ==============================================================================

-- Horizontal Sub-Nav Pills in Topbar
local SubOverview = TabHome:AddSubTab({ Name = "Overview", Icon = "grid" })
local SubMainMenu = TabHome:AddSubTab({ Name = "Main Menu", Icon = "play" })

-- 1. User Banner Card (Avatar headshot, greetings, streamer mode)
SubOverview:AddUserCard({
    Greeting    = "Welcome back,",
    DisplayName = game:GetService("Players").LocalPlayer.DisplayName,
    Username    = game:GetService("Players").LocalPlayer.Name,
    Version     = "v0.141",
    LayoutOrder = 1
})

-- 2. 6-Box Stat Grid (Live Players, Friends, Execs, Session, FPS, Ping)
SubOverview:AddStatGrid({
    LayoutOrder = 2
})

-- 3. Game Info Card & Server Action Buttons
SubOverview:AddGameCard({
    GameName    = Window.GameName,
    Creator     = "Ouw Productions",
    LayoutOrder = 3
})

-- 4. Unsupported Place / Status Warning Banner
SubOverview:AddBanner({
    Title       = "Madium",
    Description = "Not on the supported list. Some features may not work.",
    Icon        = "shield",
    Color       = Color3.fromRGB(255, 175, 60),
    Badge       = "RCtrl to hide",
    LayoutOrder = 4
})

-- 5. Two-Column Quick Links (Discord Community & Supported Games)
SubOverview:AddLinksRow({
    Left = {
        Title       = "Join the community",
        Subtitle    = "https://discord.gg/synapsex",
        ButtonText  = "Copy Invite",
        Icon        = "message-square",
        Url         = "https://discord.gg/synapsex"
    },
    Right = {
        Title       = "Supported games",
        Subtitle    = "https://ouroboros-hub-rbx.web.app/",
        ButtonText  = "Copy Website",
        Icon        = "monitor",
        Url         = "https://ouroboros-hub-rbx.web.app/"
    },
    LayoutOrder = 5
})

-- 6. Feature List Summary Card
SubOverview:AddFeatureList({
    Title       = "Feature list",
    Subtitle    = "7 features across 2 tabs",
    ButtonText  = "View Features",
    Icon        = "list",
    Callback    = function()
        Window:Notify({
            Title = "Features",
            Description = "Showing active features for " .. Window.GameName,
            Duration = 3,
            Icon = "list"
        })
    end,
    LayoutOrder = 6
})

-- SubMainMenu content
local mmLeft, mmRight = SubMainMenu:AddColumns()
local mmGeneral = mmLeft:AddGroupbox({ Title = "Quick Actions", Icon = "zap" })
mmGeneral:AddButton({
    Name = "Re-Execute Hub",
    Icon = "refresh-cw",
    Callback = function()
        Window:Notify({ Title = "System", Description = "Reloading VRS Artelier V2...", Duration = 2.5 })
    end
})
mmGeneral:AddButton({
    Name = "Unload Hub",
    Icon = "close",
    Callback = function()
        Window:Unload()
    end
})

-- ==============================================================================
-- 5. FARM TAB (Dual-Column Sections with Toggles, Sliders, Dropdowns)
-- ==============================================================================
local SubQuests = TabFarm:AddSubTab({ Name = "Quests & Mobs", Icon = "swords" })
local SubBosses = TabFarm:AddSubTab({ Name = "Bosses", Icon = "shield" })

local farmLeft, farmRight = SubQuests:AddColumns()

-- Left Column: Leveling & Auto Farm
local boxLeveling = farmLeft:AddGroupbox({ Title = "Auto Leveling", Icon = "swords" })
boxLeveling:AddToggle({
    Name = "Auto Quest Farm",
    Default = false,
    Callback = function(val)
        print("Auto Quest:", val)
    end
})
boxLeveling:AddToggle({
    Name = "Auto Mob Aura",
    Default = false,
    Callback = function(val)
        print("Auto Mob Aura:", val)
    end
})
boxLeveling:AddDropdown({
    Name = "Target Mob",
    Options = { "Low Level Bandit", "Forest Demon", "Elite Slayer", "Shadow Assassin" },
    Default = "Low Level Bandit",
    Callback = function(selected)
        print("Target Mob selected:", selected)
    end
})
boxLeveling:AddSlider({
    Name = "Attack Distance",
    Min = 2,
    Max = 30,
    Default = 12,
    Suffix = " studs",
    Callback = function(val)
        print("Attack Distance:", val)
    end
})

-- Right Column: Pickups & Modifiers
local boxPickups = farmRight:AddGroupbox({ Title = "Pickups & Gourds", Icon = "folder" })
boxPickups:AddToggle({
    Name = "Auto Collect Chests",
    Default = true,
    Callback = function(val)
        print("Auto Collect:", val)
    end
})
boxPickups:AddDropdown({
    Name = "Filter Rarities",
    Options = { "Common", "Rare", "Epic", "Legendary", "Mythic" },
    Default = { ["Legendary"] = true, ["Mythic"] = true },
    Multi = true,
    Callback = function(tableVal)
        print("Selected rarities updated.")
    end
})
boxPickups:AddSlider({
    Name = "Collect Speed",
    Min = 1,
    Max = 5,
    Default = 2,
    Suffix = "x",
    Callback = function(val)
        print("Collect Speed:", val)
    end
})

-- ==============================================================================
-- 6. SETTINGS TAB
-- ==============================================================================
local setLeft, setRight = TabSettings:AddColumns()

local boxSettings = setLeft:AddGroupbox({ Title = "Hub Configuration", Icon = "settings" })
boxSettings:AddToggle({
    Name = "Show Floating Logo When Hidden",
    Default = true,
    Callback = function(val)
        print("Floating logo:", val)
    end
})
boxSettings:AddButton({
    Name = "Test Notification",
    Icon = "bell",
    Callback = function()
        Window:Notify({
            Title = "Notification Test",
            Description = "VRSLib V2 Obsidian & Neon Pink is running flawlessly!",
            Duration = 3,
            Icon = "Wings"
        })
    end
})

-- Initial Notification
VRSLibV2:Notify({
    Title = "VRS Artelier V2",
    Description = "Loaded successfully with Obsidian & Neon Pink aesthetic!",
    Duration = 3.5,
    Icon = "Wings"
})
