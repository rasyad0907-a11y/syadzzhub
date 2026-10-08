-- ==================================================
-- SYADZZ HUB | BENAR-BENAR AMBIL TELUR & BALIK
-- ⚠️ AUTO TREADMILL TIDAK DIUBAH SAMA SEKALI ⚠️
-- ==================================================

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
    Name = "SYADZZ HUB | Steal an Egg 🥚",
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
    SavedTreadmillCFrame = nil,
    MaxEggHeight = 100,
    MinEggHeight = -10,
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
    ["Divine"]    = 1000,
    ["Eternal"]   = 900,
    ["Secret"]    = 800,
    ["Cosmic"]    = 700,
    ["Mythic"]    = 600,
    ["Legendary"] = 500,
    ["Epic"]      = 400,
    ["Rare"]      = 300
}

local GameZones = {
    "All (none)", "Forest", "Lake", "Desert", "Jungle", "Snow",
    "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom",
    "Titan Temple", "Enchanted Forest"
}

--------------------------------------------------------------------
-- ⚠️ AUTO TREADMILL — TIDAK DIUBAH SEKALI PUN ⚠️
--------------------------------------------------------------------
local function getExactTreadmillBelt()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local targetModel = nil
    local minDistance = 80

    for _, gui in pairs(Workspace:GetDescendants()) do
        if gui:IsA("TextLabel") then
            local txt = gui.Text:lower()
            if txt:find("langkah") or txt:find("step") or txt:find("jual") or txt:find("treadmill") then
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
-- DETEKSI RARITY
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

    if fullText:find("divine") or fullText:find("ilahi") then
        return "Divine", 1000
    elseif fullText:find("eternal") or fullText:find("abadi") then
        return "Eternal", 900
    elseif fullText:find("secret") or fullText:find("rahasia") then
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

--------------------------------------------------------------------
-- TABS
--------------------------------------------------------------------
local FarmTab    = Window:CreateTab("Auto Farm", 4483362458)
local FilterTab  = Window:CreateTab("Filters & Priority", 4483362458)
local GymTab     = Window:CreateTab("Gym", 4483362458)

FarmTab:CreateToggle({
    Name = "Auto Steal Egg",
    CurrentValue = false,
    Callback = function(v)
        Settings.AutoSteal = v
        if v then
            local char = LocalPlayer.Character
            if not char then
                Rayfield:Notify({Title = "⚠️ Tunggu", Content = "Karakter belum siap!", Duration = 3})
                Settings.AutoSteal = false
                return
            end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                Settings.SavedBaseCFrame = hrp.CFrame
                Rayfield:Notify({Title = "✅ Siap!", Content = "Mencari & mengambil telur...", Duration = 2.5})
            end
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Place to Pen",
    CurrentValue = false,
    Callback = function(v) Settings.AutoPlace = v end,
})

FilterTab:CreateDropdown({
    Name = "Filter Area / Zone",
    Options = GameZones,
    CurrentOption = {"All (none)"},
    Callback = function(opt) Settings.SelectedArea = opt[1] end,
})

FilterTab:CreateSection("Prioritas — Divine > Eternal > dst")
local raritiesList = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare"}
for _, r in ipairs(raritiesList) do
    FilterTab:CreateToggle({
        Name = "Target: " .. r,
        CurrentValue = false,
        Callback = function(v) Settings.Rarities[r] = v end,
    })
end

GymTab:CreateToggle({
    Name = "Auto Treadmill",
    CurrentValue = false,
    Callback = function(v)
        Settings.AutoTreadmill = v
        if not v then Settings.SavedTreadmillCFrame = nil end
    end,
})

--------------------------------------------------------------------
-- LOOP AUTO TREADMILL — TETAP SAMA PERSIS
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
                    if cachedTreadmillCFrame then
                        Settings.SavedTreadmillCFrame = cachedTreadmillCFrame
                        Rayfield:Notify({Title = "✅ Treadmill", Content = "Siap — balik ke sini setelah ambil!", Duration = 2.5})
                    end
                end
                if cachedTreadmillCFrame and not Settings.AutoSteal then
                    hrp.CFrame = cachedTreadmillCFrame
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end)
        else
            cachedTreadmillCFrame = nil
            Settings.SavedTreadmillCFrame = nil
        end
    end
end)

