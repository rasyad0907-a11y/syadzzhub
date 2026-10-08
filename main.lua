-- ==================================================
-- 🔥 DIPERBAIKI TOTAL — PASTI TELEPORT!
-- ⚠️ TREADMILL TIDAK DIUBAH SEKALI PUN ⚠️
-- ==================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("SyadzzMasterHub") then
        CoreGui.SyadzzMasterHub:Destroy()
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚",
    LoadingTitle = "DIPERBAIKI TOTAL",
    LoadingSubtitle = "Pasti pindah sekarang!",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Settings = {
    AutoSteal = false,
    AutoTreadmill = false,
    SavedBaseCFrame = nil,
    SavedTreadmillCFrame = nil,
    MaxEggHeight = 60,
    MinEggHeight = -5,
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
            if not char then
                Rayfield:Notify({Title = "⚠️ Tunggu", Content = "Karakter belum siap!", Duration = 3})
                Settings.AutoSteal = false
                return
            end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                Settings.SavedBaseCFrame = hrp.CFrame
                Rayfield:Notify({Title = "✅ Siap!", Content = "Mencari telur & pindah sekarang!", Duration = 2.5})
            end
        end
    end
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
                Rayfield:Notify({Title = "✅ Treadmill", Content = "Siap — balik ke sini!", Duration = 2.5})
            end
        end
        if cachedTreadmillCFrame and not Settings.AutoSteal then
            hrp.CFrame = cachedTreadmillCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

--------------------------------------------------------------------
-- 🔥 INI DIPERBAIKI TOTAL — PASTI PINDAH!
--------------------------------------------------------------------
task.spawn(function()
    while task.wait(1.0) do
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
        if not char then
            Rayfield:Notify({Title = "⚠️ Karakter Hilang", Content = "Tunggu sebentar lalu coba lagi", Duration = 2})
            continue
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            Rayfield:Notify({Title = "⚠️ HRP Tidak Ada", Content = "Coba nyalakan lagi", Duration = 2})
            continue
        end

        -- Titik pulang
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

        -- 🔍 CARI TELUR — DIPERLUAS
        local validEggs = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local n = obj.Name:lower()
                local a = obj.ActionText:lower()
                local o = obj.ObjectText:lower()
                local fullTxt = n .. " " .. a .. " " .. o

                -- Cari telur — lebih banyak kata kunci
                if not (fullTxt:find("egg") or fullTxt:find("telur") or fullTxt:find("steal") or fullTxt:find("take") or fullTxt:find("collect")) then
                    continue
                end
                -- Bukan lain-lain
                if fullTxt:find("wisp") or fullTxt:find("machine") or fullTxt:find("shop") or fullTxt:find("quest") then
                    continue
                end

                -- Cari bagian fisik
                local eggPart = obj.Parent
                if not eggPart then continue end
                if not eggPart:IsA("BasePart") then
                    local found = eggPart:FindFirstChildWhichIsA("BasePart", true)
                    eggPart = found
                end
                if not eggPart then continue end

                -- Batas ketinggian
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

        -- Urut
        table.sort(validEggs, function(a, b) return a.weight > b.weight end)

        if #validEggs == 0 then
            Rayfield:Notify({
                Title = "🔍 Tidak Ketemu Telur",
                Content = "Mencari... coba lihat ada telur gak?",
                Duration = 2
            })
            continue
        end

        local target = validEggs[1]
        local tPos = target.part.Position

        Rayfield:Notify({
            Title = "🥚 KETEMU: "..target.rarity,
            Content = "Pindah ke: "..math.floor(tPos.X)..","..math.floor(tPos.Y)..","..math.floor(tPos.Z),
            Duration = 3
        })

        -- ==================================================
        -- 🔥 TELEPORT PASTI JALAN — DIPERBAIKI
        -- ==================================================
        local tujuan = Vector3.new(tPos.X, tPos.Y + 1.5, tPos.Z)

        -- Langsung pindah — tanpa syarat rumit
        hrp.CFrame = CFrame.new(tujuan)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        Rayfield:Notify({Title = "🏃 Sudah Pindah!", Content = "Tunggu ambil...", Duration = 1.5})
        task.wait(0.6)

        -- Ambil telur
        target.prompt.MaxActivationDistance = 25
        target.prompt.RequiresLineOfSight = false
        task.wait(0.3)
        fireproximityprompt(target.prompt)

        Rayfield:Notify({Title = "✅ DIAMBIL!", Content = "Balik ke Zona Aman...", Duration = 2})
        task.wait(0.5)

        -- Balik
        hrp.CFrame = returnPoint
        hrp.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.5)
    end
end)

Rayfield:Notify({
    Title = "✅ SIAP TOTAL!",
    Content = "Kalau tetap tidak pindah, berarti TIDAK KETEMU telurnya — lihat notifikasi!",
    Duration = 5
})
