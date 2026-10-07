--// SYADZZ HUB - SAFE / ANTI-BAN EDITION (STEAL AN EGG)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP GUI LAMA
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("SyadzzSafeHub") then
        LocalPlayer.PlayerGui.SyadzzSafeHub:Destroy()
    end
    if CoreGui:FindFirstChild("SyadzzSafeHub") then
        CoreGui.SyadzzSafeHub:Destroy()
    end
end)

-- 2. LOAD RAYFIELD UI LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Safe Edition]",
    LoadingTitle = "Loading Safe Mode...",
    LoadingSubtitle = "by Syadholicc",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Settings = {
    AutoStealSafe = false,
    AutoWisp = false,
    AutoTreadmill = false,
    Rarities = {
        ["Divine"] = true,
        ["Eternal"] = true,
        ["Secret"] = true,
        ["Cosmic"] = true,
        ["Mythic"] = true,
        ["Legendary"] = true
    }
}

local RarityWeight = {
    ["Divine"] = 1000,
    ["Eternal"] = 900,
    ["Secret"] = 800,
    ["Cosmic"] = 700,
    ["Mythic"] = 600,
    ["Legendary"] = 500
}

local function getEggRarityNameAndWeight(eggObj)
    if not eggObj then return "Legendary", 500 end
    local fullText = ""
    local curr = eggObj
    for i = 1, 5 do
        if curr then
            fullText = fullText .. " " .. curr.Name:lower()
            curr = curr.Parent
        end
    end
    for rarity, weight in pairs(RarityWeight) do
        if fullText:find(rarity:lower()) then
            return rarity, weight
        end
    end
    return "Legendary", 500
end

local function isRealEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local parentName = prompt.Parent and prompt.Parent.Name:lower() or ""
    if parentName:find("wisp") or parentName:find("machine") or parentName:find("lab") then return false end
    if parentName:find("egg") or prompt.ObjectText:lower():find("egg") then return true end
    return false
end

-- AMAN MENGGUNAKAN HUMANOID:MOVETO (BERJALAN NATURAL)
local function safeWalkTo(targetPosition)
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:MoveTo(targetPosition)
    end
end

-- TABS
local FarmTab = Window:CreateTab("Safe Farm", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

FarmTab:CreateToggle({
    Name = "Auto Steal (Safe Walk Mode)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoStealSafe = v end,
})

MiscTab:CreateToggle({
    Name = "Auto Treadmill (Gym)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTreadmill = v end,
})

MiscTab:CreateToggle({
    Name = "Auto Wisp Event",
    CurrentValue = false,
    Callback = function(v) Settings.AutoWisp = v end,
})

-- LOOP AMAN DENGAN JALAN NATURAL
task.spawn(function()
    while task.wait(0.8) do
        if Settings.AutoStealSafe then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                
                local targets = {}
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if isRealEggPrompt(obj) then
                        local model = obj.Parent
                        local part = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
                        if part then
                            local rName, rWeight = getEggRarityNameAndWeight(model)
                            if Settings.Rarities[rName] then
                                table.insert(targets, {prompt = obj, part = part, weight = rWeight})
                            end
                        end
                    end
                end

                table.sort(targets, function(a, b) return a.weight > b.weight end)

                if #targets > 0 then
                    local t = targets[1]
                    -- Berjalan secara natural menggunakan Humanoid:MoveTo agar lolos dari anti-cheat
                    safeWalkTo(t.part.Position)
                    task.wait(0.5)
                    t.prompt.RequiresLineOfSight = false
                    fireproximityprompt(t.prompt)
                    task.wait(0.5)
                end
            end)
        end
    end
end)

-- AUTO TREADMILL & WISP AMAN
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            if Settings.AutoTreadmill then
                local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases")
                if plotsFolder then
                    for _, plot in pairs(plotsFolder:GetChildren()) do
                        if plot.Name == LocalPlayer.Name or plot:GetAttribute("Owner") == LocalPlayer.Name then
                            for _, obj in pairs(plot:GetDescendants()) do
                                if obj:IsA("BasePart") and (obj.Name:lower():find("treadmill") or obj.Color.B > 0.5) then
                                    char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                    break
                                end
                            end
                        end
                    end
                end
            end

            if Settings.AutoWisp then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent.Name:lower():find("wisp") then
                        local p = obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart", true)
                        if p then
                            safeWalkTo(p.Position)
                            fireproximityprompt(obj)
                        end
                    end
                end
            end
        end)
    end
end)

Rayfield:Notify({
    Title = "SYADZZ HUB (Safe Mode)",
    Content = "Loaded Successfully! Anti-Ban Walk Mode Active.",
    Duration = 5,
})
