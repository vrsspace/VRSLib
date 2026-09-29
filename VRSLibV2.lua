--[[
    ==============================================================================
    🌸 VRSLib V2 — 1:1 RECREATION OF TARGET MODERN HUB DESIGN
    ==============================================================================
    Features authentic Liquid Glassmorphism, 1:1 sidebar replication (detached-feel
    capsule, white/pink pill active indicator, 2-line avatar profile footer),
    exact header tabs, strict-order 6-box stat grid, and server action card.
    ==============================================================================
]]

local cloneref = (cloneref or clonereference or function(i) return i end)
local CoreGui          = cloneref(game:GetService("CoreGui"))
local Players          = cloneref(game:GetService("Players"))
local TweenService     = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService       = cloneref(game:GetService("RunService"))
local TeleportService  = cloneref(game:GetService("TeleportService"))
local Lighting         = cloneref(game:GetService("Lighting"))
local LocalPlayer      = Players.LocalPlayer or Players.PlayerAdded:Wait()

local VRSLibV2 = {
    Version = "2.2.0",
    Theme = {
        Background          = Color3.fromRGB(15, 16, 21),       -- #0F1015 Deep Matte Obsidian
        BackgroundTrans     = 0.0,                             -- Liquid Glass Transparency
        Sidebar             = Color3.fromRGB(12, 13, 17),       -- Dark Floating Sidebar
        SidebarTrans        = 0.0,
        SidebarActiveBtn    = Color3.fromRGB(36, 39, 52),       -- Active Tab Card
        SidebarActiveTrans  = 0.0,
        Header              = Color3.fromRGB(15, 16, 21),       -- Topbar Header
        HeaderTrans         = 0.0,                             -- Topbar Transparency
        Card                = Color3.fromRGB(22, 24, 32),       -- Frosted Glass Card
        CardTrans           = 0.0,
        CardStroke          = Color3.fromRGB(48, 52, 70),       -- Glass Edge Refraction
        CardStrokeTrans     = 0.45,
        InputBackground     = Color3.fromRGB(16, 17, 24),
        InputTrans          = 0.0,
        InputStroke         = Color3.fromRGB(44, 48, 66),
        Accent              = Color3.fromRGB(255, 64, 140),     -- Signature Neon Pink (#FF408C)
        AccentGlow          = Color3.fromRGB(255, 64, 140),
        TextPrimary         = Color3.fromRGB(248, 250, 255),    -- Pure White
        TextSecondary       = Color3.fromRGB(155, 160, 180),    -- Slate Light
        TextMuted           = Color3.fromRGB(115, 120, 140),    -- Muted Gray
        SwitchOff           = Color3.fromRGB(34, 37, 50),
        SwitchOffKnob       = Color3.fromRGB(145, 150, 170),
        SwitchOnKnob        = Color3.fromRGB(255, 255, 255),
        OnlineGreen         = Color3.fromRGB(46, 204, 113),     -- Online dot
        WarningOrange       = Color3.fromRGB(245, 166, 35),     -- Warning status
    },
    Windows = {},
}

-- Defensive Theme Fallback to prevent any nil property crashes
setmetatable(VRSLibV2.Theme, {
    __index = function(_, k)
        local key = tostring(k)
        if key:find("Trans") then return 0.2 end
        if key:find("Stroke") then return Color3.fromRGB(48, 52, 70) end
        if key:find("Text") then return Color3.fromRGB(240, 240, 240) end
        if key == "Header" then return Color3.fromRGB(15, 16, 21) end
        if key == "Sidebar" then return Color3.fromRGB(12, 13, 17) end
        return Color3.fromRGB(255, 64, 140) -- Safe fallback
    end
})

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
-- LIQUID GLASS FROSTED BLUR EFFECT (In Lighting)
-- ==============================================================================
local GlassBlur = nil
local function EnableGlassBlur()
    if GlassBlur and GlassBlur.Parent then return end
    pcall(function()
        for _, old in ipairs(Lighting:GetChildren()) do
            if old.Name == "VRSV2_GlassBlur" then old:Destroy() end
        end
        local blur = Instance.new("BlurEffect")
        blur.Name = "VRSV2_GlassBlur"
        blur.Size = 14
        blur.Enabled = true
        blur.Parent = Lighting
        GlassBlur = blur
    end)
end

local function DisableGlassBlur()
    if GlassBlur and GlassBlur.Parent then
        pcall(function() GlassBlur:Destroy() end)
        GlassBlur = nil
    end
end

-- Specular Glass Shine Utility
local function ApplyGlassSpecular(parentFrame)
    local spec = Instance.new("Frame")
    spec.Name = "GlassSheen"
    spec.Size = UDim2.new(1, 0, 1, 0)
    spec.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    spec.BackgroundTransparency = 0.96
    spec.BorderSizePixel = 0
    spec.ZIndex = parentFrame.ZIndex or 1
    spec.Parent = parentFrame

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 10)
    sCorner.Parent = spec

    local grad = Instance.new("UIGradient")
    grad.Rotation = 45
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.0, 0.92),
        NumberSequenceKeypoint.new(0.3, 0.96),
        NumberSequenceKeypoint.new(0.7, 0.99),
        NumberSequenceKeypoint.new(1.0, 1.00),
    })
    grad.Parent = spec
    return spec
end

