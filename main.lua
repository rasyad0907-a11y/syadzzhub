--// SYADZZ HUB (Nasi Rendang Style Remake)
--// Menggunakan Rayfield UI Library

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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

-- SERVICES & VARIABLES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local Settings = {
    AutoSteal = false,
    AutoPlace = false,
    StealMethod = "Teleport",
    SelectedRarities = {
        ["Divine"] = true,
        ["Eternal"] = true,
        ["Secret"] = true
    }
}

-- HELPER FUNCTIONS
local function checkEggRarity(eggModel)
    if not eggModel then return false end
    
    -- Cek atribut atau tag rarity dari nama/anak objek
    local eggName = eggModel.Name:lower()
    for rarity, enabled in pairs(Settings.SelectedRarities) do
        if enabled and eggName:find(rarity:lower()) then
            return true
        end
    end
    return true -- Default allow jika tidak terfilter
end

-- TABS
local StealTab = Window:CreateTab("Steal", 4483362458)
local FilterTab = Window:CreateTab("Filter Tools", 4483362458)

-- STEAL TAB TOGGLES
StealTab:CreateToggle({
   Name = "Auto Steal Eggs",
   CurrentValue = false,
   Callback = function(Value)
      Settings.AutoSteal = Value
   end,
})

StealTab:CreateToggle({
   Name = "Auto Place to Pen",
   CurrentValue = false,
   Callback = function(Value)
      Settings.AutoPlace = Value
   end,
})

StealTab:CreateDropdown({
   Name = "Steal Method",
   Options = {"Teleport","Glide","Instant"},
   CurrentOption = {"Teleport"},
   MultipleOptions = false,
   Callback = function(Option)
      Settings.StealMethod = Option[1]
   end,
})

-- FILTER TAB CHECKBOXES
FilterTab:CreateToggle({
   Name = "Filter: Divine",
   CurrentValue = true,
   Callback = function(Value) Settings.SelectedRarities["Divine"] = Value end,
})

FilterTab:CreateToggle({
   Name = "Filter: Eternal",
   CurrentValue = true,
   Callback = function(Value) Settings.SelectedRarities["Eternal"] = Value end,
})

FilterTab:CreateToggle({
   Name = "Filter: Secret",
   CurrentValue = true,
   Callback = function(Value) Settings.SelectedRarities["Secret"] = Value end,
})

-- CORE LOOPS
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoSteal then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Parent then
                        local parent = obj.Parent
                        -- Filter hanya telur & bukan mesin/event/wisp
                        if parent.Name:lower():find("egg") and checkEggRarity(parent) then
                            if Settings.StealMethod == "Teleport" then
                                char.HumanoidRootPart.CFrame = parent.CFrame + Vector3.new(0, 2, 0)
                            end
                            fireproximityprompt(obj)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Place ke Pen (Disesuaikan posisi kandang sendiri)
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoPlace then
            pcall(function()
                -- Mengirim remote penempatan ke server jika memegang telur
                local myPlot = Workspace:FindFirstChild("Plots") and Workspace.Plots:FindFirstChild(LocalPlayer.Name)
                if myPlot and myPlot:FindFirstChild("Pen") then
                    local penCFrame = myPlot.Pen.CFrame
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChildOfClass("Tool") then
                        -- Teleport presisi tepat di dalam zona Pen milik sendiri agar tidak gagal
                        char.HumanoidRootPart.CFrame = penCFrame + Vector3.new(0, 3, 0)
                    end
                end
            end)
        end
    end
end)
