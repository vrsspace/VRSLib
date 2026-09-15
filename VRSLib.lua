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
    Version = "1.0.0",
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
        TextPrimary     = Color3.fromRGB(242, 244, 252),
        TextMuted       = Color3.fromRGB(120, 125, 150),
        BadgeBackground = Color3.fromRGB(24, 25, 38),
        BadgeText       = Color3.fromRGB(165, 170, 195),
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
        -- Try loading external module first if available
        local function TryLoad()
            if isfile and isfile("src/Icons.lua") then
                local ok, res = pcall(function() return loadstring(readfile("src/Icons.lua"))() end)
                if ok and res then return res end
            end
            if isfile and isfile("Icons.lua") then
                local ok, res = pcall(function() return loadstring(readfile("Icons.lua"))() end)
                if ok and res then return res end
            end
            return nil
        end
        local loaded = TryLoad()
        if loaded then return loaded end

        -- Built-in Full Verified Icons Engine
            🌸 VRS ARTELIER — ICONS MODULE (LUCIDE ENGINE)
            Design: VRS Artelier Cyber-Dark, 100% Signature Neon Magenta Pink (#FF408C)
            Provides 800+ verified Lucide icon assets + smart alias resolver.
            Guarantees that NO icon ever renders blank or missing.
        
        local Icons = {
            -- Custom Brand Assets
            Wings   = "rbxassetid://132717088484517",
            Default = "rbxassetid://10709782497", -- Box icon fallback (never blank!)
        
            -- Smart Aliases for common terms & backward compatibility
            Aliases = {
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
        return Icons
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
local BRAND_LOGO_URL = "https://r2.fivemanage.com/vZukXicMKTGIXYcjmBRsm/Logo/2.png"
local cachedLogoAsset = nil

local function GetBrandLogo()
    if cachedLogoAsset then return cachedLogoAsset end
    local fileName = "vrs_artelier_logo.png"

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

function VRSLib:Notify(config)
    local title  = config.Title or "VRS Artelier"
    local desc   = config.Description or config.Content or ""
    local dur    = config.Duration or 3.5
    local iconId = VRSLib.Icons.Get(config.Icon or "Wings")
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
    dLbl.Font = Enum.Font.Gotham
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

function VRSLib:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, Window)

    self.Title          = config.Title or "VRS Artelier"
    self.SubTitle       = config.SubTitle or "v1.0.0 Pro"
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
    Topbar.Size = UDim2.new(1, 0, 0, 48)
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

    -- Brand Box with WINGS LOGO (Header Kiri Atas)
    local BrandBox = Instance.new("Frame")
    BrandBox.Size = UDim2.new(0, 220, 1, 0)
    BrandBox.Position = UDim2.new(0, 14, 0, 0)
    BrandBox.BackgroundTransparency = 1
    BrandBox.Parent = Topbar

    local WingsLogo = Instance.new("ImageLabel")
    WingsLogo.Name = "WingsLogo"
    WingsLogo.Size = UDim2.fromOffset(24, 24)
    WingsLogo.Position = UDim2.new(0, 0, 0.5, -12)
    WingsLogo.BackgroundTransparency = 1
    ApplyBrandLogo(WingsLogo)
    WingsLogo.Parent = BrandBox

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 0, 1, 0)
    TitleLabel.AutomaticSize = Enum.AutomaticSize.X
    TitleLabel.Position = UDim2.new(0, 32, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "VRS Artelier"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 13.5
    TitleLabel.TextColor3 = VRSLib.Theme.TextPrimary
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = BrandBox

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Size = UDim2.new(0, 0, 1, 0)
    SubTitleLabel.AutomaticSize = Enum.AutomaticSize.X
    SubTitleLabel.Position = UDim2.new(1, 6, 0, 0)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Text = config.SubTitle or (config.Title ~= "VRS Artelier" and config.Title) or "v1.0.0 Pro"
    SubTitleLabel.Font = Enum.Font.Gotham
    SubTitleLabel.TextSize = 11
    SubTitleLabel.TextColor3 = VRSLib.Theme.TextMuted
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = TitleLabel

    ProtectLocalization(TitleLabel)
    ProtectLocalization(SubTitleLabel)

    -- Live Search Input Box: [ 🔍 Search modules... ]
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Name = "SearchBox"
    SearchFrame.Size = UDim2.new(0, 240, 0, 28)
    SearchFrame.Position = UDim2.new(0, 225, 0.5, -14)
    SearchFrame.BackgroundColor3 = VRSLib.Theme.InputBackground
    SearchFrame.BorderSizePixel = 0
    SearchFrame.Parent = Topbar

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchFrame

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = VRSLib.Theme.InputStroke
    SearchStroke.Thickness = 1
    SearchStroke.Parent = SearchFrame

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.fromOffset(13, 13)
    SearchIcon.Position = UDim2.new(0, 8, 0.5, -6.5)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = VRSLib.Icons.Get("search")
    SearchIcon.ImageColor3 = VRSLib.Theme.TextMuted
    SearchIcon.Parent = SearchFrame

    local SearchInput = Instance.new("TextBox")
    SearchInput.Size = UDim2.new(1, -30, 1, 0)
    SearchInput.Position = UDim2.new(0, 26, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.Font = Enum.Font.Gotham
    SearchInput.PlaceholderText = "Search modules..."
    SearchInput.PlaceholderColor3 = VRSLib.Theme.TextMuted
    SearchInput.Text = ""
    SearchInput.TextColor3 = VRSLib.Theme.TextPrimary
    SearchInput.TextSize = 11.5
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.ClearTextOnFocus = false
    SearchInput.Parent = SearchFrame
    ProtectLocalization(SearchInput)

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        self:FilterModules(SearchInput.Text)
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
    -- BODY (SIDEBAR + MAIN CONTENT)
    -- ==============================================================================
    local Body = Instance.new("Frame")
    Body.Size = UDim2.new(1, 0, 1, -48)
    Body.Position = UDim2.new(0, 0, 0, 48)
    Body.BackgroundTransparency = 1
    Body.Parent = Main

    -- ==============================================================================
    -- LEFT SIDEBAR
    -- ==============================================================================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 185, 1, 0)
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
    UserNameLbl.Size = UDim2.new(1, -78, 0, 16)
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
            Description = "Framework: VRS Artelier v1.0.0 Pro\nToggle Key: RightControl",
            Duration = 3,
            Icon = VRSLib.Icons.Wings
        })
    end)

    -- ==============================================================================
    -- MAIN CONTENT AREA
    -- ==============================================================================
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -186, 1, 0)
    ContentArea.Position = UDim2.new(0, 186, 0, 0)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = Body

    -- Header / Sub-navbar inside Content Area (Breadcrumb + View Switchers)
    local ContentHeader = Instance.new("Frame")
    ContentHeader.Size = UDim2.new(1, 0, 0, 38)
    ContentHeader.BackgroundTransparency = 1
    ContentHeader.Parent = ContentArea

    local BreadcrumbBox = Instance.new("Frame")
    BreadcrumbBox.Size = UDim2.new(1, -130, 1, 0)
    BreadcrumbBox.Position = UDim2.new(0, 16, 0, 0)
    BreadcrumbBox.BackgroundTransparency = 1
    BreadcrumbBox.Parent = ContentHeader

    local BreadcrumbCategory = Instance.new("TextLabel")
    BreadcrumbCategory.Size = UDim2.new(0, 0, 1, 0)
    BreadcrumbCategory.AutomaticSize = Enum.AutomaticSize.X
    BreadcrumbCategory.BackgroundTransparency = 1
    BreadcrumbCategory.Text = "QUICK / "
    BreadcrumbCategory.Font = Enum.Font.Gotham
    BreadcrumbCategory.TextSize = 11.5
    BreadcrumbCategory.TextColor3 = VRSLib.Theme.TextMuted
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
    BreadcrumbBadge.Size = UDim2.new(0, 0, 1, 0)
    BreadcrumbBadge.AutomaticSize = Enum.AutomaticSize.X
    BreadcrumbBadge.Position = UDim2.new(1, 6, 0, 0)
    BreadcrumbBadge.BackgroundTransparency = 1
    BreadcrumbBadge.Text = "0"
    BreadcrumbBadge.Font = Enum.Font.Gotham
    BreadcrumbBadge.TextSize = 11
    BreadcrumbBadge.TextColor3 = VRSLib.Theme.TextMuted
    BreadcrumbBadge.TextXAlignment = Enum.TextXAlignment.Left
    BreadcrumbBadge.Parent = BreadcrumbTab
    ProtectLocalization(BreadcrumbBadge)

    self.BreadcrumbCategory = BreadcrumbCategory
    self.BreadcrumbTab      = BreadcrumbTab
    self.BreadcrumbBadge    = BreadcrumbBadge

    -- View Switchers on right: [ ⊞  ☰  𝄜 ]
    local ViewSwitchers = Instance.new("Frame")
    ViewSwitchers.Size = UDim2.new(0, 88, 0, 24)
    ViewSwitchers.Position = UDim2.new(1, -104, 0.5, -12)
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
        { Id = "Compact", Icon = VRSLib.Icons.Get("compact") },
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

    -- Scrolling Container for Cards
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

    local GridPadding = Instance.new("UIPadding")
    GridPadding.PaddingLeft = UDim.new(0, 16)
    GridPadding.PaddingRight = UDim.new(0, 16)
    GridPadding.PaddingTop = UDim.new(0, 4)
    GridPadding.PaddingBottom = UDim.new(0, 28)
    GridPadding.Parent = CardsScroll

    local GridLayout = Instance.new("UIGridLayout")
    GridLayout.CellPadding = UDim2.fromOffset(8, 8)
    GridLayout.CellSize = UDim2.fromOffset(148, 78) -- Dynamically recalculated by ReflowGrid()
    GridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    GridLayout.Parent = CardsScroll
    self.GridLayout = GridLayout

    -- Empty Search State Label (Fixed: only visible when search text is active and no cards match)
    local EmptyState = Instance.new("TextLabel")
    EmptyState.Size = UDim2.new(1, -32, 0, 80)
    EmptyState.Position = UDim2.new(0, 16, 0, 60)
    EmptyState.BackgroundTransparency = 1
    EmptyState.Text = "No matching modules found"
    EmptyState.Font = Enum.Font.Gotham
    EmptyState.TextSize = 12
    EmptyState.TextColor3 = VRSLib.Theme.TextMuted
    EmptyState.Visible = false
    EmptyState.Parent = ContentArea
    self.EmptyState = EmptyState

    -- ==============================================================================
    -- FREE WINDOW DRAG-RESIZING SYSTEM (CORNER & BORDER DRAGGERS)
    -- ==============================================================================
    local ResizeGrip = Instance.new("ImageButton")
    ResizeGrip.Name = "ResizeGrip"
    ResizeGrip.Size = UDim2.fromOffset(22, 22)
    ResizeGrip.Position = UDim2.new(1, -22, 1, -22)
    ResizeGrip.BackgroundTransparency = 1
    ResizeGrip.Image = VRSLib.Icons.Get("resize")
    ResizeGrip.ImageColor3 = VRSLib.Theme.Accent
    ResizeGrip.Rotation = 225
    ResizeGrip.ZIndex = 30
    ResizeGrip.Parent = Main

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

    -- Floating Mobile / PC Draggable Wings Widget
    local FloatingToggle = Instance.new("ImageButton")
    FloatingToggle.Name = "VRS_FloatingWings"
    FloatingToggle.Size = UDim2.fromOffset(44, 44)
    FloatingToggle.Position = UDim2.new(0, 25, 0.45, 0)
    FloatingToggle.BackgroundColor3 = VRSLib.Theme.Card
    FloatingToggle.BorderSizePixel = 0
    FloatingToggle.AutoButtonColor = false
    FloatingToggle.Parent = ScreenGui

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(1, 0)
    FloatCorner.Parent = FloatingToggle

    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Color = VRSLib.Theme.Accent
    FloatStroke.Thickness = 1.4
    FloatStroke.Parent = FloatingToggle

    local FloatIcon = Instance.new("ImageLabel")
    FloatIcon.Size = UDim2.fromOffset(26, 26)
    FloatIcon.Position = UDim2.new(0.5, -13, 0.5, -13)
    FloatIcon.BackgroundTransparency = 1
    ApplyBrandLogo(FloatIcon)
    FloatIcon.Parent = FloatingToggle

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

    self:InitQuickCategory()
    table.insert(VRSLib.Windows, self)
    task.defer(function() self:ReflowGrid() end)
    return self
