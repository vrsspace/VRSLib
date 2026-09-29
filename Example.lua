--[[
    ==============================================================================
    🌸 VRS ARTELIER — NEXT-GEN OBSIDIAN & NEON PINK UI SHOWCASE
    ==============================================================================
    - 100% Signature VRS Neon Magenta Pink (#FF408C) & Matte Obsidian Theme
    - 72px Compact Sidebar with Wings Logo & Centered Icon/Label Navigation
    - Screenshot 1 (Home Tab):
        * Welcome Card (Headshot Avatar, Welcome back, Username, Version Badge)
        * Streamer Mode (Name & Profile Toggles)
        * 6-Box Stat Grid (Live Players, Friends, Execs, Session, FPS, Ping)
        * Game Info Card (Thumbnail, Place/Job/Universe IDs, Server Action Buttons)
        * Warning Banner & Community Quick Links
    - Screenshot 2 (Farm Tab):
        * Header with Title, Icon & Subtitle ("Quests, mobs, bosses and pickups")
        * Horizontal Sub-Tab Pill Bar ([+] Quests & Mobs, Bosses, Caches, ...)
        * 2-Column Section Cards (Leveling, Quests, Become Demon, Accessories, Mobs, Gourds, Pickups)
        * Modern Inline Drop Bars (Label on Left, Trigger on Right, Searchable Multi-Select)
        * Neon Pink Toggles, Sliders, Buttons & Key-Value Status Rows
    ==============================================================================
]]

-- Anti-multi execution
if _G.VRS_SCRIPT_UNLOAD then pcall(_G.VRS_SCRIPT_UNLOAD) end

-- 1. Load UI Engine (Local fallback for instant dev testing, with GitHub fallback)
local VRSLib
pcall(function()
    if readfile then
        local localCode = readfile("VRSLib.lua")
        if localCode and #localCode > 0 then
            VRSLib = loadstring(localCode)()
        end
    end
end)
if not VRSLib then
    local repo = "https://raw.githubusercontent.com/vrsspace/VRSLib/main/"
    local rawCode = game:HttpGet(repo .. "VRSLib.lua?v=" .. tick())
    VRSLib = loadstring(rawCode)()
end

-- 2. Create Window (Title otomatis mengikuti nama game yang sedang dimainkan!)
local Window = VRSLib:CreateWindow({
    Title    = "auto", -- Otomatis menjadi "Welcome to <GameName>!" sesuai nama game yang sedang dimainkan
    SubTitle = "v0.141",
    Size     = UDim2.fromOffset(1020, 620),
    Accent   = Color3.fromRGB(255, 64, 140), -- VRS Signature Neon Pink (#FF408C)
    Keybind  = Enum.KeyCode.RightControl
})

Window.OnUnload = function()
    _G.VRS_ACTIVE = false
    print("[VRS Artelier] Unloaded successfully.")
end
_G.VRS_SCRIPT_UNLOAD = Window.OnUnload
_G.VRS_ACTIVE = true

-- ==============================================================================
-- 3. SIDEBAR NAVIGATION TABS (Matching Screenshot 1 & 2)
-- ==============================================================================
local TabHome     = Window:AddTab({ Name = "Home",     Icon = "home",     Subtitle = "", LayoutOrder = 1 })
local TabCloud    = Window:AddTab({ Name = "Cloud",    Icon = "cloud",    HeaderTitle = "Cloud Configurations", Subtitle = "Online presets and backups", LayoutOrder = 2 })
local TabFarm     = Window:AddTab({ Name = "Farm",     Icon = "swords",   HeaderTitle = "Farm", Subtitle = "Quests, mobs, bosses and pickups", LayoutOrder = 3 })
local TabMarket   = Window:AddTab({ Name = "Market",   Icon = "shopping-bag", HeaderTitle = "Marketplace", Subtitle = "Item trade and auctions", LayoutOrder = 4 })
local TabCombat   = Window:AddTab({ Name = "Combat",   Icon = "crosshair", HeaderTitle = "Combat", Subtitle = "Hitboxes, kill aura and auto skills", LayoutOrder = 5 })
local TabPriority = Window:AddTab({ Name = "Priority", Icon = "shield",   HeaderTitle = "Priority Target", Subtitle = "Target selection and whitelists", LayoutOrder = 6 })
local TabPlayer   = Window:AddTab({ Name = "Player",   Icon = "user",     HeaderTitle = "Player Modifications", Subtitle = "Speed, jump and humanoid modifiers", LayoutOrder = 7 })
local TabWebhook  = Window:AddTab({ Name = "Webhook",  Icon = "bell",     HeaderTitle = "Webhook Notifier", Subtitle = "Discord notifications and logs", LayoutOrder = 8 })
local TabSettings = Window:AddTab({ Name = "Settings", Icon = "settings", HeaderTitle = "Settings", Subtitle = "Hub configuration and hotkeys", LayoutOrder = 9 })

-- ==============================================================================
-- 4. TAB 1: HOME (Screenshot 1 Identical Recreation)
-- ==============================================================================
TabHome:SetupDashboard()

-- User Banner Card
TabHome:AddUserCard({
    Greeting    = "Welcome back,",
    DisplayName = game:GetService("Players").LocalPlayer.DisplayName,
    Username    = game:GetService("Players").LocalPlayer.Name,
    Version     = "v0.141",
    LayoutOrder = 1
})

-- 6 Quick Stat Boxes (Live FPS, Ping, Session, Players)
TabHome:AddStatGrid({
    LayoutOrder = 2
})

-- Game Information Card & Server Actions
TabHome:AddGameCard({
    GameName    = Window.GameName,
    Creator     = "Ouw Productions",
    LayoutOrder = 3
})

-- Unsupported Place Warning Banner
TabHome:AddBanner({
    Title       = "Madium",
    Description = "Not on the supported list. Some features may not work.",
    Icon        = "shield",
    Color       = Color3.fromRGB(255, 175, 60),
    Badge       = "RCtrl to hide",
    LayoutOrder = 4
})

-- Quick Link Rows
TabHome:AddLinkRow({
    Title       = "Join the community",
    Subtitle    = "https://discord.gg/synapsex",
    Icon        = "message-square",
    ButtonText  = "Copy Invite",
    Url         = "https://discord.gg/synapsex",
    LayoutOrder = 5
})

TabHome:AddLinkRow({
    Title       = "Supported games",
    Subtitle    = "https://ourboros-hub-rbx.web.app/",
    Icon        = "monitor",
    ButtonText  = "Copy Website",
    Url         = "https://ourboros-hub-rbx.web.app/",
    LayoutOrder = 6
})

TabHome:AddLinkRow({
    Title       = "Feature list",
    Subtitle    = "245 features across 7 tabs",
    Icon        = "list",
    ButtonText  = "View Features",
    Callback    = function()
        Window:SelectTab(TabFarm)
    end,
    LayoutOrder = 7
})

-- ==============================================================================
-- 5. TAB 2: FARM (Screenshot 2 Identical Recreation)
-- ==============================================================================
-- Sub-Tabs Pill Navigation:
-- [+] Quests & Mobs, Bosses, Caches, Schematics, Craft & Refine, Fishing
local SubQuests   = TabFarm:AddSubTab({ Name = "Quests & Mobs", Icon = "plus" })
local SubBosses   = TabFarm:AddSubTab({ Name = "Bosses",        Icon = "crosshair" })
local SubCaches   = TabFarm:AddSubTab({ Name = "Caches",        Icon = "package" })
local SubSchema   = TabFarm:AddSubTab({ Name = "Schematics",    Icon = "file-text" })
local SubCraft    = TabFarm:AddSubTab({ Name = "Craft & Refine",Icon = "wrench" })
local SubFishing  = TabFarm:AddSubTab({ Name = "Fishing",       Icon = "feather" })

-- Dual Columns inside "Quests & Mobs"
local LeftCol, RightCol = SubQuests:AddColumns()

-- ------------------------------------------------------------------------------
-- LEFT COLUMN CARDS
-- ------------------------------------------------------------------------------

-- Card 1: Leveling (📈 icon)
local CardLeveling = LeftCol:AddGroupbox("Leveling", "activity")
CardLeveling:AddToggle("One Click Level Up", {
    Default = false,
    Callback = function(v) print("[Leveling] One Click Level Up:", v) end
})

-- Card 2: Quests (📋 icon)
local CardQuests = LeftCol:AddGroupbox("Quests", "file-text")
CardQuests:AddDropdown("Quest", {
    Values = { "None", "Defeat 5 Demons", "Deliver Rice Bags", "Find Lost Child", "Slay Demon In Cave" },
    Default = "None",
    Callback = function(v) print("[Quests] Selected Quest:", v) end
})
CardQuests:AddToggle("Auto Quest", {
    Default = false,
    Callback = function(v) print("[Quests] Auto Quest:", v) end
})

-- Card 3: Become Demon (🌙 icon)
local CardDemon = LeftCol:AddGroupbox("Become Demon", "moon")
CardDemon:AddToggle("Auto Become Demon", {
    Default = false,
    Callback = function(v) print("[Demon] Auto Become Demon:", v) end
})
CardDemon:AddDropdown("Reputation Mobs (none = all)", {
    Values = { "Civilian", "Low Slayer", "Mizunoto", "Mizunoe", "Kanoto" },
    Multi = true,
    Default = {},
    Callback = function(v) print("[Demon] Reputation Mobs:", v) end
})
local StatQuestStep = CardDemon:AddStatus("Quest Step", "1/6 Lower your reputation (0 / -40)")
local StatDoing     = CardDemon:AddStatus("Doing", "Off")

-- Card 4: Accessories (📑 icon)
local CardAccessories = LeftCol:AddGroupbox("Accessories", "layers")
CardAccessories:AddToggle("Auto Equip Best", {
    Default = false,
    Callback = function(v) print("[Accessories] Auto Equip Best:", v) end
})
CardAccessories:AddDropdown("Favour (none = all evenly)", {
    Values = { "Stamina", "Health", "Breathing", "Damage", "Agility" },
    Multi = true,
    Default = {},
    Callback = function(v) print("[Accessories] Favour:", v) end
})
CardAccessories:AddButton("Equip Best Now", function()
    Window:Notify({ Title = "Accessories", Description = "Best gear equipped successfully!", Duration = 2.5 })
end)
local StatAccessories = CardAccessories:AddStatus("Accessories", "-")
CardAccessories:AddToggle("Auto Equip Best Title", {
    Default = false,
    Callback = function(v) print("[Accessories] Auto Equip Best Title:", v) end
})
local StatTitles = CardAccessories:AddStatus("Titles", "-")

-- Card 5: Skill Tree (E / git-branch icon)
local CardSkill = LeftCol:AddGroupbox("Skill Tree", "git-branch")
CardSkill:AddToggle("Auto Allocate Skill Points", {
    Default = false,
    Callback = function(v) print("[Skill Tree] Auto Allocate:", v) end
})
CardSkill:AddDropdown("Build Preset", {
    Values = { "None", "Breathing Focus", "Blood Demon Art Focus", "Tank Hybrid", "Speed Striker" },
    Default = "None",
    Callback = function(v) print("[Skill Tree] Preset:", v) end
})

-- ------------------------------------------------------------------------------
-- RIGHT COLUMN CARDS
-- ------------------------------------------------------------------------------

-- Card 1: Mobs (🎯 icon)
local CardMobs = RightCol:AddGroupbox("Mobs", "target")
CardMobs:AddDropdown("Mobs", {
    Values = { "None", "Starter Demon", "Slasher Demon", "Reaper Demon", "Akaza", "Enmu" },
    Default = "None",
    Callback = function(v) print("[Mobs] Target Mob:", v) end
})
CardMobs:AddToggle("Auto Farm Mobs", {
    Default = false,
    Callback = function(v)
        StatFarmStatus:Set(v and "Farming..." or "Idle")
    end
})
local StatFarmStatus = CardMobs:AddStatus("Farm", "Idle")

-- Card 2: Slayer Gourds (💨 icon)
local CardGourds = RightCol:AddGroupbox("Slayer Gourds", "wind")
CardGourds:AddToggle("Auto Gourd", {
    Default = false,
    Callback = function(v)
        StatGourdStatus:Set(v and "Blowing Gourd" or "Off")
    end
})
CardGourds:AddToggle("Buy Gourds From Ren", {
    Default = false,
    Callback = function(v) print("[Gourds] Buy Gourds From Ren:", v) end
})
CardGourds:AddDropdown("Gourd To Buy", {
    Values = { "Small Gourd", "Medium Gourd", "Large Gourd" },
    Default = "Large Gourd",
    Callback = function(v) print("[Gourds] Gourd To Buy:", v) end
})
CardGourds:AddSlider("Keep Wen", {
    Min = 0,
    Max = 100,
    Default = 0,
    Suffix = "k",
    Callback = function(v) print("[Gourds] Keep Wen:", v) end
})
local StatGourdStatus   = CardGourds:AddStatus("Status", "Off")
local StatGourdProgress = CardGourds:AddStatus("Slayer Progress", "Level 1, 0/2000, used 0, bought 0")

-- Card 3: Pickups (📦 icon)
local CardPickups = RightCol:AddGroupbox("Pickups", "package")
CardPickups:AddToggle("Auto Pick Up Drops", {
    Default = true, -- Highlighted with active Neon Pink switch in Screenshot 2!
    Callback = function(v)
        StatPickups:Set(v and "Collecting drops..." or "Off")
    end
})
CardPickups:AddSlider("Drop Range", {
    Min = 50,
    Max = 1000,
    Default = 300,
    Suffix = "studs",
    Callback = function(v) print("[Pickups] Drop Range:", v) end
})
CardPickups:AddDropdown("Rarities (none = all)", {
    Values = { "Common", "Uncommon", "Rare", "Legendary", "Mythic" },
    Multi = true,
    Default = {},
    Callback = function(v) print("[Pickups] Rarities:", v) end
})
CardPickups:AddDropdown("Items (none = all)", {
    Values = { "Wen Bags", "Demon Horns", "Ore Shards", "Elixirs", "Scrolls" },
    Multi = true,
    Default = {},
    Callback = function(v) print("[Pickups] Items:", v) end
})
CardPickups:AddToggle("Auto Collect Souls", {
    Default = false,
    Callback = function(v) print("[Pickups] Auto Collect Souls:", v) end
})
local StatPickups = CardPickups:AddStatus("Pickups", "Waiting for drops")

-- ==============================================================================
-- 6. REMAINING TABS (Placeholders for Cloud, Market, Combat, Priority, Player, etc.)
-- ==============================================================================
local CLeft, CRight = TabCombat:AddColumns()
local CBox = CLeft:AddGroupbox("Kill Aura", "crosshair")
CBox:AddToggle("Enable Kill Aura", { Default = false })
CBox:AddSlider("Attack Range", { Min = 5, Max = 40, Default = 18, Suffix = "studs" })
CBox:AddDropdown("Target Filter", { Values = { "Hostiles Only", "NPCs Only", "Everything" }, Default = "Hostiles Only" })

local PLeft, PRight = TabPlayer:AddColumns()
local PBox = PLeft:AddGroupbox("Movement Modifiers", "user")
PBox:AddToggle("Speed Boost", { Default = false })
PBox:AddSlider("WalkSpeed", { Min = 16, Max = 150, Default = 32 })
PBox:AddToggle("Infinite Jump", { Default = false })

-- Select Home Tab by default
Window:SelectTab(TabHome)
print("[VRS Artelier] Loaded perfectly matching Obsidian & Pink specifications.")
