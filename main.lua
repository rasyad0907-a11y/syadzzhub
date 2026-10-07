--// SYADZZ HUB - AUTO CLEANUP & RAYFIELD LOADER (ALL FEATURES OFF BY DEFAULT)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 1. CLEANUP GUI LAMA JIKA ADA
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

local Window = Rayfield:CreateWindow({
    Name = "SYADZZ HUB | Steal an Egg",
    LoadingTitle = "SYADZZ HUB Loading...",
    LoadingSubtitle = "by Syadzz",
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

-- ALL SETTINGS OFF BY DEFAULT
local Settings = {
    -- Steal Tab
    TeleportSteal = false,
    AutoSteal = false,
    Godmode = false,
    AutoPlace = false,
    AntiHitGuard = false,
    AutoTreadmill = false,
    StealMethod = "Glide",
    StealSpeed = 100,

    -- Filter Tools
    PetNames = "All",
    Areas = "All",
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
    MinEggKG = "0",

    -- Sell Eggs & Pets
    AutoSellEgg = false,
    AutoSellPet = false,

    -- Wisp Event
    AutoQuest = false,
    AutoClaimNet = false,
    ButterflyESP = false,
    AutoCatch = false,
    AutoChaseButterflies = false,
    AutoTradeUp = false,
    AutoCraftEssence = false
}

-- HELPER FUNCTIONS
local function isRealEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    
    local parent = prompt.Parent
    local parentName = parent and parent.Name:lower() or ""
    local grandParentName = (parent and parent.Parent) and parent.Parent.Name:lower() or ""
    local objectText = prompt.ObjectText:lower()
    local actionText = prompt.ActionText:lower()

    if parentName:find("wisp") or parentName:find("machine") or parentName:find("quest") or 
       parentName:find("chest") or parentName:find("free") or parentName:find("gratis") or 
       grandParentName:find("wisp") or grandParentName:find("machine") or grandParentName:find("quest") then
        return false
    end
    
    if objectText:find("wisp") or objectText:find("quest") or objectText:find("machine") or 
       actionText:find("claim") or actionText:find("open") or actionText:find("buka") then
        return false
    end

    if parentName:find("egg") or objectText:find("egg") or actionText:find("steal") or actionText:find("curi") or actionText:find("take") then
        return true
    end

    return false
end

-- TABS
local StealTab = Window:CreateTab("Steal", 4483362458)
local SellTab = Window:CreateTab("Sell Eggs & Pets", 4483362458)
local WispTab = Window:CreateTab("Wisp Event", 4483362458)

-- 1. STEAL TAB UI
StealTab:CreateToggle({
    Name = "Teleport Steal",
    CurrentValue = false,
    Callback = function(Value) Settings.TeleportSteal = Value end,
})

StealTab:CreateToggle({
    Name = "Auto Steal Eggs",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoSteal = Value end,
})

StealTab:CreateToggle({
    Name = "Real Godmode (Aura Bat, Anti Ragdoll)",
    CurrentValue = false,
    Callback = function(Value) Settings.Godmode = Value end,
})

StealTab:CreateToggle({
    Name = "Auto Place to Pen",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoPlace = Value end,
})

StealTab:CreateToggle({
    Name = "Anti Hit Guard",
    CurrentValue = false,
    Callback = function(Value) Settings.AntiHitGuard = Value end,
})

StealTab:CreateToggle({
    Name = "Auto Treadmill",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoTreadmill = Value end,
})

StealTab:CreateDropdown({
    Name = "Steal Method",
    Options = {"Glide", "Teleport", "Instant"},
    CurrentOption = {"Glide"},
    MultipleOptions = false,
    Callback = function(Option) Settings.StealMethod = Option[1] end,
})

StealTab:CreateSlider({
    Name = "Auto Steal Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 100,
    Callback = function(Value) Settings.StealSpeed = Value end,
})

-- FILTER SECTION INSIDE STEAL TAB
StealTab:CreateSection("Filter Tools")

StealTab:CreateDropdown({
    Name = "Pet Names",
    Options = {"All (none)", "Custom"},
    CurrentOption = {"All (none)"},
    MultipleOptions = false,
    Callback = function(Option) Settings.PetNames = Option[1] end,
})

StealTab:CreateDropdown({
    Name = "Areas",
    Options = {"All (none)", "Enchanted Forest", "Light Dark", "Titan Temple", "Cherry Blossom", "Cosmic", "Prehistoric", "Abyss Ocean", "Volcano", "Snow", "Jungle", "Desert", "Lake"},
    CurrentOption = {"All (none)"},
    MultipleOptions = false,
    Callback = function(Option) Settings.Areas = Option[1] end,
})

local rarities = {"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare", "SuperRare", "Uncommon"}
for _, rarity in ipairs(rarities) do
    StealTab:CreateToggle({
        Name = "Filter: " .. rarity,
        CurrentValue = false,
        Callback = function(Value) Settings.Rarities[rarity] = Value end,
    })
end

StealTab:CreateDropdown({
    Name = "Priority",
    Options = {"Rarity", "Value", "Distance"},
    CurrentOption = {"Rarity"},
    MultipleOptions = false,
    Callback = function(Option) Settings.Priority = Option[1] end,
})

StealTab:CreateInput({
    Name = "Min Value (ex: 1M/1B)",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) Settings.MinValue = Text end,
})

StealTab:CreateInput({
    Name = "Min Egg KG (0 = off)",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text) Settings.MinEggKG = Text end,
})

