--// SYADZZ HUB - PROFESSIONAL EDITION (STEAL AN EGG)
--// Inspired by Top Script Hub Standards (Clean, Smooth Tween & ESP)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP GUI LAMA
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("SyadzzProHub") then
        LocalPlayer.PlayerGui.SyadzzProHub:Destroy()
    end
    if CoreGui:FindFirstChild("SyadzzProHub") then
        CoreGui.SyadzzProHub:Destroy()
    end
end)

-- 2. LOAD RAYFIELD UI LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Pro Edition]",
    LoadingTitle = "Loading Syadzz Pro Hub...",
    LoadingSubtitle = "by Syadholicc & Team",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- SETTINGS CONFIGURATION
local Settings = {
    AutoSteal = false,
    SmoothTween = true,
    TweenSpeed = 150, -- Kecepatan terbang mulus
    Godmode = false,
    AutoPlace = false,
    AutoTreadmill = false,
    AutoWisp = false,
    AutoEnterBossArena = false,
    AutoHitBoss = false,
    AutoStealLabEggs = false,
    AutoTradeInLab = false,
    EggESP = false,
    AntiAFK = true,
    FPSBoost = false,
    SelectedArea = "All (none)",
    Rarities = {
        ["Divine"] = true,
        ["Eternal"] = true,
        ["Secret"] = true,
        ["Cosmic"] = true,
        ["Mythic"] = true,
        ["Legendary"] = true,
        ["Epic"] = false,
        ["Rare"] = false
    }
}

-- STATS TRACKER
local Stats = {
    EggsStolen = 0,
    StartTime = tick()
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

-- ANTI-AFK SYSTEM
task.spawn(function()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            if Settings.AntiAFK then
                vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end
        end)
    end)
end)

-- HELPER FUNCTIONS
local function getEggRarityNameAndWeight(eggObj)
    if not eggObj then return "Rare", 300 end
    local fullText = ""
    local curr = eggObj
    for i = 1, 6 do
        if curr then
            fullText = fullText .. " " .. curr.Name:lower()
            for _, attr in pairs(curr:GetAttributes()) do
                fullText = fullText .. " " .. tostring(attr):lower()
            end
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
    local parent = prompt.Parent
    local parentName = parent and parent.Name:lower() or ""
    local objectText = prompt.ObjectText:lower()

    if parentName:find("wisp") or parentName:find("machine") or parentName:find("quest") or parentName:find("lab") then return false end
    if parentName:find("egg") or objectText:find("egg") then return true end
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

-- SMOOTH TWEEN MOVEMENT (PREMIUM HUB STYLE)
local function smoothMoveTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    if Settings.SmoothTween then
        local dist = (hrp.Position - targetCFrame.Position).Magnitude
        local timeVal = math.clamp(dist / Settings.TweenSpeed, 0.05, 1.2)
        local tweenInfo = TweenInfo.new(timeVal, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()
    else
        hrp.CFrame = targetCFrame
    end
end

-- TABS CREATION
local DashboardTab = Window:CreateTab("Dashboard", 4483362458)
local FarmTab = Window:CreateTab("Auto Farm & Steal", 4483362458)
local VisualTab = Window:CreateTab("Visuals & ESP", 4483362458)
local DungeonTab = Window:CreateTab("Boss & Lab", 4483362458)
local MiscTab = Window:CreateTab("Misc & Settings", 4483362458)

-- 1. DASHBOARD TAB
DashboardTab:CreateSection("Information & Stats")
local StatsLabel = DashboardTab:CreateLabel("Eggs Stolen: 0 | Running Time: 0s")
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local runTime = math.floor(tick() - Stats.StartTime)
            StatsLabel:Set("Eggs Stolen: " .. Stats.EggsStolen .. " | Running Time: " .. runTime .. "s")
        end)
    end
end)

DashboardTab:CreateToggle({
    Name = "Anti-AFK (Prevent Kick)",
    CurrentValue = true,
    Callback = function(v) Settings.AntiAFK = v end,
})

DashboardTab:CreateToggle({
    Name = "FPS Booster (Reduce Lag for Mobile)",
    CurrentValue = false,
    Callback = function(v)
        Settings.FPSBoost = v
        pcall(function()
            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = not v
            lighting.FogEnd = v and 99999 or 10000
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Material = v and Enum.Material.SmoothPlastic or obj.Material
                end
            end
        end)
    end,
})

-- 2. FARM TAB
FarmTab:CreateToggle({
    Name = "Auto Steal Eggs (Smart Priority)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoSteal = v end,
})

FarmTab:CreateToggle({
    Name = "Smooth Tween Flying (Anti-Ban)",
    CurrentValue = true,
    Callback = function(v) Settings.SmoothTween = v end,
})