-- ==============================================================================
-- LUCIDE ICONS ENGINE
-- ==============================================================================
VRSLibV2.Icons = (function()
--[[
    ==============================================================================
    🌸 VRS ARTELIER — ICONS MODULE (LUCIDE ENGINE)
    ==============================================================================
    Design: VRS Artelier Cyber-Dark, 100% Signature Neon Magenta Pink (#FF408C)
    Provides 800+ verified Lucide icon assets + smart alias resolver.
    Guarantees that NO icon ever renders blank or missing.
    ==============================================================================
]]

local Icons = {
    -- Custom Brand Assets
    Wings   = "rbxassetid://132717088484517",
    Default = "rbxassetid://10709782497", -- Box icon fallback (never blank!)

    -- Smart Aliases for common terms & backward compatibility
    Aliases = {
        ["grid"]             = "lucide-layout-grid",
        ["layout-grid"]      = "lucide-layout-grid",
        ["zap"]              = "lucide-charge",
        ["charge"]           = "lucide-charge",
        ["timer"]            = "lucide-timer",
        ["clock"]            = "lucide-clock",
        ["gauge"]            = "lucide-gauge",
        ["fps"]              = "lucide-gauge",
        ["speed"]            = "lucide-gauge",
        ["wifi"]             = "lucide-wifi",
        ["ping"]             = "lucide-wifi",
        ["shield-alert"]     = "lucide-shield-alert",
        ["shieldalert"]      = "lucide-shield-alert",
        ["message-square"]   = "lucide-message-square",
        ["messagesquare"]    = "lucide-message-square",
        ["message-circle"]   = "lucide-message-circle",
        ["messagecircle"]    = "lucide-message-circle",
        ["monitor"]          = "lucide-monitor",
        ["list-checks"]      = "lucide-list-checks",
        ["listchecks"]       = "lucide-list-checks",
        ["wings"]            = "rbxassetid://132717088484517",
        ["vrs"]              = "rbxassetid://132717088484517",

        ["visuals"]          = "lucide-eye",
        ["movement"]         = "lucide-move",
        ["world"]            = "lucide-globe",
        ["system"]           = "lucide-settings",
        ["combat"]           = "lucide-swords",
        ["player"]           = "lucide-user",
        ["shield"]           = "lucide-shield",
        ["play"]             = "lucide-play",
        ["pin"]              = "lucide-pin",
        ["pinned"]           = "lucide-star",
        ["star"]             = "lucide-star",
        ["active"]           = "lucide-target",
        ["target"]           = "lucide-target",
        ["all"]              = "lucide-layout-grid",
        ["grid"]             = "lucide-layout-grid",
        ["list"]             = "lucide-layout-list",
        ["compact"]          = "lucide-stretch-horizontal",
        ["sun"]              = "lucide-sun",
        ["cloud"]            = "lucide-cloud",
        ["fog"]              = "lucide-cloud",
        ["clock"]            = "lucide-clock",
        ["time"]             = "lucide-clock",
        ["key"]              = "lucide-key",
        ["lock"]             = "lucide-lock",
        ["unlock"]           = "lucide-unlock",
        ["feather"]          = "lucide-feather",
        ["fly"]              = "lucide-feather",
        ["fling"]            = "lucide-move",
        ["camera"]           = "lucide-camera",
        ["view"]             = "lucide-view",
        ["crosshair"]        = "lucide-crosshair",
        ["gear"]             = "lucide-settings",
        ["settings"]         = "lucide-settings",
        ["search"]           = "lucide-search",
        ["close"]            = "lucide-x",
        ["minimize"]         = "lucide-minus",
        ["maximize"]         = "lucide-maximize-2",
        ["refresh"]          = "lucide-refresh-cw",
        ["speed"]            = "lucide-gauge",
        ["gauge"]            = "lucide-gauge",
        ["wind"]             = "lucide-wind",
        ["air"]              = "lucide-wind",
        ["fire"]             = "lucide-flame",
        ["flame"]            = "lucide-flame",
        ["trash"]            = "lucide-trash-2",
        ["removal"]          = "lucide-trash-2",
        ["gravity"]          = "lucide-globe",
        ["hitbox"]           = "lucide-box",
        ["spider"]           = "lucide-bug",
        ["click"]            = "lucide-mouse-pointer-click",
        ["pointer"]          = "lucide-mouse-pointer",
        ["activity"]         = "lucide-activity",
        ["layers"]           = "lucide-layers",
        ["resize"]           = "lucide-corner-down-right",
    },

    Assets = {
        ["lucide-accessibility"] = "rbxassetid://10709751939",
        ["lucide-activity"] = "rbxassetid://10709752035",
        ["lucide-air-vent"] = "rbxassetid://10709752131",
        ["lucide-airplay"] = "rbxassetid://10709752254",
        ["lucide-alarm-check"] = "rbxassetid://10709752405",
        ["lucide-alarm-clock"] = "rbxassetid://10709752630",
        ["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
        ["lucide-alarm-minus"] = "rbxassetid://10709752732",
        ["lucide-alarm-plus"] = "rbxassetid://10709752825",
        ["lucide-album"] = "rbxassetid://10709752906",
        ["lucide-alert-circle"] = "rbxassetid://10709752996",
        ["lucide-alert-octagon"] = "rbxassetid://10709753064",
        ["lucide-alert-triangle"] = "rbxassetid://10709753149",
        ["lucide-align-center"] = "rbxassetid://10709753570",
        ["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
        ["lucide-align-center-vertical"] = "rbxassetid://10709753421",
        ["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
        ["lucide-align-end-vertical"] = "rbxassetid://10709753808",
        ["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
        ["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
        ["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
        ["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
        ["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
        ["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
        ["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
        ["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
        ["lucide-align-justify"] = "rbxassetid://10709759610",
        ["lucide-align-left"] = "rbxassetid://10709759764",
        ["lucide-align-right"] = "rbxassetid://10709759895",
        ["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
        ["lucide-align-start-vertical"] = "rbxassetid://10709760244",
        ["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
        ["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
        ["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
        ["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
        ["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
        ["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
        ["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
        ["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
        ["lucide-anchor"] = "rbxassetid://10709761530",
        ["lucide-angry"] = "rbxassetid://10709761629",
        ["lucide-annoyed"] = "rbxassetid://10709761722",
        ["lucide-aperture"] = "rbxassetid://10709761813",
        ["lucide-apple"] = "rbxassetid://10709761889",
        ["lucide-archive"] = "rbxassetid://10709762233",
        ["lucide-archive-restore"] = "rbxassetid://10709762058",
        ["lucide-armchair"] = "rbxassetid://10709762327",
        ["lucide-arrow-big-down"] = "rbxassetid://10747796644",
        ["lucide-arrow-big-left"] = "rbxassetid://10709762574",
        ["lucide-arrow-big-right"] = "rbxassetid://10709762727",
        ["lucide-arrow-big-up"] = "rbxassetid://10709762879",
        ["lucide-arrow-down"] = "rbxassetid://10709767827",
        ["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
        ["lucide-arrow-down-left"] = "rbxassetid://10709767656",
        ["lucide-arrow-down-right"] = "rbxassetid://10709767750",
        ["lucide-arrow-left"] = "rbxassetid://10709768114",
        ["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
        ["lucide-arrow-left-right"] = "rbxassetid://10709768019",
        ["lucide-arrow-right"] = "rbxassetid://10709768347",
        ["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
        ["lucide-arrow-up"] = "rbxassetid://10709768939",
        ["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
        ["lucide-arrow-up-down"] = "rbxassetid://10709768538",
        ["lucide-arrow-up-left"] = "rbxassetid://10709768661",
        ["lucide-arrow-up-right"] = "rbxassetid://10709768787",
        ["lucide-asterisk"] = "rbxassetid://10709769095",
        ["lucide-at-sign"] = "rbxassetid://10709769286",
        ["lucide-award"] = "rbxassetid://10709769406",
        ["lucide-axe"] = "rbxassetid://10709769508",
        ["lucide-axis-3d"] = "rbxassetid://10709769598",
        ["lucide-baby"] = "rbxassetid://10709769732",
        ["lucide-backpack"] = "rbxassetid://10709769841",
        ["lucide-baggage-claim"] = "rbxassetid://10709769935",
        ["lucide-banana"] = "rbxassetid://10709770005",
        ["lucide-banknote"] = "rbxassetid://10709770178",
        ["lucide-bar-chart"] = "rbxassetid://10709773755",
        ["lucide-bar-chart-2"] = "rbxassetid://10709770317",
        ["lucide-bar-chart-3"] = "rbxassetid://10709770431",
        ["lucide-bar-chart-4"] = "rbxassetid://10709770560",
        ["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
        ["lucide-barcode"] = "rbxassetid://10747360675",
        ["lucide-baseline"] = "rbxassetid://10709773863",
        ["lucide-bath"] = "rbxassetid://10709773963",
        ["lucide-battery"] = "rbxassetid://10709774640",
        ["lucide-battery-charging"] = "rbxassetid://10709774068",
        ["lucide-battery-full"] = "rbxassetid://10709774206",
        ["lucide-battery-low"] = "rbxassetid://10709774370",
        ["lucide-battery-medium"] = "rbxassetid://10709774513",
        ["lucide-beaker"] = "rbxassetid://10709774756",
        ["lucide-bed"] = "rbxassetid://10709775036",
        ["lucide-bed-double"] = "rbxassetid://10709774864",
        ["lucide-bed-single"] = "rbxassetid://10709774968",
        ["lucide-beer"] = "rbxassetid://10709775167",
        ["lucide-bell"] = "rbxassetid://10709775704",
        ["lucide-bell-minus"] = "rbxassetid://10709775241",
        ["lucide-bell-off"] = "rbxassetid://10709775320",
        ["lucide-bell-plus"] = "rbxassetid://10709775448",
        ["lucide-bell-ring"] = "rbxassetid://10709775560",
        ["lucide-bike"] = "rbxassetid://10709775894",
        ["lucide-binary"] = "rbxassetid://10709776050",
        ["lucide-bitcoin"] = "rbxassetid://10709776126",
        ["lucide-bluetooth"] = "rbxassetid://10709776655",
        ["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
        ["lucide-bluetooth-off"] = "rbxassetid://10709776344",
        ["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
        ["lucide-bold"] = "rbxassetid://10747813908",
        ["lucide-bomb"] = "rbxassetid://10709781460",
        ["lucide-bone"] = "rbxassetid://10709781605",
        ["lucide-book"] = "rbxassetid://10709781824",
        ["lucide-book-open"] = "rbxassetid://10709781717",
        ["lucide-bookmark"] = "rbxassetid://10709782154",
        ["lucide-bookmark-minus"] = "rbxassetid://10709781919",
        ["lucide-bookmark-plus"] = "rbxassetid://10709782044",
        ["lucide-bot"] = "rbxassetid://10709782230",
        ["lucide-box"] = "rbxassetid://10709782497",
        ["lucide-box-select"] = "rbxassetid://10709782342",
        ["lucide-boxes"] = "rbxassetid://10709782582",
        ["lucide-briefcase"] = "rbxassetid://10709782662",
        ["lucide-brush"] = "rbxassetid://10709782758",
        ["lucide-bug"] = "rbxassetid://10709782845",
        ["lucide-building"] = "rbxassetid://10709783051",
        ["lucide-building-2"] = "rbxassetid://10709782939",
        ["lucide-bus"] = "rbxassetid://10709783137",
        ["lucide-cake"] = "rbxassetid://10709783217",
        ["lucide-calculator"] = "rbxassetid://10709783311",
        ["lucide-calendar"] = "rbxassetid://10709789505",
        ["lucide-calendar-check"] = "rbxassetid://10709783474",
        ["lucide-calendar-check-2"] = "rbxassetid://10709783392",
        ["lucide-calendar-clock"] = "rbxassetid://10709783577",
        ["lucide-calendar-days"] = "rbxassetid://10709783673",
        ["lucide-calendar-heart"] = "rbxassetid://10709783835",
        ["lucide-calendar-minus"] = "rbxassetid://10709783959",
        ["lucide-calendar-off"] = "rbxassetid://10709788784",
        ["lucide-calendar-plus"] = "rbxassetid://10709788937",
        ["lucide-calendar-range"] = "rbxassetid://10709789053",
        ["lucide-calendar-search"] = "rbxassetid://10709789200",
        ["lucide-calendar-x"] = "rbxassetid://10709789407",
        ["lucide-calendar-x-2"] = "rbxassetid://10709789329",
        ["lucide-camera"] = "rbxassetid://10709789686",
        ["lucide-camera-off"] = "rbxassetid://10747822677",
        ["lucide-car"] = "rbxassetid://10709789810",
        ["lucide-carrot"] = "rbxassetid://10709789960",
        ["lucide-cast"] = "rbxassetid://10709790097",
        ["lucide-charge"] = "rbxassetid://10709790202",
        ["lucide-check"] = "rbxassetid://10709790644",
        ["lucide-check-circle"] = "rbxassetid://10709790387",
        ["lucide-check-circle-2"] = "rbxassetid://10709790298",
        ["lucide-check-square"] = "rbxassetid://10709790537",
        ["lucide-chef-hat"] = "rbxassetid://10709790757",
        ["lucide-cherry"] = "rbxassetid://10709790875",
        ["lucide-chevron-down"] = "rbxassetid://10709790948",
        ["lucide-chevron-first"] = "rbxassetid://10709791015",
        ["lucide-chevron-last"] = "rbxassetid://10709791130",
        ["lucide-chevron-left"] = "rbxassetid://10709791281",
        ["lucide-chevron-right"] = "rbxassetid://10709791437",
        ["lucide-chevron-up"] = "rbxassetid://10709791523",
        ["lucide-chevrons-down"] = "rbxassetid://10709796864",
        ["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
        ["lucide-chevrons-left"] = "rbxassetid://10709797151",
        ["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
        ["lucide-chevrons-right"] = "rbxassetid://10709797382",
        ["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
        ["lucide-chevrons-up"] = "rbxassetid://10709797622",
        ["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
        ["lucide-chrome"] = "rbxassetid://10709797725",
        ["lucide-circle"] = "rbxassetid://10709798174",
        ["lucide-circle-dot"] = "rbxassetid://10709797837",
        ["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
        ["lucide-circle-slashed"] = "rbxassetid://10709798100",
        ["lucide-citrus"] = "rbxassetid://10709798276",
        ["lucide-clapperboard"] = "rbxassetid://10709798350",
        ["lucide-clipboard"] = "rbxassetid://10709799288",
        ["lucide-clipboard-check"] = "rbxassetid://10709798443",
        ["lucide-clipboard-copy"] = "rbxassetid://10709798574",
        ["lucide-clipboard-edit"] = "rbxassetid://10709798682",
        ["lucide-clipboard-list"] = "rbxassetid://10709798792",
        ["lucide-clipboard-signature"] = "rbxassetid://10709798890",
        ["lucide-clipboard-type"] = "rbxassetid://10709798999",
        ["lucide-clipboard-x"] = "rbxassetid://10709799124",
        ["lucide-clock"] = "rbxassetid://10709805144",
        ["lucide-clock-1"] = "rbxassetid://10709799535",
        ["lucide-clock-10"] = "rbxassetid://10709799718",
        ["lucide-clock-11"] = "rbxassetid://10709799818",
        ["lucide-clock-12"] = "rbxassetid://10709799962",
        ["lucide-clock-2"] = "rbxassetid://10709803876",
        ["lucide-clock-3"] = "rbxassetid://10709803989",
        ["lucide-clock-4"] = "rbxassetid://10709804164",
        ["lucide-clock-5"] = "rbxassetid://10709804291",
        ["lucide-clock-6"] = "rbxassetid://10709804435",
        ["lucide-clock-7"] = "rbxassetid://10709804599",
        ["lucide-clock-8"] = "rbxassetid://10709804784",
        ["lucide-clock-9"] = "rbxassetid://10709804996",
        ["lucide-cloud"] = "rbxassetid://10709806740",
        ["lucide-cloud-cog"] = "rbxassetid://10709805262",
        ["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
        ["lucide-cloud-fog"] = "rbxassetid://10709805477",
        ["lucide-cloud-hail"] = "rbxassetid://10709805596",
        ["lucide-cloud-lightning"] = "rbxassetid://10709805727",
        ["lucide-cloud-moon"] = "rbxassetid://10709805942",
        ["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
        ["lucide-cloud-off"] = "rbxassetid://10709806060",
        ["lucide-cloud-rain"] = "rbxassetid://10709806277",
        ["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
        ["lucide-cloud-snow"] = "rbxassetid://10709806374",
        ["lucide-cloud-sun"] = "rbxassetid://10709806631",
        ["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
        ["lucide-cloudy"] = "rbxassetid://10709806859",
        ["lucide-clover"] = "rbxassetid://10709806995",
        ["lucide-code"] = "rbxassetid://10709810463",
        ["lucide-code-2"] = "rbxassetid://10709807111",
        ["lucide-codepen"] = "rbxassetid://10709810534",
        ["lucide-codesandbox"] = "rbxassetid://10709810676",
        ["lucide-coffee"] = "rbxassetid://10709810814",
        ["lucide-cog"] = "rbxassetid://10709810948",
        ["lucide-coins"] = "rbxassetid://10709811110",
        ["lucide-columns"] = "rbxassetid://10709811261",
        ["lucide-command"] = "rbxassetid://10709811365",
        ["lucide-compass"] = "rbxassetid://10709811445",
        ["lucide-component"] = "rbxassetid://10709811595",
        ["lucide-concierge-bell"] = "rbxassetid://10709811706",
        ["lucide-connection"] = "rbxassetid://10747361219",
        ["lucide-contact"] = "rbxassetid://10709811834",
        ["lucide-contrast"] = "rbxassetid://10709811939",
        ["lucide-cookie"] = "rbxassetid://10709812067",
        ["lucide-copy"] = "rbxassetid://10709812159",
        ["lucide-copyleft"] = "rbxassetid://10709812251",
        ["lucide-copyright"] = "rbxassetid://10709812311",
        ["lucide-corner-down-left"] = "rbxassetid://10709812396",
        ["lucide-corner-down-right"] = "rbxassetid://10709812485",
        ["lucide-corner-left-down"] = "rbxassetid://10709812632",
        ["lucide-corner-left-up"] = "rbxassetid://10709812784",
        ["lucide-corner-right-down"] = "rbxassetid://10709812939",
        ["lucide-corner-right-up"] = "rbxassetid://10709813094",
        ["lucide-corner-up-left"] = "rbxassetid://10709813185",
        ["lucide-corner-up-right"] = "rbxassetid://10709813281",
        ["lucide-cpu"] = "rbxassetid://10709813383",
        ["lucide-croissant"] = "rbxassetid://10709818125",
        ["lucide-crop"] = "rbxassetid://10709818245",
        ["lucide-cross"] = "rbxassetid://10709818399",
        ["lucide-crosshair"] = "rbxassetid://10709818534",
        ["lucide-crown"] = "rbxassetid://10709818626",
        ["lucide-cup-soda"] = "rbxassetid://10709818763",
        ["lucide-curly-braces"] = "rbxassetid://10709818847",
        ["lucide-currency"] = "rbxassetid://10709818931",
        ["lucide-database"] = "rbxassetid://10709818996",
        ["lucide-delete"] = "rbxassetid://10709819059",
        ["lucide-diamond"] = "rbxassetid://10709819149",
        ["lucide-dice-1"] = "rbxassetid://10709819266",
        ["lucide-dice-2"] = "rbxassetid://10709819361",
        ["lucide-dice-3"] = "rbxassetid://10709819508",
        ["lucide-dice-4"] = "rbxassetid://10709819670",
        ["lucide-dice-5"] = "rbxassetid://10709819801",
        ["lucide-dice-6"] = "rbxassetid://10709819896",
        ["lucide-dices"] = "rbxassetid://10723343321",
        ["lucide-diff"] = "rbxassetid://10723343416",
        ["lucide-disc"] = "rbxassetid://10723343537",
        ["lucide-divide"] = "rbxassetid://10723343805",
        ["lucide-divide-circle"] = "rbxassetid://10723343636",
        ["lucide-divide-square"] = "rbxassetid://10723343737",
        ["lucide-dollar-sign"] = "rbxassetid://10723343958",
        ["lucide-download"] = "rbxassetid://10723344270",
        ["lucide-download-cloud"] = "rbxassetid://10723344088",
        ["lucide-droplet"] = "rbxassetid://10723344432",
        ["lucide-droplets"] = "rbxassetid://10734883356",
        ["lucide-drumstick"] = "rbxassetid://10723344737",
        ["lucide-edit"] = "rbxassetid://10734883598",
        ["lucide-edit-2"] = "rbxassetid://10723344885",
        ["lucide-edit-3"] = "rbxassetid://10723345088",
        ["lucide-egg"] = "rbxassetid://10723345518",
        ["lucide-egg-fried"] = "rbxassetid://10723345347",
        ["lucide-electricity"] = "rbxassetid://10723345749",
        ["lucide-electricity-off"] = "rbxassetid://10723345643",
        ["lucide-equal"] = "rbxassetid://10723345990",
        ["lucide-equal-not"] = "rbxassetid://10723345866",
        ["lucide-eraser"] = "rbxassetid://10723346158",
        ["lucide-euro"] = "rbxassetid://10723346372",
        ["lucide-expand"] = "rbxassetid://10723346553",
        ["lucide-external-link"] = "rbxassetid://10723346684",
        ["lucide-eye"] = "rbxassetid://10723346959",
        ["lucide-eye-off"] = "rbxassetid://10723346871",
        ["lucide-factory"] = "rbxassetid://10723347051",
        ["lucide-fan"] = "rbxassetid://10723354359",
        ["lucide-fast-forward"] = "rbxassetid://10723354521",
        ["lucide-feather"] = "rbxassetid://10723354671",
        ["lucide-figma"] = "rbxassetid://10723354801",
        ["lucide-file"] = "rbxassetid://10723374641",
        ["lucide-file-archive"] = "rbxassetid://10723354921",
        ["lucide-file-audio"] = "rbxassetid://10723355148",
        ["lucide-file-audio-2"] = "rbxassetid://10723355026",
        ["lucide-file-axis-3d"] = "rbxassetid://10723355272",
        ["lucide-file-badge"] = "rbxassetid://10723355622",
        ["lucide-file-badge-2"] = "rbxassetid://10723355451",
        ["lucide-file-bar-chart"] = "rbxassetid://10723355887",
        ["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
        ["lucide-file-box"] = "rbxassetid://10723355989",
        ["lucide-file-check"] = "rbxassetid://10723356210",
        ["lucide-file-check-2"] = "rbxassetid://10723356100",
        ["lucide-file-clock"] = "rbxassetid://10723356329",
        ["lucide-file-code"] = "rbxassetid://10723356507",
        ["lucide-file-cog"] = "rbxassetid://10723356830",
        ["lucide-file-cog-2"] = "rbxassetid://10723356676",
        ["lucide-file-diff"] = "rbxassetid://10723357039",
        ["lucide-file-digit"] = "rbxassetid://10723357151",
        ["lucide-file-down"] = "rbxassetid://10723357322",
        ["lucide-file-edit"] = "rbxassetid://10723357495",
        ["lucide-file-heart"] = "rbxassetid://10723357637",
        ["lucide-file-image"] = "rbxassetid://10723357790",
        ["lucide-file-input"] = "rbxassetid://10723357933",
        ["lucide-file-json"] = "rbxassetid://10723364435",
        ["lucide-file-json-2"] = "rbxassetid://10723364361",
        ["lucide-file-key"] = "rbxassetid://10723364605",
        ["lucide-file-key-2"] = "rbxassetid://10723364515",
        ["lucide-file-line-chart"] = "rbxassetid://10723364725",
        ["lucide-file-lock"] = "rbxassetid://10723364957",
        ["lucide-file-lock-2"] = "rbxassetid://10723364861",
        ["lucide-file-minus"] = "rbxassetid://10723365254",
        ["lucide-file-minus-2"] = "rbxassetid://10723365086",
        ["lucide-file-output"] = "rbxassetid://10723365457",
        ["lucide-file-pie-chart"] = "rbxassetid://10723365598",
        ["lucide-file-plus"] = "rbxassetid://10723365877",
        ["lucide-file-plus-2"] = "rbxassetid://10723365766",
        ["lucide-file-question"] = "rbxassetid://10723365987",
        ["lucide-file-scan"] = "rbxassetid://10723366167",
        ["lucide-file-search"] = "rbxassetid://10723366550",
        ["lucide-file-search-2"] = "rbxassetid://10723366340",
        ["lucide-file-signature"] = "rbxassetid://10723366741",
        ["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
        ["lucide-file-symlink"] = "rbxassetid://10723367098",
        ["lucide-file-terminal"] = "rbxassetid://10723367244",
        ["lucide-file-text"] = "rbxassetid://10723367380",
        ["lucide-file-type"] = "rbxassetid://10723367606",
        ["lucide-file-type-2"] = "rbxassetid://10723367509",
        ["lucide-file-up"] = "rbxassetid://10723367734",
        ["lucide-file-video"] = "rbxassetid://10723373884",
        ["lucide-file-video-2"] = "rbxassetid://10723367834",
        ["lucide-file-volume"] = "rbxassetid://10723374172",
        ["lucide-file-volume-2"] = "rbxassetid://10723374030",
        ["lucide-file-warning"] = "rbxassetid://10723374276",
        ["lucide-file-x"] = "rbxassetid://10723374544",
        ["lucide-file-x-2"] = "rbxassetid://10723374378",
        ["lucide-files"] = "rbxassetid://10723374759",
        ["lucide-film"] = "rbxassetid://10723374981",
        ["lucide-filter"] = "rbxassetid://10723375128",
        ["lucide-fingerprint"] = "rbxassetid://10723375250",
        ["lucide-flag"] = "rbxassetid://10723375890",
        ["lucide-flag-off"] = "rbxassetid://10723375443",
        ["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
        ["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
        ["lucide-flame"] = "rbxassetid://10723376114",
        ["lucide-flashlight"] = "rbxassetid://10723376471",
        ["lucide-flashlight-off"] = "rbxassetid://10723376365",
        ["lucide-flask-conical"] = "rbxassetid://10734883986",
        ["lucide-flask-round"] = "rbxassetid://10723376614",
        ["lucide-flip-horizontal"] = "rbxassetid://10723376884",
        ["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
        ["lucide-flip-vertical"] = "rbxassetid://10723377138",
        ["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
        ["lucide-flower"] = "rbxassetid://10747830374",
        ["lucide-flower-2"] = "rbxassetid://10723377305",
        ["lucide-focus"] = "rbxassetid://10723377537",
        ["lucide-folder"] = "rbxassetid://10723387563",
        ["lucide-folder-archive"] = "rbxassetid://10723384478",
        ["lucide-folder-check"] = "rbxassetid://10723384605",
        ["lucide-folder-clock"] = "rbxassetid://10723384731",
        ["lucide-folder-closed"] = "rbxassetid://10723384893",
        ["lucide-folder-cog"] = "rbxassetid://10723385213",
        ["lucide-folder-cog-2"] = "rbxassetid://10723385036",
        ["lucide-folder-down"] = "rbxassetid://10723385338",
        ["lucide-folder-edit"] = "rbxassetid://10723385445",
        ["lucide-folder-heart"] = "rbxassetid://10723385545",
        ["lucide-folder-input"] = "rbxassetid://10723385721",
        ["lucide-folder-key"] = "rbxassetid://10723385848",
        ["lucide-folder-lock"] = "rbxassetid://10723386005",
        ["lucide-folder-minus"] = "rbxassetid://10723386127",
        ["lucide-folder-open"] = "rbxassetid://10723386277",
        ["lucide-folder-output"] = "rbxassetid://10723386386",
        ["lucide-folder-plus"] = "rbxassetid://10723386531",
        ["lucide-folder-search"] = "rbxassetid://10723386787",
        ["lucide-folder-search-2"] = "rbxassetid://10723386674",
        ["lucide-folder-symlink"] = "rbxassetid://10723386930",
        ["lucide-folder-tree"] = "rbxassetid://10723387085",
        ["lucide-folder-up"] = "rbxassetid://10723387265",
        ["lucide-folder-x"] = "rbxassetid://10723387448",
        ["lucide-folders"] = "rbxassetid://10723387721",
        ["lucide-form-input"] = "rbxassetid://10723387841",
        ["lucide-forward"] = "rbxassetid://10723388016",
        ["lucide-frame"] = "rbxassetid://10723394389",
        ["lucide-framer"] = "rbxassetid://10723394565",
        ["lucide-frown"] = "rbxassetid://10723394681",
        ["lucide-fuel"] = "rbxassetid://10723394846",
        ["lucide-function-square"] = "rbxassetid://10723395041",
        ["lucide-gamepad"] = "rbxassetid://10723395457",
        ["lucide-gamepad-2"] = "rbxassetid://10723395215",
        ["lucide-gauge"] = "rbxassetid://10723395708",
        ["lucide-gavel"] = "rbxassetid://10723395896",
        ["lucide-gem"] = "rbxassetid://10723396000",
        ["lucide-ghost"] = "rbxassetid://10723396107",
        ["lucide-gift"] = "rbxassetid://10723396402",
        ["lucide-gift-card"] = "rbxassetid://10723396225",
        ["lucide-git-branch"] = "rbxassetid://10723396676",
        ["lucide-git-branch-plus"] = "rbxassetid://10723396542",
        ["lucide-git-commit"] = "rbxassetid://10723396812",
        ["lucide-git-compare"] = "rbxassetid://10723396954",
        ["lucide-git-fork"] = "rbxassetid://10723397049",
        ["lucide-git-merge"] = "rbxassetid://10723397165",
        ["lucide-git-pull-request"] = "rbxassetid://10723397431",
        ["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
        ["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
        ["lucide-glass"] = "rbxassetid://10723397788",
        ["lucide-glass-2"] = "rbxassetid://10723397529",
        ["lucide-glass-water"] = "rbxassetid://10723397678",
        ["lucide-glasses"] = "rbxassetid://10723397895",
        ["lucide-globe"] = "rbxassetid://10723404337",
        ["lucide-globe-2"] = "rbxassetid://10723398002",
        ["lucide-grab"] = "rbxassetid://10723404472",
        ["lucide-graduation-cap"] = "rbxassetid://10723404691",
        ["lucide-grape"] = "rbxassetid://10723404822",
        ["lucide-grid"] = "rbxassetid://10723404936",
        ["lucide-grip-horizontal"] = "rbxassetid://10723405089",
        ["lucide-grip-vertical"] = "rbxassetid://10723405236",
        ["lucide-hammer"] = "rbxassetid://10723405360",
        ["lucide-hand"] = "rbxassetid://10723405649",
        ["lucide-hand-metal"] = "rbxassetid://10723405508",
        ["lucide-hard-drive"] = "rbxassetid://10723405749",
        ["lucide-hard-hat"] = "rbxassetid://10723405859",
        ["lucide-hash"] = "rbxassetid://10723405975",
        ["lucide-haze"] = "rbxassetid://10723406078",
        ["lucide-headphones"] = "rbxassetid://10723406165",
        ["lucide-heart"] = "rbxassetid://10723406885",
        ["lucide-heart-crack"] = "rbxassetid://10723406299",
        ["lucide-heart-handshake"] = "rbxassetid://10723406480",
        ["lucide-heart-off"] = "rbxassetid://10723406662",
        ["lucide-heart-pulse"] = "rbxassetid://10723406795",
        ["lucide-help-circle"] = "rbxassetid://10723406988",
        ["lucide-hexagon"] = "rbxassetid://10723407092",
        ["lucide-highlighter"] = "rbxassetid://10723407192",
        ["lucide-history"] = "rbxassetid://10723407335",
        ["lucide-home"] = "rbxassetid://10723407389",
        ["lucide-hourglass"] = "rbxassetid://10723407498",
        ["lucide-ice-cream"] = "rbxassetid://10723414308",
        ["lucide-image"] = "rbxassetid://10723415040",
        ["lucide-image-minus"] = "rbxassetid://10723414487",
        ["lucide-image-off"] = "rbxassetid://10723414677",
        ["lucide-image-plus"] = "rbxassetid://10723414827",
        ["lucide-import"] = "rbxassetid://10723415205",
        ["lucide-inbox"] = "rbxassetid://10723415335",
        ["lucide-indent"] = "rbxassetid://10723415494",
        ["lucide-indian-rupee"] = "rbxassetid://10723415642",
        ["lucide-infinity"] = "rbxassetid://10723415766",
        ["lucide-info"] = "rbxassetid://10723415903",
        ["lucide-inspect"] = "rbxassetid://10723416057",
        ["lucide-italic"] = "rbxassetid://10723416195",
        ["lucide-japanese-yen"] = "rbxassetid://10723416363",
        ["lucide-joystick"] = "rbxassetid://10723416527",
        ["lucide-key"] = "rbxassetid://10723416652",
        ["lucide-keyboard"] = "rbxassetid://10723416765",
        ["lucide-lamp"] = "rbxassetid://10723417513",
        ["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
        ["lucide-lamp-desk"] = "rbxassetid://10723417016",
        ["lucide-lamp-floor"] = "rbxassetid://10723417131",
        ["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
        ["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
        ["lucide-landmark"] = "rbxassetid://10723417608",
        ["lucide-languages"] = "rbxassetid://10723417703",
        ["lucide-laptop"] = "rbxassetid://10723423881",
        ["lucide-laptop-2"] = "rbxassetid://10723417797",
        ["lucide-lasso"] = "rbxassetid://10723424235",
        ["lucide-lasso-select"] = "rbxassetid://10723424058",
        ["lucide-laugh"] = "rbxassetid://10723424372",
        ["lucide-layers"] = "rbxassetid://10723424505",
        ["lucide-layout"] = "rbxassetid://10723425376",
        ["lucide-layout-dashboard"] = "rbxassetid://10723424646",
        ["lucide-layout-grid"] = "rbxassetid://10723424838",
        ["lucide-layout-list"] = "rbxassetid://10723424963",
        ["lucide-layout-template"] = "rbxassetid://10723425187",
        ["lucide-leaf"] = "rbxassetid://10723425539",
        ["lucide-library"] = "rbxassetid://10723425615",
        ["lucide-life-buoy"] = "rbxassetid://10723425685",
        ["lucide-lightbulb"] = "rbxassetid://10723425852",
        ["lucide-lightbulb-off"] = "rbxassetid://10723425762",
        ["lucide-line-chart"] = "rbxassetid://10723426393",
        ["lucide-link"] = "rbxassetid://10723426722",
        ["lucide-link-2"] = "rbxassetid://10723426595",
        ["lucide-link-2-off"] = "rbxassetid://10723426513",
        ["lucide-list"] = "rbxassetid://10723433811",
        ["lucide-list-checks"] = "rbxassetid://10734884548",
        ["lucide-list-end"] = "rbxassetid://10723426886",
        ["lucide-list-minus"] = "rbxassetid://10723426986",
        ["lucide-list-music"] = "rbxassetid://10723427081",
        ["lucide-list-ordered"] = "rbxassetid://10723427199",
        ["lucide-list-plus"] = "rbxassetid://10723427334",
        ["lucide-list-start"] = "rbxassetid://10723427494",
        ["lucide-list-video"] = "rbxassetid://10723427619",
        ["lucide-list-x"] = "rbxassetid://10723433655",
        ["lucide-loader"] = "rbxassetid://10723434070",
        ["lucide-loader-2"] = "rbxassetid://10723433935",
        ["lucide-locate"] = "rbxassetid://10723434557",
        ["lucide-locate-fixed"] = "rbxassetid://10723434236",
        ["lucide-locate-off"] = "rbxassetid://10723434379",
        ["lucide-lock"] = "rbxassetid://10723434711",
        ["lucide-log-in"] = "rbxassetid://10723434830",
        ["lucide-log-out"] = "rbxassetid://10723434906",
        ["lucide-luggage"] = "rbxassetid://10723434993",
        ["lucide-magnet"] = "rbxassetid://10723435069",
        ["lucide-mail"] = "rbxassetid://10734885430",
        ["lucide-mail-check"] = "rbxassetid://10723435182",
        ["lucide-mail-minus"] = "rbxassetid://10723435261",
        ["lucide-mail-open"] = "rbxassetid://10723435342",
        ["lucide-mail-plus"] = "rbxassetid://10723435443",
        ["lucide-mail-question"] = "rbxassetid://10723435515",
        ["lucide-mail-search"] = "rbxassetid://10734884739",
        ["lucide-mail-warning"] = "rbxassetid://10734885015",
        ["lucide-mail-x"] = "rbxassetid://10734885247",
        ["lucide-mails"] = "rbxassetid://10734885614",
        ["lucide-map"] = "rbxassetid://10734886202",
        ["lucide-map-pin"] = "rbxassetid://10734886004",
        ["lucide-map-pin-off"] = "rbxassetid://10734885803",
        ["lucide-maximize"] = "rbxassetid://10734886735",
        ["lucide-maximize-2"] = "rbxassetid://10734886496",
        ["lucide-medal"] = "rbxassetid://10734887072",
        ["lucide-megaphone"] = "rbxassetid://10734887454",
        ["lucide-megaphone-off"] = "rbxassetid://10734887311",
        ["lucide-meh"] = "rbxassetid://10734887603",
        ["lucide-menu"] = "rbxassetid://10734887784",
        ["lucide-message-circle"] = "rbxassetid://10734888000",
        ["lucide-message-square"] = "rbxassetid://10734888228",
        ["lucide-mic"] = "rbxassetid://10734888864",
        ["lucide-mic-2"] = "rbxassetid://10734888430",
        ["lucide-mic-off"] = "rbxassetid://10734888646",
        ["lucide-microscope"] = "rbxassetid://10734889106",
        ["lucide-microwave"] = "rbxassetid://10734895076",
        ["lucide-milestone"] = "rbxassetid://10734895310",
        ["lucide-minimize"] = "rbxassetid://10734895698",
        ["lucide-minimize-2"] = "rbxassetid://10734895530",
        ["lucide-minus"] = "rbxassetid://10734896206",
        ["lucide-minus-circle"] = "rbxassetid://10734895856",
        ["lucide-minus-square"] = "rbxassetid://10734896029",
        ["lucide-monitor"] = "rbxassetid://10734896881",
        ["lucide-monitor-off"] = "rbxassetid://10734896360",
        ["lucide-monitor-speaker"] = "rbxassetid://10734896512",
        ["lucide-moon"] = "rbxassetid://10734897102",
        ["lucide-more-horizontal"] = "rbxassetid://10734897250",
        ["lucide-more-vertical"] = "rbxassetid://10734897387",
        ["lucide-mountain"] = "rbxassetid://10734897956",
        ["lucide-mountain-snow"] = "rbxassetid://10734897665",
        ["lucide-mouse"] = "rbxassetid://10734898592",
        ["lucide-mouse-pointer"] = "rbxassetid://10734898476",
        ["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
        ["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
        ["lucide-move"] = "rbxassetid://10734900011",
        ["lucide-move-3d"] = "rbxassetid://10734898756",
        ["lucide-move-diagonal"] = "rbxassetid://10734899164",
        ["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
        ["lucide-move-horizontal"] = "rbxassetid://10734899414",
        ["lucide-move-vertical"] = "rbxassetid://10734899821",
        ["lucide-music"] = "rbxassetid://10734905958",
        ["lucide-music-2"] = "rbxassetid://10734900215",
        ["lucide-music-3"] = "rbxassetid://10734905665",
        ["lucide-music-4"] = "rbxassetid://10734905823",
        ["lucide-navigation"] = "rbxassetid://10734906744",
        ["lucide-navigation-2"] = "rbxassetid://10734906332",
        ["lucide-navigation-2-off"] = "rbxassetid://10734906144",
        ["lucide-navigation-off"] = "rbxassetid://10734906580",
        ["lucide-network"] = "rbxassetid://10734906975",
        ["lucide-newspaper"] = "rbxassetid://10734907168",
        ["lucide-octagon"] = "rbxassetid://10734907361",
        ["lucide-option"] = "rbxassetid://10734907649",
        ["lucide-outdent"] = "rbxassetid://10734907933",
        ["lucide-package"] = "rbxassetid://10734909540",
        ["lucide-package-2"] = "rbxassetid://10734908151",
        ["lucide-package-check"] = "rbxassetid://10734908384",
        ["lucide-package-minus"] = "rbxassetid://10734908626",
        ["lucide-package-open"] = "rbxassetid://10734908793",
        ["lucide-package-plus"] = "rbxassetid://10734909016",
        ["lucide-package-search"] = "rbxassetid://10734909196",
        ["lucide-package-x"] = "rbxassetid://10734909375",
        ["lucide-paint-bucket"] = "rbxassetid://10734909847",
        ["lucide-paintbrush"] = "rbxassetid://10734910187",
        ["lucide-paintbrush-2"] = "rbxassetid://10734910030",
        ["lucide-palette"] = "rbxassetid://10734910430",
        ["lucide-palmtree"] = "rbxassetid://10734910680",
        ["lucide-paperclip"] = "rbxassetid://10734910927",
        ["lucide-party-popper"] = "rbxassetid://10734918735",
        ["lucide-pause"] = "rbxassetid://10734919336",
        ["lucide-pause-circle"] = "rbxassetid://10735024209",
        ["lucide-pause-octagon"] = "rbxassetid://10734919143",
        ["lucide-pen-tool"] = "rbxassetid://10734919503",
        ["lucide-pencil"] = "rbxassetid://10734919691",
        ["lucide-percent"] = "rbxassetid://10734919919",
        ["lucide-person-standing"] = "rbxassetid://10734920149",
        ["lucide-phone"] = "rbxassetid://10734921524",
        ["lucide-phone-call"] = "rbxassetid://10734920305",
        ["lucide-phone-forwarded"] = "rbxassetid://10734920508",
        ["lucide-phone-incoming"] = "rbxassetid://10734920694",
        ["lucide-phone-missed"] = "rbxassetid://10734920845",
        ["lucide-phone-off"] = "rbxassetid://10734921077",
        ["lucide-phone-outgoing"] = "rbxassetid://10734921288",
        ["lucide-pie-chart"] = "rbxassetid://10734921727",
        ["lucide-piggy-bank"] = "rbxassetid://10734921935",
        ["lucide-pin"] = "rbxassetid://10734922324",
        ["lucide-pin-off"] = "rbxassetid://10734922180",
        ["lucide-pipette"] = "rbxassetid://10734922497",
        ["lucide-pizza"] = "rbxassetid://10734922774",
        ["lucide-plane"] = "rbxassetid://10734922971",
        ["lucide-play"] = "rbxassetid://10734923549",
        ["lucide-play-circle"] = "rbxassetid://10734923214",
        ["lucide-plus"] = "rbxassetid://10734924532",
        ["lucide-plus-circle"] = "rbxassetid://10734923868",
        ["lucide-plus-square"] = "rbxassetid://10734924219",
        ["lucide-podcast"] = "rbxassetid://10734929553",
        ["lucide-pointer"] = "rbxassetid://10734929723",
        ["lucide-pound-sterling"] = "rbxassetid://10734929981",
        ["lucide-power"] = "rbxassetid://10734930466",
        ["lucide-power-off"] = "rbxassetid://10734930257",
        ["lucide-printer"] = "rbxassetid://10734930632",
        ["lucide-puzzle"] = "rbxassetid://10734930886",
        ["lucide-quote"] = "rbxassetid://10734931234",
        ["lucide-radio"] = "rbxassetid://10734931596",
        ["lucide-radio-receiver"] = "rbxassetid://10734931402",
        ["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
        ["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
        ["lucide-recycle"] = "rbxassetid://10734932295",
        ["lucide-redo"] = "rbxassetid://10734932822",
        ["lucide-redo-2"] = "rbxassetid://10734932586",
        ["lucide-refresh-ccw"] = "rbxassetid://10734933056",
        ["lucide-refresh-cw"] = "rbxassetid://10734933222",
        ["lucide-refrigerator"] = "rbxassetid://10734933465",
        ["lucide-regex"] = "rbxassetid://10734933655",
        ["lucide-repeat"] = "rbxassetid://10734933966",
        ["lucide-repeat-1"] = "rbxassetid://10734933826",
        ["lucide-reply"] = "rbxassetid://10734934252",
        ["lucide-reply-all"] = "rbxassetid://10734934132",
        ["lucide-rewind"] = "rbxassetid://10734934347",
        ["lucide-rocket"] = "rbxassetid://10734934585",
        ["lucide-rocking-chair"] = "rbxassetid://10734939942",
        ["lucide-rotate-3d"] = "rbxassetid://10734940107",
        ["lucide-rotate-ccw"] = "rbxassetid://10734940376",
        ["lucide-rotate-cw"] = "rbxassetid://10734940654",
        ["lucide-rss"] = "rbxassetid://10734940825",
        ["lucide-ruler"] = "rbxassetid://10734941018",
        ["lucide-russian-ruble"] = "rbxassetid://10734941199",
        ["lucide-sailboat"] = "rbxassetid://10734941354",
        ["lucide-save"] = "rbxassetid://10734941499",
        ["lucide-scale"] = "rbxassetid://10734941912",
        ["lucide-scale-3d"] = "rbxassetid://10734941739",
        ["lucide-scaling"] = "rbxassetid://10734942072",
        ["lucide-scan"] = "rbxassetid://10734942565",
        ["lucide-scan-face"] = "rbxassetid://10734942198",
        ["lucide-scan-line"] = "rbxassetid://10734942351",
        ["lucide-scissors"] = "rbxassetid://10734942778",
        ["lucide-screen-share"] = "rbxassetid://10734943193",
        ["lucide-screen-share-off"] = "rbxassetid://10734942967",
        ["lucide-scroll"] = "rbxassetid://10734943448",
        ["lucide-search"] = "rbxassetid://10734943674",
        ["lucide-send"] = "rbxassetid://10734943902",
        ["lucide-separator-horizontal"] = "rbxassetid://10734944115",
        ["lucide-separator-vertical"] = "rbxassetid://10734944326",
        ["lucide-server"] = "rbxassetid://10734949856",
        ["lucide-server-cog"] = "rbxassetid://10734944444",
        ["lucide-server-crash"] = "rbxassetid://10734944554",
        ["lucide-server-off"] = "rbxassetid://10734944668",
        ["lucide-settings"] = "rbxassetid://10734950309",
        ["lucide-settings-2"] = "rbxassetid://10734950020",
        ["lucide-share"] = "rbxassetid://10734950813",
        ["lucide-share-2"] = "rbxassetid://10734950553",
        ["lucide-sheet"] = "rbxassetid://10734951038",
        ["lucide-shield"] = "rbxassetid://10734951847",
        ["lucide-shield-alert"] = "rbxassetid://10734951173",
        ["lucide-shield-check"] = "rbxassetid://10734951367",
        ["lucide-shield-close"] = "rbxassetid://10734951535",
        ["lucide-shield-off"] = "rbxassetid://10734951684",
        ["lucide-shirt"] = "rbxassetid://10734952036",
        ["lucide-shopping-bag"] = "rbxassetid://10734952273",
        ["lucide-shopping-cart"] = "rbxassetid://10734952479",
        ["lucide-shovel"] = "rbxassetid://10734952773",
        ["lucide-shower-head"] = "rbxassetid://10734952942",
        ["lucide-shrink"] = "rbxassetid://10734953073",
        ["lucide-shrub"] = "rbxassetid://10734953241",
        ["lucide-shuffle"] = "rbxassetid://10734953451",
        ["lucide-sidebar"] = "rbxassetid://10734954301",
        ["lucide-sidebar-close"] = "rbxassetid://10734953715",
        ["lucide-sidebar-open"] = "rbxassetid://10734954000",
        ["lucide-sigma"] = "rbxassetid://10734954538",
        ["lucide-signal"] = "rbxassetid://10734961133",
        ["lucide-signal-high"] = "rbxassetid://10734954807",
        ["lucide-signal-low"] = "rbxassetid://10734955080",
        ["lucide-signal-medium"] = "rbxassetid://10734955336",
        ["lucide-signal-zero"] = "rbxassetid://10734960878",
        ["lucide-siren"] = "rbxassetid://10734961284",
        ["lucide-skip-back"] = "rbxassetid://10734961526",
        ["lucide-skip-forward"] = "rbxassetid://10734961809",
        ["lucide-skull"] = "rbxassetid://10734962068",
        ["lucide-slack"] = "rbxassetid://10734962339",
        ["lucide-slash"] = "rbxassetid://10734962600",
        ["lucide-slice"] = "rbxassetid://10734963024",
        ["lucide-sliders"] = "rbxassetid://10734963400",
        ["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
        ["lucide-smartphone"] = "rbxassetid://10734963940",
        ["lucide-smartphone-charging"] = "rbxassetid://10734963671",
        ["lucide-smile"] = "rbxassetid://10734964441",
        ["lucide-smile-plus"] = "rbxassetid://10734964188",
        ["lucide-snowflake"] = "rbxassetid://10734964600",
        ["lucide-sofa"] = "rbxassetid://10734964852",
        ["lucide-sort-asc"] = "rbxassetid://10734965115",
        ["lucide-sort-desc"] = "rbxassetid://10734965287",
        ["lucide-speaker"] = "rbxassetid://10734965419",
        ["lucide-sprout"] = "rbxassetid://10734965572",
        ["lucide-square"] = "rbxassetid://10734965702",
        ["lucide-star"] = "rbxassetid://10734966248",
        ["lucide-star-half"] = "rbxassetid://10734965897",
        ["lucide-star-off"] = "rbxassetid://10734966097",
        ["lucide-stethoscope"] = "rbxassetid://10734966384",
        ["lucide-sticker"] = "rbxassetid://10734972234",
        ["lucide-sticky-note"] = "rbxassetid://10734972463",
        ["lucide-stop-circle"] = "rbxassetid://10734972621",
        ["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
        ["lucide-stretch-vertical"] = "rbxassetid://10734973130",
        ["lucide-strikethrough"] = "rbxassetid://10734973290",
        ["lucide-subscript"] = "rbxassetid://10734973457",
        ["lucide-sun"] = "rbxassetid://10734974297",
        ["lucide-sun-dim"] = "rbxassetid://10734973645",
        ["lucide-sun-medium"] = "rbxassetid://10734973778",
        ["lucide-sun-moon"] = "rbxassetid://10734973999",
        ["lucide-sun-snow"] = "rbxassetid://10734974130",
        ["lucide-sunrise"] = "rbxassetid://10734974522",
        ["lucide-sunset"] = "rbxassetid://10734974689",
        ["lucide-superscript"] = "rbxassetid://10734974850",
        ["lucide-swiss-franc"] = "rbxassetid://10734975024",
        ["lucide-switch-camera"] = "rbxassetid://10734975214",
        ["lucide-sword"] = "rbxassetid://10734975486",
        ["lucide-swords"] = "rbxassetid://10734975692",
        ["lucide-syringe"] = "rbxassetid://10734975932",
        ["lucide-table"] = "rbxassetid://10734976230",
        ["lucide-table-2"] = "rbxassetid://10734976097",
        ["lucide-tablet"] = "rbxassetid://10734976394",
        ["lucide-tag"] = "rbxassetid://10734976528",
        ["lucide-tags"] = "rbxassetid://10734976739",
        ["lucide-target"] = "rbxassetid://10734977012",
        ["lucide-tent"] = "rbxassetid://10734981750",
        ["lucide-terminal"] = "rbxassetid://10734982144",
        ["lucide-terminal-square"] = "rbxassetid://10734981995",
        ["lucide-text-cursor"] = "rbxassetid://10734982395",
        ["lucide-text-cursor-input"] = "rbxassetid://10734982297",
        ["lucide-thermometer"] = "rbxassetid://10734983134",
        ["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
        ["lucide-thermometer-sun"] = "rbxassetid://10734982771",
        ["lucide-thumbs-down"] = "rbxassetid://10734983359",
        ["lucide-thumbs-up"] = "rbxassetid://10734983629",
        ["lucide-ticket"] = "rbxassetid://10734983868",
        ["lucide-timer"] = "rbxassetid://10734984606",
        ["lucide-timer-off"] = "rbxassetid://10734984138",
        ["lucide-timer-reset"] = "rbxassetid://10734984355",
        ["lucide-toggle-left"] = "rbxassetid://10734984834",
        ["lucide-toggle-right"] = "rbxassetid://10734985040",
        ["lucide-tornado"] = "rbxassetid://10734985247",
        ["lucide-toy-brick"] = "rbxassetid://10747361919",
        ["lucide-train"] = "rbxassetid://10747362105",
        ["lucide-trash"] = "rbxassetid://10747362393",
        ["lucide-trash-2"] = "rbxassetid://10747362241",
        ["lucide-tree-deciduous"] = "rbxassetid://10747362534",
        ["lucide-tree-pine"] = "rbxassetid://10747362748",
        ["lucide-trees"] = "rbxassetid://10747363016",
        ["lucide-trending-down"] = "rbxassetid://10747363205",
        ["lucide-trending-up"] = "rbxassetid://10747363465",
        ["lucide-triangle"] = "rbxassetid://10747363621",
        ["lucide-trophy"] = "rbxassetid://10747363809",
        ["lucide-truck"] = "rbxassetid://10747364031",
        ["lucide-tv"] = "rbxassetid://10747364593",
        ["lucide-tv-2"] = "rbxassetid://10747364302",
        ["lucide-type"] = "rbxassetid://10747364761",
        ["lucide-umbrella"] = "rbxassetid://10747364971",
        ["lucide-underline"] = "rbxassetid://10747365191",
        ["lucide-undo"] = "rbxassetid://10747365484",
        ["lucide-undo-2"] = "rbxassetid://10747365359",
        ["lucide-unlink"] = "rbxassetid://10747365771",
        ["lucide-unlink-2"] = "rbxassetid://10747397871",
        ["lucide-unlock"] = "rbxassetid://10747366027",
        ["lucide-upload"] = "rbxassetid://10747366434",
        ["lucide-upload-cloud"] = "rbxassetid://10747366266",
        ["lucide-usb"] = "rbxassetid://10747366606",
        ["lucide-user"] = "rbxassetid://10747373176",
        ["lucide-user-check"] = "rbxassetid://10747371901",
        ["lucide-user-cog"] = "rbxassetid://10747372167",
        ["lucide-user-minus"] = "rbxassetid://10747372346",
        ["lucide-user-plus"] = "rbxassetid://10747372702",
        ["lucide-user-x"] = "rbxassetid://10747372992",
        ["lucide-users"] = "rbxassetid://10747373426",
        ["lucide-utensils"] = "rbxassetid://10747373821",
        ["lucide-utensils-crossed"] = "rbxassetid://10747373629",
        ["lucide-venetian-mask"] = "rbxassetid://10747374003",
        ["lucide-verified"] = "rbxassetid://10747374131",
        ["lucide-vibrate"] = "rbxassetid://10747374489",
        ["lucide-vibrate-off"] = "rbxassetid://10747374269",
        ["lucide-video"] = "rbxassetid://10747374938",
        ["lucide-video-off"] = "rbxassetid://10747374721",
        ["lucide-view"] = "rbxassetid://10747375132",
        ["lucide-voicemail"] = "rbxassetid://10747375281",
        ["lucide-volume"] = "rbxassetid://10747376008",
        ["lucide-volume-1"] = "rbxassetid://10747375450",
        ["lucide-volume-2"] = "rbxassetid://10747375679",
        ["lucide-volume-x"] = "rbxassetid://10747375880",
        ["lucide-wallet"] = "rbxassetid://10747376205",
        ["lucide-wand"] = "rbxassetid://10747376565",
        ["lucide-wand-2"] = "rbxassetid://10747376349",
        ["lucide-watch"] = "rbxassetid://10747376722",
        ["lucide-waves"] = "rbxassetid://10747376931",
        ["lucide-webcam"] = "rbxassetid://10747381992",
        ["lucide-wifi"] = "rbxassetid://10747382504",
        ["lucide-wifi-off"] = "rbxassetid://10747382268",
        ["lucide-wind"] = "rbxassetid://10747382750",
        ["lucide-wrap-text"] = "rbxassetid://10747383065",
        ["lucide-wrench"] = "rbxassetid://10747383470",
        ["lucide-x"] = "rbxassetid://10747384394",
        ["lucide-x-circle"] = "rbxassetid://10747383819",
        ["lucide-x-octagon"] = "rbxassetid://10747384037",
        ["lucide-x-square"] = "rbxassetid://10747384217",
        ["lucide-zoom-in"] = "rbxassetid://10747384552",
        ["lucide-zoom-out"] = "rbxassetid://10747384679",
    }
}

-- Convenient direct access table for legacy calls like Icons.Visuals, Icons.Shield, etc.
setmetatable(Icons, {
    __index = function(tbl, key)
        if rawget(tbl, key) then return rawget(tbl, key) end
        return tbl.Get(key)
    end
})

-- Smart Icon Resolver Function
function Icons.Get(name)
    if not name or name == "" then return Icons.Default end
    if typeof(name) == "number" then return "rbxassetid://" .. tostring(name) end
    local strName = tostring(name)
    if string.sub(strName, 1, 13) == "rbxassetid://" then return strName end

    local originalLower = strName:lower()
    local cleanKey = originalLower:gsub("^lucide%-", ""):gsub("[%s%_%-]", "")

    -- 1. Direct match in Assets with lucide- prefix
    if Icons.Assets["lucide-" .. originalLower] then
        return Icons.Assets["lucide-" .. originalLower]
    end

    -- 2. Direct match in Assets without prefix
    if Icons.Assets[originalLower] then
        return Icons.Assets[originalLower]
    end

    -- 3. Check Aliases
    if Icons.Aliases[originalLower] then
        local alias = Icons.Aliases[originalLower]
        if Icons.Assets[alias] then return Icons.Assets[alias] end
    end
    if Icons.Aliases[cleanKey] then
        local alias = Icons.Aliases[cleanKey]
        if Icons.Assets[alias] then return Icons.Assets[alias] end
    end

    -- 4. Fuzzy search across Assets keys
    for key, asset in pairs(Icons.Assets) do
        local testKey = key:gsub("^lucide%-", ""):gsub("[%s%_%-]", "")
        if testKey == cleanKey then
            return asset
        end
    end

    -- 5. Fallback icon (never return empty or nil!)
    return Icons.Default
end

return Icons

end)()

-- ==============================================================================
-- DRAGGING UTILITIES
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
-- TOAST NOTIFICATIONS
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
    list.Padding = UDim.new(0, 10)
    list.Parent = frame

    NotifyContainer = frame
    return NotifyContainer
end

function VRSLibV2:Notify(cfg)
    cfg = cfg or {}
    local title = tostring(cfg.Title or "VRS Artelier V2")
    local desc  = tostring(cfg.Description or cfg.Content or "")
    local dur   = tonumber(cfg.Duration) or 3.5
    local iconId = VRSLibV2.Icons.Get(cfg.Icon or "home")

    local container = EnsureNotifyContainer()

    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(1, 0, 0, 62)
    toast.Position = UDim2.new(1, 350, 0, 0)
    toast.BackgroundColor3 = VRSLibV2.Theme.Card
    toast.BackgroundTransparency = VRSLibV2.Theme.CardTrans
    toast.BorderSizePixel = 0
    toast.ClipsDescendants = true
    toast.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toast

    local stroke = Instance.new("UIStroke")
    stroke.Color = VRSLibV2.Theme.CardStroke
    stroke.Transparency = VRSLibV2.Theme.CardStrokeTrans
    stroke.Thickness = 1
    stroke.Parent = toast

    ApplyGlassSpecular(toast)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, -12)
    bar.Position = UDim2.new(0, 4, 0.5, -25)
    bar.BackgroundColor3 = VRSLibV2.Theme.Accent
    bar.BorderSizePixel = 0
    bar.ZIndex = 2
    bar.Parent = toast

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(1, 0)
    bCorner.Parent = bar

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.fromOffset(24, 24)
    icon.Position = UDim2.new(0, 18, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = VRSLibV2.Theme.Accent
    icon.ZIndex = 2
    icon.Parent = toast

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -60, 0, 18)
    tLbl.Position = UDim2.new(0, 52, 0, 12)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 13.5
    tLbl.TextColor3 = VRSLibV2.Theme.TextPrimary
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.ZIndex = 2
    tLbl.Parent = toast
    ProtectLocalization(tLbl)

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(1, -60, 0, 16)
    dLbl.Position = UDim2.new(0, 52, 0, 32)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = desc
    dLbl.Font = Enum.Font.GothamMedium
    dLbl.TextSize = 11.5
    dLbl.TextColor3 = VRSLibV2.Theme.TextSecondary
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.TextTruncate = Enum.TextTruncate.AtEnd
    dLbl.ZIndex = 2
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
    if self.ShadowFrame then self.ShadowFrame.Visible = self.Visible end
    if self.FloatingToggle then self.FloatingToggle.Visible = not self.Visible end
    if self.Visible then
        EnableGlassBlur()
    else
        DisableGlassBlur()
    end
end

function Window:Unload()
    DisableGlassBlur()
    if self.OnUnload then pcall(self.OnUnload) end
    if self.Gui then self.Gui:Destroy() end
    if NotifyContainer and NotifyContainer.Parent then
        pcall(function() NotifyContainer.Parent:Destroy() end)
    end
end

-- ==============================================================================

-- ==============================================================================
-- OFFICIAL VRS ARTELIER BRAND LOGO
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

local function ApplyBrandLogo(imageLabel, customLogo)
    if customLogo and customLogo ~= "" and customLogo ~= "wings" and customLogo ~= "default" then
        if typeof(customLogo) == "number" then
            imageLabel.Image = "rbxassetid://" .. tostring(customLogo)
            imageLabel.ImageRectOffset = Vector2.new(0, 0)
            imageLabel.ImageRectSize = Vector2.new(0, 0)
            imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
            return
        elseif typeof(customLogo) == "string" then
            if customLogo:sub(1, 13) == "rbxassetid://" or customLogo:find("/") then
                imageLabel.Image = customLogo
                imageLabel.ImageRectOffset = Vector2.new(0, 0)
                imageLabel.ImageRectSize = Vector2.new(0, 0)
                imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
                return
            end
        end
    end

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

-- CREATE WINDOW CONSTRUCTOR
-- ==============================================================================
function VRSLibV2:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, Window)

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
    end

    local safeContainer = GetSafeContainer()

    -- Exhaustive Multi-Instance Cleanup (Kills duplicate & ghost windows across all contexts)
    pcall(function()
        if _G.VRS_UNLOAD then _G.VRS_UNLOAD() end
        if _G.VRSV2_UNLOAD then _G.VRSV2_UNLOAD() end
    end)

    local candidateContainers = {}
    pcall(function() if gethui then table.insert(candidateContainers, gethui()) end end)
    pcall(function() if CoreGui then table.insert(candidateContainers, CoreGui) end end)
    pcall(function()
        if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
            table.insert(candidateContainers, LocalPlayer.PlayerGui)
        end
    end)

    for _, container in ipairs(candidateContainers) do
        pcall(function()
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("ScreenGui") then
                    local nm = child.Name:lower()
                    if nm:find("vrs") or nm:find("artelier") or nm:find("slayers") then
                        child:Destroy()
                    end
                end
            end
        end)
    end

    EnableGlassBlur()

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VRSLibV2_Engine"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = safeContainer
    self.Gui = ScreenGui

    ScreenGui.DescendantAdded:Connect(ProtectLocalization)

    -- Ambient Drop Shadow
    local ShadowFrame = Instance.new("Frame")
    ShadowFrame.Name = "WindowShadow"
    ShadowFrame.Size = self.Size + UDim2.fromOffset(28, 28)
    ShadowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ShadowFrame.Position = UDim2.new(0.5, 0, 0.5, 4)
    ShadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ShadowFrame.BackgroundTransparency = 0.5
    ShadowFrame.BorderSizePixel = 0
    ShadowFrame.ZIndex = 1
    ShadowFrame.Parent = ScreenGui
    self.ShadowFrame = ShadowFrame

    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 22)
    ShadowCorner.Parent = ShadowFrame

    -- Main Shell Canvas (Holds Detached Floating Sidebar + Main Window)
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = self.Size
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundTransparency = 1
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.ClipsDescendants = false
    Main.ZIndex = 2
    Main.Parent = ScreenGui
    self.MainFrame = Main

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
    -- 1:1 DETACHED FLOATING SIDEBAR CAPSULE (70px width, Rounded All 4 Corners)
    -- ==============================================================================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 70, 1, 0)
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    Sidebar.BackgroundTransparency = 0
    Sidebar.BorderSizePixel = 0
    Sidebar.ClipsDescendants = false
    Sidebar.ZIndex = 3
    Sidebar.Parent = Main
    self.Sidebar = Sidebar

    local SBCorner = Instance.new("UICorner")
    SBCorner.CornerRadius = UDim.new(0, 16)
    SBCorner.Parent = Sidebar

    local SBStroke = Instance.new("UIStroke")
    SBStroke.Color = Color3.fromRGB(48, 52, 68)
    SBStroke.Transparency = 0.65
    SBStroke.Thickness = 1.2
    SBStroke.Parent = Sidebar

    ApplyGlassSpecular(Sidebar)

    -- Top Logo Emblem (Swirl / Ouroboros Emblem)
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Name = "LogoContainer"
    LogoContainer.Size = UDim2.new(1, 0, 0, 68)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Parent = Sidebar

    local LogoBadge = Instance.new("Frame")
    LogoBadge.Size = UDim2.fromOffset(44, 44)
    LogoBadge.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoBadge.Position = UDim2.new(0.5, 0, 0.5, 2)
    LogoBadge.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
    LogoBadge.BackgroundTransparency = 0.4
    LogoBadge.BorderSizePixel = 0
    LogoBadge.Parent = LogoContainer

    local LBCorner = Instance.new("UICorner")
    LBCorner.CornerRadius = UDim.new(0, 12)
    LBCorner.Parent = LogoBadge

    local LBStroke = Instance.new("UIStroke")
    LBStroke.Color = Color3.fromRGB(50, 55, 75)
    LBStroke.Transparency = 0.6
    LBStroke.Thickness = 1
    LBStroke.Parent = LogoBadge

    ApplyGlassSpecular(LogoBadge)

    local LogoImg = Instance.new("ImageLabel")
    LogoImg.Name = "BrandLogo"
    LogoImg.Size = UDim2.fromOffset(26, 26)
    LogoImg.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogoImg.BackgroundTransparency = 1
    LogoImg.ScaleType = Enum.ScaleType.Fit
    LogoImg.ZIndex = 5
    LogoImg.Parent = LogoBadge
    ApplyBrandLogo(LogoImg, config.Logo)

    LogoContainer.MouseEnter:Connect(function()
        TweenService:Create(LBStroke, TweenInfo.new(0.2), { Color = VRSLibV2.Theme.Accent, Transparency = 0.2 }):Play()
        TweenService:Create(LogoImg, TweenInfo.new(0.2), { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
    end)
    LogoContainer.MouseLeave:Connect(function()
        TweenService:Create(LBStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(50, 55, 75), Transparency = 0.6 }):Play()
        TweenService:Create(LogoImg, TweenInfo.new(0.2), { ImageColor3 = VRSLibV2.Theme.Accent }):Play()
    end)

    -- Tab Buttons Scroll
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Size = UDim2.new(1, 0, 1, -150)
    TabScroll.Position = UDim2.new(0, 0, 0, 70)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.ClipsDescendants = false
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 240)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabScroll.Parent = Sidebar
    self.TabScroll = TabScroll

    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Padding = UDim.new(0, 6)
    TabList.Parent = TabScroll

    -- Bottom User Profile Capsule (2-line Avatar footer matching screenshot!)
    local UserProfileBar = Instance.new("Frame")
    UserProfileBar.Name = "UserProfileBar"
    UserProfileBar.Size = UDim2.new(1, 0, 0, 74)
    UserProfileBar.Position = UDim2.new(0, 0, 1, -74)
    UserProfileBar.BackgroundColor3 = VRSLibV2.Theme.Sidebar
    UserProfileBar.BackgroundTransparency = 1
    UserProfileBar.BorderSizePixel = 0
    UserProfileBar.Parent = Sidebar

    local UPBorder = Instance.new("Frame")
    UPBorder.Size = UDim2.new(1, 0, 0, 1)
    UPBorder.BackgroundColor3 = VRSLibV2.Theme.CardStroke
    UPBorder.BackgroundTransparency = VRSLibV2.Theme.CardStrokeTrans
    UPBorder.BorderSizePixel = 0
    UPBorder.Parent = UserProfileBar

    local AvatarBox = Instance.new("Frame")
    AvatarBox.Size = UDim2.fromOffset(36, 36)
    AvatarBox.Position = UDim2.new(0.5, -18, 0, 6)
    AvatarBox.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
    AvatarBox.BorderSizePixel = 0
    AvatarBox.Parent = UserProfileBar

    local ABCorner = Instance.new("UICorner")
    ABCorner.CornerRadius = UDim.new(1, 0)
    ABCorner.Parent = AvatarBox

    local ABStroke = Instance.new("UIStroke")
    ABStroke.Color = Color3.fromRGB(55, 60, 80)
    ABStroke.Transparency = 0.5
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
    OnlineDot.ZIndex = 2
    OnlineDot.Parent = AvatarBox

    local ODCorner = Instance.new("UICorner")
    ODCorner.CornerRadius = UDim.new(1, 0)
    ODCorner.Parent = OnlineDot

    local ODStroke = Instance.new("UIStroke")
    ODStroke.Color = VRSLibV2.Theme.Sidebar
    ODStroke.Thickness = 1.5
    ODStroke.Parent = OnlineDot

    -- Line 1: Username Truncated (e.g. "NcangRowe...")
    local UNameLbl = Instance.new("TextLabel")
    UNameLbl.Size = UDim2.new(1, -4, 0, 13)
    UNameLbl.Position = UDim2.new(0, 2, 0, 44)
    UNameLbl.BackgroundTransparency = 1
    local rawName = tostring(LocalPlayer.DisplayName or LocalPlayer.Name)
    UNameLbl.Text = (#rawName > 9) and (rawName:sub(1, 8) .. "..") or rawName
    UNameLbl.Font = Enum.Font.GothamBold
    UNameLbl.TextSize = 9.5
    UNameLbl.TextColor3 = VRSLibV2.Theme.TextPrimary
    UNameLbl.TextXAlignment = Enum.TextXAlignment.Center
    UNameLbl.Parent = UserProfileBar
    ProtectLocalization(UNameLbl)

    -- Line 2: Game Name Subtitle (e.g. "Slayers 2")
    local UGameLbl = Instance.new("TextLabel")
    UGameLbl.Size = UDim2.new(1, -4, 0, 11)
    UGameLbl.Position = UDim2.new(0, 2, 0, 58)
    UGameLbl.BackgroundTransparency = 1
    UGameLbl.Text = self.GameName
    UGameLbl.Font = Enum.Font.GothamMedium
    UGameLbl.TextSize = 8.5
    UGameLbl.TextColor3 = VRSLibV2.Theme.TextMuted
    UGameLbl.TextXAlignment = Enum.TextXAlignment.Center
    UGameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    UGameLbl.Parent = UserProfileBar
    ProtectLocalization(UGameLbl)

    -- ==============================================================================
    -- 2. DETACHED FLOATING MAIN WINDOW CONTAINER (With 12px Gap & Rounded Corners)
    -- ==============================================================================
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(1, -82, 1, 0)
    MainContainer.Position = UDim2.new(0, 82, 0, 0)
    MainContainer.BackgroundColor3 = Color3.fromRGB(15, 16, 21)
    MainContainer.BackgroundTransparency = 0
    MainContainer.BorderSizePixel = 0
    MainContainer.ClipsDescendants = true
    MainContainer.ZIndex = 3
    MainContainer.Parent = Main
    self.MainContainer = MainContainer

    local MCCorner = Instance.new("UICorner")
    MCCorner.CornerRadius = UDim.new(0, 16)
    MCCorner.Parent = MainContainer

    local MCStroke = Instance.new("UIStroke")
    MCStroke.Color = Color3.fromRGB(48, 52, 68)
    MCStroke.Transparency = 0.65
    MCStroke.Thickness = 1.2
    MCStroke.Parent = MainContainer

    ApplyGlassSpecular(MainContainer)

    -- ==============================================================================
    -- 3. TWO-TIER TOPBAR (1:1 with Screenshot 2)
    -- Row 1 (42px): Title Left, Search + Minimize Right
    -- Row 2 (36px): Sub-Nav Pills Left ([ ⊞ Overview ]  [ ▷ Main Menu ])
    -- ==============================================================================
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 78)
    Topbar.Position = UDim2.new(0, 0, 0, 0)
    Topbar.BackgroundTransparency = 1
    Topbar.BorderSizePixel = 0
    Topbar.ZIndex = 4
    Topbar.Parent = MainContainer
    self.Topbar = Topbar

    local TopbarBorder = Instance.new("Frame")
    TopbarBorder.Size = UDim2.new(1, 0, 0, 1)
    TopbarBorder.Position = UDim2.new(0, 0, 1, -1)
    TopbarBorder.BackgroundColor3 = Color3.fromRGB(48, 52, 68)
    TopbarBorder.BackgroundTransparency = 0.75
    TopbarBorder.BorderSizePixel = 0
    TopbarBorder.ZIndex = 4
    TopbarBorder.Parent = Topbar

    MakeDraggable(Topbar, Main)
    MakeDraggable(Sidebar, Main)

    -- --- ROW 1: HEADER TOP ---
    local HeaderTop = Instance.new("Frame")
    HeaderTop.Name = "HeaderTop"
    HeaderTop.Size = UDim2.new(1, 0, 0, 42)
    HeaderTop.Position = UDim2.new(0, 0, 0, 0)
    HeaderTop.BackgroundTransparency = 1
    HeaderTop.ZIndex = 4
    HeaderTop.Parent = Topbar

    local HeaderLeft = Instance.new("Frame")
    HeaderLeft.Name = "HeaderLeft"
    HeaderLeft.Size = UDim2.new(1, -260, 1, 0)
    HeaderLeft.Position = UDim2.new(0, 18, 0, 0)
    HeaderLeft.BackgroundTransparency = 1
    HeaderLeft.ZIndex = 4
    HeaderLeft.Parent = HeaderTop

    local HLList = Instance.new("UIListLayout")
    HLList.FillDirection = Enum.FillDirection.Horizontal
    HLList.VerticalAlignment = Enum.VerticalAlignment.Center
    HLList.Padding = UDim.new(0, 10)
    HLList.Parent = HeaderLeft

    local HeaderIcon = Instance.new("ImageLabel")
    HeaderIcon.Name = "HeaderIcon"
    HeaderIcon.Size = UDim2.fromOffset(20, 20)
    HeaderIcon.BackgroundTransparency = 1
    HeaderIcon.Image = VRSLibV2.Icons.Get("home")
    HeaderIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    HeaderIcon.ZIndex = 5
    HeaderIcon.Parent = HeaderLeft
    self.HeaderIcon = HeaderIcon

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Name = "HeaderTitle"
    HeaderTitle.Size = UDim2.new(0, 0, 1, 0)
    HeaderTitle.AutomaticSize = Enum.AutomaticSize.X
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Text = self.Title
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.TextSize = 15.5
    HeaderTitle.TextColor3 = Color3.fromRGB(248, 250, 255)
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.ZIndex = 5
    HeaderTitle.Parent = HeaderLeft
    ProtectLocalization(HeaderTitle)
    self.HeaderTitle = HeaderTitle

    -- Row 1 Right: Search + Minimize
    local HeaderRight = Instance.new("Frame")
    HeaderRight.Name = "HeaderRight"
    HeaderRight.Size = UDim2.new(0, 240, 1, 0)
    HeaderRight.Position = UDim2.new(1, -240, 0, 0)
    HeaderRight.BackgroundTransparency = 1
    HeaderRight.ZIndex = 4
    HeaderRight.Parent = HeaderTop

    local HRList = Instance.new("UIListLayout")
    HRList.FillDirection = Enum.FillDirection.Horizontal
    HRList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    HRList.VerticalAlignment = Enum.VerticalAlignment.Center
    HRList.Padding = UDim.new(0, 12)
    HRList.Parent = HeaderRight

    local HRPadding = Instance.new("UIPadding")
    HRPadding.PaddingRight = UDim.new(0, 18)
    HRPadding.Parent = HeaderRight

    -- Search Input Capsule
    local SearchBox = Instance.new("Frame")
    SearchBox.Name = "SearchBox"
    SearchBox.Size = UDim2.new(0, 150, 0, 28)
    SearchBox.BackgroundColor3 = Color3.fromRGB(18, 20, 27)
    SearchBox.BackgroundTransparency = 0.35
    SearchBox.BorderSizePixel = 0
    SearchBox.ZIndex = 5
    SearchBox.Parent = HeaderRight

    local SBCorner = Instance.new("UICorner")
    SBCorner.CornerRadius = UDim.new(0, 6)
    SBCorner.Parent = SearchBox

    local SBStroke = Instance.new("UIStroke")
    SBStroke.Color = Color3.fromRGB(44, 48, 64)
    SBStroke.Thickness = 1
    SBStroke.Parent = SearchBox

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.fromOffset(13, 13)
    SearchIcon.Position = UDim2.new(0, 10, 0.5, -6.5)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = VRSLibV2.Icons.Get("search")
    SearchIcon.ImageColor3 = Color3.fromRGB(130, 135, 155)
    SearchIcon.ZIndex = 5
    SearchIcon.Parent = SearchBox

    local SearchInput = Instance.new("TextBox")
    SearchInput.Size = UDim2.new(1, -34, 1, 0)
    SearchInput.Position = UDim2.new(0, 28, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.Font = Enum.Font.GothamMedium
    SearchInput.PlaceholderText = "Search"
    SearchInput.PlaceholderColor3 = Color3.fromRGB(120, 125, 145)
    SearchInput.Text = ""
    SearchInput.TextColor3 = Color3.fromRGB(248, 250, 255)
    SearchInput.TextSize = 12
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.ClearTextOnFocus = false
    SearchInput.ZIndex = 5
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

    -- Window Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.fromOffset(26, 26)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Text = ""
    MinimizeBtn.ZIndex = 5
    MinimizeBtn.Parent = HeaderRight

    local MinIcon = Instance.new("ImageLabel")
    MinIcon.Size = UDim2.fromOffset(13, 13)
    MinIcon.Position = UDim2.new(0.5, -6.5, 0.5, -6.5)
    MinIcon.BackgroundTransparency = 1
    MinIcon.Image = VRSLibV2.Icons.Get("minus")
    MinIcon.ImageColor3 = Color3.fromRGB(140, 145, 165)
    MinIcon.ZIndex = 5
    MinIcon.Parent = MinimizeBtn

    MinimizeBtn.MouseEnter:Connect(function()
        TweenService:Create(MinIcon, TweenInfo.new(0.15), { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        TweenService:Create(MinIcon, TweenInfo.new(0.15), { ImageColor3 = Color3.fromRGB(140, 145, 165) }):Play()
    end)
    MinimizeBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)

    -- --- ROW 2: SUB-NAV PILLS (Positioned under Title matching Screenshot 2!) ---
    local SubNavRow = Instance.new("Frame")
    SubNavRow.Name = "SubNavRow"
    SubNavRow.Size = UDim2.new(1, 0, 0, 36)
    SubNavRow.Position = UDim2.new(0, 0, 0, 42)
    SubNavRow.BackgroundTransparency = 1
    SubNavRow.ZIndex = 4
    SubNavRow.Parent = Topbar

    local SubNavPills = Instance.new("Frame")
    SubNavPills.Name = "SubNavPills"
    SubNavPills.Size = UDim2.new(1, -36, 1, 0)
    SubNavPills.Position = UDim2.new(0, 18, 0, 0)
    SubNavPills.BackgroundTransparency = 1
    SubNavPills.ZIndex = 4
    SubNavPills.Parent = SubNavRow
    self.SubNavPills = SubNavPills

    local SNPList = Instance.new("UIListLayout")
    SNPList.SortOrder = Enum.SortOrder.LayoutOrder
    SNPList.FillDirection = Enum.FillDirection.Horizontal
    SNPList.VerticalAlignment = Enum.VerticalAlignment.Center
    SNPList.Padding = UDim.new(0, 8)
    SNPList.Parent = SubNavPills

    -- ==============================================================================
    -- 4. MAIN CONTENT CONTAINER (Starts cleanly at Y=78)
    -- ==============================================================================
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 1, -78)
    Content.Position = UDim2.new(0, 0, 0, 78)
    Content.BackgroundTransparency = 1
    Content.ZIndex = 4
    Content.Parent = MainContainer
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
-- TAB BUILDER & NAVIGATION (1:1 SCREENSHOT NAVIGATION ENGINE)
-- ==============================================================================
function Window:AddTab(config)
    config = config or {}
    local tabName = config.Name or "Tab"
    local iconId  = VRSLibV2.Icons.Get(config.Icon or "home")

    -- Tab Button in 70px Sidebar (54x50px)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = "TabBtn_" .. tabName
    TabBtn.Size = UDim2.new(0, 54, 0, 50)
    TabBtn.BackgroundColor3 = VRSLibV2.Theme.SidebarActiveBtn
    TabBtn.BackgroundTransparency = 1
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = ""
    TabBtn.LayoutOrder = config.LayoutOrder or (#self.Tabs + 1)
    TabBtn.Parent = self.TabScroll

    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(0, 10)
    TBCorner.Parent = TabBtn

    local TBStroke = Instance.new("UIStroke")
    TBStroke.Color = Color3.fromRGB(50, 55, 75)
    TBStroke.Transparency = 1
    TBStroke.Thickness = 1
    TBStroke.Parent = TabBtn

    -- 1:1 RECREATION: White Vertical Pill Indicator on the INNER LEFT EDGE OF THE BUTTON!
    local Indicator = Instance.new("Frame")
    Indicator.Name = "ActiveIndicator"
    Indicator.Size = UDim2.new(0, 3.5, 0, 22)
    Indicator.Position = UDim2.new(0, 0, 0.5, -11)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Indicator.BorderSizePixel = 0
    Indicator.Visible = false
    Indicator.ZIndex = 6
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
    TabLabel.Size = UDim2.new(1, 0, 0, 14)
    TabLabel.Position = UDim2.new(0, 0, 0, 29)
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
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(60, 65, 85)
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabPage.Visible = false
    TabPage.Parent = self.Content

    local TPPadding = Instance.new("UIPadding")
    TPPadding.PaddingLeft = UDim.new(0, 20)
    TPPadding.PaddingRight = UDim.new(0, 20)
    TPPadding.PaddingTop = UDim.new(0, 16)
    TPPadding.PaddingBottom = UDim.new(0, 26)
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
        Stroke    = TBStroke,
        Icon      = TabIcon,
        Label     = TabLabel,
        Indicator = Indicator,
        Page      = TabPage,
        SubTabs   = {},
    }

    TabBtn.MouseEnter:Connect(function()
        if self.ActiveTab ~= TabObj then
            TweenService:Create(TabBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.6, BackgroundColor3 = Color3.fromRGB(28, 30, 42) }):Play()
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
            TweenService:Create(t.Button, TweenInfo.new(0.15), { BackgroundTransparency = VRSLibV2.Theme.SidebarActiveTrans, BackgroundColor3 = VRSLibV2.Theme.SidebarActiveBtn }):Play()
            TweenService:Create(t.Stroke, TweenInfo.new(0.15), { Transparency = 0.55 }):Play()
            TweenService:Create(t.Icon, TweenInfo.new(0.15), { ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
            TweenService:Create(t.Label, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(255, 255, 255) }):Play()
            self.HeaderIcon.Image = t.IconId
            if self.HeaderTitle then
                self.HeaderTitle.Text = (t.Name == "Home" and self.Title or t.Name)
            end
        else
            TweenService:Create(t.Button, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(t.Stroke, TweenInfo.new(0.15), { Transparency = 1 }):Play()
            TweenService:Create(t.Icon, TweenInfo.new(0.15), { ImageColor3 = VRSLibV2.Theme.TextMuted }):Play()
            TweenService:Create(t.Label, TweenInfo.new(0.15), { TextColor3 = VRSLibV2.Theme.TextMuted }):Play()
        end
    end

    self:RenderSubNavPills(targetTab)
end

-- Horizontal Sub-Nav Pills Manager
function Window:RenderSubNavPills(tabObj)
    for _, ch in ipairs(self.SubNavPills:GetChildren()) do
        if ch:IsA("TextButton") then ch:Destroy() end
    end

    if #tabObj.SubTabs > 0 then
        for idx, sub in ipairs(tabObj.SubTabs) do
            local pill = Instance.new("TextButton")
            pill.Name = "Pill_" .. sub.Name
            pill.Size = UDim2.new(0, 0, 0, 28)
            pill.AutomaticSize = Enum.AutomaticSize.X
            pill.BackgroundColor3 = Color3.fromRGB(28, 31, 44)
            pill.BackgroundTransparency = (sub.Active and 0.25 or 1)
            pill.BorderSizePixel = 0
            pill.Text = ""
            pill.AutoButtonColor = false
            pill.LayoutOrder = sub.LayoutOrder or idx
            pill.ZIndex = 5
            pill.Parent = self.SubNavPills

            local pCorner = Instance.new("UICorner")
            pCorner.CornerRadius = UDim.new(0, 6)
            pCorner.Parent = pill

            local pStroke = Instance.new("UIStroke")
            pStroke.Color = Color3.fromRGB(55, 60, 80)
            pStroke.Transparency = (sub.Active and 0.45 or 1)
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
                pIcon.Size = UDim2.fromOffset(14, 14)
                pIcon.BackgroundTransparency = 1
                pIcon.Image = VRSLibV2.Icons.Get(sub.Icon)
                pIcon.ImageColor3 = (sub.Active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 155, 175))
                pIcon.ZIndex = 5
                pIcon.Parent = pill
            end

            local pText = Instance.new("TextLabel")
            pText.Size = UDim2.new(0, 0, 1, 0)
            pText.AutomaticSize = Enum.AutomaticSize.X
            pText.BackgroundTransparency = 1
            pText.Text = sub.Name
            pText.Font = Enum.Font.GothamBold
            pText.TextSize = 11.5
            pText.TextColor3 = (sub.Active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 155, 175))
            pText.ZIndex = 5
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

    function TabObj:AddSubTab(cfg)
        cfg = cfg or {}
        local subName = cfg.Name or "SubTab"
        local isFirst = (#self.SubTabs == 0)
        local order = cfg.LayoutOrder or (#self.SubTabs + 1)

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
            Window      = self.Window,
            Tab         = self,
            Name        = subName,
            Icon        = cfg.Icon,
            Active      = isFirst,
            LayoutOrder = order,
            Container   = subContainer,
            Callback    = cfg.Callback,
        }
        table.insert(self.SubTabs, subObj)
        self.Window:RenderSubNavPills(self)

        local subBuilder = {
            Window    = self.Window,
            Container = subContainer,
            SubTab    = subObj,
        }
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
    -- 1. USER WELCOME CARD (Exact Screenshot Match with Liquid Glass)
    -- ==========================================================================
    function TabObj:AddUserCard(config)
        config = config or {}
        local parentFrame = (self.Container or targetPage)

        local Card = Instance.new("Frame")
        Card.Name = "UserCard"
        Card.Size = UDim2.new(1, 0, 0, 84)
        Card.BackgroundColor3 = VRSLibV2.Theme.Card
        Card.BackgroundTransparency = 0
        Card.BorderSizePixel = 0
        Card.LayoutOrder = config.LayoutOrder or 1
        Card.Parent = parentFrame

        local CCorner = Instance.new("UICorner")
        CCorner.CornerRadius = UDim.new(0, 10)
        CCorner.Parent = Card

        local CStroke = Instance.new("UIStroke")
        CStroke.Color = VRSLibV2.Theme.CardStroke
        CStroke.Transparency = VRSLibV2.Theme.CardStrokeTrans
        CStroke.Thickness = 1
        CStroke.Parent = Card

        ApplyGlassSpecular(Card)

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
        AStroke.Color = Color3.fromRGB(55, 60, 80)
        AStroke.Transparency = 0.5
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
        VerPill.BackgroundTransparency = 0.4
        VerPill.BorderSizePixel = 0
        VerPill.Parent = Card

        local VPCorner = Instance.new("UICorner")
        VPCorner.CornerRadius = UDim.new(1, 0)
        VPCorner.Parent = VerPill

        local VPStroke = Instance.new("UIStroke")
        VPStroke.Color = Color3.fromRGB(50, 55, 75)
        VPStroke.Transparency = 0.5
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
    -- 2. STAT GRID (STRICT ORDER: Players, Friends, Execs, Session, FPS, Ping)
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
        GLayout.SortOrder = Enum.SortOrder.LayoutOrder
        GLayout.FillDirection = Enum.FillDirection.Horizontal
        GLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        GLayout.Padding = UDim.new(0, 8)
        GLayout.Parent = GridFrame

        local statCards = {}
        local defaultStats = {
            { Order = 1, Key = "Players", Label = "Players", Icon = "users", Value = tostring(#Players:GetPlayers()) .. "/" .. tostring(Players.MaxPlayers > 0 and Players.MaxPlayers or 20) },
            { Order = 2, Key = "Friends", Label = "Friends", Icon = "user", Value = "0" },
            { Order = 3, Key = "Execs", Label = "Execs", Icon = "zap", Value = "2" },
            { Order = 4, Key = "Session", Label = "Session", Icon = "timer", Value = "0s" },
            { Order = 5, Key = "FPS", Label = "FPS", Icon = "gauge", Value = "60" },
            { Order = 6, Key = "Ping", Label = "Ping", Icon = "wifi", Value = "0ms" },
        }

        for _, item in ipairs(defaultStats) do
            local Card = Instance.new("Frame")
            Card.Name = "Stat_" .. item.Key
            Card.Size = UDim2.new(1 / 6, -7, 1, 0)
            Card.BackgroundColor3 = VRSLibV2.Theme.Card
            Card.BackgroundTransparency = 0
            Card.BorderSizePixel = 0
            Card.LayoutOrder = item.Order
            Card.Parent = GridFrame

            local CCorner = Instance.new("UICorner")
            CCorner.CornerRadius = UDim.new(0, 8)
            CCorner.Parent = Card

            local CStroke = Instance.new("UIStroke")
            CStroke.Color = VRSLibV2.Theme.CardStroke
            CStroke.Transparency = VRSLibV2.Theme.CardStrokeTrans
            CStroke.Thickness = 1
            CStroke.Parent = Card

            ApplyGlassSpecular(Card)

            local CPadding = Instance.new("UIPadding")
            CPadding.PaddingLeft = UDim.new(0, 10)
            CPadding.PaddingRight = UDim.new(0, 10)
            CPadding.PaddingTop = UDim.new(0, 8)
            CPadding.PaddingBottom = UDim.new(0, 8)
            CPadding.Parent = Card

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
            Icon.ZIndex = 5
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
    -- 3. GAME INFO CARD & SERVER ACTIONS (Liquid Glass Refinement)
    -- ==========================================================================
    function TabObj:AddGameCard(config)
        config = config or {}
        local parentFrame = (self.Container or targetPage)

        local Card = Instance.new("Frame")
        Card.Name = "GameCard"
        Card.Size = UDim2.new(1, 0, 0, 118)
        Card.BackgroundColor3 = VRSLibV2.Theme.Card
        Card.BackgroundTransparency = 0
        Card.BorderSizePixel = 0
        Card.LayoutOrder = config.LayoutOrder or 3
        Card.Parent = parentFrame

        local CCorner = Instance.new("UICorner")
        CCorner.CornerRadius = UDim.new(0, 10)
        CCorner.Parent = Card

        local CStroke = Instance.new("UIStroke")
        CStroke.Color = VRSLibV2.Theme.CardStroke
        CStroke.Transparency = VRSLibV2.Theme.CardStrokeTrans
        CStroke.Thickness = 1
        CStroke.Parent = Card

        ApplyGlassSpecular(Card)

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
        local jobId = (game.JobId ~= "" and game.JobId or "2888eb48-3c99-4d0b-a909-000000000000")
        local universeId = (game.GameId ~= 0 and game.GameId or 5595353122)
        local gameName = config.GameName or (self.Window and self.Window.GameName) or "Roblox Game"
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
            btn.BackgroundColor3 = Color3.fromRGB(26, 28, 40)
            btn.BackgroundTransparency = 0.35
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
            bStroke.Color = Color3.fromRGB(48, 52, 70)
            bStroke.Transparency = 0.5
            bStroke.Thickness = 1
            bStroke.Parent = btn

            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(36, 40, 58), BackgroundTransparency = 0.2 }):Play()
                TweenService:Create(bStroke, TweenInfo.new(0.12), { Color = VRSLibV2.Theme.Accent, Transparency = 0.2 }):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(26, 28, 40), BackgroundTransparency = 0.35 }):Play()
                TweenService:Create(bStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(48, 52, 70), Transparency = 0.5 }):Play()
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
    -- 4. WARNING & STATUS BANNER
    -- ==========================================================================
    function TabObj:AddBanner(config)
        config = config or {}
        local parentFrame = (self.Container or targetPage)

        local Banner = Instance.new("Frame")
        Banner.Name = "Banner"
        Banner.Size = UDim2.new(1, 0, 0, 48)
        Banner.BackgroundColor3 = VRSLibV2.Theme.Card
        Banner.BackgroundTransparency = VRSLibV2.Theme.CardTrans
        Banner.BorderSizePixel = 0
        Banner.LayoutOrder = config.LayoutOrder or 4
        Banner.Parent = parentFrame

        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 8)
        BCorner.Parent = Banner

        local BStroke = Instance.new("UIStroke")
        BStroke.Color = VRSLibV2.Theme.CardStroke
        BStroke.Transparency = VRSLibV2.Theme.CardStrokeTrans
        BStroke.Thickness = 1
        BStroke.Parent = Banner

        ApplyGlassSpecular(Banner)

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

        local Pill = Instance.new("Frame")
        Pill.Size = UDim2.new(0, 0, 0, 24)
        Pill.AutomaticSize = Enum.AutomaticSize.X
        Pill.BackgroundColor3 = Color3.fromRGB(26, 28, 38)
        Pill.BackgroundTransparency = 0.4
        Pill.BorderSizePixel = 0
        Pill.Parent = Banner

        local PCorner = Instance.new("UICorner")
        PCorner.CornerRadius = UDim.new(0, 6)
        PCorner.Parent = Pill

        local PStroke = Instance.new("UIStroke")
        PStroke.Color = Color3.fromRGB(48, 52, 70)
        PStroke.Transparency = 0.5
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
    -- 5. QUICK LINKS ROW
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
            Card.BackgroundTransparency = 0
            Card.BorderSizePixel = 0
            Card.Parent = Row

            local CCorner = Instance.new("UICorner")
            CCorner.CornerRadius = UDim.new(0, 8)
            CCorner.Parent = Card

            local CStroke = Instance.new("UIStroke")
            CStroke.Color = VRSLibV2.Theme.CardStroke
            CStroke.Transparency = VRSLibV2.Theme.CardStrokeTrans
            CStroke.Thickness = 1
            CStroke.Parent = Card

            ApplyGlassSpecular(Card)

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
            Btn.BackgroundColor3 = Color3.fromRGB(26, 28, 40)
            Btn.BackgroundTransparency = 0.35
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
            BStroke.Color = Color3.fromRGB(48, 52, 70)
            BStroke.Transparency = 0.5
            BStroke.Thickness = 1
            BStroke.Parent = Btn

            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(36, 40, 58), BackgroundTransparency = 0.2 }):Play()
                TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = VRSLibV2.Theme.Accent, Transparency = 0.2 }):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(26, 28, 40), BackgroundTransparency = 0.35 }):Play()
                TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(48, 52, 70), Transparency = 0.5 }):Play()
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
        Card.BackgroundTransparency = 0
        Card.BorderSizePixel = 0
        Card.LayoutOrder = config.LayoutOrder or 6
        Card.Parent = parentFrame

        local CCorner = Instance.new("UICorner")
        CCorner.CornerRadius = UDim.new(0, 8)
        CCorner.Parent = Card

        local CStroke = Instance.new("UIStroke")
        CStroke.Color = VRSLibV2.Theme.CardStroke
        CStroke.Transparency = VRSLibV2.Theme.CardStrokeTrans
        CStroke.Thickness = 1
        CStroke.Parent = Card

        ApplyGlassSpecular(Card)

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
        Btn.BackgroundColor3 = Color3.fromRGB(26, 28, 40)
        Btn.BackgroundTransparency = 0.35
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
        BStroke.Color = Color3.fromRGB(48, 52, 70)
        BStroke.Transparency = 0.5
        BStroke.Thickness = 1
        BStroke.Parent = Btn

        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(36, 40, 58), BackgroundTransparency = 0.2 }):Play()
            TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = VRSLibV2.Theme.Accent, Transparency = 0.2 }):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(26, 28, 40), BackgroundTransparency = 0.35 }):Play()
            TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(48, 52, 70), Transparency = 0.5 }):Play()
        end)
        Btn.MouseButton1Click:Connect(function()
            if config.Callback then config.Callback() end
        end)

        return Card
    end

    -- ==========================================================================
    -- 7. DUAL-COLUMN SECTION ENGINE
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
        Box.BackgroundTransparency = VRSLibV2.Theme.CardTrans
        Box.BorderSizePixel = 0
        Box.ClipsDescendants = true
        Box.Parent = parentCol

        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(0, 10)
        BCorner.Parent = Box

        local BStroke = Instance.new("UIStroke")
        BStroke.Color = VRSLibV2.Theme.CardStroke
        BStroke.Transparency = VRSLibV2.Theme.CardStrokeTrans
        BStroke.Thickness = 1
        BStroke.Parent = Box

        ApplyGlassSpecular(Box)

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
            Window = self.Window or (self.Tab and self.Tab.Window) or TabObj.Window
        }

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

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, 0, 0, 8)
            Track.Position = UDim2.new(0, 0, 0, 24)
            Track.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
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

        function GroupObj:AddButton(elemCfg)
            elemCfg = elemCfg or {}
            local name     = elemCfg.Name or "Button"
            local iconKey  = elemCfg.Icon
            local callback = elemCfg.Callback or function() end

            local Btn = Instance.new("TextButton")
            Btn.Name = "Button_" .. name
            Btn.Size = UDim2.new(1, 0, 0, 32)
            Btn.BackgroundColor3 = Color3.fromRGB(26, 28, 40)
            Btn.BackgroundTransparency = 0.35
            Btn.BorderSizePixel = 0
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.Parent = Container

            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 6)
            BCorner.Parent = Btn

            local BStroke = Instance.new("UIStroke")
            BStroke.Color = Color3.fromRGB(48, 52, 70)
            BStroke.Transparency = 0.5
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
                TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(36, 40, 58), BackgroundTransparency = 0.2 }):Play()
                TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = VRSLibV2.Theme.Accent, Transparency = 0.2 }):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(26, 28, 40), BackgroundTransparency = 0.35 }):Play()
                TweenService:Create(BStroke, TweenInfo.new(0.12), { Color = Color3.fromRGB(48, 52, 70), Transparency = 0.5 }):Play()
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
            Trigger.BackgroundColor3 = Color3.fromRGB(26, 28, 40)
            Trigger.BackgroundTransparency = 0.35
            Trigger.BorderSizePixel = 0
            Trigger.Text = ""
            Trigger.AutoButtonColor = false
            Trigger.Parent = Box

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 6)
            TCorner.Parent = Trigger

            local TStroke = Instance.new("UIStroke")
            TStroke.Color = Color3.fromRGB(48, 52, 70)
            TStroke.Transparency = 0.5
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

            local DropMenu = Instance.new("Frame")
            DropMenu.Name = "DropMenu"
            DropMenu.Size = UDim2.new(0.5, 0, 0, 0)
            DropMenu.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
            DropMenu.BackgroundTransparency = 0.15
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
                    local container = self.Window.MainContainer or self.Window.MainFrame
                    local mainPos = container.AbsolutePosition
                    local relX = absPos.X - mainPos.X
                    local relY = absPos.Y - mainPos.Y + Trigger.AbsoluteSize.Y + 4

                    DropMenu.Parent = container
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
