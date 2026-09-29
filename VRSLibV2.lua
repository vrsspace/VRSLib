--[[
    ==============================================================================
    🌸 VRSLib V2 — NEXT-GEN OBSIDIAN & NEON PINK ROBLOX UI ENGINE
    ==============================================================================
    Engineered for maximum visual quality, 1:1 modern hub layout fidelity,
    ultra-smooth animations, responsive auto-scaling, and clean modular code.
    
    Features:
      • Modern Matte Obsidian UI (#0F1015) with Signature Neon Pink (#FF408C) Accents
      • 76px Floating Left Sidebar with Wings Brand Logo & User Profile Card
      • Active Tab indicator pill (smooth vertical pink glow bar)
      • Topbar with Header Icon, Title, Horizontal Sub-Nav Pills, Search Bar & Window Controls
      • Full Dashboard Suite:
          - User Welcome Card (Avatar headshot, display name, handle, streamer mode toggles)
          - 6-Box Stat Grid (Live Players, Friends, Execs, Session timer, FPS, Ping)
          - Game Info Card (Thumbnail, Developer, Job/Place/Universe IDs, Quick Server Actions)
          - Notice & Warning Banners (Status badge, RCtrl hotkey indicator)
          - Two-Column Quick Links (Discord, Supported Games, Copy buttons)
          - Feature List summary card
      • Standard Groupbox & Dual-Column Section Suite:
          - Toggles (Sleek animated neon pink pill switch)
          - Sliders (Draggable smooth progress bar with numeric readout)
          - Buttons (Interactive cards with hover glow and click tweens)
          - Dropdowns (Inline drop bars with search filter & multi-select)
          - Text Inputs, Keybinds, Paragraphs, Dividers
      • Built-in Toast Notifications with sliding animations
      • Draggable Window + Draggable Floating Logo Widget
      • Auto-Scaling for Mobile & Compact Screens (UIScale)
    ==============================================================================
]]

local cloneref = (cloneref or clonereference or function(i) return i end)
local CoreGui          = cloneref(game:GetService("CoreGui"))
local Players          = cloneref(game:GetService("Players"))
local TweenService     = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService       = cloneref(game:GetService("RunService"))
local HttpService      = cloneref(game:GetService("HttpService"))
local TeleportService  = cloneref(game:GetService("TeleportService"))
local LocalPlayer      = Players.LocalPlayer or Players.PlayerAdded:Wait()

local VRSLibV2 = {
    Version = "2.0.0",
    Theme = {
        Background        = Color3.fromRGB(15, 16, 21),       -- #0F1015 Deep Matte Obsidian
        Sidebar           = Color3.fromRGB(12, 13, 17),       -- #0C0D11 Dark Floating Sidebar
        SidebarHover      = Color3.fromRGB(22, 24, 32),
        SidebarActive     = Color3.fromRGB(26, 28, 38),
        Header            = Color3.fromRGB(15, 16, 21),
        Card              = Color3.fromRGB(20, 21, 28),       -- #14151C Clean Card Background
        CardHover         = Color3.fromRGB(27, 29, 39),
        CardStroke        = Color3.fromRGB(32, 35, 46),       -- #20232E Subtle border
        CardStrokeHover   = Color3.fromRGB(255, 64, 140),     -- Signature Pink Glow
        InputBackground   = Color3.fromRGB(16, 17, 23),
        InputStroke       = Color3.fromRGB(34, 37, 50),
        Accent            = Color3.fromRGB(255, 64, 140),     -- Signature Neon Pink (#FF408C)
        AccentHover       = Color3.fromRGB(255, 96, 162),
        AccentGlow        = Color3.fromRGB(255, 64, 140),
        TextPrimary       = Color3.fromRGB(245, 248, 255),    -- Crisp White
        TextSecondary     = Color3.fromRGB(165, 170, 190),    -- Slate Light
        TextMuted         = Color3.fromRGB(120, 125, 145),    -- Muted Gray
        Outline           = Color3.fromRGB(28, 30, 40),
        SwitchOff         = Color3.fromRGB(32, 34, 46),
        SwitchOffKnob     = Color3.fromRGB(140, 145, 165),
        SwitchOnKnob      = Color3.fromRGB(255, 255, 255),
        OnlineGreen       = Color3.fromRGB(46, 204, 113),     -- Online dot status
        WarningOrange     = Color3.fromRGB(255, 175, 60),
    },
    Windows = {},
}

-- Safe Container Resolver
local function GetSafeContainer()
    if gethui then
        return gethui()
    elseif syn and syn.protect_gui then
        local gui = Instance.new("ScreenGui")
        syn.protect_gui(gui)
        gui.Parent = CoreGui
        return gui
    end
    return CoreGui
end

local function ProtectLocalization(instance)
    pcall(function() instance.AutoLocalize = false end)
end

-- ==============================================================================
-- BRAND LOGO ENGINE
-- ==============================================================================
local BRAND_LOGO_URL = "https://raw.githubusercontent.com/vrsspace/VRSLib/v1.1.9/assets/logo.png"
local cachedLogoAsset = nil

local function GetBrandLogo()
    if cachedLogoAsset then return cachedLogoAsset end
    local fileName = "vrs_artelier_logo_v2.png"

    if writefile and isfile and (getcustomasset or getsynasset) then
        local customAsset = getcustomasset or getsynasset
        if not isfile(fileName) then
            pcall(function()
                local data = game:HttpGet(BRAND_LOGO_URL)
                if data and #data > 50 then
                    writefile(fileName, data)
                end
            end)
        end
        if isfile(fileName) then
            local ok, asset = pcall(function() return customAsset(fileName) end)
            if ok and asset then
                cachedLogoAsset = asset
                return asset
            end
        end
    end
    return "rbxassetid://132717088484517"
end

local function ApplyBrandLogo(imageLabel)
    local asset = GetBrandLogo()
    imageLabel.Image = asset
    if tostring(asset):find("132717088484517") then
        imageLabel.ImageRectOffset = Vector2.new(159, 225)
        imageLabel.ImageRectSize = Vector2.new(686, 535)
        imageLabel.ImageColor3 = VRSLibV2.Theme.Accent
    else
        imageLabel.ImageRectOffset = Vector2.new(0, 0)
        imageLabel.ImageRectSize = Vector2.new(0, 0)
        imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- ==============================================================================
-- LUCIDE ICONS ENGINE
-- ==============================================================================
VRSLibV2.Icons = (function()
    -- Try importing from local or repo
    local function TryLoad()
        pcall(function()
            if readfile and isfile and isfile("src/Icons.lua") then
                local res = loadstring(readfile("src/Icons.lua"))()
                if res then return res end
            end
        end)
        return nil
    end

    local loaded = TryLoad()
    if loaded then return loaded end

    -- Core High-Quality Lucide Asset Registry
    local Registry = {
        ["home"]              = "rbxassetid://10723407389",
        ["settings"]          = "rbxassetid://10734950309",
        ["swords"]            = "rbxassetid://10734975692",
        ["shield"]            = "rbxassetid://10734972879",
        ["users"]             = "rbxassetid://10734978081",
        ["user"]              = "rbxassetid://10734977977",
        ["clock"]             = "rbxassetid://10709791437",
        ["zap"]               = "rbxassetid://10734984533",
        ["activity"]          = "rbxassetid://10709769841",
        ["wifi"]              = "rbxassetid://10734983637",
        ["search"]            = "rbxassetid://10734943674",
        ["message-square"]    = "rbxassetid://10734887448",
        ["monitor"]           = "rbxassetid://10734898144",
        ["list"]              = "rbxassetid://10734883598",
        ["eye"]               = "rbxassetid://10723415175",
        ["eye-off"]           = "rbxassetid://10723415040",
        ["chevron-down"]      = "rbxassetid://10709790948",
        ["chevron-up"]        = "rbxassetid://10709791043",
        ["chevron-right"]     = "rbxassetid://10709791133",
        ["check"]             = "rbxassetid://10709790644",
        ["close"]             = "rbxassetid://10709791337",
        ["x"]                 = "rbxassetid://10709791337",
        ["minus"]             = "rbxassetid://10734896206",
        ["copy"]              = "rbxassetid://10709791866",
        ["refresh-cw"]        = "rbxassetid://10734940382",
        ["play"]              = "rbxassetid://10734923549",
        ["folder"]            = "rbxassetid://10723424505",
        ["cloud"]             = "rbxassetid://10709791698",
        ["shopping-bag"]      = "rbxassetid://10734973457",
        ["crosshair"]         = "rbxassetid://10709792487",
        ["bell"]              = "rbxassetid://10709775269",
        ["wrench"]            = "rbxassetid://10734984112",
        ["lock"]              = "rbxassetid://10734884000",
        ["unlock"]            = "rbxassetid://10734982755",
        ["grid"]              = "rbxassetid://10723425515",
        ["sliders"]           = "rbxassetid://10734974868",
        ["trash"]             = "rbxassetid://10734977456",
        ["info"]              = "rbxassetid://10723415903",
        ["server"]            = "rbxassetid://10734963400",
    }

    local Engine = {
        Wings   = "rbxassetid://132717088484517",
        Default = "rbxassetid://10709782497",
        Get = function(name)
            if not name or name == "" then return "rbxassetid://10709782497" end
            local s = tostring(name):lower():gsub("^lucide%-", ""):gsub("[%s%_%-]", "")
            if Registry[s] then return Registry[s] end
            if tostring(name):sub(1, 13) == "rbxassetid://" then return name end
            for k, v in pairs(Registry) do
                if k:gsub("[%s%_%-]", "") == s then return v end
            end
            return "rbxassetid://10709782497"
        end
    }
    return Engine
end)()

-- ==============================================================================
-- DRAG & TWEEN UTILITIES
-- ==============================================================================
local function MakeDraggable(handle, targetFrame)
    local dragging = false
    local dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y

            TweenService:Create(targetFrame, TweenInfo.new(0.04, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
            }):Play()
        end
    end)
end

-- ==============================================================================
-- FLOATING TOAST NOTIFICATION SYSTEM
-- ==============================================================================
local NotifyContainer = nil
local function EnsureNotifyContainer()
    if NotifyContainer and NotifyContainer.Parent then return NotifyContainer end
    local sg = Instance.new("ScreenGui")
    sg.Name = "VRSV2_Notifications"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = GetSafeContainer()

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 1, -40)
    frame.Position = UDim2.new(1, -335, 0, 20)
    frame.BackgroundTransparency = 1
    frame.Parent = sg

    local list = Instance.new("UIListLayout")
    list.VerticalAlignment = Enum.VerticalAlignment.Bottom
    list.Padding = UDim.new(0, 8)
    list.Parent = frame

    NotifyContainer = frame
    return NotifyContainer
end

function VRSLibV2:Notify(cfg)
    cfg = cfg or {}
    local title = tostring(cfg.Title or "VRS Artelier V2")
    local desc  = tostring(cfg.Description or cfg.Content or "")
    local dur   = tonumber(cfg.Duration) or 3.5
    local iconId = VRSLibV2.Icons.Get(cfg.Icon or "Wings")

    local container = EnsureNotifyContainer()

    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(1, 0, 0, 60)
    toast.Position = UDim2.new(1, 350, 0, 0)
    toast.BackgroundColor3 = VRSLibV2.Theme.Card
    toast.BorderSizePixel = 0
    toast.ClipsDescendants = true
    toast.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toast

    local stroke = Instance.new("UIStroke")
    stroke.Color = VRSLibV2.Theme.CardStroke
    stroke.Thickness = 1
    stroke.Parent = toast

    -- Pink Glowing Accent Bar on left
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = VRSLibV2.Theme.Accent
    bar.BorderSizePixel = 0
    bar.Parent = toast

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(1, 0)
    bCorner.Parent = bar

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.fromOffset(24, 24)
    icon.Position = UDim2.new(0, 16, 0.5, -12)
    icon.BackgroundTransparency = 1
    if tostring(iconId):lower():find("wings") then
        ApplyBrandLogo(icon)
    else
        icon.Image = iconId
        icon.ImageColor3 = VRSLibV2.Theme.Accent
    end
    icon.Parent = toast

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -55, 0, 18)
    tLbl.Position = UDim2.new(0, 48, 0, 11)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 13.5
    tLbl.TextColor3 = VRSLibV2.Theme.TextPrimary
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = toast
    ProtectLocalization(tLbl)

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(1, -55, 0, 16)
    dLbl.Position = UDim2.new(0, 48, 0, 31)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = desc
    dLbl.Font = Enum.Font.GothamMedium
    dLbl.TextSize = 11.5
    dLbl.TextColor3 = VRSLibV2.Theme.TextSecondary
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.TextTruncate = Enum.TextTruncate.AtEnd
    dLbl.Parent = toast
    ProtectLocalization(dLbl)

    TweenService:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.delay(dur, function()
        if toast and toast.Parent then
            local tw = TweenService:Create(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 350, 0, 0)
            })
            tw:Play()
            tw.Completed:Connect(function() toast:Destroy() end)
        end
    end)
