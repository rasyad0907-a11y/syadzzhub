--========================================================--
--                      SYADZZ HUB                        --
--                 AUTO SELL EGG                          --
--========================================================--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not player then
    warn("[SYADZZ HUB] LocalPlayer belum tersedia.")
    return
end

local playerGui = player:WaitForChild("PlayerGui")

local GUI_NAME = "SYADZZ_HUB"
local LOGO_ID = "rbxassetid://78801214923364"

--========================================================--
-- CONFIG
--========================================================--

local AutoSellEgg = false
local SelectedEgg = "ALL"
local SellDelay = 1

--========================================================--
-- THEME
--========================================================--

local THEME = {
    bg = Color3.fromRGB(13, 13, 18),
    top = Color3.fromRGB(10, 10, 14),
    sidebar = Color3.fromRGB(12, 12, 17),
    card = Color3.fromRGB(23, 23, 30),
    card2 = Color3.fromRGB(29, 29, 37),

    text = Color3.fromRGB(245, 245, 250),
    sub = Color3.fromRGB(153, 153, 168),

    accent = Color3.fromRGB(145, 92, 255),
    accentSoft = Color3.fromRGB(42, 31, 61),

    off = Color3.fromRGB(65, 65, 77),
    white = Color3.fromRGB(255, 255, 255),
    green = Color3.fromRGB(107, 222, 146),
    red = Color3.fromRGB(235, 80, 80),
}

--========================================================--
-- CLEAN OLD GUI
--========================================================--

local old = playerGui:FindFirstChild(GUI_NAME)

if old then
    old:Destroy()
end

--========================================================--
-- UI HELPERS
--========================================================--

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, transparency)
    local s = Instance.new("UIStroke")

    s.Color = color or Color3.fromRGB(55, 55, 65)
    s.Transparency = transparency or 0
    s.Thickness = 1

    s.Parent = parent

    return s
end

local function label(parent, text, size, pos, textSize, color)

    local x = Instance.new("TextLabel")

    x.BackgroundTransparency = 1
    x.Size = size
    x.Position = pos
    x.Text = text
    x.TextSize = textSize or 14
    x.Font = Enum.Font.Gotham

    x.TextColor3 = color or THEME.text

    x.TextXAlignment = Enum.TextXAlignment.Left
    x.TextYAlignment = Enum.TextYAlignment.Center

    x.Parent = parent

    return x
end

local function button(parent, text, size, pos)

    local b = Instance.new("TextButton")

    b.Size = size
    b.Position = pos

    b.BackgroundColor3 = THEME.card
    b.BorderSizePixel = 0

    b.AutoButtonColor = false

    b.Text = text
    b.TextSize = 13
    b.Font = Enum.Font.Gotham
    b.TextColor3 = THEME.text

    b.Parent = parent

    corner(b, 9)

    return b
end

--========================================================--
-- ROOT GUI
--========================================================--

local gui = Instance.new("ScreenGui")

gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

gui.Parent = playerGui

--========================================================--
-- MAIN WINDOW
--========================================================--

local main = Instance.new("Frame")

main.Name = "Main"
main.Size = UDim2.new(0, 650, 0, 420)
main.Position = UDim2.new(0.5, -325, 0.5, -210)

main.BackgroundColor3 = THEME.bg
main.BorderSizePixel = 0

main.Parent = gui

corner(main, 14)
stroke(main, Color3.fromRGB(55, 55, 70), 0.25)

--========================================================--
-- TOP BAR
--========================================================--

local top = Instance.new("Frame")

top.Size = UDim2.new(1, 0, 0, 55)
top.BackgroundColor3 = THEME.top
top.BorderSizePixel = 0

top.Parent = main

corner(top, 14)

local logo = Instance.new("ImageLabel")

logo.Size = UDim2.new(0, 35, 0, 35)
logo.Position = UDim2.new(0, 15, 0, 10)

logo.BackgroundTransparency = 1
logo.Image = LOGO_ID

logo.Parent = top

label(
    top,
    "SYADZZ HUB",
    UDim2.new(0, 200, 0, 25),
    UDim2.new(0, 58, 0, 8),
    16,
    THEME.text
)

label(
    top,
    "AUTO SELL SYSTEM",
    UDim2.new(0, 200, 0, 20),
    UDim2.new(0, 58, 0, 28),
    10,
    THEME.sub
)

--========================================================--
-- CLOSE BUTTON
--========================================================--

