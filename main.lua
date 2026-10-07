--// SYADZZ HUB
--// Main Hub

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local Hub = {
    Name = "SYADZZ HUB",
    Version = "1.0.0",

    Config = {
        AutoSteal = false,
        StealFromPlayers = false,
        AutoPlace = false,
        AutoSpeed = false,

        MinKG = 0,
        Rarity = "Any",
        Priority = "Rarity",
    },

    Adapter = nil
}

--==================================================
-- GAME ADAPTER
--==================================================

local adapters = {
    [107778070777162] =
        "https://raw.githubusercontent.com/rasyad0907-a11y/syadzzhub/main/games/steal-an-egg.lua"
}

local adapterURL = adapters[game.PlaceId]

if adapterURL then

    local success, source = pcall(function()
        return game:HttpGet(adapterURL)
    end)

    if success then

        local fn, err = loadstring(source)

        if fn then

            local ok, result = pcall(fn)

            if ok then
                Hub.Adapter = result
            else
                warn("[SYADZZ HUB] Adapter error:", result)
            end

        else
            warn("[SYADZZ HUB] Compile error:", err)
        end

    else
        warn("[SYADZZ HUB] Failed to load adapter:", source)
    end

else
    warn("[SYADZZ HUB] Game belum didukung:", game.PlaceId)
end


--==================================================
-- UI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "SYADZZ_HUB"
gui.ResetOnSpawn = false

pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)

if not gui.Parent then
    gui.Parent = Player:WaitForChild("PlayerGui")
end


local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(520, 430)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
main.BorderSizePixel = 0
main.Parent = gui


local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main


--==================================================
-- TITLE
--==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 45)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "SYADZZ HUB"
title.TextColor3 = Color3.fromRGB(255, 217, 0)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main


local gameLabel = Instance.new("TextLabel")
gameLabel.Size = UDim2.new(1, -20, 0, 25)
gameLabel.Position = UDim2.fromOffset(10, 45)
gameLabel.BackgroundTransparency = 1
gameLabel.Text = "Steal An Egg  •  " .. tostring(game.PlaceId)
gameLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
gameLabel.TextSize = 13
gameLabel.Font = Enum.Font.Gotham
gameLabel.TextXAlignment = Enum.TextXAlignment.Left
gameLabel.Parent = main


--==================================================
-- CONTENT
--==================================================

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -85)
content.Position = UDim2.fromOffset(10, 75)
content.BackgroundTransparency = 1
content.Parent = main


local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = content


--==================================================
-- TOGGLE
--==================================================

local function createToggle(name, key)

    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1, 0, 0, 42)

    button.BackgroundColor3 =
        Color3.fromRGB(32, 32, 38)

    button.BorderSizePixel = 0

    button.Text = name .. "   [ OFF ]"

    button.TextColor3 =
        Color3.fromRGB(235, 235, 235)

    button.TextSize = 14

    button.Font = Enum.Font.GothamMedium

    button.Parent = content


    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = button


    local function refresh()

        if Hub.Config[key] then

            button.Text = name .. "   [ ON ]"

            button.BackgroundColor3 =
                Color3.fromRGB(55, 45, 5)

        else

            button.Text = name .. "   [ OFF ]"

            button.BackgroundColor3 =
                Color3.fromRGB(32, 32, 38)

        end

    end


    button.MouseButton1Click:Connect(function()

        Hub.Config[key] = not Hub.Config[key]

        refresh()

    end)

end


createToggle("Auto Steal", "AutoSteal")
createToggle("Steal From Players", "StealFromPlayers")
createToggle("Auto Place To Pen", "AutoPlace")
createToggle("Auto Steal Speed", "AutoSpeed")


--==================================================
-- STATUS
--==================================================

local status = Instance.new("TextLabel")

status.Size = UDim2.new(1, 0, 0, 35)

status.BackgroundTransparency = 1

status.Text =
    Hub.Adapter
    and "● Adapter loaded"
    or "● Adapter belum tersedia"

status.TextColor3 =
    Hub.Adapter
    and Color3.fromRGB(100, 255, 120)
    or Color3.fromRGB(255, 120, 120)

status.TextSize = 13

status.Font = Enum.Font.Gotham

status.Parent = content


--==================================================
-- FEATURE LOOP
--==================================================

task.spawn(function()

    while gui.Parent do

        task.wait(0.2)

        if not Hub.Adapter then
            continue
        end

        if Hub.Config.AutoSteal then

            if Hub.Adapter.AutoSteal then
                pcall(function()
                    Hub.Adapter:AutoSteal(Hub.Config)
                end)
            end

        end

        if Hub.Config.StealFromPlayers then

            if Hub.Adapter.StealFromPlayers then
                pcall(function()
                    Hub.Adapter:StealFromPlayers(Hub.Config)
                end)
            end

        end

        if Hub.Config.AutoPlace then

            if Hub.Adapter.AutoPlace then
                pcall(function()
                    Hub.Adapter:AutoPlace(Hub.Config)
                end)
            end

        end

        if Hub.Config.AutoSpeed then

            if Hub.Adapter.AutoSpeed then
                pcall(function()
                    Hub.Adapter:AutoSpeed(Hub.Config)
                end)
            end

        end

    end

end)


print("================================")
print("SYADZZ HUB LOADED")
print("PlaceId:", game.PlaceId)
print("Adapter:", Hub.Adapter and "OK" or "NONE")
print("================================")
