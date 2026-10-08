--// SYADZZ HUB - STEAL AN EGG (STABLE & ACCURATE EDITION)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("SyadzzPerfectHub") then
        CoreGui.SyadzzPerfectHub:Destroy()
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Fix Final]",
    LoadingTitle = "Memuat Syadzz Hub...",
    LoadingSubtitle = "by Syadholicc",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- Configuration Settings (Default OFF)[cite: 2]
local Settings = {
    AutoSteal = false,
    AutoPlace = false,
    AutoTreadmill = false,
    SelectedArea = "All (none)",
    SavedBaseCFrame = nil,
    ManualTreadmillCFrame = nil,
    Rarities = {
        ["Divine"] = false, ["Eternal"] = false, ["Secret"] = false,
        ["Cosmic"] = false, ["Mythic"] = false, ["Legendary"] = false,
        ["Epic"] = false, ["Rare"] = false
    }
}

local RarityWeight = {
    ["Divine"] = 1000, ["Eternal"] = 900, ["Secret"] = 800,
    ["Cosmic"] = 700, ["Mythic"] = 600, ["Legendary"] = 500,
    ["Epic"] = 400, ["Rare"] = 300
}

local GameZones = {
    "All (none)", "Forest", "Lake", "Desert", "Jungle", "Snow", 
    "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", 
    "Titan Temple", "Enchanted Forest"
}

-- MENCARI BASE / PLOT PLAYER[cite: 10]
local function getPlayerPlot()
    local possibleFolders = {"Plots", "Bases", "PlotFolder", "PlayerPlots", "BasesFolder"}
    for _, fName in ipairs(possibleFolders) do
        local folder = Workspace:FindFirstChild(fName)
        if folder then
            for _, plot in pairs(folder:GetChildren()) do
                if plot.Name == LocalPlayer.Name 
                   or plot:GetAttribute("Owner") == LocalPlayer.Name 
                   or plot:GetAttribute("Player") == LocalPlayer.Name
                   or (plot:FindFirstChild("Owner") and tostring(plot.Owner.Value) == LocalPlayer.Name) then
                    return plot
                end
            end
        end
    end
    return nil
end

-- MENCARI MESIN TREADMILL DI BASE SECARA OTOMATIS
local function getTreadmillPartAuto()
    local plot = getPlayerPlot()
    if plot then
        for _, obj in pairs(plot:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:find("treadmill") or name:find("trainer") or name:find("gym") 
                   or name:find("flame") or name:find("freeze") or name:find("demonic") 
                   or name:find("angelic") or name:find("astral") or name:find("scifi") then
                    return obj
                end
            end
        end
    end
    return nil
end

-- DETEKSI RARITY EGG
local function getEggRarity(eggModel)
    if not eggModel then return "Rare", 300 end
    local fullText = eggModel:GetFullName():lower()
    for _, attr in pairs(eggModel:GetAttributes()) do
        fullText = fullText .. " " .. tostring(attr):lower()
    end
    for rarity, weight in pairs(RarityWeight) do
        if fullText:find(rarity:lower()) then
            return rarity, weight
        end
    end
    return "Rare", 300
end

-- FILTER ZONA AREA
local function isAreaMatched(eggObj, selectedArea)
    if selectedArea == "All (none)" or selectedArea == "All" or selectedArea == "" then
        return true
    end
    local fullPath = eggObj:GetFullName():lower():gsub("%s+", "")
    local target = selectedArea:lower():gsub("%s+", "")
    return fullPath:find(target) ~= nil
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
            Settings.SavedBaseCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "Base Saved", Content = "Titik aman tersimpan!", Duration = 3})
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Place to Pen",
    CurrentValue = false,
    Callback = function(v) Settings.AutoPlace = v end,
})

-- FILTER TAB[cite: 5]
FilterTab:CreateDropdown({
    Name = "Filter Area / Zone",
    Options = GameZones,
    CurrentOption = {"All (none)"},
    Callback = function(opt) Settings.SelectedArea = opt[1] end,
})

FilterTab:CreateSection("Filter Rarity (OFF Semua = Ambil Semua)")
local raritiesList = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare"}
for _, r in ipairs(raritiesList) do
    FilterTab:CreateToggle({
        Name = "Target " .. r,
        CurrentValue = false,
        Callback = function(v) Settings.Rarities[r] = v end,
    })
end

-- GYM TAB[cite: 3, 10]
GymTab:CreateToggle({
    Name = "Auto Treadmill (Otomatis Deteksi)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTreadmill = v end,
})

GymTab:CreateButton({
    Name = "Set Manual Treadmill (Opsi Cadangan)",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Settings.ManualTreadmillCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "Manual Position Saved", Content = "Posisi treadmill manual tersimpan!", Duration = 3})
        end
    end,
})

-- LOOP AUTO STEAL (ANTI-VOID & ANTI-KICK)
task.spawn(function()
    while task.wait(0.25) do
        if Settings.AutoSteal then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                local anyRarityActive = false
                for _, active in pairs(Settings.Rarities) do
                    if active then anyRarityActive = true break end
                end

                local targets = {}
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        local fullName = obj:GetFullName():lower()
                        if not fullName:find("wisp") and not fullName:find("machine") and not fullName:find("shop") then
                            if fullName:find("egg") or obj.ObjectText:lower():find("egg") or obj.ActionText:lower():find("steal") or obj.ActionText:lower():find("take") then
                                local eggModel = obj.Parent
                                local eggPart = eggModel:IsA("BasePart") and eggModel or eggModel:FindFirstChildWhichIsA("BasePart", true)
                                
                                if eggPart then
                                    local rName, rWeight = getEggRarity(eggModel)
                                    local areaOk = isAreaMatched(eggModel, Settings.SelectedArea)
                                    local rarityOk = not anyRarityActive or Settings.Rarities[rName]

                                    if areaOk and rarityOk then
                                        table.insert(targets, {prompt = obj, part = eggPart, weight = rWeight})
                                    end
                                end
                            end
                        end
                    end
                end

                table.sort(targets, function(a, b) return a.weight > b.weight end)

                if #targets > 0 then
                    local target = targets[1]
                    local returnCFrame = Settings.SavedBaseCFrame or hrp.CFrame

                    -- 1. Reset Kecepatan Fisika (Cegah Terlempar ke Langit)[cite: 9]
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero

                    -- 2. Teleport Tepat di Atas Telur
                    hrp.CFrame = target.part.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.12)

                    -- 3. Trigger ProximityPrompt
                    target.prompt.RequiresLineOfSight = false
                    target.prompt.MaxActivationDistance = 9999
                    fireproximityprompt(target.prompt)
                    task.wait(0.12)

                    -- 4. Kembalikan ke Base
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.CFrame = returnCFrame
                    task.wait(0.08)
                end
            end)
        end
    end
end)

-- LOOP AUTO TREADMILL[cite: 3, 10]
task.spawn(function()
    while task.wait(0.15) do
        if Settings.AutoTreadmill then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                local targetCFrame = nil
                if Settings.ManualTreadmillCFrame then
                    targetCFrame = Settings.ManualTreadmillCFrame
                else
                    local autoPart = getTreadmillPartAuto()
                    if autoPart then
                        targetCFrame = autoPart.CFrame + Vector3.new(0, 3, 0)
                    end
                end

                if targetCFrame then
                    hrp.CFrame = targetCFrame
                    hrp.AssemblyLinearVelocity = Vector3.zero
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
