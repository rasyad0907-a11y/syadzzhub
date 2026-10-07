--[[
    SYADZZ AUTO STEAL
    Single-file clean-room template
    Untuk game Roblox yang kamu miliki/kembangkan.

    Semua konfigurasi ada di bagian CONFIG.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

------------------------------------------------------------
-- CONFIG
------------------------------------------------------------

local CONFIG = {
    ScanInterval = 0.5,

    MinKG = 0,

    Priority = "RARITY",
    -- RARITY / KG / DISTANCE

    StealFromPlayers = true,
    AutoPlaceToPen = true,

    EggFolderNames = {
        "Eggs",
        "Egg",
        "EggSpawns",
        "EggSpawn",
        "EggsFolder",
    },

    PlotFolderNames = {
        "Plots",
        "Plot",
        "Bases",
        "Base",
        "PlayerPlots",
        "PlayerBases",
    },

    PenNames = {
        "Pen",
        "EggPen",
        "PetPen",
        "Pets",
    },
}

------------------------------------------------------------
-- REMOTE
------------------------------------------------------------

local Remote = ReplicatedStorage:FindFirstChild("SYADZZ_AutoSteal")

if not Remote then
    Remote = Instance.new("RemoteEvent")
    Remote.Name = "SYADZZ_AutoSteal"
    Remote.Parent = ReplicatedStorage
end

------------------------------------------------------------
-- PLAYER SETTINGS
------------------------------------------------------------

local Settings = {}

local function getSettings(player)
    if not Settings[player] then
        Settings[player] = {
            Enabled = false,
            StealFromPlayers = CONFIG.StealFromPlayers,
            AutoPlaceToPen = CONFIG.AutoPlaceToPen,
            MinKG = CONFIG.MinKG,
            Priority = CONFIG.Priority,
        }
    end

    return Settings[player]
end

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------

local function lower(value)
    return string.lower(tostring(value))
end

local function nameMatches(name, list)
    name = lower(name)

    for _, wanted in ipairs(list) do
        if name == lower(wanted) then
            return true
        end
    end

    return false
end

local function getPosition(object)
    if object:IsA("BasePart") then
        return object.Position
    end

    if object:IsA("Model") then
        return object:GetPivot().Position
    end

    return nil
end

------------------------------------------------------------
-- FIND EGG FOLDERS
------------------------------------------------------------

local function findEggFolders()
    local result = {}

    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("Folder") or object:IsA("Model") then
            if nameMatches(object.Name, CONFIG.EggFolderNames) then
                table.insert(result, object)
            end
        end
    end

    return result
end

------------------------------------------------------------
-- KG
------------------------------------------------------------

local function getKG(object)
    local attributeNames = {
        "KG",
        "Kg",
        "kg",
        "Weight",
        "WeightKG",
    }

    for _, name in ipairs(attributeNames) do
        local value = object:GetAttribute(name)

        if typeof(value) == "number" then
            return value
        end
    end

    for _, child in ipairs(object:GetDescendants()) do
        if child:IsA("NumberValue") then
            local n = lower(child.Name)

            if string.find(n, "kg", 1, true)
                or string.find(n, "weight", 1, true) then

                return child.Value
            end
        end
    end

    return 0
end

------------------------------------------------------------
-- RARITY
------------------------------------------------------------

local RarityRank = {
    common = 1,
    uncommon = 2,
    rare = 3,
    epic = 4,
    legendary = 5,
    mythic = 6,
    divine = 7,
    secret = 8,
}

local function getRarity(object)
    local value = object:GetAttribute("Rarity")

    if typeof(value) == "string" then
        return value
    end

    local rarity = object:FindFirstChild("Rarity")

    if rarity and rarity:IsA("StringValue") then
        return rarity.Value
    end

    return "Common"
end

------------------------------------------------------------
-- EGG LIST
------------------------------------------------------------

local function getEggs()
    local eggs = {}

    for _, folder in ipairs(findEggFolders()) do
        for _, object in ipairs(folder:GetDescendants()) do

            if object:IsA("Model") or object:IsA("BasePart") then

                local kg = getKG(object)

                if kg >= CONFIG.MinKG then
                    table.insert(eggs, {
                        Object = object,
                        KG = kg,
                        Rarity = getRarity(object),
                        Position = getPosition(object),
                    })
                end
            end
        end
    end

    return eggs
end

------------------------------------------------------------
-- PLAYER PLOT
------------------------------------------------------------

local function findPlot(player)

    for _, container in ipairs(Workspace:GetDescendants()) do

        if container:IsA("Folder")
            or container:IsA("Model") then

            if nameMatches(
                container.Name,
                CONFIG.PlotFolderNames
            ) then

                for _, plot in ipairs(container:GetChildren()) do

                    if lower(plot.Name) == lower(player.Name) then
                        return plot
                    end

                    local owner = plot:GetAttribute("Owner")

                    if owner == player.Name then
                        return plot
                    end

                    local ownerId =
                        plot:GetAttribute("OwnerUserId")

                    if ownerId == player.UserId then
                        return plot
                    end
                end
            end
        end
    end

    return nil
end

------------------------------------------------------------
-- PEN
------------------------------------------------------------

local function findPen(player)

    local plot = findPlot(player)

    if not plot then
        return nil
    end

    for _, object in ipairs(plot:GetDescendants()) do

        if nameMatches(
            object.Name,
            CONFIG.PenNames
        ) then

            return object
        end
    end

    return nil
end

------------------------------------------------------------
-- SCORE
------------------------------------------------------------

local function getScore(player, egg)

    local settings = getSettings(player)

    if settings.Priority == "KG" then
        return egg.KG
    end

    if settings.Priority == "RARITY" then
        return RarityRank[
            lower(egg.Rarity)
        ] or 0
    end

    if settings.Priority == "DISTANCE" then

        local character = player.Character

        if character then

            local root =
                character:FindFirstChild(
                    "HumanoidRootPart"
                )

            if root and egg.Position then

                return -(
                    root.Position -
                    egg.Position
                ).Magnitude
            end
        end
    end

    return egg.KG
end

------------------------------------------------------------
-- BEST EGG
------------------------------------------------------------

local function getBestEgg(player)

    local bestEgg = nil
    local bestScore = -math.huge

    for _, egg in ipairs(getEggs()) do

        local score =
            getScore(player, egg)

        if score > bestScore then
            bestScore = score
            bestEgg = egg
        end
    end

    return bestEgg
end

------------------------------------------------------------
-- PLACE TO PEN
------------------------------------------------------------

local function placeToPen(player, egg)

    local settings = getSettings(player)

    if not settings.AutoPlaceToPen then
        return false
    end

    local pen = findPen(player)

    if not pen then
        return false
    end

    local targetCFrame

    if pen:IsA("BasePart") then
        targetCFrame = pen.CFrame

    elseif pen:IsA("Model") then
        targetCFrame = pen:GetPivot()
    end

    if not targetCFrame then
        return false
    end

    if egg:IsA("Model") then
        egg:PivotTo(targetCFrame)
        return true
    end

    if egg:IsA("BasePart") then
        egg.CFrame = targetCFrame
        return true
    end

    return false
end

------------------------------------------------------------
-- STEAL
------------------------------------------------------------

local function steal(player, eggData)

    local egg = eggData.Object

    if not egg then
        return false
    end

    if not egg.Parent then
        return false
    end

    --------------------------------------------------------
    -- OWNERSHIP ATTRIBUTES
    -- Sistem game milik sendiri dapat menggantinya
    -- dengan inventory/remote server yang sebenarnya.
    --------------------------------------------------------

    egg:SetAttribute(
        "OwnerUserId",
        player.UserId
    )

    egg:SetAttribute(
        "OwnerName",
        player.Name
    )

    egg:SetAttribute(
        "CarriedByUserId",
        player.UserId
    )

    --------------------------------------------------------
    -- AUTO PLACE
    --------------------------------------------------------

    local placed =
        placeToPen(player, egg)

    if placed then

        egg:SetAttribute(
            "CarriedByUserId",
            nil
        )

    end

    return true
end

------------------------------------------------------------
-- AUTO LOOP
------------------------------------------------------------

task.spawn(function()

    while true do

        for _, player in ipairs(
            Players:GetPlayers()
        ) do

            local settings =
                getSettings(player)

            if settings.Enabled then

                local egg =
                    getBestEgg(player)

                if egg then
                    steal(player, egg)
                end
            end
        end

        task.wait(
            CONFIG.ScanInterval
        )
    end
end)

------------------------------------------------------------
-- REMOTE COMMANDS
------------------------------------------------------------

Remote.OnServerEvent:Connect(
    function(player, action, value)

        local settings =
            getSettings(player)

        if action == "Toggle" then

            settings.Enabled =
                value == true

        elseif action == "StealFromPlayers" then

            settings.StealFromPlayers =
                value == true

        elseif action == "AutoPlaceToPen" then

            settings.AutoPlaceToPen =
                value == true

        elseif action == "MinKG" then

            local number =
                tonumber(value)

            if number then
                settings.MinKG =
                    math.max(0, number)
            end

        elseif action == "Priority" then

            if value == "RARITY"
                or value == "KG"
                or value == "DISTANCE" then

                settings.Priority =
                    value
            end
        end
    end
)

------------------------------------------------------------
-- UI
------------------------------------------------------------

local function createUI(player)

    local playerGui =
        player:WaitForChild("PlayerGui")

    local old =
        playerGui:FindFirstChild(
            "SYADZZ_AutoSteal"
        )

    if old then
        old:Destroy()
    end

    local gui =
        Instance.new("ScreenGui")

    gui.Name =
        "SYADZZ_AutoSteal"

    gui.ResetOnSpawn =
        false

    gui.Parent =
        playerGui

    local frame =
        Instance.new("Frame")

    frame.Size =
        UDim2.fromOffset(280, 340)

    frame.Position =
        UDim2.new(
            0,
            20,
            0.5,
            -170
        )

    frame.BackgroundColor3 =
        Color3.fromRGB(
            20,
            20,
            20
        )

    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 12)

    corner.Parent = frame

    local title =
        Instance.new("TextLabel")

    title.Size =
        UDim2.new(1, 0, 0, 50)

    title.BackgroundTransparency = 1

    title.Text =
        "SYADZZ AUTO STEAL"

    title.TextColor3 =
        Color3.fromRGB(
            255,
            217,
            0
        )

    title.TextSize = 20
    title.Font =
        Enum.Font.GothamBold

    title.Parent = frame

    local function makeButton(text, y)

        local button =
            Instance.new("TextButton")

        button.Size =
            UDim2.new(
                1,
                -30,
                0,
                42
            )

        button.Position =
            UDim2.fromOffset(
                15,
                y
            )

        button.BackgroundColor3 =
            Color3.fromRGB(
                42,
                42,
                42
            )

        button.TextColor3 =
            Color3.new(
                1,
                1,
                1
            )

        button.TextSize = 14

        button.Font =
            Enum.Font.GothamBold

        button.Text =
            text

        button.Parent =
            frame

        local c =
            Instance.new("UICorner")

        c.CornerRadius =
            UDim.new(0, 8)

        c.Parent =
            button

        return button
    end

    local auto =
        makeButton(
            "AUTO STEAL : OFF",
            55
        )

    local stealPlayers =
        makeButton(
            "STEAL FROM PLAYERS : ON",
            105
        )

    local autoPlace =
        makeButton(
            "AUTO PLACE TO PEN : ON",
            155
        )

    local priority =
        makeButton(
            "PRIORITY : RARITY",
            205
        )

    local minKG =
        makeButton(
            "MIN KG : 0",
            255
        )

    local close =
        makeButton(
            "CLOSE",
            305
        )

    --------------------------------------------------------
    -- STATE
    --------------------------------------------------------

    local enabled = false
    local stealEnabled = true
    local placeEnabled = true

    --------------------------------------------------------
    -- AUTO STEAL
    --------------------------------------------------------

    auto.MouseButton1Click:Connect(
        function()

            enabled =
                not enabled

            if enabled then

                auto.Text =
                    "AUTO STEAL : ON"

            else

                auto.Text =
                    "AUTO STEAL : OFF"
            end

            Remote:FireServer(
                "Toggle",
                enabled
            )
        end
    )

    --------------------------------------------------------
    -- PLAYER STEAL
    --------------------------------------------------------

    stealPlayers.MouseButton1Click:Connect(
        function()

            stealEnabled =
                not stealEnabled

            stealPlayers.Text =
                "STEAL FROM PLAYERS : "
                .. (
                    stealEnabled
                    and "ON"
                    or "OFF"
                )

            Remote:FireServer(
                "StealFromPlayers",
                stealEnabled
            )
        end
    )

    --------------------------------------------------------
    -- PEN
    --------------------------------------------------------

    autoPlace.MouseButton1Click:Connect(
        function()

            placeEnabled =
                not placeEnabled

            autoPlace.Text =
                "AUTO PLACE TO PEN : "
                .. (
                    placeEnabled
                    and "ON"
                    or "OFF"
                )

            Remote:FireServer(
                "AutoPlaceToPen",
                placeEnabled
            )
        end
    )

    --------------------------------------------------------
    -- PRIORITY
    --------------------------------------------------------

    local priorities = {
        "RARITY",
        "KG",
        "DISTANCE",
    }

    local priorityIndex = 1

    priority.MouseButton1Click:Connect(
        function()

            priorityIndex += 1

            if priorityIndex >
                #priorities then

                priorityIndex = 1
            end

            local value =
                priorities[
                    priorityIndex
                ]

            priority.Text =
                "PRIORITY : "
                .. value

            Remote:FireServer(
                "Priority",
                value
            )
        end
    )

    --------------------------------------------------------
    -- MIN KG
    --------------------------------------------------------

    minKG.MouseButton1Click:Connect(
        function()

            local input =
                Instance.new("TextBox")

            input.Size =
                UDim2.fromOffset(
                    230,
                    45
                )

            input.Position =
                UDim2.new(
                    0.5,
                    -115,
                    0.5,
                    -22
                )

            input.BackgroundColor3 =
                Color3.fromRGB(
                    30,
                    30,
                    30
                )

            input.TextColor3 =
                Color3.new(
                    1,
                    1,
                    1
                )

            input.PlaceholderText =
                "Minimum KG"

            input.Text = ""

            input.TextSize = 16

            input.Parent = gui

            input:CaptureFocus()

            input.FocusLost:Connect(
                function()

                    local value =
                        tonumber(
                            input.Text
                        )

                    if not value then
                        value = 0
                    end

                    minKG.Text =
                        "MIN KG : "
                        .. tostring(value)

                    Remote:FireServer(
                        "MinKG",
                        value
                    )

                    input:Destroy()
                end
            )
        end
    )

    --------------------------------------------------------
    -- CLOSE
    --------------------------------------------------------

    close.MouseButton1Click:Connect(
        function()
            gui.Enabled = false
        end
    )
end

------------------------------------------------------------
-- PLAYER ADDED
------------------------------------------------------------

Players.PlayerAdded:Connect(
    function(player)

        task.spawn(
            function()
                createUI(player)
            end
        )
    end
)

for _, player in ipairs(
    Players:GetPlayers()
) do

    task.spawn(
        function()
            createUI(player)
        end
    )
end

------------------------------------------------------------
-- CLEANUP
------------------------------------------------------------

Players.PlayerRemoving:Connect(
    function(player)

        Settings[player] = nil
    end
)

print(
    "[SYADZZ] main.lua loaded"
)
