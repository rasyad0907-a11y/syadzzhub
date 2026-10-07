--========================================================--
--                        SYADZZ HUB                     --
--        Single-window UI / GitHub main.lua edition    --
--========================================================--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local LOGO_ID = "rbxassetid://78801214923364"
local GUI_NAME = "SYADZZ_HUB"

local Theme = {
    Background = Color3.fromRGB(14, 14, 19),
    Sidebar = Color3.fromRGB(11, 11, 15),
    TopBar = Color3.fromRGB(12, 12, 17),
    Card = Color3.fromRGB(23, 23, 30),
    Card2 = Color3.fromRGB(28, 28, 36),
    Text = Color3.fromRGB(245, 245, 250),
    SubText = Color3.fromRGB(150, 150, 166),
    Accent = Color3.fromRGB(142, 89, 255),
    AccentSoft = Color3.fromRGB(38, 29, 58),
    ToggleOff = Color3.fromRGB(65, 65, 77),
    ToggleOn = Color3.fromRGB(142, 89, 255),
    White = Color3.fromRGB(255, 255, 255),
}

-- Remove the current version of this hub so only ONE panel exists.
local oldHub = PlayerGui:FindFirstChild(GUI_NAME)
if oldHub then
    oldHub:Destroy()
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(50, 50, 60)
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1
    s.Parent = obj
    return s
end

local function label(parent, text, size, pos, fontSize, color)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Size = size
    x.Position = pos
    x.Text = text
    x.TextSize = fontSize or 14
    x.Font = Enum.Font.GothamMedium
    x.TextColor3 = color or Theme.Text
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.TextYAlignment = Enum.TextYAlignment.Center
    x.Parent = parent
    return x
end

local function button(parent, text, size, pos)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.Size = size
    b.Position = pos
    b.Text = text
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.TextColor3 = Theme.Text
    b.BackgroundColor3 = Theme.Card
    b.BorderSizePixel = 0
    b.Parent = parent
    corner(b, 9)
    return b
end

--========================================================--
-- SCREEN GUI / WINDOW
--========================================================--

local Gui = Instance.new("ScreenGui")
Gui.Name = GUI_NAME
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui
