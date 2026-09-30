--[[
    ==============================================================================
    ⬛ VRS MONO ENGINE (V2) — 1:1 RECREATION OF TARGET SHOWCASE
    ==============================================================================
    Matches target reference (Screenshot 1 & Screenshot 2):
      * Unified Outer Shell (Docked glass sidebar, zero detached gap)
      * Background Wallpaper Engine (Image ID / URL with live opacity control)
      * Ambient Falling Snow Particle System
      * Top-Left Custom Emblem Brand Logo
      * White Active Tab Indicator Bar on Left Edge
      * Profile Avatar with Emerald Green Online Status Indicator
      * Full 3-Tab Suite:
          - Home: Overview (Profile, Live Stat Row, Banner, Community Links) & Main Menu
          - Clan: Clan Stats & Guild Features
          - Settings: 1:1 Recreation of Screenshot 2 (Menu, Configs, Themes, Weather, Background, Colors)
    ==============================================================================
]]

-- Anti-multi execution
if _G.VRS_MONO_UNLOAD then pcall(_G.VRS_MONO_UNLOAD) end

-- 1. Load Engine (Prioritizes latest GitHub version with cache-buster, with local fallback for offline dev)
local VRSLibV2
if not _G.VRS_LOCAL and game and game.HttpGet then
    pcall(function()
        local raw = game:HttpGet("https://raw.githubusercontent.com/vrsspace/VRSLib/main/VRSLibV2.lua?v=" .. tick())
        if raw and #raw > 1000 then
            local fn = loadstring(raw)
            if fn then VRSLibV2 = fn() end
        end
    end)
end

if not VRSLibV2 and readfile then
    pcall(function()
        local paths = {
            "VRSLibV2.lua",
            "[ UI LIB ]/VRSLibV2.lua",
            "d:/Data Project's/Roblox Project/[ UI LIB ]/VRSLibV2.lua"
        }
        for _, p in ipairs(paths) do
            local ok, content = pcall(readfile, p)
            if ok and content and #content > 0 then
                local fn = loadstring(content)
                if fn then
                    VRSLibV2 = fn()
                    break
                end
            end
        end
    end)
end

if not VRSLibV2 then
    error("[VRSLibV2] Failed to load VRSLibV2 engine. Check your internet connection or executor workspace.")
end

-- 2. Create Window
local Window = VRSLibV2:CreateWindow({
    Title             = "auto",             -- Menyesuaikan judul game otomatis
    SubTitle          = "v0.171",
    Size              = UDim2.fromOffset(880, 560), -- Proportioned 1:1 with reference
    Keybind           = Enum.KeyCode.RightControl,
    Background        = "default",          -- Soft ambient dark frosted glass
    BackgroundOpacity = 0.18,              -- Subtle lux opacity (No sharp contour lines)
    Weather           = "Snow",             -- Ambient snow particles across entire screen
    ToggleButton      = true,               -- Floating mobile/desktop toggle widget
    Artwork           = {
        Title        = "Ouwland",
        Image        = "rbxassetid://1530373724",
        Footer       = "Last played\n1 day ago",
        ActionButton = "Create Party",
        Callback     = function()
            Window:Notify({ Title = "Party", Description = "Party lobby created!" })
        end
    },
    FriendJoin        = true                -- Bottom screen Friend Join widget
})

-- ==============================================================================
-- TAB 1: HOME (Matching Screenshot 1)
-- ==============================================================================
local TabHome = Window:AddTab({
    Name        = "Home",
    Icon        = "home",
    HeaderTitle = "auto",
    Subtitle    = "v0.171"
})

-- SubTab 1: Overview
local SubOverview = TabHome:AddSubTab({
    Name = "Overview",
    Icon = "overview"
})

-- Profile Card (With Name & Profile switches matching Screenshot 1)
SubOverview:AddProfileCard({
    Badge = "v0.171"
})

-- Live Stat Row (Players, Friends, Execs, Session, FPS, Ping)
local Stats = SubOverview:AddStatRow({
    { Title = "Players", Value = "1/1",     Icon = "players" },
    { Title = "Friends", Value = "0",       Icon = "friends" },
    { Title = "Execs",   Value = "6",       Icon = "execs" },
    { Title = "Session", Value = "0m 00s",  Icon = "session" },
    { Title = "FPS",     Value = "240",     Icon = "fps" },
    { Title = "Ping",    Value = "27ms",    Icon = "ping" }
})

