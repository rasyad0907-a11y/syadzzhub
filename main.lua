--// SYADZZ HUB x JUAL NASI RENDANG STYLE - ALL FEATURES OFF BY DEFAULT
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP GUI LAMA
pcall(function()
    if CoreGui:FindFirstChild("SyadzzNasiRendangHub") then
        CoreGui.SyadzzNasiRendangHub:Destroy()
    end
end)

-- 2. LOAD RAYFIELD UI LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Pro Hub Edition]",
    LoadingTitle = "Loading Hub...",
    LoadingSubtitle = "by Syadholicc & Team",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- CONFIGURATION SETTINGS (SEMUA MATI / FALSE SECARA DEFAULT)
local Settings = {
    AutoSteal = false,
    AutoPlace = false,
    AutoTreadmill = false,
    AutoWisp = false,
    EggESP = false,
    SelectedArea = "All (none)",
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

local RarityWeight = {
    ["Divine"] = 1000,
    ["Eternal"] = 900,
    ["Secret"] = 800,
    ["Cosmic"] = 700,
    ["Mythic"] = 600,
    ["Legendary"] = 500,
    ["Epic"] = 400,
    ["Rare"] = 300
}

-- HELPER FUNCTIONS
local function getEggRarityNameAndWeight(eggObj)
    if not eggObj then return "Rare", 300 end
    local fullText = ""
    local curr = eggObj
    for i = 1, 6 do
        if curr then
            fullText = fullText .. " " .. curr.Name:lower()
            curr = curr.Parent
        end
    end
    if eggObj:FindFirstChild("Rarity") then
        fullText = fullText .. " " .. tostring(eggObj.Rarity.Value):lower()
    end
    for rarity, weight in pairs(RarityWeight) do
        if fullText:find(rarity:lower()) then
            return rarity, weight
        end
    end
    return "Rare", 300
end

local function isRealEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local parentName = prompt.Parent and prompt.Parent.Name:lower() or ""
    if parentName:find("wisp") or parentName:find("machine") or parentName:find("lab") then return false end
    if parentName:find("egg") or prompt.ObjectText:lower():find("egg") then return true end
    return false
end

local function getMyPlotStrict()
    local possibleFolders = {"Plots", "Bases", "PlotFolder", "PlayerPlots"}
    for _, fName in ipairs(possibleFolders) do
        local folder = Workspace:FindFirstChild(fName)
        if folder then
            for _, plot in pairs(folder:GetChildren()) do
                if plot.Name == LocalPlayer.Name or plot:GetAttribute("Owner") == LocalPlayer.Name then
                    return plot
                end
            end
        end
    end
    return nil
end

local function getMySafeZoneCFrame()
    local myPlot = getMyPlotStrict()
    if myPlot then
        return myPlot:GetPivot() + Vector3.new(0, 3, 0)
    end
    return LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.CFrame
end

-- TABS CREATION
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local FilterTab = Window:CreateTab("Filters & ESP", 4483362458)
local MiscTab = Window:CreateTab("Gym & Misc", 4483362458)

-- FARM TAB
FarmTab:CreateToggle({
    Name = "Auto Steal Egg (Smart Priority)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoSteal = v end,
})

FarmTab:CreateToggle({
    Name = "Auto Place to Pen",
    CurrentValue = false,
    Callback = function(v) Settings.AutoPlace = v end,
})

-- FILTER TAB
FilterTab:CreateToggle({
    Name = "Egg ESP (Highlight High Tier)",
    CurrentValue = false,
    Callback = function(v) Settings.EggESP = v end,
})

FilterTab:CreateDropdown({
    Name = "Select Area Filter",
    Options = {"All (none)", "Enchanted Forest", "Cosmic", "Prehistoric", "Volcano", "Snow", "Jungle", "Desert", "Lake"},
    CurrentOption = {"All (none)"},
    Callback = function(opt) Settings.SelectedArea = opt[1] end,
})

FilterTab:CreateSection("Rarity Target Toggles")
local rarities = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare"}
for _, r in ipairs(rarities) do
    FilterTab:CreateToggle({
        Name = "Target Rarity: " .. r,
        CurrentValue = false, -- Default false
        Callback = function(v) Settings.Rarities[r] = v end,
    })
end

-- MISC TAB
MiscTab:CreateToggle({
    Name = "Auto Treadmill (Blue Gym)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTreadmill = v end,
})

MiscTab:CreateToggle({
    Name = "Auto Collect Wisp Event",
    CurrentValue = false,
    Callback = function(v) Settings.AutoWisp = v end,
})

-- BACKGROUND EXECUTION LOOPS
task.spawn(function()
    while task.wait(0.2) do
        if Settings.AutoSteal then
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
                            -- Cek apakah ada filter rarity yang menyala
                            local anyActive = false
                            for _, active in pairs(Settings.Rarities) do
                                if active then anyActive = true break end
                            end
                            
                            -- Jika tidak ada filter yang dinyalakan, ambil semua. Jika ada, sesuaikan.
                            if not anyActive or Settings.Rarities[rName] then
                                table.insert(targets, {prompt = obj, part = part, weight = rWeight})
                            end
                        end
                    end
                end

                table.sort(targets, function(a, b) return a.weight > b.weight end)

                if #targets > 0 then
                    local t = targets[1]
                    local safeCFrame = getMySafeZoneCFrame()
                    
                    char.HumanoidRootPart.CFrame = t.part.CFrame * CFrame.new(0, 2.5, 0)
                    task.wait(0.08)
                    t.prompt.RequiresLineOfSight = false
                    fireproximityprompt(t.prompt)
                    task.wait(0.1)
                    
                    if safeCFrame then
                        char.HumanoidRootPart.CFrame = safeCFrame
                    end
                end
            end)
        end
    end
end)

-- GYM & WISP LOOP
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            if Settings.AutoTreadmill then
                local myPlot = getMyPlotStrict()
                if myPlot then
                    for _, obj in pairs(myPlot:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("treadmill") or obj.Color.B > 0.5) then
                            char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                            break
                        end
                    end
                end
            end

            if Settings.AutoWisp then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent.Name:lower():find("wisp") then
                        local p = obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart", true)
                        if p then
                            char.HumanoidRootPart.CFrame = p.CFrame + Vector3.new(0, 2, 0)
                            fireproximityprompt(obj)
                        end
                    end
                end
            end
        end)
    end
end)

-- AUTO PLACE TO PEN
task.spawn(function()
    while task.wait(0.5) do
        if Settings.AutoPlace then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool.Name:lower():find("egg") then
                    local myPlot = getMyPlotStrict()
                    if myPlot then
                        for _, obj in pairs(myPlot:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") and (obj.ActionText:lower():find("place") or obj.ObjectText:lower():find("pen")) then
                                fireproximityprompt(obj)
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({
    Title = "SYADZZ HUB (Clean Edition)",
    Content = "Loaded Successfully! All features are OFF by default.",
    Duration = 5,
})
