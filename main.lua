local Players = game:GetService("Players")
local player = Players.LocalPlayer

local targetPosition = Vector3.new(
    2277.34765625,
    68.02506256103516,
    -331.1116638183594
)

local function teleportToEgg()
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")

    root.CFrame = CFrame.new(targetPosition + Vector3.new(0, 4, 0))
end

teleportToEgg()
