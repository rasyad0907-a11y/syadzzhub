-- ==================================================
-- 🚀 SYADZZ HUB — UNIVERSAL NEST EGG STEALER
-- ⚠️ AUTO TREADMILL TIDAK DIUBAH SEKALI PUN ⚠️
-- ==================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("Rayfield") then CoreGui.Rayfield:Destroy() end
    if CoreGui:FindFirstChild("SyadzzMasterHub") then CoreGui.SyadzzMasterHub:Destroy() end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB 🥚 | Universal Nest Stealer",
    LoadingTitle = "SYADZZ HUB",
    LoadingSubtitle = "Targeting All Nests Automatically",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Settings = {
    AutoSteal = false,
    AutoTreadmill = false,
    SavedBaseCFrame = nil,
    SavedTreadmillCFrame = nil,
    StealDelay = 0.15,
    Rarities = {
        ["Infinity"] = true, ["Celestial"] = true, ["Secret"] = true,
        ["Cosmic"] = true, ["Divine"] = true, ["Mythic"] = true,
        ["Legendary"] = true, ["Epic"] = true, ["Rare"] = true,
        ["Uncommon"] = true, ["Common"] = true
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
-- 🔍 DETEKSI RARITY
--------------------------------------------------------------------
local function getEggRarity(model)
    local rawText = (model.Name .. " " .. model:GetFullName()):lower()
    local attr = model:GetAttribute("Rarity") or (model.Parent and model.Parent:GetAttribute("Rarity"))
    if attr then rawText = rawText .. " " .. tostring(attr):lower() end

    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("StringValue") or v:IsA("TextLabel") then
            rawText = rawText .. " " .. tostring(v.Value or v.Text):lower()
        end
    end

    for rarity, weight in pairs(RarityWeight) do
        if rawText:find(rarity:lower()) then return rarity, weight end
    end
    return "Common", 100
end

--------------------------------------------------------------------
-- TAMPILAN GUI
--------------------------------------------------------------------
local FarmTab = Window:CreateTab("Auto Steal", 4483362458)
local FilterTab = Window:CreateTab("Filter Rarity", 4483362458)
local GymTab = Window:CreateTab("Gym Zone", 4483362458)

FarmTab:CreateToggle({
    Name = "Auto Steal All Nests",
    CurrentValue = false,
    Callback = function(v)
        Settings.AutoSteal = v
        if v then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then 
                Settings.SavedBaseCFrame = hrp.CFrame
                Rayfield:Notify({Title = "Auto Steal", Content = "Aktif! Scanning seluruh folder Nests.", Duration = 2.5})
            end
        end
    end
})

for _, r in ipairs({"Infinity", "Celestial", "Secret", "Cosmic", "Divine", "Mythic", "Legendary", "Epic", "Rare", "Uncommon", "Common"}) do
    FilterTab:CreateToggle({
        Name = "Target: " .. r,
        CurrentValue = Settings.Rarities[r] or false,
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
            if cachedTreadmillCFrame then Settings.SavedTreadmillCFrame = cachedTreadmillCFrame end
        end
        if cachedTreadmillCFrame and not Settings.AutoSteal then
            hrp.CFrame = cachedTreadmillCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

--------------------------------------------------------------------
-- ⚡ LOGIKA AUTO STEAL (KHUSUS MEMINDAI FOLDER 'NESTS')
--------------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(Settings.StealDelay)
        if not Settings.AutoSteal then continue end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not hrp or not hum or hum.Health <= 0 then continue end

        if not Settings.SavedBaseCFrame then Settings.SavedBaseCFrame = hrp.CFrame end

        local returnPoint = Settings.SavedBaseCFrame
        if Settings.AutoTreadmill and Settings.SavedTreadmillCFrame then
            returnPoint = Settings.SavedTreadmillCFrame
        end

        local validTargets = {}
        local worldAreas = Workspace:FindFirstChild("World") and Workspace.World:FindFirstChild("Areas")

        if worldAreas then
            for _, folder in ipairs(worldAreas:GetDescendants()) do
                -- Hanya memindai folder bernama 'Nests' dan mengabaikan zona EggCarryBounds
                if folder.Name == "Nests" and not folder:GetFullName():find("EggCarryBounds") then
                    for _, nestModel in ipairs(folder:GetChildren()) do
                        local targetPart = nestModel:FindFirstChild("EggFitBounds") or nestModel:FindFirstChild("EggSpotBottom") or nestModel:FindFirstChildWhichIsA("BasePart", true)
                        local prompt = nestModel:FindFirstChildWhichIsA("ProximityPrompt", true) or nestModel.Parent:FindFirstChildWhichIsA("ProximityPrompt", true)

                        if targetPart and prompt then
                            local rName, rWeight = getEggRarity(nestModel)

                            if Settings.Rarities[rName] then
                                table.insert(validTargets, {
                                    prompt = prompt,
                                    part = targetPart,
                                    weight = rWeight
                                })
                            end
                        end
                    end
                end
            end
        end

        table.sort(validTargets, function(a, b) return a.weight > b.weight end)

        if #validTargets > 0 then
            local target = validTargets[1]
            local targetPos = target.part.Position

            -- Teleportasi presisi tepat di atas lokasi EggFitBounds/Nest
            hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
            hrp.AssemblyLinearVelocity = Vector3.zero
            task.wait(0.1)

            target.prompt.HoldDuration = 0
            target.prompt.MaxActivationDistance = 50
            target.prompt.RequiresLineOfSight = false
            
            pcall(function() fireproximityprompt(target.prompt) end)

            task.wait(0.1)

            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = returnPoint
                char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
end)