end

-- ==============================================================================
-- WINDOW CLASS
-- ==============================================================================
local Window = {}
Window.__index = Window

function Window:Notify(...)
    return VRSLibV2:Notify(...)
end

function Window:Toggle()
    self.Visible = not self.Visible
    self.MainFrame.Visible = self.Visible
    if self.FloatingToggle then
        self.FloatingToggle.Visible = not self.Visible
    end
end

function Window:Unload()
    if self.OnUnload then pcall(self.OnUnload) end
    if self.Gui then self.Gui:Destroy() end
    if NotifyContainer and NotifyContainer.Parent then
        pcall(function() NotifyContainer.Parent:Destroy() end)
    end
end

-- ==============================================================================
-- CREATE WINDOW CONSTRUCTOR
-- ==============================================================================
function VRSLibV2:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, Window)

    -- Auto-detect Game Name
    local detectedGame = "Roblox"
    pcall(function()
        local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        if info and info.Name and info.Name ~= "" then
            detectedGame = info.Name
        end
    end)
    self.GameName = config.GameName or detectedGame

    local rawTitle = config.Title
    if not rawTitle or rawTitle == "" or rawTitle == "auto" then
        self.Title = "Welcome to " .. self.GameName .. "!"
    else
        self.Title = string.gsub(tostring(rawTitle), "{game}", self.GameName)
    end

    self.SubTitle    = config.SubTitle or "v0.141"
    self.Size        = config.Size or UDim2.fromOffset(1020, 620)
    self.Keybind     = config.Keybind or Enum.KeyCode.RightControl
    self.Visible     = true
    self.ActiveTab   = nil
    self.Tabs        = {}
    self.AllElements = {}

    if config.Accent then
        VRSLibV2.Theme.Accent = config.Accent
        VRSLibV2.Theme.CardStrokeHover = config.Accent
    end

    local safeContainer = GetSafeContainer()
    for _, old in ipairs(safeContainer:GetChildren()) do
        if old.Name == "VRSLibV2_Engine" then
            pcall(function() old:Destroy() end)
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VRSLibV2_Engine"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = safeContainer
    self.Gui = ScreenGui

    ScreenGui.DescendantAdded:Connect(ProtectLocalization)

    -- Floating Wings Widget (When minimized)
    local FloatingToggle = Instance.new("ImageButton")
    FloatingToggle.Name = "VRSV2_FloatingLogo"
    FloatingToggle.Size = UDim2.fromOffset(48, 48)
    FloatingToggle.Position = UDim2.new(0, 20, 0.45, 0)
    FloatingToggle.BackgroundColor3 = VRSLibV2.Theme.Sidebar
    FloatingToggle.BorderSizePixel = 0
    FloatingToggle.Visible = false
    FloatingToggle.Parent = ScreenGui

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(1, 0)
    FloatCorner.Parent = FloatingToggle

    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Color = VRSLibV2.Theme.Accent
    FloatStroke.Thickness = 1.5
    FloatStroke.Parent = FloatingToggle

    local FloatLogo = Instance.new("ImageLabel")
    FloatLogo.Size = UDim2.fromOffset(28, 22)
    FloatLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    FloatLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    FloatLogo.BackgroundTransparency = 1
    ApplyBrandLogo(FloatLogo)
    FloatLogo.Parent = FloatingToggle

    MakeDraggable(FloatingToggle, FloatingToggle)
    FloatingToggle.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    self.FloatingToggle = FloatingToggle

    -- Main Shell Frame
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = self.Size
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundColor3 = VRSLibV2.Theme.Background
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    self.MainFrame = Main

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = VRSLibV2.Theme.CardStroke
    MainStroke.Thickness = 1
    MainStroke.Parent = Main

    -- Responsive Smart Scaling Engine
    local WindowScale = Instance.new("UIScale")
    WindowScale.Name = "WindowScale"
    WindowScale.Scale = 1.0
    WindowScale.Parent = Main
    self.UIScale = WindowScale

    local function UpdateScale()
        local cam = workspace.CurrentCamera
        local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
        if vp.X > 0 and vp.Y > 0 then
            local maxW = vp.X - 30
            local maxH = vp.Y - 30
            local scaleX = maxW / self.Size.X.Offset
            local scaleY = maxH / self.Size.Y.Offset
            local ideal = math.min(1.0, math.min(scaleX, scaleY))
            WindowScale.Scale = math.clamp(ideal, 0.5, 1.0)
        end
    end
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(UpdateScale)
    ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateScale)
    UpdateScale()

    -- ==============================================================================
    -- LEFT FLOATING SIDEBAR (76px width)
    -- ==============================================================================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 76, 1, 0)
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.BackgroundColor3 = VRSLibV2.Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    self.Sidebar = Sidebar

    local SidebarBorder = Instance.new("Frame")
    SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    SidebarBorder.Position = UDim2.new(1, -1, 0, 0)
    SidebarBorder.BackgroundColor3 = VRSLibV2.Theme.CardStroke
    SidebarBorder.BorderSizePixel = 0
    SidebarBorder.Parent = Sidebar

    -- Top Logo Emblem
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Name = "LogoContainer"
    LogoContainer.Size = UDim2.new(1, 0, 0, 68)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Parent = Sidebar

    local LogoBadge = Instance.new("Frame")
    LogoBadge.Size = UDim2.fromOffset(42, 42)
    LogoBadge.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoBadge.Position = UDim2.new(0.5, 0, 0.5, 2)
    LogoBadge.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    LogoBadge.BorderSizePixel = 0
    LogoBadge.Parent = LogoContainer

    local LBCorner = Instance.new("UICorner")
    LBCorner.CornerRadius = UDim.new(0, 12)
    LBCorner.Parent = LogoBadge

    local LBStroke = Instance.new("UIStroke")
    LBStroke.Color = VRSLibV2.Theme.CardStroke
    LBStroke.Thickness = 1
    LBStroke.Parent = LogoBadge

    local LogoImg = Instance.new("ImageLabel")
    LogoImg.Size = UDim2.fromOffset(26, 20)
    LogoImg.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogoImg.BackgroundTransparency = 1
    ApplyBrandLogo(LogoImg)
    LogoImg.Parent = LogoBadge

    LogoContainer.MouseEnter:Connect(function()
        TweenService:Create(LBStroke, TweenInfo.new(0.2), { Color = VRSLibV2.Theme.Accent }):Play()
        TweenService:Create(LogoImg, TweenInfo.new(0.2), { Size = UDim2.fromOffset(29, 23) }):Play()
    end)
    LogoContainer.MouseLeave:Connect(function()
        TweenService:Create(LBStroke, TweenInfo.new(0.2), { Color = VRSLibV2.Theme.CardStroke }):Play()
        TweenService:Create(LogoImg, TweenInfo.new(0.2), { Size = UDim2.fromOffset(26, 20) }):Play()
    end)

    -- Tab Buttons Scroll
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Size = UDim2.new(1, 0, 1, -134)
    TabScroll.Position = UDim2.new(0, 0, 0, 70)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabScroll.Parent = Sidebar
    self.TabScroll = TabScroll

    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Padding = UDim.new(0, 6)
    TabList.Parent = TabScroll

    -- Bottom User Profile Card
    local UserProfileBar = Instance.new("Frame")
    UserProfileBar.Name = "UserProfileBar"
    UserProfileBar.Size = UDim2.new(1, 0, 0, 64)
    UserProfileBar.Position = UDim2.new(0, 0, 1, -64)
    UserProfileBar.BackgroundColor3 = VRSLibV2.Theme.Sidebar
    UserProfileBar.BorderSizePixel = 0
    UserProfileBar.Parent = Sidebar

    local UPBorder = Instance.new("Frame")
    UPBorder.Size = UDim2.new(1, 0, 0, 1)
    UPBorder.BackgroundColor3 = VRSLibV2.Theme.CardStroke
    UPBorder.BorderSizePixel = 0
    UPBorder.Parent = UserProfileBar

    local AvatarBox = Instance.new("Frame")
    AvatarBox.Size = UDim2.fromOffset(34, 34)
    AvatarBox.Position = UDim2.new(0.5, -17, 0, 8)
    AvatarBox.BackgroundColor3 = VRSLibV2.Theme.Card
    AvatarBox.BorderSizePixel = 0
    AvatarBox.Parent = UserProfileBar

    local ABCorner = Instance.new("UICorner")
    ABCorner.CornerRadius = UDim.new(1, 0)
    ABCorner.Parent = AvatarBox

    local ABStroke = Instance.new("UIStroke")
    ABStroke.Color = VRSLibV2.Theme.CardStroke
    ABStroke.Thickness = 1
    ABStroke.Parent = AvatarBox

    local UserThumb = Instance.new("ImageLabel")
    UserThumb.Size = UDim2.new(1, 0, 1, 0)
    UserThumb.BackgroundTransparency = 1
    UserThumb.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    UserThumb.Parent = AvatarBox

    local UTCorner = Instance.new("UICorner")
    UTCorner.CornerRadius = UDim.new(1, 0)
    UTCorner.Parent = UserThumb

    -- Green Online Status Dot
    local OnlineDot = Instance.new("Frame")
    OnlineDot.Size = UDim2.fromOffset(9, 9)
    OnlineDot.AnchorPoint = Vector2.new(1, 1)
    OnlineDot.Position = UDim2.new(1, 1, 1, 1)
    OnlineDot.BackgroundColor3 = VRSLibV2.Theme.OnlineGreen
    OnlineDot.BorderSizePixel = 0
    OnlineDot.Parent = AvatarBox

    local ODCorner = Instance.new("UICorner")
    ODCorner.CornerRadius = UDim.new(1, 0)
    ODCorner.Parent = OnlineDot

    local ODStroke = Instance.new("UIStroke")
    ODStroke.Color = VRSLibV2.Theme.Sidebar
    ODStroke.Thickness = 1.5
    ODStroke.Parent = OnlineDot

    local UNameLbl = Instance.new("TextLabel")
    UNameLbl.Size = UDim2.new(1, -6, 0, 12)
    UNameLbl.Position = UDim2.new(0, 3, 0, 46)
    UNameLbl.BackgroundTransparency = 1
    local rawName = tostring(LocalPlayer.DisplayName or LocalPlayer.Name)
    UNameLbl.Text = (#rawName > 7) and (rawName:sub(1, 6) .. "..") or rawName
    UNameLbl.Font = Enum.Font.GothamBold
    UNameLbl.TextSize = 10
    UNameLbl.TextColor3 = VRSLibV2.Theme.TextPrimary
    UNameLbl.TextXAlignment = Enum.TextXAlignment.Center
    UNameLbl.Parent = UserProfileBar
    ProtectLocalization(UNameLbl)

    -- ==============================================================================
    -- TOP HEADER BAR (Matching Screenshot 1 & 2)
    -- ==============================================================================
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, -76, 0, 52)
    Topbar.Position = UDim2.new(0, 76, 0, 0)
    Topbar.BackgroundColor3 = VRSLibV2.Theme.Header
    Topbar.BorderSizePixel = 0
    Topbar.Parent = Main
    self.Topbar = Topbar

    local TopbarBorder = Instance.new("Frame")
    TopbarBorder.Size = UDim2.new(1, 0, 0, 1)
    TopbarBorder.Position = UDim2.new(0, 0, 1, -1)
    TopbarBorder.BackgroundColor3 = VRSLibV2.Theme.CardStroke
    TopbarBorder.BorderSizePixel = 0
    TopbarBorder.Parent = Topbar

    MakeDraggable(Topbar, Main)

    -- Left: Tab Icon + Title + Horizontal Subnav Pills
    local HeaderLeft = Instance.new("Frame")
    HeaderLeft.Name = "HeaderLeft"
    HeaderLeft.Size = UDim2.new(1, -260, 1, 0)
    HeaderLeft.Position = UDim2.new(0, 16, 0, 0)
    HeaderLeft.BackgroundTransparency = 1
    HeaderLeft.Parent = Topbar

    local HLList = Instance.new("UIListLayout")
    HLList.FillDirection = Enum.FillDirection.Horizontal
    HLList.VerticalAlignment = Enum.VerticalAlignment.Center
    HLList.Padding = UDim.new(0, 12)
    HLList.Parent = HeaderLeft

    local HeaderIcon = Instance.new("ImageLabel")
    HeaderIcon.Name = "HeaderIcon"
    HeaderIcon.Size = UDim2.fromOffset(20, 20)
    HeaderIcon.BackgroundTransparency = 1
    HeaderIcon.Image = VRSLibV2.Icons.Get("home")
    HeaderIcon.ImageColor3 = VRSLibV2.Theme.TextPrimary
    HeaderIcon.Parent = HeaderLeft
    self.HeaderIcon = HeaderIcon

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Name = "HeaderTitle"
    HeaderTitle.Size = UDim2.new(0, 0, 1, 0)
    HeaderTitle.AutomaticSize = Enum.AutomaticSize.X
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Text = self.Title
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.TextSize = 14.5
    HeaderTitle.TextColor3 = VRSLibV2.Theme.TextPrimary
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.Parent = HeaderLeft
    ProtectLocalization(HeaderTitle)
    self.HeaderTitle = HeaderTitle

    -- Sub-Tab Horizontal Pills (e.g. [ ⊞ Overview ] [ ▷ Main Menu ])
    local SubNavPills = Instance.new("Frame")
    SubNavPills.Name = "SubNavPills"
    SubNavPills.Size = UDim2.new(0, 0, 1, 0)
    SubNavPills.AutomaticSize = Enum.AutomaticSize.X
    SubNavPills.BackgroundTransparency = 1
    SubNavPills.Parent = HeaderLeft
    self.SubNavPills = SubNavPills

    local SNPList = Instance.new("UIListLayout")
    SNPList.FillDirection = Enum.FillDirection.Horizontal
    SNPList.VerticalAlignment = Enum.VerticalAlignment.Center
    SNPList.Padding = UDim.new(0, 8)
    SNPList.Parent = SubNavPills

    -- Right: Search Box + Window Controls
    local HeaderRight = Instance.new("Frame")
    HeaderRight.Name = "HeaderRight"
    HeaderRight.Size = UDim2.new(0, 240, 1, 0)
    HeaderRight.Position = UDim2.new(1, -240, 0, 0)
    HeaderRight.BackgroundTransparency = 1
    HeaderRight.Parent = Topbar

    local HRList = Instance.new("UIListLayout")
    HRList.FillDirection = Enum.FillDirection.Horizontal
    HRList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    HRList.VerticalAlignment = Enum.VerticalAlignment.Center
    HRList.Padding = UDim.new(0, 12)
    HRList.Parent = HeaderRight

    local HRPadding = Instance.new("UIPadding")
    HRPadding.PaddingRight = UDim.new(0, 16)
    HRPadding.Parent = HeaderRight

    -- Search Input Capsule
    local SearchBox = Instance.new("Frame")
    SearchBox.Name = "SearchBox"
    SearchBox.Size = UDim2.new(0, 140, 0, 28)
    SearchBox.BackgroundColor3 = VRSLibV2.Theme.InputBackground
    SearchBox.BorderSizePixel = 0
    SearchBox.Parent = HeaderRight

    local SBCorner = Instance.new("UICorner")
    SBCorner.CornerRadius = UDim.new(0, 6)
    SBCorner.Parent = SearchBox

    local SBStroke = Instance.new("UIStroke")
    SBStroke.Color = VRSLibV2.Theme.InputStroke
    SBStroke.Thickness = 1
    SBStroke.Parent = SearchBox

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.fromOffset(13, 13)
    SearchIcon.Position = UDim2.new(0, 8, 0.5, -6.5)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = VRSLibV2.Icons.Get("search")
    SearchIcon.ImageColor3 = VRSLibV2.Theme.TextMuted
    SearchIcon.Parent = SearchBox

    local SearchInput = Instance.new("TextBox")
    SearchInput.Size = UDim2.new(1, -30, 1, 0)
    SearchInput.Position = UDim2.new(0, 26, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.Font = Enum.Font.GothamMedium
    SearchInput.PlaceholderText = "Search..."
    SearchInput.PlaceholderColor3 = VRSLibV2.Theme.TextMuted
    SearchInput.Text = ""
    SearchInput.TextColor3 = VRSLibV2.Theme.TextPrimary
    SearchInput.TextSize = 12
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.ClearTextOnFocus = false
    SearchInput.Parent = SearchBox
    ProtectLocalization(SearchInput)

    SearchInput.Focused:Connect(function()
        TweenService:Create(SBStroke, TweenInfo.new(0.15), { Color = VRSLibV2.Theme.Accent }):Play()
        TweenService:Create(SearchIcon, TweenInfo.new(0.15), { ImageColor3 = VRSLibV2.Theme.Accent }):Play()
    end)
    SearchInput.FocusLost:Connect(function()
        TweenService:Create(SBStroke, TweenInfo.new(0.15), { Color = VRSLibV2.Theme.InputStroke }):Play()
        TweenService:Create(SearchIcon, TweenInfo.new(0.15), { ImageColor3 = VRSLibV2.Theme.TextMuted }):Play()
    end)

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        self:FilterCards(SearchInput.Text)
    end)

    -- Window Minimize & Close Controls
    local Controls = Instance.new("Frame")
    Controls.Size = UDim2.new(0, 56, 1, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = HeaderRight

    local CList = Instance.new("UIListLayout")
    CList.FillDirection = Enum.FillDirection.Horizontal
    CList.VerticalAlignment = Enum.VerticalAlignment.Center
    CList.Padding = UDim.new(0, 4)
    CList.Parent = Controls

    local function MakeControlBtn(iconKey, onClick)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(26, 26)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = Controls

        local ic = Instance.new("ImageLabel")
        ic.Size = UDim2.fromOffset(13, 13)
        ic.Position = UDim2.new(0.5, -6.5, 0.5, -6.5)
        ic.BackgroundTransparency = 1
        ic.Image = VRSLibV2.Icons.Get(iconKey)
        ic.ImageColor3 = VRSLibV2.Theme.TextMuted
        ic.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(ic, TweenInfo.new(0.15), { ImageColor3 = VRSLibV2.Theme.TextPrimary }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(ic, TweenInfo.new(0.15), { ImageColor3 = VRSLibV2.Theme.TextMuted }):Play()
        end)
        btn.MouseButton1Click:Connect(onClick)
        return btn
    end

    MakeControlBtn("minus", function() self:Toggle() end)
    MakeControlBtn("close", function() self:Unload() end)

    -- ==============================================================================
    -- MAIN CONTENT CONTAINER
    -- ==============================================================================
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -76, 1, -52)
    Content.Position = UDim2.new(0, 76, 0, 52)
    Content.BackgroundTransparency = 1
    Content.Parent = Main
    self.Content = Content

    -- Keybind Listener
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == self.Keybind then
            self:Toggle()
        end
    end)

    table.insert(VRSLibV2.Windows, self)
    return self
