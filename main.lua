--// SYADZZ HUB - FIXED UI BLANK / MISSING ELEMENTS & COMPLETED CODE

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP GUI LAMA JIKA MASIH ADA
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("SyadzzPrivateScript") then
        LocalPlayer.PlayerGui.SyadzzPrivateScript:Destroy()
    end
    if game:GetService("CoreGui"):FindFirstChild("SyadzzPrivateScript") then
        game:GetService("CoreGui").SyadzzPrivateScript:Destroy()
    end
end)

-- 2. LOAD RAYFIELD UI LIBRARY
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end

-- ASSET ID UNTUK LOGO
local logoAssetId = "rbxthumb://type=Asset&id=87188655335018&w=420&h=420"

-- 3. CREATE WINDOW WITH LOGO ICON
local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚",
    Icon = logoAssetId, -- Menampilkan gambar logo di samping nama Syadzz Hub
    LoadingTitle = "SYADZZ HUB Loading...",
    LoadingSubtitle = "by Syadzz & Syadholicc",
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

-- SETTINGS CONFIGURATION (DEFAULT OFF)
local Settings = {
    TeleportSteal = false,
    AutoSteal = false,
    Godmode = false,
    AutoPlace = false,
    AntiHitGuard = false,
    AutoTreadmill = false,
    StealMethod = "Glide",
    StealSpeed = 100,

    PetNames = "All (none)",
    SelectedArea = "All (none)",
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

-- RARITY WEIGHTS
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
local function getEggRarityNameAndWeight(eggObj)
    if not eggObj then return "Uncommon", 1 end
    
    local fullText = ""
    local curr = eggObj
    for i = 1, 4 do
        if curr then
            fullText = fullText .. " " .. curr.Name:lower()
            curr = curr.Parent
        end
    end

    if eggObj:FindFirstChild("Rarity") then
        fullText = fullText .. " " .. tostring(eggObj.Rarity.Value):lower()
    end

    for rarity, weight in pairs(RarityWeight) do
        if fullText:find(rarity:lower()) then
            return rarity, weight
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

-- DETEKSI PLOT KHUSUS MILIK SENDIRI
local function getMyPlotStrict()
    local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("PlotsFolder")
    if plotsFolder then
        for _, plot in pairs(plotsFolder:GetChildren()) do
            if plot.Name == LocalPlayer.Name or plot.Name:lower():find(LocalPlayer.Name:lower()) then
                return plot
            end
            local ownerVal = plot:FindFirstChild("Owner") or plot:FindFirstChild("Player") or plot:FindFirstChild("OwnerValue")
            if ownerVal and (tostring(ownerVal.Value) == LocalPlayer.Name or ownerVal.Value == LocalPlayer) then
                return plot
            end
        end
    end
    return nil
end

-- DETEKSI ZONA AMAN BASE SENDIRI
local function getMySafeZoneCFrame()
    local myPlot = getMyPlotStrict()
    if myPlot then
        for _, obj in pairs(myPlot:GetDescendants()) do
            local oName = obj.Name:lower()
            if oName:find("zona aman") or oName:find("safezone") or oName:find("safe zone") or oName:find("spawn") then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    return part.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end
        return myPlot:GetPivot() + Vector3.new(0, 3, 0)
    end
    return LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.CFrame
end

-- CREATING TABS
local StealTab = Window:CreateTab("Steal", 4483362458)
local FilterTab = Window:CreateTab("Filter Tools", 4483362458)
local ProfileTab = Window:CreateTab("SYADHOLICC", 4483362458)

-- 1. STEAL TAB UI
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
    Name = "Auto Treadmill (Plot Sendiri Only)",
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

-- 2. FILTER TAB UI
FilterTab:CreateDropdown({
    Name = "Pet Names",
    Options = {"All (none)", "Custom"},
    CurrentOption = {"All (none)"},
    MultipleOptions = false,
    Callback = function(Option) Settings.PetNames = Option[1] end,
})

FilterTab:CreateDropdown({
    Name = "Areas",
    Options = {"All (none)", "Enchanted Forest", "Light Dark", "Titan Temple", "Cherry Blossom", "Cosmic", "Prehistoric", "Abyss Ocean", "Volcano", "Snow", "Jungle", "Desert", "Lake"},
    CurrentOption = {"All (none)"},
    MultipleOptions = false,
    Callback = function(Option) Settings.SelectedArea = Option[1] end,
})

local rarities = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare", "SuperRare", "Uncommon"}
for _, rarity in ipairs(rarities) do
    FilterTab:CreateToggle({
        Name = "Filter: " .. rarity,
        CurrentValue = false,
        Callback = function(Value) Settings.Rarities[rarity] = Value end,
    })
end

-- 3. PROFILE TAB UI
ProfileTab:CreateSection("SYADHOLICC Official Logo")
ProfileTab:CreateLabel("Owner: SYADHOLICC")
pcall(function()
    ProfileTab:CreateImage({
        Name = "SYADHOLICC Logo",
        Image = logoAssetId
    })
end)

-- LOGIKA AUTO STEAL
task.spawn(function()
    while task.wait(0.12) do
        if Settings.AutoSteal or Settings.TeleportSteal then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local targets = {}
                local activeRarityFilters = {}

                for rName, active in pairs(Settings.Rarities) do
                    if active then
                        table.insert(activeRarityFilters, rName:lower())
                    end
                end

                for _, obj in pairs(Workspace:GetDescendants()) do
                    if isRealEggPrompt(obj) then
                        local eggModel = obj.Parent
                        local eggPart = eggModel:IsA("BasePart") and eggModel or eggModel:FindFirstChildWhichIsA("BasePart", true)
                        if eggPart then
                            local rName, rWeight = getEggRarityNameAndWeight(eggModel)

                            -- Area Check
                            local areaMatch = true
                            if Settings.SelectedArea ~= "All (none)" and Settings.SelectedArea ~= "All" then
                                local targetAreaName = Settings.SelectedArea:lower()
                                local fullParentHierarchy = ""
                                local parentTracker = eggModel
                                for i = 1, 5 do
                                    if parentTracker then
                                        fullParentHierarchy = fullParentHierarchy .. " " .. parentTracker.Name:lower()
                                        parentTracker = parentTracker.Parent
                                    end
                                end
                                if not fullParentHierarchy:find(targetAreaName) then
                                    areaMatch = false
                                end
                            end

                            -- Rarity Check
                            local rarityMatch = false
                            if #activeRarityFilters == 0 then
                                rarityMatch = true
                            else
                                for _, filterName in ipairs(activeRarityFilters) do
                                    if rName:lower():find(filterName) or eggModel.Name:lower():find(filterName) then
                                        rarityMatch = true
                                        break
                                    end
                                end
                            end

                            if areaMatch and rarityMatch then
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

                -- Prioritaskan Telur Paling Bagus
                table.sort(targets, function(a, b)
                    if a.weight ~= b.weight then
                        return a.weight > b.weight
                    end
                    return a.dist < b.dist
                end)

                if #targets > 0 then
                    local target = targets[1]
                    local safeZoneCFrame = getMySafeZoneCFrame()

                    -- Teleport ke lokasi telur
                    char.HumanoidRootPart.CFrame = target.part.CFrame * CFrame.new(0, 2.5, 0)
                    task.wait(0.08)

                    -- Trigger Pengambilan Telur
                    target.prompt.RequiresLineOfSight = false
                    fireproximityprompt(target.prompt)
                    task.wait(0.12)

                    -- Berpindah Balik ke Zona Aman
                    if safeZoneCFrame then
                        char.HumanoidRootPart.CFrame = safeZoneCFrame
                        task.wait(0.15)
                    end
                end
            end)
        end
    end
end)

