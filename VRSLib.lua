--[[
    ==============================================================================
    🌸 VRS ARTELIER — MODULAR CARD ENGINE (PROPRIETARY)
    ==============================================================================
    Design: VRS Artelier Cyber-Dark, 100% Signature Neon Magenta Pink (#FF408C)
    Features:
      - Wings Brand Logo in Header & Draggable Floating Mobile Widget
      - Free Window Drag-Resizing (Drag Bottom-Right ⤡ or Edges to resize freely!)
      - Dynamic Column Reflow (3 to 6 columns automatically based on window width!)
      - Topbar with Live Instant Module Search & Window Controls (-, ⛶, ✕)
      - Left Sidebar with QUICK (All modules [47], Pinned, Active) & Custom Categories
      - Live User Profile footer with Roblox Headshot Avatar & Settings
      - Content Breadcrumbs & Verified View Switchers (Grid ⊞, List ☰, Compact 𝄜)
      - Compact Module Cards (78px height) with Smooth Pink Pill Toggles & Action Buttons (▷)
      - Integrated Sliders, Keybinds, and Sub-settings
      - Safe Environment & AutoLocalize Protection
    ==============================================================================
]]

local cloneref = (cloneref or clonereference or function(i) return i end)
local CoreGui          = cloneref(game:GetService("CoreGui"))
local Players          = cloneref(game:GetService("Players"))
local TweenService     = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService       = cloneref(game:GetService("RunService"))
local LocalPlayer      = Players.LocalPlayer or Players.PlayerAdded:Wait()

local VRSLib = {
    Version = "1.3.0",
    Theme = {
        Background      = Color3.fromRGB(13, 14, 19),
        Sidebar         = Color3.fromRGB(16, 17, 24),
        Header          = Color3.fromRGB(13, 14, 19),
        Card            = Color3.fromRGB(20, 21, 30),
        CardHover       = Color3.fromRGB(28, 30, 44),
        CardStroke      = Color3.fromRGB(30, 32, 46),
        CardStrokeHover = Color3.fromRGB(255, 64, 140),
        InputBackground = Color3.fromRGB(18, 19, 28),
        InputStroke     = Color3.fromRGB(34, 36, 52),
        Accent          = Color3.fromRGB(255, 64, 140), -- VRS Signature Neon Magenta Pink (#FF408C)
        AccentHover     = Color3.fromRGB(255, 96, 160),
        AccentGlow      = Color3.fromRGB(255, 64, 140),
        Outline         = Color3.fromRGB(28, 30, 44),
        TextPrimary     = Color3.fromRGB(255, 255, 255),
        TextMuted       = Color3.fromRGB(228, 234, 248),
        BadgeBackground = Color3.fromRGB(24, 25, 38),
        BadgeText       = Color3.fromRGB(255, 255, 255),
        SwitchOff       = Color3.fromRGB(34, 36, 50),
        SwitchOffKnob   = Color3.fromRGB(115, 120, 140),
        SwitchOnKnob    = Color3.fromRGB(255, 255, 255),
        ActionBtn       = Color3.fromRGB(46, 18, 34),
        ActionBtnHover  = Color3.fromRGB(70, 26, 52),
        ActionBtnIcon   = Color3.fromRGB(255, 64, 140),
        ResizeGrip      = Color3.fromRGB(120, 125, 150),
    },
    -- Injected Lucide Icon Engine
    Icons = (function()
        local GITHUB_REPO = "https://raw.githubusercontent.com/vrsspace/VRSLib/v1.1.1/"
        local function TryImport(file)
            if isfile and isfile(file) then
                local ok, res = pcall(function() return loadstring(readfile(file))() end)
                if ok and res then return res end
            end
            if isfile and isfile("src/" .. file) then
                local ok, res = pcall(function() return loadstring(readfile("src/" .. file))() end)
                if ok and res then return res end
            end
            local ok, res = pcall(function()
                return loadstring(game:HttpGet(GITHUB_REPO .. "src/" .. file .. "?v=" .. tick()))()
            end)
            if ok and res then return res end
            return nil
        end

        local mod = TryImport("Icons.lua")
        if mod then return mod end

        -- Emergency minimal fallback
        local Fallback = {
            Wings   = "rbxassetid://132717088484517",
            Default = "rbxassetid://10709782497",
            Get = function(name)
                if name == "Wings" or name == "rbxassetid://132717088484517" then
                    return "rbxassetid://132717088484517"
                end
                return "rbxassetid://10709782497"
            end
        }
        return Fallback
    end)(),
    Windows = {},
}

-- Safe GUI Container Resolver
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
-- OFFICIAL VRS ARTELIER BRAND LOGO (PERMANENT TEMPLATE)
-- ==============================================================================
local BRAND_LOGO_URL = "https://raw.githubusercontent.com/vrsspace/VRSLib/v1.1.9/assets/logo.png"
local cachedLogoAsset = nil

local function GetBrandLogo()
    if cachedLogoAsset then return cachedLogoAsset end
    local fileName = "vrs_artelier_logo_v2.png"

    if writefile and isfile and (getcustomasset or getsynasset) then
        local customAsset = getcustomasset or getsynasset
        if not isfile(fileName) then
            local s, data = pcall(function()
                return game:HttpGet(BRAND_LOGO_URL)
            end)
            if s and data and #data > 50 then
                pcall(function() writefile(fileName, data) end)
            end
        end
        if isfile(fileName) then
            local ok, asset = pcall(function() return customAsset(fileName) end)
            if ok and asset then
                cachedLogoAsset = asset
                return asset
            end
        end
    end

    -- Fallback to original asset ID if executor doesn't support getcustomasset
    return "rbxassetid://132717088484517"
end

local function ApplyBrandLogo(imageLabel)
    local asset = GetBrandLogo()
    imageLabel.Image = asset
    if tostring(asset):find("132717088484517") then
        imageLabel.ImageRectOffset = Vector2.new(159, 225)
        imageLabel.ImageRectSize = Vector2.new(686, 535)
        imageLabel.ImageColor3 = VRSLib.Theme.Accent
    else
        -- Clean 100% transparent cropped logo without box artifacts
        imageLabel.ImageRectOffset = Vector2.new(0, 0)
        imageLabel.ImageRectSize = Vector2.new(0, 0)
        imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Helper: Dragging Window
local function MakeDraggable(dragHandle, targetFrame)
    local dragging = false
    local dragInput, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
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

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(targetFrame, TweenInfo.new(0.04, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }):Play()
        end
    end)
end

-- ==============================================================================
-- NOTIFICATION TOAST SYSTEM
-- ==============================================================================
local NotifyContainer = nil
local function EnsureNotifyContainer()
    if NotifyContainer and NotifyContainer.Parent then return NotifyContainer end
    local sg = Instance.new("ScreenGui")
    sg.Name = "VRS_Notify_" .. math.random(100, 999)
    sg.ResetOnSpawn = false
    sg.Parent = GetSafeContainer()

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 310, 1, -40)
    frame.Position = UDim2.new(1, -325, 0, 20)
    frame.BackgroundTransparency = 1
    frame.Parent = sg

    local list = Instance.new("UIListLayout")
    list.VerticalAlignment = Enum.VerticalAlignment.Bottom
    list.Padding = UDim.new(0, 8)
    list.Parent = frame

    NotifyContainer = frame
    return NotifyContainer
end

function VRSLib:Notify(a1, a2, a3, a4)
    local cfg = {}
    local arg1, arg2, arg3, arg4 = a1, a2, a3, a4

    if self ~= VRSLib and (type(self) ~= "table" or not self.CreateWindow) then
        arg4 = arg3
        arg3 = arg2
        arg2 = arg1
        arg1 = self
    end

    if type(arg1) == "table" then
        cfg = arg1
    elseif type(arg1) == "string" then
        if type(arg2) == "number" then
            cfg = { Title = "VRS Artelier", Description = arg1, Duration = arg2, Icon = arg3 }
        elseif type(arg2) == "string" then
            cfg = { Title = arg1, Description = arg2, Duration = tonumber(arg3) or 3.5, Icon = arg4 }
        else
            cfg = { Title = "VRS Artelier", Description = arg1, Duration = 3.5, Icon = arg2 }
        end
    else
        cfg = { Title = "VRS Artelier", Description = tostring(arg1 or ""), Duration = 3.5 }
    end

    local title  = tostring(cfg.Title or "VRS Artelier")
    local desc   = tostring(cfg.Description or cfg.Content or "")
    local dur    = tonumber(cfg.Duration) or 3.5
    local iconId = "Wings"
    if cfg.Icon then
        if VRSLib.Icons and type(VRSLib.Icons.Get) == "function" then
            iconId = VRSLib.Icons.Get(cfg.Icon)
        else
            iconId = cfg.Icon
        end
    elseif VRSLib.Icons and VRSLib.Icons.Wings then
        iconId = VRSLib.Icons.Wings
    end
    local container = EnsureNotifyContainer()

    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(1, 0, 0, 56)
    toast.Position = UDim2.new(1, 350, 0, 0)
    toast.BackgroundColor3 = VRSLib.Theme.Card
    toast.BorderSizePixel = 0
    toast.ClipsDescendants = true
    toast.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toast

    local stroke = Instance.new("UIStroke")
    stroke.Color = VRSLib.Theme.Outline
    stroke.Thickness = 1
    stroke.Parent = toast

    local stripe = Instance.new("Frame")
    stripe.Size = UDim2.new(0, 3, 1, 0)
    stripe.BackgroundColor3 = VRSLib.Theme.Accent
    stripe.BorderSizePixel = 0
    stripe.Parent = toast

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.fromOffset(22, 22)
    icon.Position = UDim2.new(0, 12, 0.5, -11)
    icon.BackgroundTransparency = 1
    if iconId == VRSLib.Icons.Wings or iconId == "Wings" then
        ApplyBrandLogo(icon)
    else
        icon.Image = iconId
        icon.ImageColor3 = VRSLib.Theme.Accent
    end
    icon.Parent = toast

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -45, 0, 18)
    tLbl.Position = UDim2.new(0, 42, 0, 9)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 12.5
    tLbl.TextColor3 = VRSLib.Theme.TextPrimary
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = toast

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(1, -45, 0, 16)
    dLbl.Position = UDim2.new(0, 42, 0, 28)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = desc
    dLbl.Font = Enum.Font.GothamMedium
    dLbl.TextSize = 11
    dLbl.TextColor3 = VRSLib.Theme.TextMuted
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.TextTruncate = Enum.TextTruncate.AtEnd
    dLbl.Parent = toast

    ProtectLocalization(tLbl)
    ProtectLocalization(dLbl)

    TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
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
    return VRSLib:Notify(...)
end

