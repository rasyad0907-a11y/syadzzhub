-- ==================================================
-- 🚀 SYADZZ HUB — DATABASE SCANNER & ACCURATE AUTO STEAL
-- ⚠️ AUTO TREADMILL TIDAK DIUBAH SEKALI PUN ⚠️
-- ==================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Bersihkan GUI lama jika ada
pcall(function()
    if CoreGui:FindFirstChild("KavoUI") then CoreGui.KavoUI:Destroy() end
    if CoreGui:FindFirstChild("SyadzzMasterHub") then CoreGui.SyadzzMasterHub:Destroy() end
end)

local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("SYADZZ HUB 🥚 | Steal an Egg Database Edition", "Midnight")

local Settings = {
    AutoSteal = false,
    AutoTreadmill = false,
    SavedBaseCFrame = nil,
    SavedTreadmillCFrame = nil,
    StealDelay = 0.1,
    Rarities = {
        ["Infinity"] = true,
        ["Celestial"] = true,
        ["Secret"] = true,
        ["Cosmic"] = true,
        ["Divine"] = true,
        ["Mythic"] = true,
        ["Legendary"] = true,
        ["Epic"] = true,
        ["Rare"] = true,
        ["Uncommon"] = false,
        ["Common"] = false
    }
}

local RarityWeight = {
    ["Infinity"] = 1100, ["Celestial"] = 1000, ["Secret"] = 900,
    ["Cosmic"] = 800, ["Divine"] = 700, ["Mythic"] = 600,
    ["Legendary"] = 500, ["Epic"] = 400, ["Rare"] = 300,
    ["Uncommon"] = 200, ["Common"] = 100
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
-- 🔍 PEMBACA DATABASE LOKAL (INTERNAL WORKSPACE SCANNER)
--------------------------------------------------------------------
local function detectEggData(model)
    local rarityName = "Common"
    
    -- 1. Pembacaan via Attributes asli game
    local attrRarity = model:GetAttribute("Rarity") or (model.Parent and model.Parent:GetAttribute("Rarity"))
    if attrRarity then
        rarityName = tostring(attrRarity)
    else
        -- 2. Pembacaan via struktur Objek & Child Value
        local rarityVal = model:FindFirstChild("Rarity", true) or model:FindFirstChild("Tier", true)
        if rarityVal and (rarityVal:IsA("StringValue") or rarityVal:IsA("TextLabel")) then
            rarityName = tostring(rarityVal.Value or rarityVal.Text)
        else
            -- 3. Fallback pencarian String dari nama folder/model
            local rawStr = (model.Name .. " " .. model:GetFullName()):lower()
            if rawStr:find("infinity") then rarityName = "Infinity"
            elseif rawStr:find("celestial") then rarityName = "Celestial"
            elseif rawStr:find("secret") then rarityName = "Secret"
            elseif rawStr:find("cosmic") then rarityName = "Cosmic"
            elseif rawStr:find("divine") then rarityName = "Divine"
            elseif rawStr:find("mythic") then rarityName = "Mythic"
            elseif rawStr:find("legendary") then rarityName = "Legendary"
            elseif rawStr:find("epic") then rarityName = "Epic"
            elseif rawStr:find("rare") then rarityName = "Rare"
            elseif rawStr:find("uncommon") then rarityName = "Uncommon"
            end
        end
    end

    -- Normalisasi format teks Rarity
    for targetRarity, _ in pairs(RarityWeight) do
        if rarityName:lower():find(targetRarity:lower()) then
            return targetRarity, RarityWeight[targetRarity]
        end
    end

    return "Common", 100
end

--------------------------------------------------------------------
-- TAMPILAN GUI
--------------------------------------------------------------------
local MainTab = Window:NewTab("Auto Steal")
local MainSection = MainTab:NewSection("Utama")

MainSection:NewToggle("Auto Steal Egg", "Mencari & mengambil telur otomatis", function(v)
    Settings.AutoSteal = v
    if v then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then Settings.SavedBaseCFrame = hrp.CFrame end
    end
end)

MainSection:NewSlider("Kecepatan Pick (Delay)", "Jeda antar teleportasi", 10, 1, function(v)
    Settings.StealDelay = v / 20
end)

local FilterTab = Window:NewTab("Filter Rarity")
local FilterSection = FilterTab:NewSection("Prioritas Telur")

for _, r in ipairs({"Infinity", "Celestial", "Secret", "Cosmic", "Divine", "Mythic", "Legendary", "Epic", "Rare", "Uncommon", "Common"}) do
    FilterSection:NewToggle("Target: " .. r, "Fokus ke jenis " .. r, function(v)
        Settings.Rarities[r] = v
    end)
end

local GymTab = Window:NewTab("Gym Zone")
local GymSection = GymTab:NewSection("Auto Treadmill")

GymSection:NewToggle("Auto Treadmill", "Otomatis di treadmill", function(v)
    Settings.AutoTreadmill = v
    if not v then Settings.SavedTreadmillCFrame = nil end
end)

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
            end
        end
        if cachedTreadmillCFrame and not Settings.AutoSteal then
            hrp.CFrame = cachedTreadmillCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

--------------------------------------------------------------------
-- ⚡ AUTO STEAL EXECUTION LOOP
--------------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(Settings.StealDelay)
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

        local targets = {}

        -- Poin 1: Pindai ProximityPrompt di seluruh dunia
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                local parent = prompt.Parent
                if parent then
                    local rName, weight = detectEggData(parent)

                    if Settings.Rarities[rName] then
                        local part = parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart", true)
                        if part then
                            table.insert(targets, {
                                prompt = prompt,
                                part = part,
                                rarity = rName,
                                weight = weight
                            })
                        end
                    end
                end
            end
        end

        -- Poin 2: Urutkan target berdasarkan Rarity tertinggi
        table.sort(targets, function(a, b) return a.weight > b.weight end)

        -- Poin 3: Eksekusi Teleportasi & Pengambilan Instant
        if #targets > 0 then
            local bestTarget = targets[1]
            local pos = bestTarget.part.Position

            -- Teleport tepat di atas lokasi telur
            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 2.5, 0))
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            task.wait(0.05)

            -- Bypass interaksi
            bestTarget.prompt.HoldDuration = 0
            bestTarget.prompt.MaxActivationDistance = 50
            bestTarget.prompt.RequiresLineOfSight = false

            pcall(function()
                fireproximityprompt(bestTarget.prompt)
            end)

            task.wait(0.05)

            -- Kembalikan posisi karakter
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = returnPoint
                char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
end)