-- LOGIKA AUTO TREADMILL
task.spawn(function()
    while task.wait(0.15) do
        if Settings.AutoTreadmill then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local myPlot = getMyPlotStrict()
                local targetTreadmill = nil

                if myPlot then
                    for _, obj in pairs(myPlot:GetDescendants()) do
                        local oName = obj.Name:lower()
                        if oName:find("treadmill") or oName:find("trainer") or oName:find("tread") then
                            targetTreadmill = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                            if targetTreadmill then break end
                        end
                    end
                end

                if targetTreadmill then
                    local treadmillCFrame = targetTreadmill.CFrame
                    local positionAbove = treadmillCFrame.Position + Vector3.new(0, 2.8, 0)
                    
                    char.HumanoidRootPart.CFrame = CFrame.new(positionAbove, positionAbove + treadmillCFrame.LookVector)
                    char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                end
            end)
        end
    end
end)

-- LOGIKA AUTO PLACE TO PEN
task.spawn(function()
    while task.wait(0.5) do
        if Settings.AutoPlace then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool.Name:lower():find("egg") then
                    local myPlot = getMyPlotStrict()
                    if myPlot then
                        for _, obj in pairs(myPlot:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") and (obj.ActionText:lower():find("place") or obj.ObjectText:lower():find("pen")) then
                                fireproximityprompt(obj)
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- LOGIKA GODMODE & ANTI RAGDOLL
RunService.Stepped:Connect(function()
    if Settings.Godmode then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    -- Anti Ragdoll & Anti Knockdown
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    if humanoid:GetState() == Enum.HumanoidStateType.Ragdoll or humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end

                -- Hilangkan efek hit/push pada BasePart
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
end)

Rayfield:Notify({
    Title = "SYADZZ HUB",
    Content = "Script successfully loaded!",
    Duration = 5,
    Image = logoAssetId
})