function VRSLib:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, Window)

    self.Title          = config.Title or "VRS Artelier"
    self.SubTitle       = config.SubTitle or "v1.1.9 Pro"
    self.DefaultSize    = config.Size or UDim2.fromOffset(1020, 620)
    self.MaximizedSize  = UDim2.fromOffset(1240, 740)
    self.Keybind        = config.Keybind or Enum.KeyCode.RightControl
    self.Visible        = true
    self.IsMaximized    = false
    self.CurrentView    = "Grid"
    self.CurrentCategory= "QUICK"
    self.ActiveTab      = nil
    self.SearchQuery    = ""
    self.Categories     = {}
    self.CategoryObjects = {}
    self.Tabs           = {}
    self.AllCards       = {}

    if config.Accent then
        VRSLib.Theme.Accent = config.Accent
        VRSLib.Theme.CardStrokeHover = config.Accent
        VRSLib.Theme.ActionBtnIcon = config.Accent
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VRS_Artelier_Engine"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GetSafeContainer()
    self.Gui = ScreenGui

    ScreenGui.DescendantAdded:Connect(ProtectLocalization)

    -- Main Shell Frame
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = self.DefaultSize
    Main.Position = UDim2.new(0.5, -self.DefaultSize.X.Offset / 2, 0.5, -self.DefaultSize.Y.Offset / 2)
    Main.BackgroundColor3 = VRSLib.Theme.Background
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.ClipsDescendants = false
    Main.Parent = ScreenGui
    self.MainFrame = Main

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = VRSLib.Theme.Outline
    MainStroke.Thickness = 1.2
    MainStroke.Parent = Main

    -- Outer Ambient Neon Pink Glow
    local AmbientGlow = Instance.new("ImageLabel")
    AmbientGlow.Name = "AmbientGlow"
    AmbientGlow.Size = UDim2.new(1, 50, 1, 50)
    AmbientGlow.Position = UDim2.new(0, -25, 0, -25)
    AmbientGlow.BackgroundTransparency = 1
    AmbientGlow.Image = "rbxassetid://5028857084"
    AmbientGlow.ImageColor3 = VRSLib.Theme.Accent
    AmbientGlow.ImageTransparency = 0.85
    AmbientGlow.ZIndex = 0
    AmbientGlow.Parent = Main

    -- ==============================================================================
    -- TOPBAR
    -- ==============================================================================
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 50)
    Topbar.BackgroundColor3 = VRSLib.Theme.Header
    Topbar.BorderSizePixel = 0
    Topbar.Parent = Main

    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 10)
    TopbarCorner.Parent = Topbar

    local TopbarCover = Instance.new("Frame")
    TopbarCover.Size = UDim2.new(1, 0, 0, 10)
    TopbarCover.Position = UDim2.new(0, 0, 1, -10)
    TopbarCover.BackgroundColor3 = VRSLib.Theme.Header
    TopbarCover.BorderSizePixel = 0
    TopbarCover.Parent = Topbar

    local TopbarDivider = Instance.new("Frame")
    TopbarDivider.Size = UDim2.new(1, 0, 0, 1)
    TopbarDivider.Position = UDim2.new(0, 0, 1, 0)
    TopbarDivider.BackgroundColor3 = VRSLib.Theme.Outline
    TopbarDivider.BorderSizePixel = 0
    TopbarDivider.Parent = Topbar

    -- Brand Box with Prominent Big Wings Logo (Centered in 220px Sidebar Header Column, Massive & Crisp)
    local BrandBox = Instance.new("Frame")
    BrandBox.Name = "BrandBox"
    BrandBox.Size = UDim2.new(0, 220, 1, 0)
    BrandBox.Position = UDim2.new(0, 0, 0, 0)
    BrandBox.BackgroundTransparency = 1
    BrandBox.Parent = Topbar

    local WingsLogo = Instance.new("ImageLabel")
    WingsLogo.Name = "WingsLogo"
    WingsLogo.Size = UDim2.fromOffset(54, 40)
    WingsLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    WingsLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    WingsLogo.BackgroundTransparency = 1
    WingsLogo.ScaleType = Enum.ScaleType.Stretch
    ApplyBrandLogo(WingsLogo)
    WingsLogo.Parent = BrandBox

    BrandBox.MouseEnter:Connect(function()
        TweenService:Create(WingsLogo, TweenInfo.new(0.2), { Size = UDim2.fromOffset(58, 43) }):Play()
    end)
    BrandBox.MouseLeave:Connect(function()
        TweenService:Create(WingsLogo, TweenInfo.new(0.2), { Size = UDim2.fromOffset(54, 40) }):Play()
    end)

    -- Live Search Input Box: Left-aligned in Content Area (Position 236px, perfectly anchored)
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Name = "SearchBox"
    SearchFrame.AnchorPoint = Vector2.new(0, 0.5)
    SearchFrame.Position = UDim2.new(0, 236, 0.5, 0)
    SearchFrame.Size = UDim2.new(0, 285, 0, 30)
    SearchFrame.BackgroundColor3 = VRSLib.Theme.InputBackground
    SearchFrame.BorderSizePixel = 0
    SearchFrame.Parent = Topbar
    self.SearchFrame = SearchFrame

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchFrame

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = VRSLib.Theme.InputStroke
    SearchStroke.Thickness = 1
    SearchStroke.Parent = SearchFrame

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.fromOffset(13, 13)
    SearchIcon.Position = UDim2.new(0, 10, 0.5, -6.5)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = VRSLib.Icons.Get("search")
    SearchIcon.ImageColor3 = VRSLib.Theme.TextMuted
    SearchIcon.Parent = SearchFrame

    local SearchInput = Instance.new("TextBox")
    SearchInput.Size = UDim2.new(1, -62, 1, 0)
    SearchInput.Position = UDim2.new(0, 30, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.Font = Enum.Font.GothamMedium
    SearchInput.PlaceholderText = "Search modules..."
    SearchInput.PlaceholderColor3 = VRSLib.Theme.TextMuted
    SearchInput.Text = ""
    SearchInput.TextColor3 = VRSLib.Theme.TextPrimary
    SearchInput.TextSize = 11.5
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.ClearTextOnFocus = false
    SearchInput.Parent = SearchFrame
    ProtectLocalization(SearchInput)

    local ClearBtn = Instance.new("ImageButton")
    ClearBtn.Name = "ClearSearch"
    ClearBtn.Size = UDim2.fromOffset(14, 14)
    ClearBtn.Position = UDim2.new(1, -24, 0.5, -7)
    ClearBtn.BackgroundTransparency = 1
    ClearBtn.Image = VRSLib.Icons.Get("close")
    ClearBtn.ImageColor3 = VRSLib.Theme.TextMuted
    ClearBtn.Visible = false
    ClearBtn.Parent = SearchFrame

    ClearBtn.MouseButton1Click:Connect(function()
        SearchInput.Text = ""
        self:FilterModules("")
    end)

    local ShortcutPill = Instance.new("Frame")
    ShortcutPill.Name = "ShortcutPill"
    ShortcutPill.Size = UDim2.fromOffset(18, 18)
    ShortcutPill.Position = UDim2.new(1, -26, 0.5, -9)
    ShortcutPill.BackgroundColor3 = VRSLib.Theme.Card
    ShortcutPill.BorderSizePixel = 0
    ShortcutPill.Parent = SearchFrame

    local SPCorner = Instance.new("UICorner")
    SPCorner.CornerRadius = UDim.new(0, 4)
    SPCorner.Parent = ShortcutPill

    local SPText = Instance.new("TextLabel")
    SPText.Size = UDim2.new(1, 0, 1, 0)
    SPText.BackgroundTransparency = 1
    SPText.Text = "/"
    SPText.Font = Enum.Font.GothamBold
    SPText.TextSize = 10
    SPText.TextColor3 = VRSLib.Theme.TextMuted
    SPText.Parent = ShortcutPill
    ProtectLocalization(SPText)

    SearchInput.Focused:Connect(function()
        TweenService:Create(SearchStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.Accent }):Play()
        TweenService:Create(SearchIcon, TweenInfo.new(0.15), { ImageColor3 = VRSLib.Theme.Accent }):Play()
    end)
    SearchInput.FocusLost:Connect(function()
        TweenService:Create(SearchStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.InputStroke }):Play()
        TweenService:Create(SearchIcon, TweenInfo.new(0.15), { ImageColor3 = VRSLib.Theme.TextMuted }):Play()
    end)

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local txt = SearchInput.Text
        local hasText = txt ~= ""
        ClearBtn.Visible = hasText
        ShortcutPill.Visible = not hasText
        self:FilterModules(txt)
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.Slash then
            task.defer(function()
                if SearchInput and SearchInput.Parent then
                    SearchInput:CaptureFocus()
                end
            end)
        end
    end)

    -- Window Controls (-, ⛶, ✕)
    local Controls = Instance.new("Frame")
    Controls.Size = UDim2.new(0, 95, 1, 0)
    Controls.Position = UDim2.new(1, -105, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = Topbar

    local cList = Instance.new("UIListLayout")
    cList.FillDirection = Enum.FillDirection.Horizontal
    cList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    cList.VerticalAlignment = Enum.VerticalAlignment.Center
    cList.Padding = UDim.new(0, 4)
    cList.Parent = Controls

    local function CreateTopBtn(iconId, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(26, 26)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = Controls

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.fromOffset(13, 13)
        icon.Position = UDim2.new(0.5, -6.5, 0.5, -6.5)
        icon.BackgroundTransparency = 1
        icon.Image = iconId
        icon.ImageColor3 = VRSLib.Theme.TextMuted
        icon.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(icon, TweenInfo.new(0.15), { ImageColor3 = VRSLib.Theme.TextPrimary }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(icon, TweenInfo.new(0.15), { ImageColor3 = VRSLib.Theme.TextMuted }):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    CreateTopBtn(VRSLib.Icons.Get("minimize"), function() self:Toggle() end)
    CreateTopBtn(VRSLib.Icons.Get("maximize"), function() self:ToggleMaximize() end)
    CreateTopBtn(VRSLib.Icons.Get("close"), function() self:Unload() end)

    MakeDraggable(Topbar, Main)

    -- ==============================================================================
    -- BODY (SIDEBAR + MAIN CONTENT) — Positioned between Topbar (50px) & FooterBar (22px)
    -- ==============================================================================
    local Body = Instance.new("Frame")
    Body.Size = UDim2.new(1, 0, 1, -72)
    Body.Position = UDim2.new(0, 0, 0, 50)
    Body.BackgroundTransparency = 1
    Body.Parent = Main

    -- ==============================================================================
    -- LEFT SIDEBAR
    -- ==============================================================================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 220, 1, 0)
    Sidebar.ClipsDescendants = true
    self.Sidebar = Sidebar
    self.SidebarCollapsed = false
    Sidebar.BackgroundColor3 = VRSLib.Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Body

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    SidebarDivider.Position = UDim2.new(1, 0, 0, 0)
    SidebarDivider.BackgroundColor3 = VRSLib.Theme.Outline
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Parent = Sidebar

    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Size = UDim2.new(1, 0, 1, -50)
    SidebarScroll.Position = UDim2.new(0, 0, 0, 4)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.ScrollBarThickness = 2
    SidebarScroll.ScrollBarImageColor3 = VRSLib.Theme.Outline
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SidebarScroll.Parent = Sidebar

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 2)
    SidebarList.Parent = SidebarScroll

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingLeft = UDim.new(0, 8)
    SidebarPadding.PaddingRight = UDim.new(0, 8)
    SidebarPadding.PaddingTop = UDim.new(0, 4)
    SidebarPadding.PaddingBottom = UDim.new(0, 8)
    SidebarPadding.Parent = SidebarScroll
    self.SidebarScroll = SidebarScroll

    -- Profile Bar (Bottom Left)
    local ProfileBar = Instance.new("Frame")
    ProfileBar.Name = "ProfileBar"
    ProfileBar.Size = UDim2.new(1, 0, 0, 50)
    ProfileBar.Position = UDim2.new(0, 0, 1, -50)
    ProfileBar.BackgroundColor3 = VRSLib.Theme.Sidebar
    ProfileBar.BorderSizePixel = 0
    ProfileBar.Parent = Sidebar

    local ProfileDivider = Instance.new("Frame")
    ProfileDivider.Size = UDim2.new(1, 0, 0, 1)
    ProfileDivider.BackgroundColor3 = VRSLib.Theme.Outline
    ProfileDivider.BorderSizePixel = 0
    ProfileDivider.Parent = ProfileBar

    local AvatarFrame = Instance.new("Frame")
    AvatarFrame.Size = UDim2.fromOffset(28, 28)
    AvatarFrame.Position = UDim2.new(0, 10, 0.5, -14)
    AvatarFrame.BackgroundColor3 = VRSLib.Theme.Card
    AvatarFrame.BorderSizePixel = 0
    AvatarFrame.Parent = ProfileBar

    local AvCorner = Instance.new("UICorner")
    AvCorner.CornerRadius = UDim.new(1, 0)
    AvCorner.Parent = AvatarFrame

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Size = UDim2.new(1, 0, 1, 0)
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    AvatarImg.Parent = AvatarFrame

    local AvImgCorner = Instance.new("UICorner")
    AvImgCorner.CornerRadius = UDim.new(1, 0)
    AvImgCorner.Parent = AvatarImg

    local UserNameLbl = Instance.new("TextLabel")
    UserNameLbl.Size = UDim2.new(1, -85, 0, 16)
    UserNameLbl.Position = UDim2.new(0, 46, 0.5, -8)
    UserNameLbl.BackgroundTransparency = 1
    UserNameLbl.Text = LocalPlayer.Name
    UserNameLbl.Font = Enum.Font.GothamBold
    UserNameLbl.TextSize = 11.5
    UserNameLbl.TextColor3 = VRSLib.Theme.TextPrimary
    UserNameLbl.TextXAlignment = Enum.TextXAlignment.Left
    UserNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    UserNameLbl.Parent = ProfileBar

    local SettingsBtn = Instance.new("TextButton")
    SettingsBtn.Size = UDim2.fromOffset(24, 24)
    SettingsBtn.Position = UDim2.new(1, -32, 0.5, -12)
    SettingsBtn.BackgroundTransparency = 1
    SettingsBtn.Text = ""
    SettingsBtn.Parent = ProfileBar

    local GearIcon = Instance.new("ImageLabel")
    GearIcon.Size = UDim2.fromOffset(15, 15)
    GearIcon.Position = UDim2.new(0.5, -7.5, 0.5, -7.5)
    GearIcon.BackgroundTransparency = 1
    GearIcon.Image = VRSLib.Icons.Get("settings")
    GearIcon.ImageColor3 = VRSLib.Theme.TextMuted
    GearIcon.Parent = SettingsBtn

    SettingsBtn.MouseEnter:Connect(function()
        TweenService:Create(GearIcon, TweenInfo.new(0.15), { ImageColor3 = VRSLib.Theme.Accent, Rotation = 45 }):Play()
    end)
    SettingsBtn.MouseLeave:Connect(function()
        TweenService:Create(GearIcon, TweenInfo.new(0.15), { ImageColor3 = VRSLib.Theme.TextMuted, Rotation = 0 }):Play()
    end)
    SettingsBtn.MouseButton1Click:Connect(function()
        VRSLib:Notify({
            Title = "VRS Artelier",
            Description = "Framework: VRS Artelier v1.1.4 Pro\nGame: " .. (self.DetectedGame or "Detecting...") .. "\nToggle Key: RightControl",
            Duration = 3,
            Icon = VRSLib.Icons.Wings
        })
    end)



    -- ==============================================================================
    -- MAIN CONTENT AREA
    -- ==============================================================================
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -221, 1, 0)
    ContentArea.Position = UDim2.new(0, 221, 0, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = Body
    self.ContentArea = ContentArea

    -- Header / Sub-navbar inside Content Area (Sidebar Toggle + Breadcrumb + View Switchers)
    local ContentHeader = Instance.new("Frame")
    ContentHeader.Size = UDim2.new(1, 0, 0, 38)
    ContentHeader.BackgroundTransparency = 1
    ContentHeader.Parent = ContentArea

    -- Sidebar Minimize / Expand Button [ ☰ ]
    local SidebarToggleBtn = Instance.new("ImageButton")
    SidebarToggleBtn.Name = "SidebarToggleBtn"
    SidebarToggleBtn.Size = UDim2.fromOffset(22, 22)
    SidebarToggleBtn.Position = UDim2.new(0, 12, 0.5, -11)
    SidebarToggleBtn.BackgroundColor3 = VRSLib.Theme.Card
    SidebarToggleBtn.BackgroundTransparency = 1
    SidebarToggleBtn.BorderSizePixel = 0
    SidebarToggleBtn.AutoButtonColor = false
    SidebarToggleBtn.Image = VRSLib.Icons.Get("sidebar")
    SidebarToggleBtn.ImageColor3 = VRSLib.Theme.TextMuted
    SidebarToggleBtn.Parent = ContentHeader

    local STBCorner = Instance.new("UICorner")
    STBCorner.CornerRadius = UDim.new(0, 5)
    STBCorner.Parent = SidebarToggleBtn

    SidebarToggleBtn.MouseEnter:Connect(function()
        TweenService:Create(SidebarToggleBtn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.5,
            ImageColor3 = VRSLib.Theme.Accent
        }):Play()
    end)
    SidebarToggleBtn.MouseLeave:Connect(function()
        TweenService:Create(SidebarToggleBtn, TweenInfo.new(0.15), {
            BackgroundTransparency = 1,
            ImageColor3 = (self.SidebarCollapsed and VRSLib.Theme.Accent or VRSLib.Theme.TextMuted)
        }):Play()
    end)
    SidebarToggleBtn.MouseButton1Click:Connect(function()
        self:ToggleSidebar()
    end)
    self.SidebarToggleBtn = SidebarToggleBtn

    local BreadcrumbBox = Instance.new("Frame")
    BreadcrumbBox.Size = UDim2.new(1, -150, 1, 0)
    BreadcrumbBox.Position = UDim2.new(0, 42, 0, 0)
    BreadcrumbBox.BackgroundTransparency = 1
    BreadcrumbBox.Parent = ContentHeader

    local BreadcrumbCategory = Instance.new("TextLabel")
    BreadcrumbCategory.Size = UDim2.new(0, 0, 1, 0)
    BreadcrumbCategory.AutomaticSize = Enum.AutomaticSize.X
    BreadcrumbCategory.BackgroundTransparency = 1
    BreadcrumbCategory.Text = "QUICK / "
    BreadcrumbCategory.Font = Enum.Font.GothamMedium
    BreadcrumbCategory.TextSize = 11.5
    BreadcrumbCategory.TextColor3 = Color3.fromRGB(225, 230, 245)
    BreadcrumbCategory.TextXAlignment = Enum.TextXAlignment.Left
    BreadcrumbCategory.Parent = BreadcrumbBox
    ProtectLocalization(BreadcrumbCategory)

    local BreadcrumbTab = Instance.new("TextLabel")
    BreadcrumbTab.Size = UDim2.new(0, 0, 1, 0)
    BreadcrumbTab.AutomaticSize = Enum.AutomaticSize.X
    BreadcrumbTab.Position = UDim2.new(1, 0, 0, 0)
    BreadcrumbTab.BackgroundTransparency = 1
    BreadcrumbTab.Text = "All modules"
    BreadcrumbTab.Font = Enum.Font.GothamBold
    BreadcrumbTab.TextSize = 12.5
    BreadcrumbTab.TextColor3 = VRSLib.Theme.TextPrimary
    BreadcrumbTab.TextXAlignment = Enum.TextXAlignment.Left
    BreadcrumbTab.Parent = BreadcrumbCategory
    ProtectLocalization(BreadcrumbTab)

    local BreadcrumbBadge = Instance.new("TextLabel")
    BreadcrumbBadge.Size = UDim2.new(0, 0, 0, 0)
    BreadcrumbBadge.Position = UDim2.new(1, 6, 0, 0)
    BreadcrumbBadge.BackgroundTransparency = 1
    BreadcrumbBadge.Visible = false
    BreadcrumbBadge.Text = ""
    BreadcrumbBadge.Parent = BreadcrumbTab
    ProtectLocalization(BreadcrumbBadge)

    self.BreadcrumbCategory = BreadcrumbCategory
    self.BreadcrumbTab      = BreadcrumbTab
    self.BreadcrumbBadge    = BreadcrumbBadge

    -- View Switchers on right: [ ⊞ Grid, ☰ List ] (Compact button removed completely)
    local ViewSwitchers = Instance.new("Frame")
    self.ViewSwitchers = ViewSwitchers
    ViewSwitchers.Size = UDim2.new(0, 58, 0, 24)
    ViewSwitchers.Position = UDim2.new(1, -74, 0.5, -12)
    ViewSwitchers.BackgroundColor3 = VRSLib.Theme.Card
    ViewSwitchers.BorderSizePixel = 0
    ViewSwitchers.Parent = ContentHeader

    local VSCorner = Instance.new("UICorner")
    VSCorner.CornerRadius = UDim.new(0, 5)
    VSCorner.Parent = ViewSwitchers

    local VSStroke = Instance.new("UIStroke")
    VSStroke.Color = VRSLib.Theme.Outline
    VSStroke.Thickness = 1
    VSStroke.Parent = ViewSwitchers

    local VSLayout = Instance.new("UIListLayout")
    VSLayout.FillDirection = Enum.FillDirection.Horizontal
    VSLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    VSLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    VSLayout.Padding = UDim.new(0, 2)
    VSLayout.Parent = ViewSwitchers

    local viewIcons = {
        { Id = "Grid", Icon = VRSLib.Icons.Get("grid") },
        { Id = "List", Icon = VRSLib.Icons.Get("list") },
    }

    self.ViewButtons = {}
    for _, item in ipairs(viewIcons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(26, 20)
        btn.BackgroundColor3 = (item.Id == "Grid" and VRSLib.Theme.InputBackground or Color3.fromRGB(0, 0, 0))
        btn.BackgroundTransparency = (item.Id == "Grid" and 0 or 1)
        btn.Text = ""
        btn.Parent = ViewSwitchers

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 4)
        bCorner.Parent = btn

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.fromOffset(13, 13)
        img.Position = UDim2.new(0.5, -6.5, 0.5, -6.5)
        img.BackgroundTransparency = 1
        img.Image = item.Icon
        img.ImageColor3 = (item.Id == "Grid" and VRSLib.Theme.TextPrimary or VRSLib.Theme.TextMuted)
        img.Parent = btn

        btn.MouseButton1Click:Connect(function()
            self:SetViewMode(item.Id)
        end)
        self.ViewButtons[item.Id] = { Button = btn, Icon = img }
    end

    -- Horizontal Sub-Navbar (Centered Layout, Obsidian-Grade Architecture)
    local SubNavBar = Instance.new("Frame")
    SubNavBar.Name = "SubNavBar"
    SubNavBar.Size = UDim2.new(1, 0, 0, 34)
    SubNavBar.Position = UDim2.new(0, 0, 0, 38)
    SubNavBar.BackgroundColor3 = VRSLib.Theme.Sidebar
    SubNavBar.BackgroundTransparency = 0.5
    SubNavBar.BorderSizePixel = 0
    SubNavBar.ClipsDescendants = true
    SubNavBar.Visible = false
    SubNavBar.Parent = ContentArea
    self.SubNavBar = SubNavBar

    local SubNavBorder = Instance.new("Frame")
    SubNavBorder.Size = UDim2.new(1, 0, 0, 1)
    SubNavBorder.Position = UDim2.new(0, 0, 1, -1)
    SubNavBorder.BackgroundColor3 = VRSLib.Theme.Outline
    SubNavBorder.BorderSizePixel = 0
    SubNavBorder.Parent = SubNavBar

    -- Centered SubNav Items Container
    local SubNavContainer = Instance.new("Frame")
    SubNavContainer.Name = "SubNavContainer"
    SubNavContainer.Size = UDim2.new(0, 0, 1, 0)
    SubNavContainer.AutomaticSize = Enum.AutomaticSize.X
    SubNavContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    SubNavContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    SubNavContainer.BackgroundTransparency = 1
    SubNavContainer.Parent = SubNavBar
    self.SubNavContainer = SubNavContainer
    self.SubNavScroll = SubNavContainer -- alias for backwards compatibility

    local SubNavLayout = Instance.new("UIListLayout")
    SubNavLayout.FillDirection = Enum.FillDirection.Horizontal
    SubNavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SubNavLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    SubNavLayout.Padding = UDim.new(0, 14)
    SubNavLayout.Parent = SubNavContainer

    -- Scrolling Container for Content (Cards & Columns)
    local CardsScroll = Instance.new("ScrollingFrame")
    CardsScroll.Name = "CardsScroll"
    CardsScroll.Size = UDim2.new(1, 0, 1, -38)
    CardsScroll.Position = UDim2.new(0, 0, 0, 38)
    CardsScroll.BackgroundTransparency = 1
    CardsScroll.BorderSizePixel = 0
    CardsScroll.ScrollBarThickness = 3
    CardsScroll.ScrollBarImageColor3 = VRSLib.Theme.Outline
    CardsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    CardsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    CardsScroll.Parent = ContentArea
    self.CardsScroll = CardsScroll

    -- Separate Container for standard 4-column 404hub modular card grid
    local GridContainer = Instance.new("Frame")
    GridContainer.Name = "GridContainer"
    GridContainer.Size = UDim2.new(1, 0, 0, 0)
    GridContainer.AutomaticSize = Enum.AutomaticSize.Y
    GridContainer.BackgroundTransparency = 1
    GridContainer.Parent = CardsScroll
    self.GridContainer = GridContainer

    local GridPadding = Instance.new("UIPadding")
    GridPadding.PaddingLeft = UDim.new(0, 16)
    GridPadding.PaddingRight = UDim.new(0, 16)
    GridPadding.PaddingTop = UDim.new(0, 4)
    GridPadding.PaddingBottom = UDim.new(0, 28)
    GridPadding.Parent = GridContainer

    local GridLayout = Instance.new("UIGridLayout")
    GridLayout.CellPadding = UDim2.fromOffset(10, 10)
    GridLayout.CellSize = UDim2.fromOffset(193, 78) -- Recalculated dynamically by ReflowGrid()
    GridLayout.FillDirectionMaxCells = 4
    GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    GridLayout.Parent = GridContainer
    self.GridLayout = GridLayout

    -- Automatically recalculate grid columns when container size changes
    CardsScroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:ReflowGrid()
    end)

    -- Empty Search State Label (Fixed: only visible when search text is active and no cards match)
    local EmptyState = Instance.new("TextLabel")
    EmptyState.Size = UDim2.new(1, -32, 0, 80)
    EmptyState.Position = UDim2.new(0, 16, 0, 60)
    EmptyState.BackgroundTransparency = 1
    EmptyState.Text = "No matching modules found"
    EmptyState.Font = Enum.Font.GothamMedium
    EmptyState.TextSize = 12
    EmptyState.TextColor3 = VRSLib.Theme.TextMuted
    EmptyState.Visible = false
    EmptyState.Parent = ContentArea
    self.EmptyState = EmptyState

    -- ==============================================================================
    -- FREE WINDOW DRAG-RESIZING SYSTEM (CORNER & BORDER DRAGGERS)
    -- ==============================================================================
    -- ==============================================================================
    -- FULL-WIDTH WINDOW FOOTER BAR (VRS Artelier | <Game Name>)
    -- ==============================================================================
    local FooterBar = Instance.new("Frame")
    FooterBar.Name = "FooterBar"
    FooterBar.Size = UDim2.new(1, 0, 0, 22)
    FooterBar.Position = UDim2.new(0, 0, 1, -22)
    FooterBar.BackgroundColor3 = Color3.fromRGB(11, 12, 16)
    FooterBar.BorderSizePixel = 0
    FooterBar.ZIndex = 25
    FooterBar.Parent = Main
    self.FooterBar = FooterBar

    local FooterDivider = Instance.new("Frame")
    FooterDivider.Size = UDim2.new(1, 0, 0, 1)
    FooterDivider.Position = UDim2.new(0, 0, 0, 0)
    FooterDivider.BackgroundColor3 = VRSLib.Theme.Outline
    FooterDivider.BorderSizePixel = 0
    FooterDivider.Parent = FooterBar

    local syncGame = nil
    pcall(function()
        if game.Name and game.Name ~= "" and game.Name ~= "Game" then
            syncGame = game.Name
        end
    end)
    local initialGame = config.GameName or syncGame or "Detecting Experience..."
    local FooterLabel = Instance.new("TextLabel")
    FooterLabel.Name = "FooterLabel"
    FooterLabel.Size = UDim2.new(1, -60, 1, 0)
    FooterLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    FooterLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    FooterLabel.BackgroundTransparency = 1
    FooterLabel.Text = "Copyright © VRS Artelier | " .. initialGame
    FooterLabel.Font = Enum.Font.GothamMedium
    FooterLabel.TextSize = 10.5
    FooterLabel.TextColor3 = Color3.fromRGB(225, 230, 245)
    FooterLabel.TextXAlignment = Enum.TextXAlignment.Center
    FooterLabel.TextTruncate = Enum.TextTruncate.AtEnd
    FooterLabel.ZIndex = 30
    FooterLabel.Parent = FooterBar
    ProtectLocalization(FooterLabel)

    FooterLabel.MouseEnter:Connect(function()
        TweenService:Create(FooterLabel, TweenInfo.new(0.15), { TextColor3 = VRSLib.Theme.Accent }):Play()
    end)
    FooterLabel.MouseLeave:Connect(function()
        TweenService:Create(FooterLabel, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(225, 230, 245) }):Play()
    end)

    -- Auto-Detect Live Game Title from game.PlaceId via MarketplaceService
    task.spawn(function()
        local gameTitle = config.GameName
        if not gameTitle or gameTitle == "" then
            pcall(function()
                local MarketplaceService = cloneref(game:GetService("MarketplaceService"))
                local info = MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)
                if info and info.Name and info.Name ~= "" then
                    gameTitle = info.Name
                end
            end)
            if not gameTitle or gameTitle == "" then
                pcall(function()
                    local MarketplaceService = cloneref(game:GetService("MarketplaceService"))
                    local info = MarketplaceService:GetProductInfo(game.PlaceId)
                    if info and info.Name and info.Name ~= "" then
                        gameTitle = info.Name
                    end
                end)
            end
            if not gameTitle or gameTitle == "" then
                pcall(function()
                    if game.Name and game.Name ~= "" and game.Name ~= "Game" then
                        gameTitle = game.Name
                    end
                end)
            end
        end
        local finalGame = gameTitle or "Roblox Experience"
        self.DetectedGame = finalGame
        FooterLabel.Text = "Copyright © VRS Artelier | " .. finalGame
    end)

    -- Window Resize Draggers (Attached to FooterBar right corner)
    local ResizeGrip = Instance.new("ImageButton")
    ResizeGrip.Name = "ResizeGrip"
    ResizeGrip.Size = UDim2.fromOffset(14, 14)
    ResizeGrip.Position = UDim2.new(1, -18, 0.5, -7)
    ResizeGrip.BackgroundTransparency = 1
    ResizeGrip.Image = VRSLib.Icons.Get("resize")
    ResizeGrip.ImageColor3 = Color3.fromRGB(120, 125, 145)
    ResizeGrip.Rotation = 225
    ResizeGrip.ZIndex = 30
    ResizeGrip.Parent = FooterBar

    local RightBorder = Instance.new("TextButton")
    RightBorder.Name = "ResizeRight"
    RightBorder.Size = UDim2.new(0, 10, 1, -30)
    RightBorder.Position = UDim2.new(1, -5, 0, 0)
    RightBorder.BackgroundTransparency = 1
    RightBorder.Text = ""
    RightBorder.ZIndex = 25
    RightBorder.Parent = Main

    local BottomBorder = Instance.new("TextButton")
    BottomBorder.Name = "ResizeBottom"
    BottomBorder.Size = UDim2.new(1, -30, 0, 10)
    BottomBorder.Position = UDim2.new(0, 0, 1, -5)
    BottomBorder.BackgroundTransparency = 1
    BottomBorder.Text = ""
    BottomBorder.ZIndex = 25
    BottomBorder.Parent = Main

    local resizing = false
    local resizeMode = "Both" -- "Both", "Width", "Height"
    local resizeStart, startSize

    local function StartResize(mode, input)
        resizing = true
        resizeMode = mode
        resizeStart = input.Position
        startSize = Main.AbsoluteSize

        local connEnd, connMove
        connEnd = UserInputService.InputEnded:Connect(function(endInput)
            if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                resizing = false
                if connEnd then connEnd:Disconnect() end
                if connMove then connMove:Disconnect() end
            end
        end)

        connMove = UserInputService.InputChanged:Connect(function(moveInput)
            if resizing and (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) then
                local delta = moveInput.Position - resizeStart
                local newW = startSize.X
                local newH = startSize.Y

                if resizeMode == "Both" or resizeMode == "Width" then
                    newW = math.clamp(startSize.X + delta.X, 720, 1500)
                end
                if resizeMode == "Both" or resizeMode == "Height" then
                    newH = math.clamp(startSize.Y + delta.Y, 440, 950)
                end

                Main.Size = UDim2.fromOffset(newW, newH)
                self:ReflowGrid()
            end
        end)
    end

    ResizeGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            StartResize("Both", input)
        end
    end)

    RightBorder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            StartResize("Width", input)
        end
    end)

    BottomBorder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            StartResize("Height", input)
        end
    end)

    -- Floating Mobile / PC Draggable Wings Widget (Pure Clean Transparent Logo, Zero Box)
    local FloatingToggle = Instance.new("ImageButton")
    FloatingToggle.Name = "VRS_FloatingWings"
    FloatingToggle.Size = UDim2.fromOffset(54, 40)
    FloatingToggle.Position = UDim2.new(0, 25, 0.45, 0)
    FloatingToggle.BackgroundTransparency = 1
    FloatingToggle.BorderSizePixel = 0
    FloatingToggle.AutoButtonColor = false
    FloatingToggle.ScaleType = Enum.ScaleType.Stretch
    ApplyBrandLogo(FloatingToggle)
    FloatingToggle.Parent = ScreenGui

    FloatingToggle.MouseEnter:Connect(function()
        TweenService:Create(FloatingToggle, TweenInfo.new(0.2), { Size = UDim2.fromOffset(60, 44) }):Play()
    end)
    FloatingToggle.MouseLeave:Connect(function()
        TweenService:Create(FloatingToggle, TweenInfo.new(0.2), { Size = UDim2.fromOffset(54, 40) }):Play()
    end)

    MakeDraggable(FloatingToggle, FloatingToggle)
    FloatingToggle.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    self.FloatingToggle = FloatingToggle

    -- Keybind Listener
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == self.Keybind then
            self:Toggle()
        end
    end)

    -- Auto reflow on size change
    Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:ReflowGrid()
    end)

    self.Toggles = {}
    self.Options = {}
    self.Toggled = true
    VRSLib.Toggles = self.Toggles
    VRSLib.Options = self.Options
    VRSLib.Toggle = function() self:Toggle() end
    _G.Toggles = self.Toggles
    _G.Options = self.Options
    if getgenv then
        getgenv().Toggles = self.Toggles
        getgenv().Options = self.Options
    end

    self:InitQuickCategory()
    table.insert(VRSLib.Windows, self)
    task.defer(function() self:ReflowGrid() end)
    return self
