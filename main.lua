local Players = game:GetService("Players")

repeat
    task.wait()
until Players.LocalPlayer

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "SYADZZ_TEST_2"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(650, 420)
main.Position = UDim2.new(0.5, -325, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 50)
title.Position = UDim2.fromOffset(15, 15)
title.BackgroundTransparency = 1
title.Text = "SYADZZ HUB"
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

print("[SYADZZ] PANEL TEST BERHASIL")
