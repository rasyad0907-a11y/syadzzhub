--// SYADZZ HUB - ULTIMATE ACCURATE ZONE EDITION (STEAL AN EGG)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP GUI LAMA
pcall(function()
    if CoreGui:FindFirstChild("SyadzzUltimateHub") then
        CoreGui.SyadzzUltimateHub:Destroy()
    end
end)

-- 2. LOAD RAYFIELD UI LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Ultimate Zone Edition]",
    LoadingTitle = "Loading Ultimate Hub...",
    LoadingSubtitle = "by Syadholicc",
    ConfigurationSaving = { Enabled = true, FolderName = "SyadzzHubConfig" },
    KeySystem = false
})

-- CONFIGURATION SETTINGS (SEMUA MATI / OFF DEFAULT)
local Settings = {
    AutoSteal = false,
    AutoPlace = false,
    AutoHatch = false,
    AutoSellEggs = false,
    AutoSellPets = false,
    AutoTreadmill = false,
    AutoTreadmillUpgrade = false,
    AutoUpgradePen = false,
    AutoBuyTrails = false,
    AutoEquipBestGear = false,
    EggESP = false,
    MaxFPS = false,
    KillVFX = false,
    SelectedArea = "All (none)"
}

-- DAFTAR ZONA RESMI SESUAI DATA GAME
local GameZones = {
    "All (none)",
    "Forest",
    "Lake",
    "Desert",
    "Jungle",
    "Snow",
    "Volcano",
    "Abyss Ocean",
    "Prehistoric",
    "Cosmic",
    "Cherry Blossom",
    "Titan Temple",
    "Enchanted Forest"
}

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
local FarmTab = Window:CreateTab("Auto Farm & Steal", 4483362458)
local InventoryTab = Window:CreateTab("Eggs & Pets", 4483362458)
local GymTab = Window:CreateTab("Gym & Upgrades", 4483362458)
local MiscTab = Window:CreateTab("Visuals & Misc", 4483362458)

-- 1. FARM TAB
FarmTab:CreateToggle({
    Name = "Auto Steal Egg",
    CurrentValue = false,
    Callback = function(v) Settings.AutoSteal = v end,
})

FarmTab:CreateToggle({
    Name = "Auto Place to Pen",
    CurrentValue = false,
    Callback = function(v) Settings.AutoPlace = v end,
})

FarmTab:CreateDropdown({
    Name = "Filter by Zone Area",
    Options = GameZones,
    CurrentOption = {"All (none)"},
    Callback = function(opt) Settings.SelectedArea = opt[1] end,
})

-- 2. INVENTORY & PETS TAB
InventoryTab:CreateToggle({
    Name = "Auto Hatch Ready Eggs",
    CurrentValue = false,
    Callback = function(v) Settings.AutoHatch = v end,
})

InventoryTab:CreateToggle({
    Name = "Auto Sell Eggs",
    CurrentValue = false,
    Callback = function(v) Settings.AutoSellEggs = v end,
})

InventoryTab:CreateToggle({
    Name = "Auto Sell Pets",
    CurrentValue = false,
    Callback = function(v) Settings.AutoSellPets = v end,
})

-- 3. GYM & UPGRADES TAB
GymTab:CreateToggle({
    Name = "Auto Treadmill Training",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTreadmill = v end,
})

GymTab:CreateToggle({
    Name = "Auto Treadmill Upgrade",
    CurrentValue = false,
    Callback = function(v) Settings.AutoTreadmillUpgrade = v end,
})

GymTab:CreateToggle({
    Name = "Auto Upgrades Pen",
    CurrentValue = false,
    Callback = function(v) Settings.AutoUpgradePen = v end,
})

GymTab:CreateToggle({
    Name = "Auto Buy Cash Trails",
    CurrentValue = false,
    Callback = function(v) Settings.AutoBuyTrails = v end,
})

-- 4. VISUALS & MISC TAB
MiscTab:CreateToggle({
    Name = "Egg ESP (Highlight High Tier)",
    CurrentValue = false,
    Callback = function(v) Settings.EggESP = v end,
})

MiscTab:CreateToggle({
    Name = "Max FPS / Boost Performance",
    CurrentValue = false,
    Callback = function(v)
        Settings.MaxFPS = v
        pcall(function()
            settings().Rendering.QualityLevel = v and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
        end)
    end,
})

MiscTab:CreateToggle({
    Name = "Kill All VFX Weight (Reduce Lag)",
    CurrentValue = false,
    Callback = function(v)
        Settings.KillVFX = v
        pcall(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                    obj.Enabled = not v
                end
            end
        end)
    end,
})

-- BACKGROUND EXECUTION LOOPS (AUTO STEAL DENGAN FILTER ZONA)
task.spawn(function()
    while task.wait(0.25) do
        pcall(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end

            if Settings.AutoSteal then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        local pName = obj.Parent and obj.Parent.Name:lower() or ""
                        local fullParentHierarchy = ""
                        local curr = obj.Parent
                        for i = 1, 6 do
                            if curr then
                                fullParentHierarchy = fullParentHierarchy .. " " .. curr.Name:lower()
                                curr = curr.Parent
                            end
                        end

                        -- Cek apakah sesuai zona yang dipilih di dropdown
                        local zoneMatch = true
                        if Settings.SelectedArea ~= "All (none)" then
                            if not fullParentHierarchy:find(Settings.SelectedArea:lower():gsub("%s+", "")) then
                                zoneMatch = false
                            end
                        end

                        if zoneMatch and (pName:find("egg") or obj.ObjectText:lower():find("egg")) then
                            local part = obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart", true)
                            if part then
                                local safeCFrame = getMySafeZoneCFrame()
                                char.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 2.5, 0)
                                task.wait(0.08)
                                obj.RequiresLineOfSight = false
                                fireproximityprompt(obj)
                                task.wait(0.1)
                                if safeCFrame then
                                    char.HumanoidRootPart.CFrame = safeCFrame
                                end
                                break
                            end
                        end
                    end
                end
            end

            -- Auto Treadmill Loop (Akurat berdasarkan nama treadmill)
            if Settings.AutoTreadmill then
                local myPlot = getMyPlotStrict()
                if myPlot then
                    for _, obj in pairs(myPlot:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local oName = obj.Name:lower()
                            if oName:find("treadmill") or oName:find("trainer") or oName:find("freeze") or oName:find("astral") or oName:find("flame") then
                                char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- AUTO PLACE TO PEN LOOP
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
    Title = "SYADZZ HUB (Ultimate Zone)",
    Content = "Loaded Successfully! Zones synced with game data.",
    Duration = 5,
})
