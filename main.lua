local Players = game:GetService("Players")

repeat
    task.wait()
until Players.LocalPlayer

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "SYADZZ_TEST"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(500, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Parent = gui

print("SYADZZ TEST BERHASIL")
