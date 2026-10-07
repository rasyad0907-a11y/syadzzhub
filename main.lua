--========================================================--
--                    SYADZZ HUB                         --
--                main.lua - UI PANEL                    --
--========================================================--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================--
-- CONFIG
--========================================================--

local CONFIG = {
    Title = "SYADZZ HUB",
    Version = "v1.0",

    Theme = {
        Background = Color3.fromRGB(16, 16, 21),
        Sidebar = Color3.fromRGB(12, 12, 17),
        Card = Color3.fromRGB(22, 22, 28),
        CardHover = Color3.fromRGB(29, 29, 37),

        Text = Color3.fromRGB(245, 245, 250),
        SubText = Color3.fromRGB(155, 155, 170),

        Accent = Color3.fromRGB(145, 95, 255),
        AccentDark = Color3.fromRGB(95, 58, 180),

        ToggleOff = Color3.fromRGB(65, 65, 75),
        ToggleOn = Color3.fromRGB(145, 95, 255),

        White = Color3.fromRGB(255, 255, 255)
    }
}

local Theme = CONFIG.Theme

--========================================================--
-- CLEAN OLD GUI
--========================================================--

local old = PlayerGui:FindFirstChild("SYADZZ_HUB")
if old then
    old:Destroy()
end

--========================================================--
-- HELPERS
--========================================================--

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Transparency = transparency or 0
    s.Thickness = 1
    s.Parent = obj
    return s
end

local function makeLabel(parent, text, size, position, textSize, color)
    local label = Instance.new("TextLabel")

    label.BackgroundTransparency = 1
    label.Size = size
    label.Position = position

    label.Text = text
    label.TextSize = textSize or 14
    label.Font = Enum.Font.GothamMedium
    label.TextColor3 = color or Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center

    label.Parent = parent

    return label
end

local function makeButton(parent, text, size, position)
    local button = Instance.new("TextButton")

    button.AutoButtonColor = false
    button.Size = size
    button.Position = position

    button.Text = text
    button.TextSize = 14
    button.Font = Enum.Font.GothamMedium
    button.TextColor3 = Theme.Text

    button.BackgroundColor3 = Theme.Card
    button.Parent = parent

    corner(button, 8)

    return button
end

--========================================================--
-- SCREEN GUI
--========================================================--

local Gui = Instance.new("ScreenGui")
Gui.Name = "SYADZZ_HUB"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--========================================================--
-- MAIN WINDOW
--========================================================--

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(900, 550)
Main.Position = UDim2.new(0.5, -450, 0.5, -275)

Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0

Main.Parent = Gui

corner(Main, 14)
stroke(Main, Color3.fromRGB(45, 45, 55), 0.25)

--========================================================--
-- TOP BAR
--========================================================--

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 56)
TopBar.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

corner(TopBar, 14)

-- cover bottom rounded corners
local TopCover = Instance.new("Frame")
TopCover.Size = UDim2.new(1, 0, 0, 15)
TopCover.Position = UDim2.new(0, 0, 1, -15)
TopCover.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
TopCover.BorderSizePixel = 0
TopCover.Parent = TopBar

-- logo
local Logo = Instance.new("Frame")
Logo.Size = UDim2.fromOffset(34, 34)
Logo.Position = UDim2.fromOffset(12, 11)
Logo.BackgroundColor3 = Theme.Accent
Logo.Parent = TopBar
corner(Logo, 10)

makeLabel(
    Logo,
    "S",
    UDim2.fromScale(1, 1),
    UDim2.fromScale(0, 0),
    19,
    Theme.White
).TextXAlignment = Enum.TextXAlignment.Center

makeLabel(
    TopBar,
    CONFIG.Title,
    UDim2.fromOffset(200, 26),
    UDim2.fromOffset(56, 8),
    17,
    Theme.Text
)

local VersionLabel = makeLabel(
    TopBar,
    CONFIG.Version,
    UDim2.fromOffset(100, 20),
    UDim2.fromOffset(56, 31),
    11,
    Theme.SubText
)

