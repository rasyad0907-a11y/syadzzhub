--// SYADZZ HUB - FULL FIXED ULTIMATE EDITION (STEAL AN EGG)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP GUI LAMA
pcall(function()
    if CoreGui:FindFirstChild("SyadzzFixedUltimateHub") then
        CoreGui.SyadzzFixedUltimateHub:Destroy()
    end
end)

-- 2. LOAD RAYFIELD UI LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Fixed Ultimate]",
    LoadingTitle = "Loading Fixed Hub...",
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

-- BOBOT RARITAS UNTUK PRIORITAS STEAL
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

-- DAFTAR ZONA RESMI GAME[cite: 5, 6]
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

-- HELPER: DETEKSI RARITAS TELUR
local function getEggRarityNameAndWeight(eggObj)
    if not eggObj then return "Rare", 300 end
    local fullText = ""
    local curr = eggObj
    for i = 1, 6 do
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
    return "Rare", 300
end

local function isRealEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local parentName = prompt.Parent and prompt.Parent.Name:lower() or ""
    if parentName:find("wisp") or parentName:find("machine") or parentName:find("lab") then return false end
    if parentName:find("egg") or prompt.ObjectText:lower():find("egg") then return true end
    return false
end

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
    -- Fallback cari model atas nama player
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
        for _, obj in pairs(myPlot:GetDescendants()) do
            local oName = obj.Name:lower()
            if oName:find("safe") or oName:find("spawn") or oName:find("zona") then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                if part then return part.CFrame + Vector3.new(0, 3, 0) end
            end
        end
        return myPlot:GetPivot() + Vector3.new(0, 3, 0)
    end
    return LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.CFrame
end

-- TABS CREATION
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local FilterTab = Window:CreateTab("Filters & Rarity", 4483362458)
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

-- 2. FILTER TAB (AREA & RARITIES KEMBALI LENGKAP)
FilterTab:CreateDropdown({
    Name = "Filter by Zone Area",
    Options = GameZones,
    CurrentOption = {"All (none)"},
    Callback = function(opt) Settings.SelectedArea = opt[1] end,
})

FilterTab:CreateSection("Target Rarity Filters")
local raritiesList = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare"}
for _, r in ipairs(raritiesList) do
    FilterTab:CreateToggle({
        Name = "Target: " + r, -- Jika error tanda plus string di beberapa executor, diganti manual bawahnya
        Name = "Filter Rarity: " .. r,
        CurrentValue = false,
        Callback = function(v) Settings.Rarities[r] = v end,
    })
end

-- 3. GYM TAB
GymTab:CreateToggle({
    Name = "Auto Treadmill (Teleport to Base Machine)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTreadmill = v end,
})

GymTab:CreateToggle({
    Name = "Auto Collect Wisp Event",
    CurrentValue = false,
    Callback = function(v) Settings.AutoWisp = v end,
})

-- BACKGROUND EXECUTION: AUTO STEAL DENGAN TELEPORT & FILTER RARITY
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
                            local fullHierarchy = ""
                            local curr = model
                            for i = 1, 6 do
                                if curr then
                                    fullHierarchy = fullHierarchy .. " " .. curr.Name:lower()
                                    curr = curr.Parent
                                end
                            end
                            
                            local areaOk = true
                            if Settings.SelectedArea ~= "All (none)" then
                                if not fullHierarchy:find(Settings.SelectedArea:lower():gsub("%s+", "")) then
                                    areaOk = false
                                end
                            end
                            
                            -- Cek Filter Rarity (Jika ada yang nyala, ikuti. Kalau mati semua, ambil semua)
                            local anyActive = false
                            for _, active in pairs(Settings.Rarities) do
                                if active then anyActive = true break end
                            end
                            
                            local rarityOk = not anyActive or Settings.Rarities[rName]

                            if areaOk and rarityOk then
                                table.insert(targets, {prompt = obj, part = part, weight = rWeight})
                            end
                        end
                    end
                end

                -- Urutkan berdasarkan bobot rarity tertinggi
                table.sort(targets, function(a, b) return a.weight > b.weight end)

                if #targets > 0 then
                    local t = targets[1]
                    local safeCFrame = getMySafeZoneCFrame()
                    
                    -- Teleport ke Telur
                    char.HumanoidRootPart.CFrame = t.part.CFrame * CFrame.new(0, 2.5, 0)
                    task.wait(0.1)
                    
                    t.prompt.RequiresLineOfSight = false
                    fireproximityprompt(t.prompt)
                    task.wait(0.15)
                    
                    -- Teleport kembali ke Safe Zone Base
                    if safeCFrame then
                        char.HumanoidRootPart.CFrame = safeCFrame
                    end
                end
            end)
        end
    end
end)

-- BACKGROUND EXECUTION: AUTO TREADMILL & WISP TELEPORT
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            -- Auto Treadmill Teleport
            if Settings.AutoTreadmill then
                local myPlot = getMyPlotStrict()
                local targetTreadmill = nil
                
                if myPlot then
                    for _, obj in pairs(myPlot:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local oName = obj.Name:lower()
                            -- Deteksi berbagai jenis treadmill base, sci-fi, freeze, astral, dll[cite: 3, 4]
                            if oName:find("treadmill") or oName:find("trainer") or oName:find("gym") or oName:find("freeze") or oName:find("astral") or oName:find("flame") then
                                targetTreadmill = obj
                                break
                            end
                        end
                    end
                end

                if targetTreadmill then
                    -- Teleport pas di atas treadmill player
                    char.HumanoidRootPart.CFrame = targetTreadmill.CFrame + Vector3.new(0, 3, 0)
                    char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                end
            end

            -- Auto Wisp Teleport
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
    Title = "SYADZZ HUB (Fixed Ultimate)",
    Content = "Loaded Successfully! Teleport & Rarity Filters Fixed.",
    Duration = 5,
})
