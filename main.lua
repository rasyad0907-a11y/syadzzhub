--// SYADZZ HUB - FIXED UI BLANK / MISSING ELEMENTS & ENHANCED ARCHITECTURE

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP GUI LAMA JIKA MASIH ADA
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("SyadzzPrivateScript") then
        LocalPlayer.PlayerGui.SyadzzPrivateScript:Destroy()
    end
    if game:GetService("CoreGui"):FindFirstChild("SyadzzPrivateScript") then
        game:GetService("CoreGui").SyadzzPrivateScript:Destroy()
    end
end)

-- 2. LOAD RAYFIELD UI LIBRARY
local Rayfield
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end

-- ASSET ID UNTUK LOGO
local logoAssetId = "rbxthumb://type=Asset&id=87188655335018&w=420&h=420"

-- 3. CREATE WINDOW WITH LOGO ICON
local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg 🥚",
    Icon = logoAssetId,
    LoadingTitle = "SYADZZ HUB Loading...",
    LoadingSubtitle = "by Syadzz & Syadholicc",
    ConfigurationSaving = { Enabled = false },
    KeySystem = true,
    KeySettings = {
        Title = "SYADZZ HUB - Verification",
        Subtitle = "Masukkan Password",
        Note = "Password: SYADZZ123",
        FileName = "SyadzzKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"SYADZZ123"}
    }
})

-- SETTINGS CONFIGURATION
local Settings = {
    TeleportSteal = false,
    AutoSteal = false,
    Godmode = false,
    AutoPlace = false,
    AntiHitGuard = false,
    AutoTreadmill = false,
    StealMethod = "Glide",
    StealSpeed = 100,

    PetNames = "All (none)",
    SelectedArea = "All (none)",
    Rarities = {
        ["Divine"] = false,
        ["Eternal"] = false,
        ["Secret"] = false,
        ["Cosmic"] = false,
        ["Mythic"] = false,
        ["Legendary"] = false,
        ["Epic"] = false,
        ["Rare"] = false,
        ["SuperRare"] = false,
        ["Uncommon"] = false
    },
    Priority = "Rarity",
    MinValue = "0",
    MinEggKG = "0"
}

-- RARITY WEIGHTS
local RarityWeight = {
    ["Divine"] = 10,
    ["Eternal"] = 9,
    ["Secret"] = 8,
    ["Cosmic"] = 7,
    ["Mythic"] = 6,
    ["Legendary"] = 5,
    ["Epic"] = 4,
    ["Rare"] = 3,
    ["SuperRare"] = 2,
    ["Uncommon"] = 1
}

local ValidAreas = {
    "Enchanted Forest", "Light Dark", "Titan Temple", "Cherry Blossom", 
    "Cosmic", "Prehistoric", "Abyss Ocean", "Volcano", "Snow", "Jungle", "Desert", "Lake"
}

--------------------------------------------------------------------------------
-- HELPER FUNCTIONS & MODULAR LOGIC
--------------------------------------------------------------------------------

local function getMyPlotStrict()
    local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("PlotsFolder")
    if not plotsFolder then return nil end

    for _, plot in pairs(plotsFolder:GetChildren()) do
        local ownerVal = plot:FindFirstChild("Owner") or plot:FindFirstChild("Player") or plot:FindFirstChild("OwnerValue")
        if ownerVal then
            if ownerVal:IsA("ObjectValue") and ownerVal.Value == LocalPlayer then
                return plot
            elseif ownerVal:IsA("StringValue") and (ownerVal.Value == LocalPlayer.Name or ownerVal.Value == LocalPlayer.DisplayName) then
                return plot
            elseif ownerVal:IsA("IntValue") or ownerVal:IsA("NumberValue") then
                if ownerVal.Value == LocalPlayer.UserId then
                    return plot
                end
            end
        end

        local attrOwner = plot:GetAttribute("Owner") or plot:GetAttribute("OwnerUserId") or plot:GetAttribute("Player")
        if attrOwner then
            if tostring(attrOwner) == LocalPlayer.Name or attrOwner == LocalPlayer.UserId then
                return plot
            end
        end

        if plot.Name == LocalPlayer.Name or plot.Name == "Plot_" .. LocalPlayer.Name or plot.Name == tostring(LocalPlayer.UserId) then
            return plot
        end
    end
    return nil
end

local function getMySafeZoneCFrame()
    local myPlot = getMyPlotStrict()
    if myPlot then
        for _, obj in pairs(myPlot:GetDescendants()) do
            local oName = obj.Name:lower()
            if oName:find("zona aman") or oName:find("safezone") or oName:find("safe zone") or oName:find("spawn") then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    return part.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end
        return myPlot:GetPivot() + Vector3.new(0, 3, 0)
    end
    
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.CFrame
end

local function getEggArea(eggObj)
    if not eggObj then return "Unknown" end

    local area