-- status
local Status = makeLabel(
    TopBar,
    "● READY",
    UDim2.fromOffset(110, 30),
    UDim2.new(1, -265, 0, 13),
    12,
    Color3.fromRGB(100, 220, 140)
)

Status.TextXAlignment = Enum.TextXAlignment.Center

-- minimize
local Minimize = makeButton(
    TopBar,
    "—",
    UDim2.fromOffset(38, 34),
    UDim2.new(1, -94, 0, 11)
)

-- close
local Close = makeButton(
    TopBar,
    "×",
    UDim2.fromOffset(38, 34),
    UDim2.new(1, -48, 0, 11)
)

--========================================================--
-- SIDEBAR
--========================================================--

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 190, 1, -56)
Sidebar.Position = UDim2.fromOffset(0, 56)

Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

-- separator
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(0, 1, 1, 0)
Separator.Position = UDim2.new(1, -1, 0, 0)
Separator.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
Separator.BorderSizePixel = 0
Separator.Parent = Sidebar

--========================================================--
-- CONTENT
--========================================================--

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -190, 1, -56)
Content.Position = UDim2.fromOffset(190, 56)
Content.BackgroundTransparency = 1
Content.Parent = Main

--========================================================--
-- SIDEBAR MENU
--========================================================--

local Menu = {
    {Name = "HOME", Icon = "⌂"},
    {Name = "STEAL", Icon = "🥚"},
    {Name = "SELL", Icon = "💰"},
    {Name = "HATCH", Icon = "🐣"},
    {Name = "ESP", Icon = "◉"},
    {Name = "SETTINGS", Icon = "⚙"},
}

local CurrentPage = "HOME"
local PageObjects = {}

local function clearPage()
    for _, obj in ipairs(PageObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end

    PageObjects = {}
end

local function addPageObject(obj)
    table.insert(PageObjects, obj)
    return obj
end

local function setStatus(text, color)
    Status.Text = "● " .. text
    Status.TextColor3 = color or Theme.Text
end

--========================================================--
-- TITLE
--========================================================--

local function createPageTitle(title, subtitle)
    local titleLabel = addPageObject(Instance.new("TextLabel"))

    titleLabel.Size = UDim2.new(1, -40, 0, 35)
    titleLabel.Position = UDim2.fromOffset(25, 20)

    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextSize = 21
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    titleLabel.Parent = Content

    if subtitle then
        local sub = addPageObject(Instance.new("TextLabel"))

        sub.Size = UDim2.new(1, -40, 0, 25)
        sub.Position = UDim2.fromOffset(25, 53)

        sub.BackgroundTransparency = 1
        sub.Text = subtitle
        sub.TextSize = 12
        sub.Font = Enum.Font.Gotham
        sub.TextColor3 = Theme.SubText
        sub.TextXAlignment = Enum.TextXAlignment.Left

        sub.Parent = Content
    end
end

--========================================================--
-- TOGGLE
--========================================================--

local function createToggle(parent, title, description, default, callback, y)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -50, 0, 62)
    row.Position = UDim2.fromOffset(25, y)

    row.BackgroundColor3 = Theme.Card
    row.BorderSizePixel = 0
    row.Parent = parent

    corner(row, 10)

    local titleLabel = makeLabel(
        row,
        title,
        UDim2.new(1, -90, 0, 24),
        UDim2.fromOffset(14, 7),
        14,
        Theme.Text
    )

    titleLabel.Font = Enum.Font.GothamSemibold

    makeLabel(
        row,
        description or "",
        UDim2.new(1, -90, 0, 20),
        UDim2.fromOffset(14, 31),
        11,
        Theme.SubText
    )

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.fromOffset(48, 26)
    toggle.Position = UDim2.new(1, -62, 0.5, -13)

    toggle.AutoButtonColor = false
    toggle.Text = ""

    toggle.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
    toggle.Parent = row

    corner(toggle, 20)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(20, 20)
    knob.Position = default
        and UDim2.new(1, -23, 0.5, -10)
        or UDim2.fromOffset(3, 3)

    knob.BackgroundColor3 = Theme.White
    knob.Parent = toggle

    corner(knob, 20)

    local enabled = default

    local function update()
        toggle.BackgroundColor3 =
            enabled and Theme.ToggleOn or Theme.ToggleOff

        local goal = {
            Position = enabled
                and UDim2.new(1, -23, 0.5, -10)
                or UDim2.fromOffset(3, 3)
        }

        TweenService:Create(
            knob,
            TweenInfo.new(0.15),
            goal
        ):Play()

        if callback then
            callback(enabled)
        end
    end

    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        update()

        setStatus(
            enabled and title .. " ON" or title .. " OFF",
            enabled
                and Color3.fromRGB(120, 220, 150)
                or Theme.SubText
        )
    end)

    return row
