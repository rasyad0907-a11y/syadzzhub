--========================================================--
--                      SYADZZ HUB                        --
--                 UI ONLY / ROBLOX CLIENT                --
--========================================================--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not player then
    warn("[SYADZZ HUB] LocalPlayer belum tersedia.")
    return
end

local playerGui = player:WaitForChild("PlayerGui")
local GUI_NAME = "SYADZZ_HUB"
local LOGO_ID = "rbxassetid://78801214923364"

local old = playerGui:FindFirstChild(GUI_NAME)
if old then old:Destroy() end

local THEME = {
    bg = Color3.fromRGB(13, 13, 18),
    top = Color3.fromRGB(10, 10, 14),
    sidebar = Color3.fromRGB(12, 12, 17),
    card = Color3.fromRGB(23, 23, 30),
    card2 = Color3.fromRGB(29, 29, 37),
    text = Color3.fromRGB(245, 245, 250),
    sub = Color3.fromRGB(153, 153, 168),
    accent = Color3.fromRGB(145, 92, 255),
    accentSoft = Color3.fromRGB(42, 31, 61),
    off = Color3.fromRGB(65, 65, 77),
    white = Color3.fromRGB(255, 255, 255),
    green = Color3.fromRGB(107, 222, 146),
}

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(55, 55, 65)
    s.Transparency = transparency or 0
    s.Thickness = 1
    s.Parent = parent
    return s
end

local function label(parent, text, size, pos, textSize, color)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Size = size
    x.Position = pos
    x.Text = text
    x.TextSize = textSize or 14
    x.Font = Enum.Font.Gotham
    x.TextColor3 = color or THEME.text
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.TextYAlignment = Enum.TextYAlignment.Center
    x.Parent = parent
    return x
end

local function button(parent, text, size, pos)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = THEME.card
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Text = text
    b.TextSize = 13
    b.Font = Enum.Font.Gotham
    b.TextColor3 = THEME.text
    b.Parent = parent
    corner(b, 9)
    return b
end

--========================================================--
-- ROOT GUI
--========================================================--

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui
