--[[
    ==============================================================================
    ⬛ VRS MONO ENGINE (V2) — GENERAL COMPONENT TEST SHOWCASE
    ==============================================================================
    Design: 1:1 Recreation of Target Design in Strict Monochrome
      * Solid Charcoal Abu-Abu Window (#131419, Matte Finish)
      * Floating Frosted Glass Sidebar (#0E0F14, 0.22 Translucency)
      * Top-Left VRS Wings Brand Logo (rbxassetid://132717088484517)
      * White Vertical Pill Active Indicator on Tab Left Edge
      * Profile Avatar with Emerald Online Status Dot
      * Pure Monochrome Theme (White Accents, Slate Borders, Zero Neon)
      * Sub-Tabs Pill Bar ([田 Overview] [▷ Main Menu])
      * General Component Testing (Toggles, Sliders, Drop Bars, Inputs, Buttons)
    ==============================================================================
]]

-- Anti-multi execution & clean lingering instances
if _G.VRS_MONO_UNLOAD then pcall(_G.VRS_MONO_UNLOAD) end

-- 1. Load Engine (Multi-path fallback: local executor folder, subfolders, or raw)
local VRSLibV2
pcall(function()
    if readfile then
        local paths = {
            "VRSLibV2.lua",
            "[ UI LIB ]/VRSLibV2.lua",
            "d:/Data Project's/Roblox Project/[ UI LIB ]/VRSLibV2.lua"
        }
        for _, p in ipairs(paths) do
            local ok, content = pcall(readfile, p)
            if ok and content and #content > 0 then
                local fn, err = loadstring(content)
                if fn then
                    VRSLibV2 = fn()
                    break
                end
            end
        end
    end
end)

-- Fallback to GitHub repository if running remotely
if not VRSLibV2 then
    pcall(function()
        local raw = game:HttpGet("https://raw.githubusercontent.com/vrsspace/VRSLib/main/VRSLibV2.lua?v=" .. tick())
        local fn = loadstring(raw)
        if fn then VRSLibV2 = fn() end
    end)
end

if not VRSLibV2 then
    error("[VRSLibV2] Failed to load VRSLibV2 engine. Ensure VRSLibV2.lua is in your executor workspace.")
end

-- 2. Create Window
local Window = VRSLibV2:CreateWindow({
    Title    = "auto", -- Otomatis: "Welcome to <GameName>!"
    SubTitle = "v0.167",
    Size     = UDim2.fromOffset(1020, 620),
    Keybind  = Enum.KeyCode.RightControl
})

-- ==============================================================================
-- TAB 1: HOME (Dashboard, Overview & Main Menu)
-- ==============================================================================
local TabHome = Window:AddTab({
    Name = "Home",
    Icon = "home",
    HeaderTitle = "auto"
})

-- SubTab 1: Overview
local SubOverview = TabHome:AddSubTab({
    Name = "Overview",
    Icon = "overview"
})

-- Hero / Profile Card
SubOverview:AddProfileCard({
    Badge = "v0.167"
})

-- Live Stat Row (Players, Friends, Execs, Session, FPS, Ping)
local Stats = SubOverview:AddStatRow({
    { Title = "Players", Value = "1/1",     Icon = "players" },
    { Title = "Friends", Value = "0",       Icon = "friends" },
    { Title = "Execs",   Value = "5",       Icon = "execs" },
    { Title = "Session", Value = "0m 00s",  Icon = "session" },
    { Title = "FPS",     Value = "240",     Icon = "fps" },
    { Title = "Ping",    Value = "27ms",    Icon = "ping" }
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

            -- Session duration
            local elapsed = math.floor(now - startTime)
            local mins = math.floor(elapsed / 60)
            local secs = elapsed % 60
            if Stats["Session"] then
                Stats["Session"].UpdateValue(string.format("%dm %02ds", mins, secs))
            end

            -- Ping
            pcall(function()
                local pingVal = math.round(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
                if Stats["Ping"] then Stats["Ping"].UpdateValue(pingVal .. "ms") end
            end)
        end
    end)
end)

-- Notice Banner
SubOverview:AddBanner({
    Title   = "Mono Engine",
    Message = "Pure monochrome aesthetic active. Frosted glass floating sidebar enabled.",
    Icon    = "shield",
    Badge   = "RCtrl to hide"
})

-- Quick Links & Information Rows
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
    Value      = "Modular components tested across all categories",
    Icon       = "list",
    ButtonText = "View Info",
    Callback   = function()
        Window:Notify({ Title = "Information", Description = "Mono V2 Engine loaded with 100% component coverage." })
    end
})

-- SubTab 2: Main Menu (Component Testing in Home)
local SubMenu = TabHome:AddSubTab({
    Name = "Main Menu",
    Icon = "menu"
})

local GeneralBox = SubMenu:AddGroupbox({ Title = "Quick Actions", Icon = "zap" })

GeneralBox:AddToggle({
    Name     = "Enable Quick Farm",
    Default  = false,
    Callback = function(val)
        print("[Toggle] Quick Farm:", val)
    end
})

GeneralBox:AddSlider({
    Name     = "Speed Multiplier",
    Min      = 1,
    Max      = 10,
    Default  = 2,
    Step     = 1,
    Suffix   = "x",
    Callback = function(val)
        print("[Slider] Speed:", val)
    end
})

GeneralBox:AddButton({
    Name     = "Trigger Instant Rejoin",
    Callback = function()
        Window:Notify({ Title = "Server", Description = "Rejoining server..." })
    end
})


-- ==============================================================================
-- TAB 2: COMPONENT TESTING (Toggles, Sliders, Dropdowns, Inputs, Buttons)
-- ==============================================================================
local TabControls = Window:AddTab({
    Name = "Controls",
    Icon = "sliders",
    HeaderTitle = "Component Testing & Controls"
})

local SubToggles = TabControls:AddSubTab({
    Name = "Switches & Sliders",
    Icon = "sliders"
})

-- Groupbox 1: Switches
local BoxSwitches = SubToggles:AddGroupbox({ Title = "Pill Switches (iOS Mono)", Icon = "sliders" })

BoxSwitches:AddToggle({
    Name     = "Auto Attack Mobs",
    Default  = true,
    Callback = function(v)
        print("[Toggle] Auto Attack:", v)
    end
})

BoxSwitches:AddToggle({
    Name     = "Auto Collect Drops",
    Default  = false,
    Callback = function(v)
        print("[Toggle] Auto Collect:", v)
    end
})

BoxSwitches:AddToggle({
    Name     = "Fast Weapon Swing",
    Default  = true,
    Callback = function(v)
        print("[Toggle] Fast Swing:", v)
    end
})

-- Groupbox 2: Sliders
local BoxSliders = SubToggles:AddGroupbox({ Title = "Precision Sliders", Icon = "sliders" })

BoxSliders:AddSlider({
    Name     = "WalkSpeed Multiplier",
    Min      = 16,
    Max      = 250,
    Default  = 32,
    Step     = 1,
    Suffix   = " spd",
    Callback = function(v)
        pcall(function()
            local char = game:GetService("Players").LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = v
            end
        end)
    end
})

BoxSliders:AddSlider({
    Name     = "JumpPower Height",
    Min      = 50,
    Max      = 300,
    Default  = 50,
    Step     = 5,
    Suffix   = " jp",
    Callback = function(v)
        pcall(function()
            local char = game:GetService("Players").LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.JumpPower = v
            end
        end)
    end
})

BoxSliders:AddSlider({
    Name     = "Attack Cooldown Delay",
    Min      = 0.1,
    Max      = 2.0,
    Default  = 0.5,
    Step     = 0.1,
    Suffix   = "s",
    Callback = function(v)
        print("[Slider] Attack Delay:", v)
    end
})

-- SubTab: Drop Bars & Inputs
local SubInputs = TabControls:AddSubTab({
    Name = "Drop Bars & Inputs",
    Icon = "list"
})

-- Groupbox 3: Drop Bars (Dropdowns)
local BoxDropbars = SubInputs:AddGroupbox({ Title = "Inline Drop Bars (Dropdowns)", Icon = "list" })

BoxDropbars:AddDropdown({
    Name     = "Target Priority Mode",
    Items    = { "Closest Distance", "Lowest HP", "Highest Level", "Random" },
    Default  = "Closest Distance",
    Multi    = false,
    Callback = function(choice)
        print("[Dropdown Single] Selected:", choice)
        Window:Notify({ Title = "Target Priority", Description = "Changed to " .. tostring(choice) })
    end
})

BoxDropbars:AddDropdown({
    Name     = "Active Farming Zones",
    Items    = { "Starter Village", "Bamboo Forest", "Demon Cave", "Mountaintop", "Underground" },
    Default  = { "Starter Village", "Bamboo Forest" },
    Multi    = true,
    Callback = function(selectedList)
        print("[Dropdown Multi] Selected zones:", table.concat(selectedList, ", "))
    end
})

-- Groupbox 4: TextInputs & Keybinds
local BoxInputs = SubInputs:AddGroupbox({ Title = "Inputs & Keybinds", Icon = "terminal" })

BoxInputs:AddInput({
    Name        = "Custom Target Name",
    Placeholder = "e.g. Demon King",
    Default     = "",
    Callback    = function(text, enter)
        print("[Input] Value entered:", text)
        Window:Notify({ Title = "Target Saved", Description = "Target set to: " .. text })
    end
})

BoxInputs:AddKeybind({
    Name     = "Quick Teleport Keybind",
    Default  = Enum.KeyCode.F,
    Callback = function(key)
        print("[Keybind] Pressed:", key.Name)
        Window:Notify({ Title = "Keybind Fired", Description = "Key " .. key.Name .. " pressed!" })
    end
})

BoxInputs:AddButton({
    Name     = "Print Status Diagnostics to Console",
    Callback = function()
        print("=== VRS MONO STATUS DIAGNOSTIC ===")
        print("LocalPlayer:", game:GetService("Players").LocalPlayer.Name)
        print("Engine Version:", VRSLibV2.Version)
        print("Active Tab:", Window.ActiveTab and Window.ActiveTab.Name or "None")
        print("==================================")
        Window:Notify({ Title = "Diagnostics", Description = "Check F9 developer console for output." })
    end
})


-- ==============================================================================
-- TAB 3: SETTINGS
-- ==============================================================================
local TabSettings = Window:AddTab({
    Name = "Settings",
    Icon = "settings",
    HeaderTitle = "System & Engine Settings"
})

local SettingsBox = TabSettings:AddGroupbox({ Title = "Configuration", Icon = "settings" })

SettingsBox:AddLabel("VRS Mono Engine v2.1.0 • Pure Charcoal Edition")
SettingsBox:AddLabel("Press RightControl on your keyboard to toggle window visibility.")

SettingsBox:AddButton({
    Name     = "Unload & Clean GUI",
    Callback = function()
        Window.OnUnload()
        print("[VRS Mono] Interface unloaded.")
    end
})

print("[VRS Mono] ExampleV2 loaded successfully!")
