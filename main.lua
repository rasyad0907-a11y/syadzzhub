--// SYADZZ HUB - SILENT BYPASS EDITION (STEAL AN EGG)
--// Menggunakan metode manipulasi jarak ProximityPrompt tanpa teleport karakter

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP GUI LAMA
pcall(function()
    if CoreGui:FindFirstChild("SyadzzBypassHub") then
        CoreGui.SyadzzBypassHub:Destroy()
    end
end)

-- 2. LOAD RAYFIELD UI LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚 [Bypass Mode]",
    LoadingTitle = "Loading Silent Bypass...",
    LoadingSubtitle = "by Syadholicc",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Settings = {
    AutoStealSilent = false,
    AutoWisp = false
}

local function isRealEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    local parentName = prompt.Parent and prompt.Parent.Name:lower() or ""
    if parentName:find("wisp") or parentName:find("machine") or parentName:find("lab") then return false end
    if parentName:find("egg") or prompt.ObjectText:lower():find("egg") then return true end
    return false
end

-- TABS
local FarmTab = Window:CreateTab("Silent Farm", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

FarmTab:CreateToggle({
    Name = "Auto Steal (Silent / No Teleport)",
    CurrentValue = false,
    Callback = function(v) Settings.AutoStealSilent = v end,
})

MiscTab:CreateToggle({
    Name = "Auto Wisp Event",
    CurrentValue = false,
    Callback = function(v) Settings.AutoWisp = v end,
})

-- SILENT TRIGGER LOOP (TIDAK MEMINDAHKAN KARAKTER)
task.spawn(function()
    while task.wait(0.4) do
        if Settings.AutoStealSilent then
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if isRealEggPrompt(obj) then
                        pcall(function()
                            -- Memperbesar jangkauan aktivasi agar bisa diambil dari jarak jauh tanpa teleport
                            obj.MaxActivationDistance = 999999
                            obj.RequiresLineOfSight = false
                            fireproximityprompt(obj)
                        end)
                    end
                end
            end)
        end
    end
end)

-- WISP SILENT TRIGGER
task.spawn(function()
    while task.wait(0.5) do
        if Settings.AutoWisp then
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent.Name:lower():find("wisp") then
                        pcall(function()
                            obj.MaxActivationDistance = 999999
                            obj.RequiresLineOfSight = false
                            fireproximityprompt(obj)
                        end)
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({
    Title = "SYADZZ HUB (Bypass)",
    Content = "Silent Mode Active! No Teleportation Used.",
    Duration = 5,
})
