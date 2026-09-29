--[[
    ==============================================================================
    ⬛ VRS MONO ENGINE — V2 (1:1 TARGET RECREATION)
    ==============================================================================
    Engineered with 1:1 fidelity to reference designs:
      * Unified Outer Shell (Single seamless frame, no detached gap!)
      * Frosted Glass Sidebar (Docked left, subtle divider line)
      * Clean Emblem Brand Logo (Auto-loads local custom asset / fallback)
      * White Active Tab Indicator Bar (Left-edge pill)
      * Player Avatar Footer with Emerald Green Online Status Indicator
      * Background Wallpaper Engine (Image ID/URL with adjustable Opacity)
      * Ambient Weather Particle System (Snow falling across window)
      * Sub-Tab Pill Bar ([田 Overview] [▷ Main Menu])
      * Multi-Column Grid Support (2-Column layout for Settings & Controls)
      * Complete Component Suite:
          - Profile / Hero Banner
          - Live Stat Counters (FPS, Ping, Session, Players, Execs)
          - Groupboxes with title, collapse dash (-), and category icon
          - iOS-Style Switches (White ON, Dark OFF)
          - Sliders with Pill Value Badges
          - Inline Drop Bars (Single & Multi-Select with floating popout)
          - Inputs (TextBox) & Action Buttons
          - Interactive Keybinds
          - InfoRows with Copy Buttons
          - Notice & Warning Banners
    ==============================================================================
]]

local cloneref = (cloneref or clonereference or function(i) return i end)
local CoreGui          = cloneref(game:GetService("CoreGui"))
local Players          = cloneref(game:GetService("Players"))
local TweenService     = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService       = cloneref(game:GetService("RunService"))
local HttpService      = cloneref(game:GetService("HttpService"))
local LocalPlayer      = Players.LocalPlayer or Players.PlayerAdded:Wait()

