--[[
    ==============================================================================
    🌸 VRS ARTELIER — MODULE CARD COMPONENT
    ==============================================================================
    Design: VRS Artelier Cyber-Dark, 100% Signature Neon Magenta Pink (#FF408C)
    Cards (78px height) with pink pill toggles, action buttons, inline sliders,
    keybind pickers, and context dropdowns.
    ==============================================================================
]]

local cloneref = (cloneref or clonereference or function(i) return i end)
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))

local ModuleCard = {}

function ModuleCard.Create(window, tab, config)
    local VRSLib = window.VRSLib
    config = config or {}
    local title       = config.Title or "Module"
    local description = config.Description or ""
    local iconId      = VRSLib.Icons.Get(config.Icon or "Shield")
    local modType     = config.Type or "Toggle"
    local isEnabled   = config.Default or false
    local callback    = config.Callback or function() end

    local card = Instance.new("Frame")
    card.Name = "Mod_" .. title:gsub("%s+", "")
    card.Size = UDim2.new(0, 195, 0, 76)
    card.BackgroundColor3 = VRSLib.Theme.Card
    card.BorderSizePixel = 0
    card.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = VRSLib.Theme.CardStroke
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = card

    local topRow = Instance.new("Frame")
    topRow.Size = UDim2.new(1, -20, 0, 24)
    topRow.Position = UDim2.new(0, 10, 0, 8)
    topRow.BackgroundTransparency = 1
    topRow.Parent = card

    local modIcon = Instance.new("ImageLabel")
    modIcon.Size = UDim2.fromOffset(14, 14)
    modIcon.Position = UDim2.new(0, 0, 0.5, -7)
    modIcon.BackgroundTransparency = 1
    modIcon.Image = iconId
    modIcon.ImageColor3 = VRSLib.Theme.TextMuted
    modIcon.Parent = topRow

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -54, 1, 0)
    titleLbl.Position = UDim2.new(0, 20, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = VRSLib.Theme.TextPrimary
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.Parent = topRow

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -20, 0, 28)
    descLbl.Position = UDim2.new(0, 10, 0, 36)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = description
    descLbl.TextColor3 = VRSLib.Theme.TextMuted
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 10
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextYAlignment = Enum.TextYAlignment.Top
    descLbl.TextWrapped = true
    descLbl.Parent = card

    -- Interactive Control: Toggle or Action Button
    local modObject = {
        Frame = card,
        Title = title,
        Description = description,
        Tab = tab,
        Values = {},
        Enabled = isEnabled,
    }

    if modType == "Toggle" then
        local toggleTrack = Instance.new("Frame")
        toggleTrack.Size = UDim2.fromOffset(28, 15)
        toggleTrack.Position = UDim2.new(1, -28, 0.5, -7.5)
        toggleTrack.BackgroundColor3 = isEnabled and VRSLib.Theme.Accent or VRSLib.Theme.SwitchOff
        toggleTrack.BorderSizePixel = 0
        toggleTrack.Parent = topRow

        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = toggleTrack

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(11, 11)
        knob.Position = isEnabled and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5)
        knob.BackgroundColor3 = isEnabled and VRSLib.Theme.SwitchOnKnob or VRSLib.Theme.SwitchOffKnob
        knob.BorderSizePixel = 0
        knob.Parent = toggleTrack

        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob

        local hitBtn = Instance.new("TextButton")
        hitBtn.Size = UDim2.new(1, 0, 1, 0)
        hitBtn.BackgroundTransparency = 1
        hitBtn.Text = ""
        hitBtn.Parent = card

        local function SetState(state)
            isEnabled = state
            modObject.Enabled = state
            local targetTrack = state and VRSLib.Theme.Accent or VRSLib.Theme.SwitchOff
            local targetKnob  = state and VRSLib.Theme.SwitchOnKnob or VRSLib.Theme.SwitchOffKnob
            local targetPos   = state and UDim2.new(1, -13, 0.5, -5.5) or UDim2.new(0, 2, 0.5, -5.5)
            local targetIconCol = state and VRSLib.Theme.Accent or VRSLib.Theme.TextMuted

            TweenService:Create(toggleTrack, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundColor3 = targetTrack }):Play()
            TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = targetPos,
                BackgroundColor3 = targetKnob
            }):Play()
            TweenService:Create(modIcon, TweenInfo.new(0.18), { ImageColor3 = targetIconCol }):Play()

            pcall(callback, state)
            if window.UpdateCounts then window:UpdateCounts() end
        end

        hitBtn.MouseButton1Click:Connect(function()
            SetState(not isEnabled)
        end)

        modObject.SetState = SetState
    elseif modType == "Action" then
        local actionBtn = Instance.new("TextButton")
        actionBtn.Size = UDim2.fromOffset(26, 18)
        actionBtn.Position = UDim2.new(1, -26, 0.5, -9)
        actionBtn.BackgroundColor3 = VRSLib.Theme.ActionBtn
        actionBtn.BorderSizePixel = 0
        actionBtn.Text = ""
        actionBtn.Parent = topRow

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = actionBtn

        local actionIcon = Instance.new("ImageLabel")
        actionIcon.Size = UDim2.fromOffset(10, 10)
        actionIcon.Position = UDim2.new(0.5, -5, 0.5, -5)
        actionIcon.BackgroundTransparency = 1
        actionIcon.Image = VRSLib.Icons.Get("play")
        actionIcon.ImageColor3 = VRSLib.Theme.ActionBtnIcon
        actionIcon.Parent = actionBtn

        actionBtn.MouseButton1Click:Connect(function()
            TweenService:Create(actionIcon, TweenInfo.new(0.1), { Size = UDim2.fromOffset(8, 8) }):Play()
            task.wait(0.1)
            TweenService:Create(actionIcon, TweenInfo.new(0.1), { Size = UDim2.fromOffset(10, 10) }):Play()
            pcall(callback)
        end)
    end

    -- Card hover effect
    card.MouseEnter:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.Accent }):Play()
        TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = VRSLib.Theme.CardHover }):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.15), { Color = VRSLib.Theme.CardStroke }):Play()
        TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = VRSLib.Theme.Card }):Play()
    end)

    return modObject
end

return ModuleCard
