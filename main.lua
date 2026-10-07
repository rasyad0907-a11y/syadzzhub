-- SYADZZ HUB
-- Panel Open / Close
-- Taruh sebagai LocalScript di StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Hapus GUI lama kalau ada
local oldGui = playerGui:FindFirstChild("SYADZZ_HUB")
if oldGui then
    oldGui:Destroy()
end

--==================================================
-- SCREEN GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "SYADZZ_HUB"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

--==================================================
-- OPEN BUTTON
--==================================================

local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.fromOffset(100, 38)
openButton.Position = UDim2.new(0, 15, 0.5, -19)
openButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Text = "SYADZZ"
openButton.TextSize = 16
openButton.Font = Enum.Font.GothamBold
openButton.Visible = false
openButton.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 10)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(80, 255, 140)
openStroke.Thickness = 1.5
openStroke.Parent = openButton

--==================================================
-- MAIN PANEL
--==================================================

local main = Instance.new("Frame")
main.Name = "MainPanel"
main.Size = UDim2.fromOffset(470, 330)
main.Position = UDim2.new(0.5, -235, 0.5, -165)
main.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(65, 65, 75)
mainStroke.Thickness = 1
mainStroke.Parent = main

--==================================================
-- HEADER
--==================================================

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 55)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(18, 7)
title.Size = UDim2.new(1, -100, 0, 25)
title.Text = "SYADZZ HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(19, 31)
subtitle.Size = UDim2.new(1, -100, 0, 17)
subtitle.Text = "SYADZZHUB"
subtitle.TextColor3 = Color3.fromRGB(120, 120, 130)
subtitle.TextSize = 11
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

--==================================================
-- CLOSE BUTTON
--==================================================

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.fromOffset(34, 34)
closeButton.Position = UDim2.new(1, -45, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 23
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 9)
closeCorner.Parent = closeButton

--==================================================
-- CONTENT
--==================================================

local content = Instance.new("Frame")
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.fromOffset(15, 70)
content.Size = UDim2.new(1, -30, 1, -85)
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 9)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

--==================================================
-- FEATURE BUTTON FUNCTION
--==================================================

local function createFeature(name, description, callback)
    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1, 0, 0, 58)
    button.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 55)
    stroke.Thickness = 1
    stroke.Parent = button

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.fromOffset(14, 8)
    nameLabel.Size = UDim2.new(1, -28, 0, 20)
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = button

    local descLabel = Instance.new("TextLabel")
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.fromOffset(14, 29)
    descLabel.Size = UDim2.new(1, -28, 0, 18)
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(135, 135, 145)
    descLabel.TextSize = 11
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = button

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 37)
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    end)

    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return button
end

--==================================================
-- FITUR
--==================================================

createFeature(
    "AUTO STEAL",
    "Pengaturan otomatis",
    function()
        print("Auto Steal dipilih")
    end
)

createFeature(
    "STEAL FROM PLAYERS",
    "Pengaturan target player",
    function()
        print("Steal From Players dipilih")
    end
)

createFeature(
    "AUTO STEAL SPEED",
    "Pengaturan speed",
    function()
        print("Auto Steal Speed dipilih")
    end
)

createFeature(
    "AUTO PLACE TO PEN",
    "Pengaturan penempatan",
    function()
        print("Auto Place To Pen dipilih")
    end
)

--==================================================
-- OPEN / CLOSE
--==================================================

closeButton.MouseButton1Click:Connect(function()
    main.Visible = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    main.Visible = true
    openButton.Visible = false
end)

--==================================================
-- DRAG PANEL
--==================================================

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)
