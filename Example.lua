--[[
    ==============================================================================
    🌸 VRS ARTELIER — MODULAR CARD SHOWCASE (47 MODULES)
    ==============================================================================
    - 100% Signature VRS Neon Magenta Pink (#FF408C) & Cyber-Dark (#0D0E13)
    - Wings Logo di Kiri Atas & Floating Widget Mobile
    - Window Bebas Di-Tarik/Di-Besar-Lebarin (Corner Grip ⤡ & Border Draggers)
    - Dynamic Columns Reflow (3 hingga 6 Kolom otomatis!)
    - Tombol [X] Berfungsi Menutup Hub & Unload Script Bersih
    - Lengkap 47 Modules (Visuals 16, Movement 13, World 6, System 12)
    ==============================================================================
]]

-- Anti-multi execution
if _G.VRS_SCRIPT_UNLOAD then pcall(_G.VRS_SCRIPT_UNLOAD) end

-- 1. Load UI Engine langsung dari Raw GitHub (Anti-Cache)
local repo = "https://raw.githubusercontent.com/vrsspace/VRSLib/v1.1.3/"
local rawCode = game:HttpGet(repo .. "VRSLib.lua?v=" .. tick())
local loadFunc, loadErr = loadstring(rawCode)
if not loadFunc then
    error("[VRS Artelier] Compilation error: " .. tostring(loadErr))
end
local VRSLib = loadFunc()

-- 2. Buat Window VRS Artelier (Aksen Neon Magenta Pink & Wings Logo)
local Window = VRSLib:CreateWindow({
    Title    = "VRS Artelier",
    SubTitle = "v1.1.3",
    Size     = UDim2.fromOffset(1020, 620), -- Ukuran lega (otomatis 5-6 kolom!)
    Accent   = Color3.fromRGB(255, 64, 140), -- VRS Signature Neon Magenta Pink (#FF408C)
    Keybind  = Enum.KeyCode.RightControl
})

-- Register Unload Handler (Dijalankan saat tombol [X] di pojok kanan atas ditekan)
Window.OnUnload = function()
    _G.VRS_ACTIVE = false
    print("[VRS Artelier] Script unloaded & all listeners disconnected cleanly.")
end
_G.VRS_SCRIPT_UNLOAD = Window.OnUnload
_G.VRS_ACTIVE = true

-- 3. Kategori Universal & Tab Navigasi
Window:AddCategory("UNIVERSAL", 10)

local TabVisuals  = Window:AddTab({ Name = "Visuals",  Category = "UNIVERSAL", Icon = "Visuals",  LayoutOrder = 11 })
local TabMovement = Window:AddTab({ Name = "Movement", Category = "UNIVERSAL", Icon = "Movement", LayoutOrder = 12 })
local TabWorld    = Window:AddTab({ Name = "World",    Category = "UNIVERSAL", Icon = "World",    LayoutOrder = 13 })
local TabSystem   = Window:AddTab({ Name = "System",   Category = "UNIVERSAL", Icon = "System",   LayoutOrder = 14 })

-- ==============================================================================
-- 4. MODULES (TOTAL 47 MODULES LENGKAP PERSIS SEPERTI 404HUB)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- [ VISUALS — 16 MODULES ]
-- ------------------------------------------------------------------------------
Window:AddModule(TabVisuals, {
    Title       = "ESP",
    Description = "Player ESP editor — 2D/3D boxes, chams, avatar, name lines, health...",
    Icon        = "lucide-eye",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] ESP:", v) end
})

local fov = Window:AddModule(TabVisuals, {
    Title       = "FOV",
    Description = "Override the camera field of view",
    Icon        = "lucide-camera",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] FOV:", v) end
})
fov:AddSlider({
    Name     = "FOV Angle",
    Min      = 70,
    Max      = 120,
    Default  = 90,
    Callback = function(v) workspace.CurrentCamera.FieldOfView = v end
})

Window:AddModule(TabVisuals, {
    Title       = "Atmosphere",
    Description = "Volumetric air + horizon haze",
    Icon        = "Cloud",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Atmosphere:", v) end
})