end

--========================================================--
-- SLIDER
--========================================================--

local function createSlider(parent, title, min, max, default, callback, y)
    local row = Instance.new("Frame")

    row.Size = UDim2.new(1, -50, 0, 78)
    row.Position = UDim2.fromOffset(25, y)

    row.BackgroundColor3 = Theme.Card
    row.BorderSizePixel = 0
    row.Parent = parent

    corner(row, 10)

    local titleLabel = makeLabel(
        row,
        title,
        UDim2.new(1, -100, 0, 28),
        UDim2.fromOffset(14, 8),
        14,
        Theme.Text
    )

    local valueLabel = makeLabel(
        row,
        tostring(default) .. "%",
        UDim2.fromOffset(70, 28),
        UDim2.new(1, -84, 0, 8),
        13,
        Theme.Text
    )

    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -28, 0, 6)
    bar.Position = UDim2.fromOffset(14, 52)

    bar.BackgroundColor3 = Theme.ToggleOff
    bar.BorderSizePixel = 0
    bar.Parent = row

    corner(bar, 10)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(
        (default - min) / (max - min),
        0,
        1,
        0
    )

    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = bar

    corner(fill, 10)

    local dragging = false

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end

        local x = math.clamp(
            (input.Position.X - bar.AbsolutePosition.X)
                / bar.AbsoluteSize.X,
            0,
            1
        )

        fill.Size = UDim2.new(x, 0, 1, 0)

        local value = math.floor(
            min + ((max - min) * x)
        )

        valueLabel.Text = tostring(value) .. "%"

        if callback then
            callback(value)
        end
    end)

    return row
end

--========================================================--
-- DROPDOWN
--========================================================--

local function createDropdown(parent, title, options, default, callback, y)
    local row = Instance.new("Frame")

    row.Size = UDim2.new(1, -50, 0, 58)
    row.Position = UDim2.fromOffset(25, y)

    row.BackgroundColor3 = Theme.Card
    row.BorderSizePixel = 0
    row.Parent = parent

    corner(row, 10)

    makeLabel(
        row,
        title,
        UDim2.new(0.5, 0, 1, 0),
        UDim2.fromOffset(14, 0),
        14,
        Theme.Text
    )

    local selected = makeButton(
        row,
        tostring(default) .. " ▼",
        UDim2.fromOffset(160, 38),
        UDim2.new(1, -174, 0.5, -19)
    )

    local index = 1

    for i, option in ipairs(options) do
        if option == default then
            index = i
        end
    end

    selected.MouseButton1Click:Connect(function()
        index += 1

        if index > #options then
            index = 1
        end

        local value = options[index]

        selected.Text = tostring(value) .. " ▼"

        if callback then
            callback(value)
        end
    end)

    return row
end

--========================================================--
-- HOME
--========================================================--