--------------------------------------------------------------------
-- LOOP AUTO STEAL — DIPERBAIKI: PINDAH → AMBIL → BALIK
--------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.8) do
        if not Settings.AutoSteal then
            task.wait(0.2)
            continue
        end
        if not Settings.SavedBaseCFrame then
            Rayfield:Notify({Title = "⚠️ Ulangi", Content = "Nyalakan ulang Auto Steal!", Duration = 3})
            task.wait(1)
            continue
        end

        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- Tempat BALIK: Treadmill kalau aktif, kalau tidak ke base
            local returnPoint = Settings.SavedBaseCFrame
            if Settings.AutoTreadmill and Settings.SavedTreadmillCFrame then
                returnPoint = Settings.SavedTreadmillCFrame
            end

            -- Pilih rarity
            local activeRarities = {}
            local anySelected = false
            for rName, enabled in pairs(Settings.Rarities) do
                if enabled then
                    activeRarities[rName] = true
                    anySelected = true
                end
            end

            -- 🔍 CARI TELUR
            local validEggs = {}
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    local actText = obj.ActionText:lower()
                    local objText = obj.ObjectText:lower()
                    local fullTxt = (obj.Name .. " " .. actText .. " " .. objText):lower()

                    -- BUKAN telur = lewati
                    if not (fullTxt:find("egg") or fullTxt:find("telur") or fullTxt:find("steal") or fullTxt:find("take")) then
                        continue
                    end
                    if fullTxt:find("wisp") or fullTxt:find("machine") or fullTxt:find("shop") or fullTxt:find("quest") then
                        continue
                    end

                    -- Cari bagian fisik telur
                    local eggPart = obj.Parent:IsA("BasePart") and obj.Parent
                        or obj.Parent:FindFirstChildWhichIsA("BasePart", true)
                    if not eggPart then continue end

                    -- Tidak ke langit/dasar
                    local y = eggPart.Position.Y
                    if y >= Settings.MaxEggHeight or y <= Settings.MinEggHeight then
                        continue
                    end

                    local rName, rWeight = getEggRarityData(obj.Parent)
                    local zoneOk = isZoneMatched(obj.Parent, Settings.SelectedArea)
                    local rarityOk = not anySelected or activeRarities[rName]

                    if zoneOk and rarityOk then
                        table.insert(validEggs, {
                            prompt = obj,
                            part = eggPart,
                            rarity = rName,
                            weight = rWeight
                        })
                    end
                end
            end

            table.sort(validEggs, function(a, b) return a.weight > b.weight end)

            if #validEggs == 0 then
                Rayfield:Notify({Title = "🔍 Mencari...", Content = anySelected and "Menunggu "..next(activeRarities) or "Semua telur", Duration = 1.5})
                return
            end

            local target = validEggs[1]

            -- ✅ LANGKAH 1: PERGI KE TELUR — DEKAT BANGET
            Rayfield:Notify({Title = "🥚 "..target.rarity, Content = "Pergi ke telur...", Duration = 2})

            hrp.CFrame = CFrame.new(target.part.Position + Vector3.new(0, 1.5, 0))
            task.wait(0.5) -- Tunggu sampai sampai!

            -- ✅ LANGKAH 2: PASTIKAN JARAK CUKUP LALU AMBIL
            target.prompt.MaxActivationDistance = 25
            target.prompt.RequiresLineOfSight = false
            task.wait(0.3)

            fireproximityprompt(target.prompt)

            Rayfield:Notify({Title = "✅ DIAMBIL!", Content = target.rarity, Duration = 2})
            task.wait(0.6) -- Tunggu sampai diambil!

            -- ✅ LANGKAH 3: BALIK KE TREADMILL / BASE
            Rayfield:Notify({Title = "🔙 Kembali", Content = "Kembali ke posisi aman...", Duration = 1.5})

            hrp.CFrame = returnPoint
            hrp.AssemblyLinearVelocity = Vector3.zero
            task.wait(0.4)

        end)
    end
end)

--------------------------------------------------------------------
-- AUTO PLACE
--------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.5) do
        if not Settings.AutoPlace then
            task.wait(0.2)
            continue
        end
        pcall(function()
            local char = LocalPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if not tool or not tool.Name:lower():find("egg") then return end
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    local txt = (obj.ActionText .. " " .. obj.ObjectText):lower()
                    if txt:find("place") or txt:find("taruh") or txt:find("pen") or txt:find("nest") then
                        fireproximityprompt(obj)
                        task.wait(0.7)
                        break
                    end
                end
            end
        end)
    end
end)

Rayfield:Notify({
    Title = "✅ SIAP BERJALAN!",
    Content = "Pergi→Ambil→Balik ke Treadmill | Treadmill TIDAK diubah!",
    Duration = 4
})
