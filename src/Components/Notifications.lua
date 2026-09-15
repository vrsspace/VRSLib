--[[
    ==============================================================================
    🌸 VRS ARTELIER — NOTIFICATIONS COMPONENT
    ==============================================================================
    Design: VRS Artelier Cyber-Dark, 100% Signature Neon Magenta Pink (#FF408C)
    Floating toast notification system with smooth tweens & Lucide icons.
    ==============================================================================
]]

local cloneref = (cloneref or clonereference or function(i) return i end)
local TweenService = cloneref(game:GetService("TweenService"))

local Notifications = {}

function Notifications.CreateToast(VRSLib, container, config)
    config = config or {}
    local title       = config.Title or "Notification"
    local description = config.Description or ""
    local duration    = config.Duration or 3
    local iconId      = VRSLib.Icons.Get(config.Icon or "Wings")

    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(1, 0, 0, 52)
    toast.BackgroundColor3 = VRSLib.Theme.Card
    toast.BorderSizePixel = 0
    toast.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toast

    local stroke = Instance.new("UIStroke")
    stroke.Color = VRSLib.Theme.CardStroke
    stroke.Thickness = 1
    stroke.Parent = toast

    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(0, 3, 1, 0)
    glow.BackgroundColor3 = VRSLib.Theme.Accent
    glow.BorderSizePixel = 0
    glow.Parent = toast

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.fromOffset(20, 20)
    icon.Position = UDim2.new(0, 12, 0.5, -10)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = VRSLib.Theme.Accent
    icon.Parent = toast

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -44, 0, 18)
    titleLbl.Position = UDim2.new(0, 40, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = VRSLib.Theme.TextPrimary
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = toast

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -44, 0, 16)
    descLbl.Position = UDim2.new(0, 40, 0, 26)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = description
    descLbl.TextColor3 = VRSLib.Theme.TextMuted
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 11
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Parent = toast

    toast.Parent = container

    -- Entrance tween
    toast.Position = UDim2.new(1, 40, 0, 0)
    TweenService:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    -- Auto dismiss
    task.delay(duration, function()
        if toast and toast.Parent then
            local tw = TweenService:Create(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 40, 0, 0)
            })
            tw:Play()
            tw.Completed:Connect(function()
                toast:Destroy()
            end)
        end
    end)

    return toast
end

return Notifications
