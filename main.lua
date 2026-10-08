--// SYADZZ HUB | TERINSPIRASI NASI RENDANG HUB
-- Auto Treadmill TETAP UTUH TIDAK DIUBAH
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
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
    LoadingSubtitle = "by Syadholicc | Nasi Rendang Style",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Settings = {
    AutoSteal = false,
    StealFromPlayers = false,
    Godmode = false,
    FlyMode = false,
    AutoPlace = false,
    AutoTreadmill = false,
    SelectedArea = "All (none)",
    SavedBaseCFrame = nil,
    SavedTreadmillCFrame = nil,
    StealSpeed = 0.8, -- 80% seperti saran Nasi Rendang
    MaxDistance = 500,
    IgnoreYAbove = 120,
    ForceSpeed = 0,
    EggPredictor = false,
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
-- TREADMILL === TIDAK DIUBAH SAMA SEKALI ===
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

--------------------------------------------------------------------
-- TABS
--------------------------------------------------------------------
local FarmTab    = Window:CreateTab("Auto Farm", 4483362458)
local FilterTab  = Window:CreateTab("Filters & Priority", 4483362458)
local ExtraTab   = Window:CreateTab("Extra Features", 4483362458)
local GymTab     = Window:CreateTab("Gym", 4483362458)

-- FARM TAB
FarmTab:CreateToggle({
    Name = "Auto Steal Egg",
    CurrentValue = false,
    Callback = function(v)
        Settings.AutoSteal = v
        if v then
            task.wait(0.2)
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                Settings.SavedBaseCFrame = hrp.CFrame
                Rayfield:Notify({
                    Title = "✅ Posisi Disimpan",
                    Content = "Ambil telur lalu balik ke sini!",
                    Duration = 3
                })
            end
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Steal from Players",
    CurrentValue = false,
    Callback = function(v)
        Settings.StealFromPlayers = v
        Rayfield:Notify({
            Title = v and "✅ Aktif" or "❌ Mati",
            Content = "Steal from Players "..(v and "AKTIF — Hati-hati!" or "dimatikan"),
            Duration = 2.5
        })
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Place to Pen",
    CurrentValue = false,
    Callback = function(v) Settings.AutoPlace = v end,
})

FarmTab:CreateSlider({
    Name = "Auto Steal Speed (disarankan 80%)",
    Min = 0.1,
    Max = 1.0,
    CurrentValue = 0.8,
    Callback = function(val)
        Settings.StealSpeed = val
    end,
})

FarmTab:CreateInput({
    Name = "Force Speed (0 = Otomatis)",
    Placeholder = "0",
    Default = "0",
    Callback = function(txt)
        local num = tonumber(txt) or 0
        Settings.ForceSpeed = num
    end,
})

-- FILTER TAB
FilterTab:CreateDropdown({
    Name = "Filter Area / Zone",
    Options = GameZones,
    CurrentOption = {"All (none)"},
    Callback = function(opt) Settings.SelectedArea = opt[1] end,
})

FilterTab:CreateSection("Prioritas — Divine > Eternal > Secret > dst")
local raritiesList = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare"}
for _, r in ipairs(raritiesList) do
    FilterTab:CreateToggle({
        Name = "Target: " .. r,
        CurrentValue = false,
        Callback = function(v) Settings.Rarities[r] = v end,
    })
end

-- EXTRA TAB
ExtraTab:CreateToggle({
    Name = "Real Godmode",
    CurrentValue = false,
    Callback = function(v)
        Settings.Godmode = v
        Rayfield:Notify({
            Title = v and "✅ Godmode ON" or "❌ Godmode OFF",
            Content = v and "Hati-hati, mudah ketahuan!" or "Aman kembali",
            Duration = 2.5
        })
    end,
})

ExtraTab:CreateToggle({
    Name = "Fly Mode",
    CurrentValue = false,
    Callback = function(v)
        Settings.FlyMode = v
        Rayfield:Notify({
            Title = v and "✅ Fly ON" or "❌ Fly OFF",
            Content = v and "Terbang aktif" or "Terbang mati",
            Duration = 2
        })
    end,
})

ExtraTab:CreateToggle({
    Name = "Egg Predictor",
    CurrentValue = false,
    Callback = function(v)
        Settings.EggPredictor = v
        Rayfield:Notify({
            Title = v and "✅ Prediktor ON" or "❌ Prediktor OFF",
            Content = v and "Melihat telur yang akan datang" or "Prediksi mati",
            Duration = 2
        })
    end,
})

-- GYM TAB
GymTab:CreateToggle({
    Name = "Auto Treadmill",
    CurrentValue = false,
    Callback = function(v)
        Settings.AutoTreadmill = v
        if not v then
            Settings.SavedTreadmillCFrame = nil
        end
    end,
})

--------------------------------------------------------------------
-- LOOP AUTO TREADMILL === TETAP UTUH ===
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
                        Rayfield:Notify({
                            Title = "✅ Treadmill Ditemukan",
                            Content = "Balik ke sini setelah ambil telur!",
                            Duration = 2.5
                        })
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
-- LOOP AUTO STEAL — LENGKAP
--------------------------------------------------------------------
task.spawn(function()
    while task.wait(Settings.ForceSpeed > 0 and Settings.ForceSpeed or Settings.StealSpeed) do
        if not Settings.AutoSteal or not Settings.SavedBaseCFrame then
            task.wait(0.2)
            continue
        end

        pcall(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- Tempat pulang: treadmill kalau aktif
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

            local validEggs = {}
            local myPos = hrp.Position

            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    local txt = (obj.Name .. " " .. obj.ActionText .. " " .. obj.ObjectText):lower()

                    if txt:find("wisp") or txt:find("machine") or txt:find("shop") or txt:find("quest") then
                        continue
                    end
                    if not (txt:find("egg") or txt:find("telur") or txt:find("steal") or txt:find("take")) then
                        continue
                    end

                    local eggModel = obj.Parent
                    local eggPart = eggModel:IsA("BasePart") and eggModel
                        or eggModel:FindFirstChildWhichIsA("BasePart", true)

                    -- TIDAK KE LANGIT
                    if not eggPart then continue end
                    if eggPart.Position.Y >= Settings.IgnoreYAbove or eggPart.Position.Y < -20 then
                        continue
                    end
                    local dist = (eggPart.Position - myPos).Magnitude
                    if dist > Settings.MaxDistance then
                        continue
                    end

                    local rName, rWeight = getEggRarityData(eggModel)
                    local zoneOk = isZoneMatched(eggModel, Settings.SelectedArea)
                    local rarityOk = not anySelected or activeRarities[rName]

                    if zoneOk and rarityOk then
                        table.insert(validEggs, {
                            prompt = obj,
                            part   = eggPart,
                            rarity = rName,
                            weight = rWeight
                        })
                    end
                end
            end

            -- Urutkan prioritas
            table.sort(validEggs, function(a, b)
                return a.weight > b.weight
            end)

            -- Egg Predictor notifikasi
            if Settings.EggPredictor and #validEggs > 0 then
                Rayfield:Notify({
                    Title = "🔮 Telur Terdekat",
                    Content = validEggs[1].rarity .. " — siap diambil",
                    Duration = 1.5
                })
            end

            if #validEggs > 0 then
                local target = validEggs[1]

                -- Pergi ke telur
                hrp.AssemblyLinearVelocity  = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                task.wait()
                hrp.CFrame = target.part.CFrame * CFrame.new(0, 2.5, 0)

                task.wait(0.5)

                -- Ambil
                target.prompt.RequiresLineOfSight = false
                target.prompt.MaxActivationDistance = 20
                fireproximityprompt(target.prompt)

                Rayfield:Notify({
                    Title = "🥚 Diambil: " .. target.rarity,
                    Content = "Kembali ke posisi...",
                    Duration = 2
                })

                task.wait(0.5)

                -- BALIK KE TREADMILL / BASE
                hrp.AssemblyLinearVelocity  = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                hrp.CFrame = returnPoint
                task.wait(0.25)
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    end
end)

--------------------------------------------------------------------
-- LOOP AUTO PLACE
--------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.4) do
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
                        task.wait(0.6)
                        break
                    end
                end
            end
        end)
    end
end)

--------------------------------------------------------------------
-- GODMODE & FLY
--------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end

            -- Godmode
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, not Settings.Godmode)
            if Settings.Godmode then
                hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            end

            -- Fly
            if Settings.FlyMode then
                hum.PlatformStand = true
                hrp.AssemblyLinearVelocity = Vector3.new(
                    (UserInputService:IsKeyDown(Enum.KeyCode.D) and 20 or 0) + (UserInputService:IsKeyDown(Enum.KeyCode.A) and -20 or 0),
                    (UserInputService:IsKeyDown.Space and 15 or 0) + (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -15 or 0),
                    (UserInputService:IsKeyDown(Enum.KeyCode.S) and 20 or 0) + (UserInputService:IsKeyDown(Enum.KeyCode.W) and -20 or 0)
                )
            end
        end)
    end
end)

Rayfield:Notify({
    Title = "✅ SYADZZ HUB Siap — Nasi Rendang Style",
    Content = "Semua fitur aktif | Treadmill tetap utuh!",
    Duration = 4
})
