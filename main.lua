local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "SYADZZ_HUB"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(450, 300)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 45)
title.Position = UDim2.fromOffset(10, 10)
title.BackgroundTransparency = 1
title.Text = "SYADZZ HUB"
title.TextColor3 = Color3.fromRGB(255, 217, 0)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local gameName = Instance.new("TextLabel")
gameName.Size = UDim2.new(1, -20, 0, 30)
gameName.Position = UDim2.fromOffset(10, 55)
gameName.BackgroundTransparency = 1
gameName.Text = "STEAL AN EGG"
gameName.TextColor3 = Color3.fromRGB(220, 220, 220)
gameName.TextSize = 15
gameName.Font = Enum.Font.Gotham
gameName.TextXAlignment = Enum.TextXAlignment.Left
gameName.Parent = frame

local function button(name, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 42)
    b.Position = UDim2.fromOffset(10, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    b.Text = name .. "  [ OFF ]"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    b.Font = Enum.Font.GothamMedium
    b.Parent = frame

    local enabled = false

    b.MouseButton1Click:Connect(function()
        enabled = not enabled
        b.Text = name .. (enabled and "  [ ON ]" or "  [ OFF ]")
    end)
end

button("Auto Steal", 95)
button("Auto Place", 145)
button("Speed", 195)

print("[SYADZZ HUB] Loaded")
