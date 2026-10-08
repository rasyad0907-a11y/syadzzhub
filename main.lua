--// SYADZZ HUB - STABLE RESTORED EDITION (STEAL AN EGG)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP GUI LAMA
pcall(function()
    if CoreGui:FindFirstChild("SyadzzStableHub") then
        CoreGui.SyadzzStableHub:Destroy()
    end
end)

-- 2. LOAD RAYFIELD UI LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Stable Edition]",
    LoadingTitle = "Loading Stable Hub...",
    LoadingSubtitle = "by Syadholicc",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- CONFIGURATION SETTINGS (SEMUA MATI / OFF DEFAULT)
local Settings = {
    AutoSteal = false,
    AutoPlace = false,
    AutoTreadmill = false,
    AutoWisp = false,
    SelectedArea = "All (none)",
    Rarities = {
        ["Divine"] = false,
        ["Eternal"] = false,
        ["Secret"] = false,
        ["Cosmic"] = false,
        ["Mythic"] = false,
        ["Legendary"] = false,
        ["Epic"] = false,
        ["Rare"] = false
    }
}

local RarityWeight = {
    ["Divine"] = 1000,
    ["Eternal"] = 900,
    ["Secret"] = 800,
    ["Cosmic"] = 700,
    ["Mythic"] = 600,
    ["Legendary"] = 500,
    ["Epic"] = 400,
    ["Rare"] = 300
}

local GameZones = {
    "All (none)",
    "Forest",
    "Lake",
    "Desert",
    "Jungle",
    "Snow",
    "Volcano",
    "Abyss Ocean",
    "Prehistoric",
    "Cosmic",
    "Cherry Blossom",
    "Titan Temple",
    "Enchanted Forest"
}

-- HELPER: DETEKSI RARITAS
local function getEggRarityNameAndWeight(eggObj)
    if not eggObj then return "Rare", 300 end
    local fullText = eggObj.Name:lower()
    local curr = eggObj.Parent
    for i = 1, 4 do
        if curr then
            fullText = fullText .. " " .. curr.Name:lower()
            curr = curr.Parent
        end
    end
    for rarity, weight in pairs(RarityWeight) do
        if fullText:find(rarity:lower()) then
            return rarity, weight
        end
    end
    return "Rare", 300
end

local function isRealEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local parentName = prompt.Parent and prompt.Parent.Name:lower() or ""
    if parentName:find("wisp") or parentName:find("machine") or parentName:find("lab") then return false end
    if parentName:find("egg") or prompt.ObjectText:lower():find("egg") or prompt.ActionText:lower():find("steal") then return true end
    return false
end

-- PENCARIAN PLOT / BASE SENDIRI YANG AKURAT
local function getMyPlotStrict()
    local possibleFolders = {"Plots", "Bases", "PlotFolder", "PlayerPlots", "Base"}
    for _, fName in ipairs(possibleFolders) do
        local folder = Workspace:FindFirstChild(fName)
        if folder then
            for _, plot in pairs(folder:GetChildren()) do
                if plot.Name == LocalPlayer.Name or plot:GetAttribute("Owner") == LocalPlayer.Name or plot:GetAttribute("Player") == LocalPlayer.Name then
                    return plot
                end
            end
        end
    end
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj.Name:lower():find(LocalPlayer.Name:lower()) then
            return obj
        end
    end
    return nil
end

local function getMySafeZoneCFrame()
    local myPlot = getMyPlotStrict()
    if myPlot then
        return myPlot:GetPivot() + Vector3.new(0, 3, 0)
    end
    return LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.CFrame
end

-- TABS CREATION
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local FilterTab = Window:CreateTab("Filters & Zone", 4483362458)
local GymTab = Window:CreateTab("Gym & Misc", 4483362458)

-- 1. FARM TAB
FarmTab:CreateToggle({
    Name = "Auto Steal Egg (Teleport Mode)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoSteal = v end,
})

FarmTab:CreateToggle({
    Name = "Auto Place to Pen",
    CurrentValue = false,
    Callback = function(v) Settings.AutoPlace = v end,
})

