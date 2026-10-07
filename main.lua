--==================================================
-- SYADZZ HUB - PRACTICE / SIMULATION
-- UI exploit-style, fitur hanya simulasi
--==================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local Config = {
    AutoSteal = true,
    StealPlayers = true,
    AutoPlace = true,
    AutoSpeed = true,

    MinKG = 0,
    Priority = "Rarity",

    Running = true
}

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "SYADZZ_HUB"
Gui.ResetOnSpawn = false
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- MAIN
--==================================================

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(560, 390)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

--==================================================
-- TOP BAR
--==================================================

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 58)
Top.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Top.BorderSizePixel = 0
Top.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Position = UDim2.fromOffset(15, 8)
Title.BackgroundTransparency = 1
Title.Text = "SYADZZ HUB"
Title.TextColor3 = Color3.fromRGB(255, 217, 0)
Title.TextSize = 23
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, -30, 0, 18)
Version.Position = UDim2.fromOffset(16, 34)
Version.BackgroundTransparency = 1
Version.Text = "Practice Build  •  Simulation Mode"
Version.TextColor3 = Color3.fromRGB(130, 130, 140)
Version.TextSize = 11
Version.Font = Enum.Font.Gotham
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Top

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(145, 310)
Sidebar.Position = UDim2.fromOffset(12, 68)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = Sidebar

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -170, 1, -80)
Content.Position = UDim2.fromOffset(158, 68)
Content.BackgroundTransparency = 1
Content.Parent = Main

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -10, 0, 28)
Status.Position = UDim2.new(0, 5, 1, -32)
Status.BackgroundTransparency = 1
Status.Text = "● Ready"
Status.TextColor3 = Color3.fromRGB(100, 255, 120)
Status.TextSize = 13
Status.Font = Enum.Font.GothamMedium
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Content

local function SetStatus(text, color)
    Status.Text = "● " .. text
    Status.TextColor3 = color or Color3.fromRGB(100, 255, 120)
end

--==================================================
-- TAB SYSTEM
--==================================================

local Tabs = {}

local function CreateTab(name, y)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -16, 0, 40)
    Button.Position = UDim2.fromOffset(8, y)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    Button.BorderSizePixel = 0
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(220, 220, 225)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium
    Button.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    Tabs[name] = Button

    return Button
end

local MainTab = CreateTab("MAIN", 10)
local SettingsTab = CreateTab("SETTINGS", 58)
local InfoTab = CreateTab("INFO", 106)

--==================================================
-- CLEAR CONTENT
--==================================================

local function ClearContent()

    for _, obj in ipairs(Content:GetChildren()) do
        if obj ~= Status then
            obj:Destroy()
        end
    end

end

--==================================================
-- SECTION
--==================================================

local function CreateSection(text, y)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 25)
    Label.Position = UDim2.fromOffset(5, y)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 217, 0)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Content

end

--==================================================
-- TOGGLE
--==================================================

local function CreateToggle(text, configName, y)

    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, -10, 0, 42)
    Button.Position = UDim2.fromOffset(5, y)

    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    Button.BorderSizePixel = 0

    Button.Text = text .. "   [ OFF ]"
    Button.TextColor3 = Color3.fromRGB(235, 235, 240)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium

    Button.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    local function Update()

        if Config[configName] then

            Button.Text = text .. "   [ ON ]"
            Button.BackgroundColor3 = Color3.fromRGB(65, 55, 5)

        else

            Button.Text = text .. "   [ OFF ]"
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 36)

        end

    end

    Button.MouseButton1Click:Connect(function()

        Config[configName] = not Config[configName]

        Update()

        if Config[configName] then
            SetStatus(text .. " enabled")
        else
            SetStatus(text .. " disabled")
        end

        print("[SYADZZ]", configName, Config[configName])

    end)

    Update()

end

--==================================================
-- MAIN TAB
--==================================================