-- Game Info Card (Matching Screenshot 1: Slayers 2 / Current Game Info & Action Controls)
SubOverview:AddGameCard({
    Title      = "Slayers 2",
    Creator    = "by Gun Productions",
    PlaceId    = 1530373724,
    UniverseId = 5370353122
})

-- Live Session Timer & FPS / Ping Update Loop
task.spawn(function()
    local startTime = tick()
    local lastFpsTime = tick()
    local frameCount = 0

    local RunService = game:GetService("RunService")
    local StatsService = game:GetService("Stats")

    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = tick()
        if now - lastFpsTime >= 1 then
            local fps = math.round(frameCount / (now - lastFpsTime))
            if Stats["FPS"] then Stats["FPS"].UpdateValue(fps) end
            frameCount = 0
            lastFpsTime = now

            local elapsed = math.floor(now - startTime)
            local mins = math.floor(elapsed / 60)
            local secs = elapsed % 60
            if Stats["Session"] then
                Stats["Session"].UpdateValue(string.format("%dm %02ds", mins, secs))
            end

            pcall(function()
                local pingVal = math.round(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
                if Stats["Ping"] then Stats["Ping"].UpdateValue(pingVal .. "ms") end
            end)
        end
    end)
end)

-- Notice Banner
SubOverview:AddBanner({
    Title   = "Madium",
    Message = "Not on the supported list. Some features may not work.",
    Icon    = "shield",
    Badge   = "RCtrl to hide"
})

-- Quick Links & Community InfoRows
local QuickGroup = SubOverview:AddGroupbox({ Title = "Community & Support", Icon = "globe" })

QuickGroup:AddInfoRow({
    Name       = "Join the community",
    Value      = "https://discord.gg/synapsex",
    Icon       = "users",
    ButtonText = "Copy Invite",
    Callback   = function(val)
        if setclipboard then setclipboard(val) end
        Window:Notify({ Title = "Clipboard", Description = "Discord invite link copied to clipboard!" })
    end
})

QuickGroup:AddInfoRow({
    Name       = "Supported games",
    Value      = "https://ouroboros-hub-rbx.web.app/",
    Icon       = "box",
    ButtonText = "Copy Website",
    Callback   = function(val)
        if setclipboard then setclipboard(val) end
        Window:Notify({ Title = "Clipboard", Description = "Website URL copied to clipboard!" })
    end
})

QuickGroup:AddInfoRow({
    Name       = "Feature list",
    Value      = "7 features across 2 tabs",
    Icon       = "list",
    ButtonText = "View Features",
    Callback   = function()
        Window:Notify({ Title = "Features", Description = "All components active with 100% fidelity." })
    end
})

-- SubTab 2: Main Menu (2 Columns for Controls)
local SubMenu = TabHome:AddSubTab({
    Name = "Main Menu",
    Icon = "menu"
})

local LeftCol, RightCol = SubMenu:AddColumns()

local FarmBox = LeftCol:AddGroupbox({ Title = "Automation", Icon = "swords" })
FarmBox:AddToggle({ Name = "Auto Farm Mobs", Default = false, Callback = function(v) print("Auto Farm:", v) end })
FarmBox:AddToggle({ Name = "Auto Collect Drops", Default = true, Callback = function(v) print("Auto Collect:", v) end })
FarmBox:AddSlider({ Name = "Attack Delay", Min = 0.1, Max = 2.0, Default = 0.5, Step = 0.1, Suffix = "s", Callback = function(v) print("Delay:", v) end })

local MiscBox = RightCol:AddGroupbox({ Title = "Player Modifications", Icon = "sliders" })
MiscBox:AddSlider({ Name = "WalkSpeed Multiplier", Min = 16, Max = 250, Default = 32, Step = 1, Suffix = " spd", Callback = function(v)
    pcall(function() game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = v end)
end })
MiscBox:AddDropdown({ Name = "Target Selection", Items = { "Closest", "Lowest HP", "Highest Level" }, Default = "Closest", Callback = function(c) print("Target:", c) end })
MiscBox:AddButton({ Name = "Instant Server Rejoin", Callback = function() Window:Notify({ Title = "Server", Description = "Rejoining..." }) end })


