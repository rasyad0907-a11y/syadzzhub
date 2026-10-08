--// SYADZZ HUB - STEAL AN EGG (PERFECT FILTER & TELEPORT FIX)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("SyadzzPerfectScript") then
        CoreGui.SyadzzPerfectScript:Destroy()
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Pro Fix]",
    LoadingTitle = "Memuat Script...",
    LoadingSubtitle = "by Syadholicc",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Settings = {
    AutoSteal = false,
    AutoPlace = false,
    AutoTreadmill = false,
    SelectedArea = "All (none)",
    SavedBaseCFrame = nil,
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

-- HIERARKI KELANGKAAN (Divine > Eternal > Secret > Cosmic > Mythic > Legendary > Epic > Rare)
local RarityPriority = {
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

-- MENCARI BASE / PLOT PLAYER SECARA OTOMATIS & AMAN
local function getSafeBaseCFrame()
    if Settings.SavedBaseCFrame and Settings.SavedBaseCFrame.Position.Y > 0 then
        return Settings.SavedBaseCFrame
    end
    
    local possibleFolders = {"Plots", "Bases", "PlotFolder", "PlayerPlots", "BasesFolder"}
    for _, fName in ipairs(possibleFolders) do
        local folder = Workspace:FindFirstChild(fName)
        if folder then
            for _, plot in pairs(folder:GetChildren()) do
                if plot.Name == LocalPlayer.Name 
                   or plot:GetAttribute("Owner") == LocalPlayer.Name 
                   or plot:GetAttribute("Player") == LocalPlayer.Name
                   or (plot:FindFirstChild("Owner") and tostring(plot.Owner.Value) == LocalPlayer.Name) then
                    local pPivot = plot:GetPivot()
                    if pPivot.Position.Y > -10 then
                        return pPivot + Vector3.new(0, 4, 0)
                    end
                end
            end
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if hrp.Position.Y > -10 then
            return hrp.CFrame
        end
    end

    return CFrame.new(0, 10, 0)
end

-- DETEKSI TREADMILL TERDEKAT DENGAN PLOT/PLAYER OTOMATIS
local function getAutoTreadmillPart()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position

    local bestPart = nil
    local minDistance = 250

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            local parentName = obj.Parent and obj.Parent.Name:lower() or ""
            
            if name:find("treadmill") or name:find("trainer") or name:find("gym") 
               or name:find("flame") or name:find("freeze") or name:find("demonic") 
               or name:find("angelic") or name:find("astral") or name:find("scifi")
               or parentName:find("treadmill") or parentName:find("trainer") then
                
                local dist = (obj.Position - myPos).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    bestPart = obj
                end
            end
        end
    end
    return bestPart
end

-- DETEKSI RARITY TELUR (AKURAT DENGAN STRING SEARCH)
local function getEggRarityData(eggModel)
    if not eggModel then return "Rare", 300 end
    local fullText = eggModel:GetFullName():lower()
    for _, attr in pairs(eggModel:GetAttributes()) do
        fullText = fullText .. " " .. tostring(attr):lower()
    end
    
    for rarity, weight in pairs(RarityPriority) do
        if fullText:find(rarity:lower()) then
            return rarity, weight
        end
    end
    return "Rare", 300
end

-- MATCH ZONA/AREA TELUR
local function isZoneMatched(eggObj, selectedArea)
    if selectedArea == "All (none)" or selectedArea == "All" or selectedArea == "" then
        return true
    end
    local fullPath = eggObj:GetFullName():lower():gsub("%s+", "")
    local target = selectedArea:lower():gsub("%s+", "")
    return fullPath:find(target) ~= nil
end

-- TABS
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local FilterTab = Window:CreateTab("Filters & Priority", 4483362458)
local GymTab = Window:CreateTab("Gym", 4483362458)

-- FARM TAB
FarmTab:CreateToggle({
    Name = "Auto Steal Egg",
    CurrentValue = false,
    Callback = function(v)
        Settings.AutoSteal = v
        if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if hrp.Position.Y > -10 then
                Settings.SavedBaseCFrame = hrp.CFrame
                Rayfield:Notify({Title = "Base Safe Zone Saved", Content = "Titik base berhasil dikunci!", Duration = 3})
            end
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
    Name = "Filter Area / Zone Area",
    Options = GameZones,
    CurrentOption = {"All (none)"},
    Callback = function(opt) Settings.SelectedArea = opt[1] end,
})

FilterTab:CreateSection("Target Rarity Filters (Prioritas: Divine > Eternal > Secret > dst)")
local raritiesList = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare"}
for _, r in ipairs(raritiesList) do
    FilterTab:CreateToggle({
        Name = "Target: " .. r,
        CurrentValue = false,
        Callback = function(v) Settings.Rarities[r] = v end,
    })
end

-- GYM TAB
GymTab:CreateToggle({
    Name = "Auto Treadmill (Deteksi Otomatis Mesin)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTreadmill = v end,
})

-- LOOP AUTO TREADMILL (OTOMATIS TANPA BUTTON)
local targetTreadmillPart = nil
task.spawn(function()
    while task.wait(0.15) do
        if Settings.AutoTreadmill then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                if not targetTreadmillPart or not targetTreadmillPart:IsDescendantOf(Workspace) then
                    targetTreadmillPart = getAutoTreadmillPart()
                end

                if targetTreadmillPart then
                    hrp.CFrame = targetTreadmillPart.CFrame + Vector3.new(0, 3, 0)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end)
        else
            targetTreadmillPart = nil
        end
    end
end)

-- LOOP AUTO STEAL (SISTEM PRIORITAS DENGAN KETAT)
task.spawn(function()
    while task.wait(0.25) do
        if Settings.AutoSteal then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                local safeReturn = getSafeBaseCFrame()

                local activeRarities = {}
                local totalActiveRarities = 0
                for rName, active in pairs(Settings.Rarities) do
                    if active then
                        totalActiveRarities = totalActiveRarities + 1
                        activeRarities[rName] = true
                    end
                end

                local targets = {}
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        local fullName = obj:GetFullName():lower()
                        if not fullName:find("wisp") and not fullName:find("machine") and not fullName:find("shop") and not fullName:find("quest") then
                            if fullName:find("egg") or obj.ObjectText:lower():find("egg") or obj.ActionText:lower():find("steal") or obj.ActionText:lower():find("take") then
                                local eggModel = obj.Parent
                                local eggPart = eggModel:IsA("BasePart") and eggModel or eggModel:FindFirstChildWhichIsA("BasePart", true)

                                if eggPart then
                                    local rName, rWeight = getEggRarityData(eggModel)
                                    
                                    -- Filter 1: Area
                                    local isAreaOk = isZoneMatched(eggModel, Settings.SelectedArea)
                                    
                                    -- Filter 2: Rarity
                                    local isRarityOk = (totalActiveRarities == 0) or (activeRarities[rName] == true)

                                    if isAreaOk and isRarityOk then
                                        table.insert(targets, {
                                            prompt = obj,
                                            part = eggPart,
                                            weight = rWeight,
                                            rarity = rName
                                        })
                                    end
                                end
                            end
                        end
                    end
                end

                -- URUTKAN BERDASARKAN PRIORITAS WEIGHT TERTINGGI
                table.sort(targets, function(a, b)
                    return a.weight > b.weight
                end)

                -- EKSEKUSI TELEPORT UNTUK TELUR DENGAN PRIORITAS TERTINGGI
                if #targets > 0 then
                    local target = targets[1]

                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero

                    hrp.CFrame = target.part.CFrame * CFrame.new(0, 2.5, 0)
                    task.wait(0.1)

                    target.prompt.RequiresLineOfSight = false
                    target.prompt.MaxActivationDistance = 9999
                    fireproximityprompt(target.prompt)
                    task.wait(0.12)

                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    hrp.CFrame = safeReturn
                    task.wait(0.08)
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
    Content = "Script Steal, Filter Prioritas & Treadmill Siap!",
    Duration = 4,
})
