--[[
    ==============================================================================
    🌸 VRSLib V2 SHOWCASE — 1:1 RECREATION OF TARGET SCREENSHOT
    ==============================================================================
    Execute this script in your executor.
    Features signature Liquid Frosted Glass + Matte Obsidian (#0F1015) + Neon Pink!
    ==============================================================================
]]

-- Anti-multi execution & clean ghost windows
if _G.VRSV2_UNLOAD then pcall(_G.VRSV2_UNLOAD) end
if _G.VRS_UNLOAD then pcall(_G.VRS_UNLOAD) end
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local targets = {}
    if gethui then table.insert(targets, gethui()) end
    if CoreGui then table.insert(targets, CoreGui) end
    if lp and lp:FindFirstChild("PlayerGui") then table.insert(targets, lp.PlayerGui) end
    for _, container in ipairs(targets) do
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("ScreenGui") then
                local nm = child.Name:lower()
                if nm:find("vrs") or nm:find("artelier") then
                    child:Destroy()
                end
            end
        end
    end
end)


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
    Title    = "auto", -- Otomatis menjadi "Welcome to <GameName>!" (e.g. Welcome to Slayer 2!)
    SubTitle = "v0.141",
    Size     = UDim2.fromOffset(1020, 620),
    Accent   = Color3.fromRGB(255, 64, 140), -- VRS Signature Neon Pink (#FF408C)
    Keybind  = Enum.KeyCode.RightControl,
    Logo     = "wings"
})

Window.OnUnload = function()
    _G.VRSV2_ACTIVE = false
    print("[VRSLibV2] Unloaded successfully.")
end
_G.VRSV2_UNLOAD = Window.OnUnload
_G.VRSV2_ACTIVE = true

-- ==============================================================================
-- 3. SIDEBAR NAVIGATION TABS (1:1 Matching Screenshot)
-- ==============================================================================
local TabHome     = Window:AddTab({ Name = "Home",     Icon = "home",     LayoutOrder = 1 })
local TabClan     = Window:AddTab({ Name = "Clan",     Icon = "shield",   LayoutOrder = 2 })
local TabSettings = Window:AddTab({ Name = "Settings", Icon = "settings", LayoutOrder = 3 })

-- ==============================================================================
-- 4. HOME TAB (Screenshot 1: 100% Identical Recreation)
-- ==============================================================================

-- Horizontal Sub-Nav Pills in Topbar (Overview is first and active, Main Menu is second)
local SubOverview = TabHome:AddSubTab({ Name = "Overview",  Icon = "grid", LayoutOrder = 1 })
local SubMainMenu = TabHome:AddSubTab({ Name = "Main Menu", Icon = "play", LayoutOrder = 2 })

-- 1. User Banner Card (Avatar headshot, greetings, display name, handle, streamer mode)
SubOverview:AddUserCard({
    Greeting    = "Welcome back,",
    DisplayName = game:GetService("Players").LocalPlayer.DisplayName,
    Username    = game:GetService("Players").LocalPlayer.Name,
    Version     = "v0.141",
    LayoutOrder = 1
})

-- 2. 6-Box Stat Grid (Strict Order: Players, Friends, Execs, Session, FPS, Ping)
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
    Icon        = "shield-alert",
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
    Icon        = "list-checks",
    Callback    = function()
        Window:Notify({
            Title = "Features",
            Description = "Showing 7 active features for " .. Window.GameName,
            Duration = 3,
            Icon = "list"
        })
    end,
    LayoutOrder = 6
})

-- SubMainMenu content (Quick Actions)
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
-- 5. CLAN TAB (Dual-Column Sections with Toggles, Sliders, Dropdowns)
-- ==============================================================================
local clanLeft, clanRight = TabClan:AddColumns()

local boxReroll = clanLeft:AddGroupbox({ Title = "Clan Spin & Reroll", Icon = "swords" })
boxReroll:AddToggle({
    Name = "Auto Spin Rare Clan",
    Default = false,
    Callback = function(val)
        print("Auto Spin:", val)
    end
})
boxReroll:AddDropdown({
    Name = "Target Clans",
    Options = { "Kamado", "Tsugikuni", "Rengoku", "Tomioka", "Hashibira", "Agatsuma" },
    Default = { ["Kamado"] = true, ["Tsugikuni"] = true },
    Multi = true,
    Callback = function(selected)
        print("Target clans updated.")
    end
})
boxReroll:AddSlider({
    Name = "Spin Delay",
    Min = 0.1,
    Max = 2.0,
    Default = 0.5,
    Precision = 1,
    Suffix = "s",
    Callback = function(val)
        print("Spin Delay:", val)
    end
})

local boxBuffs = clanRight:AddGroupbox({ Title = "Clan Passive Buffs", Icon = "shield" })
boxBuffs:AddToggle({
    Name = "Auto Activate Sun Breathing",
    Default = true,
    Callback = function(val)
        print("Sun Breathing:", val)
    end
})
boxBuffs:AddButton({
    Name = "Check Clan Pity Counter",
    Icon = "activity",
    Callback = function()
        Window:Notify({ Title = "Clan System", Description = "Current Pity: 48/50 Spins (Guaranteed Mythic next!)", Duration = 3 })
    end
})

-- ==============================================================================
-- 6. SETTINGS TAB
-- ==============================================================================
local setLeft, setRight = TabSettings:AddColumns()

local boxSettings = setLeft:AddGroupbox({ Title = "Hub Configuration", Icon = "settings" })
boxSettings:AddToggle({
    Name = "Frosted Liquid Glass Blur",
    Default = true,
    Callback = function(val)
        print("Glass blur:", val)
    end
})
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
            Description = "VRSLib V2 Liquid Glass & Obsidian Neon Pink is active!",
            Duration = 3,
            Icon = "home"
        })
    end
})

-- Initial Notification
VRSLibV2:Notify({
    Title = "VRS Artelier V2",
    Description = "Loaded successfully with Liquid Glass & Obsidian aesthetic!",
    Duration = 3.5,
    Icon = "home"
})