-- ==============================================================================
-- TAB 2: CLAN (Guild & Faction Management)
-- ==============================================================================
local TabClan = Window:AddTab({
    Name        = "Clan",
    Icon        = "shield",
    HeaderTitle = "Clan",
    Subtitle    = "v0.167"
})

local ClanLeft, ClanRight = TabClan:AddColumns()

local ClanInfo = ClanLeft:AddGroupbox({ Title = "Guild Information", Icon = "shield" })
ClanInfo:AddInfoRow({ Name = "Current Clan", Value = "Kamado (Mythic)", ButtonText = "Inspect" })
ClanInfo:AddInfoRow({ Name = "Clan Rank", Value = "Grand Master #12", ButtonText = "Ranks" })
ClanInfo:AddButton({ Name = "Spin Clan Slot (100 Spins)", Callback = function() Window:Notify({ Title = "Clan", Description = "Spinning slot..." }) end })

local ClanBuffs = ClanRight:AddGroupbox({ Title = "Active Clan Buffs", Icon = "zap" })
ClanBuffs:AddLabel("• +25% Health Regeneration")
ClanBuffs:AddLabel("• +15% Breathing Technique Damage")
ClanBuffs:AddLabel("• Special Ability: Sun Breathing Mastery")


-- ==============================================================================
-- TAB 3: SETTINGS (1:1 Recreation of Screenshot 2)
-- ==============================================================================
local TabSettings = Window:AddTab({
    Name        = "Settings",
    Icon        = "settings",
    HeaderTitle = "Settings",
    Subtitle    = "v0.167"
})

local SetLeft, SetRight = TabSettings:AddColumns()

-- 1. Left Column: Menu Groupbox
local MenuBox = SetLeft:AddGroupbox({ Title = "Menu", Icon = "desktop" })

MenuBox:AddKeybind({
    Name     = "Toggle UI",
    Default  = Enum.KeyCode.RightControl,
    Callback = function(key)
        Window:Notify({ Title = "Keybind Saved", Description = "UI toggle keybind set to " .. key.Name })
    end
})

MenuBox:AddDropdown({
    Name     = "Toggle button",
    Items    = { "Mobile only", "Always", "Never" },
    Default  = "Mobile only",
    Callback = function(v) print("Toggle button mode:", v) end
})

local antiAfkConn
MenuBox:AddToggle({
    Name     = "Anti AFK",
    Default  = true,
    Callback = function(enabled)
        if enabled then
            antiAfkConn = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new())
            end)
            Window:Notify({ Title = "Anti AFK", Description = "Anti AFK protection activated." })
        else
            if antiAfkConn then antiAfkConn:Disconnect() end
            Window:Notify({ Title = "Anti AFK", Description = "Anti AFK disabled." })
        end
    end
})

MenuBox:AddButton({
    Name     = "⏻ Unload",
    Callback = function()
        Window.OnUnload()
        print("[VRS Mono] Interface unloaded successfully.")
    end
})

-- 2. Left Column: Configs Groupbox
local ConfigBox = SetLeft:AddGroupbox({ Title = "Configs", Icon = "folder" })

local currentConfigName = ""
ConfigBox:AddInput({
    Name        = "Config Name",
    Placeholder = "config name",
    Default     = "",
    Callback    = function(txt) currentConfigName = txt end
})

ConfigBox:AddDropdown({
    Name    = "Select Config",
    Items   = { "--", "Default", "Farming", "PvP" },
    Default = "--"
})

ConfigBox:AddButton({ Name = "Create Config", Callback = function() Window:Notify({ Title = "Configs", Description = "Created config: " .. currentConfigName }) end })
ConfigBox:AddButton({ Name = "Save Config",   Callback = function() Window:Notify({ Title = "Configs", Description = "Config saved." }) end })
ConfigBox:AddButton({ Name = "Load Config",   Callback = function() Window:Notify({ Title = "Configs", Description = "Config loaded." }) end })
ConfigBox:AddButton({ Name = "Delete Config", Callback = function() Window:Notify({ Title = "Configs", Description = "Config deleted." }) end })

ConfigBox:AddLabel("loaded: none  |  autoload: none")

ConfigBox:AddDropdown({
    Name    = "Autoload mode",
    Items   = { "All accounts", "This account only", "Disabled" },
    Default = "All accounts"
})

ConfigBox:AddButton({ Name = "Refresh list", Callback = function() Window:Notify({ Title = "Configs", Description = "Config list refreshed." }) end })

