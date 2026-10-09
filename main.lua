-- ==================================================
-- 🚀 SYADZZ HUB — FRONT TELEPORT & RETURN HARVESTER
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
    Name = "SYADZZ HUB 🥚 | Front Teleport Harvester",
    LoadingTitle = "SYADZZ HUB",
    LoadingSubtitle = "Teleporting Front of Eggs & Returning Base",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Settings = {
    AutoSteal = false,
    AutoTreadmill = false,
    SavedBaseCFrame = nil,
    SavedTreadmillCFrame = nil,
    StealTimeout = 0.8,
    Rarities = {
        ["BrainrotGod"] = true, ["Transcendent"] = true, ["Titan"] = true,
        ["Eternal"] = true, ["Secret"] = true, ["Cosmic"] = true,
        ["Divine"] = true, ["Mythic"] = true, ["Legendary"] = true,
        ["Epic"] = true, ["SuperRare"] = true, ["Rare"] = true,
        ["Uncommon"] = true, ["Common"] = true, ["LightDark"] = true
    }
}

local RarityWeight = {
    ["BrainrotGod"] = 1500, ["Transcendent"] = 1400, ["Titan"] = 1300,
    ["Eternal"] = 1200, ["Secret"] = 1100, ["Cosmic"] = 1000,
    ["Divine"] = 900, ["Mythic"] = 800, ["Legendary"] = 700,
    ["Epic"] = 600, ["SuperRare"] = 500, ["Rare"] = 400,
    ["Uncommon"] = 300, ["Common"] = 200, ["LightDark"] = 100
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
-- 🔍 PEMACU DETEKSI TAS RANSEL & RARITY
--------------------------------------------------------------------
local function getBackpackItemCount()
    local ransel = LocalPlayer:FindFirstChild("Tas Ransel") or LocalPlayer:FindFirstChild("Backpack")
    if ransel then return #ransel:GetChildren() end
    return 0
end

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
    return "Common", 200
end

--------------------------------------------------------------------
-- TAMPILAN GUI
--------------------------------------------------------------------
local FarmTab = Window:CreateTab("Auto Steal", 4483362458)
local FilterTab = Window:CreateTab("Filter Rarity", 4483362458)
local GymTab = Window:CreateTab("Gym Zone", 4483362458)

FarmTab:CreateToggle({
    Name = "Auto Steal (Front Teleport)",
    CurrentValue = false,
    Callback = function(v)
        Settings.AutoSteal = v
        if v then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then 
                Settings.SavedBaseCFrame = hrp.CFrame
                Rayfield:Notify({Title = "Auto Steal", Content = "Aktif! Saved base location.", Duration = 2.5})
            end
        end
    end
})

for r, _ in pairs(Settings.Rarities) do
    FilterTab:CreateToggle({
        Name = "Target: " .. r,
        CurrentValue = Settings.Rarities[r],
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
-- ⚡ LOGIKA AUTO STEAL (FRONT TELEPORT & RETURN BASE)
--------------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.1)
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
                if folder.Name == "Nests" and not folder:GetFullName():find("EggCarryBounds") then
                    for _, nestModel in ipairs(folder:GetChildren()) do
                        local targetPart = nestModel:FindFirstChild("EggFitBounds") or nestModel:FindFirstChild("EggSpotBottom") or nestModel:FindFirstChildWhichIsA("BasePart", true)

                        if targetPart then
                            local rName, rWeight = getEggRarity(nestModel)

                            if Settings.Rarities[rName] then
                                table.insert(validTargets, {
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
            local targetPart = target.part
            local initialBackpackCount = getBackpackItemCount()

            -- 1. Teleport Tepat di Depan Telur (3 studs offset & menghadap telur)
            local frontCFrame = targetPart.CFrame * CFrame.new(0, 0, -3)
            hrp.CFrame = CFrame.lookAt(frontCFrame.Position, targetPart.Position)
            hrp.AssemblyLinearVelocity = Vector3.zero

            -- 2. Trigger Touch
            local touchInterest = targetPart:FindFirstChildWhichIsA("TouchTransmitter", true)
            if touchInterest then
                pcall(function()
                    firetouchinterest(hrp, targetPart, 0)
                    task.wait(0.05)
                    firetouchinterest(hrp, targetPart, 1)
                end)
            end

            -- 3. Menunggu Item Masuk Ke Tas
            local timer = 0
            while timer < Settings.StealTimeout do
                task.wait(0.1)
                timer = timer + 0.1
                if getBackpackItemCount() > initialBackpackCount then
                    break
                end
            end

            -- 4. Langsung Kembali ke Base / Treadmill
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = returnPoint
                char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
end)