Window:AddModule(TabVisuals, {
    Title       = "Bloom",
    Description = "Soft glow over bright areas",
    Icon        = "Sun",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Bloom:", v) end
})

Window:AddModule(TabVisuals, {
    Title       = "Blur",
    Description = "Soft full-screen blur",
    Icon        = "lucide-eye-off",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Blur:", v) end
})

Window:AddModule(TabVisuals, {
    Title       = "Color correction",
    Description = "Saturation, contrast and tint over the scene",
    Icon        = "lucide-sliders",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Color correction:", v) end
})

Window:AddModule(TabVisuals, {
    Title       = "Custom Fog",
    Description = "Classic distance fog",
    Icon        = "Cloud",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Custom Fog:", v) end
})

Window:AddModule(TabVisuals, {
    Title       = "Custom Sky",
    Description = "Stars, sun/moon and custom skybox",
    Icon        = "Cloud",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Custom Sky:", v) end
})

local cTime = Window:AddModule(TabVisuals, {
    Title       = "Custom Time",
    Description = "Pin the time of day",
    Icon        = "Clock",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Custom Time:", v) end
})
cTime:AddSlider({
    Name     = "Hour",
    Min      = 0,
    Max      = 24,
    Default  = 14,
    Callback = function(v) game:GetService("Lighting").ClockTime = v end
})

Window:AddModule(TabVisuals, {
    Title       = "Freecam",
    Description = "Detach the camera and fly freely — WASD + Q/E, Shift to speed",
    Icon        = "lucide-camera",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Freecam:", v) end
})

Window:AddModule(TabVisuals, {
    Title       = "Fullbright",
    Description = "Flat full-scene lighting, no shadows",
    Icon        = "Sun",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Fullbright:", v) end
})

local lightMod = Window:AddModule(TabVisuals, {
    Title       = "Lighting...",
    Description = "Brightness, shadows, fog and ambient",
    Icon        = "Sun",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Lighting:", v) end
})
lightMod:AddSlider({ Name = "Brightness", Min = 1, Max = 5, Default = 2 })

Window:AddModule(TabVisuals, {
    Title       = "NoRender",
    Description = "Stop drawing the 3D world (UI stays visible)",
    Icon        = "lucide-eye-off",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] NoRender:", v) end
})

Window:AddModule(TabVisuals, {
    Title       = "Perspective",
    Description = "Force first or third person camera view",
    Icon        = "lucide-view",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Perspective:", v) end
})

Window:AddModule(TabVisuals, {
    Title       = "Tracers",
    Description = "Draw a line from your screen to every player",
    Icon        = "lucide-crosshair",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] Tracers:", v) end
})

Window:AddModule(TabVisuals, {
    Title       = "X-Ray",
    Description = "See through walls and world geometry",
    Icon        = "lucide-eye",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Visuals] X-Ray:", v) end
})

-- ------------------------------------------------------------------------------
-- [ MOVEMENT — 13 MODULES ]
-- ------------------------------------------------------------------------------
local fly = Window:AddModule(TabMovement, {
    Title       = "Fly",
    Description = "Vape-style flight — WASD + Up/Down",
    Icon        = "lucide-feather",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] Fly:", v) end
})
fly:AddSlider({ Name = "Fly Speed", Min = 10, Max = 250, Default = 60 })

Window:AddModule(TabMovement, {
    Title       = "Fling",
    Description = "Throw other players across the map — spin them or walk them down",
    Icon        = "lucide-move",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] Fling:", v) end
})

Window:AddModule(TabMovement, {
    Title       = "Ctrl Lock",
    Description = "Toggle shift-lock with your own key — bind one below",
    Icon        = "Key",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] Ctrl Lock:", v) end
})

Window:AddModule(TabMovement, {
    Title       = "Alignment Keys",
    Description = "Nudge the camera yaw one step at a time",
    Icon        = "Key",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] Alignment Keys:", v) end
})