local function showHome()
    clearPage()

    createPageTitle(
        "Home",
        "SYADZZ automation panel"
    )

    local welcome = addPageObject(Instance.new("Frame"))

    welcome.Size = UDim2.new(1, -50, 0, 125)
    welcome.Position = UDim2.fromOffset(25, 90)

    welcome.BackgroundColor3 = Theme.Card
    welcome.BorderSizePixel = 0
    welcome.Parent = Content

    corner(welcome, 12)

    makeLabel(
        welcome,
        "Welcome to SYADZZ HUB",
        UDim2.new(1, -28, 0, 30),
        UDim2.fromOffset(14, 13),
        18,
        Theme.Text
    )

    makeLabel(
        welcome,
        "Gunakan panel ini untuk mengatur sistem game milikmu.",
        UDim2.new(1, -28, 0, 45),
        UDim2.fromOffset(14, 45),
        12,
        Theme.SubText
    )

    createToggle(
        Content,
        "Enable Panel",
        "Aktif/nonaktifkan kontrol panel",
        true,
        function()
        end,
        230
    )
end

--========================================================--
-- STEAL
--========================================================--

local function showSteal()
    clearPage()

    createPageTitle(
        "Auto Steal",
        "Automation settings"
    )

    createToggle(
        Content,
        "Auto Steal",
        "Aktifkan sistem steal milik game",
        false,
        function(value)
            -- Hubungkan ke sistem game milikmu sendiri di sini
        end,
        90
    )

    createToggle(
        Content,
        "Auto Place",
        "Penempatan otomatis",
        false,
        function(value)
        end,
        162
    )

    createDropdown(
        Content,
        "Steal Method",
        {"Nearest", "Random", "First"},
        "Nearest",
        function(value)
        end,
        234
    )

    createSlider(
        Content,
        "Steal Speed",
        10,
        100,
        100,
        function(value)
        end,
        304
    )

    createToggle(
        Content,
        "Anti Ragdoll",
        "Kontrol karakter milik game",
        false,
        function(value)
        end,
        394
    )
end

--========================================================--
-- SELL
--========================================================--

local function showSell()
    clearPage()

    createPageTitle(
        "Auto Sell",
        "Inventory and selling settings"
    )

    createToggle(
        Content,
        "Auto Sell",
        "Jual inventory secara otomatis",
        false,
        function(value)
        end,
        90
    )

    createToggle(
        Content,
        "Sell When Full",
        "Jual saat kapasitas penuh",
        true,
        function(value)
        end,
        162
    )

    createSlider(
        Content,
        "Sell Threshold",
        10,
        100,
        80,
        function(value)
        end,
        234
    )
end

--========================================================--
-- HATCH
--========================================================--

local function showHatch()
    clearPage()

    createPageTitle(
        "Auto Hatch",
        "Egg automation settings"
    )

    createDropdown(
        Content,
        "Egg",
        {"Basic Egg", "Rare Egg", "Epic Egg"},
        "Basic Egg",
        function(value)
        end,
        90
    )

    createToggle(
        Content,
        "Auto Hatch",
        "Buka egg otomatis di game milikmu",
        false,
        function(value)
        end,
        160
    )

    createToggle(
        Content,
        "Triple Hatch",
        "Gunakan triple hatch",
        false,
        function(value)
        end,
        232
    )

    createToggle(
        Content,
        "Skip Animation",
        "Lewati animasi hatch",
        false,
        function(value)
        end,
        304
    )
end

--========================================================--
-- ESP
--========================================================--

local function showESP()
    clearPage()

    createPageTitle(
        "ESP",
        "Visual settings"
    )

    createToggle(
        Content,
        "ESP",
        "Visual helper untuk game milikmu",
        false,
        function(value)
        end,
        90
    )

    createToggle(
        Content,
        "Egg ESP",
        "Tampilkan egg",
        false,
        function(value)
        end,
        162
    )

    createToggle(
        Content,
        "Player ESP",
        "Tampilkan player",
        false,
        function(value)
        end,
        234
    )
end

--========================================================--
-- SETTINGS
--========================================================--