end

-- ==============================================================================
-- DYNAMIC CARD GRID REFLOW (3 TO 6 COLUMNS LIKE 404HUB)
-- ==============================================================================
-- ==============================================================================
-- SIDEBAR MINIMIZE / EXPAND SYSTEM
-- ==============================================================================
function Window:ToggleSidebar(collapsed)
    if collapsed == nil then
        collapsed = not self.SidebarCollapsed
    end
    self.SidebarCollapsed = collapsed

    local targetSidebarW = collapsed and 0 or 220
    local targetContentX = collapsed and 0 or 221
    local targetContentW = collapsed and 0 or -221

    TweenService:Create(self.Sidebar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, targetSidebarW, 1, 0)
    }):Play()

    TweenService:Create(self.ContentArea, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, targetContentX, 0, 0),
        Size = UDim2.new(1, targetContentW, 1, 0)
    }):Play()

    if self.SearchFrame then
        local targetSearchX = collapsed and 16 or 236
        TweenService:Create(self.SearchFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, targetSearchX, 0.5, 0)
        }):Play()
    end

    if self.SidebarToggleBtn then
        TweenService:Create(self.SidebarToggleBtn, TweenInfo.new(0.2), {
            ImageColor3 = collapsed and VRSLib.Theme.Accent or VRSLib.Theme.TextMuted,
            Rotation = collapsed and 180 or 0
        }):Play()
    end

    task.delay(0.26, function()
        self:ReflowGrid()
    end)
end