Window:AddModule(TabMovement, {
    Title       = "Jesus",
    Description = "Walk on terrain water surfaces seamlessly",
    Icon        = "lucide-navigation",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] Jesus:", v) end
})

local jmp = Window:AddModule(TabMovement, {
    Title       = "Jump",
    Description = "Jump higher, infinitely, or automatically — pick a bypass",
    Icon        = "lucide-arrow-up",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] Jump:", v) end
})
jmp:AddSlider({ Name = "JumpPower", Min = 50, Max = 300, Default = 100 })

Window:AddModule(TabMovement, {
    Title       = "NoClip",
    Description = "Walk through walls without obstruction",
    Icon        = "lucide-shield",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] NoClip:", v) end
})

Window:AddModule(TabMovement, {
    Title       = "Spider",
    Description = "Climb walls by holding into them",
    Icon        = "lucide-bug",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] Spider:", v) end
})

Window:AddModule(TabMovement, {
    Title       = "Spin",
    Description = "Spin your character in place rapidly",
    Icon        = "lucide-refresh-cw",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] Spin:", v) end
})

local ws = Window:AddModule(TabMovement, {
    Title       = "WalkSpeed",
    Description = "Vape-style speed — configurable bypasses",
    Icon        = "lucide-gauge",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] WalkSpeed:", v) end
})
ws:AddSlider({ Name = "Speed", Min = 16, Max = 250, Default = 50 })

Window:AddModule(TabMovement, {
    Title       = "Bunny Hop",
    Description = "Preserve sprint momentum upon landing",
    Icon        = "lucide-move-diagonal",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] Bunny Hop:", v) end
})

Window:AddModule(TabMovement, {
    Title       = "Air Walk",
    Description = "Creates a solid invisible platform under your feet",
    Icon        = "lucide-wind",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] Air Walk:", v) end
})

Window:AddModule(TabMovement, {
    Title       = "No Slowdown",
    Description = "Ignore water, spiderweb, and item drag slows",
    Icon        = "lucide-gauge",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Movement] No Slowdown:", v) end
})

-- ------------------------------------------------------------------------------
-- [ WORLD — 6 MODULES ]
-- ------------------------------------------------------------------------------
Window:AddModule(TabWorld, {
    Title       = "Click Detectors",
    Description = "Click from any distance, and fire them all at once",
    Icon        = "lucide-mouse-pointer-click",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[World] Click Detectors:", v) end
})

Window:AddModule(TabWorld, {
    Title       = "Fire Touch...",
    Description = "Fire nearby parts' touch interests",
    Icon        = "lucide-flame",
    Type        = "Action",
    Callback    = function()
        VRSLib:Notify({ Title = "World", Description = "Fired nearby parts' touch interests!", Duration = 2, Icon = "Play" })
    end
})

local hb = Window:AddModule(TabWorld, {
    Title       = "Hitbox",
    Description = "Expand other players' hit parts — pick the bones below",
    Icon        = "lucide-box",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[World] Hitbox:", v) end
})
hb:AddSlider({ Name = "Size", Min = 2, Max = 30, Default = 12 })

Window:AddModule(TabWorld, {
    Title       = "Proximity...",
    Description = "Instant - no limit prompts, and fire them all at once",
    Icon        = "lucide-target",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[World] Proximity:", v) end
})

Window:AddModule(TabWorld, {
    Title       = "Removals",
    Description = "Strip ads, terrain, nil instances and set the void height",
    Icon        = "lucide-trash-2",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[World] Removals:", v) end
})

local grav = Window:AddModule(TabWorld, {
    Title       = "Gravity Override",
    Description = "Override workspace world gravity scale",
    Icon        = "lucide-globe",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[World] Gravity:", v) end
})
grav:AddSlider({ Name = "Gravity", Min = 0, Max = 196, Default = 50, Callback = function(v) workspace.Gravity = v end })

