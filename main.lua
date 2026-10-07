local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "SYADZZ_PANEL"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(300, 360)
frame.Position = UDim2.new(0, 25, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 50)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "SYADZZ HUB"
title.TextColor3 = Color3.fromRGB(255, 217, 0)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.fromOffset(10, 55)
status.BackgroundTransparency = 1
status.Text = "STATUS : LOADED"
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.TextSize = 14
status.Font = Enum.Font.Gotham
status.Parent = frame

local function createButton(text, y)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 0, 45)
    button.Position = UDim2.fromOffset(15, y)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 15
    button.Font = Enum.Font.GothamBold
    button.Parent = frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = button

    return button
end

local autoSteal = createButton("AUTO STEAL : OFF", 100)
local stealPlayers = createButton("STEAL FROM PLAYERS : OFF", 155)
local autoPen = createButton("AUTO PLACE TO PEN : OFF", 210)
local close = createButton("CLOSE PANEL", 265)

local enabled = false
local playerSteal = false
local pen = false

autoSteal.MouseButton1Click:Connect(function()
    enabled = not enabled

    autoSteal.Text =
        "AUTO STEAL : " .. (enabled and "ON" or "OFF")

    status.Text =
        "STATUS : AUTO STEAL " ..
        (enabled and "ON" or "OFF")
end)

stealPlayers.MouseButton1Click:Connect(function()
    playerSteal = not playerSteal

    stealPlayers.Text =
        "STEAL FROM PLAYERS : " ..
        (playerSteal and "ON" or "OFF")
end)

autoPen.MouseButton1Click:Connect(function()
    pen = not pen

    autoPen.Text =
        "AUTO PLACE TO PEN : " ..
        (pen and "ON" or "OFF")
end)

close.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

print("[SYADZZ] PANEL LOADED")
