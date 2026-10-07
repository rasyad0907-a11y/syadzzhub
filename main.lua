--// SYADZZ HUB - DYNAMIC PLOT TREADMILL & SMART AUTO STEAL

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- CLEANUP GUI LAMA JIKA ADA
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("SyadzzPrivateScript") then
        LocalPlayer.PlayerGui.SyadzzPrivateScript:Destroy()
    end
    if game:GetService("CoreGui"):FindFirstChild("SyadzzPrivateScript") then
        game:GetService("CoreGui").SyadzzPrivateScript:Destroy()
    end
end)

-- LOAD RAYFIELD UI LIBRARY
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg",
    LoadingTitle = "SYADZZ HUB Loading...",
    LoadingSubtitle = "by Syadzz",
    ConfigurationSaving = { Enabled = false },
    KeySystem = true,
    KeySettings = {
        Title = "SYADZZ HUB - Verification",
        Subtitle = "Masukkan Password",
        Note = "Password: SYADZZ123",
        FileName = "SyadzzKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"SYADZZ123"}
    }
})

-- SETTINGS CONFIGURATION (ALL DEFAULT OFF)
local Settings = {
    TeleportSteal = false,
    AutoSteal = false,
    Godmode = false,
    AutoPlace = false,
    AntiHitGuard = false,
    AutoTreadmill = false,
    StealMethod = "Glide",
    StealSpeed = 100,

    PetNames = "All",
    Areas = "All",
    Rarities = {
        ["Divine"] = false,
        ["Eternal"] = false,
        ["Secret"] = false,
        ["Cosmic"] = false,
        ["Mythic"] = false,
        ["Legendary"] = false,
        ["Epic"] = false,
        ["Rare"] = false,
        ["SuperRare"] = false,
        ["Uncommon"] = false
    },
    Priority = "Rarity",
    MinValue = "0",
    MinEggKG = "0"
}

-- BOBOT RARITY (TERBAGUS KE BIASA)
local RarityWeight = {
    ["Divine"] = 10,
    ["Eternal"] = 9,
    ["Secret"] = 8,
    ["Cosmic"] = 7,
    ["Mythic"] = 6,
    ["Legendary"] = 5,
    ["Epic"] = 4,
    ["Rare"] = 3,
    ["SuperRare"] = 2,
    ["Uncommon"] = 1
}

-- HELPER FUNCTIONS
local function getEggRarityNameAndWeight(model)
    if not model then return "Uncommon", 1 end
    local modelName = model.Name
    for rarity, weight in pairs(RarityWeight) do
        if modelName:lower():find(rarity:lower()) then return rarity, weight end
    end
    if model:FindFirstChild("Rarity") then
        local rVal = tostring(model.Rarity.Value)
        for rarity, weight in pairs(RarityWeight) do
            if rVal:lower():find(rarity:lower()) then return rarity, weight end
        end
    end
    return "Uncommon", 1
end

local function isRealEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local parent = prompt.Parent
    local parentName = parent and parent.Name:lower() or ""
    local grandParentName = (parent and parent.Parent) and parent.Parent.Name:lower() or ""
    local objectText = prompt.ObjectText:lower()
    local actionText = prompt.ActionText:lower()

    if parentName:find("wisp") or parentName:find("machine") or parentName:find("quest") or 
       parentName:find("chest") or parentName:find("free") or parentName:find("gratis") or 
       grandParentName:find("wisp") or grandParentName:find("machine") or grandParentName:find("quest") then
        return false
    end
    
    if objectText:find("wisp") or objectText:find("quest") or objectText:find("machine") or 
       actionText:find("claim") or actionText:find("open") or actionText:find("buka") then
        return false
    end

    if parentName:find("egg") or objectText:find("egg") or actionText:find("steal") or actionText:find("curi") or actionText:find("take") then
        return true
    end
    return false
end

-- AMBIL BASE / PLOT MILIK PLAYER SECARA DINAMIS
local function getMyPlot()
    local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("PlotsFolder")
    if plotsFolder then
        for _, plot in pairs(plotsFolder:GetChildren()) do
            -- Cek nama Plot atau atribut Owner
            if plot.Name == LocalPlayer.Name or plot.Name:lower():find(LocalPlayer.Name:lower()) then
                return plot
            end
            local ownerVal = plot:FindFirstChild("Owner") or plot:FindFirstChild("Player")
            if ownerVal and (tostring(ownerVal.Value) == LocalPlayer.Name or ownerVal.Value == LocalPlayer) then
                return plot
            end
        end
    end
    return nil
end

local function getMyBaseCFrame()
    local myPlot = getMyPlot()
    if myPlot then
        local safeZone = myPlot:FindFirstChild("SafeZone", true) or myPlot:FindFirstChild("Pen", true) or myPlot:FindFirstChild("Spawn", true)
        if safeZone then
            local p = safeZone:IsA("BasePart") and safeZone or safeZone:FindFirstChildWhichIsA("BasePart", true)
            if p then return p.CFrame + Vector3.new(0, 3, 0) end
        end
        return myPlot:GetPivot() + Vector3.new(0, 3, 0)
    end
    return LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.CFrame
end

-- TABS
local StealTab = Window:CreateTab("Steal", 4483362458)

-- UI TOGGLES
StealTab:CreateToggle({
    Name = "Teleport Steal",
    CurrentValue = false,
    Callback = function(Value) Settings.TeleportSteal = Value end,
})