end

-- ==============================================================================
-- DYNAMIC CARD GRID REFLOW (3 TO 6 COLUMNS LIKE 404HUB)
-- ==============================================================================
function Window:ReflowGrid()
    if self.CurrentView ~= "Grid" then return end
    local contentW = self.CardsScroll.AbsoluteSize.X - 32
    if contentW <= 100 then
        contentW = self.MainFrame.AbsoluteSize.X - 186 - 32
    end

    local cols = 4
    if contentW >= 1050 then
        cols = 6 -- 6 columns like 404hub!
    elseif contentW >= 820 then
        cols = 5
    elseif contentW >= 600 then
        cols = 4
    else
        cols = 3
    end

    local cellW = math.floor((contentW - (cols - 1) * 8) / cols)
    self.GridLayout.CellSize = UDim2.fromOffset(cellW, 78)
end

-- ==============================================================================
-- CATEGORY & TAB SYSTEM
-- ==============================================================================
function Window:AddCategoryHeader(name, layoutOrder)
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Size = UDim2.new(1, 0, 0, 22)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.LayoutOrder = layoutOrder or 10
    HeaderFrame.Parent = self.SidebarScroll

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Size = UDim2.new(1, 0, 1, 0)
    HeaderText.BackgroundTransparency = 1
    HeaderText.Text = string.upper(name)
    HeaderText.Font = Enum.Font.GothamBold
    HeaderText.TextSize = 9.5
    HeaderText.TextColor3 = VRSLib.Theme.TextMuted
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left
    HeaderText.Parent = HeaderFrame
    ProtectLocalization(HeaderText)

    return HeaderFrame
