--[[
    ==============================================================================
    🌸 VRS ARTELIER — UTILITIES MODULE
    ==============================================================================
    Design: VRS Artelier Cyber-Dark, 100% Signature Neon Magenta Pink (#FF408C)
    Safe execution helpers, smooth tweening, window dragging, and brand asset loader.
    ==============================================================================
]]

local cloneref = (cloneref or clonereference or function(i) return i end)
local CoreGui          = cloneref(game:GetService("CoreGui"))
local TweenService     = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService       = cloneref(game:GetService("RunService"))

local Utils = {}

-- Safe GUI Container Resolver
function Utils.GetSafeContainer()
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

-- Protect UI elements from AutoLocalize mutation
function Utils.ProtectLocalization(instance)
    pcall(function() instance.AutoLocalize = false end)
end

-- Smooth Tween Helper
function Utils.Tween(instance, info, properties)
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

-- Official VRS Artelier Wings Logo Loader (FiveManage CDN + Spritesheet Fallback)
local BRAND_LOGO_URL = "https://r2.fivemanage.com/vZukXicMKTGIXYcjmBRsm/Logo/2.png"
local cachedLogoAsset = nil

function Utils.GetBrandLogo()
    if cachedLogoAsset then return cachedLogoAsset end
    local fileName = "vrs_artelier_logo.png"

    if writefile and isfile and (getcustomasset or getsynasset) then
        local customAsset = getcustomasset or getsynasset
        if not isfile(fileName) then
            local s, data = pcall(function()
                return game:HttpGet(BRAND_LOGO_URL)
            end)
            if s and data and #data > 50 then
                pcall(writefile, fileName, data)
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

    -- Fallback to Roblox spritesheet
    return "rbxassetid://132717088484517"
end

-- Make any Frame smoothly draggable
function Utils.MakeDraggable(guiObject, dragHandle, onDragCallback)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local handle = dragHandle or guiObject

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

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
            guiObject.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            if onDragCallback then
                onDragCallback(guiObject.Position)
            end
        end
    end)
end

return Utils
