--// SYADZZ HUB - STEAL AN EGG (PERFECT TREADMILL & FILTER FIX)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("SyadzzUltraFixScript") then
        CoreGui.SyadzzUltraFixScript:Destroy()
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Fix Final]",
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

-- PRIORITAS KELANGKAAN (Divine > Eternal > Secret > Cosmic > Mythic > Legendary > Epic > Rare)
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

-- MENCARI SAFE ZONE BASE
local function getSafeBaseCFrame()
    if Settings.SavedBaseCFrame and Settings.SavedBaseCFrame.Position.Y > -10 then
        return Settings.SavedBaseCFrame
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if hrp.Position.Y > -10 then
            return hrp.CFrame
        end
    end
    return CFrame.new(0, 10, 0)
end

-- DETEKSI ATAS TREADMILL PRESISI (MENCARI TEKS LANGKAH / TRACK)
local function getExactTreadmillPart()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position

    -- Cari berdasarkan Teks "langkah" atau "step"
    for _, gui in pairs(Workspace:GetDescendants()) do
        if gui:IsA("TextLabel") or gui:IsA("TextButton") then
            local txt = gui.Text:lower()
            if txt:find("langkah") or txt:find("step") then
                local part = gui:FindFirstAncestorWhichIsA("BasePart") or (gui.Parent and gui.Parent:IsA("BasePart") and gui.Parent)
                if part and (part.Position - myPos).Magnitude < 250 then
                    return part
                end
            end
        end
    end

    -- Cari berdasarkan nama part fisik Treadmill (bukan papan Sign)
    local bestPart = nil
    local minDistance = 250
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            local parentName = obj.Parent and obj.Parent.Name:lower() or ""
            if not name:find("sign") and not name:find("board") and not name:find("tingkat") and not parentName:find("sign") then
                if name:find("tread") or name:find("pad") or name:find("track") or parentName:find("treadmill") or name:find("demonic") or name:find("flame") or name:find("astral") or name:find("freeze") then
                    local dist = (obj.Position - myPos).Magnitude
                    if dist < minDistance then
                        minDistance = dist
                        bestPart = obj
                    end
                end
            end
        end
    end
    return bestPart
end

-- DETEKSI RARITY DEEP SCAN (INGGRIS & INDONESIA)
local function getEggRarityData(eggModel)
    if not eggModel then return "Rare", 300 end
    
    local fullText = eggModel:GetFullName():lower()
    for _, descendant in pairs(eggModel:GetDescendants()) do
        fullText = fullText .. " " .. descendant.Name:lower()
        if descendant:IsA("ValueBase") then
            fullText = fullText .. " " .. tostring(descendant.Value):lower()
        elseif descendant:IsA("TextLabel") then
            fullText = fullText .. " " .. descendant.Text:lower()
        end
    end
    for attrName, attrVal in pairs(eggModel:GetAttributes()) do
        fullText = fullText .. " " .. attrName:lower() .. " " .. tostring(attrVal):lower()
    end

    if fullText:find("divine") or fullText:find("ilahi") or fullText:find("malaikat") then
        return "Divine", 1000
    elseif fullText:find("eternal") or fullText:find("abadi") or fullText:find("iblis") then
        return "Eternal", 900
    elseif fullText:find("secret") or fullText:find("rahasia") or fullText:find("???") then
        return "Secret", 800
    elseif fullText:find("cosmic") or fullText:find("kosmik") then
        return "Cosmic", 700
    elseif fullText:find("mythic") or fullText:find("mitos") then
        return "Mythic", 600
    elseif fullText:find("legendary") or fullText:find("legendaris") then
        return "Legendary", 500
    elseif fullText:find("epic") or fullText:find("epik") then
        return "Epic", 400
    elseif fullText:find("rare") or fullText:find("langka") then
        return "Rare", 300
    end

    return "Rare", 300
end

-- MATCH ZONA AREA
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
                Rayfield:Notify({Title = "Base Safe Zone Saved", Content = "Titik aman terkunci!", Duration = 3})
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
    Name = "Auto Treadmill (Presisi Atas Mesin)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTreadmill = v end,
})

-- LOOP AUTO TREADMILL PRESISI
local cachedTreadmillPart = nil
task.spawn(function()
    while task.wait(0.15) do
        if Settings.AutoTreadmill then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                if not cachedTreadmillPart or not cachedTreadmillPart:IsDescendantOf(Workspace) then
                    cachedTreadmillPart = getExactTreadmillPart()
                end

                if cachedTreadmillPart then
                    -- Berdiri tepat di atas lintasan treadmill
                    hrp.CFrame = cachedTreadmillPart.CFrame + Vector3.new(0, 3.5, 0)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end)
        else
            cachedTreadmillPart = nil
        end
    end
end)

-- LOOP AUTO STEAL (DELAY DISESUAIKAN & PRIORITAS KERAS)
task.spawn(function()
    while task.wait(0.3) do
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
                                    
                                    local isAreaOk = isZoneMatched(eggModel, Settings.SelectedArea)
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

                -- URUTKAN BERDASARKAN RARITY TERTINGGI
                table.sort(targets, function(a, b)
                    return a.weight > b.weight
                end)

                if #targets > 0 then
                    local target = targets[1]

                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero

                    -- Teleport ke telur
                    hrp.CFrame = target.part.CFrame * CFrame.new(0, 2.5, 0)
                    task.wait(0.18) -- Delay disesuaikan agar tidak terlalu cepat

                    -- Ambil telur berulang agar pasti masuk inventaris
                    target.prompt.RequiresLineOfSight = false
                    target.prompt.MaxActivationDistance = 9999
                    fireproximityprompt(target.prompt)
                    task.wait(0.08)
                    fireproximityprompt(target.prompt)
                    task.wait(0.15)

                    -- Kembali ke base aman
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    hrp.CFrame = safeReturn
                    task.wait(0.1)
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
    Content = "Pembaruan Treadmill & Filter Berhasil Dimuat!",
    Duration = 4,
})
