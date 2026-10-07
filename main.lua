--========================================================--
--                      SYADZZ HUB V3                    --
--          Single window / robust GitHub UI             --
--========================================================--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player then
    warn("[SYADZZ HUB] LocalPlayer belum tersedia. Jalankan dari sisi client.")
    return
end

local playerGui = player:WaitForChild("PlayerGui")
local GUI_NAME = "SYADZZ_HUB"
local LOGO_ID = "rbxassetid://78801214923364"

-- Hapus panel SYADZZ lama agar tidak numpuk.
local oldGui = playerGui:FindFirstChild(GUI_NAME)
if oldGui then
    oldGui:Destroy()
end

local THEME = {
    bg = Color3.fromRGB(14, 14, 19),
    top = Color3.fromRGB(11, 11, 16),
    side = Color3.fromRGB(10, 10, 14),
    card = Color3.fromRGB(23, 23, 30),
    card2 = Color3.fromRGB(28, 28, 36),
    text = Color3.fromRGB(245, 245, 250),
    sub = Color3.fromRGB(150, 150, 165),
    accent = Color3.fromRGB(145, 92, 255),
    accentSoft = Color3.fromRGB(39, 30, 58),
    off = Color3.fromRGB(63, 63, 75),
    white = Color3.fromRGB(255, 255, 255),
}

local function addCorner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

local function addStroke(obj, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(50, 50, 60)
    s.Transparency = transparency or 0
    s.Thickness = 1
    s.Parent = obj
    return s
end

local function addLabel(parent, text, size, pos, textSize, color)
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

local function addButton(parent, text, size, pos)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.Size = size
    b.Position = pos
    b.Text = text
    b.TextSize = 13
    b.Font = Enum.Font.Gotham
    b.TextColor3 = THEME.text
    b.BackgroundColor3 = THEME.card
    b.BorderSizePixel = 0
    b.Parent = parent
    addCorner(b, 9)
    return b
end

local function safeTween(obj, info, props)
    local ok, result = pcall(function()
        return TweenService:Create(obj, info, props)
    end)
    if ok and result then
        result:Play()
    end
end

--========================================================--