end

-- ==============================================================================
-- SEARCH FILTERING ENGINE
-- ==============================================================================
function Window:FilterCards(query)
    query = tostring(query or ""):lower():gsub("%s+", "")
    for _, item in ipairs(self.AllElements) do
        if item.Frame and item.SearchText then
            if query == "" then
                item.Frame.Visible = true
            else
                local match = item.SearchText:lower():gsub("%s+", ""):find(query, 1, true) ~= nil
                item.Frame.Visible = match
            end
        end
    end
end

-- ==============================================================================
-- TAB BUILDER & NAVIGATION
-- ==============================================================================
function Window:AddTab(config)
    config = config or {}
    local tabName = config.Name or "Tab"
    local iconId  = VRSLibV2.Icons.Get(config.Icon or "home")

    -- Tab Button in 76px Sidebar
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = "TabBtn_" .. tabName
    TabBtn.Size = UDim2.new(0, 60, 0, 50)
    TabBtn.BackgroundColor3 = VRSLibV2.Theme.Sidebar
    TabBtn.BackgroundTransparency = 1
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = ""
    TabBtn.LayoutOrder = config.LayoutOrder or (#self.Tabs + 1)
    TabBtn.Parent = self.TabScroll

    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(0, 8)
    TBCorner.Parent = TabBtn

    -- Signature Left Pink Glow Indicator Pill (Identical to Screenshot!)
    local Indicator = Instance.new("Frame")
    Indicator.Name = "ActiveIndicator"
    Indicator.Size = UDim2.new(0, 3, 0, 22)
    Indicator.Position = UDim2.new(0, 2, 0.5, -11)
    Indicator.BackgroundColor3 = VRSLibV2.Theme.Accent
    Indicator.BorderSizePixel = 0
    Indicator.Visible = false
    Indicator.Parent = TabBtn

    local ICorner = Instance.new("UICorner")
    ICorner.CornerRadius = UDim.new(1, 0)
    ICorner.Parent = Indicator

    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.fromOffset(20, 20)
    TabIcon.Position = UDim2.new(0.5, -10, 0, 7)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Image = iconId
    TabIcon.ImageColor3 = VRSLibV2.Theme.TextMuted
    TabIcon.Parent = TabBtn

    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -4, 0, 14)
    TabLabel.Position = UDim2.new(0, 2, 0, 29)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = tabName
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.TextSize = 10
    TabLabel.TextColor3 = VRSLibV2.Theme.TextMuted
    TabLabel.TextXAlignment = Enum.TextXAlignment.Center
    TabLabel.Parent = TabBtn
    ProtectLocalization(TabLabel)

    -- Tab Content Scroll Frame
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = "TabPage_" .. tabName
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.BorderSizePixel = 0
    TabPage.ScrollBarThickness = 3
    TabPage.ScrollBarImageColor3 = VRSLibV2.Theme.CardStroke
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabPage.Visible = false
    TabPage.Parent = self.Content

    local TPPadding = Instance.new("UIPadding")
    TPPadding.PaddingLeft = UDim.new(0, 18)
    TPPadding.PaddingRight = UDim.new(0, 18)
    TPPadding.PaddingTop = UDim.new(0, 14)
    TPPadding.PaddingBottom = UDim.new(0, 24)
    TPPadding.Parent = TabPage

    local TPLayout = Instance.new("UIListLayout")
    TPLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TPLayout.Padding = UDim.new(0, 12)
    TPLayout.Parent = TabPage

    local TabObj = {
        Window    = self,
        Name      = tabName,
        IconId    = iconId,
        Button    = TabBtn,
        Icon      = TabIcon,
        Label     = TabLabel,
        Indicator = Indicator,
        Page      = TabPage,
        SubTabs   = {},
    }

    TabBtn.MouseEnter:Connect(function()
        if self.ActiveTab ~= TabObj then
            TweenService:Create(TabBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.5, BackgroundColor3 = VRSLibV2.Theme.SidebarHover }):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.15), { ImageColor3 = Color3.fromRGB(220, 225, 240) }):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(220, 225, 240) }):Play()
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if self.ActiveTab ~= TabObj then
            TweenService:Create(TabBtn, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.15), { ImageColor3 = VRSLibV2.Theme.TextMuted }):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.15), { TextColor3 = VRSLibV2.Theme.TextMuted }):Play()
        end
    end)
    TabBtn.MouseButton1Click:Connect(function()
        self:SelectTab(TabObj)
    end)

    -- Attach Modules
    self:BindTabMethods(TabObj)
    table.insert(self.Tabs, TabObj)

    if not self.ActiveTab then
        self:SelectTab(TabObj)
    end

    return TabObj
end