end

function Window:InitQuickCategory()
    self:AddCategoryHeader("QUICK", 1)

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

function Window:AddCategory(categoryName, layoutOrder)
    self:AddCategoryHeader(categoryName, layoutOrder or (#self.Categories * 10 + 20))
    table.insert(self.Categories, categoryName)
end

function Window:CreateSidebarTab(config)
    local tabName     = config.Name or "Tab"
    local category    = config.Category or "UNIVERSAL"
    local iconId      = VRSLib.Icons.Get(config.Icon or "Visuals")
    local layoutOrder = config.LayoutOrder or 50

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
    TabLabel.Size = UDim2.new(1, -65, 1, 0)
    TabLabel.Position = UDim2.new(0, 30, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = tabName
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.TextSize = 11.5
    TabLabel.TextColor3 = VRSLib.Theme.TextMuted
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabBtn
    ProtectLocalization(TabLabel)

    local Badge = Instance.new("Frame")
    Badge.Size = UDim2.new(0, 24, 0, 15)
    Badge.Position = UDim2.new(1, -26, 0.5, -7.5)
    Badge.BackgroundColor3 = VRSLib.Theme.BadgeBackground
    Badge.BorderSizePixel = 0
    Badge.Parent = TabBtn

    local BadgeCorner = Instance.new("UICorner")
    BadgeCorner.CornerRadius = UDim.new(0, 8)
    BadgeCorner.Parent = Badge

    local BadgeText = Instance.new("TextLabel")
    BadgeText.Size = UDim2.new(1, 0, 1, 0)
    BadgeText.BackgroundTransparency = 1
    BadgeText.Text = "0"
    BadgeText.Font = Enum.Font.GothamBold
    BadgeText.TextSize = 9.5
    BadgeText.TextColor3 = VRSLib.Theme.BadgeText
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

    TabBtn.MouseEnter:Connect(function()
        if self.ActiveTab ~= TabObj then
            TweenService:Create(TabBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.6, BackgroundColor3 = VRSLib.Theme.CardHover }):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.15), { TextColor3 = VRSLib.Theme.TextPrimary }):Play()
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if self.ActiveTab ~= TabObj then
            TweenService:Create(TabBtn, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.15), { TextColor3 = VRSLib.Theme.TextMuted }):Play()
        end
    end)

    TabBtn.MouseButton1Click:Connect(function()
        self:SelectTab(TabObj)
    end)

    table.insert(self.Tabs, TabObj)
    return TabObj