-- 2. FILTER TAB
FilterTab:CreateDropdown({
    Name = "Filter by Zone Area",
    Options = GameZones,
    CurrentOption = {"All (none)"},
    Callback = function(opt) Settings.SelectedArea = opt[1] end,
})

FilterTab:CreateSection("Target Rarity Toggles")
local raritiesList = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare"}
for _, r in ipairs(raritiesList) do
    FilterTab:CreateToggle({
        Name = "Target: " .. r,
        CurrentValue = false,
        Callback = function(v) Settings.Rarities[r] = v end,
    })
end

-- 3. GYM TAB
GymTab:CreateToggle({
    Name = "Auto Treadmill (Base Gym)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTreadmill = v end,
})

GymTab:CreateToggle({
    Name = "Auto Collect Wisp Event",
    CurrentValue = false,
    Callback = function(v) Settings.AutoWisp = v end,
})

-- BACKGROUND: AUTO STEAL DENGAN TELEPORT PAS DI TELUR
task.spawn(function()
    while task.wait(0.2) do
        if Settings.AutoSteal then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                
                local targets = {}
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if isRealEggPrompt(obj) then
                        local model = obj.Parent
                        local part = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
                        if part then
                            local rName, rWeight = getEggRarityNameAndWeight(model)
                            
                            -- Cek Filter Area
                            local areaMatch = true
                            if Settings.SelectedArea ~= "All (none)" then
                                local hierarchy = ""
                                local curr = model
                                for i = 1, 5 do
                                    if curr then
                                        hierarchy = hierarchy .. " " .. curr.Name:lower()
                                        curr = curr.Parent
                                    end
                                end
                                if not hierarchy:find(Settings.SelectedArea:lower():gsub("%s+", "")) then
                                    areaMatch = false
                                end
                            end
                            
                            -- Cek Filter Rarity
                            local anyActive = false
                            for _, active in pairs(Settings.Rarities) do
                                if active then anyActive = true break end
                            end
                            
                            local rarityMatch = not anyActive or Settings.Rarities[rName]

                            if areaMatch and rarityMatch then
                                table.insert(targets, {prompt = obj, part = part, weight = rWeight})
                            end
                        end
                    end
                end

                table.sort(targets, function(a, b) return a.weight > b.weight end)

                if #targets > 0 then
                    local t = targets[1]
                    local safeCFrame = getMySafeZoneCFrame()
                    
                    -- Teleport persis di atas telur tanpa keluar batas
                    char.HumanoidRootPart.CFrame = t.part.CFrame + Vector3.new(0, 2.5, 0)
                    task.wait(0.1)
                    
                    t.prompt.MaxActivationDistance = 999
                    t.prompt.RequiresLineOfSight = false
                    fireproximityprompt(t.prompt)
                    task.wait(0.15)
                    
                    if safeCFrame then
                        char.HumanoidRootPart.CFrame = safeCFrame
                    end
                end
            end)
        end
    end
end)

-- BACKGROUND: AUTO TREADMILL & WISP
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            if Settings.AutoTreadmill then
                local myPlot = getMyPlotStrict()
                local targetTreadmill = nil
                if myPlot then
                    for _, obj in pairs(myPlot:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local oName = obj.Name:lower()
                            if oName:find("treadmill") or oName:find("trainer") or oName:find("gym") or oName:find("freeze") or oName:find("astral") or oName:find("flame") then
                                targetTreadmill = obj
                                break
                            end
                        end
                    end
                end

                if targetTreadmill then
                    char.HumanoidRootPart.CFrame = targetTreadmill.CFrame + Vector3.new(0, 3, 0)
                    char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                end
            end

            if Settings.AutoWisp then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent.Name:lower():find("wisp") then
                        local p = obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart", true)
                        if p then
                            char.HumanoidRootPart.CFrame = p.CFrame + Vector3.new(0, 2, 0)
                            fireproximityprompt(obj)
                        end
                    end
                end
            end
        end)
    end
end)

-- AUTO PLACE TO PEN
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

Rayfield:Notify({
    Title = "SYADZZ HUB (Stable)",
    Content = "Successfully Loaded! Teleport & Filters Restored.",
    Duration = 5,
})
