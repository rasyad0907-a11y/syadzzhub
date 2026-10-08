-- ==================================================
-- 🔥 DIPERBAIKI TOTAL — PASTI TELEPORT & AUTO STEAL FAST!
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
    MaxEggHeight = 200,
    MinEggHeight = -50,
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
        if d:IsA("BasePart") or d:IsA("StringValue") then
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
                Rayfield:Notify({Title = "✅ Siap!", Content = "Base disimpan. Mencari telur...", Duration = 2.5})
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
-- 🔥 LOGIKA AUTO STEAL DIPERBAIKI TOTAL
--------------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.3)
        if not Settings.AutoSteal then continue end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not hrp or not hum or hum.Health <= 0 then continue end

        if not Settings.SavedBaseCFrame then
            Settings.SavedBaseCFrame = hrp.CFrame
        end

        local returnPoint = Settings.SavedBaseCFrame
        if Settings.AutoTreadmill and Settings.SavedTreadmillCFrame then
            returnPoint = Settings.SavedTreadmillCFrame
        end

        local activeRarities = {}
        local anySelected = false
        for rName, enabled in pairs(Settings.Rarities) do
            if enabled then
                activeRarities[rName] = true
                anySelected = true
            end
        end

        -- Cari ProximityPrompt telur
        local validEggs = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local parent = obj.Parent
                if not parent then continue end

                local fullTxt = (obj.Name .. " " .. obj.ActionText .. " " .. obj.ObjectText .. " " .. parent.Name .. " " .. parent:GetFullName()):lower()

                -- Abaikan yang bukan telur
                if fullTxt:find("wisp") or fullTxt:find("machine") or fullTxt:find("shop") or fullTxt:find("quest") or fullTxt:find("treadmill") then
                    continue
                end

                -- Pastikan ada kata kunci pencurian / telur
                local isEgg = fullTxt:find("egg") or fullTxt:find("telur") or fullTxt:find("steal") or fullTxt:find("take") or fullTxt:find("grab") or fullTxt:find("collect")

                if isEgg then
                    local eggPart = parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart", true)
                    if eggPart then
                        local yPos = eggPart.Position.Y
                        if yPos <= Settings.MaxEggHeight and yPos >= Settings.MinEggHeight then
                            local rName, rWeight = getEggRarityData(parent)
                            
                            -- Kalau ada filter terpasang, cek apa tercentang
                            if not anySelected or activeRarities[rName] then
                                table.insert(validEggs, {
                                    prompt = obj,
                                    part = eggPart,
                                    rarity = rName,
                                    weight = rWeight
                                })
                            end
                        end
                    end
                end
            end
        end

        -- Urutkan berdasarkan Rarity tertinggi
        table.sort(validEggs, function(a, b) return a.weight > b.weight end)

        if #validEggs > 0 then
            local target = validEggs[1]
            local tPos = target.part.Position

            Rayfield:Notify({
                Title = "🥚 Target Ketemu!",
                Content = "Rarity: " .. target.rarity,
                Duration = 1.5
            })

            -- Teleport langsung ke posisi telur
            hrp.CFrame = CFrame.new(tPos + Vector3.new(0, 2, 0))
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            task.wait(0.2)

            -- Bypass ProximityPrompt & Trigger
            target.prompt.HoldDuration = 0
            target.prompt.MaxActivationDistance = 50
            target.prompt.RequiresLineOfSight = false
            
            pcall(function()
                fireproximityprompt(target.prompt)
            end)

            task.wait(0.3)

            -- Kembalikan karakter ke posisi asal
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = returnPoint
                char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            end

            task.wait(0.5)
        end
    end
end)

Rayfield:Notify({
    Title = "✅ SIAP TOTAL!",
    Content = "Auto Steal sudah diperbaiki total!",
    Duration = 5
})
