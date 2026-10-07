--==================================================
-- SYADZZ HUB
-- UI ONLY - OPEN / CLOSE / DRAG
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

if not player then
    warn("[SYADZZ] LocalPlayer belum tersedia.")
    return
end

local function getUIParent()
    -- Untuk environment yang menyediakan gethui()
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then
            return result
        end
    end

    -- Fallback Roblox normal
    return player:WaitForChild("PlayerGui")
end

local uiParent = getUIParent()

--==================================================
-- HAPUS GUI LAMA
--==================================================

pcall(function()
    local old = uiParent:FindFirstChild("SYADZZ_HUB")
    if old then
        old:Destroy()
    end
end)

--==================================================
-- SCREEN GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "SYADZZ_HUB"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999999
gui.Parent = uiParent

--==================================================
-- OPEN BUTTON
--==================================================

local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.fromOffset(110, 42)
openButton.Position = UDim2.new(0, 15, 0.5, -21)
openButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
openButton.BorderSizePixel = 0
openButton.Text = "SYADZZ"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = 16
openButton.Font = Enum.Font.GothamBold
openButton.AutoButtonColor = false
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
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Size = UDim2.fromOffset(500, 350)
main.Position = UDim2.fromScale(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
main.BorderSizePixel = 0
main.Visible = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 70)
mainStroke.Thickness = 1
mainStroke.Parent = main

--==================================================
-- HEADER
--==================================================

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 62)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(18, 8)
title.Size = UDim2.new(1, -80, 0, 26)
title.Text = "SYADZZ HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 21
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(19, 34)
subtitle.Size = UDim2.new(1, -80, 0, 18)
subtitle.Text = "SYADZZHUB • CONTROL PANEL"
subtitle.TextColor3 = Color3.fromRGB(130, 130, 140)
subtitle.TextSize = 10
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

--==================================================
-- CLOSE BUTTON
--==================================================

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.fromOffset(36, 36)
closeButton.Position = UDim2.new(1, -48, 0, 13)
closeButton.BackgroundColor3 = Color3.fromRGB(38, 38, 45)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 24
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 9)
closeCorner.Parent = closeButton

--==================================================
-- CONTENT
--==================================================

local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Position = UDim2.fromOffset(15, 76)
content.Size = UDim2.new(1, -30, 1, -91)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.ScrollingDirection = Enum.ScrollingDirection.Y
content.Parent = main

local padding = Instance.new("UIPadding")
padding.PaddingBottom = UDim.new(0, 8)
padding.Parent = content

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 9)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

--==================================================
-- FEATURE CREATOR
--==================================================

local function createFeature(name, description)
    local button = Instance.new("TextButton")

    button.Name = name:gsub("%s+", "_")
    button.Size = UDim2.new(1, -4, 0, 62)
    button.BackgroundColor3 = Color3.fromRGB(23, 23, 29)
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(43, 43, 52)
    stroke.Thickness = 1
    stroke.Parent = button

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.fromOffset(14, 8)
    nameLabel.Size = UDim2.new(1, -95, 0, 22)
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = button

    local descLabel = Instance.new("TextLabel")
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.fromOffset(14, 31)
    descLabel.Size = UDim2.new(1, -28, 0, 18)
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(130, 130, 140)
    descLabel.TextSize = 11
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = button

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.BackgroundTransparency = 1
    status.AnchorPoint = Vector2.new(1, 0.5)
    status.Position = UDim2.new(1, -14, 0.5, -2)
    status.Size = UDim2.fromOffset(48, 25)
    status.Text = "OFF"
    status.TextColor3 = Color3.fromRGB(150, 150, 160)
    status.TextSize = 12
    status.Font = Enum.Font.GothamBold
    status.Parent = button

    local enabled = false

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(29, 29, 36)
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(23, 23, 29)
    end)

    button.MouseButton1Click:Connect(function()
        enabled = not enabled

        if enabled then
            status.Text = "ON"
            status.TextColor3 = Color3.fromRGB(80, 255, 140)

            stroke.Color = Color3.fromRGB(80, 255, 140)

            print("[SYADZZ] " .. name .. " -> ON")
        else
            status.Text = "OFF"
            status.TextColor3 = Color3.fromRGB(150, 150, 160)

            stroke.Color = Color3.fromRGB(43, 43, 52)

            print("[SYADZZ] " .. name .. " -> OFF")
        end
    end)

    return button
end

--==================================================
-- FEATURES
--==================================================

createFeature(
    "AUTO STEAL",
    "Automatically select matching eggs"
)

createFeature(
    "STEAL FROM PLAYERS",
    "Player target settings"
)

createFeature(
    "AUTO STEAL SPEED",
    "Automatic speed settings"
)

createFeature(
    "AUTO PLACE TO PEN",
    "Automatically place selected eggs"
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
-- DRAG SYSTEM
--==================================================

local dragging = false
local dragStart = nil
local startPosition = nil

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
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

--==================================================
-- READY
--==================================================

print("================================")
print("[SYADZZ HUB] PANEL LOADED")
print("[SYADZZ HUB] UI Parent:", uiParent:GetFullName())
print("[SYADZZ HUB] Ready")
print("================================")
