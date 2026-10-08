--// SYADZZ HUB - FIXED AUTO STEAL & FILTER EDITION (STEAL AN EGG)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- CLEANUP GUI LAMA
pcall(function()
    if CoreGui:FindFirstChild("SyadzzFixHub") then
        CoreGui.SyadzzFixHub:Destroy()
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Fixed Steal & Filters]",
    LoadingTitle = "Loading Fix...",
    LoadingSubtitle = "by Syadholicc",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Settings = {
    AutoSteal = false,
    AutoPlace = false,
    AutoTreadmill = false,
    SavedBasePos = nil,
    SavedTreadmillPos = nil,
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
    "All (none)", "Forest", "Lake", "Desert", "Jungle", "Snow", 
    "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", 
    "Titan Temple", "Enchanted Forest"
}

-- HELPER: DETEKSI RARITY
local function detectEggRarity(eggObj)
    if not eggObj then return "Rare", 300 end
    
    local searchString = eggObj.Name:lower() .. " " .. eggObj:GetFullName():lower()
    
    for _, attrVal in pairs(eggObj:GetAttributes()) do
        searchString = searchString .. " " .. tostring(attrVal):lower()
    end
    for _, child in pairs(eggObj:GetChildren()) do
        if child:IsA("ValueBase") then
            searchString = searchString .. " " .. tostring(child.Value):lower()
        end
    end
    
    for rarityName, weight in pairs(RarityWeight) do
        if searchString:find(rarityName:lower()) then
            return rarityName, weight
        end
    end
    
    return "Rare", 300
end

-- HELPER: PROXIMITY PROMPT EGG VALID
local function isValidEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local fullName = prompt:GetFullName():lower()
    
    if fullName:find("wisp") or fullName:find("machine") or fullName:find("lab") or fullName:find("quest") then 
        return false 
    end
    
    if fullName:find("egg") or prompt.ObjectText:lower():find("egg") or prompt.ActionText:lower():find("steal") or prompt.ActionText:lower():find("take") then
        return true
    end
    
    for rName, _ in pairs(RarityWeight) do
        if fullName:find(rName:lower()) then
            return true
        end
    end
    
    return false
end

-- HELPER: MATCH AREA / ZONA
local function checkAreaMatch(eggObj, targetArea)
    if targetArea == "All (none)" or targetArea == "All" or targetArea == "" then
        return true
    end
    
    local fullName = eggObj:GetFullName():lower()
    local cleanTarget = targetArea:lower():gsub("%s+", "")
    local rawTarget = targetArea:lower()
    
    if fullName:gsub("%s+", ""):find(cleanTarget) or fullName:find(rawTarget) then
        return true
    end
    
    return false
end

-- TABS
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local FilterTab = Window:CreateTab("Filters", 4483362458)
local GymTab = Window:CreateTab("Gym", 4483362458)

-- FARM TAB
FarmTab:CreateToggle({
    Name = "Auto Steal Egg",
    CurrentValue = false,
    Callback = function(v) 
        Settings.AutoSteal = v 
        if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Settings.SavedBasePos = LocalPlayer.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "Base Position Saved", Content = "Posisi dasar kamu berhasil disimpan!", Duration = 3})
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Place to Pen",
    CurrentValue = false,
    Callback = function(v) Settings.AutoPlace = v end,
})

-- FILTER TAB
FilterTab:CreateDropdown({
    Name = "Filter Area / Zone",
    Options = GameZones,
    CurrentOption = {"All (none)"},
    Callback = function(opt) 
        Settings.SelectedArea = opt[1] 
    end,
})

FilterTab:CreateSection("Filter Rarity (Kosongkan/Matikan Semua untuk Ambil Semua)")
local raritiesList = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare"}
for _, r in ipairs(raritiesList) do
    FilterTab:CreateToggle({
        Name = "Target " .. r,
        CurrentValue = false,
        Callback = function(v) 
            Settings.Rarities[r] = v 
        end,
    })
end

-- GYM TAB
GymTab:CreateButton({
    Name = "1. Set Posisi Treadmill (Berdiri di Atas Treadmill)",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Settings.SavedTreadmillPos = LocalPlayer.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "Treadmill Saved", Content = "Posisi treadmill tersimpan!", Duration = 3})
        end
    end,
})

GymTab:CreateToggle({
    Name = "2. Auto Treadmill",
    CurrentValue = false,
    Callback = function(v) 
        if v and not Settings.SavedTreadmillPos then
            Rayfield:Notify({Title = "Peringatan", Content = "Klik 'Set Posisi Treadmill' dulu pas berdiri di mesin!", Duration = 4})
            Settings.AutoTreadmill = false
            return
        end
        Settings.AutoTreadmill = v 
    end,
})

-- LOOP AUTO STEAL
task.spawn(function()
    while task.wait(0.2) do
        if Settings.AutoSteal then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart
                
                local activeRarities = {}
                local isAnyRarityActive = false
                for rName, active in pairs(Settings.Rarities) do
                    if active then
                        isAnyRarityActive = true
                        table.insert(activeRarities, rName)
                    end
                end
                
                local targets = {}
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if isValidEggPrompt(obj) then
                        local eggModel = obj.Parent
                        local eggPart = eggModel:IsA("BasePart") and eggModel or eggModel:FindFirstChildWhichIsA("BasePart", true)
                        
                        if eggPart then
                            local rName, rWeight = detectEggRarity(eggModel)
                            local isAreaValid = checkAreaMatch(eggModel, Settings.SelectedArea)
                            local isRarityValid = not isAnyRarityActive or Settings.Rarities[rName]
                            
                            if isAreaValid and isRarityValid then
                                table.insert(targets, {
                                    prompt = obj,
                                    part = eggPart,
                                    weight = rWeight
                                })
                            end
                        end
                    end
                end
                
                table.sort(targets, function(a, b) return a.weight > b.weight end)
                
                if #targets > 0 then
                    local target = targets[1]
                    local returnPos = Settings.SavedBasePos or hrp.CFrame
                    
                    -- Reset kecepatan fisika biar gak terlempar ke langit/void
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    
                    -- Matikan collision sementara biar gak mental karena tabrakan hitbox
                    for _, part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    
                    -- Teleport tepat di atas telur
                    hrp.CFrame = target.part.CFrame * CFrame.new(0, 2.5, 0)
                    task.wait(0.1)
                    
                    target.prompt.MaxActivationDistance = 9999
                    target.prompt.RequiresLineOfSight = false
                    fireproximityprompt(target.prompt)
                    task.wait(0.12)
                    
                    -- Balik ke titik aman
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.CFrame = returnPos
                    task.wait(0.05)
                end
            end)
        end
    end
end)

-- LOOP AUTO TREADMILL
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoTreadmill and Settings.SavedTreadmillPos then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = Settings.SavedTreadmillPos
                    char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                end
            end)
        end
    end
end)

-- LOOP AUTO PLACE TO PEN
task.spawn(function()
    while task.wait(0.4) do
        if Settings.AutoPlace then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool.Name:lower():find("egg") then
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") and (obj.ActionText:lower():find("place") or obj.ObjectText:lower():find("pen")) then
                            fireproximityprompt(obj)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({
    Title = "SYADZZ HUB",
    Content = "Script fix berhasil dimuat!",
    Duration = 4,
})