local VRSLibV2 = {
    Version = "2.2.0-Mono",
    Windows = {},
    ActiveWindow = nil,
    Theme = {
        Background      = Color3.fromRGB(16, 17, 21),    -- Charcoal Abu-Abu (#101115)
        BackgroundTrans = 0,                             -- Base solid
        Sidebar         = Color3.fromRGB(14, 15, 19),    -- Docked Sidebar (#0E0F13)
        SidebarTrans    = 0.35,                          -- Frosted Glass over background
        SidebarStroke   = Color3.fromRGB(38, 41, 52),
        Header          = Color3.fromRGB(16, 17, 21),
        Card            = Color3.fromRGB(25, 26, 33),    -- Elevated Card (#191A21)
        CardHover       = Color3.fromRGB(32, 34, 44),
        CardStroke      = Color3.fromRGB(38, 41, 52),    -- Sleek Stroke
        CardInner       = Color3.fromRGB(18, 19, 25),    -- Embedded containers
        CardInnerStroke = Color3.fromRGB(32, 35, 45),
        Accent          = Color3.fromRGB(255, 255, 255), -- Pure Mono White
        AccentMuted     = Color3.fromRGB(180, 185, 200),
        TextPrimary     = Color3.fromRGB(255, 255, 255), -- White text
        TextSecondary   = Color3.fromRGB(150, 155, 172), -- Medium slate
        TextMuted       = Color3.fromRGB(105, 110, 126), -- Dim grey
        SwitchOff       = Color3.fromRGB(34, 36, 46),
        SwitchOffKnob   = Color3.fromRGB(115, 120, 135),
        SwitchOn        = Color3.fromRGB(255, 255, 255), -- White Pill
        SwitchOnKnob    = Color3.fromRGB(16, 17, 21),    -- Dark Knob
        PillIndicator   = Color3.fromRGB(255, 255, 255), -- White active bar
        OnlineDot       = Color3.fromRGB(34, 197, 94),   -- Emerald green
        WarningBadge    = Color3.fromRGB(234, 179, 8),   -- Warning yellow
        ActionBtn       = Color3.fromRGB(28, 30, 39),
        ActionBtnHover  = Color3.fromRGB(38, 41, 54),
    }
}

-- Safe GUI Resolver
local function GetSafeGui()
    if gethui then
        return gethui()
    elseif syn and syn.protect_gui then
        local g = Instance.new("ScreenGui")
        syn.protect_gui(g)
        g.Parent = CoreGui
        return g
    end
    return CoreGui
end

local function QuickTween(obj, props, duration, style, dir)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

-- ==============================================================================
-- 1. ASSET & LOGO LOADER (Guaranteed to Render in all Executors)
-- ==============================================================================
local function LoadCustomImage(url, filename, fallbackAssetId)
    if getcustomasset and writefile and isfile then
        pcall(function()
            if not isfile(filename) then
                local raw = game:HttpGet(url)
                if raw and #raw > 0 then
                    writefile(filename, raw)
                end
            end
        end)
        if isfile(filename) then
            local ok, asset = pcall(getcustomasset, filename)
            if ok and asset then return asset end
        end
    end
    return fallbackAssetId
end

VRSLibV2.Icons = (function()
    local LogoUrl = "https://raw.githubusercontent.com/vrsspace/VRSLib/main/assets/mono_logo.png"
    local ResolvedLogo = LoadCustomImage(LogoUrl, "vrs_mono_logo.png", "rbxassetid://10709761813")

    local Map = {
        ["wings"]             = ResolvedLogo,
        ["brand"]             = ResolvedLogo,
        ["logo"]              = ResolvedLogo,
        ["ouroboros"]         = ResolvedLogo,
        ["home"]              = "rbxassetid://10709789810",
        ["layout-grid"]       = "rbxassetid://10709789508",
        ["grid"]              = "rbxassetid://10709789508",
        ["overview"]          = "rbxassetid://10709789508",
        ["list"]              = "rbxassetid://10709789643",
        ["menu"]              = "rbxassetid://10709790537",
        ["swords"]            = "rbxassetid://10709819149",
        ["combat"]            = "rbxassetid://10709819149",
        ["shield"]            = "rbxassetid://10709811911",
        ["clan"]              = "rbxassetid://10709811911",
        ["settings"]          = "rbxassetid://10709810948",
        ["gear"]              = "rbxassetid://10709810948",
        ["user"]              = "rbxassetid://10709818834",
        ["users"]             = "rbxassetid://10709818967",
        ["players"]           = "rbxassetid://10709818967",
        ["friends"]           = "rbxassetid://10709818967",
        ["search"]            = "rbxassetid://10734943674",
        ["clock"]             = "rbxassetid://10709752630",
        ["session"]           = "rbxassetid://10709752630",
        ["gauge"]             = "rbxassetid://10709788686",
        ["speed"]             = "rbxassetid://10709788686",
        ["fps"]               = "rbxassetid://10709788686",
        ["wifi"]              = "rbxassetid://10709819443",
        ["ping"]              = "rbxassetid://10709819443",
        ["zap"]               = "rbxassetid://10709819617",
        ["execs"]             = "rbxassetid://10709819617",
        ["minus"]             = "rbxassetid://10709790757",
        ["x"]                 = "rbxassetid://10709819844",
        ["close"]             = "rbxassetid://10709819844",
        ["check"]             = "rbxassetid://10709790644",
        ["chevron-down"]      = "rbxassetid://10709790948",
        ["chevron-up"]        = "rbxassetid://10709791043",
        ["chevron-right"]     = "rbxassetid://10709791130",
        ["chevron-left"]      = "rbxassetid://10709791281",
        ["copy"]              = "rbxassetid://10709791437",
        ["external-link"]     = "rbxassetid://10709791558",
        ["play"]              = "rbxassetid://10709810810",
        ["eye"]               = "rbxassetid://10709791694",
        ["eye-off"]           = "rbxassetid://10709791786",
        ["sliders"]           = "rbxassetid://10709811520",
        ["terminal"]          = "rbxassetid://10709811776",
        ["code"]              = "rbxassetid://10709791880",
        ["folder"]            = "rbxassetid://10709788798",
        ["star"]              = "rbxassetid://10709811651",
        ["alert-circle"]      = "rbxassetid://10709752996",
        ["alert-triangle"]    = "rbxassetid://10709753149",
        ["info"]              = "rbxassetid://10709790387",
        ["refresh-cw"]        = "rbxassetid://10709810534",
        ["cloud"]             = "rbxassetid://10709788574",
        ["globe"]             = "rbxassetid://10709789392",
        ["database"]          = "rbxassetid://10709791993",
        ["box"]               = "rbxassetid://10709782497",
        ["palette"]           = "rbxassetid://10709810463",
        ["desktop"]           = "rbxassetid://10709791558",
        ["computer"]          = "rbxassetid://10709791558",
    }

    return {
        Logo = ResolvedLogo,
        Get = function(name)
            if not name or name == "" then return Map["box"] end
            local s = tostring(name):lower():gsub("lucide%-", "")
            if s:sub(1, 13) == "rbxassetid://" then return s end
            if Map[s] then return Map[s] end
            return Map["box"]
        end
    }
end)()

-- ==============================================================================
-- 2. CREATE WINDOW IMPLEMENTATION (UNIFIED FRAME WITH BACKGROUND & WEATHER)
-- ==============================================================================
function VRSLibV2:CreateWindow(config)
    config = config or {}

    local defaultTitle = "Welcome to Slayer 2!"
    pcall(function()
        local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        if info and info.Name then defaultTitle = "Welcome to " .. info.Name .. "!" end
    end)

    local initialTitle   = (config.Title == "auto" or not config.Title) and defaultTitle or config.Title
    local windowSubtitle = config.SubTitle or "v0.167"
    local windowSize     = config.Size or UDim2.fromOffset(1020, 620)
    local windowKeybind  = config.Keybind or Enum.KeyCode.RightControl
    local bgOpacity      = config.BackgroundOpacity or 0.65
    local bgImage        = config.Background or "rbxassetid://132817836308238" -- Subtle aesthetic backdrop
    local weatherMode    = config.Weather or "Snow"

    -- Close old instance
    if _G.VRS_MONO_UNLOAD then pcall(_G.VRS_MONO_UNLOAD) end

    local RootGui = Instance.new("ScreenGui")
    RootGui.Name = "VRS_Mono_" .. HttpService:GenerateGUID(false):sub(1, 8)
    RootGui.ResetOnSpawn = false
    RootGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    RootGui.Parent = GetSafeGui()

    -- UNIFIED MAIN SHELL (Sidebar + Content together in ONE frame)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = windowSize
    MainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
    MainFrame.BackgroundColor3 = VRSLibV2.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = RootGui

    local mfCorner = Instance.new("UICorner")
    mfCorner.CornerRadius = UDim.new(0, 16)
    mfCorner.Parent = MainFrame

    local mfStroke = Instance.new("UIStroke")
    mfStroke.Color = Color3.fromRGB(42, 45, 58)
    mfStroke.Thickness = 1
    mfStroke.Parent = MainFrame

    -- Subtle Dark Glass Gradient on Base Window
    local mfGrad = Instance.new("UIGradient")
    mfGrad.Rotation = 90
    mfGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 25, 32)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(18, 19, 24)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 17))
    })
    mfGrad.Parent = MainFrame

    -- BACKGROUND IMAGE LAYER (Customizable Wallpaper with Opacity)
    local BgImageLabel = Instance.new("ImageLabel")
    BgImageLabel.Name = "BackgroundImage"
    BgImageLabel.Size = UDim2.new(1, 0, 1, 0)
    BgImageLabel.BackgroundTransparency = 1
    BgImageLabel.ScaleType = Enum.ScaleType.Crop
    BgImageLabel.ImageTransparency = 1 - bgOpacity
    BgImageLabel.ZIndex = 1
    BgImageLabel.Parent = MainFrame

    local function ApplyBackground(src, opacity)
        if not src or src == "" or src == "None" then
            BgImageLabel.Visible = false
            return
        end
        BgImageLabel.Visible = true
        if opacity then
            BgImageLabel.ImageTransparency = 1 - opacity
        end
        if src:sub(1, 4) == "http" then
            local asset = LoadCustomImage(src, "vrs_bg_" .. HttpService:GenerateGUID(false):sub(1, 6) .. ".png", src)
            BgImageLabel.Image = asset
        else
            BgImageLabel.Image = src
        end
    end

    if bgImage and bgImage ~= "None" then
        ApplyBackground(bgImage, bgOpacity)
    end

    -- WEATHER LAYER (Snow Particles Floating across Window)
    local WeatherContainer = Instance.new("Frame")
    WeatherContainer.Name = "WeatherContainer"
    WeatherContainer.Size = UDim2.new(1, 0, 1, 0)
    WeatherContainer.BackgroundTransparency = 1
    WeatherContainer.ZIndex = 2
    WeatherContainer.ClipsDescendants = true
    WeatherContainer.Parent = MainFrame

    local weatherActive = (weatherMode == "Snow")
    local snowFlakes = {}

    local function InitSnow()
        for i = 1, 28 do
            local flake = Instance.new("Frame")
            local sz = math.random(2, 4)
            flake.Size = UDim2.fromOffset(sz, sz)
            flake.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            flake.BackgroundTransparency = math.random(35, 75) / 100
            flake.BorderSizePixel = 0
            flake.Position = UDim2.new(math.random(), 0, math.random(), 0)
            flake.ZIndex = 2
            flake.Parent = WeatherContainer

            local flkCorner = Instance.new("UICorner")
            flkCorner.CornerRadius = UDim.new(1, 0)
            flkCorner.Parent = flake

            table.insert(snowFlakes, {
                obj = flake,
                speed = math.random(30, 60),
                drift = math.random(-15, 15),
                seed = math.random(1, 1000)
            })
        end
    end

    InitSnow()

    local snowConn
    snowConn = RunService.RenderStepped:Connect(function(dt)
        if not weatherActive or not WeatherContainer.Parent then return end
        local t = tick()
        local h = MainFrame.AbsoluteSize.Y
        local w = MainFrame.AbsoluteSize.X
        for _, flk in ipairs(snowFlakes) do
            local curX = flk.obj.Position.X.Scale
            local curY = flk.obj.Position.Y.Offset
            local newY = curY + flk.speed * dt
            local newX = curX + (math.sin(t + flk.seed) * flk.drift * dt) / w
            if newY > h + 10 then
                newY = -10
                newX = math.random()
            end
            flk.obj.Position = UDim2.new(newX, 0, 0, newY)
        end
    end)

    -- ==========================================================================
    -- A. DOCKED FROSTED GLASS SIDEBAR (Left Column)
    -- ==========================================================================
    local SidebarWidth = 68

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, SidebarWidth, 1, 0)
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.BackgroundColor3 = VRSLibV2.Theme.Sidebar
    Sidebar.BackgroundTransparency = VRSLibV2.Theme.SidebarTrans -- 0.35 Glass
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 3
    Sidebar.Parent = MainFrame

    -- Subtle 1px Divider Line on Right of Sidebar
    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Name = "Divider"
    SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
    SidebarDivider.BackgroundColor3 = Color3.fromRGB(36, 38, 48)
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.ZIndex = 4
    SidebarDivider.Parent = Sidebar

    -- 1. Brand Logo Container
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Name = "LogoContainer"
    LogoContainer.Size = UDim2.fromOffset(46, 46)
    LogoContainer.Position = UDim2.new(0.5, -23, 0, 12)
    LogoContainer.BackgroundColor3 = Color3.fromRGB(22, 23, 29)
    LogoContainer.BorderSizePixel = 0
    LogoContainer.ZIndex = 4
    LogoContainer.Parent = Sidebar

    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 12)
    logoCorner.Parent = LogoContainer

    local logoStroke = Instance.new("UIStroke")
    logoStroke.Color = Color3.fromRGB(42, 45, 58)
    logoStroke.Thickness = 1
    logoStroke.Parent = LogoContainer

    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Name = "LogoImage"
    LogoImage.Size = UDim2.fromOffset(30, 30)
    LogoImage.Position = UDim2.new(0.5, -15, 0.5, -15)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = VRSLibV2.Icons.Logo
    LogoImage.ImageColor3 = VRSLibV2.Theme.Accent -- Pure White
    LogoImage.ScaleType = Enum.ScaleType.Fit
    LogoImage.ZIndex = 5
    LogoImage.Parent = LogoContainer

    -- 2. Vertical Navigation Tabs
    local NavList = Instance.new("ScrollingFrame")
    NavList.Name = "NavList"
    NavList.Size = UDim2.new(1, 0, 1, -145)
    NavList.Position = UDim2.new(0, 0, 0, 70)
    NavList.BackgroundTransparency = 1
    NavList.BorderSizePixel = 0
    NavList.ScrollBarThickness = 0
    NavList.CanvasSize = UDim2.new(0, 0, 0, 0)
    NavList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    NavList.ZIndex = 4
    NavList.Parent = Sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Padding = UDim.new(0, 8)
    navLayout.Parent = NavList

    -- 3. Profile Avatar Footer with Online Dot
    local ProfileFooter = Instance.new("Frame")
    ProfileFooter.Name = "ProfileFooter"
    ProfileFooter.Size = UDim2.new(1, 0, 0, 64)
    ProfileFooter.Position = UDim2.new(0, 0, 1, -64)
    ProfileFooter.BackgroundTransparency = 1
    ProfileFooter.BorderSizePixel = 0
    ProfileFooter.ZIndex = 4
    ProfileFooter.Parent = Sidebar

    local AvatarHolder = Instance.new("Frame")
    AvatarHolder.Name = "AvatarHolder"
    AvatarHolder.Size = UDim2.fromOffset(30, 30)
    AvatarHolder.Position = UDim2.new(0.5, -15, 0, 4)
    AvatarHolder.BackgroundColor3 = Color3.fromRGB(26, 27, 35)
    AvatarHolder.BorderSizePixel = 0
    AvatarHolder.ZIndex = 4
    AvatarHolder.Parent = ProfileFooter

    local avCorner = Instance.new("UICorner")
    avCorner.CornerRadius = UDim.new(1, 0)
    avCorner.Parent = AvatarHolder

    local avStroke = Instance.new("UIStroke")
    avStroke.Color = Color3.fromRGB(48, 52, 66)
    avStroke.Thickness = 1
    avStroke.Parent = AvatarHolder

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Size = UDim2.new(1, 0, 1, 0)
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.ZIndex = 4
    AvatarImg.Parent = AvatarHolder

    local avImgCorner = Instance.new("UICorner")
    avImgCorner.CornerRadius = UDim.new(1, 0)
    avImgCorner.Parent = AvatarImg

    task.spawn(function()
        pcall(function()
            AvatarImg.Image = Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
    end)

    local OnlineDot = Instance.new("Frame")
    OnlineDot.Name = "OnlineDot"
    OnlineDot.Size = UDim2.fromOffset(8, 8)
    OnlineDot.Position = UDim2.new(1, -7, 1, -7)
    OnlineDot.BackgroundColor3 = VRSLibV2.Theme.OnlineDot
    OnlineDot.BorderSizePixel = 0
    OnlineDot.ZIndex = 5
    OnlineDot.Parent = AvatarHolder

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = OnlineDot

    local dotStroke = Instance.new("UIStroke")
    dotStroke.Color = Color3.fromRGB(14, 15, 19)
    dotStroke.Thickness = 1.5
    dotStroke.Parent = OnlineDot

    local FooterName = Instance.new("TextLabel")
    FooterName.Size = UDim2.new(1, -6, 0, 12)
    FooterName.Position = UDim2.new(0, 3, 0, 37)
    FooterName.BackgroundTransparency = 1
    FooterName.Font = Enum.Font.GothamMedium
    FooterName.TextSize = 10
    FooterName.TextColor3 = VRSLibV2.Theme.TextPrimary
    FooterName.TextTruncate = Enum.TextTruncate.AtEnd
    FooterName.Text = LocalPlayer.DisplayName or LocalPlayer.Name
    FooterName.ZIndex = 4
    FooterName.Parent = ProfileFooter

    local FooterSub = Instance.new("TextLabel")
    FooterSub.Size = UDim2.new(1, -6, 0, 11)
    FooterSub.Position = UDim2.new(0, 3, 0, 49)
    FooterSub.BackgroundTransparency = 1
    FooterSub.Font = Enum.Font.Gotham
    FooterSub.TextSize = 9
    FooterSub.TextColor3 = VRSLibV2.Theme.TextMuted
    FooterSub.TextTruncate = Enum.TextTruncate.AtEnd
    FooterSub.Text = "Mono V2"
    FooterSub.ZIndex = 4
    FooterSub.Parent = ProfileFooter

    -- ==========================================================================
    -- B. CONTENT AREA (Right of Sidebar)
    -- ==========================================================================
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -SidebarWidth, 1, 0)
    ContentArea.Position = UDim2.new(0, SidebarWidth, 0, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ZIndex = 3
    ContentArea.Parent = MainFrame

    -- Top Header Bar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 56)
    Topbar.BackgroundTransparency = 1
    Topbar.BorderSizePixel = 0
    Topbar.ZIndex = 3
    Topbar.Parent = ContentArea

    local TitleHolder = Instance.new("Frame")
    TitleHolder.Name = "TitleHolder"
    TitleHolder.Size = UDim2.new(0.65, 0, 1, 0)
    TitleHolder.Position = UDim2.new(0, 16, 0, 0)
    TitleHolder.BackgroundTransparency = 1
    TitleHolder.ZIndex = 3
    TitleHolder.Parent = Topbar

    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Name = "TitleIcon"
    TitleIcon.Size = UDim2.fromOffset(18, 18)
    TitleIcon.Position = UDim2.new(0, 0, 0, 10)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Image = VRSLibV2.Icons.Get("home")
    TitleIcon.ImageColor3 = VRSLibV2.Theme.Accent
    TitleIcon.ZIndex = 4
    TitleIcon.Parent = TitleHolder

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -26, 0, 20)
    TitleLabel.Position = UDim2.new(0, 26, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 15
    TitleLabel.TextColor3 = VRSLibV2.Theme.TextPrimary
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Text = initialTitle
    TitleLabel.ZIndex = 4
    TitleLabel.Parent = TitleHolder

    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "SubtitleLabel"
    SubtitleLabel.Size = UDim2.new(1, -26, 0, 14)
    SubtitleLabel.Position = UDim2.new(0, 26, 0, 28)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextSize = 10
    SubtitleLabel.TextColor3 = VRSLibV2.Theme.TextMuted
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Text = windowSubtitle
    SubtitleLabel.ZIndex = 4
    SubtitleLabel.Parent = TitleHolder

    -- SubTab Pills Bar (Directly below Title)
    local SubTabBar = Instance.new("Frame")
    SubTabBar.Name = "SubTabBar"
    SubTabBar.Size = UDim2.new(1, 0, 0, 24)
    SubTabBar.Position = UDim2.new(0, 0, 0, 30)
    SubTabBar.BackgroundTransparency = 1
    SubTabBar.Visible = false
    SubTabBar.ZIndex = 4
    SubTabBar.Parent = TitleHolder

    local subTabLayout = Instance.new("UIListLayout")
    subTabLayout.FillDirection = Enum.FillDirection.Horizontal
    subTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    subTabLayout.Padding = UDim.new(0, 8)
    subTabLayout.Parent = SubTabBar

    -- Controls on the Right (Search + Minimize)
    local TopControls = Instance.new("Frame")
    TopControls.Name = "TopControls"
    TopControls.Size = UDim2.new(0, 220, 0, 36)
    TopControls.Position = UDim2.new(1, -232, 0, 10)
    TopControls.BackgroundTransparency = 1
    TopControls.ZIndex = 4
    TopControls.Parent = Topbar

    local SearchBox = Instance.new("Frame")
    SearchBox.Name = "SearchBox"
    SearchBox.Size = UDim2.new(1, -44, 0, 28)
    SearchBox.Position = UDim2.new(0, 0, 0, 4)
    SearchBox.BackgroundColor3 = Color3.fromRGB(24, 25, 33)
    SearchBox.BorderSizePixel = 0
    SearchBox.ZIndex = 4
    SearchBox.Parent = TopControls

    local sbBoxCorner = Instance.new("UICorner")
    sbBoxCorner.CornerRadius = UDim.new(0, 8)
    sbBoxCorner.Parent = SearchBox

    local sbBoxStroke = Instance.new("UIStroke")
    sbBoxStroke.Color = Color3.fromRGB(38, 41, 54)
    sbBoxStroke.Thickness = 1
    sbBoxStroke.Parent = SearchBox

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.fromOffset(14, 14)
    SearchIcon.Position = UDim2.new(0, 8, 0.5, -7)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = VRSLibV2.Icons.Get("search")
    SearchIcon.ImageColor3 = VRSLibV2.Theme.TextMuted
    SearchIcon.ZIndex = 5
    SearchIcon.Parent = SearchBox

    local SearchInput = Instance.new("TextBox")
    SearchInput.Size = UDim2.new(1, -28, 1, 0)
    SearchInput.Position = UDim2.new(0, 26, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.TextSize = 11
    SearchInput.TextColor3 = VRSLibV2.Theme.TextPrimary
    SearchInput.PlaceholderColor3 = VRSLibV2.Theme.TextMuted
    SearchInput.PlaceholderText = "Search..."
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.Text = ""
    SearchInput.ClearTextOnFocus = false
    SearchInput.ZIndex = 5
    SearchInput.Parent = SearchBox

    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "MinBtn"
    MinBtn.Size = UDim2.fromOffset(28, 28)
    MinBtn.Position = UDim2.new(1, -34, 0, 4)
    MinBtn.BackgroundColor3 = Color3.fromRGB(24, 25, 33)
    MinBtn.Text = "-"
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 16
    MinBtn.TextColor3 = VRSLibV2.Theme.TextSecondary
    MinBtn.AutoButtonColor = false
    MinBtn.ZIndex = 4
    MinBtn.Parent = TopControls

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = MinBtn

    local minStroke = Instance.new("UIStroke")
    minStroke.Color = Color3.fromRGB(38, 41, 54)
    minStroke.Thickness = 1
    minStroke.Parent = MinBtn

    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            QuickTween(MainFrame, { Size = UDim2.new(0, SidebarWidth, 0, 70) }, 0.25)
            ContentArea.Visible = false
        else
            ContentArea.Visible = true
            QuickTween(MainFrame, { Size = windowSize }, 0.25)
        end
    end)

    -- Window Dragging System
    local isDragging = false
    local dragStart, startPos
    local function UpdateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    local function HookDrag(frame)
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        isDragging = false
                    end
                end)
            end
        end)
    end

    HookDrag(Topbar)
    HookDrag(LogoContainer)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateDrag(input)
        end
    end)

    -- Visibility Toggle Keybind
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == windowKeybind then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- Pages Container
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Size = UDim2.new(1, -32, 1, -66)
    PagesContainer.Position = UDim2.new(0, 16, 0, 58)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.BorderSizePixel = 0
    PagesContainer.ClipsDescendants = true
    PagesContainer.ZIndex = 3
    PagesContainer.Parent = ContentArea

    local WindowObj = {
        RootGui        = RootGui,
        MainFrame      = MainFrame,
        ContentArea    = ContentArea,
        PagesContainer = PagesContainer,
        SubTabBar      = SubTabBar,
        TitleLabel     = TitleLabel,
        TitleIcon      = TitleIcon,
        SubtitleLabel  = SubtitleLabel,
        Tabs           = {},
        ActiveTab      = nil,
        Keybind        = windowKeybind,
        SetBackground  = ApplyBackground,
        SetWeather     = function(self, mode)
            weatherActive = (mode == "Snow")
            WeatherContainer.Visible = weatherActive
        end
    }

    WindowObj.OnUnload = function()
        if snowConn then snowConn:Disconnect() end
        RootGui:Destroy()
        _G.VRS_MONO_UNLOAD = nil
    end
    _G.VRS_MONO_UNLOAD = WindowObj.OnUnload

    -- ==========================================================================
    -- C. TAB IMPLEMENTATION
    -- ==========================================================================
    function WindowObj:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName   = tabConfig.Name or "Tab"
        local tabIcon   = tabConfig.Icon or "box"
        local tabHeader = tabConfig.HeaderTitle or tabName
        local tabSub    = tabConfig.Subtitle or windowSubtitle

        -- Tab Button on Sidebar
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = "Tab_" .. tabName
        TabBtn.Size = UDim2.new(0, 52, 0, 48)
        TabBtn.BackgroundColor3 = Color3.fromRGB(26, 27, 35)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.ZIndex = 4
        TabBtn.Parent = NavList

        local tbCorner = Instance.new("UICorner")
        tbCorner.CornerRadius = UDim.new(0, 10)
        tbCorner.Parent = TabBtn

        -- WHITE ACTIVE CAPSULE PILL ON LEFT EDGE
        local ActivePill = Instance.new("Frame")
        ActivePill.Name = "ActivePill"
        ActivePill.Size = UDim2.new(0, 3, 0, 0)
        ActivePill.Position = UDim2.new(0, 0, 0.5, 0)
        ActivePill.AnchorPoint = Vector2.new(0, 0.5)
        ActivePill.BackgroundColor3 = VRSLibV2.Theme.PillIndicator
        ActivePill.BorderSizePixel = 0
        ActivePill.ZIndex = 5
        ActivePill.Parent = TabBtn

        local pillCorner = Instance.new("UICorner")
        pillCorner.CornerRadius = UDim.new(0, 2)
        pillCorner.Parent = ActivePill

        local TabIconImg = Instance.new("ImageLabel")
        TabIconImg.Name = "Icon"
        TabIconImg.Size = UDim2.fromOffset(20, 20)
        TabIconImg.Position = UDim2.new(0.5, -10, 0, 6)
        TabIconImg.BackgroundTransparency = 1
        TabIconImg.Image = VRSLibV2.Icons.Get(tabIcon)
        TabIconImg.ImageColor3 = VRSLibV2.Theme.TextMuted
        TabIconImg.ZIndex = 5
        TabIconImg.Parent = TabBtn

        local TabText = Instance.new("TextLabel")
        TabText.Name = "Label"
        TabText.Size = UDim2.new(1, 0, 0, 14)
        TabText.Position = UDim2.new(0, 0, 0, 28)
        TabText.BackgroundTransparency = 1
        TabText.Font = Enum.Font.GothamMedium
        TabText.TextSize = 10
        TabText.TextColor3 = VRSLibV2.Theme.TextMuted
        TabText.Text = tabName
        TabText.ZIndex = 5
        TabText.Parent = TabBtn

        -- Tab Content Page
        local TabPage = Instance.new("Frame")
        TabPage.Name = "TabPage_" .. tabName
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ZIndex = 3
        TabPage.Parent = PagesContainer

        local TabObj = {
            Name         = tabName,
            Icon         = tabIcon,
            HeaderTitle  = tabHeader,
            Subtitle     = tabSub,
            Button       = TabBtn,
            Page         = TabPage,
            SubTabs      = {},
            ActiveSubTab = nil,
        }

        table.insert(WindowObj.Tabs, TabObj)

        function TabObj:Select()
            for _, t in ipairs(WindowObj.Tabs) do
                if t == TabObj then
                    t.Page.Visible = true
                    QuickTween(t.Button, { BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(30, 32, 42) }, 0.18)
                    QuickTween(t.Button.Icon, { ImageColor3 = VRSLibV2.Theme.Accent }, 0.18)
                    QuickTween(t.Button.Label, { TextColor3 = VRSLibV2.Theme.Accent }, 0.18)
                    QuickTween(t.Button.ActivePill, { Size = UDim2.new(0, 3, 0, 18) }, 0.2)
                else
                    t.Page.Visible = false
                    QuickTween(t.Button, { BackgroundTransparency = 1 }, 0.18)
                    QuickTween(t.Button.Icon, { ImageColor3 = VRSLibV2.Theme.TextMuted }, 0.18)
                    QuickTween(t.Button.Label, { TextColor3 = VRSLibV2.Theme.TextMuted }, 0.18)
                    QuickTween(t.Button.ActivePill, { Size = UDim2.new(0, 3, 0, 0) }, 0.2)
                end
            end

            WindowObj.ActiveTab = TabObj

            -- Correctly update Topbar Title
            local displayTitle = TabObj.HeaderTitle
            if displayTitle == "auto" or displayTitle == "" then
                displayTitle = defaultTitle
            end
            TitleLabel.Text = displayTitle
            TitleIcon.Image = VRSLibV2.Icons.Get(TabObj.Icon)
            SubtitleLabel.Text = TabObj.Subtitle

            -- SubTabs Bar
            for _, child in ipairs(SubTabBar:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end

            if #TabObj.SubTabs > 0 then
                SubTabBar.Visible = true
                SubtitleLabel.Visible = false
                for _, st in ipairs(TabObj.SubTabs) do
                    st:CreatePill()
                end
                if TabObj.ActiveSubTab then
                    TabObj.ActiveSubTab:Select()
                else
                    TabObj.SubTabs[1]:Select()
                end
            else
                SubTabBar.Visible = false
                SubtitleLabel.Visible = true
            end
        end

        TabBtn.MouseButton1Click:Connect(function()
            TabObj:Select()
        end)

        TabBtn.MouseEnter:Connect(function()
            if WindowObj.ActiveTab ~= TabObj then
                QuickTween(TabBtn, { BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(24, 25, 33) }, 0.15)
                QuickTween(TabIconImg, { ImageColor3 = VRSLibV2.Theme.TextSecondary }, 0.15)
                QuickTween(TabText, { TextColor3 = VRSLibV2.Theme.TextSecondary }, 0.15)
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if WindowObj.ActiveTab ~= TabObj then
                QuickTween(TabBtn, { BackgroundTransparency = 1 }, 0.15)
                QuickTween(TabIconImg, { ImageColor3 = VRSLibV2.Theme.TextMuted }, 0.15)
                QuickTween(TabText, { TextColor3 = VRSLibV2.Theme.TextMuted }, 0.15)
            end
        end)

        -- Scroll canvas factory
        local function CreateScrollCanvas(parent)
            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, 0, 1, 0)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel = 0
            scroll.ScrollBarThickness = 3
            scroll.ScrollBarImageColor3 = Color3.fromRGB(45, 48, 62)
            scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scroll.ZIndex = 3
            scroll.Parent = parent

            local pad = Instance.new("UIPadding")
            pad.PaddingTop = UDim.new(0, 4)
            pad.PaddingBottom = UDim.new(0, 16)
            pad.PaddingRight = UDim.new(0, 6)
            pad.Parent = scroll

            local layout = Instance.new("UIListLayout")
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 10)
            layout.Parent = scroll

            return scroll
        end

        -- SubTab Implementation
        function TabObj:AddSubTab(subConfig)
            subConfig = subConfig or {}
            local subName = subConfig.Name or "SubTab"
            local subIcon = subConfig.Icon or "overview"

            local SubPage = Instance.new("Frame")
            SubPage.Name = "SubPage_" .. subName
            SubPage.Size = UDim2.new(1, 0, 1, 0)
            SubPage.BackgroundTransparency = 1
            SubPage.Visible = false
            SubPage.ZIndex = 3
            SubPage.Parent = TabPage

            local SubScroll = CreateScrollCanvas(SubPage)

            local SubTabObj = {
                Name    = subName,
                Icon    = subIcon,
                Page    = SubPage,
                Scroll  = SubScroll,
                PillBtn = nil,
            }

            table.insert(TabObj.SubTabs, SubTabObj)

            function SubTabObj:CreatePill()
                local PillBtn = Instance.new("TextButton")
                PillBtn.Name = "Pill_" .. subName
                PillBtn.Size = UDim2.new(0, 0, 0, 22)
                PillBtn.AutomaticSize = Enum.AutomaticSize.X
                PillBtn.BackgroundColor3 = Color3.fromRGB(24, 25, 33)
                PillBtn.BackgroundTransparency = 0.4
                PillBtn.Text = ""
                PillBtn.AutoButtonColor = false
                PillBtn.ZIndex = 4
                PillBtn.Parent = SubTabBar

                local pCorner = Instance.new("UICorner")
                pCorner.CornerRadius = UDim.new(0, 6)
                pCorner.Parent = PillBtn

                local pStroke = Instance.new("UIStroke")
                pStroke.Color = Color3.fromRGB(38, 41, 52)
                pStroke.Thickness = 1
                pStroke.Parent = PillBtn

                local pPad = Instance.new("UIPadding")
                pPad.PaddingLeft = UDim.new(0, 8)
                pPad.PaddingRight = UDim.new(0, 8)
                pPad.Parent = PillBtn

                local pLayout = Instance.new("UIListLayout")
                pLayout.FillDirection = Enum.FillDirection.Horizontal
                pLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                pLayout.Padding = UDim.new(0, 5)
                pLayout.Parent = PillBtn

                local pIcon = Instance.new("ImageLabel")
                pIcon.Size = UDim2.fromOffset(13, 13)
                pIcon.BackgroundTransparency = 1
                pIcon.Image = VRSLibV2.Icons.Get(subIcon)
                pIcon.ImageColor3 = VRSLibV2.Theme.TextMuted
                pIcon.ZIndex = 5
                pIcon.Parent = PillBtn

                local pText = Instance.new("TextLabel")
                pText.Size = UDim2.new(0, 0, 1, 0)
                pText.AutomaticSize = Enum.AutomaticSize.X
                pText.BackgroundTransparency = 1
                pText.Font = Enum.Font.GothamMedium
                pText.TextSize = 11
                pText.TextColor3 = VRSLibV2.Theme.TextMuted
                pText.Text = subName
                pText.ZIndex = 5
                pText.Parent = PillBtn

                SubTabObj.PillBtn = PillBtn
                SubTabObj.PillStroke = pStroke
                SubTabObj.PillIcon = pIcon
                SubTabObj.PillText = pText

                PillBtn.MouseButton1Click:Connect(function()
                    SubTabObj:Select()
                end)
            end

            function SubTabObj:Select()
                for _, st in ipairs(TabObj.SubTabs) do
                    if st == SubTabObj then
                        st.Page.Visible = true
                        if st.PillBtn then
                            QuickTween(st.PillBtn, { BackgroundColor3 = Color3.fromRGB(34, 36, 48), BackgroundTransparency = 0 }, 0.15)
                            QuickTween(st.PillStroke, { Color = Color3.fromRGB(55, 60, 75) }, 0.15)
                            QuickTween(st.PillIcon, { ImageColor3 = VRSLibV2.Theme.Accent }, 0.15)
                            QuickTween(st.PillText, { TextColor3 = VRSLibV2.Theme.Accent }, 0.15)
                        end
                    else
                        st.Page.Visible = false
                        if st.PillBtn then
                            QuickTween(st.PillBtn, { BackgroundColor3 = Color3.fromRGB(24, 25, 33), BackgroundTransparency = 0.5 }, 0.15)
                            QuickTween(st.PillStroke, { Color = Color3.fromRGB(38, 41, 52) }, 0.15)
                            QuickTween(st.PillIcon, { ImageColor3 = VRSLibV2.Theme.TextMuted }, 0.15)
                            QuickTween(st.PillText, { TextColor3 = VRSLibV2.Theme.TextMuted }, 0.15)
                        end
                    end
                end
                TabObj.ActiveSubTab = SubTabObj
            end

            VRSLibV2:_AttachComponentFactory(SubTabObj, SubScroll)
            return SubTabObj
        end

        local DefaultScroll = CreateScrollCanvas(TabPage)
        TabObj.Scroll = DefaultScroll
        VRSLibV2:_AttachComponentFactory(TabObj, DefaultScroll)

        if #WindowObj.Tabs == 1 then
            task.defer(function() TabObj:Select() end)
        end

        return TabObj
    end

    function WindowObj:Notify(notifConfig)
        notifConfig = notifConfig or {}
        local title = notifConfig.Title or "Notification"
        local desc  = notifConfig.Content or notifConfig.Description or ""
        local dur   = notifConfig.Duration or 3

        local NotifHolder = RootGui:FindFirstChild("NotifHolder")
        if not NotifHolder then
            NotifHolder = Instance.new("Frame")
            NotifHolder.Name = "NotifHolder"
            NotifHolder.Size = UDim2.new(0, 280, 1, -20)
            NotifHolder.Position = UDim2.new(1, -290, 0, 10)
            NotifHolder.BackgroundTransparency = 1
            NotifHolder.ZIndex = 50
            NotifHolder.Parent = RootGui

            local nLayout = Instance.new("UIListLayout")
            nLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            nLayout.SortOrder = Enum.SortOrder.LayoutOrder
            nLayout.Padding = UDim.new(0, 8)
            nLayout.Parent = NotifHolder
        end

        local Box = Instance.new("Frame")
        Box.Size = UDim2.new(1, 0, 0, 56)
        Box.BackgroundColor3 = VRSLibV2.Theme.Card
        Box.Position = UDim2.new(1, 40, 0, 0)
        Box.BorderSizePixel = 0
        Box.ZIndex = 51
        Box.Parent = NotifHolder

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 10)
        bCorner.Parent = Box

        local bStroke = Instance.new("UIStroke")
        bStroke.Color = VRSLibV2.Theme.CardStroke
        bStroke.Thickness = 1
        bStroke.Parent = Box

        local nTitle = Instance.new("TextLabel")
        nTitle.Size = UDim2.new(1, -16, 0, 18)
        nTitle.Position = UDim2.new(0, 12, 0, 8)
        nTitle.BackgroundTransparency = 1
        nTitle.Font = Enum.Font.GothamBold
        nTitle.TextSize = 13
        nTitle.TextColor3 = VRSLibV2.Theme.TextPrimary
        nTitle.TextXAlignment = Enum.TextXAlignment.Left
        nTitle.Text = title
        nTitle.ZIndex = 52
        nTitle.Parent = Box

        local nDesc = Instance.new("TextLabel")
        nDesc.Size = UDim2.new(1, -16, 0, 16)
        nDesc.Position = UDim2.new(0, 12, 0, 28)
        nDesc.BackgroundTransparency = 1
        nDesc.Font = Enum.Font.Gotham
        nDesc.TextSize = 11
        nDesc.TextColor3 = VRSLibV2.Theme.TextSecondary
        nDesc.TextXAlignment = Enum.TextXAlignment.Left
        nDesc.Text = desc
        nDesc.ZIndex = 52
        nDesc.Parent = Box

        QuickTween(Box, { Position = UDim2.new(0, 0, 0, 0) }, 0.25)
        task.delay(dur, function()
            local tw = QuickTween(Box, { Position = UDim2.new(1, 40, 0, 0) }, 0.25)
            tw.Completed:Connect(function() Box:Destroy() end)
        end)
    end

    table.insert(VRSLibV2.Windows, WindowObj)
    VRSLibV2.ActiveWindow = WindowObj
    return WindowObj