-- ==============================================================================
-- DUAL-COLUMN SPLIT & GROUPBOX SYSTEM (OBSIDIAN-GRADE ARCHITECTURE)
-- ==============================================================================
function Window:CreateGroupbox(parentFrame, configOrTitle, optionalIcon, optionalTab)
    local config
    if type(configOrTitle) == "string" then
        config = { Title = configOrTitle, Icon = optionalIcon }
    else
        config = configOrTitle or {}
    end
    local title = config.Title or config.Name or config.Text or "Groupbox"
    local iconId = VRSLib.Icons.Get(config.Icon or "folder")
    local collapsed = config.Collapsed or false
    local tabRef = optionalTab or config.Tab

    local GroupCard = Instance.new("Frame")
    GroupCard.Name = "Groupbox_" .. title
    GroupCard.Size = UDim2.new(1, 0, 0, 0)
    GroupCard.AutomaticSize = Enum.AutomaticSize.Y
    GroupCard.BackgroundColor3 = VRSLib.Theme.Card
    GroupCard.BorderSizePixel = 0
    GroupCard.ClipsDescendants = true
    GroupCard.Parent = parentFrame

    local GCorner = Instance.new("UICorner")
    GCorner.CornerRadius = UDim.new(0, 7)
    GCorner.Parent = GroupCard

    local GStroke = Instance.new("UIStroke")
    GStroke.Color = VRSLib.Theme.CardStroke
    GStroke.Thickness = 1
    GStroke.Parent = GroupCard

    -- Title Bar
    local TitleBar = Instance.new("TextButton")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 34)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Text = ""
    TitleBar.AutoButtonColor = false
    TitleBar.Parent = GroupCard

    local GIcon = Instance.new("ImageLabel")
    GIcon.Size = UDim2.fromOffset(14, 14)
    GIcon.Position = UDim2.new(0, 10, 0.5, -7)
    GIcon.BackgroundTransparency = 1
    GIcon.Image = iconId
    GIcon.ImageColor3 = VRSLib.Theme.Accent
    GIcon.Parent = TitleBar

    local GTitle = Instance.new("TextLabel")
    GTitle.Size = UDim2.new(1, -56, 1, 0)
    GTitle.Position = UDim2.new(0, 30, 0, 0)
    GTitle.BackgroundTransparency = 1
    GTitle.Text = title
    GTitle.Font = Enum.Font.GothamBold
    GTitle.TextSize = 11.5
    GTitle.TextColor3 = VRSLib.Theme.TextPrimary
    GTitle.TextXAlignment = Enum.TextXAlignment.Left
    GTitle.Parent = TitleBar
    ProtectLocalization(GTitle)

    local GChevron = Instance.new("ImageLabel")
    GChevron.Size = UDim2.fromOffset(12, 12)
    GChevron.Position = UDim2.new(1, -22, 0.5, -6)
    GChevron.BackgroundTransparency = 1
    GChevron.Image = VRSLib.Icons.Get("chevron-down")
    GChevron.ImageColor3 = VRSLib.Theme.TextMuted
    GChevron.Rotation = collapsed and -90 or 0
    GChevron.Parent = TitleBar

    -- Content Frame
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.Position = UDim2.new(0, 0, 0, 34)
    Content.BackgroundTransparency = 1
    Content.Visible = not collapsed
    Content.Parent = GroupCard

    local CList = Instance.new("UIListLayout")
    CList.SortOrder = Enum.SortOrder.LayoutOrder
    CList.Padding = UDim.new(0, 8)
    CList.Parent = Content

    local CPadding = Instance.new("UIPadding")
    CPadding.PaddingLeft = UDim.new(0, 10)
    CPadding.PaddingRight = UDim.new(0, 10)
    CPadding.PaddingTop = UDim.new(0, 4)
    CPadding.PaddingBottom = UDim.new(0, 12)
    CPadding.Parent = Content

    local BoxObj = {
        Frame = GroupCard,
        Content = Content,
        Container = Content,
        Chevron = GChevron,
        Window = self,
        IsCollapsed = collapsed,
        Title = title,
        Icon = iconId,
        Tab = tabRef,
    }

    TitleBar.MouseButton1Click:Connect(function()
        BoxObj.IsCollapsed = not BoxObj.IsCollapsed
        Content.Visible = not BoxObj.IsCollapsed
        TweenService:Create(GChevron, TweenInfo.new(0.2), {
            Rotation = BoxObj.IsCollapsed and -90 or 0,
            ImageColor3 = BoxObj.IsCollapsed and VRSLib.Theme.TextMuted or VRSLib.Theme.Accent
        }):Play()
    end)

    -- Divider separator
    function BoxObj:AddDivider()
        local Div = Instance.new("Frame")
        Div.Name = "Divider"
        Div.Size = UDim2.new(1, 0, 0, 1)
        Div.BackgroundColor3 = VRSLib.Theme.CardStroke
        Div.BorderSizePixel = 0
        Div.Parent = Content
        return Div
    end

    -- 1. AddToggle (Pill Toggle Switch - Universal Dual Format)
    function BoxObj:AddToggle(idOrConfig, optionalConfig)
        local id, ctrlConfig
        if type(idOrConfig) == "string" then
            id = idOrConfig
            ctrlConfig = optionalConfig or {}
        else
            ctrlConfig = idOrConfig or {}
            id = ctrlConfig.Id or ctrlConfig.Title or ctrlConfig.Text or "Toggle"
        end

        local cTitle = ctrlConfig.Title or ctrlConfig.Text or tostring(id)
        local defVal = ctrlConfig.Default or false
        local cb = ctrlConfig.Callback or ctrlConfig.Func or function() end

        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 26)
        Row.BackgroundTransparency = 1
        Row.Parent = Content

        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(1, -38, 1, 0)
        Lbl.BackgroundTransparency = 1
        Lbl.Text = cTitle
        Lbl.Font = Enum.Font.GothamMedium
        Lbl.TextSize = 11.5
        Lbl.TextColor3 = VRSLib.Theme.TextPrimary
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Parent = Row
        ProtectLocalization(Lbl)

        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.fromOffset(30, 16)
        Switch.Position = UDim2.new(1, -30, 0.5, -8)
        Switch.BackgroundColor3 = (defVal and VRSLib.Theme.Accent or VRSLib.Theme.SwitchOff)
        Switch.BorderSizePixel = 0
        Switch.Text = ""
        Switch.Parent = Row

        local SCorner = Instance.new("UICorner")
        SCorner.CornerRadius = UDim.new(1, 0)
        SCorner.Parent = Switch

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.fromOffset(12, 12)
        Knob.Position = (defVal and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6))
        Knob.BackgroundColor3 = (defVal and VRSLib.Theme.SwitchOnKnob or VRSLib.Theme.SwitchOffKnob)
        Knob.BorderSizePixel = 0
        Knob.Parent = Switch

        local KCorner = Instance.new("UICorner")
        KCorner.CornerRadius = UDim.new(1, 0)
        KCorner.Parent = Knob

        local isVal = defVal
        local toggleObj
        local cardObj = nil
        local toggleCallbacks = {}
        if ctrlConfig.Callback then table.insert(toggleCallbacks, ctrlConfig.Callback) end
        if ctrlConfig.Func then table.insert(toggleCallbacks, ctrlConfig.Func) end

        pcall(function()
            local targetTab = self.Tab or (self.Window and self.Window.ActiveTab) or (self.Window and self.Window.Tabs and self.Window.Tabs[1])
            if targetTab and self.Window and self.Window.AddModule then
                cardObj = self.Window:AddModule(targetTab, {
                    Title = cTitle,
                    Description = ctrlConfig.Tooltip or (title .. " • " .. (targetTab.Name or "Automation")),
                    Icon = ctrlConfig.Icon or self.Icon or "sliders",
                    Type = "Toggle",
                    Default = defVal,
                    Callback = function(v)
                        if toggleObj and toggleObj.Value ~= v then
                            toggleObj.Set(v)
                        end
                    end
                })
            end
        end)

        local function SetVal(v)
            isVal = v
            if toggleObj then toggleObj.Value = v end
            TweenService:Create(Switch, TweenInfo.new(0.2), {
                BackgroundColor3 = isVal and VRSLib.Theme.Accent or VRSLib.Theme.SwitchOff
            }):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2), {
                Position = isVal and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
                BackgroundColor3 = isVal and VRSLib.Theme.SwitchOnKnob or VRSLib.Theme.SwitchOffKnob
            }):Play()
            if cardObj and cardObj.Set and cardObj.Value ~= v then
                cardObj.Set(v)
            end
            for _, fn in ipairs(toggleCallbacks) do
                task.spawn(fn, isVal)
            end
        end

        Switch.MouseButton1Click:Connect(function() SetVal(not isVal) end)

        toggleObj = {
            Value = isVal,
            Set = SetVal,
            SetValue = function(selfOrVal, maybeVal)
                local v = maybeVal
                if v == nil then v = selfOrVal end
                SetVal(v)
            end,
            OnChanged = function(selfOrFn, maybeFn)
                local fn = maybeFn or selfOrFn
                if type(fn) == "function" then
                    table.insert(toggleCallbacks, fn)
                end
                return toggleObj
            end,
            Card = cardObj,
            Frame = Row
        }

        if self.Window.Toggles then self.Window.Toggles[id] = toggleObj end
        if _G.Toggles then _G.Toggles[id] = toggleObj end
        if getgenv then getgenv().Toggles[id] = toggleObj end
        return toggleObj
    end

    -- 2. AddButton (Action button with clean icon - Dual Format)
    function BoxObj:AddButton(textOrConfig, optionalFunc)
        local ctrlConfig
        if type(textOrConfig) == "string" then
            ctrlConfig = { Title = textOrConfig, Callback = optionalFunc }
        else
            ctrlConfig = textOrConfig or {}
        end
        local cTitle = ctrlConfig.Title or ctrlConfig.Text or "Button"
        local cIcon = ctrlConfig.Icon and VRSLib.Icons.Get(ctrlConfig.Icon)
        local cb = ctrlConfig.Callback or ctrlConfig.Func or function() end

        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 28)
        Btn.BackgroundColor3 = VRSLib.Theme.InputBackground
        Btn.BorderSizePixel = 0
        Btn.Text = ""
        Btn.AutoButtonColor = false
        Btn.Parent = Content

        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 5)
        BCorner.Parent = Btn

        local BStroke = Instance.new("UIStroke")
        BStroke.Color = VRSLib.Theme.CardStroke
        BStroke.Thickness = 1
        BStroke.Parent = Btn

        local ContentBox = Instance.new("Frame")
        ContentBox.Size = UDim2.new(1, 0, 1, 0)
        ContentBox.BackgroundTransparency = 1
        ContentBox.Parent = Btn

        local CLayout = Instance.new("UIListLayout")
        CLayout.FillDirection = Enum.FillDirection.Horizontal
        CLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        CLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        CLayout.Padding = UDim.new(0, 6)
        CLayout.Parent = ContentBox

        if cIcon then
            local BImg = Instance.new("ImageLabel")
            BImg.Size = UDim2.fromOffset(13, 13)
            BImg.BackgroundTransparency = 1
            BImg.Image = cIcon
            BImg.ImageColor3 = VRSLib.Theme.Accent
            BImg.Parent = ContentBox
        end

        local BLbl = Instance.new("TextLabel")
        BLbl.Size = UDim2.new(0, 0, 1, 0)
        BLbl.AutomaticSize = Enum.AutomaticSize.X
        BLbl.BackgroundTransparency = 1
        BLbl.Text = cTitle
        BLbl.Font = Enum.Font.GothamBold
        BLbl.TextSize = 11
        BLbl.TextColor3 = VRSLib.Theme.TextPrimary
        BLbl.Parent = ContentBox
        ProtectLocalization(BLbl)

        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.15), { BackgroundColor3 = VRSLib.Theme.CardHover }):Play()
            TweenService:Create(BStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.Accent }):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.15), { BackgroundColor3 = VRSLib.Theme.InputBackground }):Play()
            TweenService:Create(BStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.CardStroke }):Play()
        end)
        pcall(function()
            local targetTab = self.Tab or (self.Window and self.Window.ActiveTab) or (self.Window and self.Window.Tabs and self.Window.Tabs[1])
            if targetTab and self.Window and self.Window.AddModule then
                self.Window:AddModule(targetTab, {
                    Title = cTitle,
                    Description = ctrlConfig.Tooltip or (title .. " • " .. (targetTab.Name or "Action")),
                    Icon = ctrlConfig.Icon or self.Icon or "play",
                    Type = "Action",
                    Callback = function()
                        task.spawn(cb)
                    end
                })
            end
        end)

        Btn.MouseButton1Click:Connect(function()
            task.spawn(cb)
        end)
        return Btn
    end

    -- 3. AddSlider (Slider with Title on left and Value Badge - Dual Format)
    function BoxObj:AddSlider(idOrConfig, optionalConfig)
        local id, ctrlConfig
        if type(idOrConfig) == "string" then
            id = idOrConfig
            ctrlConfig = optionalConfig or {}
        else
            ctrlConfig = idOrConfig or {}
            id = ctrlConfig.Id or ctrlConfig.Title or ctrlConfig.Text or "Slider"
        end

        local cTitle = ctrlConfig.Title or ctrlConfig.Text or tostring(id)
        local min = ctrlConfig.Min or 0
        local max = ctrlConfig.Max or 100
        local def = ctrlConfig.Default or min
        local unit = ctrlConfig.Unit or ctrlConfig.Suffix or ""
        local cb = ctrlConfig.Callback or ctrlConfig.Func or function() end

        local SFrame = Instance.new("Frame")
        SFrame.Size = UDim2.new(1, 0, 0, 42)
        SFrame.BackgroundTransparency = 1
        SFrame.Parent = Content

        local TopRow = Instance.new("Frame")
        TopRow.Size = UDim2.new(1, 0, 0, 18)
        TopRow.BackgroundTransparency = 1
        TopRow.Parent = SFrame

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Size = UDim2.new(1, -70, 1, 0)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = cTitle
        TitleLbl.Font = Enum.Font.GothamMedium
        TitleLbl.TextSize = 11.5
        TitleLbl.TextColor3 = VRSLib.Theme.TextPrimary
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.Parent = TopRow
        ProtectLocalization(TitleLbl)

        local ValBadge = Instance.new("TextLabel")
        ValBadge.Size = UDim2.new(0, 65, 1, 0)
        ValBadge.Position = UDim2.new(1, -65, 0, 0)
        ValBadge.BackgroundTransparency = 1
        ValBadge.Text = tostring(def) .. (unit ~= "" and (" " .. unit) or "")
        ValBadge.Font = Enum.Font.GothamBold
        ValBadge.TextSize = 10.5
        ValBadge.TextColor3 = VRSLib.Theme.Accent
        ValBadge.TextXAlignment = Enum.TextXAlignment.Right
        ValBadge.Parent = TopRow
        ProtectLocalization(ValBadge)

        local BarFrame = Instance.new("TextButton")
        BarFrame.Size = UDim2.new(1, 0, 0, 14)
        BarFrame.Position = UDim2.new(0, 0, 0, 22)
        BarFrame.BackgroundTransparency = 1
        BarFrame.Text = ""
        BarFrame.AutoButtonColor = false
        BarFrame.Parent = SFrame

        local Track = Instance.new("Frame")
        Track.Size = UDim2.new(1, 0, 0, 6)
        Track.Position = UDim2.new(0, 0, 0.5, -3)
        Track.BackgroundColor3 = VRSLib.Theme.InputBackground
        Track.BorderSizePixel = 0
        Track.Parent = BarFrame

        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(1, 0)
        TCorner.Parent = Track

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new(math.clamp((def - min) / (max - min), 0, 1), 0, 1, 0)
        Fill.BackgroundColor3 = VRSLib.Theme.Accent
        Fill.BorderSizePixel = 0
        Fill.Parent = Track

        local FCorner = Instance.new("UICorner")
        FCorner.CornerRadius = UDim.new(1, 0)
        FCorner.Parent = Fill

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.fromOffset(12, 12)
        Knob.Position = UDim2.new(1, -6, 0.5, -6)
        Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Knob.BorderSizePixel = 0
        Knob.Parent = Fill

        local KCorner = Instance.new("UICorner")
        KCorner.CornerRadius = UDim.new(1, 0)
        KCorner.Parent = Knob

        local dragging = false
        local curVal = def
        local sliderObj

        local function UpdateSlider(input)
            local frac = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            curVal = math.floor(min + (max - min) * frac + 0.5)
            if sliderObj then sliderObj.Value = curVal end
            Fill.Size = UDim2.new(frac, 0, 1, 0)
            ValBadge.Text = tostring(curVal) .. (unit ~= "" and (" " .. unit) or "")
            for _, fn in ipairs(sliderCallbacks) do
                task.spawn(fn, curVal)
            end
        end

        BarFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                UpdateSlider(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateSlider(input)
            end
        end)

        local sliderCallbacks = {}
        if ctrlConfig.Callback then table.insert(sliderCallbacks, ctrlConfig.Callback) end
        if ctrlConfig.Func then table.insert(sliderCallbacks, ctrlConfig.Func) end

        sliderObj = {
            Value = curVal,
            Set = function(val)
                local frac = math.clamp((val - min) / (max - min), 0, 1)
                curVal = val
                sliderObj.Value = val
                Fill.Size = UDim2.new(frac, 0, 1, 0)
                ValBadge.Text = tostring(curVal) .. (unit ~= "" and (" " .. unit) or "")
                task.spawn(cb, curVal)
                for _, fn in ipairs(sliderCallbacks) do
                    task.spawn(fn, curVal)
                end
            end,
            SetValue = function(selfOrVal, maybeVal)
                local v = (maybeVal ~= nil and maybeVal) or selfOrVal
                sliderObj.Set(v)
            end,
            OnChanged = function(selfOrFn, maybeFn)
                local fn = maybeFn or selfOrFn
                if type(fn) == "function" then
                    table.insert(sliderCallbacks, fn)
                end
                return sliderObj
            end,
            Frame = SFrame
        }

        if self.Window.Options then self.Window.Options[id] = sliderObj end
        if _G.Options then _G.Options[id] = sliderObj end
        if getgenv then getgenv().Options[id] = sliderObj end
        return sliderObj
    end

    -- 4. AddDropdown (Clean popup selector - Dual Format)
    function BoxObj:AddDropdown(idOrConfig, optionalConfig)
        local id, ctrlConfig
        if type(idOrConfig) == "string" then
            id = idOrConfig
            ctrlConfig = optionalConfig or {}
        else
            ctrlConfig = idOrConfig or {}
            id = ctrlConfig.Id or ctrlConfig.Title or ctrlConfig.Text or "Dropdown"
        end

        local cTitle = ctrlConfig.Title or ctrlConfig.Text or tostring(id)
        local values = ctrlConfig.Values or ctrlConfig.Items or {}
        local isMulti = (ctrlConfig.Multi == true or ctrlConfig.Multiselect == true)
        local curSel
        if isMulti then
            curSel = {}
            if type(ctrlConfig.Default) == "table" then
                for k, v in pairs(ctrlConfig.Default) do
                    if type(k) == "number" and type(v) == "string" then
                        curSel[v] = true
                    elseif type(k) == "string" and v == true then
                        curSel[k] = true
                    end
                end
            elseif type(ctrlConfig.Default) == "string" then
                curSel[ctrlConfig.Default] = true
            end
        else
            if type(ctrlConfig.Default) == "number" and values[ctrlConfig.Default] ~= nil then
                curSel = values[ctrlConfig.Default]
            elseif ctrlConfig.Default ~= nil then
                curSel = ctrlConfig.Default
            else
                curSel = values[1] or "Select..."
            end
        end
        local cb = ctrlConfig.Callback or ctrlConfig.Func or function() end

        local DFrame = Instance.new("Frame")
        DFrame.Size = UDim2.new(1, 0, 0, 48)
        DFrame.BackgroundTransparency = 1
        DFrame.ZIndex = 10
        DFrame.Parent = Content

        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(1, 0, 0, 16)
        Lbl.BackgroundTransparency = 1
        Lbl.Text = cTitle
        Lbl.Font = Enum.Font.GothamMedium
        Lbl.TextSize = 11.5
        Lbl.TextColor3 = VRSLib.Theme.TextPrimary
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Parent = DFrame
        ProtectLocalization(Lbl)

        local MainBtn = Instance.new("TextButton")
        MainBtn.Size = UDim2.new(1, 0, 0, 26)
        MainBtn.Position = UDim2.new(0, 0, 0, 18)
        MainBtn.BackgroundColor3 = VRSLib.Theme.InputBackground
        MainBtn.BorderSizePixel = 0
        MainBtn.Text = ""
        MainBtn.AutoButtonColor = false
        MainBtn.Parent = DFrame

        local DCorner = Instance.new("UICorner")
        DCorner.CornerRadius = UDim.new(0, 5)
        DCorner.Parent = MainBtn

        local DStroke = Instance.new("UIStroke")
        DStroke.Color = VRSLib.Theme.CardStroke
        DStroke.Thickness = 1
        DStroke.Parent = MainBtn

        local function getSummary()
            if not isMulti then return tostring(curSel) end
            local active = {}
            for _, v in ipairs(values) do
                if curSel[v] then
                    table.insert(active, tostring(v))
                end
            end
            if #active == 0 then return "None" end
            if #active == #values and #values > 1 then return "All Selected (" .. #values .. ")" end
            return table.concat(active, ", ")
        end

        local SelText = Instance.new("TextLabel")
        SelText.Size = UDim2.new(1, -26, 1, 0)
        SelText.Position = UDim2.new(0, 8, 0, 0)
        SelText.BackgroundTransparency = 1
        SelText.Text = getSummary()
        SelText.Font = Enum.Font.GothamMedium
        SelText.TextSize = 10.5
        SelText.TextColor3 = VRSLib.Theme.TextPrimary
        SelText.TextXAlignment = Enum.TextXAlignment.Left
        SelText.TextTruncate = Enum.TextTruncate.AtEnd
        SelText.Parent = MainBtn
        ProtectLocalization(SelText)

        local Chevron = Instance.new("ImageLabel")
        Chevron.Size = UDim2.fromOffset(12, 12)
        Chevron.Position = UDim2.new(1, -20, 0.5, -6)
        Chevron.BackgroundTransparency = 1
        Chevron.Image = VRSLib.Icons.Get("chevron-down")
        Chevron.ImageColor3 = VRSLib.Theme.TextMuted
        Chevron.Parent = MainBtn

        local listHeight = math.min(#values * 26 + 6, 160)
        local DropList = Instance.new("ScrollingFrame")
        DropList.Size = UDim2.new(1, 0, 0, listHeight)
        DropList.Position = UDim2.new(0, 0, 0, 46)
        DropList.BackgroundColor3 = VRSLib.Theme.Card
        DropList.BorderSizePixel = 0
        DropList.Visible = false
        DropList.ZIndex = 25
        DropList.ClipsDescendants = true
        DropList.ScrollBarThickness = 3
        DropList.ScrollBarImageColor3 = VRSLib.Theme.Accent
        DropList.CanvasSize = UDim2.new(0, 0, 0, 0)
        DropList.AutomaticCanvasSize = Enum.AutomaticSize.Y
        DropList.Parent = DFrame

        local DLCorner = Instance.new("UICorner")
        DLCorner.CornerRadius = UDim.new(0, 5)
        DLCorner.Parent = DropList

        local DLStroke = Instance.new("UIStroke")
        DLStroke.Color = VRSLib.Theme.CardStroke
        DLStroke.Thickness = 1
        DLStroke.Parent = DropList

        local DLLayout = Instance.new("UIListLayout")
        DLLayout.SortOrder = Enum.SortOrder.LayoutOrder
        DLLayout.Padding = UDim.new(0, 2)
        DLLayout.Parent = DropList

        local isOpen = false
        local function ToggleDrop(open)
            isOpen = (open ~= nil and open) or not isOpen
            DropList.Visible = isOpen
            local targetH = math.min(#values * 26 + 6, 160)
            DropList.Size = UDim2.new(1, 0, 0, targetH)
            DFrame.Size = UDim2.new(1, 0, 0, isOpen and (48 + targetH + 6) or 48)
            pcall(function()
                TweenService:Create(Chevron, TweenInfo.new(0.15), { Rotation = isOpen and 180 or 0 }):Play()
            end)
        end
        MainBtn.MouseButton1Click:Connect(function() ToggleDrop() end)

        local optBtns = {}
        local dropObj
        local dropCallbacks = {}
        if ctrlConfig.Callback then table.insert(dropCallbacks, ctrlConfig.Callback) end
        if ctrlConfig.Func then table.insert(dropCallbacks, ctrlConfig.Func) end

        local function refreshBtnColors()
            for _, btn in ipairs(optBtns) do
                local val = btn:GetAttribute("Val")
                local isSelected = isMulti and (curSel[val] == true) or (tostring(val) == tostring(curSel))
                btn.TextColor3 = isSelected and VRSLib.Theme.Accent or VRSLib.Theme.TextMuted
                btn.Text = (isMulti and (isSelected and "[x] " or "[ ] ") or "") .. tostring(val)
            end
        end

        local function handleItemToggle(val)
            if isMulti then
                if val == "All In Stock" or val == "All Items" then
                    local newAllState = not curSel[val]
                    for _, v in ipairs(values) do
                        curSel[v] = newAllState
                    end
                else
                    curSel[val] = not curSel[val]
                    local allActive = true
                    for _, v in ipairs(values) do
                        if v ~= "All In Stock" and v ~= "All Items" and not curSel[v] then
                            allActive = false
                            break
                        end
                    end
                    if curSel["All In Stock"] ~= nil then curSel["All In Stock"] = allActive end
                    if curSel["All Items"] ~= nil then curSel["All Items"] = allActive end
                end
                if dropObj then dropObj.Value = curSel end
                SelText.Text = getSummary()
                refreshBtnColors()
                for _, fn in ipairs(dropCallbacks) do
                    task.spawn(fn, curSel)
                end
            else
                curSel = val
                if dropObj then dropObj.Value = val end
                SelText.Text = tostring(val)
                refreshBtnColors()
                ToggleDrop(false)
                for _, fn in ipairs(dropCallbacks) do
                    task.spawn(fn, val)
                end
            end
        end

        for i, val in ipairs(values) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Size = UDim2.new(1, 0, 0, 24)
            OptBtn.BackgroundTransparency = 1
            OptBtn.Text = (isMulti and (curSel[val] and "[x] " or "[ ] ") or "") .. tostring(val)
            OptBtn.Font = Enum.Font.GothamMedium
            OptBtn.TextSize = 10.5
            local isSelected = isMulti and (curSel[val] == true) or (tostring(val) == tostring(curSel))
            OptBtn.TextColor3 = (isSelected and VRSLib.Theme.Accent or VRSLib.Theme.TextPrimary)
            if isMulti then OptBtn.TextXAlignment = Enum.TextXAlignment.Left end
            OptBtn.ZIndex = 26
            OptBtn:SetAttribute("Val", val)
            OptBtn.Parent = DropList
            ProtectLocalization(OptBtn)
            table.insert(optBtns, OptBtn)

            OptBtn.MouseEnter:Connect(function()
                OptBtn.BackgroundTransparency = 0.8
                OptBtn.BackgroundColor3 = VRSLib.Theme.Accent
            end)
            OptBtn.MouseLeave:Connect(function()
                OptBtn.BackgroundTransparency = 1
            end)
            OptBtn.MouseButton1Click:Connect(function()
                handleItemToggle(val)
            end)
        end

        dropObj = {
            Value = curSel,
            Set = function(val)
                if isMulti then
                    if type(val) == "table" then
                        curSel = {}
                        for k, v in pairs(val) do
                            if type(k) == "number" and type(v) == "string" then
                                curSel[v] = true
                            elseif type(k) == "string" and v == true then
                                curSel[k] = true
                            end
                        end
                    elseif type(val) == "string" then
                        curSel[val] = true
                    end
                    dropObj.Value = curSel
                    SelText.Text = getSummary()
                    refreshBtnColors()
                    for _, fn in ipairs(dropCallbacks) do
                        task.spawn(fn, curSel)
                    end
                else
                    if type(val) == "number" and values[val] ~= nil then
                        val = values[val]
                    end
                    curSel = val
                    dropObj.Value = val
                    SelText.Text = tostring(val)
                    refreshBtnColors()
                    for _, fn in ipairs(dropCallbacks) do
                        task.spawn(fn, val)
                    end
                end
            end,
            SetValue = function(selfOrVal, maybeVal)
                local v = maybeVal
                if v == nil then v = selfOrVal end
                dropObj.Set(v)
            end,
            SetValues = function(selfOrVals, maybeVals, shouldSelectAll)
                local newVals = maybeVals or selfOrVals
                if type(newVals) == "table" then
                    values = newVals
                    for _, b in ipairs(optBtns) do pcall(function() b:Destroy() end) end
                    optBtns = {}
                    local targetH = math.min(#values * 26 + 6, 160)
                    DropList.Size = UDim2.new(1, 0, 0, targetH)
                    if isOpen then
                        DFrame.Size = UDim2.new(1, 0, 0, 48 + targetH + 6)
                    end
                    if isMulti and shouldSelectAll ~= false then
                        curSel = {}
                        for _, v in ipairs(values) do
                            curSel[v] = true
                        end
                    elseif not isMulti then
                        curSel = values[1] or "Select..."
                    end
                    dropObj.Value = curSel
                    for _, val in ipairs(values) do
                        local OptBtn = Instance.new("TextButton")
                        OptBtn.Size = UDim2.new(1, 0, 0, 24)
                        OptBtn.BackgroundTransparency = 1
                        OptBtn.Text = (isMulti and (curSel[val] and "[x] " or "[ ] ") or "") .. tostring(val)
                        OptBtn.Font = Enum.Font.GothamMedium
                        OptBtn.TextSize = 10.5
                        local isSelected = isMulti and (curSel[val] == true) or (tostring(val) == tostring(curSel))
                        OptBtn.TextColor3 = (isSelected and VRSLib.Theme.Accent or VRSLib.Theme.TextPrimary)
                        if isMulti then OptBtn.TextXAlignment = Enum.TextXAlignment.Left end
                        OptBtn.ZIndex = 26
                        OptBtn:SetAttribute("Val", val)
                        OptBtn.Parent = DropList
                        ProtectLocalization(OptBtn)
                        table.insert(optBtns, OptBtn)

                        OptBtn.MouseEnter:Connect(function()
                            OptBtn.BackgroundTransparency = 0.8
                            OptBtn.BackgroundColor3 = VRSLib.Theme.Accent
                        end)
                        OptBtn.MouseLeave:Connect(function()
                            OptBtn.BackgroundTransparency = 1
                        end)
                        OptBtn.MouseButton1Click:Connect(function()
                            handleItemToggle(val)
                        end)
                    end
                    SelText.Text = isMulti and getSummary() or tostring(curSel)
                    refreshBtnColors()
                end
            end,
            OnChanged = function(selfOrFn, maybeFn)
                local fn = maybeFn or selfOrFn
                if type(fn) == "function" then
                    table.insert(dropCallbacks, fn)
                end
                return dropObj
            end,
            Frame = DFrame
        }

        if self.Window.Options then self.Window.Options[id] = dropObj end
        if _G.Options then _G.Options[id] = dropObj end
        if getgenv then getgenv().Options[id] = dropObj end
        return dropObj
    end

    -- 5. AddStatus (Glowing status row)
    function BoxObj:AddStatus(ctrlConfig)
        ctrlConfig = ctrlConfig or {}
        local cLabel = ctrlConfig.Label or "Status:"
        local cStatus = ctrlConfig.Status or "INACTIVE"
        local cColor = ctrlConfig.Color or Color3.fromRGB(255, 75, 75)

        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 22)
        Row.BackgroundTransparency = 1
        Row.Parent = Content

        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(0, 0, 1, 0)
        Lbl.AutomaticSize = Enum.AutomaticSize.X
        Lbl.BackgroundTransparency = 1
        Lbl.Text = cLabel
        Lbl.Font = Enum.Font.GothamMedium
        Lbl.TextSize = 11
        Lbl.TextColor3 = VRSLib.Theme.TextMuted
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Parent = Row
        ProtectLocalization(Lbl)

        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.fromOffset(8, 8)
        Dot.Position = UDim2.new(0, 56, 0.5, -4)
        Dot.BackgroundColor3 = cColor
        Dot.BorderSizePixel = 0
        Dot.Parent = Row

        local DCorner = Instance.new("UICorner")
        DCorner.CornerRadius = UDim.new(1, 0)
        DCorner.Parent = Dot

        local StatLbl = Instance.new("TextLabel")
        StatLbl.Size = UDim2.new(1, -70, 1, 0)
        StatLbl.Position = UDim2.new(0, 70, 0, 0)
        StatLbl.BackgroundTransparency = 1
        StatLbl.Text = cStatus
        StatLbl.Font = Enum.Font.GothamBold
        StatLbl.TextSize = 10.5
        StatLbl.TextColor3 = cColor
        StatLbl.TextXAlignment = Enum.TextXAlignment.Left
        StatLbl.Parent = Row
        ProtectLocalization(StatLbl)

        return {
            Set = function(newStatus, newColor)
                StatLbl.Text = newStatus
                if newColor then
                    Dot.BackgroundColor3 = newColor
                    StatLbl.TextColor3 = newColor
                end
            end,
            Frame = Row
        }
    end

    -- 6. AddLabel (Text line - Supports Chained Interactive AddKeyPicker)
    function BoxObj:AddLabel(ctrlConfig, optionalColor)
        local cText = (type(ctrlConfig) == "string" and ctrlConfig) or (ctrlConfig and (ctrlConfig.Text or ctrlConfig.Title)) or "Label"
        local cColor = (type(ctrlConfig) == "table" and ctrlConfig.Color) or (typeof(optionalColor) == "Color3" and optionalColor) or VRSLib.Theme.TextPrimary

        local Lbl = Instance.new("TextLabel")
        local isMulti = tostring(cText):find("\n") ~= nil or optionalColor == true
        Lbl.Size = isMulti and UDim2.new(1, 0, 0, 0) or UDim2.new(1, 0, 0, 22)
        Lbl.AutomaticSize = isMulti and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
        Lbl.TextWrapped = isMulti
        Lbl.BackgroundTransparency = 1
        Lbl.Text = cText
        Lbl.Font = Enum.Font.GothamMedium
        Lbl.TextSize = 11.5
        Lbl.TextColor3 = (typeof(optionalColor) == "Color3" and optionalColor) or cColor or VRSLib.Theme.TextPrimary
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.TextTruncate = isMulti and Enum.TextTruncate.None or Enum.TextTruncate.AtEnd
        Lbl.Parent = Content
        ProtectLocalization(Lbl)

        local labelObj
        labelObj = {
            Set = function(t)
                Lbl.Text = tostring(t)
                if tostring(t):find("\n") then
                    Lbl.TextWrapped = true
                    Lbl.AutomaticSize = Enum.AutomaticSize.Y
                    Lbl.TextTruncate = Enum.TextTruncate.None
                    Lbl.Size = UDim2.new(1, 0, 0, 0)
                end
            end,
            SetText = function(selfOrText, maybeText)
                local t = (maybeText ~= nil and maybeText) or selfOrText
                Lbl.Text = tostring(t)
                if tostring(t):find("\n") then
                    Lbl.TextWrapped = true
                    Lbl.AutomaticSize = Enum.AutomaticSize.Y
                    Lbl.TextTruncate = Enum.TextTruncate.None
                    Lbl.Size = UDim2.new(1, 0, 0, 0)
                end
            end,
            AddKeyPicker = function(selfOrId, idOrCfg, optionalCfg)
                local id = (type(selfOrId) == "string" and selfOrId) or (type(idOrCfg) == "string" and idOrCfg) or "Keybind"
                local cfg = (type(idOrCfg) == "table" and idOrCfg) or optionalCfg or {}
                local keyName = cfg.Default or "RightControl"
                if type(keyName) == "table" then keyName = keyName[1] or "RightControl" end
                keyName = tostring(keyName)

                local win = BoxObj.Window or (self and self.Window) or (VRSLib.Windows and VRSLib.Windows[1])

                Lbl.Size = UDim2.new(1, 0, 0, 26)

                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Name = "KeyPicker_" .. tostring(id)
                KeyBtn.Size = UDim2.new(0, 96, 0, 22)
                KeyBtn.Position = UDim2.new(1, -96, 0.5, -11)
                KeyBtn.BackgroundColor3 = VRSLib.Theme.InputBackground
                KeyBtn.BorderSizePixel = 0
                KeyBtn.Font = Enum.Font.GothamBold
                KeyBtn.Text = "[" .. tostring(keyName) .. "]"
                KeyBtn.TextColor3 = VRSLib.Theme.TextPrimary
                KeyBtn.TextSize = 11
                KeyBtn.AutoButtonColor = false
                KeyBtn.ZIndex = 5
                KeyBtn.Parent = Lbl

                local KBCorner = Instance.new("UICorner")
                KBCorner.CornerRadius = UDim.new(0, 5)
                KBCorner.Parent = KeyBtn

                local KBStroke = Instance.new("UIStroke")
                KBStroke.Color = VRSLib.Theme.InputStroke
                KBStroke.Thickness = 1
                KBStroke.Parent = KeyBtn

                local keyObj
                local callbacks = {}
                if cfg.Callback then table.insert(callbacks, cfg.Callback) end
                if cfg.Func then table.insert(callbacks, cfg.Func) end

                local listening = false
                local conn = nil

                KeyBtn.MouseEnter:Connect(function()
                    if not listening then
                        TweenService:Create(KBStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.Accent }):Play()
                    end
                end)
                KeyBtn.MouseLeave:Connect(function()
                    if not listening then
                        TweenService:Create(KBStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.InputStroke }):Play()
                    end
                end)

                local function setKey(newKeyName)
                    keyName = tostring(newKeyName)
                    keyObj.Value = keyName
                    KeyBtn.Text = "[" .. keyName .. "]"
                    KeyBtn.TextColor3 = VRSLib.Theme.TextPrimary
                    KBStroke.Color = VRSLib.Theme.InputStroke

                    if id == "MenuKeybind" or id == "ToggleKeybind" or cfg.SyncToggle then
                        local kc = Enum.KeyCode[keyName]
                        if kc and win then
                            win.Keybind = kc
                        end
                    end

                    for _, fn in ipairs(callbacks) do
                        task.spawn(fn, keyName)
                    end
                    for _, fn in ipairs(keyObj._vrsListeners or {}) do
                        task.spawn(fn, keyName)
                    end
                    local autoSave = (getgenv and getgenv().requestAutoSave) or _G.requestAutoSave
                    if autoSave then autoSave() end
                end

                KeyBtn.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    KeyBtn.Text = "[...]"
                    KeyBtn.TextColor3 = VRSLib.Theme.Accent
                    KBStroke.Color = VRSLib.Theme.Accent

                    conn = UserInputService.InputBegan:Connect(function(input, gpe)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Escape then
                                listening = false
                                if conn then conn:Disconnect() conn = nil end
                                setKey("None")
                            else
                                listening = false
                                if conn then conn:Disconnect() conn = nil end
                                setKey(input.KeyCode.Name)
                            end
                        end
                    end)
                end)

                keyObj = {
                    Value = keyName,
                    SetValue = function(selfOrVal, maybeVal)
                        local v = maybeVal
                        if v == nil then v = selfOrVal end
                        if type(v) == "table" then v = v[1] or v.key or "RightControl" end
                        setKey(tostring(v))
                    end,
                    OnChanged = function(selfOrFn, maybeFn)
                        local fn = maybeFn or selfOrFn
                        if type(fn) == "function" then table.insert(callbacks, fn) end
                        return keyObj
                    end,
                    Button = KeyBtn
                }

                if win and win.Options then win.Options[id] = keyObj end
                if VRSLib and VRSLib.Options then VRSLib.Options[id] = keyObj end
                if _G.Options then _G.Options[id] = keyObj end
                if getgenv and getgenv().Options then getgenv().Options[id] = keyObj end
                return keyObj
            end,
            Frame = Lbl
        }
        return labelObj
    end

    -- 7. AddKeyPicker (Direct interactive row)
    function BoxObj:AddKeyPicker(idOrConfig, optionalConfig)
        local id, cfg
        if type(idOrConfig) == "string" then
            id = idOrConfig
            cfg = optionalConfig or {}
        else
            cfg = idOrConfig or {}
            id = cfg.Id or cfg.Title or cfg.Text or "Keybind"
        end

        local cTitle = cfg.Title or cfg.Text or tostring(id)
        local keyName = cfg.Default or "RightControl"
        if type(keyName) == "table" then keyName = keyName[1] or "RightControl" end
        keyName = tostring(keyName)

        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 26)
        Row.BackgroundTransparency = 1
        Row.Parent = Content

        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(1, -102, 1, 0)
        Lbl.BackgroundTransparency = 1
        Lbl.Text = cTitle
        Lbl.Font = Enum.Font.GothamMedium
        Lbl.TextSize = 11.5
        Lbl.TextColor3 = VRSLib.Theme.TextPrimary
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Parent = Row
        ProtectLocalization(Lbl)

        local KeyBtn = Instance.new("TextButton")
        KeyBtn.Name = "KeyPicker_" .. tostring(id)
        KeyBtn.Size = UDim2.new(0, 96, 0, 22)
        KeyBtn.Position = UDim2.new(1, -96, 0.5, -11)
        KeyBtn.BackgroundColor3 = VRSLib.Theme.InputBackground
        KeyBtn.BorderSizePixel = 0
        KeyBtn.Font = Enum.Font.GothamBold
        KeyBtn.Text = "[" .. tostring(keyName) .. "]"
        KeyBtn.TextColor3 = VRSLib.Theme.TextPrimary
        KeyBtn.TextSize = 11
        KeyBtn.AutoButtonColor = false
        KeyBtn.Parent = Row

        local KBCorner = Instance.new("UICorner")
        KBCorner.CornerRadius = UDim.new(0, 5)
        KBCorner.Parent = KeyBtn

        local KBStroke = Instance.new("UIStroke")
        KBStroke.Color = VRSLib.Theme.InputStroke
        KBStroke.Thickness = 1
        KBStroke.Parent = KeyBtn

        local win = self.Window or (VRSLib.Windows and VRSLib.Windows[1])
        local keyObj
        local callbacks = {}
        if cfg.Callback then table.insert(callbacks, cfg.Callback) end
        if cfg.Func then table.insert(callbacks, cfg.Func) end

        local listening = false
        local conn = nil

        KeyBtn.MouseEnter:Connect(function()
            if not listening then
                TweenService:Create(KBStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.Accent }):Play()
            end
        end)
        KeyBtn.MouseLeave:Connect(function()
            if not listening then
                TweenService:Create(KBStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.InputStroke }):Play()
            end
        end)

        local function setKey(newKeyName)
            keyName = tostring(newKeyName)
            keyObj.Value = keyName
            KeyBtn.Text = "[" .. keyName .. "]"
            KeyBtn.TextColor3 = VRSLib.Theme.TextPrimary
            KBStroke.Color = VRSLib.Theme.InputStroke

            if id == "MenuKeybind" or id == "ToggleKeybind" or cfg.SyncToggle then
                local kc = Enum.KeyCode[keyName]
                if kc and win then
                    win.Keybind = kc
                end
            end

            for _, fn in ipairs(callbacks) do
                task.spawn(fn, keyName)
            end
            for _, fn in ipairs(keyObj._vrsListeners or {}) do
                task.spawn(fn, keyName)
            end
            local autoSave = (getgenv and getgenv().requestAutoSave) or _G.requestAutoSave
            if autoSave then autoSave() end
        end

        KeyBtn.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            KeyBtn.Text = "[...]"
            KeyBtn.TextColor3 = VRSLib.Theme.Accent
            KBStroke.Color = VRSLib.Theme.Accent

            conn = UserInputService.InputBegan:Connect(function(input, gpe)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode == Enum.KeyCode.Escape then
                        listening = false
                        if conn then conn:Disconnect() conn = nil end
                        setKey("None")
                    else
                        listening = false
                        if conn then conn:Disconnect() conn = nil end
                        setKey(input.KeyCode.Name)
                    end
                end
            end)
        end)

        keyObj = {
            Value = keyName,
            SetValue = function(selfOrVal, maybeVal)
                local v = maybeVal
                if v == nil then v = selfOrVal end
                if type(v) == "table" then v = v[1] or v.key or "RightControl" end
                setKey(tostring(v))
            end,
            OnChanged = function(selfOrFn, maybeFn)
                local fn = maybeFn or selfOrFn
                if type(fn) == "function" then table.insert(callbacks, fn) end
                return keyObj
            end,
            Frame = Row,
            Button = KeyBtn
        }

        if win and win.Options then win.Options[id] = keyObj end
        if VRSLib.Options then VRSLib.Options[id] = keyObj end
        if _G.Options then _G.Options[id] = keyObj end
        if getgenv and getgenv().Options then getgenv().Options[id] = keyObj end
        return keyObj
    end

    -- 8. AddColorPicker
    function BoxObj:AddColorPicker(idOrConfig, optionalConfig)
        local id = (type(idOrConfig) == "string" and idOrConfig) or (idOrConfig and idOrConfig.Id) or "ColorPicker"
        local cfg = (type(idOrConfig) == "table" and idOrConfig) or optionalConfig or {}
        local defColor = cfg.Default or Color3.fromRGB(255, 64, 140)
        local colorObj = {
            Value = defColor,
            SetValue = function(self, c) self.Value = c end
        }
        if self.Window.Options then self.Window.Options[id] = colorObj end
        if _G.Options then _G.Options[id] = colorObj end
        if getgenv then getgenv().Options[id] = colorObj end
        return colorObj
    end

    -- 9. AddQueueList (Clean list of steps/items)
    function BoxObj:AddQueueList(ctrlConfig)
        ctrlConfig = ctrlConfig or {}
        local items = ctrlConfig.Items or {}

        local QFrame = Instance.new("Frame")
        QFrame.Size = UDim2.new(1, 0, 0, 0)
        QFrame.AutomaticSize = Enum.AutomaticSize.Y
        QFrame.BackgroundTransparency = 1
        QFrame.Parent = Content

        local QList = Instance.new("UIListLayout")
        QList.SortOrder = Enum.SortOrder.LayoutOrder
        QList.Padding = UDim.new(0, 4)
        QList.Parent = QFrame

        for i, item in ipairs(items) do
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, 24)
            Row.BackgroundColor3 = VRSLib.Theme.InputBackground
            Row.BackgroundTransparency = 0.5
            Row.BorderSizePixel = 0
            Row.LayoutOrder = i
            Row.Parent = QFrame

            local RCorner = Instance.new("UICorner")
            RCorner.CornerRadius = UDim.new(0, 4)
            RCorner.Parent = Row

            local RowText = Instance.new("TextLabel")
            RowText.Size = UDim2.new(1, -70, 1, 0)
            RowText.Position = UDim2.new(0, 8, 0, 0)
            RowText.BackgroundTransparency = 1
            RowText.Text = item.Text or tostring(item)
            RowText.Font = Enum.Font.GothamMedium
            RowText.TextSize = 10.5
            RowText.TextColor3 = item.IsActive and VRSLib.Theme.TextPrimary or VRSLib.Theme.TextMuted
            RowText.TextXAlignment = Enum.TextXAlignment.Left
            RowText.Parent = Row
            ProtectLocalization(RowText)

            if item.Tag or item.IsActive then
                local TagLbl = Instance.new("TextLabel")
                TagLbl.Size = UDim2.new(0, 60, 1, 0)
                TagLbl.Position = UDim2.new(1, -66, 0, 0)
                TagLbl.BackgroundTransparency = 1
                TagLbl.Text = item.Tag or (item.IsActive and "◀ ACTIVE" or "")
                TagLbl.Font = Enum.Font.GothamBold
                TagLbl.TextSize = 9.5
                TagLbl.TextColor3 = item.IsActive and VRSLib.Theme.Accent or VRSLib.Theme.TextMuted
                TagLbl.TextXAlignment = Enum.TextXAlignment.Right
                TagLbl.Parent = Row
                ProtectLocalization(TagLbl)
            end
        end

        return QFrame
    end    -- 10. AddInput (Text Input Box - Obsidian / Linoria Compatible)
    function BoxObj:AddInput(idOrConfig, optionalConfig)
        local id, ctrlConfig
        if type(idOrConfig) == "string" then
            id = idOrConfig
            ctrlConfig = optionalConfig or {}
        else
            ctrlConfig = idOrConfig or {}
            id = ctrlConfig.Id or ctrlConfig.Title or ctrlConfig.Text or "Input"
        end

        local cTitle = ctrlConfig.Title or ctrlConfig.Text or tostring(id)
        local defVal = ctrlConfig.Default or ""
        local placeholder = ctrlConfig.Placeholder or "Type here..."
        local isNumeric = (ctrlConfig.Numeric == true)
        local isFinished = (ctrlConfig.Finished ~= false)
        local clearFocus = (ctrlConfig.ClearTextOnFocus == true)

        local IFrame = Instance.new("Frame")
        IFrame.Size = UDim2.new(1, 0, 0, 48)
        IFrame.BackgroundTransparency = 1
        IFrame.Parent = Content

        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(1, 0, 0, 16)
        Lbl.BackgroundTransparency = 1
        Lbl.Text = cTitle
        Lbl.Font = Enum.Font.GothamMedium
        Lbl.TextSize = 11.5
        Lbl.TextColor3 = VRSLib.Theme.TextPrimary
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Parent = IFrame
        ProtectLocalization(Lbl)

        local BoxFrame = Instance.new("Frame")
        BoxFrame.Size = UDim2.new(1, 0, 0, 26)
        BoxFrame.Position = UDim2.new(0, 0, 0, 18)
        BoxFrame.BackgroundColor3 = VRSLib.Theme.InputBackground
        BoxFrame.BorderSizePixel = 0
        BoxFrame.Parent = IFrame

        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 5)
        BCorner.Parent = BoxFrame

        local BStroke = Instance.new("UIStroke")
        BStroke.Color = VRSLib.Theme.CardStroke
        BStroke.Thickness = 1
        BStroke.Parent = BoxFrame

        local TBox = Instance.new("TextBox")
        TBox.Size = UDim2.new(1, -16, 1, 0)
        TBox.Position = UDim2.new(0, 8, 0, 0)
        TBox.BackgroundTransparency = 1
        TBox.Text = tostring(defVal)
        TBox.PlaceholderText = placeholder
        TBox.Font = Enum.Font.GothamMedium
        TBox.TextSize = 10.5
        TBox.TextColor3 = VRSLib.Theme.TextPrimary
        TBox.PlaceholderColor3 = Color3.fromRGB(100, 105, 125)
        TBox.TextXAlignment = Enum.TextXAlignment.Left
        TBox.ClearTextOnFocus = clearFocus
        TBox.Parent = BoxFrame

        TBox.Focused:Connect(function()
            TweenService:Create(BStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.Accent }):Play()
        end)
        TBox.FocusLost:Connect(function()
            TweenService:Create(BStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.CardStroke }):Play()
        end)

        local curVal = tostring(defVal)
        local callbacks = {}
        if ctrlConfig.Callback then table.insert(callbacks, ctrlConfig.Callback) end
        if ctrlConfig.Func then table.insert(callbacks, ctrlConfig.Func) end

        local inputObj
        local function triggerFire(val)
            curVal = tostring(val)
            if inputObj then inputObj.Value = (isNumeric and tonumber(val) or val) end
            for _, fn in ipairs(callbacks) do
                task.spawn(fn, inputObj.Value)
            end
        end

        if isFinished then
            TBox.FocusLost:Connect(function(enterPressed)
                if isNumeric then
                    local num = tonumber(TBox.Text)
                    if num then
                        triggerFire(num)
                    else
                        TBox.Text = tostring(curVal)
                    end
                else
                    triggerFire(TBox.Text)
                end
            end)
        else
            TBox:GetPropertyChangedSignal("Text"):Connect(function()
                if isNumeric then
                    local num = tonumber(TBox.Text)
                    if num then triggerFire(num) end
                else
                    triggerFire(TBox.Text)
                end
            end)
        end

        inputObj = {
            Value = isNumeric and (tonumber(defVal) or 0) or tostring(defVal),
            SetValue = function(selfOrVal, maybeVal)
                local v = (maybeVal ~= nil and maybeVal) or selfOrVal
                TBox.Text = tostring(v)
                triggerFire(v)
            end,
            OnChanged = function(selfOrFn, maybeFn)
                local fn = maybeFn or selfOrFn
                if type(fn) == "function" then
                    table.insert(callbacks, fn)
                end
                return inputObj
            end,
            Frame = IFrame
        }

        if self.Window.Options then self.Window.Options[id] = inputObj end
        if _G.Options then _G.Options[id] = inputObj end
        if getgenv then getgenv().Options[id] = inputObj end
        return inputObj
    end

    function BoxObj:Resize() end

    return BoxObj
