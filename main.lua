-- ==================================================
-- 🚀 SYADZZ HUB — REDESIGN ORION UI & FIXED TELEPORT
-- ⚠️ AUTO TREADMILL TIDAK DIUBAH SEKALI PUN ⚠️
-- ==================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Clean up GUI lama
pcall(function()
    if CoreGui:FindFirstChild("Orion") then CoreGui.Orion:Destroy() end
    if CoreGui:FindFirstChild("KavoUI") then CoreGui.KavoUI:Destroy() end
    if CoreGui:FindFirstChild("SyadzzMasterHub") then CoreGui.SyadzzMasterHub:Destroy() end
end)

-- Orion Library (GUI Bagus & Modern)
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

local Window = OrionLib:CreateWindow({
    Name = "SYADZZ HUB 🥚 | Steal an Egg",
    HidePremium = true,
    SaveConfig = false,
    ConfigFolder = "SyadzzHub"
})

local Settings = {
    AutoSteal = false,
    AutoTreadmill = false,
    SavedBaseCFrame = nil,
    SavedTreadmillCFrame = nil,
    StealDelay = 0.15,
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
-- 🔍 DETEKSI RARITY TELUR
--------------------------------------------------------------------
local function detectEggData(model)
    local rarityName = "Common"
    local rawStr = (model.Name .. " " .. model:GetFullName()):lower()

    local attr = model:GetAttribute("Rarity") or (model.Parent and model.Parent:GetAttribute("Rarity"))
    if attr then
        rawStr = rawStr .. " " .. tostring(attr):lower()
    end

    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("StringValue") or v:IsA("TextLabel") then
            rawStr = rawStr .. " " .. tostring(v.Value or v.Text):lower()
        end
    end

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

    return rarityName, (RarityWeight[rarityName] or 100)
end

--------------------------------------------------------------------
-- TAMPILAN ORION UI (BERSIH & ELEGAN)
--------------------------------------------------------------------
local FarmTab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483362458", PremiumOnly = false})
local FilterTab = Window:MakeTab({Name = "Filter Rarity", Icon = "rbxassetid://4483362458", PremiumOnly = false})
local GymTab = Window:MakeTab({Name = "Gym Zone", Icon = "rbxassetid://4483362458", PremiumOnly = false})

FarmTab:AddToggle({
    Name = "Auto Steal Egg",
    Default = false,
    Callback = function(v)
        Settings.AutoSteal = v
        if v then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then 
                Settings.SavedBaseCFrame = hrp.CFrame 
                OrionLib:MakeNotification({Name = "Auto Steal", Content = "Base disimpan. Mulai teleportasi...", Image = "rbxassetid://4483362458", Time = 2})
            end
        end
    end
})

FarmTab:AddSlider({
    Name = "Steal Delay",
    Min = 1,
    Max = 10,
    Default = 2,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(v)
        Settings.StealDelay = v / 10
    end
})

for _, r in ipairs({"Infinity", "Celestial", "Secret", "Cosmic", "Divine", "Mythic", "Legendary", "Epic", "Rare", "Uncommon", "Common"}) do
    FilterTab:AddToggle({
        Name = "Target: " .. r,
        Default = Settings.Rarities[r] or false,
        Callback = function(v)
            Settings.Rarities[r] = v
        end
    })
end

GymTab:AddToggle({
    Name = "Auto Treadmill",
    Default = false,
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
            end
        end
        if cachedTreadmillCFrame and not Settings.AutoSteal then
            hrp.CFrame = cachedTreadmillCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

--------------------------------------------------------------------
-- ⚡ LOGIKA AUTO STEAL (PASTI TELEPORT KE TELUR)
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

        -- Pindai ProximityPrompt
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                local parent = prompt.Parent
                if parent then
                    local fullText = (prompt.Name .. " " .. prompt.ActionText .. " " .. prompt.ObjectText .. " " .. parent.Name .. " " .. parent:GetFullName()):lower()

                    -- Abaikan portal/dunia/mesin/enchanted
                    if fullText:find("portal") or fullText:find("enter") or fullText:find("teleport") or 
                       fullText:find("fuse") or fullText:find("world") or fullText:find("enchanted") or 
                       fullText:find("angel") or fullText:find("demon") or fullText:find("warp") or 
                       fullText:find("machine") or fullText:find("spin") or fullText:find("craft") then
                        continue
                    end

                    -- Cek telur
                    local isEgg = fullText:find("egg") or fullText:find("telur") or fullText:find("steal") or fullText:find("take") or fullText:find("grab") or fullText:find("collect")

                    if isEgg then
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
        end

        -- Urutkan target terbaik
        table.sort(targets, function(a, b) return a.weight > b.weight end)

        -- Eksekusi Teleportasi
        if #targets > 0 then
            local bestTarget = targets[1]
            local targetCFrame = bestTarget.part.CFrame

            -- Teleport Paksa ke Karakter
            hrp.CFrame = targetCFrame + Vector3.new(0, 2.5, 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero

            task.wait(0.12)

            -- Bypass & Fire Prompt
            pcall(function()
                bestTarget.prompt.HoldDuration = 0
                bestTarget.prompt.MaxActivationDistance = 100
                bestTarget.prompt.RequiresLineOfSight = false
                fireproximityprompt(bestTarget.prompt)
            end)

            task.wait(0.1)

            -- Balik ke asal
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = returnPoint
                char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
end)

OrionLib:Init()