end

-- ==============================================================================
-- 3. COMPONENT FACTORY & MULTI-COLUMN LAYOUTS
-- ==============================================================================
function VRSLibV2:_AttachComponentFactory(targetObj, container)
    local Theme = VRSLibV2.Theme

    -- Multi-Column Layout (Matching Settings tab 2 columns)
    function targetObj:AddColumns()
        local ColGrid = Instance.new("Frame")
        ColGrid.Name = "ColumnGrid"
        ColGrid.Size = UDim2.new(1, 0, 0, 0)
        ColGrid.AutomaticSize = Enum.AutomaticSize.Y
        ColGrid.BackgroundTransparency = 1
        ColGrid.ZIndex = 3
        ColGrid.Parent = container

        local gLayout = Instance.new("UIListLayout")
        gLayout.FillDirection = Enum.FillDirection.Horizontal
        gLayout.SortOrder = Enum.SortOrder.LayoutOrder
        gLayout.Padding = UDim.new(0, 10)
        gLayout.Parent = ColGrid

        local function MakeCol(name)
            local Col = Instance.new("Frame")
            Col.Name = name
            Col.Size = UDim2.new(0.5, -5, 0, 0)
            Col.AutomaticSize = Enum.AutomaticSize.Y
            Col.BackgroundTransparency = 1
            Col.ZIndex = 3
            Col.Parent = ColGrid

            local cLayout = Instance.new("UIListLayout")
            cLayout.SortOrder = Enum.SortOrder.LayoutOrder
            cLayout.Padding = UDim.new(0, 10)
            cLayout.Parent = Col

            local ColObj = { Frame = Col }
            VRSLibV2:_AttachComponentFactory(ColObj, Col)
            return ColObj
        end

        local LeftCol  = MakeCol("LeftCol")
        local RightCol = MakeCol("RightCol")
        return LeftCol, RightCol
    end

    -- Profile / Hero Card
    function targetObj:AddProfileCard(cfg)
        cfg = cfg or {}
        local nameText = cfg.Name or (LocalPlayer.DisplayName or LocalPlayer.Name)
        local userText = cfg.Username or ("@" .. LocalPlayer.Name)
        local badgeVer = cfg.Badge or "v0.167"

        local Card = Instance.new("Frame")
        Card.Name = "ProfileCard"
        Card.Size = UDim2.new(1, 0, 0, 94)
        Card.BackgroundColor3 = Theme.Card
        Card.BorderSizePixel = 0
        Card.ZIndex = 3
        Card.Parent = container

        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(0, 12)
        cCorner.Parent = Card

        local cStroke = Instance.new("UIStroke")
        cStroke.Color = Theme.CardStroke
        cStroke.Thickness = 1
        cStroke.Parent = Card

        local AvFrame = Instance.new("Frame")
        AvFrame.Size = UDim2.fromOffset(58, 58)
        AvFrame.Position = UDim2.new(0, 16, 0.5, -29)
        AvFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 25)
        AvFrame.BorderSizePixel = 0
        AvFrame.ZIndex = 4
        AvFrame.Parent = Card

        local avCorner = Instance.new("UICorner")
        avCorner.CornerRadius = UDim.new(1, 0)
        avCorner.Parent = AvFrame

        local avStroke = Instance.new("UIStroke")
        avStroke.Color = Color3.fromRGB(48, 52, 66)
        avStroke.Thickness = 1.5
        avStroke.Parent = AvFrame

        local AvImg = Instance.new("ImageLabel")
        AvImg.Size = UDim2.new(1, 0, 1, 0)
        AvImg.BackgroundTransparency = 1
        AvImg.ZIndex = 4
        AvImg.Parent = AvFrame

        local avImgCorner = Instance.new("UICorner")
        avImgCorner.CornerRadius = UDim.new(1, 0)
        avImgCorner.Parent = AvImg

        task.spawn(function()
            pcall(function()
                AvImg.Image = Players:GetUserThumbnailAsync(
                    LocalPlayer.UserId,
                    Enum.ThumbnailType.HeadShot,
                    Enum.ThumbnailSize.Size150x150
                )
            end)
        end)

        local WelcomeLbl = Instance.new("TextLabel")
        WelcomeLbl.Size = UDim2.new(0, 200, 0, 14)
        WelcomeLbl.Position = UDim2.new(0, 86, 0, 16)
        WelcomeLbl.BackgroundTransparency = 1
        WelcomeLbl.Font = Enum.Font.Gotham
        WelcomeLbl.TextSize = 11
        WelcomeLbl.TextColor3 = Theme.TextMuted
        WelcomeLbl.TextXAlignment = Enum.TextXAlignment.Left
        WelcomeLbl.Text = "Welcome back,"
        WelcomeLbl.ZIndex = 4
        WelcomeLbl.Parent = Card

        local NameLbl = Instance.new("TextLabel")
        NameLbl.Size = UDim2.new(0, 300, 0, 22)
        NameLbl.Position = UDim2.new(0, 86, 0, 30)
        NameLbl.BackgroundTransparency = 1
        NameLbl.Font = Enum.Font.GothamBold
        NameLbl.TextSize = 18
        NameLbl.TextColor3 = Theme.TextPrimary
        NameLbl.TextXAlignment = Enum.TextXAlignment.Left
        NameLbl.Text = nameText
        NameLbl.ZIndex = 4
        NameLbl.Parent = Card

        local UserLbl = Instance.new("TextLabel")
        UserLbl.Size = UDim2.new(0, 200, 0, 14)
        UserLbl.Position = UDim2.new(0, 86, 0, 54)
        UserLbl.BackgroundTransparency = 1
        UserLbl.Font = Enum.Font.Gotham
        UserLbl.TextSize = 11
        UserLbl.TextColor3 = Theme.TextSecondary
        UserLbl.TextXAlignment = Enum.TextXAlignment.Left
        UserLbl.Text = userText
        UserLbl.ZIndex = 4
        UserLbl.Parent = Card

        local Badge = Instance.new("Frame")
        Badge.Size = UDim2.fromOffset(78, 26)
        Badge.Position = UDim2.new(1, -94, 0, 16)
        Badge.BackgroundColor3 = Color3.fromRGB(32, 34, 44)
        Badge.BorderSizePixel = 0
        Badge.ZIndex = 4
        Badge.Parent = Card

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 6)
        bCorner.Parent = Badge

        local bStroke = Instance.new("UIStroke")
        bStroke.Color = Color3.fromRGB(48, 52, 68)
        bStroke.Thickness = 1
        bStroke.Parent = Badge

        local bIcon = Instance.new("ImageLabel")
        bIcon.Size = UDim2.fromOffset(13, 13)
        bIcon.Position = UDim2.new(0, 8, 0.5, -6)
        bIcon.BackgroundTransparency = 1
        bIcon.Image = VRSLibV2.Icons.Get("gear")
        bIcon.ImageColor3 = Theme.TextSecondary
        bIcon.ZIndex = 5
        bIcon.Parent = Badge

        local bText = Instance.new("TextLabel")
        bText.Size = UDim2.new(1, -26, 1, 0)
        bText.Position = UDim2.new(0, 24, 0, 0)
        bText.BackgroundTransparency = 1
        bText.Font = Enum.Font.GothamBold
        bText.TextSize = 11
        bText.TextColor3 = Theme.TextPrimary
        bText.TextXAlignment = Enum.TextXAlignment.Left
        bText.Text = badgeVer
        bText.ZIndex = 5
        bText.Parent = Badge

        return Card
    end

    -- Stat Row (6 cards)
    function targetObj:AddStatRow(statsList)
        statsList = statsList or {}
        local Row = Instance.new("Frame")
        Row.Name = "StatRow"
        Row.Size = UDim2.new(1, 0, 0, 62)
        Row.BackgroundTransparency = 1
        Row.ZIndex = 3
        Row.Parent = container

        local rLayout = Instance.new("UIListLayout")
        rLayout.FillDirection = Enum.FillDirection.Horizontal
        rLayout.SortOrder = Enum.SortOrder.LayoutOrder
        rLayout.Padding = UDim.new(0, 8)
        rLayout.Parent = Row

        local count = #statsList
        local statControllers = {}

        for _, s in ipairs(statsList) do
            local title = s.Title or s.Name or "Stat"
            local val   = s.Value or "0"
            local icon  = s.Icon or "activity"

            local Card = Instance.new("Frame")
            Card.Name = "Stat_" .. title
            Card.Size = UDim2.new(1 / count, -((count - 1) * 8) / count, 1, 0)
            Card.BackgroundColor3 = Theme.Card
            Card.BorderSizePixel = 0
            Card.ZIndex = 3
            Card.Parent = Row

            local cCorner = Instance.new("UICorner")
            cCorner.CornerRadius = UDim.new(0, 10)
            cCorner.Parent = Card

            local cStroke = Instance.new("UIStroke")
            cStroke.Color = Theme.CardStroke
            cStroke.Thickness = 1
            cStroke.Parent = Card

            local IconImg = Instance.new("ImageLabel")
            IconImg.Size = UDim2.fromOffset(14, 14)
            IconImg.Position = UDim2.new(0, 12, 0, 12)
            IconImg.BackgroundTransparency = 1
            IconImg.Image = VRSLibV2.Icons.Get(icon)
            IconImg.ImageColor3 = Theme.TextMuted
            IconImg.ZIndex = 4
            IconImg.Parent = Card

            local TitleLbl = Instance.new("TextLabel")
            TitleLbl.Size = UDim2.new(1, -34, 0, 14)
            TitleLbl.Position = UDim2.new(0, 32, 0, 12)
            TitleLbl.BackgroundTransparency = 1
            TitleLbl.Font = Enum.Font.Gotham
            TitleLbl.TextSize = 10
            TitleLbl.TextColor3 = Theme.TextMuted
            TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
            TitleLbl.Text = title
            TitleLbl.ZIndex = 4
            TitleLbl.Parent = Card

            local ValLbl = Instance.new("TextLabel")
            ValLbl.Size = UDim2.new(1, -24, 0, 20)
            ValLbl.Position = UDim2.new(0, 12, 0, 32)
            ValLbl.BackgroundTransparency = 1
            ValLbl.Font = Enum.Font.GothamBold
            ValLbl.TextSize = 15
            ValLbl.TextColor3 = Theme.TextPrimary
            ValLbl.TextXAlignment = Enum.TextXAlignment.Left
            ValLbl.Text = val
            ValLbl.ZIndex = 4
            ValLbl.Parent = Card

            statControllers[title] = {
                UpdateValue = function(newVal) ValLbl.Text = tostring(newVal) end
            }
        end
        return statControllers
    end

    -- Warning Banner
    function targetObj:AddBanner(cfg)
        cfg = cfg or {}
        local title = cfg.Title or "Notice"
        local desc  = cfg.Message or cfg.Content or ""
        local icon  = cfg.Icon or "shield"
        local badge = cfg.Badge or "Notice"

        local Banner = Instance.new("Frame")
        Banner.Name = "Banner"
        Banner.Size = UDim2.new(1, 0, 0, 54)
        Banner.BackgroundColor3 = Theme.Card
        Banner.BorderSizePixel = 0
        Banner.ZIndex = 3
        Banner.Parent = container

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 10)
        bCorner.Parent = Banner

        local bStroke = Instance.new("UIStroke")
        bStroke.Color = Theme.CardStroke
        bStroke.Thickness = 1
        bStroke.Parent = Banner

        local IconImg = Instance.new("ImageLabel")
        IconImg.Size = UDim2.fromOffset(18, 18)
        IconImg.Position = UDim2.new(0, 14, 0.5, -9)
        IconImg.BackgroundTransparency = 1
        IconImg.Image = VRSLibV2.Icons.Get(icon)
        IconImg.ImageColor3 = Theme.WarningBadge
        IconImg.ZIndex = 4
        IconImg.Parent = Banner

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Size = UDim2.new(1, -140, 0, 16)
        TitleLbl.Position = UDim2.new(0, 42, 0, 10)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.TextSize = 12
        TitleLbl.TextColor3 = Theme.WarningBadge
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.Text = title
        TitleLbl.ZIndex = 4
        TitleLbl.Parent = Banner

        local DescLbl = Instance.new("TextLabel")
        DescLbl.Size = UDim2.new(1, -140, 0, 14)
        DescLbl.Position = UDim2.new(0, 42, 0, 28)
        DescLbl.BackgroundTransparency = 1
        DescLbl.Font = Enum.Font.Gotham
        DescLbl.TextSize = 10
        DescLbl.TextColor3 = Theme.TextSecondary
        DescLbl.TextXAlignment = Enum.TextXAlignment.Left
        DescLbl.Text = desc
        DescLbl.ZIndex = 4
        DescLbl.Parent = Banner

        if badge and badge ~= "" then
            local BadgePill = Instance.new("Frame")
            BadgePill.Size = UDim2.fromOffset(80, 24)
            BadgePill.Position = UDim2.new(1, -94, 0.5, -12)
            BadgePill.BackgroundColor3 = Color3.fromRGB(32, 34, 44)
            BadgePill.BorderSizePixel = 0
            BadgePill.ZIndex = 4
            BadgePill.Parent = Banner

            local bpCorner = Instance.new("UICorner")
            bpCorner.CornerRadius = UDim.new(0, 6)
            bpCorner.Parent = BadgePill

            local bpText = Instance.new("TextLabel")
            bpText.Size = UDim2.new(1, 0, 1, 0)
            bpText.BackgroundTransparency = 1
            bpText.Font = Enum.Font.GothamMedium
            bpText.TextSize = 10
            bpText.TextColor3 = Theme.TextSecondary
            bpText.Text = badge
            bpText.ZIndex = 5
            bpText.Parent = BadgePill
        end
        return Banner
    end

    -- Groupbox Container
    function targetObj:AddGroupbox(gbConfig)
        if type(gbConfig) == "string" then gbConfig = { Title = gbConfig } end
        gbConfig = gbConfig or {}

        local gbTitle = gbConfig.Title or "Section"
        local gbIcon  = gbConfig.Icon or "box"

        local GroupCard = Instance.new("Frame")
        GroupCard.Name = "Groupbox_" .. gbTitle
        GroupCard.Size = UDim2.new(1, 0, 0, 0)
        GroupCard.AutomaticSize = Enum.AutomaticSize.Y
        GroupCard.BackgroundColor3 = Theme.Card
        GroupCard.BorderSizePixel = 0
        GroupCard.ZIndex = 3
        GroupCard.Parent = container

        local gcCorner = Instance.new("UICorner")
        gcCorner.CornerRadius = UDim.new(0, 10)
        gcCorner.Parent = GroupCard

        local gcStroke = Instance.new("UIStroke")
        gcStroke.Color = Theme.CardStroke
        gcStroke.Thickness = 1
        gcStroke.Parent = GroupCard

        local Header = Instance.new("Frame")
        Header.Name = "Header"
        Header.Size = UDim2.new(1, 0, 0, 34)
        Header.BackgroundTransparency = 1
        Header.ZIndex = 4
        Header.Parent = GroupCard

        local hTitle = Instance.new("TextLabel")
        hTitle.Size = UDim2.new(1, -60, 1, 0)
        hTitle.Position = UDim2.new(0, 14, 0, 0)
        hTitle.BackgroundTransparency = 1
        hTitle.Font = Enum.Font.GothamBold
        hTitle.TextSize = 12
        hTitle.TextColor3 = Theme.TextPrimary
        hTitle.TextXAlignment = Enum.TextXAlignment.Left
        hTitle.Text = gbTitle
        hTitle.ZIndex = 4
        hTitle.Parent = Header

        local hDash = Instance.new("TextButton")
        hDash.Name = "CollapseBtn"
        hDash.Size = UDim2.fromOffset(20, 20)
        hDash.Position = UDim2.new(1, -54, 0.5, -10)
        hDash.BackgroundTransparency = 1
        hDash.Font = Enum.Font.GothamBold
        hDash.TextSize = 14
        hDash.TextColor3 = Theme.TextMuted
        hDash.Text = "-"
        hDash.ZIndex = 5
        hDash.Parent = Header

        local hIcon = Instance.new("ImageLabel")
        hIcon.Size = UDim2.fromOffset(14, 14)
        hIcon.Position = UDim2.new(1, -28, 0.5, -7)
        hIcon.BackgroundTransparency = 1
        hIcon.Image = VRSLibV2.Icons.Get(gbIcon)
        hIcon.ImageColor3 = Theme.TextMuted
        hIcon.ZIndex = 5
        hIcon.Parent = Header

        local ItemContainer = Instance.new("Frame")
        ItemContainer.Name = "Items"
        ItemContainer.Size = UDim2.new(1, -28, 0, 0)
        ItemContainer.Position = UDim2.new(0, 14, 0, 36)
        ItemContainer.AutomaticSize = Enum.AutomaticSize.Y
        ItemContainer.BackgroundTransparency = 1
        ItemContainer.ZIndex = 3
        ItemContainer.Parent = GroupCard

        local iLayout = Instance.new("UIListLayout")
        iLayout.SortOrder = Enum.SortOrder.LayoutOrder
        iLayout.Padding = UDim.new(0, 8)
        iLayout.Parent = ItemContainer

        local iPad = Instance.new("UIPadding")
        iPad.PaddingBottom = UDim.new(0, 12)
        iPad.Parent = ItemContainer

        local isCollapsed = false
        hDash.MouseButton1Click:Connect(function()
            isCollapsed = not isCollapsed
            ItemContainer.Visible = not isCollapsed
            hDash.Text = isCollapsed and "+" or "-"
        end)

        local GroupObj = {
            Card = GroupCard,
            ItemContainer = ItemContainer
        }
        VRSLibV2:_AttachComponentFactory(GroupObj, ItemContainer)
        return GroupObj
    end

    -- Toggle Switch
    function targetObj:AddToggle(toggleConfig)
        toggleConfig = toggleConfig or {}
        local name     = toggleConfig.Name or "Toggle"
        local state    = toggleConfig.Default or false
        local callback = toggleConfig.Callback or function() end

        local Row = Instance.new("Frame")
        Row.Name = "Toggle_" .. name
        Row.Size = UDim2.new(1, 0, 0, 34)
        Row.BackgroundColor3 = Color3.fromRGB(20, 21, 28)
        Row.BorderSizePixel = 0
        Row.ZIndex = 3
        Row.Parent = container

        local rCorner = Instance.new("UICorner")
        rCorner.CornerRadius = UDim.new(0, 8)
        rCorner.Parent = Row

        local rStroke = Instance.new("UIStroke")
        rStroke.Color = Color3.fromRGB(34, 36, 48)
        rStroke.Thickness = 1
        rStroke.Parent = Row

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -56, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 11
        Label.TextColor3 = Theme.TextPrimary
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = name
        Label.ZIndex = 4
        Label.Parent = Row

        local Switch = Instance.new("TextButton")
        Switch.Name = "Switch"
        Switch.Size = UDim2.fromOffset(36, 20)
        Switch.Position = UDim2.new(1, -46, 0.5, -10)
        Switch.BackgroundColor3 = state and Theme.SwitchOn or Theme.SwitchOff
        Switch.Text = ""
        Switch.AutoButtonColor = false
        Switch.ZIndex = 4
        Switch.Parent = Row

        local swCorner = Instance.new("UICorner")
        swCorner.CornerRadius = UDim.new(1, 0)
        swCorner.Parent = Switch

        local Knob = Instance.new("Frame")
        Knob.Name = "Knob"
        Knob.Size = UDim2.fromOffset(14, 14)
        Knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        Knob.BackgroundColor3 = state and Theme.SwitchOnKnob or Theme.SwitchOffKnob
        Knob.BorderSizePixel = 0
        Knob.ZIndex = 5
        Knob.Parent = Switch

        local knCorner = Instance.new("UICorner")
        knCorner.CornerRadius = UDim.new(1, 0)
        knCorner.Parent = Knob

        local function UpdateState(val, fireCallback)
            state = val
            local targetPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            local targetBg  = state and Theme.SwitchOn or Theme.SwitchOff
            local targetKn  = state and Theme.SwitchOnKnob or Theme.SwitchOffKnob

            QuickTween(Switch, { BackgroundColor3 = targetBg }, 0.18)
            QuickTween(Knob, { Position = targetPos, BackgroundColor3 = targetKn }, 0.18)

            if fireCallback then
                task.spawn(function() pcall(callback, state) end)
            end
        end

        Switch.MouseButton1Click:Connect(function() UpdateState(not state, true) end)
        Row.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                UpdateState(not state, true)
            end
        end)

        return {
            SetValue = function(self, val) UpdateState(val, true) end,
            GetValue = function() return state end
        }
    end

    -- Slider with Value Badge
    function targetObj:AddSlider(sliderConfig)
        sliderConfig = sliderConfig or {}
        local name     = sliderConfig.Name or "Slider"
        local minVal   = sliderConfig.Min or 0
        local maxVal   = sliderConfig.Max or 100
        local default  = sliderConfig.Default or minVal
        local step     = sliderConfig.Step or 1
        local suffix   = sliderConfig.Suffix or ""
        local callback = sliderConfig.Callback or function() end

        local currentVal = math.clamp(default, minVal, maxVal)

        local Row = Instance.new("Frame")
        Row.Name = "Slider_" .. name
        Row.Size = UDim2.new(1, 0, 0, 48)
        Row.BackgroundColor3 = Color3.fromRGB(20, 21, 28)
        Row.BorderSizePixel = 0
        Row.ZIndex = 3
        Row.Parent = container

        local rCorner = Instance.new("UICorner")
        rCorner.CornerRadius = UDim.new(0, 8)
        rCorner.Parent = Row

        local rStroke = Instance.new("UIStroke")
        rStroke.Color = Color3.fromRGB(34, 36, 48)
        rStroke.Thickness = 1
        rStroke.Parent = Row

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -70, 0, 18)
        Label.Position = UDim2.new(0, 12, 0, 6)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 11
        Label.TextColor3 = Theme.TextPrimary
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = name
        Label.ZIndex = 4
        Label.Parent = Row

        local ValBadge = Instance.new("Frame")
        ValBadge.Size = UDim2.fromOffset(48, 18)
        ValBadge.Position = UDim2.new(1, -58, 0, 6)
        ValBadge.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
        ValBadge.BorderSizePixel = 0
        ValBadge.ZIndex = 4
        ValBadge.Parent = Row

        local vbCorner = Instance.new("UICorner")
        vbCorner.CornerRadius = UDim.new(0, 4)
        vbCorner.Parent = ValBadge

        local ValLabel = Instance.new("TextLabel")
        ValLabel.Size = UDim2.new(1, 0, 1, 0)
        ValLabel.BackgroundTransparency = 1
        ValLabel.Font = Enum.Font.GothamBold
        ValLabel.TextSize = 10
        ValLabel.TextColor3 = Theme.Accent
        ValLabel.Text = tostring(currentVal) .. suffix
        ValLabel.ZIndex = 5
        ValLabel.Parent = ValBadge

        local Track = Instance.new("Frame")
        Track.Name = "Track"
        Track.Size = UDim2.new(1, -24, 0, 6)
        Track.Position = UDim2.new(0, 12, 0, 32)
        Track.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
        Track.BorderSizePixel = 0
        Track.ZIndex = 4
        Track.Parent = Row

        local trCorner = Instance.new("UICorner")
        trCorner.CornerRadius = UDim.new(1, 0)
        trCorner.Parent = Track

        local Fill = Instance.new("Frame")
        Fill.Name = "Fill"
        Fill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
        Fill.BackgroundColor3 = Theme.Accent
        Fill.BorderSizePixel = 0
        Fill.ZIndex = 4
        Fill.Parent = Track

        local fCorner = Instance.new("UICorner")
        fCorner.CornerRadius = UDim.new(1, 0)
        fCorner.Parent = Fill

        local Knob = Instance.new("Frame")
        Knob.Name = "Knob"
        Knob.Size = UDim2.fromOffset(12, 12)
        Knob.Position = UDim2.new(1, -6, 0.5, -6)
        Knob.BackgroundColor3 = Theme.Accent
        Knob.BorderSizePixel = 0
        Knob.ZIndex = 5
        Knob.Parent = Fill

        local knCorner = Instance.new("UICorner")
        knCorner.CornerRadius = UDim.new(1, 0)
        knCorner.Parent = Knob

        local isDragging = false
        local function SetVal(val, fire)
            currentVal = math.clamp(math.round((val - minVal) / step) * step + minVal, minVal, maxVal)
            local pct = (currentVal - minVal) / (maxVal - minVal)
            Fill.Size = UDim2.new(pct, 0, 1, 0)
            ValLabel.Text = tostring(currentVal) .. suffix

            if fire then
                task.spawn(function() pcall(callback, currentVal) end)
            end
        end

        local function UpdateFromInput(input)
            local barPos = Track.AbsolutePosition.X
            local barWidth = Track.AbsoluteSize.X
            local mouseX = input.Position.X
            local pct = math.clamp((mouseX - barPos) / barWidth, 0, 1)
            SetVal(minVal + (maxVal - minVal) * pct, true)
        end

        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                UpdateFromInput(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateFromInput(input)
            end
        end)

        return {
            SetValue = function(self, val) SetVal(val, true) end,
            GetValue = function() return currentVal end
        }
    end

    -- Inline Drop Bar (Dropdown)
    function targetObj:AddDropdown(ddConfig)
        ddConfig = ddConfig or {}
        local name     = ddConfig.Name or "Dropdown"
        local items    = ddConfig.Items or ddConfig.Options or {}
        local multi    = ddConfig.Multi or false
        local default  = ddConfig.Default or (items[1] or "Select...")
        local callback = ddConfig.Callback or function() end

        local selected = multi and (type(default) == "table" and default or { default }) or default

        local Row = Instance.new("Frame")
        Row.Name = "Dropdown_" .. name
        Row.Size = UDim2.new(1, 0, 0, 36)
        Row.BackgroundColor3 = Color3.fromRGB(20, 21, 28)
        Row.BorderSizePixel = 0
        Row.ClipsDescendants = false
        Row.ZIndex = 4
        Row.Parent = container

        local rCorner = Instance.new("UICorner")
        rCorner.CornerRadius = UDim.new(0, 8)
        rCorner.Parent = Row

        local rStroke = Instance.new("UIStroke")
        rStroke.Color = Color3.fromRGB(34, 36, 48)
        rStroke.Thickness = 1
        rStroke.Parent = Row

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.5, 0, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 11
        Label.TextColor3 = Theme.TextPrimary
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = name
        Label.ZIndex = 4
        Label.Parent = Row

        local Trigger = Instance.new("TextButton")
        Trigger.Name = "Trigger"
        Trigger.Size = UDim2.new(0.48, -12, 0, 24)
        Trigger.Position = UDim2.new(0.52, 0, 0.5, -12)
        Trigger.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
        Trigger.Text = ""
        Trigger.AutoButtonColor = false
        Trigger.ZIndex = 4
        Trigger.Parent = Row

        local tCorner = Instance.new("UICorner")
        tCorner.CornerRadius = UDim.new(0, 6)
        tCorner.Parent = Trigger

        local tStroke = Instance.new("UIStroke")
        tStroke.Color = Color3.fromRGB(44, 47, 60)
        tStroke.Thickness = 1
        tStroke.Parent = Trigger

        local function GetDisplayString()
            if multi then
                local str = table.concat(selected, ", ")
                return str == "" and "None" or str
            end
            return tostring(selected)
        end

        local SelectedLbl = Instance.new("TextLabel")
        SelectedLbl.Size = UDim2.new(1, -26, 1, 0)
        SelectedLbl.Position = UDim2.new(0, 8, 0, 0)
        SelectedLbl.BackgroundTransparency = 1
        SelectedLbl.Font = Enum.Font.GothamMedium
        SelectedLbl.TextSize = 10
        SelectedLbl.TextColor3 = Theme.Accent
        SelectedLbl.TextXAlignment = Enum.TextXAlignment.Left
        SelectedLbl.TextTruncate = Enum.TextTruncate.AtEnd
        SelectedLbl.Text = GetDisplayString()
        SelectedLbl.ZIndex = 5
        SelectedLbl.Parent = Trigger

        local Chevron = Instance.new("ImageLabel")
        Chevron.Size = UDim2.fromOffset(12, 12)
        Chevron.Position = UDim2.new(1, -18, 0.5, -6)
        Chevron.BackgroundTransparency = 1
        Chevron.Image = VRSLibV2.Icons.Get("chevron-down")
        Chevron.ImageColor3 = Theme.TextSecondary
        Chevron.ZIndex = 5
        Chevron.Parent = Trigger

        local Menu = Instance.new("ScrollingFrame")
        Menu.Name = "Menu"
        Menu.Size = UDim2.new(1, 0, 0, 0)
        Menu.Position = UDim2.new(0, 0, 1, 4)
        Menu.BackgroundColor3 = Color3.fromRGB(24, 25, 33)
        Menu.BorderSizePixel = 0
        Menu.ZIndex = 50
        Menu.ScrollBarThickness = 2
        Menu.ScrollBarImageColor3 = Color3.fromRGB(50, 53, 68)
        Menu.Visible = false
        Menu.Parent = Trigger

        local mCorner = Instance.new("UICorner")
        mCorner.CornerRadius = UDim.new(0, 6)
        mCorner.Parent = Menu

        local mStroke = Instance.new("UIStroke")
        mStroke.Color = Color3.fromRGB(48, 52, 66)
        mStroke.Thickness = 1
        mStroke.Parent = Menu

        local mLayout = Instance.new("UIListLayout")
        mLayout.SortOrder = Enum.SortOrder.LayoutOrder
        mLayout.Padding = UDim.new(0, 2)
        mLayout.Parent = Menu

        local mPad = Instance.new("UIPadding")
        mPad.PaddingTop = UDim.new(0, 4)
        mPad.PaddingBottom = UDim.new(0, 4)
        mPad.PaddingLeft = UDim.new(0, 4)
        mPad.PaddingRight = UDim.new(0, 4)
        mPad.Parent = Menu

        local isOpen = false
        local function PopulateItems()
            for _, c in ipairs(Menu:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end

            for _, opt in ipairs(items) do
                local optStr = tostring(opt)
                local ItemBtn = Instance.new("TextButton")
                ItemBtn.Size = UDim2.new(1, 0, 0, 22)
                ItemBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
                ItemBtn.BackgroundTransparency = 1
                ItemBtn.Text = ""
                ItemBtn.AutoButtonColor = false
                ItemBtn.ZIndex = 51
                ItemBtn.Parent = Menu

                local ibCorner = Instance.new("UICorner")
                ibCorner.CornerRadius = UDim.new(0, 4)
                ibCorner.Parent = ItemBtn

                local ibText = Instance.new("TextLabel")
                ibText.Size = UDim2.new(1, -12, 1, 0)
                ibText.Position = UDim2.new(0, 6, 0, 0)
                ibText.BackgroundTransparency = 1
                ibText.Font = Enum.Font.GothamMedium
                ibText.TextSize = 10
                ibText.TextColor3 = Theme.TextSecondary
                ibText.TextXAlignment = Enum.TextXAlignment.Left
                ibText.Text = optStr
                ibText.ZIndex = 52
                ibText.Parent = ItemBtn

                local isPicked = multi and (table.find(selected, optStr) ~= nil) or (selected == optStr)
                if isPicked then
                    ItemBtn.BackgroundTransparency = 0
                    ibText.TextColor3 = Theme.Accent
                end

                ItemBtn.MouseButton1Click:Connect(function()
                    if multi then
                        local idx = table.find(selected, optStr)
                        if idx then table.remove(selected, idx) else table.insert(selected, optStr) end
                        SelectedLbl.Text = GetDisplayString()
                        PopulateItems()
                        task.spawn(function() pcall(callback, selected) end)
                    else
                        selected = optStr
                        SelectedLbl.Text = GetDisplayString()
                        isOpen = false
                        Menu.Visible = false
                        QuickTween(Chevron, { Rotation = 0 }, 0.15)
                        task.spawn(function() pcall(callback, selected) end)
                    end
                end)
            end

            local totalH = math.min(#items * 24 + 8, 120)
            Menu.Size = UDim2.new(1, 0, 0, totalH)
            Menu.CanvasSize = UDim2.new(0, 0, 0, #items * 24 + 8)
        end

        Trigger.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            if isOpen then
                PopulateItems()
                Menu.Visible = true
                QuickTween(Chevron, { Rotation = 180 }, 0.15)
            else
                Menu.Visible = false
                QuickTween(Chevron, { Rotation = 0 }, 0.15)
            end
        end)

        return {
            SetValue = function(self, val)
                selected = val
                SelectedLbl.Text = GetDisplayString()
                task.spawn(function() pcall(callback, selected) end)
            end,
            Refresh = function(self, newItems)
                items = newItems or {}
                PopulateItems()
            end,
            GetValue = function() return selected end
        }
    end

    -- Input Box (TextBox)
    function targetObj:AddInput(inputConfig)
        inputConfig = inputConfig or {}
        local name        = inputConfig.Name or "Input"
        local placeholder = inputConfig.Placeholder or "Type here..."
        local default     = inputConfig.Default or ""
        local callback    = inputConfig.Callback or function() end

        local Row = Instance.new("Frame")
        Row.Name = "Input_" .. name
        Row.Size = UDim2.new(1, 0, 0, 36)
        Row.BackgroundColor3 = Color3.fromRGB(20, 21, 28)
        Row.BorderSizePixel = 0
        Row.ZIndex = 3
        Row.Parent = container

        local rCorner = Instance.new("UICorner")
        rCorner.CornerRadius = UDim.new(0, 8)
        rCorner.Parent = Row

        local rStroke = Instance.new("UIStroke")
        rStroke.Color = Color3.fromRGB(34, 36, 48)
        rStroke.Thickness = 1
        rStroke.Parent = Row

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.45, 0, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 11
        Label.TextColor3 = Theme.TextPrimary
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = name
        Label.ZIndex = 4
        Label.Parent = Row

        local BoxFrame = Instance.new("Frame")
        BoxFrame.Size = UDim2.new(0.53, -12, 0, 24)
        BoxFrame.Position = UDim2.new(0.47, 0, 0.5, -12)
        BoxFrame.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
        BoxFrame.BorderSizePixel = 0
        BoxFrame.ZIndex = 4
        BoxFrame.Parent = Row

        local bfCorner = Instance.new("UICorner")
        bfCorner.CornerRadius = UDim.new(0, 6)
        bfCorner.Parent = BoxFrame

        local bfStroke = Instance.new("UIStroke")
        bfStroke.Color = Color3.fromRGB(44, 47, 60)
        bfStroke.Thickness = 1
        bfStroke.Parent = BoxFrame

        local TBox = Instance.new("TextBox")
        TBox.Size = UDim2.new(1, -12, 1, 0)
        TBox.Position = UDim2.new(0, 6, 0, 0)
        TBox.BackgroundTransparency = 1
        TBox.Font = Enum.Font.Gotham
        TBox.TextSize = 10
        TBox.TextColor3 = Theme.TextPrimary
        TBox.PlaceholderColor3 = Theme.TextMuted
        TBox.PlaceholderText = placeholder
        TBox.Text = default
        TBox.ClearTextOnFocus = false
        TBox.TextXAlignment = Enum.TextXAlignment.Left
        TBox.ZIndex = 5
        TBox.Parent = BoxFrame

        TBox.Focused:Connect(function() QuickTween(bfStroke, { Color = Theme.Accent }, 0.15) end)
        TBox.FocusLost:Connect(function(enterPressed)
            QuickTween(bfStroke, { Color = Color3.fromRGB(44, 47, 60) }, 0.15)
            task.spawn(function() pcall(callback, TBox.Text, enterPressed) end)
        end)

        return {
            SetValue = function(self, val) TBox.Text = tostring(val) end,
            GetValue = function() return TBox.Text end
        }
    end

    -- Action Button
    function targetObj:AddButton(btnConfig)
        btnConfig = btnConfig or {}
        local name     = btnConfig.Name or btnConfig.Text or "Button"
        local callback = btnConfig.Callback or function() end

        local Btn = Instance.new("TextButton")
        Btn.Name = "Button_" .. name
        Btn.Size = UDim2.new(1, 0, 0, 32)
        Btn.BackgroundColor3 = Theme.ActionBtn
        Btn.Text = name
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 11
        Btn.TextColor3 = Theme.TextPrimary
        Btn.AutoButtonColor = false
        Btn.ZIndex = 4
        Btn.Parent = container

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 8)
        bCorner.Parent = Btn

        local bStroke = Instance.new("UIStroke")
        bStroke.Color = Theme.CardStroke
        bStroke.Thickness = 1
        bStroke.Parent = Btn

        Btn.MouseEnter:Connect(function() QuickTween(Btn, { BackgroundColor3 = Theme.ActionBtnHover }, 0.15) end)
        Btn.MouseLeave:Connect(function() QuickTween(Btn, { BackgroundColor3 = Theme.ActionBtn }, 0.15) end)
        Btn.MouseButton1Click:Connect(function()
            QuickTween(Btn, { Size = UDim2.new(0.98, 0, 0, 30) }, 0.08).Completed:Connect(function()
                QuickTween(Btn, { Size = UDim2.new(1, 0, 0, 32) }, 0.1)
            end)
            task.spawn(function() pcall(callback) end)
        end)
        return Btn
    end

    -- Keybind
    function targetObj:AddKeybind(kbConfig)
        kbConfig = kbConfig or {}
        local name     = kbConfig.Name or "Keybind"
        local default  = kbConfig.Default or Enum.KeyCode.E
        local callback = kbConfig.Callback or function() end

        local currentKey = default

        local Row = Instance.new("Frame")
        Row.Name = "Keybind_" .. name
        Row.Size = UDim2.new(1, 0, 0, 34)
        Row.BackgroundColor3 = Color3.fromRGB(20, 21, 28)
        Row.BorderSizePixel = 0
        Row.ZIndex = 3
        Row.Parent = container

        local rCorner = Instance.new("UICorner")
        rCorner.CornerRadius = UDim.new(0, 8)
        rCorner.Parent = Row

        local rStroke = Instance.new("UIStroke")
        rStroke.Color = Color3.fromRGB(34, 36, 48)
        rStroke.Thickness = 1
        rStroke.Parent = Row

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -80, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 11
        Label.TextColor3 = Theme.TextPrimary
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = name
        Label.ZIndex = 4
        Label.Parent = Row

        local KeyBtn = Instance.new("TextButton")
        KeyBtn.Size = UDim2.fromOffset(64, 20)
        KeyBtn.Position = UDim2.new(1, -74, 0.5, -10)
        KeyBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
        KeyBtn.Font = Enum.Font.GothamBold
        KeyBtn.TextSize = 10
        KeyBtn.TextColor3 = Theme.Accent
        KeyBtn.Text = currentKey.Name
        KeyBtn.AutoButtonColor = false
        KeyBtn.ZIndex = 4
        KeyBtn.Parent = Row

        local kbCorner = Instance.new("UICorner")
        kbCorner.CornerRadius = UDim.new(0, 5)
        kbCorner.Parent = KeyBtn

        local kbStroke = Instance.new("UIStroke")
        kbStroke.Color = Color3.fromRGB(44, 47, 60)
        kbStroke.Thickness = 1
        kbStroke.Parent = KeyBtn

        local isBinding = false
        KeyBtn.MouseButton1Click:Connect(function()
            if isBinding then return end
            isBinding = true
            KeyBtn.Text = "..."
            QuickTween(kbStroke, { Color = Theme.Accent }, 0.15)

            local conn
            conn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    KeyBtn.Text = currentKey.Name
                    QuickTween(kbStroke, { Color = Color3.fromRGB(44, 47, 60) }, 0.15)
                    isBinding = false
                    conn:Disconnect()
                    task.spawn(function() pcall(callback, currentKey) end)
                end
            end)
        end)

        return {
            SetValue = function(self, k)
                currentKey = k
                KeyBtn.Text = currentKey.Name
            end,
            GetValue = function() return currentKey end
        }
    end

    -- InfoRow with Copy / Action Button
    function targetObj:AddInfoRow(infoConfig)
        infoConfig = infoConfig or {}
        local name     = infoConfig.Name or infoConfig.Title or "Info"
        local val      = infoConfig.Value or infoConfig.Content or ""
        local icon     = infoConfig.Icon
        local btnText  = infoConfig.ButtonText or "Copy"
        local callback = infoConfig.Callback or function() end

        local Row = Instance.new("Frame")
        Row.Name = "InfoRow_" .. name
        Row.Size = UDim2.new(1, 0, 0, 44)
        Row.BackgroundColor3 = Color3.fromRGB(20, 21, 28)
        Row.BorderSizePixel = 0
        Row.ZIndex = 3
        Row.Parent = container

        local rCorner = Instance.new("UICorner")
        rCorner.CornerRadius = UDim.new(0, 8)
        rCorner.Parent = Row

        local rStroke = Instance.new("UIStroke")
        rStroke.Color = Color3.fromRGB(34, 36, 48)
        rStroke.Thickness = 1
        rStroke.Parent = Row

        local textLeft = 12
        if icon then
            local IconImg = Instance.new("ImageLabel")
            IconImg.Size = UDim2.fromOffset(16, 16)
            IconImg.Position = UDim2.new(0, 12, 0.5, -8)
            IconImg.BackgroundTransparency = 1
            IconImg.Image = VRSLibV2.Icons.Get(icon)
            IconImg.ImageColor3 = Theme.TextMuted
            IconImg.ZIndex = 4
            IconImg.Parent = Row
            textLeft = 36
        end

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Size = UDim2.new(1, -(textLeft + 100), 0, 16)
        TitleLbl.Position = UDim2.new(0, textLeft, 0, 6)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Font = Enum.Font.GothamMedium
        TitleLbl.TextSize = 11
        TitleLbl.TextColor3 = Theme.TextPrimary
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.Text = name
        TitleLbl.ZIndex = 4
        TitleLbl.Parent = Row

        local ValLbl = Instance.new("TextLabel")
        ValLbl.Size = UDim2.new(1, -(textLeft + 100), 0, 14)
        ValLbl.Position = UDim2.new(0, textLeft, 0, 22)
        ValLbl.BackgroundTransparency = 1
        ValLbl.Font = Enum.Font.Gotham
        ValLbl.TextSize = 10
        ValLbl.TextColor3 = Theme.TextMuted
        ValLbl.TextXAlignment = Enum.TextXAlignment.Left
        ValLbl.Text = val
        ValLbl.ZIndex = 4
        ValLbl.Parent = Row

        local ActionBtn = Instance.new("TextButton")
        ActionBtn.Size = UDim2.fromOffset(84, 24)
        ActionBtn.Position = UDim2.new(1, -94, 0.5, -12)
        ActionBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
        ActionBtn.Text = btnText
        ActionBtn.Font = Enum.Font.GothamMedium
        ActionBtn.TextSize = 10
        ActionBtn.TextColor3 = Theme.Accent
        ActionBtn.AutoButtonColor = false
        ActionBtn.ZIndex = 4
        ActionBtn.Parent = Row

        local abCorner = Instance.new("UICorner")
        abCorner.CornerRadius = UDim.new(0, 6)
        abCorner.Parent = ActionBtn

        local abStroke = Instance.new("UIStroke")
        abStroke.Color = Color3.fromRGB(44, 47, 60)
        abStroke.Thickness = 1
        abStroke.Parent = ActionBtn

        ActionBtn.MouseButton1Click:Connect(function()
            ActionBtn.Text = "Copied!"
            QuickTween(ActionBtn, { BackgroundColor3 = Color3.fromRGB(36, 40, 56) }, 0.1)
            task.delay(1.5, function()
                ActionBtn.Text = btnText
                QuickTween(ActionBtn, { BackgroundColor3 = Color3.fromRGB(28, 30, 40) }, 0.2)
            end)
            task.spawn(function() pcall(callback, val) end)
        end)

        return {
            Update = function(newVal)
                val = newVal
                ValLbl.Text = tostring(newVal)
            end
        }
    end

    -- Descriptive Label
    function targetObj:AddLabel(lblConfig)
        if type(lblConfig) == "string" then lblConfig = { Text = lblConfig } end
        lblConfig = lblConfig or {}
        local text = lblConfig.Text or ""
        local col  = lblConfig.Color or Theme.TextSecondary

        local Lbl = Instance.new("TextLabel")
        Lbl.Name = "Label"
        Lbl.Size = UDim2.new(1, 0, 0, 20)
        Lbl.BackgroundTransparency = 1
        Lbl.Font = Enum.Font.Gotham
        Lbl.TextSize = 11
        Lbl.TextColor3 = col
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
        Lbl.Text = text
        Lbl.ZIndex = 3
        Lbl.Parent = container

        return Lbl
    end
end

return VRSLibV2
