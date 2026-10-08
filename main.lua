-- ==================================================
-- 🔥 LURUS KE DEPAN KE AREA TELUR — BUKAN KE ATAS!
-- ⚠️ TREADMILL TIDAK DIUBAH SEKALI PUN ⚠️
-- ==================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("SyadzzHub") then
        CoreGui:FindFirstChild("SyadzzHub"):Destroy()
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚",
    LoadingTitle = "LURUS KE DEPAN — TIDAK KE LANGIT",
    LoadingSubtitle = "Zona Aman ↔ Area Telur",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Settings = {
    AutoSteal = false,
    AutoPlace = false,
    AutoTreadmill = false,
    SavedBaseCFrame = nil, -- Zona Aman
    SavedTreadmillCFrame = nil,
    -- Posisi lurus ke depan, datar di tanah
    MaxEggHeight = 50,
    MinEggHeight = -5,
    StandOffset = 1.8, -- Pas di samping telur
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

--------------------------------------------------------------------
-- ⚠️ TREADMILL — TIDAK DIUBAH SEKALI PUN ⚠️
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

    if not targetModel then return nil end
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
    if not lowestPart then return targetModel:GetPivot() + Vector3.new(0, 2.5, 0) end
    return lowestPart.CFrame + Vector3.new(0, 2.5, 0)
end

--------------------------------------------------------------------
-- DETEKSI RARITY
--------------------------------------------------------------------
local function getEggRarityData(eggModel)
    if not eggModel then return "Rare", 300 end
    local fullText = eggModel.Name:lower() .. " " .. eggModel:GetFullName():lower()
    for _, d in pairs(eggModel:GetDescendants()) do
        if d:IsA("BasePart") then
            fullText = fullText .. " " .. d.Name:lower()
        end
    end
    if fullText:find("divine") then return "Divine", 1000 end
    if fullText:find("eternal") then return "Eternal", 900 end
    if fullText:find("secret") then return "Secret", 800 end
    if fullText:find("cosmic") then return "Cosmic", 700 end
    if fullText:find("mythic") then return "Mythic", 600 end
    if fullText:find("legendary") then return "Legendary", 500 end
    if fullText:find("epic") then return "Epic", 400 end
    if fullText:find("rare") then return "Rare", 300 end
    return "Rare", 300
end

--------------------------------------------------------------------
-- TABS
--------------------------------------------------------------------
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local FilterTab = Window:CreateTab("Filters & Priority", 4483362458)
local GymTab = Window:CreateTab("Gym", 4483362458)

FarmTab:CreateToggle({
    Name = "Auto Steal Egg",
    CurrentValue = false,
    Callback = function(v)
        Settings.AutoSteal = v
        if v then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            -- Simpan ZONA AMAN saat nyalakan
            Settings.SavedBaseCFrame = char.HumanoidRootPart.CFrame
            Rayfield:Notify({
                Title = "✅ Zona Aman Disimpan",
                Content = "Lurus ke depan cari telur...",
                Duration = 2.5
            })
        end
    end
})

FarmTab:CreateToggle({
    Name = "Auto Place to Pen",
    CurrentValue = false,
    Callback = function(v) Settings.AutoPlace = v end
})

FilterTab:CreateSection("Prioritas — Divine > Eternal > dst")
for _, r in ipairs({"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare"}) do
    FilterTab:CreateToggle({
        Name = "Target: " .. r,
        CurrentValue = false,
        Callback = function(v) Settings.Rarities[r] = v end
    })
end

GymTab:CreateToggle({
    Name = "Auto Treadmill",
    CurrentValue = false,
    Callback = function(v)
        Settings.AutoTreadmill = v
        if not v then Settings.SavedTreadmillCFrame = nil end
    end
})

--------------------------------------------------------------------
-- LOOP TREADMILL — TETAP UTUH
--------------------------------------------------------------------
local cachedTreadmillCFrame = nil
task.spawn(function()
    while task.wait(0.15) do
        if not Settings.AutoTreadmill then
            cachedTreadmillCFrame = nil
            continue
        end
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local hrp = char.HumanoidRootPart
        if not cachedTreadmillCFrame then
            cachedTreadmillCFrame = getExactTreadmillBelt()
            if cachedTreadmillCFrame then
                Settings.SavedTreadmillCFrame = cachedTreadmillCFrame
                Rayfield:Notify({Title = "✅ Treadmill Siap", Content = "Balik ke sini setelah selesai", Duration = 2.5})
            end
        end
        if cachedTreadmillCFrame and not Settings.AutoSteal then
            hrp.CFrame = cachedTreadmillCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

--------------------------------------------------------------------
-- 🔥 BAGIAN UTAMA — LURUS KE DEPAN, DATAR DI TANAH
--------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.8) do
        if not Settings.AutoSteal then
            task.wait(0.2)
            continue
        end
        if not Settings.SavedBaseCFrame then
            Rayfield:Notify({Title = "⚠️ Ulangi", Content = "Nyalakan ulang di Zona Aman!", Duration = 3})
            task.wait(1)
            continue
        end

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local hrp = char.HumanoidRootPart

        -- BALIK KE: Treadmill kalau aktif, kalau tidak ke Zona Aman
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

        -- 🔍 CARI TELUR — lurus ke depan, di tanah
        local validEggs = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local fullTxt = (obj.Name .. " " .. obj.ActionText .. " " .. obj.ObjectText):lower()

                -- Harus berhubungan telur
                if not (fullTxt:find("egg") or fullTxt:find("telur") or fullTxt:find("steal") or fullTxt:find("take")) then
                    continue
                end
                -- Bukan bangunan/lainnya
                if fullTxt:find("wisp") or fullTxt:find("machine") or fullTxt:find("shop") or fullTxt:find("quest") then
                    continue
                end

                -- Cari bagian fisik telur
                local eggPart = obj.Parent
                if not eggPart then continue end
                if not eggPart:IsA("BasePart") then
                    eggPart = eggPart:FindFirstChildWhichIsA("BasePart")
                end
                if not eggPart then continue end

                -- ✅ DATAR DI TANAH — bukan ke atas!
                local y = eggPart.Position.Y
                if y >= Settings.MaxEggHeight or y <= Settings.MinEggHeight then
                    continue
                end

                -- Cek rarity
                local rName, rWeight = getEggRarityData(obj.Parent)
                if anySelected and not activeRarities[rName] then
                    continue
                end

                table.insert(validEggs, {
                    prompt = obj,
                    part = eggPart,
                    rarity = rName,
                    weight = rWeight
                })
            end
        end

        -- Urut dari tertinggi
        table.sort(validEggs, function(a, b) return a.weight > b.weight end)

        if #validEggs == 0 then
            Rayfield:Notify({
                Title = "🔍 Mencari...",
                Content = anySelected and "Menunggu "..next(activeRarities).." muncul" or "Lurus ke depan cari telur",
                Duration = 1.5
            })
            continue
        end

        local target = validEggs[1]
        local tPos = target.part.Position

        Rayfield:Notify({
            Title = "🥚 "..target.rarity,
            Content = "Lurus ke depan ke telur...",
            Duration = 2
        })

        -- ✅ LURUS KE DEPAN, DI TANAH — TIDAK KE LANGIT!
        -- Posisi di samping telur, ketinggian pas
        local posAkhir = Vector3.new(tPos.X, tPos.Y + Settings.StandOffset, tPos.Z)
        hrp.CFrame = CFrame.new(posAkhir, tPos) -- Hadap ke telur
        task.wait(0.5) -- Tunggu sampai sampai!

        -- ✅ AMBIL TELUR
        target.prompt.MaxActivationDistance = 20
        target.prompt.RequiresLineOfSight = false
        task.wait(0.3)
        fireproximityprompt(target.prompt)

        Rayfield:Notify({
            Title = "✅ DIAMBIL!",
            Content = "Balik ke Zona Aman...",
            Duration = 1.5
        })
        task.wait(0.5)

        -- ✅ BALIK KE ZONA AMAN / TREADMILL
        hrp.CFrame = returnPoint
        hrp.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.4)
    end
end)

Rayfield:Notify({
    Title = "✅ SIAP!",
    Content = "Lurus ke depan → ambil → balik Zona Aman!",
    Duration = 4
})