local close = button(
    top,
    "×",
    UDim2.new(0, 38, 0, 35),
    UDim2.new(1, -48, 0, 10)
)

close.TextSize = 22

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

--========================================================--
-- SIDEBAR
--========================================================--

local sidebar = Instance.new("Frame")

sidebar.Size = UDim2.new(0, 170, 1, -55)
sidebar.Position = UDim2.new(0, 0, 0, 55)

sidebar.BackgroundColor3 = THEME.sidebar
sidebar.BorderSizePixel = 0

sidebar.Parent = main

--========================================================--
-- CONTENT
--========================================================--

local content = Instance.new("Frame")

content.Size = UDim2.new(1, -170, 1, -55)
content.Position = UDim2.new(0, 170, 0, 55)

content.BackgroundTransparency = 1

content.Parent = main

--========================================================--
-- SIDEBAR TITLE
--========================================================--

label(
    sidebar,
    "MENU",
    UDim2.new(1, -30, 0, 30),
    UDim2.new(0, 15, 0, 15),
    11,
    THEME.sub
)

--========================================================--
-- AUTO SELL TAB
--========================================================--

local autoTab = button(
    sidebar,
    "  🥚  Auto Sell Egg",
    UDim2.new(1, -20, 0, 42),
    UDim2.new(0, 10, 0, 50)
)

autoTab.BackgroundColor3 = THEME.accentSoft
autoTab.TextXAlignment = Enum.TextXAlignment.Left

--========================================================--
-- CONTENT TITLE
--========================================================--

label(
    content,
    "Auto Sell Egg",
    UDim2.new(1, -40, 0, 35),
    UDim2.new(0, 20, 0, 20),
    21,
    THEME.text
)

label(
    content,
    "Otomatis menjual Egg melalui menu NPC Sell.",
    UDim2.new(1, -40, 0, 25),
    UDim2.new(0, 20, 0, 52),
    12,
    THEME.sub
)

--========================================================--
-- AUTO SELL CARD
--========================================================--

local card = Instance.new("Frame")

card.Size = UDim2.new(1, -40, 0, 105)
card.Position = UDim2.new(0, 20, 0, 95)

card.BackgroundColor3 = THEME.card
card.BorderSizePixel = 0

card.Parent = content

corner(card, 12)
stroke(card, Color3.fromRGB(55, 55, 65), 0.35)

label(
    card,
    "AUTO SELL",
    UDim2.new(0, 200, 0, 25),
    UDim2.new(0, 15, 0, 12),
    14,
    THEME.text
)

local status = label(
    card,
    "Status : OFF",
    UDim2.new(0, 250, 0, 25),
    UDim2.new(0, 15, 0, 43),
    12,
    THEME.sub
)

--========================================================--
-- TOGGLE
--========================================================--

local toggle = Instance.new("TextButton")

toggle.Size = UDim2.new(0, 90, 0, 38)
toggle.Position = UDim2.new(1, -105, 0, 33)

toggle.BackgroundColor3 = THEME.off
toggle.BorderSizePixel = 0

toggle.Text = "OFF"
toggle.TextSize = 13
toggle.Font = Enum.Font.GothamBold
toggle.TextColor3 = THEME.white

toggle.AutoButtonColor = false

toggle.Parent = card

corner(toggle, 9)

--========================================================--
-- EGG SELECTION
--========================================================--

local eggCard = Instance.new("Frame")

eggCard.Size = UDim2.new(1, -40, 0, 120)
eggCard.Position = UDim2.new(0, 20, 0, 215)

eggCard.BackgroundColor3 = THEME.card
eggCard.BorderSizePixel = 0

eggCard.Parent = content

corner(eggCard, 12)
stroke(eggCard, Color3.fromRGB(55, 55, 65), 0.35)

label(
    eggCard,
    "EGG YANG DIJUAL",
    UDim2.new(0, 220, 0, 25),
    UDim2.new(0, 15, 0, 12),
    14,
    THEME.text
)

local eggButton = button(
    eggCard,
    "SEMUA EGG",
    UDim2.new(0, 180, 0, 38),
    UDim2.new(0, 15, 0, 52)
)

eggButton.BackgroundColor3 = THEME.card2

--========================================================--
-- EGG OPTIONS
--========================================================--

local eggOptions = {
    "SEMUA EGG",
    "EGG 1",
    "EGG 2",
    "EGG 3",
    "EGG 4",
}

local optionFrame = Instance.new("Frame")