-- 2. SELL EGGS & PETS TAB UI
SellTab:CreateSection("Sell Egg Filter")

SellTab:CreateToggle({
    Name = "Auto Sell Egg",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoSellEgg = Value end,
})

SellTab:CreateButton({
    Name = "Sell Eggs Now",
    Callback = function()
        -- Trigger event jual telur
    end,
})

SellTab:CreateSection("Sell Pet Filter")

SellTab:CreateToggle({
    Name = "Auto Sell Pet",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoSellPet = Value end,
})

SellTab:CreateButton({
    Name = "Sell Pets Now",
    Callback = function()
        -- Trigger event jual pet
    end,
})

-- 3. WISP EVENT TAB UI
WispTab:CreateSection("Wisp Quest")

WispTab:CreateToggle({
    Name = "Auto Quest",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoQuest = Value end,
})

WispTab:CreateSection("Butterfly Bloom")

WispTab:CreateToggle({
    Name = "Auto Claim Net",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoClaimNet = Value end,
})

WispTab:CreateToggle({
    Name = "Butterfly ESP",
    CurrentValue = false,
    Callback = function(Value) Settings.ButterflyESP = Value end,
})

WispTab:CreateToggle({
    Name = "Auto Catch",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoCatch = Value end,
})

WispTab:CreateToggle({
    Name = "Auto Chase Butterflies",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoChaseButterflies = Value end,
})

WispTab:CreateSection("Trade & Craft")

WispTab:CreateToggle({
    Name = "Auto Trade Up (after bloom)",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoTradeUp = Value end,
})

WispTab:CreateToggle({
    Name = "Auto Craft Essence (after bloom)",
    CurrentValue = false,
    Callback = function(Value) Settings.AutoCraftEssence = Value end,
})

-- CORE BACKEND LOGIC (Hanya berjalan jika Setting di-ON-kan)

-- Auto Steal Loop
task.spawn(function()
    while task.wait(0.1 / (Settings.StealSpeed / 50)) do
        if Settings.AutoSteal or Settings.TeleportSteal then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                for _, obj in pairs(Workspace:GetDescendants()) do
                    if isRealEggPrompt(obj) then
                        local eggPart = obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart", true)
                        if eggPart then
                            if Settings.StealMethod == "Glide" or Settings.StealMethod == "Teleport" then
                                char.HumanoidRootPart.CFrame = eggPart.CFrame + Vector3.new(0, 2.5, 0)
                                task.wait(0.05)
                            end
                            
                            fireproximityprompt(obj)
                            task.wait(0.1)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Place Loop
task.spawn(function()
    while task.wait(0.8) do
        if Settings.AutoPlace then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                
                local hasEgg = char:FindFirstChildOfClass("Tool")
                if hasEgg then
                    local plots = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases")
                    if plots then
                        for _, plot in pairs(plots:GetChildren()) do
                            if plot.Name == LocalPlayer.Name or (plot:FindFirstChild("Owner") and plot.Owner.Value == LocalPlayer) then
                                local pen = plot:FindFirstChild("Pen") or plot:FindFirstChild("EggPen")
                                if pen then
                                    char.HumanoidRootPart.CFrame = pen.CFrame + Vector3.new(0, 3, 0)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Godmode & Anti Ragdoll Loop
RunService.Stepped:Connect(function()
    if Settings.Godmode then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    if hum.PlatformStand then hum.PlatformStand = false end
                end
            end
        end)
    end
end)

-- Auto Treadmill Loop
task.spawn(function()
    while task.wait(0.5) do
        if Settings.AutoTreadmill then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                
                local treadmill = Workspace:FindFirstChild("Treadmill", true)
                if treadmill and treadmill:IsA("BasePart") then
                    char.HumanoidRootPart.CFrame = treadmill.CFrame + Vector3.new(0, 3, 0)
                end
            end)
        end
    end
end)
