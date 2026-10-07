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

    local areaAttr = eggObj:GetAttribute("Area") or eggObj:GetAttribute("Zone") or eggObj:GetAttribute("Region")
    if areaAttr then return tostring(areaAttr) end

    local areaVal = eggObj:FindFirstChild("Area") or eggObj:FindFirstChild("Zone") or eggObj:FindFirstChild("Region")
    if areaVal and areaVal:IsA("ValueBase") then
        return tostring(areaVal.Value)
    end

    local curr = eggObj
    while curr and curr ~= Workspace do
        local currNameLower = curr.Name:lower()
        for _, areaName in ipairs(ValidAreas) do
            if currNameLower:find(areaName:lower(), 1, true) then
                return areaName
            end
        end
        
        local parentAttr = curr:GetAttribute("Area") or curr:GetAttribute("Zone")
        if parentAttr then return tostring(parentAttr) end
        
        curr = curr.Parent
    end

    return "Unknown"
end

local function getEggRarityNameAndWeight(eggObj)
    if not eggObj then return "Uncommon", 1 end

    local rarityAttr = eggObj:GetAttribute("Rarity")
    if rarityAttr then
        local rStr = tostring(rarityAttr)
        for rarity, weight in pairs(RarityWeight) do
            if rStr:lower() == rarity:lower() then return rarity, weight end
        end
    end

    if eggObj:FindFirstChild("Rarity") and eggObj.Rarity:IsA("ValueBase") then
        local rStr = tostring(eggObj.Rarity.Value)
        for rarity, weight in pairs(RarityWeight) do
            if rStr:lower() == rarity:lower() then return rarity, weight end
        end
    end

    local fullText = eggObj.Name:lower()
    if eggObj.Parent then fullText = fullText .. " " .. eggObj.Parent.Name:lower() end

    for rarity, weight in pairs(RarityWeight) do
        if fullText:find(rarity:lower(), 1, true) then
            return rarity, weight
        end
    end

    return "Uncommon", 1
end

local function isValidEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    
    local parent = prompt.Parent
    if not parent then return false end
    
    local parentName = parent.Name:lower()
    local objectText = prompt.ObjectText:lower()
    local actionText = prompt.ActionText:lower()

    if parentName:find("wisp") or parentName:find("machine") or parentName:find("quest") or 
       parentName:find("chest") or parentName:find("free") or parentName:find("gratis") or
       objectText:find("wisp") or objectText:find("quest") or actionText:find("claim") or actionText:find("buka") then
        return false
    end

    if parentName:find("egg") or objectText:find("egg") or actionText:find("steal") or actionText:find("curi") or actionText:find("take") then
        return true
    end

    return false
end

local function passesFilters(prompt, eggPart, eggModel)
    if Settings.SelectedArea ~= "All (none)" and Settings.SelectedArea ~= "All" then
        local eggArea = getEggArea(eggModel)
        if eggArea:lower() ~= Settings.SelectedArea:lower() then
            return false
        end
    end

    local activeRarityFilters = {}
    for rName, active in pairs(Settings.Rarities) do
        if active then table.insert(activeRarityFilters, rName:lower()) end
    end

    if #activeRarityFilters > 0 then
        local rName, _ = getEggRarityNameAndWeight(eggModel)
        local matchRarity = false
        for _, filterRarity in ipairs(activeRarityFilters) do
            if rName:lower() == filterRarity or eggModel.Name:lower():find(filterRarity, 1, true) then
                matchRarity = true
                break
            end
        end
        if not matchRarity then return false end
    end

    return true
end

local function getEggTargets()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return {} end
    local hrpPos = char.HumanoidRootPart.Position

    local targets = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if isValidEggPrompt(obj) then
            local eggModel = obj.Parent
            local eggPart = eggModel:IsA("BasePart") and eggModel or eggModel:FindFirstChildWhichIsA("BasePart", true)
            
            if eggPart and passesFilters(obj, eggPart, eggModel) then
                local _, rWeight = getEggRarityNameAndWeight(eggModel)
                local dist = (hrpPos - eggPart.Position).Magnitude
                
                table.insert(targets, {
                    prompt = obj,
                    part = eggPart,
                    model = eggModel,
                    weight = rWeight,
                    dist = dist
                })
            end
        end
    end

    return targets
end

local function sortTargets(targets)
    table.sort(targets, function(a, b)
        if Settings.Priority == "Distance" then
            if math.abs(a.dist - b.dist) > 2 then
                return a.dist < b.dist
            end
            return a.weight > b.weight
        else
            if a.weight ~= b.weight then
                return a.weight > b.weight
            end
            return a.dist < b.dist
        end
    end)
end

--------------------------------------------------------------------------------
-- UI CREATION
--------------------------------------------------------------------------------

local StealTab = Window:CreateTab("Steal", 4483362458)
local FilterTab = Window:CreateTab("Filter Tools", 4483362458)
local ProfileTab = Window:CreateTab("SYADHOLICC", 4483362458)

StealTab:CreateToggle({ Name = "Teleport Steal", CurrentValue = false, Callback = function(Value) Settings.TeleportSteal = Value end })
StealTab:CreateToggle({ Name = "Auto Steal Eggs", CurrentValue = false, Callback = function(Value) Settings.AutoSteal = Value end })
StealTab:CreateToggle({ Name = "Real Godmode (Aura Bat, Anti Ragdoll)", CurrentValue = false, Callback = function(Value) Settings.Godmode = Value end })
StealTab:CreateToggle({ Name = "Auto Place to Pen", CurrentValue = false, Callback = function(Value) Settings.AutoPlace = Value end })
StealTab:CreateToggle({ Name = "Anti Hit Guard", CurrentValue = false, Callback = function(Value) Settings.AntiHitGuard = Value end })
StealTab:CreateToggle({ Name = "Auto Treadmill (Plot Sendiri Only)", CurrentValue = false, Callback = function(Value) Settings.AutoTreadmill = Value end })