end

-- Method on TabObj to create dual columns
function Window:SetupDualColumns(tabObj)
    tabObj.LayoutType = "Columns"

    local ColContainer = Instance.new("Frame")
    ColContainer.Name = "ColContainer_" .. tabObj.Name
    ColContainer.Size = UDim2.new(1, 0, 0, 0)
    ColContainer.AutomaticSize = Enum.AutomaticSize.Y
    ColContainer.BackgroundTransparency = 1
    ColContainer.Visible = false
    ColContainer.Parent = self.CardsScroll
    tabObj.ColumnsContainer = ColContainer

    local CPadding = Instance.new("UIPadding")
    CPadding.PaddingLeft = UDim.new(0, 16)
    CPadding.PaddingRight = UDim.new(0, 16)
    CPadding.PaddingTop = UDim.new(0, 4)
    CPadding.PaddingBottom = UDim.new(0, 28)
    CPadding.Parent = ColContainer

    local LeftColFrame = Instance.new("Frame")
    LeftColFrame.Name = "LeftCol"
    LeftColFrame.Size = UDim2.new(0.5, -6, 0, 0)
    LeftColFrame.Position = UDim2.new(0, 0, 0, 0)
    LeftColFrame.AutomaticSize = Enum.AutomaticSize.Y
    LeftColFrame.BackgroundTransparency = 1
    LeftColFrame.Parent = ColContainer

    local LList = Instance.new("UIListLayout")
    LList.SortOrder = Enum.SortOrder.LayoutOrder
    LList.Padding = UDim.new(0, 12)
    LList.Parent = LeftColFrame

    local RightColFrame = Instance.new("Frame")
    RightColFrame.Name = "RightCol"
    RightColFrame.Size = UDim2.new(0.5, -6, 0, 0)
    RightColFrame.Position = UDim2.new(0.5, 6, 0, 0)
    RightColFrame.AutomaticSize = Enum.AutomaticSize.Y
    RightColFrame.BackgroundTransparency = 1
    RightColFrame.Parent = ColContainer

    local RList = Instance.new("UIListLayout")
    RList.SortOrder = Enum.SortOrder.LayoutOrder
    RList.Padding = UDim.new(0, 12)
    RList.Parent = RightColFrame

    local function MakeColHelper(colFrame)
        local h = { Frame = colFrame, Window = self, Tab = tabObj }
        function h:AddGroupbox(cfgOrTitle, optionalIcon)
            local box = self.Window:CreateGroupbox(colFrame, cfgOrTitle, optionalIcon, self.Tab)
            box.Tab = self.Tab
            return box
        end
        return h
    end

    tabObj.LeftCol = MakeColHelper(LeftColFrame)
    tabObj.RightCol = MakeColHelper(RightColFrame)

    return tabObj.LeftCol, tabObj.RightCol
