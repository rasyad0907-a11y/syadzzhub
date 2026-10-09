-- ==================================================
-- 🚀 SYADZZ HUB — SPECIALIZED BASE/PLOT EGG STEALER
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
    Name = "SYADZZ HUB 🥚 | Fix Total Steal An Egg",
    LoadingTitle = "SYADZZ HUB",
    LoadingSubtitle = "Anti-Portal & Direct Plot Steal",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Settings = {
    AutoSteal = false,
    AutoTreadmill = false,
    SavedBaseCFrame = nil,
    SavedTreadmillCFrame = nil,
    StealDelay = 0.2,
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
        ["Uncommon"] = true,
        ["Common"] = true
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
local function getEggRarity(eggModel)
    local rawText = (eggModel.Name .. " " .. eggModel:GetFullName()):lower()
    
    local attr = eggModel:GetAttribute("Rarity")
    if attr then rawText = rawText .. " " .. tostring(attr):lower() end

    for _, v in ipairs(eggModel:GetDescendants()) do
        if v:IsA("StringValue") or v:IsA("TextLabel") then
            rawText = rawText .. " " .. tostring(v.Value or v.Text):lower()
        end
    end

    for rarity, weight in pairs(RarityWeight) do
        if rawText:find(rarity:lower()) then
            return rarity, weight
        end
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
    Name = "Auto Steal Egg (Base Only)",
    CurrentValue = false,
    Callback = function(v)
        Settings.AutoSteal = v
        if v then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then 
                Settings.SavedBaseCFrame = hrp.CFrame
                Rayfield:Notify({Title = "Auto Steal", Content = "Aktif! Hanya scan Base musuh.", Duration = 2})
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
-- ⚡ LOGIKA AUTO STEAL BARU (KHUSUS BASE/PLOT MUSUH)
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

        local validTargets = {}

        -- 1. Cari Folder Plot/Base/Plots di Workspace
        local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("Baseplates") or Workspace

        for _, plot in ipairs(plotsFolder:GetChildren()) do
            -- Abaikan Plot milik player sendiri
            local isMyPlot = false
            for _, child in ipairs(plot:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("StringValue") then
                    if child.Text == LocalPlayer.Name or child.Value == LocalPlayer.Name then
                        isMyPlot = true
                        break
                    end
                end
            end

            if not isMyPlot then
                -- Scan ProximityPrompt yang HANYA ada di dalam Plot musuh
                for _, prompt in ipairs(plot:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        local parent = prompt.Parent
                        if parent then
                            local fullName = (prompt.Name .. " " .. prompt.ActionText .. " " .. parent.Name .. " " .. parent:GetFullName()):lower()

                            -- Blokir total kata kunci portal
                            if not (fullName:find("portal") or fullName:find("enter") or fullName:find("teleport") or fullName:find("world") or fullName:find("enchanted") or fullName:find("fuse")) then
                                local rName, rWeight = getEggRarity(parent)

                                if Settings.Rarities[rName] then
                                    local part = parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart", true)
                                    if part then
                                        table.insert(validTargets, {
                                            prompt = prompt,
                                            part = part,
                                            weight = rWeight
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Urutkan berdasarkan nilai telur
        table.sort(validTargets, function(a, b) return a.weight > b.weight end)

        -- Eksekusi Teleportasi
        if #validTargets > 0 then
            local target = validTargets[1]
            local targetPos = target.part.Position

            -- Teleport langsung ke atas telur di Base musuh
            hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            task.wait(0.1)

            -- Ambil telur
            target.prompt.HoldDuration = 0
            target.prompt.MaxActivationDistance = 50
            target.prompt.RequiresLineOfSight = false

            pcall(function()
                fireproximityprompt(target.prompt)
            end)

            task.wait(0.1)

            -- Balik ke Base
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = returnPoint
                char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
end)
