--[[
    ==============================================================================
    🌸 VRS ARTELIER — SIDEBAR COMPONENT
    ==============================================================================
    Design: VRS Artelier Cyber-Dark, 100% Signature Neon Magenta Pink (#FF408C)
    Handles navigation categories, quick filters (All, Pinned, Active),
    live badge counters, and the User Profile footer with headshot avatar.
    ==============================================================================
]]

local cloneref = (cloneref or clonereference or function(i) return i end)
local Players = cloneref(game:GetService("Players"))
local TweenService = cloneref(game:GetService("TweenService"))
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local Sidebar = {}

function Sidebar.Create(window, parent)
    local VRSLib = window.VRSLib
    local sidebarFrame = Instance.new("Frame")
    sidebarFrame.Name = "Sidebar"
    sidebarFrame.Size = UDim2.new(0, 175, 1, -44)
    sidebarFrame.Position = UDim2.new(0, 0, 0, 44)
    sidebarFrame.BackgroundColor3 = VRSLib.Theme.Sidebar
    sidebarFrame.BorderSizePixel = 0
    sidebarFrame.Parent = parent

    -- Right subtle divider border
    local border = Instance.new("Frame")
    border.Size = UDim2.new(0, 1, 1, 0)
    border.Position = UDim2.new(1, -1, 0, 0)
    border.BackgroundColor3 = VRSLib.Theme.Outline
    border.BorderSizePixel = 0
    border.Parent = sidebarFrame

    -- Navigation scroll container
    local navScroll = Instance.new("ScrollingFrame")
    navScroll.Name = "NavScroll"
    navScroll.Size = UDim2.new(1, 0, 1, -54)
    navScroll.Position = UDim2.new(0, 0, 0, 0)
    navScroll.BackgroundTransparency = 1
    navScroll.BorderSizePixel = 0
    navScroll.ScrollBarThickness = 2
    navScroll.ScrollBarImageColor3 = VRSLib.Theme.Outline
    navScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    navScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    navScroll.Parent = sidebarFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = navScroll

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = navScroll

    -- Profile Footer
    local profileBar = Instance.new("Frame")
    profileBar.Name = "ProfileBar"
    profileBar.Size = UDim2.new(1, 0, 0, 54)
    profileBar.Position = UDim2.new(0, 0, 1, -54)
    profileBar.BackgroundColor3 = VRSLib.Theme.Sidebar
    profileBar.BorderSizePixel = 0
    profileBar.Parent = sidebarFrame

    local profBorder = Instance.new("Frame")
    profBorder.Size = UDim2.new(1, 0, 0, 1)
    profBorder.BackgroundColor3 = VRSLib.Theme.Outline
    profBorder.BorderSizePixel = 0
    profBorder.Parent = profileBar

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.fromOffset(28, 28)
    avatarImg.Position = UDim2.new(0, 10, 0.5, -14)
    avatarImg.BackgroundColor3 = VRSLib.Theme.Card
    avatarImg.BorderSizePixel = 0
    avatarImg.Parent = profileBar

    local avCorner = Instance.new("UICorner")
    avCorner.CornerRadius = UDim.new(1, 0)
    avCorner.Parent = avatarImg

    task.spawn(function()
        pcall(function()
            local content = Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
            avatarImg.Image = content
        end)
    end)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -78, 0, 18)
    nameLabel.Position = UDim2.new(0, 44, 0.5, -9)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = LocalPlayer.DisplayName or LocalPlayer.Name
    nameLabel.TextColor3 = VRSLib.Theme.TextPrimary
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = profileBar

    local settingsBtn = Instance.new("TextButton")
    settingsBtn.Size = UDim2.fromOffset(26, 26)
    settingsBtn.Position = UDim2.new(1, -34, 0.5, -13)
    settingsBtn.BackgroundTransparency = 1
    settingsBtn.Text = ""
    settingsBtn.Parent = profileBar

    local gearIcon = Instance.new("ImageLabel")
    gearIcon.Size = UDim2.fromOffset(15, 15)
    gearIcon.Position = UDim2.new(0.5, -7.5, 0.5, -7.5)
    gearIcon.BackgroundTransparency = 1
    gearIcon.Image = VRSLib.Icons.Get("settings")
    gearIcon.ImageColor3 = VRSLib.Theme.TextMuted
    gearIcon.Parent = settingsBtn

    settingsBtn.MouseEnter:Connect(function()
        TweenService:Create(gearIcon, TweenInfo.new(0.15), {
            ImageColor3 = VRSLib.Theme.Accent,
            Rotation = 45
        }):Play()
    end)
    settingsBtn.MouseLeave:Connect(function()
        TweenService:Create(gearIcon, TweenInfo.new(0.15), {
            ImageColor3 = VRSLib.Theme.TextMuted,
            Rotation = 0
        }):Play()
    end)

    return {
        Frame = sidebarFrame,
        NavScroll = navScroll,
        ProfileBar = profileBar,
        SettingsButton = settingsBtn,
    }
end

return Sidebar