end

function Window:ReflowGrid()
    if self.CurrentView ~= "Grid" then return end
    local scrollW = (self.CardsScroll and self.CardsScroll.AbsoluteSize.X > 50) and self.CardsScroll.AbsoluteSize.X or (self.MainFrame.AbsoluteSize.X - 221)
    if scrollW <= 100 then
        scrollW = self.MainFrame.AbsoluteSize.X - 221
    end
    -- Deduct 32px (16px left + 16px right scroll padding)
    local availableW = scrollW - 32
    if availableW <= 200 then availableW = 780 end

    local gap = 10
    self.GridLayout.CellPadding = UDim2.fromOffset(gap, gap)

    -- STRICTLY 4 columns for standard window (1020px)!
    -- 4 spacious cards (~193px width x 78px height) like 404hub
    local cols = 4
    if availableW >= 1150 then
        cols = 5
    elseif availableW < 600 then
        cols = 3
    else
        cols = 4
    end

    local cellW = math.floor((availableW - (cols - 1) * gap) / cols)
    local cellH = 78

    -- STRICTLY lock column count so cards NEVER pack into 7-8 narrow columns!
    self.GridLayout.FillDirectionMaxCells = cols
    self.GridLayout.CellSize = UDim2.fromOffset(cellW, cellH)
end

-- ==============================================================================
-- CATEGORY & TAB SYSTEM
-- ==============================================================================
-- ==============================================================================
-- COLLAPSIBLE CATEGORY SYSTEM (QUICK, UNIVERSAL, DUNGEON CAN BE MINIMIZED!)
-- ==============================================================================
function Window:AddCategory(categoryName, layoutOrder)
    local upperName = string.upper(categoryName)
    if self.CategoryObjects[upperName] then
        return self.CategoryObjects[upperName]
    end

    local order = layoutOrder and ((layoutOrder < 100 and layoutOrder * 100) or layoutOrder) or (#self.Categories * 100 + 100)

    local CategoryObj = {
        Window    = self,
        Name      = upperName,
        Order     = order,
        Expanded  = true,
        Tabs      = {},
    }

    -- Top spacing divider between categories (except first category)
    if #self.Categories > 0 then
        local Spacer = Instance.new("Frame")
        Spacer.Name = "CategorySpacer_" .. upperName
        Spacer.Size = UDim2.new(1, 0, 0, 10)
        Spacer.BackgroundTransparency = 1
        Spacer.LayoutOrder = order - 1
        Spacer.Parent = self.SidebarScroll
    end

    local HeaderBtn = Instance.new("TextButton")
    HeaderBtn.Name = "CategoryHeader_" .. upperName
    HeaderBtn.Size = UDim2.new(1, 0, 0, 26)
    HeaderBtn.BackgroundTransparency = 1
    HeaderBtn.Text = ""
    HeaderBtn.AutoButtonColor = false
    HeaderBtn.LayoutOrder = order
    HeaderBtn.Parent = self.SidebarScroll
    CategoryObj.Header = HeaderBtn

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Size = UDim2.new(1, -30, 1, 0)
    HeaderText.Position = UDim2.new(0, 6, 0, 0)
    HeaderText.BackgroundTransparency = 1
    HeaderText.Text = upperName
    HeaderText.Font = Enum.Font.GothamBold
    HeaderText.TextSize = 10
    HeaderText.TextColor3 = Color3.fromRGB(225, 230, 245)
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left
    HeaderText.Parent = HeaderBtn
    ProtectLocalization(HeaderText)
    CategoryObj.Label = HeaderText

    local Chevron = Instance.new("ImageLabel")
    Chevron.Name = "Chevron"
    Chevron.Size = UDim2.fromOffset(12, 12)
    Chevron.Position = UDim2.new(1, -16, 0.5, -6)
    Chevron.BackgroundTransparency = 1
    Chevron.Image = VRSLib.Icons.Get("chevron-down")
    Chevron.ImageColor3 = Color3.fromRGB(225, 230, 245)
    Chevron.Rotation = 0
    Chevron.Parent = HeaderBtn
    CategoryObj.Chevron = Chevron

    function CategoryObj:Toggle(expanded)
        if expanded == nil then expanded = not self.Expanded end
        self.Expanded = expanded

        TweenService:Create(Chevron, TweenInfo.new(0.2), {
            Rotation = self.Expanded and 0 or -90,
            ImageColor3 = self.Expanded and VRSLib.Theme.Accent or Color3.fromRGB(225, 230, 245)
        }):Play()

        for _, tab in ipairs(self.Tabs) do
            tab.Button.Visible = self.Expanded
            if tab.HasSubTabs and tab.SubContainer then
                tab.SubContainer.Visible = self.Expanded and tab.IsExpanded or false
            end
        end
    end

    HeaderBtn.MouseEnter:Connect(function()
        TweenService:Create(HeaderText, TweenInfo.new(0.15), { TextColor3 = VRSLib.Theme.TextPrimary }):Play()
        TweenService:Create(Chevron, TweenInfo.new(0.15), { ImageColor3 = VRSLib.Theme.TextPrimary }):Play()
    end)
    HeaderBtn.MouseLeave:Connect(function()
        TweenService:Create(HeaderText, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(225, 230, 245) }):Play()
        TweenService:Create(Chevron, TweenInfo.new(0.15), { ImageColor3 = self.Expanded and VRSLib.Theme.Accent or Color3.fromRGB(225, 230, 245) }):Play()
    end)
    HeaderBtn.MouseButton1Click:Connect(function()
        CategoryObj:Toggle()
    end)

    self.CategoryObjects[upperName] = CategoryObj
    table.insert(self.Categories, categoryName)
    return CategoryObj
end

function Window:AddCategoryHeader(name, layoutOrder)
    return self:AddCategory(name, layoutOrder)
end

function Window:InitQuickCategory()
    self:AddCategory("QUICK", 1)

    self.AllModulesTab = self:CreateSidebarTab({
        Name = "All modules",
        Category = "QUICK",
        Icon = VRSLib.Icons.Get("all"),
        LayoutOrder = 2,
        IsQuickTab = true,
        QuickFilter = "All"
    })

    self.PinnedTab = self:CreateSidebarTab({
        Name = "Pinned",
        Category = "QUICK",
        Icon = VRSLib.Icons.Get("pinned"),
        LayoutOrder = 3,
        IsQuickTab = true,
        QuickFilter = "Pinned"
    })

    self.ActiveTabBtn = self:CreateSidebarTab({
        Name = "Active",
        Category = "QUICK",
        Icon = VRSLib.Icons.Get("active"),
        LayoutOrder = 4,
        IsQuickTab = true,
        QuickFilter = "Active"
    })

    self:SelectTab(self.AllModulesTab)
end