StealTab:CreateToggle({
    Name = "Auto Steal Eggs",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoSteal = Value end,
})

StealTab:CreateToggle({
    Name = "Real Godmode (Aura Bat, Anti Ragdoll)",
    CurrentValue = false,
    Callback = function(Value) Settings.Godmode = Value end,
})

StealTab:CreateToggle({
    Name = "Auto Place to Pen",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoPlace = Value end,
})

StealTab:CreateToggle({
    Name = "Anti Hit Guard",
    CurrentValue = false,
    Callback = function(Value) Settings.AntiHitGuard = Value end,
})

StealTab:CreateToggle({
    Name = "Auto Treadmill",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoTreadmill = Value end,
})

StealTab:CreateDropdown({
    Name = "Steal Method",
    Options = {"Glide", "Teleport", "Instant"},
    CurrentOption = {"Glide"},
    MultipleOptions = false,
    Callback = function(Option) Settings.StealMethod = Option[1] end,
})

StealTab:CreateSlider({
    Name = "Auto Steal Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 100,
    Callback = function(Value) Settings.StealSpeed = Value end,
})

StealTab:CreateSection("Filter Tools")
local rarities = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare", "SuperRare", "Uncommon"}
for _, rarity in ipairs(rarities) do
    StealTab:CreateToggle({
        Name = "Filter: " .. rarity,
        CurrentValue = false,
        Callback = function(Value) Settings.Rarities[rarity] = Value end,
    })
end

-- LOGIKA AUTO STEAL
task.spawn(function()
    while task.wait(0.15) do
        if Settings.AutoSteal or Settings.TeleportSteal then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local targets = {}
                local activeFilters = {}

                for rName, active in pairs(Settings.Rarities) do
                    if active then table.insert(activeFilters, rName:lower()) end
                end

                for _, obj in pairs(Workspace:GetDescendants()) do
                    if isRealEggPrompt(obj) then
                        local eggModel = obj.Parent
                        local eggPart = eggModel:IsA("BasePart") and eggModel or eggModel:FindFirstChildWhichIsA("BasePart", true)
                        if eggPart then
                            local rName, rWeight = getEggRarityNameAndWeight(eggModel)

                            local isAllowed = false
                            if #activeFilters == 0 then
                                isAllowed = true
                            else
                                for _, filterName in ipairs(activeFilters) do
                                    if rName:lower():find(filterName) or eggModel.Name:lower():find(filterName) then
                                        isAllowed = true
                                        break
                                    end
                                end
                            end

                            if isAllowed then
                                table.insert(targets, {
                                    prompt = obj,
                                    part = eggPart,
                                    weight = rWeight,
                                    dist = (char.HumanoidRootPart.Position - eggPart.Position).Magnitude
                                })
                            end
                        end
                    end
                end

                table.sort(targets, function(a, b)
                    if a.weight ~= b.weight then
                        return a.weight > b.weight
                    end
                    return a.dist < b.dist
                end)

                if #targets > 0 then
                    local target = targets[1]
                    local myBase = getMyBaseCFrame()

                    char.HumanoidRootPart.CFrame = target.part.CFrame * CFrame.new(0, 2.5, 0)
                    task.wait(0.1)

                    target.prompt.RequiresLineOfSight = false
                    fireproximityprompt(target.prompt)
                    task.wait(0.2)

                    if myBase then
                        char.HumanoidRootPart.CFrame = myBase
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
end)

-- LOGIKA AUTO TREADMILL DINAMIS KAMPUS/BASE SENDIRI
task.spawn(function()
    while task.wait(0.2) do
        if Settings.AutoTreadmill then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local targetTreadmill = nil
                local myPlot = getMyPlot()

                -- 1. Cari Treadmill di dalam Plot milik kamu sendiri lebih dulu
                if myPlot then
                    for _, obj in pairs(myPlot:GetDescendants()) do
                        local oName = obj.Name:lower()
                        if oName:find("treadmill") or oName:find("trainer") or oName:find("tread") then
                            targetTreadmill = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                            if targetTreadmill then break end
                        end
                    end
                end

                -- 2. Jika tidak ada di Plot, cari treadmill terdekat dari posisi Base kamu
                if not targetTreadmill then
                    local myBaseCF = getMyBaseCFrame()
                    local shortestDist = math.huge
                    
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        local oName = obj.Name:lower()
                        if oName:find("treadmill") or oName:find("trainer") then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                            if part and myBaseCF then
                                local dist = (myBaseCF.Position - part.Position).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    targetTreadmill = part
                                end
                            end
                        end
                    end
                end

                -- 3. Teleport & Kunci Posisi di Atas Treadmill Sesuai Arah Hadap Mesin
                if targetTreadmill then
                    local treadmillCFrame = targetTreadmill.CFrame
                    local positionAbove = treadmillCFrame.Position + Vector3.new(0, 2.8, 0)
                    
                    -- Mengunci posisi dan rotasi agar karakter selalu menghadap lurus sesuai arah treadmill
                    char.HumanoidRootPart.CFrame = CFrame.new(positionAbove, positionAbove + treadmillCFrame.LookVector)
                    char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    end
end)

-- GODMODE LOGIC
RunService.Stepped:Connect(function()
    if Settings.Godmode then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    if hum.PlatformStand then hum.PlatformStand = false end
                end
            end
        end)
    end
end)
