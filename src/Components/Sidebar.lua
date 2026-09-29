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
    sidebarFrame.Size = UDim2.new(0, 72, 1, -44)
    sidebarFrame.Position = UDim2.new(0, 0, 0, 44)
    sidebarFrame.BackgroundColor3 = VRSLib.Theme.Sidebar
    sidebarFrame.BorderSizePixel = 0
    sidebarFrame.ClipsDescendants = true
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
    navScroll.Size = UDim2.new(1, 0, 1, -58)
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
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = navScroll

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 4)
    padding.Parent = navScroll

    -- Profile Footer (Compact 72px matching Screenshots)
    local profileBar = Instance.new("Frame")
    profileBar.Name = "ProfileBar"
    profileBar.Size = UDim2.new(1, 0, 0, 58)
    profileBar.Position = UDim2.new(0, 0, 1, -58)
    profileBar.BackgroundColor3 = VRSLib.Theme.Sidebar
    profileBar.BorderSizePixel = 0
    profileBar.Parent = sidebarFrame

    local profBorder = Instance.new("Frame")
    profBorder.Size = UDim2.new(1, 0, 0, 1)
    profBorder.BackgroundColor3 = VRSLib.Theme.Outline
    profBorder.BorderSizePixel = 0
    profBorder.Parent = profileBar

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.fromOffset(26, 26)
    avatarImg.Position = UDim2.new(0.5, -13, 0, 6)
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
    nameLabel.Size = UDim2.new(1, -6, 0, 13)
    nameLabel.Position = UDim2.new(0, 3, 0, 33)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = LocalPlayer.DisplayName or LocalPlayer.Name
    nameLabel.TextColor3 = VRSLib.Theme.TextPrimary
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 10
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = profileBar

    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, -6, 0, 11)
    subLabel.Position = UDim2.new(0, 3, 0, 45)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = window.GameName or "Roblox"
    subLabel.TextColor3 = VRSLib.Theme.TextMuted
    subLabel.Font = Enum.Font.GothamMedium
    subLabel.TextSize = 9
    subLabel.TextXAlignment = Enum.TextXAlignment.Center
    subLabel.TextTruncate = Enum.TextTruncate.AtEnd
    subLabel.Parent = profileBar

    return {
        Frame = sidebarFrame,
        NavScroll = navScroll,
        ProfileBar = profileBar,
        SettingsButton = settingsBtn,
    }
end

return Sidebar