-- Tab Selection
function Window:SelectTab(targetTab)
    self.ActiveTab = targetTab

    for _, t in ipairs(self.Tabs) do
        local isActive = (t == targetTab)
        t.Page.Visible = isActive
        t.Indicator.Visible = isActive

        if isActive then
            TweenService:Create(t.Button, TweenInfo.new(0.15), { BackgroundTransparency = 0.3, BackgroundColor3 = VRSLibV2.Theme.SidebarActive }):Play()
            TweenService:Create(t.Icon, TweenInfo.new(0.15), { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
            TweenService:Create(t.Label, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
            self.HeaderIcon.Image = t.IconId
        else
            TweenService:Create(t.Button, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(t.Icon, TweenInfo.new(0.15), { ImageColor3 = VRSLibV2.Theme.TextMuted }):Play()
            TweenService:Create(t.Label, TweenInfo.new(0.15), { TextColor3 = VRSLibV2.Theme.TextMuted }):Play()
        end
    end

    -- Render Sub-Nav Horizontal Pills if this tab has subtabs
    self:RenderSubNavPills(targetTab)
end

-- Horizontal Sub-Nav Pills Manager
function Window:RenderSubNavPills(tabObj)
    for _, ch in ipairs(self.SubNavPills:GetChildren()) do
        if ch:IsA("TextButton") then ch:Destroy() end
    end

    if #tabObj.SubTabs > 0 then
        for _, sub in ipairs(tabObj.SubTabs) do
            local pill = Instance.new("TextButton")
            pill.Name = "Pill_" .. sub.Name
            pill.Size = UDim2.new(0, 0, 0, 26)
            pill.AutomaticSize = Enum.AutomaticSize.X
            pill.BackgroundColor3 = (sub.Active and Color3.fromRGB(28, 30, 42) or Color3.fromRGB(18, 19, 25))
            pill.BorderSizePixel = 0
            pill.Text = ""
            pill.AutoButtonColor = false
            pill.Parent = self.SubNavPills

            local pCorner = Instance.new("UICorner")
            pCorner.CornerRadius = UDim.new(0, 6)
            pCorner.Parent = pill

            local pStroke = Instance.new("UIStroke")
            pStroke.Color = (sub.Active and VRSLibV2.Theme.Accent or VRSLibV2.Theme.CardStroke)
            pStroke.Thickness = 1
            pStroke.Parent = pill

            local pPadding = Instance.new("UIPadding")
            pPadding.PaddingLeft = UDim.new(0, 10)
            pPadding.PaddingRight = UDim.new(0, 10)
            pPadding.Parent = pill

            local pLayout = Instance.new("UIListLayout")
            pLayout.FillDirection = Enum.FillDirection.Horizontal
            pLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            pLayout.Padding = UDim.new(0, 6)
            pLayout.Parent = pill

            if sub.Icon then
                local pIcon = Instance.new("ImageLabel")
                pIcon.Size = UDim2.fromOffset(13, 13)
                pIcon.BackgroundTransparency = 1
                pIcon.Image = VRSLibV2.Icons.Get(sub.Icon)
                pIcon.ImageColor3 = (sub.Active and Color3.fromRGB(255, 255, 255) or VRSLibV2.Theme.TextMuted)
                pIcon.Parent = pill
            end

            local pText = Instance.new("TextLabel")
            pText.Size = UDim2.new(0, 0, 1, 0)
            pText.AutomaticSize = Enum.AutomaticSize.X
            pText.BackgroundTransparency = 1
            pText.Text = sub.Name
            pText.Font = Enum.Font.GothamBold
            pText.TextSize = 11
            pText.TextColor3 = (sub.Active and Color3.fromRGB(255, 255, 255) or VRSLibV2.Theme.TextSecondary)
            pText.Parent = pill
            ProtectLocalization(pText)

            pill.MouseButton1Click:Connect(function()
                for _, s in ipairs(tabObj.SubTabs) do
                    s.Active = (s == sub)
                    if s.Container then s.Container.Visible = (s == sub) end
                end
                self:RenderSubNavPills(tabObj)
                if sub.Callback then sub.Callback() end
            end)
        end
    end
end

-- ==============================================================================
-- TAB MODULE ATTACHMENTS (DASHBOARD SUITE + SECTION SUITE)
-- ==============================================================================
function Window:BindTabMethods(TabObj)
    local targetPage = TabObj.Page

    -- Add SubTab Pill helper
    function TabObj:AddSubTab(cfg)
        cfg = cfg or {}
        local subName = cfg.Name or "SubTab"
        local isFirst = (#self.SubTabs == 0)

        local subContainer = Instance.new("Frame")
        subContainer.Name = "SubPage_" .. subName
        subContainer.Size = UDim2.new(1, 0, 0, 0)
        subContainer.AutomaticSize = Enum.AutomaticSize.Y
        subContainer.BackgroundTransparency = 1
        subContainer.Visible = isFirst
        subContainer.Parent = targetPage

        local sLayout = Instance.new("UIListLayout")
        sLayout.SortOrder = Enum.SortOrder.LayoutOrder
        sLayout.Padding = UDim.new(0, 12)
        sLayout.Parent = subContainer

        local subObj = {
            Name = subName,
            Icon = cfg.Icon,
            Active = isFirst,
            Container = subContainer,
            Callback = cfg.Callback,
        }
        table.insert(self.SubTabs, subObj)
        self.Window:RenderSubNavPills(self)

        -- Allow building UI inside SubContainer
        local subBuilder = {}
        for k, v in pairs(self) do
            if type(v) == "function" and k ~= "AddSubTab" then
                subBuilder[k] = function(_, ...)
                    return v(subObj, ...)
                end
            end
        end
        return subBuilder
    end

    -- ==========================================================================
    -- 1. USER WELCOME CARD (Screenshot 1 Identical Recreation)
    -- ==========================================================================
    function TabObj:AddUserCard(config)
        config = config or {}
        local parentFrame = (self.Container or targetPage)

        local Card = Instance.new("Frame")
        Card.Name = "UserCard"
        Card.Size = UDim2.new(1, 0, 0, 84)
        Card.BackgroundColor3 = VRSLibV2.Theme.Card
        Card.BorderSizePixel = 0
        Card.LayoutOrder = config.LayoutOrder or 1
        Card.Parent = parentFrame

        local CCorner = Instance.new("UICorner")
        CCorner.CornerRadius = UDim.new(0, 10)
        CCorner.Parent = Card

        local CStroke = Instance.new("UIStroke")
        CStroke.Color = VRSLibV2.Theme.CardStroke
        CStroke.Thickness = 1
        CStroke.Parent = Card

        local CPadding = Instance.new("UIPadding")
        CPadding.PaddingLeft = UDim.new(0, 16)
        CPadding.PaddingRight = UDim.new(0, 16)
        CPadding.PaddingTop = UDim.new(0, 14)
        CPadding.PaddingBottom = UDim.new(0, 14)
        CPadding.Parent = Card

        -- Circular Avatar
        local Avatar = Instance.new("ImageLabel")
        Avatar.Name = "Avatar"
        Avatar.Size = UDim2.fromOffset(56, 56)
        Avatar.Position = UDim2.new(0, 0, 0.5, -28)
        Avatar.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
        Avatar.BorderSizePixel = 0
        Avatar.Parent = Card

        local ACorner = Instance.new("UICorner")
        ACorner.CornerRadius = UDim.new(1, 0)
        ACorner.Parent = Avatar

        local AStroke = Instance.new("UIStroke")
        AStroke.Color = VRSLibV2.Theme.CardStroke
        AStroke.Thickness = 1
        AStroke.Parent = Avatar

        local realAvatarUrl = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
        Avatar.Image = realAvatarUrl

        -- Info Stack
        local InfoStack = Instance.new("Frame")
        InfoStack.Size = UDim2.new(1, -300, 1, 0)
        InfoStack.Position = UDim2.new(0, 70, 0, 0)
        InfoStack.BackgroundTransparency = 1
        InfoStack.Parent = Card

        local WelcomeLbl = Instance.new("TextLabel")
        WelcomeLbl.Size = UDim2.new(1, 0, 0, 14)
        WelcomeLbl.BackgroundTransparency = 1
        WelcomeLbl.Text = config.Greeting or "Welcome back,"
        WelcomeLbl.Font = Enum.Font.GothamMedium
        WelcomeLbl.TextSize = 11.5
        WelcomeLbl.TextColor3 = VRSLibV2.Theme.TextMuted
        WelcomeLbl.TextXAlignment = Enum.TextXAlignment.Left
        WelcomeLbl.Parent = InfoStack
        ProtectLocalization(WelcomeLbl)

        local NameLbl = Instance.new("TextLabel")
        NameLbl.Size = UDim2.new(1, 0, 0, 22)
        NameLbl.Position = UDim2.new(0, 0, 0, 15)
        NameLbl.BackgroundTransparency = 1
        local realDisplayName = config.DisplayName or LocalPlayer.DisplayName
        NameLbl.Text = realDisplayName
        NameLbl.Font = Enum.Font.GothamBold
        NameLbl.TextSize = 17
        NameLbl.TextColor3 = VRSLibV2.Theme.TextPrimary
        NameLbl.TextXAlignment = Enum.TextXAlignment.Left
        NameLbl.Parent = InfoStack
        ProtectLocalization(NameLbl)

        local HandleLbl = Instance.new("TextLabel")
        HandleLbl.Size = UDim2.new(1, 0, 0, 14)
        HandleLbl.Position = UDim2.new(0, 0, 0, 39)
        HandleLbl.BackgroundTransparency = 1
        local realHandle = "@" .. (config.Username or LocalPlayer.Name)
        HandleLbl.Text = realHandle
        HandleLbl.Font = Enum.Font.GothamMedium
        HandleLbl.TextSize = 11.5
        HandleLbl.TextColor3 = VRSLibV2.Theme.TextSecondary
        HandleLbl.TextXAlignment = Enum.TextXAlignment.Left
        HandleLbl.Parent = InfoStack
        ProtectLocalization(HandleLbl)

        -- Top Right: Version Badge Pill
        local VerPill = Instance.new("Frame")
        VerPill.AnchorPoint = Vector2.new(1, 0)
        VerPill.Position = UDim2.new(1, 0, 0, 0)
        VerPill.Size = UDim2.new(0, 0, 0, 26)
        VerPill.AutomaticSize = Enum.AutomaticSize.X
        VerPill.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
        VerPill.BorderSizePixel = 0
        VerPill.Parent = Card

        local VPCorner = Instance.new("UICorner")
        VPCorner.CornerRadius = UDim.new(1, 0)
        VPCorner.Parent = VerPill

        local VPStroke = Instance.new("UIStroke")
        VPStroke.Color = Color3.fromRGB(42, 45, 60)
        VPStroke.Thickness = 1
        VPStroke.Parent = VerPill

        local VPPadding = Instance.new("UIPadding")
        VPPadding.PaddingLeft = UDim.new(0, 10)
        VPPadding.PaddingRight = UDim.new(0, 10)
        VPPadding.Parent = VerPill

        local VPLayout = Instance.new("UIListLayout")
        VPLayout.FillDirection = Enum.FillDirection.Horizontal
        VPLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        VPLayout.Padding = UDim.new(0, 6)
        VPLayout.Parent = VerPill

        local VIcon = Instance.new("ImageLabel")
        VIcon.Size = UDim2.fromOffset(13, 13)
        VIcon.BackgroundTransparency = 1
        VIcon.Image = VRSLibV2.Icons.Get("swords")
        VIcon.ImageColor3 = VRSLibV2.Theme.TextSecondary
        VIcon.Parent = VerPill

        local VLbl = Instance.new("TextLabel")
        VLbl.Size = UDim2.new(0, 0, 1, 0)
        VLbl.AutomaticSize = Enum.AutomaticSize.X
        VLbl.BackgroundTransparency = 1
        VLbl.Text = config.Version or "v0.141"
        VLbl.Font = Enum.Font.GothamBold
        VLbl.TextSize = 11
        VLbl.TextColor3 = VRSLibV2.Theme.TextPrimary
        VLbl.Parent = VerPill
        ProtectLocalization(VLbl)

        -- Bottom Right: Streamer Mode Toggles
        local StreamerBar = Instance.new("Frame")
        StreamerBar.AnchorPoint = Vector2.new(1, 1)
        StreamerBar.Position = UDim2.new(1, 0, 1, 0)
        StreamerBar.Size = UDim2.new(0, 0, 0, 24)
        StreamerBar.AutomaticSize = Enum.AutomaticSize.X
        StreamerBar.BackgroundTransparency = 1
        StreamerBar.Parent = Card

        local SBLayout = Instance.new("UIListLayout")
        SBLayout.FillDirection = Enum.FillDirection.Horizontal
        SBLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        SBLayout.Padding = UDim.new(0, 14)
        SBLayout.Parent = StreamerBar

        local function MakeMiniToggle(name, iconKey, onToggle)
            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 0, 1, 0)
            Box.AutomaticSize = Enum.AutomaticSize.X
            Box.BackgroundTransparency = 1
            Box.Parent = StreamerBar

            local BLayout = Instance.new("UIListLayout")
            BLayout.FillDirection = Enum.FillDirection.Horizontal
            BLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            BLayout.Padding = UDim.new(0, 6)
            BLayout.Parent = Box

            local Icon = Instance.new("ImageLabel")
            Icon.Size = UDim2.fromOffset(13, 13)
            Icon.BackgroundTransparency = 1
            Icon.Image = VRSLibV2.Icons.Get(iconKey)
            Icon.ImageColor3 = VRSLibV2.Theme.TextMuted
            Icon.Parent = Box

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0, 0, 1, 0)
            Lbl.AutomaticSize = Enum.AutomaticSize.X
            Lbl.BackgroundTransparency = 1
            Lbl.Text = name
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 11
            Lbl.TextColor3 = VRSLibV2.Theme.TextMuted
            Lbl.Parent = Box
            ProtectLocalization(Lbl)

            local Sw = Instance.new("TextButton")
            Sw.Size = UDim2.fromOffset(28, 16)
            Sw.BackgroundColor3 = VRSLibV2.Theme.SwitchOff
            Sw.BorderSizePixel = 0
            Sw.Text = ""
            Sw.Parent = Box

            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(1, 0)
            SCorner.Parent = Sw

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.fromOffset(10, 10)
            Knob.Position = UDim2.new(0, 2, 0.5, -5)
            Knob.BackgroundColor3 = VRSLibV2.Theme.SwitchOffKnob
            Knob.BorderSizePixel = 0
            Knob.Parent = Sw

            local KCorner = Instance.new("UICorner")
            KCorner.CornerRadius = UDim.new(1, 0)
            KCorner.Parent = Knob

            local state = false
            Sw.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Sw, TweenInfo.new(0.15), {
                    BackgroundColor3 = state and VRSLibV2.Theme.Accent or VRSLibV2.Theme.SwitchOff
                }):Play()
                TweenService:Create(Knob, TweenInfo.new(0.15), {
                    Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5),
                    BackgroundColor3 = state and VRSLibV2.Theme.SwitchOnKnob or VRSLibV2.Theme.SwitchOffKnob
                }):Play()
                onToggle(state)
            end)
        end

        MakeMiniToggle("Name", "eye", function(active)
            if active then
                NameLbl.Text = "Streamer_" .. string.sub(tostring(LocalPlayer.UserId), 1, 4)
                HandleLbl.Text = "@Anonymous"
            else
                NameLbl.Text = realDisplayName
                HandleLbl.Text = realHandle
            end
        end)

        MakeMiniToggle("Profile", "user", function(active)
            if active then
                Avatar.Image = VRSLibV2.Icons.Get("user")
            else
                Avatar.Image = realAvatarUrl
            end
        end)

        return Card
    end

    -- ==========================================================================
    -- 2. STAT GRID (6 Equal-width horizontal cards with live tracking)
    -- ==========================================================================
    function TabObj:AddStatGrid(config)
        config = config or {}
        local parentFrame = (self.Container or targetPage)

        local GridFrame = Instance.new("Frame")
        GridFrame.Name = "StatGrid"
        GridFrame.Size = UDim2.new(1, 0, 0, 58)
        GridFrame.BackgroundTransparency = 1
        GridFrame.LayoutOrder = config.LayoutOrder or 2
        GridFrame.Parent = parentFrame

        local GLayout = Instance.new("UIListLayout")
        GLayout.FillDirection = Enum.FillDirection.Horizontal
        GLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        GLayout.Padding = UDim.new(0, 8)
        GLayout.Parent = GridFrame

        local statCards = {}
        local defaultStats = {
            { Key = "Players", Label = "Players", Icon = "users", Value = tostring(#Players:GetPlayers()) .. "/" .. tostring(Players.MaxPlayers > 0 and Players.MaxPlayers or 20) },
            { Key = "Friends", Label = "Friends", Icon = "user", Value = "0" },
            { Key = "Execs", Label = "Execs", Icon = "zap", Value = "2" },
            { Key = "Session", Label = "Session", Icon = "clock", Value = "0s" },
            { Key = "FPS", Label = "FPS", Icon = "activity", Value = "60" },
            { Key = "Ping", Label = "Ping", Icon = "wifi", Value = "0ms" },
        }

        for _, item in ipairs(defaultStats) do
            local Card = Instance.new("Frame")
            Card.Name = "Stat_" .. item.Key
            Card.Size = UDim2.new(1 / 6, -7, 1, 0)
            Card.BackgroundColor3 = VRSLibV2.Theme.Card
            Card.BorderSizePixel = 0
            Card.Parent = GridFrame

            local CCorner = Instance.new("UICorner")
            CCorner.CornerRadius = UDim.new(0, 8)
            CCorner.Parent = Card

            local CStroke = Instance.new("UIStroke")
            CStroke.Color = VRSLibV2.Theme.CardStroke
            CStroke.Thickness = 1
            CStroke.Parent = Card

            local CPadding = Instance.new("UIPadding")
            CPadding.PaddingLeft = UDim.new(0, 10)
            CPadding.PaddingRight = UDim.new(0, 10)
            CPadding.PaddingTop = UDim.new(0, 8)
            CPadding.PaddingBottom = UDim.new(0, 8)
            CPadding.Parent = Card

            -- Top Row (Icon + Label)
            local HRow = Instance.new("Frame")
            HRow.Size = UDim2.new(1, 0, 0, 16)
            HRow.BackgroundTransparency = 1
            HRow.Parent = Card

            local HList = Instance.new("UIListLayout")
            HList.FillDirection = Enum.FillDirection.Horizontal
            HList.VerticalAlignment = Enum.VerticalAlignment.Center
            HList.Padding = UDim.new(0, 6)
            HList.Parent = HRow

            local Icon = Instance.new("ImageLabel")
            Icon.Size = UDim2.fromOffset(13, 13)
            Icon.BackgroundTransparency = 1
            Icon.Image = VRSLibV2.Icons.Get(item.Icon)
            Icon.ImageColor3 = VRSLibV2.Theme.TextMuted
            Icon.Parent = HRow

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0, 0, 1, 0)
            Lbl.AutomaticSize = Enum.AutomaticSize.X
            Lbl.BackgroundTransparency = 1
            Lbl.Text = item.Label
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 11
            Lbl.TextColor3 = VRSLibV2.Theme.TextMuted
            Lbl.Parent = HRow
            ProtectLocalization(Lbl)

            -- Bottom Value
            local Val = Instance.new("TextLabel")
            Val.Name = "ValLbl"
            Val.Size = UDim2.new(1, 0, 0, 22)
            Val.Position = UDim2.new(0, 0, 1, -22)
            Val.BackgroundTransparency = 1
            Val.Text = item.Value
            Val.Font = Enum.Font.GothamBold
            Val.TextSize = 15
            Val.TextColor3 = VRSLibV2.Theme.TextPrimary
            Val.TextXAlignment = Enum.TextXAlignment.Left
            Val.Parent = Card
            ProtectLocalization(Val)

            statCards[item.Key] = Val
        end

        -- Live FPS, Ping, Session Timers
        local startTime = tick()
        local frameCount = 0
        local lastFpsTime = tick()
        local currentFps = 60

        local conn = RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            local now = tick()
            if now - lastFpsTime >= 0.5 then
                currentFps = math.floor(frameCount / (now - lastFpsTime) + 0.5)
                frameCount = 0
                lastFpsTime = now
                if statCards["FPS"] then statCards["FPS"].Text = tostring(currentFps) end
            end
        end)

        task.spawn(function()
            while GridFrame.Parent do
                task.wait(1)
                local elapsed = math.floor(tick() - startTime)
                local m = math.floor(elapsed / 60)
                local s = elapsed % 60
                local sessionStr = (m > 0 and (tostring(m) .. "m ") or "") .. tostring(s) .. "s"
                if statCards["Session"] then statCards["Session"].Text = sessionStr end

                pcall(function()
                    local pingVal = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
                    if statCards["Ping"] then statCards["Ping"].Text = tostring(pingVal) .. "ms" end
                end)

                if statCards["Players"] then
                    local maxP = Players.MaxPlayers > 0 and Players.MaxPlayers or 20
                    statCards["Players"].Text = tostring(#Players:GetPlayers()) .. "/" .. tostring(maxP)
                end
            end
            if conn then conn:Disconnect() end
        end)

        return GridFrame
    end

    -- ==========================================================================
    -- 3. GAME INFO CARD & SERVER ACTIONS
    -- ==========================================================================
    function TabObj:AddGameCard(config)
        config = config or {}
        local parentFrame = (self.Container or targetPage)

        local Card = Instance.new("Frame")
        Card.Name = "GameCard"
        Card.Size = UDim2.new(1, 0, 0, 118)
        Card.BackgroundColor3 = VRSLibV2.Theme.Card
        Card.BorderSizePixel = 0
        Card.LayoutOrder = config.LayoutOrder or 3
        Card.Parent = parentFrame

        local CCorner = Instance.new("UICorner")
        CCorner.CornerRadius = UDim.new(0, 10)
        CCorner.Parent = Card

        local CStroke = Instance.new("UIStroke")
        CStroke.Color = VRSLibV2.Theme.CardStroke
        CStroke.Thickness = 1
        CStroke.Parent = Card

        local CPadding = Instance.new("UIPadding")
        CPadding.PaddingLeft = UDim.new(0, 14)
        CPadding.PaddingRight = UDim.new(0, 14)
        CPadding.PaddingTop = UDim.new(0, 12)
        CPadding.PaddingBottom = UDim.new(0, 12)
        CPadding.Parent = Card

        -- Thumbnail
        local Thumb = Instance.new("ImageLabel")
        Thumb.Name = "GameThumb"
        Thumb.Size = UDim2.fromOffset(54, 54)
        Thumb.Position = UDim2.new(0, 0, 0, 0)
        Thumb.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
        Thumb.BorderSizePixel = 0
        Thumb.Parent = Card

        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 8)
        TCorner.Parent = Thumb

        local placeId = game.PlaceId
        local jobId = (game.JobId ~= "" and game.JobId or "97a448b9-87a2-4a90-b1c2-a909")
        local universeId = (game.GameId ~= 0 and game.GameId or 5595353122)
        local gameName = config.GameName or self.Window.GameName or "Roblox Game"
        local creatorName = config.Creator or "Ouw Productions"

        pcall(function()
            local info = game:GetService("MarketplaceService"):GetProductInfo(placeId)
            if info and info.IconImageAssetId and info.IconImageAssetId ~= 0 then
                Thumb.Image = "rbxassetid://" .. tostring(info.IconImageAssetId)
            end
        end)

        -- Meta Stack
        local MetaStack = Instance.new("Frame")
        MetaStack.Size = UDim2.new(0.5, 0, 1, 0)
        MetaStack.Position = UDim2.new(0, 66, 0, 0)
        MetaStack.BackgroundTransparency = 1
        MetaStack.Parent = Card

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Size = UDim2.new(1, 0, 0, 18)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = gameName
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.TextSize = 15
        TitleLbl.TextColor3 = VRSLibV2.Theme.TextPrimary
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.Parent = MetaStack
        ProtectLocalization(TitleLbl)

        local DevLbl = Instance.new("TextLabel")
        DevLbl.Size = UDim2.new(1, 0, 0, 14)
        DevLbl.Position = UDim2.new(0, 0, 0, 18)
        DevLbl.BackgroundTransparency = 1
        DevLbl.Text = "by " .. creatorName
        DevLbl.Font = Enum.Font.GothamMedium
        DevLbl.TextSize = 11.5
        DevLbl.TextColor3 = VRSLibV2.Theme.TextMuted
        DevLbl.TextXAlignment = Enum.TextXAlignment.Left
        DevLbl.Parent = MetaStack
        ProtectLocalization(DevLbl)

        local JobLbl = Instance.new("TextLabel")
        JobLbl.Size = UDim2.new(1, 0, 0, 14)
        JobLbl.Position = UDim2.new(0, 0, 0, 38)
        JobLbl.BackgroundTransparency = 1
        JobLbl.Text = "Job  " .. string.sub(jobId, 1, 10) .. "..." .. string.sub(jobId, -4)
        JobLbl.Font = Enum.Font.Gotham
        JobLbl.TextSize = 11
        JobLbl.TextColor3 = VRSLibV2.Theme.TextSecondary
        JobLbl.TextXAlignment = Enum.TextXAlignment.Left
        JobLbl.Parent = MetaStack
        ProtectLocalization(JobLbl)

        local PlaceLbl = Instance.new("TextLabel")
        PlaceLbl.Size = UDim2.new(1, 0, 0, 14)
        PlaceLbl.Position = UDim2.new(0, 0, 0, 54)
        PlaceLbl.BackgroundTransparency = 1
        PlaceLbl.Text = "Place  " .. tostring(placeId)
        PlaceLbl.Font = Enum.Font.Gotham
        PlaceLbl.TextSize = 11
        PlaceLbl.TextColor3 = VRSLibV2.Theme.TextSecondary
        PlaceLbl.TextXAlignment = Enum.TextXAlignment.Left
        PlaceLbl.Parent = MetaStack
        ProtectLocalization(PlaceLbl)

        local UniLbl = Instance.new("TextLabel")
        UniLbl.Size = UDim2.new(1, 0, 0, 14)
        UniLbl.Position = UDim2.new(0, 0, 0, 70)
        UniLbl.BackgroundTransparency = 1
        UniLbl.Text = "Universe  " .. tostring(universeId)
        UniLbl.Font = Enum.Font.Gotham
        UniLbl.TextSize = 11
        UniLbl.TextColor3 = VRSLibV2.Theme.TextSecondary
        UniLbl.TextXAlignment = Enum.TextXAlignment.Left
        UniLbl.Parent = MetaStack
        ProtectLocalization(UniLbl)

        -- Action Buttons Grid
        local BtnBox = Instance.new("Frame")
        BtnBox.AnchorPoint = Vector2.new(1, 0.5)
        BtnBox.Position = UDim2.new(1, 0, 0.5, 0)
        BtnBox.Size = UDim2.new(0, 240, 0, 94)
        BtnBox.BackgroundTransparency = 1
        BtnBox.Parent = Card

        local function MakeBtn(title, pos, size, onClick)
            local btn = Instance.new("TextButton")
            btn.Size = size
            btn.Position = pos
            btn.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
            btn.BorderSizePixel = 0
            btn.Text = title
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 11
            btn.TextColor3 = VRSLibV2.Theme.TextPrimary
            btn.AutoButtonColor = false
            btn.Parent = BtnBox

            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 6)
            bCorner.Parent = btn

            local bStroke = Instance.new("UIStroke")
            bStroke.Color = Color3.fromRGB(42, 45, 60)
            bStroke.Thickness = 1
            bStroke.Parent = btn

            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(32, 35, 48) }):Play()
                TweenService:Create(bStroke, TweenInfo.new(0.12), { Color = VRSLibV2.Theme.Accent }):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(24, 26, 36) }):Play()
                TweenService:Create(bStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(42, 45, 60) }):Play()
            end)
            btn.MouseButton1Click:Connect(function()
                if onClick then onClick() end
            end)
            return btn
        end

        MakeBtn("Rejoin", UDim2.new(0, 0, 0, 0), UDim2.new(0.48, 0, 0, 28), function()
            TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
        end)
        MakeBtn("Server Hop", UDim2.new(0.52, 0, 0, 0), UDim2.new(0.48, 0, 0, 28), function()
            VRSLibV2:Notify({ Title = "Server Hop", Description = "Finding optimal low-ping server...", Duration = 3 })
        end)
        MakeBtn("Copy Job ID", UDim2.new(0, 0, 0, 33), UDim2.new(0.48, 0, 0, 28), function()
            if setclipboard then setclipboard(jobId) end
            VRSLibV2:Notify({ Title = "Copied", Description = "Job ID copied to clipboard!", Duration = 2.5 })
        end)
        MakeBtn("Copy Universe", UDim2.new(0.52, 0, 0, 33), UDim2.new(0.48, 0, 0, 28), function()
            if setclipboard then setclipboard(tostring(universeId)) end
            VRSLibV2:Notify({ Title = "Copied", Description = "Universe ID copied to clipboard!", Duration = 2.5 })
        end)
        MakeBtn("Join Lowest Server", UDim2.new(0, 0, 0, 66), UDim2.new(1, 0, 0, 28), function()
            VRSLibV2:Notify({ Title = "Matchmaking", Description = "Searching lowest population server...", Duration = 3 })
        end)

        return Card
    end

    -- ==========================================================================
    -- 4. WARNING & STATUS BANNER (Screenshot 1 Identical)
    -- ==========================================================================
    function TabObj:AddBanner(config)
        config = config or {}
        local parentFrame = (self.Container or targetPage)

        local Banner = Instance.new("Frame")
        Banner.Name = "Banner"
        Banner.Size = UDim2.new(1, 0, 0, 48)
        Banner.BackgroundColor3 = VRSLibV2.Theme.Card
        Banner.BorderSizePixel = 0
        Banner.LayoutOrder = config.LayoutOrder or 4
        Banner.Parent = parentFrame

        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 8)
        BCorner.Parent = Banner

        local BStroke = Instance.new("UIStroke")
        BStroke.Color = VRSLibV2.Theme.CardStroke
        BStroke.Thickness = 1
        BStroke.Parent = Banner

        local BPadding = Instance.new("UIPadding")
        BPadding.PaddingLeft = UDim.new(0, 14)
        BPadding.PaddingRight = UDim.new(0, 14)
        BPadding.Parent = Banner

        local BLayout = Instance.new("UIListLayout")
        BLayout.FillDirection = Enum.FillDirection.Horizontal
        BLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        BLayout.Padding = UDim.new(0, 12)
        BLayout.Parent = Banner

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.fromOffset(20, 20)
        Icon.BackgroundTransparency = 1
        Icon.Image = VRSLibV2.Icons.Get(config.Icon or "shield")
        Icon.ImageColor3 = config.Color or VRSLibV2.Theme.WarningOrange
        Icon.Parent = Banner

        local TextStack = Instance.new("Frame")
        TextStack.Size = UDim2.new(1, -160, 1, 0)
        TextStack.BackgroundTransparency = 1
        TextStack.Parent = Banner

        local TLayout = Instance.new("UIListLayout")
        TLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        TLayout.Padding = UDim.new(0, 2)
        TLayout.Parent = TextStack

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Size = UDim2.new(1, 0, 0, 16)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = config.Title or "Madium"
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.TextSize = 13
        TitleLbl.TextColor3 = config.Color or VRSLibV2.Theme.WarningOrange
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.Parent = TextStack
        ProtectLocalization(TitleLbl)

        local DescLbl = Instance.new("TextLabel")
        DescLbl.Size = UDim2.new(1, 0, 0, 14)
        DescLbl.BackgroundTransparency = 1
        DescLbl.Text = config.Description or "Not on the supported list. Some features may not work."
        DescLbl.Font = Enum.Font.GothamMedium
        DescLbl.TextSize = 11
        DescLbl.TextColor3 = VRSLibV2.Theme.TextMuted
        DescLbl.TextXAlignment = Enum.TextXAlignment.Left
        DescLbl.Parent = TextStack
        ProtectLocalization(DescLbl)

        -- Right Badge Pill
        local Pill = Instance.new("Frame")
        Pill.Size = UDim2.new(0, 0, 0, 24)
        Pill.AutomaticSize = Enum.AutomaticSize.X
        Pill.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
        Pill.BorderSizePixel = 0
        Pill.Parent = Banner

        local PCorner = Instance.new("UICorner")
        PCorner.CornerRadius = UDim.new(0, 6)
        PCorner.Parent = Pill

        local PStroke = Instance.new("UIStroke")
        PStroke.Color = Color3.fromRGB(42, 45, 60)
        PStroke.Thickness = 1
        PStroke.Parent = Pill

        local PPadding = Instance.new("UIPadding")
        PPadding.PaddingLeft = UDim.new(0, 8)
        PPadding.PaddingRight = UDim.new(0, 8)
        PPadding.Parent = Pill

        local PLbl = Instance.new("TextLabel")
        PLbl.Size = UDim2.new(0, 0, 1, 0)
        PLbl.AutomaticSize = Enum.AutomaticSize.X
        PLbl.BackgroundTransparency = 1
        PLbl.Text = config.Badge or "RCtrl to hide"
        PLbl.Font = Enum.Font.GothamBold
        PLbl.TextSize = 10.5
        PLbl.TextColor3 = VRSLibV2.Theme.TextSecondary
        PLbl.Parent = Pill
        ProtectLocalization(PLbl)

        return Banner
    end

    -- ==========================================================================
    -- 5. QUICK LINKS ROW (Two Equal Columns)
    -- ==========================================================================
    function TabObj:AddLinksRow(config)
        config = config or {}
        local parentFrame = (self.Container or targetPage)

        local Row = Instance.new("Frame")
        Row.Name = "LinksRow"
        Row.Size = UDim2.new(1, 0, 0, 52)
        Row.BackgroundTransparency = 1
        Row.LayoutOrder = config.LayoutOrder or 5
        Row.Parent = parentFrame

        local RLayout = Instance.new("UIListLayout")
        RLayout.FillDirection = Enum.FillDirection.Horizontal
        RLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        RLayout.Padding = UDim.new(0, 10)
        RLayout.Parent = Row

        local function MakeLinkCard(cardCfg)
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(0.5, -5, 1, 0)
            Card.BackgroundColor3 = VRSLibV2.Theme.Card
            Card.BorderSizePixel = 0
            Card.Parent = Row

            local CCorner = Instance.new("UICorner")
            CCorner.CornerRadius = UDim.new(0, 8)
            CCorner.Parent = Card

            local CStroke = Instance.new("UIStroke")
            CStroke.Color = VRSLibV2.Theme.CardStroke
            CStroke.Thickness = 1
            CStroke.Parent = Card

            local CPadding = Instance.new("UIPadding")
            CPadding.PaddingLeft = UDim.new(0, 14)
            CPadding.PaddingRight = UDim.new(0, 14)
            CPadding.Parent = Card

            local Icon = Instance.new("ImageLabel")
            Icon.Size = UDim2.fromOffset(20, 20)
            Icon.Position = UDim2.new(0, 0, 0.5, -10)
            Icon.BackgroundTransparency = 1
            Icon.Image = VRSLibV2.Icons.Get(cardCfg.Icon or "message-square")
            Icon.ImageColor3 = VRSLibV2.Theme.TextMuted
            Icon.Parent = Card

            local TStack = Instance.new("Frame")
            TStack.Size = UDim2.new(1, -145, 1, 0)
            TStack.Position = UDim2.new(0, 32, 0, 0)
            TStack.BackgroundTransparency = 1
            TStack.Parent = Card

            local TLay = Instance.new("UIListLayout")
            TLay.VerticalAlignment = Enum.VerticalAlignment.Center
            TLay.Padding = UDim.new(0, 2)
            TLay.Parent = TStack

            local TLbl = Instance.new("TextLabel")
            TLbl.Size = UDim2.new(1, 0, 0, 16)
            TLbl.BackgroundTransparency = 1
            TLbl.Text = cardCfg.Title or "Community"
            TLbl.Font = Enum.Font.GothamBold
            TLbl.TextSize = 12.5
            TLbl.TextColor3 = VRSLibV2.Theme.TextPrimary
            TLbl.TextXAlignment = Enum.TextXAlignment.Left
            TLbl.Parent = TStack
            ProtectLocalization(TLbl)

            local SLbl = Instance.new("TextLabel")
            SLbl.Size = UDim2.new(1, 0, 0, 14)
            SLbl.BackgroundTransparency = 1
            SLbl.Text = cardCfg.Subtitle or cardCfg.Url or ""
            SLbl.Font = Enum.Font.Gotham
            SLbl.TextSize = 10.5
            SLbl.TextColor3 = VRSLibV2.Theme.TextMuted
            SLbl.TextXAlignment = Enum.TextXAlignment.Left
            SLbl.TextTruncate = Enum.TextTruncate.AtEnd
            SLbl.Parent = TStack
            ProtectLocalization(SLbl)

            local Btn = Instance.new("TextButton")
            Btn.AnchorPoint = Vector2.new(1, 0.5)
            Btn.Position = UDim2.new(1, 0, 0.5, 0)
            Btn.Size = UDim2.new(0, 105, 0, 28)
            Btn.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
            Btn.BorderSizePixel = 0
            Btn.Text = cardCfg.ButtonText or "Copy"
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 11
            Btn.TextColor3 = VRSLibV2.Theme.TextPrimary
            Btn.AutoButtonColor = false
            Btn.Parent = Card

            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 6)
            BCorner.Parent = Btn

            local BStroke = Instance.new("UIStroke")
            BStroke.Color = Color3.fromRGB(42, 45, 60)
            BStroke.Thickness = 1
            BStroke.Parent = Btn

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(32, 35, 48) }):Play()
                TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = VRSLibV2.Theme.Accent }):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(24, 26, 36) }):Play()
                TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(42, 45, 60) }):Play()
            end)
            Btn.MouseButton1Click:Connect(function()
                if cardCfg.Callback then
                    cardCfg.Callback()
                elseif cardCfg.Url and setclipboard then
                    setclipboard(cardCfg.Url)
                    VRSLibV2:Notify({ Title = "Copied", Description = "Link copied to clipboard!", Duration = 2.5 })
                end
            end)
        end

        local left = config.Left or { Title = "Join the community", Subtitle = "https://discord.gg/synapsex", ButtonText = "Copy Invite", Icon = "message-square" }
        local right = config.Right or { Title = "Supported games", Subtitle = "https://ouroboros-hub-rbx.web.app/", ButtonText = "Copy Website", Icon = "monitor" }

        MakeLinkCard(left)
        MakeLinkCard(right)
        return Row
    end

    -- ==========================================================================
    -- 6. FEATURE LIST ROW
    -- ==========================================================================
    function TabObj:AddFeatureList(config)
        config = config or {}
        local parentFrame = (self.Container or targetPage)

        local Card = Instance.new("Frame")
        Card.Name = "FeatureListCard"
        Card.Size = UDim2.new(1, 0, 0, 50)
        Card.BackgroundColor3 = VRSLibV2.Theme.Card
        Card.BorderSizePixel = 0
        Card.LayoutOrder = config.LayoutOrder or 6
        Card.Parent = parentFrame

        local CCorner = Instance.new("UICorner")
        CCorner.CornerRadius = UDim.new(0, 8)
        CCorner.Parent = Card

        local CStroke = Instance.new("UIStroke")
        CStroke.Color = VRSLibV2.Theme.CardStroke
        CStroke.Thickness = 1
        CStroke.Parent = Card

        local CPadding = Instance.new("UIPadding")
        CPadding.PaddingLeft = UDim.new(0, 14)
        CPadding.PaddingRight = UDim.new(0, 14)
        CPadding.Parent = Card

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.fromOffset(20, 20)
        Icon.Position = UDim2.new(0, 0, 0.5, -10)
        Icon.BackgroundTransparency = 1
        Icon.Image = VRSLibV2.Icons.Get(config.Icon or "list")
        Icon.ImageColor3 = VRSLibV2.Theme.TextMuted
        Icon.Parent = Card

        local TStack = Instance.new("Frame")
        TStack.Size = UDim2.new(1, -160, 1, 0)
        TStack.Position = UDim2.new(0, 32, 0, 0)
        TStack.BackgroundTransparency = 1
        TStack.Parent = Card

        local TLay = Instance.new("UIListLayout")
        TLay.VerticalAlignment = Enum.VerticalAlignment.Center
        TLay.Padding = UDim.new(0, 2)
        TLay.Parent = TStack

        local TLbl = Instance.new("TextLabel")
        TLbl.Size = UDim2.new(1, 0, 0, 16)
        TLbl.BackgroundTransparency = 1
        TLbl.Text = config.Title or "Feature list"
        TLbl.Font = Enum.Font.GothamBold
        TLbl.TextSize = 13
        TLbl.TextColor3 = VRSLibV2.Theme.TextPrimary
        TLbl.TextXAlignment = Enum.TextXAlignment.Left
        TLbl.Parent = TStack
        ProtectLocalization(TLbl)

        local SLbl = Instance.new("TextLabel")
        SLbl.Size = UDim2.new(1, 0, 0, 14)
        SLbl.BackgroundTransparency = 1
        SLbl.Text = config.Subtitle or "7 features across 2 tabs"
        SLbl.Font = Enum.Font.Gotham
        SLbl.TextSize = 11
        SLbl.TextColor3 = VRSLibV2.Theme.TextMuted
        SLbl.TextXAlignment = Enum.TextXAlignment.Left
        SLbl.Parent = TStack
        ProtectLocalization(SLbl)

        local Btn = Instance.new("TextButton")
        Btn.AnchorPoint = Vector2.new(1, 0.5)
        Btn.Position = UDim2.new(1, 0, 0.5, 0)
        Btn.Size = UDim2.new(0, 115, 0, 28)
        Btn.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
        Btn.BorderSizePixel = 0
        Btn.Text = config.ButtonText or "View Features"
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 11
        Btn.TextColor3 = VRSLibV2.Theme.TextPrimary
        Btn.AutoButtonColor = false
        Btn.Parent = Card

        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 6)
        BCorner.Parent = Btn

        local BStroke = Instance.new("UIStroke")
        BStroke.Color = Color3.fromRGB(42, 45, 60)
        BStroke.Thickness = 1
        BStroke.Parent = Btn

        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(32, 35, 48) }):Play()
            TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = VRSLibV2.Theme.Accent }):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(24, 26, 36) }):Play()
            TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(42, 45, 60) }):Play()
        end)
        Btn.MouseButton1Click:Connect(function()
            if config.Callback then config.Callback() end
        end)

        return Card
    end

    -- ==========================================================================
    -- 7. DUAL-COLUMN SECTION ENGINE (For Standard Hub Tabs like Farm, Combat, etc.)
    -- ==========================================================================
    function TabObj:AddColumns()
        local parentFrame = (self.Container or targetPage)

        local ColFrame = Instance.new("Frame")
        ColFrame.Name = "ColumnFrame"
        ColFrame.Size = UDim2.new(1, 0, 0, 0)
        ColFrame.AutomaticSize = Enum.AutomaticSize.Y
        ColFrame.BackgroundTransparency = 1
        ColFrame.Parent = parentFrame

        local CLayout = Instance.new("UIListLayout")
        CLayout.FillDirection = Enum.FillDirection.Horizontal
        CLayout.Padding = UDim.new(0, 12)
        CLayout.Parent = ColFrame

        local function MakeCol(name)
            local Col = Instance.new("Frame")
            Col.Name = name
            Col.Size = UDim2.new(0.5, -6, 0, 0)
            Col.AutomaticSize = Enum.AutomaticSize.Y
            Col.BackgroundTransparency = 1
            Col.Parent = ColFrame

            local L = Instance.new("UIListLayout")
            L.SortOrder = Enum.SortOrder.LayoutOrder
            L.Padding = UDim.new(0, 12)
            L.Parent = Col

            local ColObj = { Frame = Col }
            function ColObj:AddGroupbox(cfgOrTitle, icon)
                return TabObj:CreateGroupbox(Col, cfgOrTitle, icon)
            end
            return ColObj
        end

        local Left = MakeCol("LeftCol")
        local Right = MakeCol("RightCol")
        return Left, Right
    end

    -- Groupbox Builder
    function TabObj:CreateGroupbox(parentCol, cfgOrTitle, optionalIcon)
        local cfg = type(cfgOrTitle) == "table" and cfgOrTitle or { Title = cfgOrTitle, Icon = optionalIcon }
        local title = cfg.Title or "Section"
        local iconId = VRSLibV2.Icons.Get(cfg.Icon or "folder")
        local isCollapsed = cfg.Collapsed or false

        local Box = Instance.new("Frame")
        Box.Name = "Groupbox_" .. title
        Box.Size = UDim2.new(1, 0, 0, 0)
        Box.AutomaticSize = Enum.AutomaticSize.Y
        Box.BackgroundColor3 = VRSLibV2.Theme.Card
        Box.BorderSizePixel = 0
        Box.ClipsDescendants = true
        Box.Parent = parentCol

        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 10)
        BCorner.Parent = Box

        local BStroke = Instance.new("UIStroke")
        BStroke.Color = VRSLibV2.Theme.CardStroke
        BStroke.Thickness = 1
        BStroke.Parent = Box

        -- Title Bar
        local TitleBar = Instance.new("TextButton")
        TitleBar.Name = "TitleBar"
        TitleBar.Size = UDim2.new(1, 0, 0, 38)
        TitleBar.BackgroundTransparency = 1
        TitleBar.Text = ""
        TitleBar.AutoButtonColor = false
        TitleBar.Parent = Box

        local TBPadding = Instance.new("UIPadding")
        TBPadding.PaddingLeft = UDim.new(0, 14)
        TBPadding.PaddingRight = UDim.new(0, 14)
        TBPadding.Parent = TitleBar

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.fromOffset(16, 16)
        Icon.Position = UDim2.new(0, 0, 0.5, -8)
        Icon.BackgroundTransparency = 1
        Icon.Image = iconId
        Icon.ImageColor3 = VRSLibV2.Theme.TextMuted
        Icon.Parent = TitleBar

        local TLbl = Instance.new("TextLabel")
        TLbl.Size = UDim2.new(1, -50, 1, 0)
        TLbl.Position = UDim2.new(0, 24, 0, 0)
        TLbl.BackgroundTransparency = 1
        TLbl.Text = title
        TLbl.Font = Enum.Font.GothamBold
        TLbl.TextSize = 13
        TLbl.TextColor3 = VRSLibV2.Theme.TextPrimary
        TLbl.TextXAlignment = Enum.TextXAlignment.Left
        TLbl.Parent = TitleBar
        ProtectLocalization(TLbl)

        local CollapseLbl = Instance.new("TextLabel")
        CollapseLbl.AnchorPoint = Vector2.new(1, 0.5)
        CollapseLbl.Position = UDim2.new(1, 0, 0.5, 0)
        CollapseLbl.Size = UDim2.fromOffset(16, 16)
        CollapseLbl.BackgroundTransparency = 1
        CollapseLbl.Text = isCollapsed and "+" or "—"
        CollapseLbl.Font = Enum.Font.GothamBold
        CollapseLbl.TextSize = 14
        CollapseLbl.TextColor3 = VRSLibV2.Theme.TextMuted
        CollapseLbl.Parent = TitleBar
        ProtectLocalization(CollapseLbl)

        -- Elements Container
        local Container = Instance.new("Frame")
        Container.Name = "Elements"
        Container.Size = UDim2.new(1, 0, 0, 0)
        Container.AutomaticSize = Enum.AutomaticSize.Y
        Container.BackgroundTransparency = 1
        Container.Visible = not isCollapsed
        Container.Parent = Box

        local CPadding = Instance.new("UIPadding")
        CPadding.PaddingLeft = UDim.new(0, 14)
        CPadding.PaddingRight = UDim.new(0, 14)
        CPadding.PaddingTop = UDim.new(0, 4)
        CPadding.PaddingBottom = UDim.new(0, 14)
        CPadding.Parent = Container

        local CLayout = Instance.new("UIListLayout")
        CLayout.SortOrder = Enum.SortOrder.LayoutOrder
        CLayout.Padding = UDim.new(0, 10)
        CLayout.Parent = Container

        TitleBar.MouseButton1Click:Connect(function()
            isCollapsed = not isCollapsed
            Container.Visible = not isCollapsed
            CollapseLbl.Text = isCollapsed and "+" or "—"
            TweenService:Create(CollapseLbl, TweenInfo.new(0.15), {
                TextColor3 = isCollapsed and VRSLibV2.Theme.TextMuted or VRSLibV2.Theme.Accent
            }):Play()
        end)

        local GroupObj = {
            Box = Box,
            Container = Container,
            Window = self.Window
        }

        -- ======================================================================
        -- ELEMENT: TOGGLE (Sleek Neon Pink Pill Switch)
        -- ======================================================================
        function GroupObj:AddToggle(elemCfg)
            elemCfg = elemCfg or {}
            local name = elemCfg.Name or "Toggle"
            local state = elemCfg.Default or false
            local callback = elemCfg.Callback or function() end

            local Row = Instance.new("Frame")
            Row.Name = "Toggle_" .. name
            Row.Size = UDim2.new(1, 0, 0, 24)
            Row.BackgroundTransparency = 1
            Row.Parent = Container

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, -44, 1, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = name
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 12.5
            Lbl.TextColor3 = state and VRSLibV2.Theme.TextPrimary or VRSLibV2.Theme.TextSecondary
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Row
            ProtectLocalization(Lbl)

            local Sw = Instance.new("TextButton")
            Sw.AnchorPoint = Vector2.new(1, 0.5)
            Sw.Position = UDim2.new(1, 0, 0.5, 0)
            Sw.Size = UDim2.fromOffset(36, 20)
            Sw.BackgroundColor3 = state and VRSLibV2.Theme.Accent or VRSLibV2.Theme.SwitchOff
            Sw.BorderSizePixel = 0
            Sw.Text = ""
            Sw.AutoButtonColor = false
            Sw.Parent = Row

            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(1, 0)
            SCorner.Parent = Sw

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.fromOffset(14, 14)
            Knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            Knob.BackgroundColor3 = state and VRSLibV2.Theme.SwitchOnKnob or VRSLibV2.Theme.SwitchOffKnob
            Knob.BorderSizePixel = 0
            Knob.Parent = Sw

            local KCorner = Instance.new("UICorner")
            KCorner.CornerRadius = UDim.new(1, 0)
            KCorner.Parent = Knob

            local function UpdateVisuals(val)
                TweenService:Create(Sw, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = val and VRSLibV2.Theme.Accent or VRSLibV2.Theme.SwitchOff
                }):Play()
                TweenService:Create(Knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = val and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                    BackgroundColor3 = val and VRSLibV2.Theme.SwitchOnKnob or VRSLibV2.Theme.SwitchOffKnob
                }):Play()
                TweenService:Create(Lbl, TweenInfo.new(0.15), {
                    TextColor3 = val and VRSLibV2.Theme.TextPrimary or VRSLibV2.Theme.TextSecondary
                }):Play()
            end

            Sw.MouseButton1Click:Connect(function()
                state = not state
                UpdateVisuals(state)
                callback(state)
            end)

            table.insert(self.Window.AllElements, { Frame = Row, SearchText = name })

            return {
                Set = function(_, val)
                    state = val
                    UpdateVisuals(state)
                    callback(state)
                end,
                Value = function() return state end
            }
        end

        -- ======================================================================
        -- ELEMENT: SLIDER (Neon Pink Draggable Bar)
        -- ======================================================================
        function GroupObj:AddSlider(elemCfg)
            elemCfg = elemCfg or {}
            local name      = elemCfg.Name or "Slider"
            local min       = elemCfg.Min or 0
            local max       = elemCfg.Max or 100
            local def       = elemCfg.Default or min
            local suffix    = elemCfg.Suffix or elemCfg.Unit or ""
            local precision = elemCfg.Precision or 0
            local callback  = elemCfg.Callback or function() end

            local currentVal = def

            local Box = Instance.new("Frame")
            Box.Name = "Slider_" .. name
            Box.Size = UDim2.new(1, 0, 0, 44)
            Box.BackgroundTransparency = 1
            Box.Parent = Container

            local TopRow = Instance.new("Frame")
            TopRow.Size = UDim2.new(1, 0, 0, 16)
            TopRow.BackgroundTransparency = 1
            TopRow.Parent = Box

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0.7, 0, 1, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = name
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 12
            Lbl.TextColor3 = VRSLibV2.Theme.TextPrimary
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = TopRow
            ProtectLocalization(Lbl)

            local ValLbl = Instance.new("TextLabel")
            ValLbl.Size = UDim2.new(0.3, 0, 1, 0)
            ValLbl.Position = UDim2.new(0.7, 0, 0, 0)
            ValLbl.BackgroundTransparency = 1
            ValLbl.Text = string.format("%." .. precision .. "f", currentVal) .. suffix
            ValLbl.Font = Enum.Font.GothamBold
            ValLbl.TextSize = 12
            ValLbl.TextColor3 = VRSLibV2.Theme.Accent
            ValLbl.TextXAlignment = Enum.TextXAlignment.Right
            ValLbl.Parent = TopRow
            ProtectLocalization(ValLbl)

            -- Track
            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, 0, 0, 8)
            Track.Position = UDim2.new(0, 0, 0, 24)
            Track.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
            Track.BorderSizePixel = 0
            Track.Text = ""
            Track.AutoButtonColor = false
            Track.Parent = Box

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(1, 0)
            TCorner.Parent = Track

            local Fill = Instance.new("Frame")
            local initPct = math.clamp((def - min) / (max - min), 0, 1)
            Fill.Size = UDim2.new(initPct, 0, 1, 0)
            Fill.BackgroundColor3 = VRSLibV2.Theme.Accent
            Fill.BorderSizePixel = 0
            Fill.Parent = Track

            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(1, 0)
            FCorner.Parent = Fill

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.fromOffset(12, 12)
            Knob.AnchorPoint = Vector2.new(0.5, 0.5)
            Knob.Position = UDim2.new(1, 0, 0.5, 0)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.BorderSizePixel = 0
            Knob.Parent = Fill

            local KCorner = Instance.new("UICorner")
            KCorner.CornerRadius = UDim.new(1, 0)
            KCorner.Parent = Knob

            local sliding = false
            local function UpdateSlider(inputX)
                local absX = Track.AbsolutePosition.X
                local absW = Track.AbsoluteSize.X
                local pct = math.clamp((inputX - absX) / absW, 0, 1)
                Fill.Size = UDim2.new(pct, 0, 1, 0)

                local rawVal = min + (max - min) * pct
                local snappedVal = tonumber(string.format("%." .. precision .. "f", rawVal))
                currentVal = snappedVal
                ValLbl.Text = string.format("%." .. precision .. "f", currentVal) .. suffix
                callback(currentVal)
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    UpdateSlider(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input.Position.X)
                end
            end)

            table.insert(self.Window.AllElements, { Frame = Box, SearchText = name })

            return {
                Set = function(_, val)
                    val = math.clamp(val, min, max)
                    currentVal = val
                    local pct = math.clamp((val - min) / (max - min), 0, 1)
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    ValLbl.Text = string.format("%." .. precision .. "f", currentVal) .. suffix
                    callback(currentVal)
                end,
                Value = function() return currentVal end
            }
        end

        -- ======================================================================
        -- ELEMENT: BUTTON (Interactive Action Button)
        -- ======================================================================
        function GroupObj:AddButton(elemCfg)
            elemCfg = elemCfg or {}
            local name     = elemCfg.Name or "Button"
            local iconKey  = elemCfg.Icon
            local callback = elemCfg.Callback or function() end

            local Btn = Instance.new("TextButton")
            Btn.Name = "Button_" .. name
            Btn.Size = UDim2.new(1, 0, 0, 32)
            Btn.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
            Btn.BorderSizePixel = 0
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.Parent = Container

            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 6)
            BCorner.Parent = Btn

            local BStroke = Instance.new("UIStroke")
            BStroke.Color = Color3.fromRGB(40, 44, 58)
            BStroke.Thickness = 1
            BStroke.Parent = Btn

            local HLayout = Instance.new("UIListLayout")
            HLayout.FillDirection = Enum.FillDirection.Horizontal
            HLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            HLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            HLayout.Padding = UDim.new(0, 8)
            HLayout.Parent = Btn

            if iconKey then
                local Icon = Instance.new("ImageLabel")
                Icon.Size = UDim2.fromOffset(14, 14)
                Icon.BackgroundTransparency = 1
                Icon.Image = VRSLibV2.Icons.Get(iconKey)
                Icon.ImageColor3 = VRSLibV2.Theme.TextSecondary
                Icon.Parent = Btn
            end

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0, 0, 1, 0)
            Lbl.AutomaticSize = Enum.AutomaticSize.X
            Lbl.BackgroundTransparency = 1
            Lbl.Text = name
            Lbl.Font = Enum.Font.GothamBold
            Lbl.TextSize = 12
            Lbl.TextColor3 = VRSLibV2.Theme.TextPrimary
            Lbl.Parent = Btn
            ProtectLocalization(Lbl)

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(32, 35, 48) }):Play()
                TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = VRSLibV2.Theme.Accent }):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(24, 26, 36) }):Play()
                TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(40, 44, 58) }):Play()
            end)
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.08), { Size = UDim2.new(0.98, 0, 0, 30) }):Play()
                task.delay(0.08, function()
                    TweenService:Create(Btn, TweenInfo.new(0.08), { Size = UDim2.new(1, 0, 0, 32) }):Play()
                end)
                callback()
            end)

            table.insert(self.Window.AllElements, { Frame = Btn, SearchText = name })
            return Btn
        end

        -- ======================================================================
        -- ELEMENT: DROPDOWN (Modern Inline Drop Bar)
        -- ======================================================================
        function GroupObj:AddDropdown(elemCfg)
            elemCfg = elemCfg or {}
            local name     = elemCfg.Name or "Dropdown"
            local options  = elemCfg.Options or {}
            local default  = elemCfg.Default or options[1] or "Select..."
            local isMulti  = elemCfg.Multi or false
            local callback = elemCfg.Callback or function() end

            local currentSelection = isMulti and (type(default) == "table" and default or {}) or default

            local Box = Instance.new("Frame")
            Box.Name = "Dropdown_" .. name
            Box.Size = UDim2.new(1, 0, 0, 32)
            Box.BackgroundTransparency = 1
            Box.Parent = Container

            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0.48, 0, 1, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = name
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextSize = 12
            Lbl.TextColor3 = VRSLibV2.Theme.TextPrimary
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = Box
            ProtectLocalization(Lbl)

            local Trigger = Instance.new("TextButton")
            Trigger.AnchorPoint = Vector2.new(1, 0.5)
            Trigger.Position = UDim2.new(1, 0, 0.5, 0)
            Trigger.Size = UDim2.new(0.5, 0, 0, 28)
            Trigger.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
            Trigger.BorderSizePixel = 0
            Trigger.Text = ""
            Trigger.AutoButtonColor = false
            Trigger.Parent = Box

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 6)
            TCorner.Parent = Trigger

            local TStroke = Instance.new("UIStroke")
            TStroke.Color = Color3.fromRGB(42, 45, 60)
            TStroke.Thickness = 1
            TStroke.Parent = Trigger

            local TLbl = Instance.new("TextLabel")
            TLbl.Size = UDim2.new(1, -28, 1, 0)
            TLbl.Position = UDim2.new(0, 8, 0, 0)
            TLbl.BackgroundTransparency = 1
            TLbl.Font = Enum.Font.GothamMedium
            TLbl.TextSize = 11
            TLbl.TextColor3 = VRSLibV2.Theme.TextSecondary
            TLbl.TextXAlignment = Enum.TextXAlignment.Left
            TLbl.TextTruncate = Enum.TextTruncate.AtEnd
            TLbl.Parent = Trigger
            ProtectLocalization(TLbl)

            local Arrow = Instance.new("ImageLabel")
            Arrow.Size = UDim2.fromOffset(13, 13)
            Arrow.Position = UDim2.new(1, -20, 0.5, -6.5)
            Arrow.BackgroundTransparency = 1
            Arrow.Image = VRSLibV2.Icons.Get("chevron-down")
            Arrow.ImageColor3 = VRSLibV2.Theme.TextMuted
            Arrow.Parent = Trigger

            local function FormatDisplayText()
                if isMulti then
                    local count = 0
                    local preview = {}
                    for _, v in ipairs(options) do
                        if currentSelection[v] then
                            count = count + 1
                            table.insert(preview, v)
                        end
                    end
                    if count == 0 then return "None" end
                    return table.concat(preview, ", ")
                else
                    return tostring(currentSelection)
                end
            end
            TLbl.Text = FormatDisplayText()

            -- Dropdown Floating Menu
            local DropMenu = Instance.new("Frame")
            DropMenu.Name = "DropMenu"
            DropMenu.Size = UDim2.new(0.5, 0, 0, 0)
            DropMenu.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
            DropMenu.BorderSizePixel = 0
            DropMenu.ClipsDescendants = true
            DropMenu.Visible = false
            DropMenu.ZIndex = 50
            DropMenu.Parent = self.Window.MainFrame

            local DMCorner = Instance.new("UICorner")
            DMCorner.CornerRadius = UDim.new(0, 6)
            DMCorner.Parent = DropMenu

            local DMStroke = Instance.new("UIStroke")
            DMStroke.Color = VRSLibV2.Theme.Accent
            DMStroke.Thickness = 1
            DMStroke.Parent = DropMenu

            local DScroll = Instance.new("ScrollingFrame")
            DScroll.Size = UDim2.new(1, 0, 1, 0)
            DScroll.BackgroundTransparency = 1
            DScroll.BorderSizePixel = 0
            DScroll.ScrollBarThickness = 2
            DScroll.ScrollBarImageColor3 = VRSLibV2.Theme.Accent
            DScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            DScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            DScroll.ZIndex = 51
            DScroll.Parent = DropMenu

            local DLayout = Instance.new("UIListLayout")
            DLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DLayout.Padding = UDim.new(0, 2)
            DLayout.Parent = DScroll

            local isOpen = false
            local function RenderOptions()
                for _, ch in ipairs(DScroll:GetChildren()) do
                    if ch:IsA("TextButton") then ch:Destroy() end
                end

                for idx, opt in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1, 0, 0, 26)
                    optBtn.BackgroundTransparency = 1
                    optBtn.Text = ""
                    optBtn.ZIndex = 52
                    optBtn.LayoutOrder = idx
                    optBtn.Parent = DScroll

                    local oLbl = Instance.new("TextLabel")
                    oLbl.Size = UDim2.new(1, -26, 1, 0)
                    oLbl.Position = UDim2.new(0, 8, 0, 0)
                    oLbl.BackgroundTransparency = 1
                    oLbl.Text = opt
                    oLbl.Font = Enum.Font.GothamMedium
                    oLbl.TextSize = 11.5
                    local isSelected = isMulti and currentSelection[opt] or (currentSelection == opt)
                    oLbl.TextColor3 = isSelected and VRSLibV2.Theme.Accent or VRSLibV2.Theme.TextSecondary
                    oLbl.TextXAlignment = Enum.TextXAlignment.Left
                    oLbl.ZIndex = 53
                    oLbl.Parent = optBtn
                    ProtectLocalization(oLbl)

                    if isSelected then
                        local check = Instance.new("ImageLabel")
                        check.Size = UDim2.fromOffset(13, 13)
                        check.Position = UDim2.new(1, -20, 0.5, -6.5)
                        check.BackgroundTransparency = 1
                        check.Image = VRSLibV2.Icons.Get("check")
                        check.ImageColor3 = VRSLibV2.Theme.Accent
                        check.ZIndex = 53
                        check.Parent = optBtn
                    end

                    optBtn.MouseButton1Click:Connect(function()
                        if isMulti then
                            currentSelection[opt] = not currentSelection[opt]
                            TLbl.Text = FormatDisplayText()
                            RenderOptions()
                            callback(currentSelection)
                        else
                            currentSelection = opt
                            TLbl.Text = opt
                            isOpen = false
                            DropMenu.Visible = false
                            Arrow.Rotation = 0
                            callback(currentSelection)
                        end
                    end)
                end
            end

            Trigger.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    local absPos = Trigger.AbsolutePosition
                    local mainPos = self.Window.MainFrame.AbsolutePosition
                    local relX = absPos.X - mainPos.X
                    local relY = absPos.Y - mainPos.Y + Trigger.AbsoluteSize.Y + 4

                    DropMenu.Position = UDim2.fromOffset(relX, relY)
                    local menuHeight = math.min(#options * 28 + 6, 140)
                    DropMenu.Size = UDim2.new(0, Trigger.AbsoluteSize.X, 0, menuHeight)
                    DropMenu.Visible = true
                    Arrow.Rotation = 180
                    RenderOptions()
                else
                    DropMenu.Visible = false
                    Arrow.Rotation = 0
                end
            end)

            table.insert(self.Window.AllElements, { Frame = Box, SearchText = name })

            return {
                Set = function(_, val)
                    currentSelection = val
                    TLbl.Text = FormatDisplayText()
                    callback(currentSelection)
                end,
                Refresh = function(_, newOptions)
                    options = newOptions or {}
                    if isOpen then RenderOptions() end
                end,
                Value = function() return currentSelection end
            }
        end

        return GroupObj
    end
end

return VRSLibV2
