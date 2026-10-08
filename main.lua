--// SYADZZ HUB - STEAL AN EGG (PERFECT SLOW STEAL & PRESERVED TREADMILL)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("SyadzzMasterHub") then
        CoreGui.SyadzzMasterHub:Destroy()
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Slow & Safe Steal]",
    LoadingTitle = "Memuat Hub...",
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

--------------------------------------------------------------------
-- DETEKSI TREADMILL (100% SAMA, TIDAK DIUBAH APAPUN)
--------------------------------------------------------------------
local function getExactTreadmillBelt()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position

    local targetModel = nil
    local minDistance = 250

    for _, gui in pairs(Workspace:GetDescendants()) do
        if gui:IsA("TextLabel") then
            local txt = gui.Text:lower()
            if txt:find("langkah") or txt:find("step") or txt:find("jual") then
                local model = gui:FindFirstAncestorWhichIsA("Model")
                if model then
                    local dist = (model:GetPivot().Position - myPos).Magnitude
                    if dist < minDistance then
                        minDistance = dist
                        targetModel = model
                    end
                end
            end
        end
    end

    if targetModel then
        local lowestPart = nil
        local lowestY = math.huge

        for _, part in pairs(targetModel:GetDescendants()) do
            if part:IsA("BasePart") then
                local pName = part.Name:lower()
                if not pName:find("sign") and not pName:find("text") and not pName:find("board") and not pName:find("gui") then
                    if part.Position.Y < lowestY then
                        lowestY = part.Position.Y
                        lowestPart = part
                    end
                end
            end
        end

        if lowestPart then
            return lowestPart.CFrame + Vector3.new(0, 2.5, 0)
        end
        return targetModel:GetPivot() + Vector3.new(0, 2, 0)
    end

    return nil
end

--------------------------------------------------------------------
-- DETEKSI RARITY & AREA
--------------------------------------------------------------------
local function getEggRarityData(eggModel)
    if not eggModel then return "Rare", 300 end
    
    local fullText = eggModel.Name:lower() .. " " .. eggModel:GetFullName():lower()
    
    for _, d in pairs(eggModel:GetDescendants()) do
        fullText = fullText .. " " .. d.Name:lower()
        if d:IsA("ValueBase") then
            fullText = fullText .. " " .. tostring(d.Value):lower()
        elseif d:IsA("TextLabel") then
            fullText = fullText .. " " .. d.Text:lower()
        end
    end
    for attrName, attrVal in pairs(eggModel:GetAttributes()) do
        fullText = fullText .. " " .. attrName:lower() .. " " .. tostring(attrVal):lower()
    end

    if fullText:find("divine") or fullText:find("ilahi") or fullText:find("ilah") or fullText:find("malaikat") or fullText:find("angelic") then
        return "Divine", 1000
    elseif fullText:find("eternal") or fullText:find("abadi") or fullText:find("iblis") or fullText:find("demonic") then
        return "Eternal", 900
    elseif fullText:find("secret") or fullText:find("rahasia") or fullText:find("%?%?%?") or fullText:find("hacker") then
        return "Secret", 800
    elseif fullText:find("cosmic") or fullText:find("kosmik") or fullText:find("lucky") then
        return "Cosmic", 700
    elseif fullText:find("mythic") or fullText:find("mitos") or fullText:find("freeze") then
        return "Mythic", 600
    elseif fullText:find("legendary") or fullText:find("legendaris") or fullText:find("golden") then
        return "Legendary", 500
    elseif fullText:find("epic") or fullText:find("epik") or fullText:find("celebrity") then
        return "Epic", 400
    elseif fullText:find("rare") or fullText:find("langka") or fullText:find("flame") then
        return "Rare", 300
    end

    return "Rare", 300
end

local function isZoneMatched(eggObj, selectedArea)
    if selectedArea == "All (none)" or selectedArea == "All" or selectedArea == "" then
        return true
    end
    
    local fullPath = eggObj:GetFullName():lower()
    local cleanTarget = selectedArea:lower()
    
    if cleanTarget:find("abyss") then cleanTarget = "abyss" end
    if cleanTarget:find("cherry") then cleanTarget = "cherry" end
    if cleanTarget:find("titan") then cleanTarget = "titan" end
    if cleanTarget:find("enchanted") then cleanTarget = "enchanted" end
    if cleanTarget:find("prehistoric") then cleanTarget = "prehistoric" end

    return fullPath:find(cleanTarget) ~= nil
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
            if hrp.Position.Y > -5 and hrp.Position.Y < 50 then
                Settings.SavedBaseCFrame = hrp.CFrame
                Rayfield:Notify({Title = "Base Safe Zone Saved", Content = "Titik base terkunci aman di daratan!", Duration = 3})
            else
                Rayfield:Notify({Title = "Peringatan", Content = "Berdirilah di daratan base terlebih dahulu!", Duration = 3})
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
    Name = "Auto Treadmill (Presisi Karpet Treadmill)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTreadmill = v end,
})

--------------------------------------------------------------------
-- LOOP AUTO TREADMILL (TIDAK DIUBAH SAMA SEKALI)
--------------------------------------------------------------------
local cachedTreadmillCFrame = nil
task.spawn(function()
    while task.wait(0.15) do
        if Settings.AutoTreadmill then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                if not cachedTreadmillCFrame then
                    cachedTreadmillCFrame = getExactTreadmillBelt()
                end

                if cachedTreadmillCFrame then
                    hrp.CFrame = cachedTreadmillCFrame
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end)
        else
            cachedTreadmillCFrame = nil
        end
    end
end)

--------------------------------------------------------------------
-- LOOP AUTO STEAL FIX (SANTAY + ANTI-LANGIT KETAT)
--------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if Settings.AutoSteal then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                -- Pastikan koordinat baliq HANYA di daratan base yang valid (Y antara -5 sampai 50)
                local safeReturn = Settings.SavedBaseCFrame
                if not safeReturn or safeReturn.Position.Y > 50 or safeReturn.Position.Y < -5 then
                    if hrp.Position.Y > -5 and hrp.Position.Y < 50 then
                        Settings.SavedBaseCFrame = hrp.CFrame
                        safeReturn = hrp.CFrame
                    end
                end

                if not safeReturn then return end

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

                                -- Abaikan telur jika berada di posisi glitch langit (Y > 150)
                                if eggPart and eggPart.Position.Y < 150 then
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

                table.sort(targets, function(a, b)
                    return a.weight > b.weight
                end)

                if #targets > 0 then
                    local target = targets[1]

                    -- Reset fisika sebelum pindah
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero

                    -- Teleport ke Telur
                    hrp.CFrame = target.part.CFrame * CFrame.new(0, 3, 0)
                    
                    -- Santay: Beri jeda 0.4 detik agar server mendaftarkan posisi karakter terlebih dahulu
                    task.wait(0.4)

                    -- Ambil Telur
                    target.prompt.RequiresLineOfSight = false
                    target.prompt.MaxActivationDistance = 9999
                    fireproximityprompt(target.prompt)
                    
                    -- Jeda setelah ambil
                    task.wait(0.35)

                    -- Reset fisika & Teleport Balik ke Base Daratan Aman
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    hrp.CFrame = safeReturn
                    
                    task.wait(0.2)
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
    Content = "Auto Steal santai & anti-langit dimuat!",
    Duration = 4,
})
