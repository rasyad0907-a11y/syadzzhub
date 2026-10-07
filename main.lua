--// SYADZZ HUB (Rayfield UI Library Edition)
--// Menggunakan UI Library Modern + Anti Lag + Full Feature

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
local function isRealEggPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    
    local parent = prompt.Parent
    local parentName = parent and parent.Name:lower() or ""
    local grandParentName = (parent and parent.Parent) and parent.Parent.Name:lower() or ""
    local objectText = prompt.ObjectText:lower()
    local actionText = prompt.ActionText:lower()

    -- BLOKIR: Event, Quest, Machine, Wisp, Chest, Daily, Shop
    if parentName:find("wisp") or parentName:find("machine") or parentName:find("quest") or 
       parentName:find("chest") or parentName:find("free") or parentName:find("gratis") or 
       grandParentName:find("wisp") or grandParentName:find("machine") or grandParentName:find("quest") then
        return false
    end
    
    if objectText:find("wisp") or objectText:find("quest") or objectText:find("machine") or 
       actionText:find("claim") or actionText:find("open") or actionText:find("buka") then
        return false
    end

    -- TERIMA: Hanya jika ada kata Egg / Steal
    if parentName:find("egg") or objectText:find("egg") or actionText:find("steal") or actionText:find("curi") or actionText:find("take") then
        return true
    end

    return false
end

-- TABS
local StealTab = Window:CreateTab("Steal", 4483362458)
local FilterTab = Window:CreateTab("Filter Tools", 4483362458)

-- STEAL TAB
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
   Options = {"Teleport","Instant"},
   CurrentOption = {"Teleport"},
   MultipleOptions = false,
   Callback = function(Option)
      Settings.StealMethod = Option[1]
   end,
})

StealTab:CreateButton({
   Name = "Teleport to Nearest Egg",
   Callback = function()
      local char = LocalPlayer.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
          local targetCFrame = nil
          local shortestDistance = math.huge

          for _, obj in pairs(Workspace:GetDescendants()) do
              if isRealEggPrompt(obj) and obj.Parent then
                  local part = obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart", true)
                  if part then
                      local dist = (char.HumanoidRootPart.Position - part.Position).Magnitude
                      if dist > 5 and dist < shortestDistance then
                          shortestDistance = dist
                          targetCFrame = part.CFrame
                      end
                  end
              end
          end

          if targetCFrame then
              char.HumanoidRootPart.CFrame = targetCFrame + Vector3.new(0, 3, 0)
          end
      end
   end,
})

-- FILTER TAB
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
                    if isRealEggPrompt(obj) then
                        if Settings.StealMethod == "Teleport" and obj.Parent and obj.Parent:IsA("BasePart") then
                            char.HumanoidRootPart.CFrame = obj.Parent.CFrame + Vector3.new(0, 2, 0)
                        end
                        fireproximityprompt(obj)
                    end
                end
            end)
        end
    end
end)

-- Auto Place ke Pen
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoPlace then
            pcall(function()
                local myPlot = Workspace:FindFirstChild("Plots") and Workspace.Plots:FindFirstChild(LocalPlayer.Name)
                if myPlot and myPlot:FindFirstChild("Pen") then
                    local penCFrame = myPlot.Pen.CFrame
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChildOfClass("Tool") then
                        char.HumanoidRootPart.CFrame = penCFrame + Vector3.new(0, 3, 0)
                    end
                end
            end)
        end
    end
end)