local function ShowMain()

    ClearContent()

    CreateSection("FEATURES", 5)

    CreateToggle("Auto Steal", "AutoSteal", 35)
    CreateToggle("Steal From Players", "StealPlayers", 83)
    CreateToggle("Auto Place To Pen", "AutoPlace", 131)
    CreateToggle("Auto Steal Speed", "AutoSpeed", 179)

    CreateSection("SIMULATION", 230)

    local Simulate = Instance.new("TextButton")
    Simulate.Size = UDim2.new(1, -10, 0, 42)
    Simulate.Position = UDim2.fromOffset(5, 260)
    Simulate.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    Simulate.BorderSizePixel = 0
    Simulate.Text = "RUN SIMULATION"
    Simulate.TextColor3 = Color3.fromRGB(255, 217, 0)
    Simulate.TextSize = 13
    Simulate.Font = Enum.Font.GothamBold
    Simulate.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Simulate

    Simulate.MouseButton1Click:Connect(function()

        SetStatus(
            "Simulation running...",
            Color3.fromRGB(255, 217, 0)
        )

        task.wait(1)

        print("[SYADZZ SIMULATION]")
        print("AutoSteal:", Config.AutoSteal)
        print("StealPlayers:", Config.StealPlayers)
        print("AutoPlace:", Config.AutoPlace)
        print("AutoSpeed:", Config.AutoSpeed)

        SetStatus(
            "Simulation complete",
            Color3.fromRGB(100, 255, 120)
        )

    end)

end

--==================================================
-- SETTINGS TAB
--==================================================

local function ShowSettings()

    ClearContent()

    CreateSection("SETTINGS", 5)

    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -10, 0, 80)
    Info.Position = UDim2.fromOffset(5, 40)
    Info.BackgroundTransparency = 1
    Info.Text =
        "Minimum KG: " .. tostring(Config.MinKG) ..
        "\nPriority: " .. Config.Priority ..
        "\nMode: Simulation"

    Info.TextColor3 = Color3.fromRGB(210, 210, 215)
    Info.TextSize = 13
    Info.Font = Enum.Font.Gotham
    Info.TextXAlignment = Enum.TextXAlignment.Left
    Info.TextYAlignment = Enum.TextYAlignment.Top
    Info.Parent = Content

end

--==================================================
-- INFO TAB
--==================================================

local function ShowInfo()

    ClearContent()

    CreateSection("SYADZZ HUB", 5)

    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, -10, 0, 150)
    Info.Position = UDim2.fromOffset(5, 40)
    Info.BackgroundTransparency = 1

    Info.Text =
        "Practice Hub\n\n" ..
        "This build demonstrates the structure of\n" ..
        "an exploit-style hub without performing\n" ..
        "actions against third-party game systems.\n\n" ..
        "Version: 1.0.0"

    Info.TextColor3 = Color3.fromRGB(200, 200, 205)
    Info.TextSize = 13
    Info.Font = Enum.Font.Gotham
    Info.TextXAlignment = Enum.TextXAlignment.Left
    Info.TextYAlignment = Enum.TextYAlignment.Top
    Info.Parent = Content

end

--==================================================
-- TAB EVENTS
--==================================================

MainTab.MouseButton1Click:Connect(ShowMain)
SettingsTab.MouseButton1Click:Connect(ShowSettings)
InfoTab.MouseButton1Click:Connect(ShowInfo)

--==================================================
-- DRAG WINDOW
--==================================================

local dragging = false
local dragStart
local startPos

Top.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end

        end)

    end

end)

Top.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseMovement then

        input.Changed:Connect(function()

            if dragging then

                local delta = input.Position - dragStart

                Main.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )

            end

        end)

    end

end)

--==================================================
-- START
--==================================================

ShowMain()

print("================================")
print("       SYADZZ HUB")
print("    PRACTICE BUILD")
print("================================")
print("Hub loaded successfully.")
print("Simulation mode: ON")