-- ------------------------------------------------------------------------------
-- [ SYSTEM & SECURITY — 12 MODULES ]
-- ------------------------------------------------------------------------------
Window:AddModule(TabSystem, {
    Title       = "Anti-Kick",
    Description = "Block client-side kicks",
    Icon        = "lucide-shield",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[System] Anti-Kick:", v) end
})

Window:AddModule(TabSystem, {
    Title       = "Anti-Teleport",
    Description = "Block client-side teleports",
    Icon        = "lucide-shield-alert",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[System] Anti-Teleport:", v) end
})

Window:AddModule(TabSystem, {
    Title       = "Antifling",
    Description = "Stop other players from flinging you",
    Icon        = "lucide-shield-check",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[System] Antifling:", v) end
})

Window:AddModule(TabSystem, {
    Title       = "Anti Ragdoll",
    Description = "Stops knockback from ragdolling you",
    Icon        = "Player",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[System] Anti Ragdoll:", v) end
})

Window:AddModule(TabSystem, {
    Title       = "Anti-AFK",
    Description = "Stop the game kicking you for being idle",
    Icon        = "Clock",
    Type        = "Toggle",
    Default     = true,
    Callback    = function(v) print("[System] Anti-AFK:", v) end
})

Window:AddModule(TabSystem, {
    Title       = "AntiLag",
    Description = "Lower quality and strip effects to boost FPS",
    Icon        = "lucide-gauge",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[System] AntiLag:", v) end
})

Window:AddModule(TabSystem, {
    Title       = "Anti Gamepl...",
    Description = "Remove the gameplay-paused overlay",
    Icon        = "Play",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[System] Anti Gameplay...", v) end
})

Window:AddModule(TabSystem, {
    Title       = "Auto-Rejoin",
    Description = "Rejoin automatically if you get kicked or disconnected",
    Icon        = "Refresh",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[System] Auto-Rejoin:", v) end
})

Window:AddModule(TabSystem, {
    Title       = "Clear Error",
    Description = "Dismiss the kick/disconnect error popup",
    Icon        = "Close",
    Type        = "Action",
    Callback    = function()
        VRSLib:Notify({ Title = "Clear Error", Description = "Dismissed kick / disconnect popup!", Duration = 2.5, Icon = "Close" })
    end
})

Window:AddModule(TabSystem, {
    Title       = "Rejoin",
    Description = "Rejoin the current server instance immediately",
    Icon        = "Refresh",
    Type        = "Action",
    Callback    = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
    end
})

Window:AddModule(TabSystem, {
    Title       = "Server Hop",
    Description = "Teleport to a random different server",
    Icon        = "World",
    Type        = "Action",
    Callback    = function()
        VRSLib:Notify({ Title = "Server Hop", Description = "Finding active server...", Duration = 3, Icon = "World" })
    end
})

Window:AddModule(TabSystem, {
    Title       = "Teleport Tool",
    Description = "Teleport once to the mouse — click, or assign a hotkey",
    Icon        = "lucide-mouse-pointer",
    Type        = "Action",
    Callback    = function()
        VRSLib:Notify({ Title = "Teleport Tool", Description = "Equipped Click Teleport tool.", Duration = 2.5, Icon = "Play" })
    end
})


-- ------------------------------------------------------------------------------
-- [ DUNGEON & RPG MODES — SUB-DROP & DUAL-COLUMN SPLIT SCREEN (ALA OBSIDIAN) ]
-- ------------------------------------------------------------------------------
Window:AddCategory("DUNGEON MODES", 30)

local TabDungeon = Window:AddTabGroup({
    Name = "Dungeon",
    Category = "DUNGEON MODES",
    Icon = "swords",
    LayoutOrder = 31
})

local SubAutoProg = TabDungeon:AddSubTab({ Name = "Auto Progress", Icon = "activity" })
local SubEvent    = TabDungeon:AddSubTab({ Name = "Event Raid",    Icon = "skull" })
local SubBoss     = TabDungeon:AddSubTab({ Name = "Boss Rush",     Icon = "flame" })
local SubChal     = TabDungeon:AddSubTab({ Name = "Challenge",     Icon = "trophy" })