FarmTab:CreateSlider({
    Name = "Tween Flight Speed",
    Range = {50, 300},
    Increment = 10,
    Suffix = " studs/s",
    CurrentValue = 150,
    Callback = function(v) Settings.TweenSpeed = v end,
})

FarmTab:CreateDropdown({
    Name = "Select Area",
    Options = {"All (none)", "Enchanted Forest", "Cosmic", "Prehistoric", "Volcano", "Snow", "Jungle", "Desert", "Lake"},
    CurrentOption = {"All (none)"},
    Callback = function(opt) Settings.SelectedArea = opt[1] end,
})

FarmTab:CreateSection("Rarity Target Filter")
local rarities = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare"}
for _, r in ipairs(rarities) do
    FarmTab:CreateToggle({
        Name = "Target: " .. r,
        CurrentValue = Settings.Rarities[r],
        Callback = function(v) Settings.Rarities[r] = v end,
    })
end

-- 3. VISUAL TAB (ESP)
VisualTab:CreateToggle({
    Name = "Egg ESP (Highlight High Rarity)",
    CurrentValue = false,
    Callback = function(v) Settings.EggESP = v end,
})

-- 4. DUNGEON TAB
DungeonTab:CreateToggle({
    Name = "Auto Enter Boss Arena (Portal)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoEnterBossArena = v end,
})

DungeonTab:CreateToggle({
    Name = "Auto Hit Boss",
    CurrentValue = false,
    Callback = function(v) Settings.AutoHitBoss = v end,
})

DungeonTab:CreateToggle({
    Name = "Auto Steal Lab Eggs",
    CurrentValue = false,
    Callback = function(v) Settings.AutoStealLabEggs = v end,
})

DungeonTab:CreateToggle({
    Name = "Auto Trade-In Laboratory",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTradeInLab = v end,
})

-- 5. MISC TAB
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

MiscTab:CreateToggle({
    Name = "Auto Place Egg to Pen",
    CurrentValue = false,
    Callback = function(v) Settings.AutoPlace = v end,
})

MiscTab:CreateToggle({
    Name = "Godmode & Anti Ragdoll",
    CurrentValue = false,
    Callback = function(v) Settings.Godmode = v end,
})

-- BACKGROUND LOOPS (OPTIMIZED FOR DELTA/MOBILE)
task.spawn(function()
    while task.wait(0.12) do
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
                            if Settings.Rarities[rName] then
                                table.insert(targets, {prompt = obj, part = part, weight = rWeight})
                            end
                        end
                    end
                end

                table.sort(targets, function(a, b) return a.weight > b.weight end)

                if #targets > 0 then
                    local t = targets[1]
                    local safeCFrame = getMySafeZoneCFrame()
                    
                    smoothMoveTo(t.part.CFrame * CFrame.new(0, 2.5, 0))
                    task.wait(0.05)
                    t.prompt.RequiresLineOfSight = false
                    fireproximityprompt(t.prompt)
                    Stats.EggsStolen = Stats.EggsStolen + 1
                    task.wait(0.08)
                    
                    if safeCFrame then
                        smoothMoveTo(safeCFrame)
                    end
                end
            end)
        end
    end
end)

-- DUNGEON & GYM LOOP
task.spawn(function()
    while task.wait(0.2) do
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
                            smoothMoveTo(p.CFrame + Vector3.new(0, 2, 0))
                            fireproximityprompt(obj)
                        end
                    end
                end
            end

            if Settings.AutoEnterBossArena then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("portal") or obj.Name:lower():find("arena")) then
                        char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                        break
                    end
                end
            end

            if Settings.AutoHitBoss then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("boss") or obj.Name:lower():find("scramble")) then
                        local bp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                        if bp then
                            char.HumanoidRootPart.CFrame = bp.CFrame + Vector3.new(0, 4, 3)
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end
                    end
                end
            end

            if Settings.AutoStealLabEggs then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and (obj.Parent.Name:lower():find("lab") or obj.ObjectText:lower():find("lab")) then
                        local p = obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart", true)
                        if p then
                            smoothMoveTo(p.CFrame + Vector3.new(0, 2, 0))
                            fireproximityprompt(obj)
                        end
                    end
                end
            end

            if Settings.AutoTradeInLab then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.ActionText:lower():find("trade") then
                        local p = obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart", true)
                        if p then fireproximityprompt(obj) end
                    end
                end
            end
        end)
    end
end)

-- GODMODE HANDLER
RunService.Stepped:Connect(function()
    if Settings.Godmode then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                end
            end
        end)
    end
end)

Rayfield:Notify({
    Title = "SYADZZ HUB (Pro Edition)",
    Content = "Successfully Loaded! Smooth Tween & Dashboard Active.",
    Duration = 5,
})