optionFrame.Size = UDim2.new(0, 180, 0, 0)
optionFrame.Position = UDim2.new(0, 15, 0, 92)

optionFrame.BackgroundColor3 = THEME.card2
optionFrame.Visible = false

optionFrame.BorderSizePixel = 0
optionFrame.ZIndex = 20

optionFrame.Parent = eggCard

corner(optionFrame, 8)

local layout = Instance.new("UIListLayout")

layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = optionFrame

for _, eggName in ipairs(eggOptions) do

    local option = button(
        optionFrame,
        eggName,
        UDim2.new(1, 0, 0, 30),
        UDim2.new()
    )

    option.TextXAlignment = Enum.TextXAlignment.Left
    option.ZIndex = 21

    option.MouseButton1Click:Connect(function()

        SelectedEgg = eggName == "SEMUA EGG"
            and "ALL"
            or eggName

        eggButton.Text = eggName
        optionFrame.Visible = false

    end)

end

eggButton.MouseButton1Click:Connect(function()
    optionFrame.Visible = not optionFrame.Visible
end)

--========================================================--
-- FIND SELL GUI
--========================================================--

local function findSellGui()

    local keywords = {
        "sell",
        "jual",
        "jualtelur",
        "sellegg",
        "sellmenu",
        "egg"
    }

    for _, guiObject in ipairs(playerGui:GetDescendants()) do

        if guiObject:IsA("Frame")
            or guiObject:IsA("ScreenGui") then

            local name = guiObject.Name:lower()

            for _, keyword in ipairs(keywords) do

                if name:find(keyword) then
                    return guiObject
                end

            end

        end

    end

    return nil
end

--========================================================--
-- FIND BUTTON BY TEXT
--========================================================--

local function findButtonByText(root, wanted)

    if not root then
        return nil
    end

    wanted = wanted:lower()

    for _, object in ipairs(root:GetDescendants()) do

        if object:IsA("TextButton")
            or object:IsA("ImageButton") then

            local text = ""

            pcall(function()
                text = object.Text or ""
            end)

            if text:lower():find(wanted, 1, true) then
                return object
            end

        end

    end

    return nil
end

--========================================================--
-- SELL EGG
--========================================================--

local function sellEgg()

    local sellGui = findSellGui()

    if not sellGui then
        warn("[SYADZZ HUB] Menu Sell tidak ditemukan.")
        return false
    end

    -- Jika ALL, langsung cari tombol jual.
    if SelectedEgg == "ALL" then

        local sellButton =
            findButtonByText(sellGui, "jual")
            or findButtonByText(sellGui, "sell")

        if sellButton then

            pcall(function()
                sellButton:Activate()
            end)

            return true
        end

        return false
    end

    -- Cari Egg yang dipilih.
    local eggButtonObject =
        findButtonByText(sellGui, SelectedEgg)

    if eggButtonObject then

        pcall(function()
            eggButtonObject:Activate()
        end)

        task.wait(0.15)

        local sellButton =
            findButtonByText(sellGui, "jual")
            or findButtonByText(sellGui, "sell")

        if sellButton then

            pcall(function()
                sellButton:Activate()
            end)

            return true
        end

    end

    return false
end

--========================================================--
-- AUTO SELL LOOP
--========================================================--

task.spawn(function()

    while gui.Parent do

        task.wait(SellDelay)

        if AutoSellEgg then
            sellEgg()
        end

    end

end)

--========================================================--
-- TOGGLE EVENT
--========================================================--

toggle.MouseButton1Click:Connect(function()

    AutoSellEgg = not AutoSellEgg

    if AutoSellEgg then

        toggle.Text = "ON"
        toggle.BackgroundColor3 = THEME.accent

        status.Text = "Status : ON"
        status.TextColor3 = THEME.green

        print("[SYADZZ HUB] Auto Sell Egg ON")

    else

        toggle.Text = "OFF"
        toggle.BackgroundColor3 = THEME.off

        status.Text = "Status : OFF"
        status.TextColor3 = THEME.sub

        print("[SYADZZ HUB] Auto Sell Egg OFF")

    end

end)

--========================================================--
-- DRAG WINDOW
--========================================================--

local dragging = false
local dragStart
local startPosition

top.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = main.Position

    end

end)

top.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local delta = input.Position - dragStart

    main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )

end)

--========================================================--
-- START
--========================================================--

print("====================================")
print("       SYADZZ HUB LOADED")
print("       AUTO SELL EGG READY")
print("====================================")