function Window:CreateSidebarTab(config)
    local tabName     = config.Name or "Tab"
    local category    = config.Category or "UNIVERSAL"
    local iconId      = VRSLib.Icons.Get(config.Icon or "Visuals")

    local catUpper = string.upper(category)
    local catObj = self.CategoryObjects[catUpper]
    if not catObj then
        catObj = self:AddCategory(category)
    end

    local baseCatOrder = (catObj.Order < 100 and catObj.Order * 100) or catObj.Order
    local layoutOrder = config.LayoutOrder or (baseCatOrder + (#catObj.Tabs + 1) * 10)

    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = "Tab_" .. tabName
    TabBtn.Size = UDim2.new(1, 0, 0, 30)
    TabBtn.BackgroundColor3 = VRSLib.Theme.Sidebar
    TabBtn.BackgroundTransparency = 1
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = ""
    TabBtn.LayoutOrder = layoutOrder
    TabBtn.Parent = self.SidebarScroll

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabBtn

    -- Left Accent Bar (Pink when active)
    local ActiveIndicator = Instance.new("Frame")
    ActiveIndicator.Size = UDim2.new(0, 3, 0, 14)
    ActiveIndicator.Position = UDim2.new(0, 2, 0.5, -7)
    ActiveIndicator.BackgroundColor3 = VRSLib.Theme.Accent
    ActiveIndicator.BorderSizePixel = 0
    ActiveIndicator.Visible = false
    ActiveIndicator.Parent = TabBtn

    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(1, 0)
    IndCorner.Parent = ActiveIndicator

    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.fromOffset(14, 14)
    TabIcon.Position = UDim2.new(0, 10, 0.5, -7)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Image = iconId
    TabIcon.ImageColor3 = VRSLib.Theme.TextMuted
    TabIcon.Parent = TabBtn

    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -38, 1, 0)
    TabLabel.Position = UDim2.new(0, 30, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = tabName
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.TextSize = 12
    TabLabel.TextColor3 = Color3.fromRGB(240, 244, 255)
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabBtn
    ProtectLocalization(TabLabel)

    local Badge = Instance.new("Frame")
    Badge.Size = UDim2.new(0, 0, 0, 0)
    Badge.BackgroundTransparency = 1
    Badge.Visible = false
    Badge.Parent = TabBtn

    local BadgeCorner = Instance.new("UICorner")
    BadgeCorner.CornerRadius = UDim.new(0, 8)
    BadgeCorner.Parent = Badge

    local BadgeText = Instance.new("TextLabel")
    BadgeText.Size = UDim2.new(0, 0, 0, 0)
    BadgeText.BackgroundTransparency = 1
    BadgeText.Visible = false
    BadgeText.Text = ""
    BadgeText.Parent = Badge
    ProtectLocalization(BadgeText)

    local TabObj = {
        Window      = self,
        Name        = tabName,
        Category    = category,
        Button      = TabBtn,
        Icon        = TabIcon,
        Label       = TabLabel,
        Badge       = Badge,
        BadgeText   = BadgeText,
        Indicator   = ActiveIndicator,
        IsQuickTab  = config.IsQuickTab or false,
        QuickFilter = config.QuickFilter,
        Cards       = {},
    }

    function TabObj:AddModule(modConfig)
        return self.Window:AddModule(self, modConfig)
    end
    function TabObj:AddColumns()
        return self.Window:SetupDualColumns(self)
    end
    function TabObj:AddLeftGroupbox(titleOrCfg, optionalIcon)
        if not self.LeftCol then self:AddColumns() end
        return self.LeftCol:AddGroupbox(titleOrCfg, optionalIcon)
    end
    function TabObj:AddRightGroupbox(titleOrCfg, optionalIcon)
        if not self.RightCol then self:AddColumns() end
        return self.RightCol:AddGroupbox(titleOrCfg, optionalIcon)
    end

    TabBtn.MouseEnter:Connect(function()
        if self.ActiveTab ~= TabObj then
            TweenService:Create(TabBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.6, BackgroundColor3 = VRSLib.Theme.CardHover }):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.15), { TextColor3 = VRSLib.Theme.TextPrimary }):Play()
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if self.ActiveTab ~= TabObj then
            TweenService:Create(TabBtn, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(240, 244, 255) }):Play()
        end
    end)

    TabBtn.MouseButton1Click:Connect(function()
        if TabObj.HasSubTabs then
            TabObj.IsExpanded = not TabObj.IsExpanded
            TabObj.SubContainer.Visible = TabObj.IsExpanded
            if TabObj.IsExpanded then
                TabObj.SubContainer.Size = UDim2.new(1, 0, 0, #TabObj.SubTabs * 34 + 6)
            end
            TweenService:Create(TabObj.Chevron, TweenInfo.new(0.2), {
                Rotation = TabObj.IsExpanded and 90 or 0,
                ImageColor3 = TabObj.IsExpanded and VRSLib.Theme.Accent or VRSLib.Theme.TextMuted
            }):Play()

            -- If expanding and no sub-tab is currently active, activate first subtab
            if TabObj.IsExpanded and #TabObj.SubTabs > 0 then
                local isChildActive = false
                for _, sub in ipairs(TabObj.SubTabs) do
                    if self.ActiveTab == sub then isChildActive = true break end
                end
                if not isChildActive then
                    self:SelectTab(TabObj.SubTabs[1])
                end
            end
        else
            self:SelectTab(TabObj)
        end
    end)

    -- SubTab / Sub-Drop Factory (Accordion Dropdown Groups ala Obsidian)
    function TabObj:AddSubTab(subConfig)
        subConfig = subConfig or {}
        local subName = subConfig.Name or "SubTab"
        local subIcon = VRSLib.Icons.Get(subConfig.Icon or "folder")
        self.HasSubTabs = true

        -- Create Chevron on Parent Tab if not exists
        if not self.Chevron then
            local Chevron = Instance.new("ImageLabel")
            Chevron.Name = "Chevron"
            Chevron.Size = UDim2.fromOffset(12, 12)
            Chevron.Position = UDim2.new(1, -16, 0.5, -6)
            Chevron.BackgroundTransparency = 1
            Chevron.Image = VRSLib.Icons.Get("chevron-right")
            Chevron.ImageColor3 = VRSLib.Theme.TextMuted
            Chevron.Rotation = 0
            Chevron.Parent = self.Button
            self.Chevron = Chevron

            -- Generous spacing: Chevron at -16px with clean padding
            self.Badge.Visible = false
            self.Label.Size = UDim2.new(1, -38, 1, 0)
        end

        -- Create SubTabs Container if not exists
        if not self.SubContainer then
            self.SubTabs = {}
            self.IsExpanded = false

            local SubContainer = Instance.new("Frame")
            SubContainer.Name = "SubContainer_" .. self.Name
            SubContainer.Size = UDim2.new(1, 0, 0, 0)
            SubContainer.BackgroundTransparency = 1
            SubContainer.BorderSizePixel = 0
            SubContainer.ClipsDescendants = true
            SubContainer.LayoutOrder = self.Button.LayoutOrder + 1
            SubContainer.Visible = false
            SubContainer.Parent = self.Window.SidebarScroll

            local SubList = Instance.new("UIListLayout")
            SubList.SortOrder = Enum.SortOrder.LayoutOrder
            SubList.Padding = UDim.new(0, 3)
            SubList.Parent = SubContainer

            local SubPadding = Instance.new("UIPadding")
            SubPadding.PaddingLeft = UDim.new(0, 16)
            SubPadding.PaddingRight = UDim.new(0, 4)
            SubPadding.PaddingTop = UDim.new(0, 2)
            SubPadding.PaddingBottom = UDim.new(0, 4)
            SubPadding.Parent = SubContainer

            self.SubContainer = SubContainer
        end

        local subOrder = #self.SubTabs + 1
        local SubBtn = Instance.new("TextButton")
        SubBtn.Name = "SubTab_" .. subName
        SubBtn.Size = UDim2.new(1, 0, 0, 30)
        SubBtn.BackgroundTransparency = 1
        SubBtn.BackgroundColor3 = VRSLib.Theme.Card
        SubBtn.BorderSizePixel = 0
        SubBtn.Text = ""
        SubBtn.AutoButtonColor = false
        SubBtn.LayoutOrder = subOrder
        SubBtn.Parent = self.SubContainer

        local SubCorner = Instance.new("UICorner")
        SubCorner.CornerRadius = UDim.new(0, 6)
        SubCorner.Parent = SubBtn

        -- Sub-tab Tree branch pip (Single sleek vertical guide line that changes color to Neon Pink when active)
        local TreePip = Instance.new("Frame")
        TreePip.Name = "TreePip"
        TreePip.Size = UDim2.new(0, 2.5, 0, 16)
        TreePip.Position = UDim2.new(0, 6, 0.5, -8)
        TreePip.BackgroundColor3 = VRSLib.Theme.Outline
        TreePip.BorderSizePixel = 0
        TreePip.Parent = SubBtn

        local TreeCorner = Instance.new("UICorner")
        TreeCorner.CornerRadius = UDim.new(1, 0)
        TreeCorner.Parent = TreePip

        local SubIcon = Instance.new("ImageLabel")
        SubIcon.Size = UDim2.fromOffset(14, 14)
        SubIcon.Position = UDim2.new(0, 18, 0.5, -7)
        SubIcon.BackgroundTransparency = 1
        SubIcon.Image = subIcon
        SubIcon.ImageColor3 = VRSLib.Theme.TextMuted
        SubIcon.Parent = SubBtn

        local SubLabel = Instance.new("TextLabel")
        SubLabel.Size = UDim2.new(1, -68, 1, 0)
        SubLabel.Position = UDim2.new(0, 38, 0, 0)
        SubLabel.BackgroundTransparency = 1
        SubLabel.Text = subName
        SubLabel.Font = Enum.Font.GothamMedium
        SubLabel.TextSize = 11.5
        SubLabel.TextColor3 = Color3.fromRGB(240, 244, 255)
        SubLabel.TextXAlignment = Enum.TextXAlignment.Left
        SubLabel.Parent = SubBtn
        ProtectLocalization(SubLabel)

        local SubBadge = Instance.new("Frame")
        SubBadge.Size = UDim2.new(0, 0, 0, 0)
        SubBadge.BackgroundTransparency = 1
        SubBadge.Visible = false
        SubBadge.Parent = SubBtn

        local SubBadgeCorner = Instance.new("UICorner")
        SubBadgeCorner.CornerRadius = UDim.new(0, 6)
        SubBadgeCorner.Parent = SubBadge

        local SubBadgeText = Instance.new("TextLabel")
        SubBadgeText.Size = UDim2.new(0, 0, 0, 0)
        SubBadgeText.BackgroundTransparency = 1
        SubBadgeText.Visible = false
        SubBadgeText.Text = ""
        SubBadgeText.Parent = SubBadge
        ProtectLocalization(SubBadgeText)

        local SubTabObj = {
            Window       = self.Window,
            ParentTab    = self,
            Name         = subName,
            Category     = self.Name,
            FullCategory = self.Category,
            Button       = SubBtn,
            Icon         = SubIcon,
            Label        = SubLabel,
            Badge        = SubBadge,
            BadgeText    = SubBadgeText,
            Indicator    = TreePip,
            TreePip      = TreePip,
            Cards        = {},
            IsSubTab     = true,
        }

        function SubTabObj:AddModule(modConfig)
            return self.Window:AddModule(self, modConfig)
        end

        function SubTabObj:AddColumns()
            return self.Window:SetupDualColumns(self)
        end

        function SubTabObj:AddLeftGroupbox(titleOrCfg, optionalIcon)
            if not self.LeftCol then self:AddColumns() end
            return self.LeftCol:AddGroupbox(titleOrCfg, optionalIcon)
        end

        function SubTabObj:AddRightGroupbox(titleOrCfg, optionalIcon)
            if not self.RightCol then self:AddColumns() end
            return self.RightCol:AddGroupbox(titleOrCfg, optionalIcon)
        end

        SubBtn.MouseEnter:Connect(function()
            if self.Window.ActiveTab ~= SubTabObj then
                TweenService:Create(SubBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.6, BackgroundColor3 = VRSLib.Theme.CardHover }):Play()
                TweenService:Create(SubLabel, TweenInfo.new(0.15), { TextColor3 = VRSLib.Theme.TextPrimary }):Play()
                TweenService:Create(TreePip, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(70, 75, 95) }):Play()
            end
        end)
        SubBtn.MouseLeave:Connect(function()
            if self.Window.ActiveTab ~= SubTabObj then
                TweenService:Create(SubBtn, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
                TweenService:Create(SubLabel, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(240, 244, 255) }):Play()
                TweenService:Create(TreePip, TweenInfo.new(0.15), { BackgroundColor3 = VRSLib.Theme.Outline }):Play()
            end
        end)

        SubBtn.MouseButton1Click:Connect(function()
            self.Window:SelectTab(SubTabObj)
        end)

        table.insert(self.SubTabs, SubTabObj)
        table.insert(self.Window.Tabs, SubTabObj)

        -- Keep container height exactly matching number of children
        self.SubContainer.Size = UDim2.new(1, 0, 0, #self.SubTabs * 34 + 6)

        return SubTabObj
    end

    table.insert(self.Tabs, TabObj)
    if self.CategoryObjects[catUpper] then
        table.insert(self.CategoryObjects[catUpper].Tabs, TabObj)
    end
    return TabObj
end

function Window:AddTab(tabNameOrConfig, optionalIcon, optionalCategory)
    local config
    if type(tabNameOrConfig) == "string" then
        config = {
            Name = tabNameOrConfig,
            Icon = optionalIcon or "folder",
            Category = optionalCategory or "UNIVERSAL"
        }
    else
        config = tabNameOrConfig or {}
    end
    return self:CreateSidebarTab(config)
end

function Window:AddTabGroup(tabNameOrConfig, optionalIcon, optionalCategory)
    return self:AddTab(tabNameOrConfig, optionalIcon, optionalCategory)
end

function Window:SelectTab(tabObj)
    self.ActiveTab = tabObj
    self.CurrentCategory = tabObj.Category

    local parentOfCurrent = tabObj.IsSubTab and tabObj.ParentTab or (tabObj.HasSubTabs and tabObj or nil)

    -- Manage Top Horizontal SubNavBar
    if parentOfCurrent and #parentOfCurrent.SubTabs > 0 then
        self.SubNavBar.Visible = true
        self.CardsScroll.Position = UDim2.new(0, 0, 0, 72)
        self.CardsScroll.Size = UDim2.new(1, 0, 1, -72)

        -- Clear old subnav buttons
        for _, ch in ipairs(self.SubNavScroll:GetChildren()) do
            if ch:IsA("TextButton") then ch:Destroy() end
        end

        for _, sub in ipairs(parentOfCurrent.SubTabs) do
            local isActive = (sub == tabObj)
            local SBtn = Instance.new("TextButton")
            SBtn.Size = UDim2.new(0, 0, 1, 0)
            SBtn.AutomaticSize = Enum.AutomaticSize.X
            SBtn.BackgroundTransparency = 1
            SBtn.Text = ""
            SBtn.AutoButtonColor = false
            SBtn.Parent = self.SubNavScroll

            local SBox = Instance.new("Frame")
            SBox.Size = UDim2.new(0, 0, 1, 0)
            SBox.AutomaticSize = Enum.AutomaticSize.X
            SBox.BackgroundTransparency = 1
            SBox.Parent = SBtn

            local SPadding = Instance.new("UIPadding")
            SPadding.PaddingLeft = UDim.new(0, 8)
            SPadding.PaddingRight = UDim.new(0, 8)
            SPadding.Parent = SBox

            local SLayout = Instance.new("UIListLayout")
            SLayout.FillDirection = Enum.FillDirection.Horizontal
            SLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            SLayout.Padding = UDim.new(0, 6)
            SLayout.Parent = SBox

            local SIcon = Instance.new("ImageLabel")
            SIcon.Size = UDim2.fromOffset(13, 13)
            SIcon.BackgroundTransparency = 1
            SIcon.Image = sub.Icon.Image
            SIcon.ImageColor3 = isActive and VRSLib.Theme.Accent or VRSLib.Theme.TextMuted
            SIcon.Parent = SBox

            local SLbl = Instance.new("TextLabel")
            SLbl.Size = UDim2.new(0, 0, 1, 0)
            SLbl.AutomaticSize = Enum.AutomaticSize.X
            SLbl.BackgroundTransparency = 1
            SLbl.Text = sub.Name
            SLbl.Font = Enum.Font.GothamBold
            SLbl.TextSize = 11
            SLbl.TextColor3 = isActive and VRSLib.Theme.TextPrimary or VRSLib.Theme.TextMuted
            SLbl.Parent = SBox
            ProtectLocalization(SLbl)

            -- Active glowing underline
            if isActive then
                local ULine = Instance.new("Frame")
                ULine.Size = UDim2.new(1, 0, 0, 2)
                ULine.Position = UDim2.new(0, 0, 1, -2)
                ULine.BackgroundColor3 = VRSLib.Theme.Accent
                ULine.BorderSizePixel = 0
                ULine.Parent = SBtn
            end

            SBtn.MouseEnter:Connect(function()
                if not (sub == self.ActiveTab) then
                    TweenService:Create(SLbl, TweenInfo.new(0.15), { TextColor3 = VRSLib.Theme.TextPrimary }):Play()
                    TweenService:Create(SIcon, TweenInfo.new(0.15), { ImageColor3 = Color3.fromRGB(220, 220, 230) }):Play()
                end
            end)
            SBtn.MouseLeave:Connect(function()
                if not (sub == self.ActiveTab) then
                    TweenService:Create(SLbl, TweenInfo.new(0.15), { TextColor3 = VRSLib.Theme.TextMuted }):Play()
                    TweenService:Create(SIcon, TweenInfo.new(0.15), { ImageColor3 = VRSLib.Theme.TextMuted }):Play()
                end
            end)

            SBtn.MouseButton1Click:Connect(function()
                self:SelectTab(sub)
            end)
        end
    else
        self.SubNavBar.Visible = false
        self.CardsScroll.Position = UDim2.new(0, 0, 0, 38)
        self.CardsScroll.Size = UDim2.new(1, 0, 1, -38)
    end

    -- Switch between Grid Mode and Columns Mode
    if tabObj.LayoutType == "Columns" then
        self.GridContainer.Visible = false
        if self.ViewSwitchers then self.ViewSwitchers.Visible = false end
        for _, t in ipairs(self.Tabs) do
            if t.ColumnsContainer then
                t.ColumnsContainer.Visible = (t == tabObj)
            end
        end
    else
        self.GridContainer.Visible = true
        if self.ViewSwitchers then self.ViewSwitchers.Visible = true end
        for _, t in ipairs(self.Tabs) do
            if t.ColumnsContainer then
                t.ColumnsContainer.Visible = false
            end
        end
        self:ReflowGrid()
    end

    if tabObj.IsSubTab then
        self.BreadcrumbCategory.Text = string.upper(tabObj.ParentTab.Name) .. " / "
        self.BreadcrumbTab.Text = tabObj.Name
        self.BreadcrumbBadge.Visible = false

        if tabObj.ParentTab then
            TweenService:Create(tabObj.ParentTab.Button, TweenInfo.new(0.2), { BackgroundTransparency = 0.5, BackgroundColor3 = VRSLib.Theme.Card }):Play()
            TweenService:Create(tabObj.ParentTab.Label, TweenInfo.new(0.2), { TextColor3 = VRSLib.Theme.TextPrimary }):Play()
            if tabObj.ParentTab.Chevron then
                TweenService:Create(tabObj.ParentTab.Chevron, TweenInfo.new(0.2), { Rotation = 90, ImageColor3 = VRSLib.Theme.Accent }):Play()
            end
            if tabObj.ParentTab.SubContainer then
                tabObj.ParentTab.SubContainer.Visible = true
                tabObj.ParentTab.IsExpanded = true
            end
        end
    else
        self.BreadcrumbCategory.Text = string.upper(tabObj.Category) .. " / "
        self.BreadcrumbTab.Text = tabObj.Name
        self.BreadcrumbBadge.Visible = false
    end

    for _, t in ipairs(self.Tabs) do
        if t == tabObj then
            TweenService:Create(t.Button, TweenInfo.new(0.2), { BackgroundTransparency = 0, BackgroundColor3 = VRSLib.Theme.Card }):Play()
            TweenService:Create(t.Label, TweenInfo.new(0.2), { TextColor3 = VRSLib.Theme.TextPrimary }):Play()
            TweenService:Create(t.Icon, TweenInfo.new(0.2), { ImageColor3 = VRSLib.Theme.Accent }):Play()
            if t.IsSubTab then
                TweenService:Create(t.Indicator, TweenInfo.new(0.2), { BackgroundColor3 = VRSLib.Theme.Accent }):Play()
            else
                t.Indicator.Visible = true
            end
        else
            local isParentOfCurrent = (tabObj.IsSubTab and t == tabObj.ParentTab)
            if not isParentOfCurrent then
                TweenService:Create(t.Button, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
                TweenService:Create(t.Label, TweenInfo.new(0.2), { TextColor3 = VRSLib.Theme.TextMuted }):Play()
                TweenService:Create(t.Icon, TweenInfo.new(0.2), { ImageColor3 = VRSLib.Theme.TextMuted }):Play()
                if t.IsSubTab then
                    TweenService:Create(t.Indicator, TweenInfo.new(0.2), { BackgroundColor3 = VRSLib.Theme.Outline }):Play()
                else
                    t.Indicator.Visible = false
                end
            end
        end
    end

    self:FilterModules(self.SearchQuery)
end

function Window:UpdateBadges()
    -- Numbers/badges hidden for clean, uncluttered modern sidebar
    if self.BreadcrumbBadge then
        self.BreadcrumbBadge.Visible = false
        self.BreadcrumbBadge.Text = ""
    end
end

-- ==============================================================================
-- MODULE CARD ENGINE (TOGGLES, ACTIONS & SLIDERS)
-- ==============================================================================
local ModuleCard = {}
ModuleCard.__index = ModuleCard

function Window:AddModule(tabOrConfig, optionalConfig)
    local tab, config
    if typeof(tabOrConfig) == "table" and tabOrConfig.Cards ~= nil then
        tab = tabOrConfig
        config = optionalConfig or {}
    else
        config = tabOrConfig or {}
        tab = config.Tab or self.ActiveTab or self.Tabs[1]
    end

    local title       = config.Title or "Module"
    local desc        = config.Description or config.Desc or ""
    local iconId      = VRSLib.Icons.Get(config.Icon or "Shield")
    local modType     = config.Type or "Toggle"
    local defaultVal  = config.Default or false
    local callback    = config.Callback or function() end

    local CardObj = setmetatable({
        Window      = self,
        Tab         = tab,
        Title       = title,
        Description = desc,
        Type        = modType,
        Value       = defaultVal,
        IsPinned    = false,
        Callback    = callback,
        SubElements = {},
        IsExpanded  = false,
    }, ModuleCard)

    local CardFrame = Instance.new("Frame")
    CardFrame.Name = "Card_" .. title
    CardFrame.Size = UDim2.fromOffset(193, 78)
    CardFrame.BackgroundColor3 = VRSLib.Theme.Card
    CardFrame.BorderSizePixel = 0
    CardFrame.ClipsDescendants = true
    CardFrame.Parent = self.GridContainer
    CardObj.Frame = CardFrame

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 7)
    CardCorner.Parent = CardFrame

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = VRSLib.Theme.CardStroke
    CardStroke.Thickness = 1
    CardStroke.Parent = CardFrame
    CardObj.Stroke = CardStroke

    -- Top Row
    local TopRow = Instance.new("Frame")
    TopRow.Size = UDim2.new(1, -16, 0, 22)
    TopRow.Position = UDim2.new(0, 8, 0, 8)
    TopRow.BackgroundTransparency = 1
    TopRow.Parent = CardFrame

    local ModIcon = Instance.new("ImageLabel")
    ModIcon.Size = UDim2.fromOffset(15, 15)
    ModIcon.Position = UDim2.new(0, 0, 0.5, -7.5)
    ModIcon.BackgroundTransparency = 1
    ModIcon.Image = iconId
    ModIcon.ImageColor3 = VRSLib.Theme.TextMuted
    ModIcon.Parent = TopRow

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, (modType == "Toggle" and -76 or -58), 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 11
    TitleLabel.TextColor3 = VRSLib.Theme.TextPrimary
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLabel.Parent = TopRow
    ProtectLocalization(TitleLabel)

    local PinBtn = Instance.new("ImageButton")
    PinBtn.Name = "PinBtn"
    PinBtn.Size = UDim2.fromOffset(13, 13)
    PinBtn.Position = UDim2.new(1, (modType == "Toggle" and -50 or -38), 0.5, -6.5)
    PinBtn.BackgroundTransparency = 1
    PinBtn.Image = VRSLib.Icons.Get("star")
    PinBtn.ImageColor3 = VRSLib.Theme.TextMuted
    PinBtn.Parent = TopRow

    PinBtn.MouseButton1Click:Connect(function()
        CardObj.IsPinned = not CardObj.IsPinned
        TweenService:Create(PinBtn, TweenInfo.new(0.15), {
            ImageColor3 = CardObj.IsPinned and VRSLib.Theme.Accent or VRSLib.Theme.TextMuted
        }):Play()
        self:UpdateBadges()
        if self.ActiveTab == self.PinnedTab then
            self:FilterModules(self.SearchQuery)
        end
    end)

    -- Description
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -16, 0, 36)
    DescLabel.Position = UDim2.new(0, 8, 0, 33)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = desc
    DescLabel.Font = Enum.Font.GothamMedium
    DescLabel.TextSize = 9.5
    DescLabel.TextColor3 = VRSLib.Theme.TextMuted
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.TextWrapped = true
    DescLabel.TextTruncate = Enum.TextTruncate.AtEnd
    DescLabel.Parent = CardFrame
    ProtectLocalization(DescLabel)

    -- Pill Toggle or Action Play Button (100% Pink when Active)
    if modType == "Toggle" then
        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.fromOffset(30, 16)
        Switch.Position = UDim2.new(1, -30, 0.5, -8)
        Switch.BackgroundColor3 = (defaultVal and VRSLib.Theme.Accent or VRSLib.Theme.SwitchOff)
        Switch.BorderSizePixel = 0
        Switch.Text = ""
        Switch.Parent = TopRow

        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = Switch

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.fromOffset(12, 12)
        Knob.Position = (defaultVal and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6))
        Knob.BackgroundColor3 = (defaultVal and VRSLib.Theme.SwitchOnKnob or VRSLib.Theme.SwitchOffKnob)
        Knob.BorderSizePixel = 0
        Knob.Parent = Switch

        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(1, 0)
        KnobCorner.Parent = Knob

        local function SetState(val)
            CardObj.Value = val
            local targetBg   = val and VRSLib.Theme.Accent or VRSLib.Theme.SwitchOff
            local targetKnob = val and VRSLib.Theme.SwitchOnKnob or VRSLib.Theme.SwitchOffKnob
            local targetPos  = val and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)

            TweenService:Create(Switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = targetBg
            }):Play()
            TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = targetPos,
                BackgroundColor3 = targetKnob
            }):Play()

            self:UpdateBadges()
            task.spawn(CardObj.Callback, val)
        end

        Switch.MouseButton1Click:Connect(function()
            SetState(not CardObj.Value)
        end)
        CardObj.Set = SetState

    elseif modType == "Action" then
        local ActionBtn = Instance.new("TextButton")
        ActionBtn.Size = UDim2.fromOffset(24, 18)
        ActionBtn.Position = UDim2.new(1, -24, 0.5, -9)
        ActionBtn.BackgroundColor3 = VRSLib.Theme.ActionBtn
        ActionBtn.BorderSizePixel = 0
        ActionBtn.Text = ""
        ActionBtn.Parent = TopRow

        local ActionCorner = Instance.new("UICorner")
        ActionCorner.CornerRadius = UDim.new(0, 5)
        ActionCorner.Parent = ActionBtn

        local ActionIcon = Instance.new("ImageLabel")
        ActionIcon.Size = UDim2.fromOffset(10, 10)
        ActionIcon.Position = UDim2.new(0.5, -5, 0.5, -5)
        ActionIcon.BackgroundTransparency = 1
        ActionIcon.Image = VRSLib.Icons.Get("play")
        ActionIcon.ImageColor3 = VRSLib.Theme.ActionBtnIcon
        ActionIcon.Parent = ActionBtn

        ActionBtn.MouseEnter:Connect(function()
            TweenService:Create(ActionBtn, TweenInfo.new(0.15), { BackgroundColor3 = VRSLib.Theme.ActionBtnHover }):Play()
        end)
        ActionBtn.MouseLeave:Connect(function()
            TweenService:Create(ActionBtn, TweenInfo.new(0.15), { BackgroundColor3 = VRSLib.Theme.ActionBtn }):Play()
        end)
        ActionBtn.MouseButton1Click:Connect(function()
            TweenService:Create(ActionIcon, TweenInfo.new(0.1), { Size = UDim2.fromOffset(8, 8) }):Play()
            task.delay(0.1, function()
                TweenService:Create(ActionIcon, TweenInfo.new(0.1), { Size = UDim2.fromOffset(10, 10) }):Play()
            end)
            task.spawn(CardObj.Callback)
        end)
    end

    -- Card Hover Animation (VRS Pink Accent)
    CardFrame.MouseEnter:Connect(function()
        TweenService:Create(CardFrame, TweenInfo.new(0.15), { BackgroundColor3 = VRSLib.Theme.CardHover }):Play()
        TweenService:Create(CardStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.Accent, Transparency = 0.4 }):Play()
    end)
    CardFrame.MouseLeave:Connect(function()
        TweenService:Create(CardFrame, TweenInfo.new(0.15), { BackgroundColor3 = VRSLib.Theme.Card }):Play()
        TweenService:Create(CardStroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.CardStroke, Transparency = 0 }):Play()
    end)

    table.insert(tab.Cards, CardObj)
    table.insert(self.AllCards, CardObj)
    self:UpdateBadges()
    if self.ActiveTab == self.AllModulesTab or self.ActiveTab == tab then
        self:FilterModules(self.SearchQuery)
    end

    return CardObj