-- ==============================================================================
-- [ SUB-TAB: AUTO PROGRESS — DUAL COLUMN SPLIT SCREEN ]
-- ==============================================================================
local LeftCol, RightCol = SubAutoProg:AddColumns()

-- [ Left Column - Box 1: Auto Progress Control ]
local ControlBox = LeftCol:AddGroupbox({ Title = "Auto Progress Control", Icon = "play" })

ControlBox:AddToggle({
    Title = "Enable Auto Progress",
    Default = false,
    Callback = function(v) print("[Auto Progress] Enabled:", v) end
})

ControlBox:AddButton({
    Title = "Start Auto Progress Now",
    Icon = "play",
    Callback = function()
        VRSLib:Notify({ Title = "Auto Progress", Description = "Started progression sequence!", Duration = 2.5, Icon = "play" })
    end
})

ControlBox:AddButton({
    Title = "Pause Auto Progress",
    Icon = "pause",
    Callback = function()
        VRSLib:Notify({ Title = "Auto Progress", Description = "Progress paused.", Duration = 2, Icon = "pause" })
    end
})

local statusRow = ControlBox:AddStatus({
    Label = "Status:",
    Status = "INACTIVE (Paused)",
    Color = Color3.fromRGB(255, 75, 75)
})

ControlBox:AddLabel("Current Step: #1 / #8 (Frostspire Bastion - Easy)")
ControlBox:AddLabel("Step Clears: 0 / 1 runs")
ControlBox:AddLabel("Lifetime Progression Clears: 0")
ControlBox:AddLabel("Next Dungeon: Frostspire Bastion (Normal)")

ControlBox:AddButton({
    Title = "Skip to Next Step",
    Icon = "arrow-right",
    Callback = function() print("[Auto Progress] Skipped step") end
})

ControlBox:AddButton({
    Title = "Previous Step",
    Icon = "arrow-left",
    Callback = function() print("[Auto Progress] Previous step") end
})

ControlBox:AddButton({
    Title = "Reset Progress to Step 1",
    Icon = "refresh-cw",
    Callback = function() print("[Auto Progress] Reset progress") end
})

-- [ Left Column - Box 2: Progression Queue ]
local QueueBox = LeftCol:AddGroupbox({ Title = "Progression Queue (Template Steps)", Icon = "list" })
QueueBox:AddQueueList({
    Items = {
        { Text = "[1] Frostspire Bastion (Easy) [0/1 runs]", IsActive = true },
        { Text = "[2] Frostspire Bastion (Normal) [1 run(s)]" },
        { Text = "[3] Frostspire Bastion (Hard) [1 run(s)]" },
        { Text = "[4] Frostspire Bastion (Nightmare) [1 run(s)]" },
        { Text = "[5] Underworld Gate (Easy) [1 run(s)]" },
        { Text = "[6] Underworld Gate (Normal) [1 run(s)]" },
        { Text = "[7] Underworld Gate (Hard) [1 run(s)]" },
        { Text = "[8] Underworld Gate (Nightmare) [1 run(s)]" },
    }
})

-- [ Right Column - Box 1: Progression Presets & Options ]
local PresetBox = RightCol:AddGroupbox({ Title = "Progression Presets & Options", Icon = "settings" })

PresetBox:AddDropdown({
    Title = "Template Preset",
    Values = { "Frostspire to Underworld", "Goblin Farm Route", "Daily Raid Rush" },
    Default = "Frostspire to Underworld",
    Callback = function(v) print("[Preset] Selected:", v) end
})

PresetBox:AddButton({
    Title = "Load Selected Preset",
    Icon = "download",
    Callback = function()
        VRSLib:Notify({ Title = "Presets", Description = "Loaded preset successfully!", Duration = 2.5, Icon = "check" })
    end
})

PresetBox:AddDropdown({
    Title = "When Template Finishes",
    Values = { "Loop to Step 1", "Stop Script", "Return to Lobby" },
    Default = "Loop to Step 1",
    Callback = function(v) print("[Option] On Finish:", v) end
})