local function showSettings()
    clearPage()

    createPageTitle(
        "Settings",
        "Panel preferences"
    )

    createToggle(
        Content,
        "Show Status",
        "Tampilkan status di header",
        true,
        function(value)
            Status.Visible = value
        end,
        90
    )

    createToggle(
        Content,
        "Animations",
        "Gunakan animasi panel",
        true,
        function(value)
        end,
        162
    )

    createToggle(
        Content,
        "Compact Mode",
        "Mode panel lebih kecil",
        false,
        function(value)
        end,
        234
    )
end

--========================================================--
-- PAGE SWITCHER
--========================================================--

local function openPage(name)
    CurrentPage = name

    if name == "HOME" then
        showHome()

    elseif name == "STEAL" then
        showSteal()

    elseif name == "SELL" then
        showSell()

    elseif name == "HATCH" then
        showHatch()

    elseif name == "ESP" then
        showESP()

    elseif name == "SETTINGS" then
        showSettings()
    end
end

--========================================================--
-- SIDEBAR BUTTONS
--========================================================--

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 18)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

local SidebarButtons = {}

for _, item in ipairs(Menu) do

    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1, 0, 0, 42)

    button.Text = ""
    button.AutoButtonColor = false

    button.BackgroundColor3 = Theme.Sidebar
    button.BorderSizePixel = 0

    button.Parent = Sidebar

    corner(button, 9)

    local icon = makeLabel(
        button,
        item.Icon,
        UDim2.fromOffset(28, 42),
        UDim2.fromOffset(8, 0),
        16,
        Theme.SubText
    )

    icon.TextXAlignment = Enum.TextXAlignment.Center

    local title = makeLabel(
        button,
        item.Name,
        UDim2.new(1, -45, 1, 0),
        UDim2.fromOffset(40, 0),
        13,
        Theme.SubText
    )

    SidebarButtons[item.Name] = {
        Button = button,
        Icon = icon,
        Title = title
    }

    button.MouseButton1Click:Connect(function()
        openPage(item.Name)
    end)
end

local function updateSidebar()
    for name, refs in pairs(SidebarButtons) do
        if name == CurrentPage then

            refs.Button.BackgroundColor3 = Color3.fromRGB(30, 25, 43)
            refs.Icon.TextColor3 = Theme.Accent
            refs.Title.TextColor3 = Theme.Text

        else

            refs.Button.BackgroundColor3 = Theme.Sidebar
            refs.Icon.TextColor3 = Theme.SubText
            refs.Title.TextColor3 = Theme.SubText

        end
    end
end

-- refresh sidebar after opening page
local oldOpenPage = openPage

openPage = function(name)
    oldOpenPage(name)
    updateSidebar()
end

--========================================================--
-- MINIMIZE
--========================================================--

local minimized = false
local originalSize = Main.Size

Minimize.MouseButton1Click:Connect(function()

    minimized = not minimized

    if minimized then

        Sidebar.Visible = false
        Content.Visible = false

        TweenService:Create(
            Main,
            TweenInfo.new(0.2),
            {
                Size = UDim2.fromOffset(320, 56)
            }
        ):Play()

    else

        TweenService:Create(
            Main,
            TweenInfo.new(0.2),
            {
                Size = originalSize
            }
        ):Play()

        task.delay(0.2, function()
            Sidebar.Visible = true
            Content.Visible = true
        end)

    end
end)

--========================================================--
-- CLOSE
--========================================================--

Close.MouseButton1Click:Connect(function()

    local tween = TweenService:Create(
        Main,
        TweenInfo.new(0.2),
        {
            Size = UDim2.fromOffset(0, 0)
        }
    )

    tween:Play()

    tween.Completed:Connect(function()
        Gui:Destroy()
    end)
end)

--========================================================--
-- DRAG WINDOW
--========================================================--

local dragging = false
local dragStart
local startPos

TopBar.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

    end

end)

TopBar.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end

end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    local delta = input.Position - dragStart

    Main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )

end)

--========================================================--
-- OPEN DEFAULT PAGE
--========================================================--

openPage("HOME")
updateSidebar()

setStatus(
    "READY",
    Color3.fromRGB(100, 220, 140)
)

print("[SYADZZ HUB] Loaded successfully")