end

function Window:AddTabModule(tab, config)
    return self:AddModule(tab, config)
end

-- Slider inside Card
function ModuleCard:AddSlider(config)
    local name     = config.Name or "Slider"
    local min      = config.Min or 0
    local max      = config.Max or 100
    local def      = config.Default or min
    local callback = config.Callback or function() end

    self.Frame.Size = UDim2.fromOffset(self.Frame.Size.X.Offset, 108)

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -14, 0, 24)
    SliderFrame.Position = UDim2.new(0, 7, 0, 76)
    SliderFrame.BackgroundColor3 = VRSLib.Theme.InputBackground
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = self.Frame

    local SCorner = Instance.new("UICorner")
    SCorner.CornerRadius = UDim.new(0, 5)
    SCorner.Parent = SliderFrame

    local SLabel = Instance.new("TextLabel")
    SLabel.Size = UDim2.new(1, -50, 0, 12)
    SLabel.Position = UDim2.new(0, 6, 0, 2)
    SLabel.BackgroundTransparency = 1
    SLabel.Text = name
    SLabel.Font = Enum.Font.GothamMedium
    SLabel.TextSize = 9.5
    SLabel.TextColor3 = VRSLib.Theme.TextPrimary
    SLabel.TextXAlignment = Enum.TextXAlignment.Left
    SLabel.Parent = SliderFrame

    local SVal = Instance.new("TextLabel")
    SVal.Size = UDim2.new(0, 45, 0, 12)
    SVal.Position = UDim2.new(1, -50, 0, 2)
    SVal.BackgroundTransparency = 1
    SVal.Text = tostring(def)
    SVal.Font = Enum.Font.GothamBold
    SVal.TextSize = 9.5
    SVal.TextColor3 = VRSLib.Theme.Accent
    SVal.TextXAlignment = Enum.TextXAlignment.Right
    SVal.Parent = SliderFrame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -12, 0, 3)
    Bar.Position = UDim2.new(0, 6, 0, 16)
    Bar.BackgroundColor3 = VRSLib.Theme.SwitchOff
    Bar.BorderSizePixel = 0
    Bar.Parent = SliderFrame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    local initRatio = math.clamp((def - min) / (max - min), 0, 1)
    Fill.Size = UDim2.new(initRatio, 0, 1, 0)
    Fill.BackgroundColor3 = VRSLib.Theme.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local dragging = false
    local function Update(input)
        local posX = math.clamp(input.Position.X - Bar.AbsolutePosition.X, 0, Bar.AbsoluteSize.X)
        local ratio = posX / Bar.AbsoluteSize.X
        local val = math.floor(min + (max - min) * ratio)
        Fill.Size = UDim2.new(ratio, 0, 1, 0)
        SVal.Text = tostring(val)
        task.spawn(callback, val)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input)
        end
    end)

    return SliderFrame
end

-- ==============================================================================
-- SEARCH FILTERING & VIEW MODES
-- ==============================================================================
function Window:FilterModules(query)
    self.SearchQuery = string.lower(query or "")
    local hasVisibleCards = false

    local isAllTab    = self.ActiveTab == self.AllModulesTab
    local isPinnedTab = self.ActiveTab == self.PinnedTab
    local isActiveTab = self.ActiveTab == self.ActiveTabBtn

    for _, card in ipairs(self.AllCards) do
        local matchesTab = false
        if isAllTab then
            matchesTab = true
        elseif isPinnedTab then
            matchesTab = card.IsPinned
        elseif isActiveTab then
            matchesTab = card.Value == true
        else
            matchesTab = (card.Tab == self.ActiveTab)
        end

        local matchesSearch = true
        if self.SearchQuery ~= "" then
            local inTitle = string.find(string.lower(card.Title), self.SearchQuery, 1, true) ~= nil
            local inDesc  = string.find(string.lower(card.Description), self.SearchQuery, 1, true) ~= nil
            matchesSearch = inTitle or inDesc
        end

        local visible = matchesTab and matchesSearch
        card.Frame.Visible = visible
        if visible then hasVisibleCards = true end
    end

    if self.SearchQuery ~= "" then
        self.EmptyState.Text = "No matching modules found"
        self.EmptyState.Visible = not hasVisibleCards
    elseif isPinnedTab and not hasVisibleCards then
        self.EmptyState.Text = "No pinned modules yet — pin cards using card actions!"
        self.EmptyState.Visible = true
    elseif isActiveTab and not hasVisibleCards then
        self.EmptyState.Text = "No active modules right now — turn on any toggle to see cards here."
        self.EmptyState.Visible = true
    else
        self.EmptyState.Visible = false
    end
end

function Window:SetViewMode(mode)
    self.CurrentView = mode

    for m, data in pairs(self.ViewButtons) do
        local active = (m == mode)
        TweenService:Create(data.Button, TweenInfo.new(0.15), {
            BackgroundTransparency = active and 0 or 1,
            BackgroundColor3 = active and VRSLib.Theme.InputBackground or Color3.fromRGB(0,0,0)
        }):Play()
        TweenService:Create(data.Icon, TweenInfo.new(0.15), {
            ImageColor3 = active and VRSLib.Theme.TextPrimary or VRSLib.Theme.TextMuted
        }):Play()
    end

    if mode == "Grid" then
        self:ReflowGrid()
    elseif mode == "List" then
        local scrollW = (self.CardsScroll and self.CardsScroll.AbsoluteSize.X > 50) and self.CardsScroll.AbsoluteSize.X or (self.MainFrame.AbsoluteSize.X - 186)
        local availableW = scrollW - 32
        self.GridLayout.FillDirectionMaxCells = 1
        self.GridLayout.CellPadding = UDim2.fromOffset(8, 6)
        self.GridLayout.CellSize = UDim2.fromOffset(availableW, 64)
    end
end

-- ==============================================================================
-- CONTROLS (TOGGLE, MAXIMIZE)
-- ==============================================================================
function Window:Toggle()
    self.Visible = not self.Visible
    if self.Visible then
        self.MainFrame.Visible = true
        self.MainFrame.Size = UDim2.new(0, self.DefaultSize.X.Offset * 0.95, 0, self.DefaultSize.Y.Offset * 0.95)
        TweenService:Create(self.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = (self.IsMaximized and self.MaximizedSize or self.DefaultSize),
            BackgroundTransparency = 0
        }):Play()
        task.delay(0.25, function() self:ReflowGrid() end)
    else
        local tw = TweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, self.DefaultSize.X.Offset * 0.9, 0, self.DefaultSize.Y.Offset * 0.9),
            BackgroundTransparency = 1
        })
        tw:Play()
        tw.Completed:Connect(function()
            if not self.Visible then
                self.MainFrame.Visible = false
            end
        end)
    end
end

function Window:ToggleMaximize()
    self.IsMaximized = not self.IsMaximized
    local targetSize = self.IsMaximized and self.MaximizedSize or self.DefaultSize

    TweenService:Create(self.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = targetSize,
        Position = UDim2.new(0.5, -targetSize.X.Offset / 2, 0.5, -targetSize.Y.Offset / 2)
    }):Play()
    task.delay(0.25, function() self:ReflowGrid() end)
end

function Window:Unload()
    VRSLib:Notify({
        Title = "VRS Artelier",
        Description = "Closing hub & unloading script...",
        Duration = 2,
        Icon = VRSLib.Icons.Wings
    })

    task.delay(0.2, function()
        if self.OnUnload then
            pcall(self.OnUnload)
        end
        if _G.VRS_SCRIPT_UNLOAD then
            pcall(_G.VRS_SCRIPT_UNLOAD)
        end
        pcall(function()
            if self.Gui then self.Gui:Destroy() end
        end)
    end)
end

return VRSLib
