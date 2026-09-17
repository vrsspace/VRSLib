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
-- Smart Mobile Detection Engine
function Utils.IsMobile()
    local isTouch = UserInputService.TouchEnabled
    local hasKeyboard = UserInputService.KeyboardEnabled
    local hasMouse = UserInputService.MouseEnabled

    if isTouch and (not hasKeyboard or not hasMouse) then
        return true
    end

    local cam = workspace.CurrentCamera
    if cam and cam.ViewportSize then
        local vp = cam.ViewportSize
        if vp.X > 0 and vp.Y > 0 then
            if vp.X < 960 or vp.Y < 580 then
                return true
            end
        end
    end

    return false
end

-- Smart Adaptive Scale Calculator
function Utils.CalculateSmartScale(baseW, baseH, isMobile, customMobileScale, desktopScale)
    local cam = workspace.CurrentCamera
    local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
    if vp.X <= 0 or vp.Y <= 0 then return 1.0 end

    local padX = isMobile and 24 or 40
    local padY = isMobile and 20 or 40
    local maxW = math.max(260, vp.X - padX)
    local maxH = math.max(200, vp.Y - padY)

    local scaleX = maxW / (baseW or 1020)
    local scaleY = maxH / (baseH or 620)
    local ideal = math.min(scaleX, scaleY)

    if isMobile then
        if customMobileScale then
            ideal = math.min(customMobileScale, ideal)
        else
            ideal = math.min(ideal, 0.72)
        end
    else
        ideal = math.min(desktopScale or 1.0, ideal)
    end

    return math.clamp(ideal, 0.45, 1.0)
end

return Utils