end

function Window:AddTab(config)
    return self:CreateSidebarTab(config)
end

function Window:SelectTab(tabObj)
    self.ActiveTab = tabObj
    self.CurrentCategory = tabObj.Category

    self.BreadcrumbCategory.Text = string.upper(tabObj.Category) .. " / "
    self.BreadcrumbTab.Text = tabObj.Name
    self.BreadcrumbBadge.Text = tabObj.BadgeText.Text

    for _, t in ipairs(self.Tabs) do
        if t == tabObj then
            TweenService:Create(t.Button, TweenInfo.new(0.2), { BackgroundTransparency = 0, BackgroundColor3 = VRSLib.Theme.Card }):Play()
            TweenService:Create(t.Label, TweenInfo.new(0.2), { TextColor3 = VRSLib.Theme.TextPrimary }):Play()
            TweenService:Create(t.Icon, TweenInfo.new(0.2), { ImageColor3 = VRSLib.Theme.Accent }):Play()
            t.Indicator.Visible = true
        else
            TweenService:Create(t.Button, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(t.Label, TweenInfo.new(0.2), { TextColor3 = VRSLib.Theme.TextMuted }):Play()
            TweenService:Create(t.Icon, TweenInfo.new(0.2), { ImageColor3 = VRSLib.Theme.TextMuted }):Play()
            t.Indicator.Visible = false
        end
    end

    self:FilterModules(self.SearchQuery)
end

function Window:UpdateBadges()
    local totalCount = #self.AllCards
    local pinnedCount = 0
    local activeCount = 0

    for _, card in ipairs(self.AllCards) do
        if card.IsPinned then pinnedCount = pinnedCount + 1 end
        if card.Value then activeCount = activeCount + 1 end
    end

    if self.AllModulesTab then self.AllModulesTab.BadgeText.Text = tostring(totalCount) end
    if self.PinnedTab then self.PinnedTab.BadgeText.Text = tostring(pinnedCount) end
    if self.ActiveTabBtn then self.ActiveTabBtn.BadgeText.Text = tostring(activeCount) end

    for _, tab in ipairs(self.Tabs) do
        if not tab.IsQuickTab then
            tab.BadgeText.Text = tostring(#tab.Cards)
        end
    end

    if self.ActiveTab then
        self.BreadcrumbBadge.Text = self.ActiveTab.BadgeText.Text
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
    CardFrame.Size = UDim2.fromOffset(148, 78)
    CardFrame.BackgroundColor3 = VRSLib.Theme.Card
    CardFrame.BorderSizePixel = 0
    CardFrame.ClipsDescendants = true
    CardFrame.Parent = self.CardsScroll
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
    TopRow.Size = UDim2.new(1, -14, 0, 22)
    TopRow.Position = UDim2.new(0, 7, 0, 7)
    TopRow.BackgroundTransparency = 1
    TopRow.Parent = CardFrame

    local ModIcon = Instance.new("ImageLabel")
    ModIcon.Size = UDim2.fromOffset(14, 14)
    ModIcon.Position = UDim2.new(0, 0, 0.5, -7)
    ModIcon.BackgroundTransparency = 1
    ModIcon.Image = iconId
    ModIcon.ImageColor3 = VRSLib.Theme.TextMuted
    ModIcon.Parent = TopRow

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -44, 1, 0)
    TitleLabel.Position = UDim2.new(0, 18, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 11.5
    TitleLabel.TextColor3 = VRSLib.Theme.TextPrimary
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLabel.Parent = TopRow
    ProtectLocalization(TitleLabel)

    -- Description
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -14, 0, 36)
    DescLabel.Position = UDim2.new(0, 7, 0, 33)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = desc
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 9.5
    DescLabel.TextColor3 = VRSLib.Theme.TextMuted
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.TextWrapped = true
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

    -- Fixed: Only show EmptyState if a search was actually typed and 0 results found!
    if self.SearchQuery ~= "" then
        self.EmptyState.Visible = not hasVisibleCards
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
        self.GridLayout.CellSize = UDim2.new(1, 0, 0, 52)
    elseif mode == "Compact" then
        self.GridLayout.CellSize = UDim2.fromOffset(130, 48)
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
