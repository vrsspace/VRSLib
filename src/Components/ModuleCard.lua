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

    function modObject:AddDropdown(config)
        config = config or {}
        local name     = config.Name or config.Title or "Dropdown"
        local values   = config.Values or config.Items or config.Options or {}
        local isMulti  = (config.Multi == true or config.Multiselect == true)
        local curSel
        if isMulti then
            curSel = {}
            if type(config.Default) == "table" then
                for k, v in pairs(config.Default) do
                    if type(k) == "number" and type(v) == "string" then
                        curSel[v] = true
                    elseif type(k) == "string" and v == true then
                        curSel[k] = true
                    end
                end
            elseif type(config.Default) == "string" then
                curSel[config.Default] = true
            end
        else
            if type(config.Default) == "number" and values[config.Default] ~= nil then
                curSel = values[config.Default]
            elseif config.Default ~= nil then
                curSel = config.Default
            else
                curSel = values[1] or "Select..."
            end
        end
        local cb = config.Callback or config.Func or function() end

        card.Size = UDim2.fromOffset(card.Size.X.Offset, 126)
        card.ClipsDescendants = false

        local DropFrame = Instance.new("Frame")
        DropFrame.Name = "CardDrop_" .. tostring(name)
        DropFrame.Size = UDim2.new(1, -14, 0, 42)
        DropFrame.Position = UDim2.new(0, 7, 0, 76)
        DropFrame.BackgroundTransparency = 1
        DropFrame.ZIndex = 20
        DropFrame.ClipsDescendants = false
        DropFrame.Parent = card

        local DLabel = Instance.new("TextLabel")
        DLabel.Size = UDim2.new(1, 0, 0, 14)
        DLabel.Position = UDim2.new(0, 0, 0, 0)
        DLabel.BackgroundTransparency = 1
        DLabel.Text = name
        DLabel.Font = Enum.Font.GothamMedium
        DLabel.TextSize = 9.5
        DLabel.TextColor3 = VRSLib.Theme.TextPrimary
        DLabel.TextXAlignment = Enum.TextXAlignment.Left
        DLabel.Parent = DropFrame

        local MainBtn = Instance.new("TextButton")
        MainBtn.Size = UDim2.new(1, 0, 0, 24)
        MainBtn.Position = UDim2.new(0, 0, 0, 16)
        MainBtn.BackgroundColor3 = VRSLib.Theme.InputBackground
        MainBtn.BorderSizePixel = 0
        MainBtn.Text = ""
        MainBtn.AutoButtonColor = false
        MainBtn.ZIndex = 21
        MainBtn.Parent = DropFrame

        local DCorner = Instance.new("UICorner")
        DCorner.CornerRadius = UDim.new(0, 4)
        DCorner.Parent = MainBtn

        local DStroke = Instance.new("UIStroke")
        DStroke.Color = VRSLib.Theme.CardStroke
        DStroke.Thickness = 1
        DStroke.Parent = MainBtn

        local function getSummary()
            if not isMulti then return tostring(curSel or "Select...") end
            local active = {}
            for _, v in ipairs(values) do
                if curSel[v] then
                    table.insert(active, tostring(v))
                end
            end
            if #active == 0 then return "None" end
            return table.concat(active, ", ")
        end

        local SelText = Instance.new("TextLabel")
        SelText.Size = UDim2.new(1, -26, 1, 0)
        SelText.Position = UDim2.new(0, 6, 0, 0)
        SelText.BackgroundTransparency = 1
        SelText.Text = getSummary()
        SelText.Font = Enum.Font.GothamMedium
        SelText.TextSize = 9.5
        SelText.TextColor3 = VRSLib.Theme.TextPrimary
        SelText.TextXAlignment = Enum.TextXAlignment.Left
        SelText.TextTruncate = Enum.TextTruncate.AtEnd
        SelText.ZIndex = 22
        SelText.Parent = MainBtn

        local Chevron = Instance.new("ImageLabel")
        Chevron.Size = UDim2.fromOffset(11, 11)
        Chevron.Position = UDim2.new(1, -18, 0.5, -5.5)
        Chevron.BackgroundTransparency = 1
        Chevron.Image = VRSLib.Icons.Get("chevron-down")
        Chevron.ImageColor3 = VRSLib.Theme.TextMuted
        Chevron.ZIndex = 22
        Chevron.Parent = MainBtn

        local DropMenu = Instance.new("Frame")
        DropMenu.Name = "DropMenu"
        DropMenu.Size = UDim2.new(1, 0, 0, 0)
        DropMenu.Position = UDim2.new(0, 0, 0, 44)
        DropMenu.BackgroundColor3 = VRSLib.Theme.Card
        DropMenu.BorderSizePixel = 0
        DropMenu.Visible = false
        DropMenu.ZIndex = 40
        DropMenu.ClipsDescendants = true
        DropMenu.Parent = DropFrame

        local DMCorner = Instance.new("UICorner")
        DMCorner.CornerRadius = UDim.new(0, 5)
        DMCorner.Parent = DropMenu

        local DMStroke = Instance.new("UIStroke")
        DMStroke.Color = VRSLib.Theme.CardStroke
        DMStroke.Thickness = 1
        DMStroke.Parent = DropMenu

        local SearchBar = Instance.new("Frame")
        SearchBar.Size = UDim2.new(1, -10, 0, 22)
        SearchBar.Position = UDim2.new(0, 5, 0, 5)
        SearchBar.BackgroundColor3 = VRSLib.Theme.InputBackground
        SearchBar.BorderSizePixel = 0
        SearchBar.ZIndex = 41
        SearchBar.Parent = DropMenu

        local SBCorner = Instance.new("UICorner")
        SBCorner.CornerRadius = UDim.new(0, 4)
        SBCorner.Parent = SearchBar

        local SearchIcon = Instance.new("ImageLabel")
        SearchIcon.Size = UDim2.fromOffset(11, 11)
        SearchIcon.Position = UDim2.new(0, 5, 0.5, -5.5)
        SearchIcon.BackgroundTransparency = 1
        SearchIcon.Image = VRSLib.Icons.Get("search")
        SearchIcon.ImageColor3 = VRSLib.Theme.TextMuted
        SearchIcon.ZIndex = 42
        SearchIcon.Parent = SearchBar

        local SearchInput = Instance.new("TextBox")
        SearchInput.Size = UDim2.new(1, -22, 1, 0)
        SearchInput.Position = UDim2.new(0, 20, 0, 0)
        SearchInput.BackgroundTransparency = 1
        SearchInput.Text = ""
        SearchInput.PlaceholderText = "search..."
        SearchInput.PlaceholderColor3 = Color3.fromRGB(105, 110, 130)
        SearchInput.TextColor3 = VRSLib.Theme.TextPrimary
        SearchInput.Font = Enum.Font.Gotham
        SearchInput.TextSize = 9.5
        SearchInput.TextXAlignment = Enum.TextXAlignment.Left
        SearchInput.ClearTextOnFocus = false
        SearchInput.ZIndex = 42
        SearchInput.Parent = SearchBar

        local DropScroll = Instance.new("ScrollingFrame")
        DropScroll.Size = UDim2.new(1, 0, 0, 0)
        DropScroll.Position = UDim2.new(0, 0, 0, 30)
        DropScroll.BackgroundTransparency = 1
        DropScroll.BorderSizePixel = 0
        DropScroll.ZIndex = 41
        DropScroll.ClipsDescendants = true
        DropScroll.ScrollBarThickness = 2
        DropScroll.ScrollBarImageColor3 = VRSLib.Theme.Accent
        DropScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        DropScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        DropScroll.Parent = DropMenu

        local DSPadding = Instance.new("UIPadding")
        DSPadding.PaddingLeft = UDim.new(0, 5)
        DSPadding.PaddingRight = UDim.new(0, 5)
        DSPadding.PaddingTop = UDim.new(0, 2)
        DSPadding.PaddingBottom = UDim.new(0, 4)
        DSPadding.Parent = DropScroll

        local DSLayout = Instance.new("UIListLayout")
        DSLayout.SortOrder = Enum.SortOrder.LayoutOrder
        DSLayout.Padding = UDim.new(0, 2)
        DSLayout.Parent = DropScroll

        local optItems = {}
        local dropCallbacks = { cb }

        local function refreshItems()
            for _, opt in ipairs(optItems) do
                local val = opt.Value
                local isSel = isMulti and (curSel[val] == true) or (tostring(val) == tostring(curSel))
                opt.Label.TextColor3 = isSel and VRSLib.Theme.Accent or Color3.fromRGB(220, 224, 235)
                opt.Check.ImageColor3 = VRSLib.Theme.Accent
                opt.Check.Visible = isSel
            end
        end

        local function getVisibleCount()
            local count = 0
            for _, opt in ipairs(optItems) do
                if opt.Button.Visible then count = count + 1 end
            end
            return count
        end

        local isOpen = false
        local function updateMenuHeight()
            if not isOpen then return end
            local count = getVisibleCount()
            local visibleH = math.min(math.max(count, 1) * 24 + 4, 130)
            DropScroll.Size = UDim2.new(1, 0, 0, visibleH)
            DropMenu.Size = UDim2.new(1, 0, 0, 32 + visibleH + 4)
        end

        local function filterOptions(query)
            query = string.lower(query or "")
            for _, opt in ipairs(optItems) do
                local matches = (query == "") or (string.find(string.lower(tostring(opt.Value)), query, 1, true) ~= nil)
                opt.Button.Visible = matches
            end
            updateMenuHeight()
        end

        SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
            filterOptions(SearchInput.Text)
        end)

        local function ToggleDrop(open)
            isOpen = (open ~= nil and open) or not isOpen
            DropMenu.Visible = isOpen
            if isOpen then
                SearchInput.Text = ""
                filterOptions("")
                DropScroll.CanvasPosition = Vector2.new(0, 0)
                updateMenuHeight()
                TweenService:Create(Chevron, TweenInfo.new(0.15), { Rotation = 180 }):Play()
            else
                TweenService:Create(Chevron, TweenInfo.new(0.15), { Rotation = 0 }):Play()
            end
        end

        MainBtn.MouseButton1Click:Connect(function() ToggleDrop() end)

        local function handleItemToggle(val)
            if isMulti then
                curSel[val] = not curSel[val]
                SelText.Text = getSummary()
                refreshItems()
                for _, fn in ipairs(dropCallbacks) do task.spawn(fn, curSel) end
            else
                curSel = val
                SelText.Text = tostring(val)
                refreshItems()
                ToggleDrop(false)
                for _, fn in ipairs(dropCallbacks) do task.spawn(fn, val) end
            end
        end

        for idx, val in ipairs(values) do
            local isSelected = isMulti and (curSel[val] == true) or (tostring(val) == tostring(curSel))

            local OptBtn = Instance.new("TextButton")
            OptBtn.Name = "Option_" .. tostring(val)
            OptBtn.Size = UDim2.new(1, 0, 0, 22)
            OptBtn.BackgroundTransparency = 1
            OptBtn.BackgroundColor3 = VRSLib.Theme.CardHover
            OptBtn.BorderSizePixel = 0
            OptBtn.Text = ""
            OptBtn.AutoButtonColor = false
            OptBtn.LayoutOrder = idx
            OptBtn.ZIndex = 43
            OptBtn.Parent = DropScroll

            local OBCorner = Instance.new("UICorner")
            OBCorner.CornerRadius = UDim.new(0, 3)
            OBCorner.Parent = OptBtn

            local OptLbl = Instance.new("TextLabel")
            OptLbl.Name = "Text"
            OptLbl.Size = UDim2.new(1, -24, 1, 0)
            OptLbl.Position = UDim2.new(0, 6, 0, 0)
            OptLbl.BackgroundTransparency = 1
            OptLbl.Text = tostring(val)
            OptLbl.Font = Enum.Font.GothamMedium
            OptLbl.TextSize = 10
            OptLbl.TextColor3 = isSelected and VRSLib.Theme.Accent or Color3.fromRGB(220, 224, 235)
            OptLbl.TextXAlignment = Enum.TextXAlignment.Left
            OptLbl.TextTruncate = Enum.TextTruncate.AtEnd
            OptLbl.ZIndex = 44
            OptLbl.Parent = OptBtn

            local Check = Instance.new("ImageLabel")
            Check.Name = "Check"
            Check.Size = UDim2.fromOffset(11, 11)
            Check.Position = UDim2.new(1, -16, 0.5, -5.5)
            Check.BackgroundTransparency = 1
            Check.Image = VRSLib.Icons.Get("check")
            Check.ImageColor3 = VRSLib.Theme.Accent
            Check.Visible = isSelected
            Check.ZIndex = 44
            Check.Parent = OptBtn

            OptBtn.MouseEnter:Connect(function()
                TweenService:Create(OptBtn, TweenInfo.new(0.12), { BackgroundTransparency = 0.85 }):Play()
            end)
            OptBtn.MouseLeave:Connect(function()
                TweenService:Create(OptBtn, TweenInfo.new(0.12), { BackgroundTransparency = 1 }):Play()
            end)
            OptBtn.MouseButton1Click:Connect(function()
                handleItemToggle(val)
            end)

            table.insert(optItems, {
                Button = OptBtn,
                Label = OptLbl,
                Check = Check,
                Value = val
            })
        end

        return {
            Value = curSel,
            Frame = DropFrame
        }
    end

    return modObject
end

return ModuleCard