StealTab:CreateDropdown({ Name = "Steal Method", Options = {"Glide", "Teleport", "Instant"}, CurrentOption = {"Glide"}, MultipleOptions = false, Callback = function(Option) Settings.StealMethod = Option[1] end })
StealTab:CreateDropdown({ Name = "Priority", Options = {"Rarity", "Distance"}, CurrentOption = {"Rarity"}, MultipleOptions = false, Callback = function(Option) Settings.Priority = Option[1] end })
StealTab:CreateSlider({ Name = "Auto Steal Speed", Range = {1, 100}, Increment = 1, Suffix = "%", CurrentValue = 100, Callback = function(Value) Settings.StealSpeed = Value end })

FilterTab:CreateDropdown({ Name = "Pet Names", Options = {"All (none)", "Custom"}, CurrentOption = {"All (none)"}, MultipleOptions = false, Callback = function(Option) Settings.PetNames = Option[1] end })
FilterTab:CreateDropdown({ Name = "Areas", Options = {"All (none)", "Enchanted Forest", "Light Dark", "Titan Temple", "Cherry Blossom", "Cosmic", "Prehistoric", "Abyss Ocean", "Volcano", "Snow", "Jungle", "Desert", "Lake"}, CurrentOption = {"All (none)"}, MultipleOptions = false, Callback = function(Option) Settings.SelectedArea = Option[1] end })

for _, rarity in ipairs({"Divine", "Eternal", "Secret", "Cosmic", "Mythic", "Legendary", "Epic", "Rare", "SuperRare", "Uncommon"}) do
    FilterTab:CreateToggle({ Name = "Filter: " .. rarity, CurrentValue = false, Callback = function(Value) Settings.Rarities[rarity] = Value end })
end

ProfileTab:CreateSection("SYADHOLICC Official Logo")
ProfileTab:CreateLabel("Owner: SYADHOLICC")
pcall(function() ProfileTab:CreateImage({ Name = "SYADHOLICC Logo", Image = logoAssetId }) end)

--------------------------------------------------------------------------------
-- LOOPS & EXECUTION
--------------------------------------------------------------------------------

task.spawn(function()
    while task.wait(0.2) do
        if Settings.AutoSteal or Settings.TeleportSteal then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                local targets = getEggTargets()
                if #targets == 0 then return end

                sortTargets(targets)
                local target = targets[1]
                local safeZoneCFrame = getMySafeZoneCFrame()

                if Settings.AntiHitGuard then
                    for _, p in pairs(char:GetChildren()) do
                        if p:IsA("BasePart") then p.CanTouch = false end
                    end
                end

                local targetCFrame = target.part.CFrame * CFrame.new(0, 2.5, 0)
                if Settings.StealMethod == "Instant" or Settings.StealMethod == "Teleport" then
                    hrp.CFrame = targetCFrame
                else
                    local speedFactor = math.clamp(Settings.StealSpeed / 100, 0.1, 1)
                    local dist = (hrp.Position - targetCFrame.Position).Magnitude
                    local duration = math.clamp(dist / (50 * speedFactor), 0.1, 3)
                    
                    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                    tween:Play()
                    tween.Completed:Wait()
                end

                task.wait(0.05)
                target.prompt.RequiresLineOfSight = false
                fireproximityprompt(target.prompt)
                task.wait(0.1)

                if safeZoneCFrame then
                    hrp.CFrame = safeZoneCFrame
                end

                if Settings.AntiHitGuard then
                    for _, p in pairs(char:GetChildren()) do
                        if p:IsA("BasePart") then p.CanTouch = true end
                    end
                end
            end)
        end
    end
end)

local function findMyTreadmill()
    local myPlot = getMyPlotStrict()
    if not myPlot then return nil end

    for _, obj in pairs(myPlot:GetDescendants()) do
        local oName = obj.Name:lower()
        if oName:find("treadmill") or oName:find("trainer") or oName:find("tread") then
            return obj
        end
    end
    return nil
end

local function activateTreadmill(treadmillObj)
    if not treadmillObj then return end
    local prompt = treadmillObj:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then fireproximityprompt(prompt) return end

    local cd = treadmillObj:FindFirstChildWhichIsA("ClickDetector", true)
    if cd then fireclickdetector(cd) return end

    local part = treadmillObj:IsA("BasePart") and treadmillObj or treadmillObj:FindFirstChildWhichIsA("BasePart", true)
    local char = LocalPlayer.Character
    if part and char and char:FindFirstChild("HumanoidRootPart") then
        local pos = part.CFrame.Position + Vector3.new(0, 2.8, 0)
        char.HumanoidRootPart.CFrame = CFrame.new(pos, pos + part.CFrame.LookVector)
        char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    end
end

task.spawn(function()
    while task.wait(0.3) do
        if Settings.AutoTreadmill then
            pcall(function()
                local treadmill = findMyTreadmill()
                if treadmill then activateTreadmill(treadmill) end
            end)
        end
    end
end)

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

RunService.Stepped:Connect(function()
    if Settings.Godmode then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    if humanoid:GetState() == Enum.HumanoidStateType.Ragdoll or humanoid:GetState() == Enum.HumanoidStateType.FallingDown then
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
            end
        end)
    end
end)

Rayfield:Notify({
    Title = "SYADZZ HUB",
    Content = "Script successfully loaded!",
    Duration = 5,
    Image = logoAssetId
})