PresetBox:AddToggle({
    Title = "Advance Only on Clear/Victory",
    Default = true,
    Callback = function(v) print("[Option] Advance on Clear:", v) end
})

PresetBox:AddSlider({
    Title = "Lobby Return Delay",
    Min = 1,
    Max = 15,
    Default = 4,
    Unit = "s",
    Callback = function(v) print("[Option] Return Delay:", v) end
})

PresetBox:AddSlider({
    Title = "Next Match Queue Delay",
    Min = 1,
    Max = 10,
    Default = 2,
    Unit = "s",
    Callback = function(v) print("[Option] Queue Delay:", v) end
})

-- [ Right Column - Box 2: Custom Step Builder ]
local BuilderBox = RightCol:AddGroupbox({ Title = "Custom Step Builder", Icon = "plus-circle" })

BuilderBox:AddDropdown({
    Title = "Map",
    Values = { "Goblin's Stronghold", "Frostspire Bastion", "Underworld Gate" },
    Default = "Goblin's Stronghold",
    Callback = function(v) print("[Builder] Map:", v) end
})

BuilderBox:AddDropdown({
    Title = "Difficulty",
    Values = { "Easy", "Normal", "Hard", "Nightmare" },
    Default = "Nightmare",
    Callback = function(v) print("[Builder] Difficulty:", v) end
})

BuilderBox:AddSlider({
    Title = "Target Runs to Clear",
    Min = 1,
    Max = 50,
    Default = 1,
    Unit = "runs",
    Callback = function(v) print("[Builder] Target Runs:", v) end
})

BuilderBox:AddButton({
    Title = "+ Add Step to Template",
    Icon = "plus",
    Callback = function()
        VRSLib:Notify({ Title = "Builder", Description = "Added step to template queue!", Duration = 2, Icon = "plus" })
    end
})

BuilderBox:AddButton({
    Title = "Remove Last Step",
    Icon = "x",
    Callback = function() print("[Builder] Removed last step") end
})

BuilderBox:AddButton({
    Title = "Clear All Steps",
    Icon = "trash",
    Callback = function() print("[Builder] Cleared all steps") end
})

-- ==============================================================================
-- [ SUB-TAB: EVENT RAID — MODULAR 4-COLUMN CARD GRID ]
-- ==============================================================================
Window:AddModule(SubEvent, {
    Title       = "Event Farm",
    Description = "Automatically farms limited seasonal event tokens and currencies",
    Icon        = "star",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Event] Farm:", v) end
})

Window:AddModule(SubEvent, {
    Title       = "Mini-Game Solver",
    Description = "Instantly clears event puzzle mini-games with 100% perfect score",
    Icon        = "target",
    Type        = "Action",
    Callback    = function()
        VRSLib:Notify({ Title = "Event", Description = "Solved mini-game with 100% score!", Duration = 2.5, Icon = "star" })
    end
})

-- ==============================================================================
-- [ SUB-TAB: BOSS RUSH — MODULAR 4-COLUMN CARD GRID ]
-- ==============================================================================
Window:AddModule(SubBoss, {
    Title       = "Boss Hitbox Ext",
    Description = "Extends world & raid boss hitboxes for safe long-distance melee hits",
    Icon        = "crosshair",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Boss] Hitbox Ext:", v) end
})

Window:AddModule(SubBoss, {
    Title       = "Auto Dodge Attacks",
    Description = "Automatically dodges boss red zone AoE attacks and dangerous projectiles",
    Icon        = "shield",
    Type        = "Toggle",
    Default     = false,
    Callback    = function(v) print("[Boss] Auto Dodge:", v) end
})

-- Notifikasi Sukses Load
VRSLib:Notify({
    Title       = "VRS Artelier",
    Description = "Loaded 53 modules successfully with Sub-Drop Accordion!\nToggle with RightControl or floating Wings button.\nPress [X] to unload.",
    Duration    = 4,
    Icon        = "Wings"
})
