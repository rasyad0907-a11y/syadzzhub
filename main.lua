--// SYADZZ PRIVATE SCRIPT
--// LocalScript -> StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- PASSWORD
local PASSWORD = "SYADZZ123"

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "SyadzzPrivateScript"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main password window
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 220)
main.Position = UDim2.new(0.5, -170, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 217, 0)
stroke.Thickness = 2
stroke.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "SYADZZ PRIVATE SCRIPT"
title.TextColor3 = Color3.fromRGB(255, 217, 0)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = main

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -30, 0, 25)
subtitle.Position = UDim2.new(0, 15, 0, 48)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Enter password to continue"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextSize = 14
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = main

-- Password textbox
local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(1, -40, 0, 42)
textbox.Position = UDim2.new(0, 20, 0, 85)
textbox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
textbox.BorderSizePixel = 0
textbox.PlaceholderText = "Password"
textbox.Text = ""
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textbox.TextSize = 15
textbox.Font = Enum.Font.Gotham
textbox.ClearTextOnFocus = false
textbox.Parent = main

local textCorner = Instance.new("UICorner")
textCorner.CornerRadius = UDim.new(0, 8)
textCorner.Parent = textbox

-- Unlock button
local unlock = Instance.new("TextButton")
unlock.Size = UDim2.new(1, -40, 0, 42)
unlock.Position = UDim2.new(0, 20, 0, 140)
unlock.BackgroundColor3 = Color3.fromRGB(255, 217, 0)
unlock.BorderSizePixel = 0
unlock.Text = "UNLOCK"
unlock.TextColor3 = Color3.fromRGB(0, 0, 0)
unlock.TextSize = 15
unlock.Font = Enum.Font.GothamBold
unlock.Parent = main

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = unlock

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 1, 5)
status.BackgroundTransparency = 1
status.Text = ""
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.Parent = main

--==================================================
-- MENU SETELAH PASSWORD BENAR
--==================================================

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 380, 0, 300)
menu.Position = UDim2.new(0.5, -190, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = gui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menu

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(255, 217, 0)
menuStroke.Thickness = 2
menuStroke.Parent = menu

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, 0, 0, 55)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "SYADZZ PRIVATE SCRIPT"
menuTitle.TextColor3 = Color3.fromRGB(255, 217, 0)
menuTitle.TextSize = 21
menuTitle.Font = Enum.Font.GothamBold
menuTitle.Parent = menu

local welcome = Instance.new("TextLabel")
welcome.Size = UDim2.new(1, -30, 0, 35)
welcome.Position = UDim2.new(0, 15, 0, 55)
welcome.BackgroundTransparency = 1
welcome.Text = "✓ Successfully unlocked"
welcome.TextColor3 = Color3.fromRGB(100, 255, 130)
welcome.TextSize = 15
welcome.Font = Enum.Font.GothamBold
welcome.Parent = menu

-- Contoh tombol menu
local function createButton(text, y)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -40, 0, 45)
    button.Position = UDim2.new(0, 20, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = menu

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = button

    return button
end

local button1 = createButton("⚡ OPTION 1", 105)
local button2 = createButton("🔥 OPTION 2", 160)
local button3 = createButton("⚙ SETTINGS", 215)

--==================================================
-- UNLOCK
--==================================================

local function checkPassword()
    if textbox.Text == PASSWORD then

        status.Text = "✓ Correct password"
        status.TextColor3 = Color3.fromRGB(100, 255, 130)

        task.wait(0.5)

        main.Visible = false
        menu.Visible = true

    else

        status.Text = "✕ Wrong password"
        status.TextColor3 = Color3.fromRGB(255, 80, 80)

        textbox.Text = ""

        task.wait(1)

        status.Text = ""
    end
end

unlock.MouseButton1Click:Connect(checkPassword)

textbox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        checkPassword()
    end
end)