ConfigBox:AddLabel("——— share ———")
ConfigBox:AddButton({ Name = "Copy code", Callback = function()
    if setclipboard then setclipboard("VRS_CFG_018274") end
    Window:Notify({ Title = "Config Code", Description = "Code copied to clipboard!" })
end })

ConfigBox:AddInput({
    Name        = "Import Code",
    Placeholder = "paste a config code...",
    Default     = "",
    Callback    = function(code)
        Window:Notify({ Title = "Configs", Description = "Imported config code!" })
    end
})

ConfigBox:AddButton({ Name = "Import code", Callback = function() Window:Notify({ Title = "Configs", Description = "Config imported." }) end })


-- 3. Right Column: Themes Groupbox (Matching Screenshot 2 exactly)
local ThemesBox = SetRight:AddGroupbox({ Title = "Themes", Icon = "palette" })

ThemesBox:AddDropdown({
    Name     = "Preset",
    Items    = { "Mono", "Cyber", "Emerald", "Artelier", "Gold" },
    Default  = "Mono",
    Callback = function(val)
        Window:SetPreset(val)
        Window:Notify({ Title = "Theme Preset", Description = "Preset changed to " .. val })
    end
})

ThemesBox:AddDropdown({
    Name     = "Weather",
    Items    = { "Snow", "None" },
    Default  = "Snow",
    Callback = function(val)
        Window:SetWeather(val)
    end
})

ThemesBox:AddDropdown({
    Name     = "Weather Mode",
    Items    = { "Screen", "Window" },
    Default  = "Window",
    Callback = function(val) print("Weather Mode:", val) end
})

ThemesBox:AddToggle({ Name = "Dim", Default = false, Callback = function(v) print("Dim:", v) end })
ThemesBox:AddToggle({ Name = "Transparent", Default = false, Callback = function(v) print("Transparent:", v) end })
ThemesBox:AddToggle({ Name = "Drag Skeleton", Default = true, Callback = function(v) print("Drag Skeleton:", v) end })

ThemesBox:AddDropdown({
    Name     = "Background",
    Items    = { "Default Artwork", "Cyber Grid", "None" },
    Default  = "Default Artwork",
    Callback = function(v)
        if v == "None" then
            Window:SetBackground("None", 0)
        elseif v == "Default Artwork" then
            Window:SetBackground("default", 0.65)
        elseif v == "Cyber Grid" then
            Window:SetBackground("rbxassetid://6071575925", 0.45)
        end
    end
})

local customBgUrl = ""
ThemesBox:AddInput({
    Name        = "Background Image",
    Placeholder = "image id or url",
    Default     = "",
    Callback    = function(url) customBgUrl = url end
})

ThemesBox:AddButton({
    Name     = "Set Background",
    Callback = function()
        if customBgUrl and customBgUrl ~= "" then
            Window:SetBackground(customBgUrl, 0.65)
            Window:Notify({ Title = "Background", Description = "Custom background applied!" })
        end
    end
})

ThemesBox:AddSlider({
    Name     = "Background Opacity",
    Min      = 0,
    Max      = 100,
    Default  = 65,
    Step     = 1,
    Suffix   = "%",
    Callback = function(val)
        Window:SetBackground(nil, val / 100)
    end
})

ThemesBox:AddLabel("——— Custom Themes & Palette ———")
ThemesBox:AddColorPicker({
    Name     = "Accent Color",
    Default  = Color3.fromRGB(255, 255, 255),
    Callback = function(col)
        VRSLibV2.Theme.Accent = col
        VRSLibV2.Theme.PillIndicator = col
        if Window.ActiveTab and Window.ActiveTab.Button then
            TweenService:Create(Window.ActiveTab.Button.ActivePill, TweenInfo.new(0.2), { BackgroundColor3 = col }):Play()
        end
        Window:Notify({ Title = "Palette", Description = "Accent color updated!" })
    end
})

ThemesBox:AddInput({ Name = "Theme Name", Placeholder = "theme name", Default = "" })
ThemesBox:AddButton({ Name = "Save Theme", Callback = function() Window:Notify({ Title = "Themes", Description = "Theme saved." }) end })
ThemesBox:AddButton({ Name = "Load Theme", Callback = function() Window:Notify({ Title = "Themes", Description = "Theme loaded." }) end })

ThemesBox:AddLabel("Default theme: Mono")

print("[VRS Mono] ExampleV2 loaded successfully!")
