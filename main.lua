-- ===================================================
-- SYADHUB VVIP (ULTRA FAST + AUTO GLIDER TO SAFE ZONE)
-- ===================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Hapus GUI lama jika ada
if CoreGui:FindFirstChild("SyadHubGui") then
    CoreGui.SyadHubGui:Destroy()
end

-- Target Koordinat Safe Zone
local SafeZoneVector = Vector3.new(-72.5000153, 3, 0)

-- Variabel Custom Title
_G.CustomTitleText = "🎥 STREAMING 🎥"
_G.AutoGliderActive = false
_G.TitleActive = true
_G.FastSwingActive = false

-- =============================================
-- 1. TAMPILAN GUI SYADHUB (AVATAR & NAMA DINAMIS)
-- =============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SyadHubGui"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 285) -- Ukuran diperbesar sedikit untuk input title
MainFrame.Position = UDim2.new(0.5, -130, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- Foto Avatar Dinamis
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 45, 0, 45)
AvatarImage.Position = UDim2.new(0.06, 0, 0.04, 0)
AvatarImage.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
AvatarImage.Parent = MainFrame

Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 180, 0, 22)
Title.Position = UDim2.new(0.28, 0, 0.04, 0)
Title.BackgroundTransparency = 1
Title.Text = "SYADHUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local UserText = Instance.new("TextLabel")
UserText.Size = UDim2.new(0, 180, 0, 18)
UserText.Position = UDim2.new(0.28, 0, 0.11, 0)
UserText.BackgroundTransparency = 1
UserText.Text = "@" .. LocalPlayer.Name
UserText.TextColor3 = Color3.fromRGB(180, 180, 180)
UserText.TextSize = 15
UserText.Font = Enum.Font.SourceSans
UserText.TextXAlignment = Enum.TextXAlignment.Left
UserText.Parent = MainFrame

local Line = Instance.new("Frame")
Line.Size = UDim2.new(0, 228, 0, 1)
Line.Position = UDim2.new(0.06, 0, 0.21, 0)
Line.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- Input Box untuk Custom Title
local TitleInput = Instance.new("TextBox")
TitleInput.Size = UDim2.new(0.88, 0, 0, 32)
TitleInput.Position = UDim2.new(0.06, 0, 0.25, 0)
TitleInput.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
TitleInput.Text = _G.CustomTitleText
TitleInput.PlaceholderText = "Ketik Custom Title Disini..."
TitleInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleInput.TextSize = 15
TitleInput.Font = Enum.Font.SourceSans
TitleInput.Parent = MainFrame

Instance.new("UICorner", TitleInput).CornerRadius = UDim.new(0, 8)

-- Tombol Fitur
local ToggleTitle = Instance.new("TextButton")
ToggleTitle.Size = UDim2.new(0.88, 0, 0, 34)
ToggleTitle.Position = UDim2.new(0.06, 0, 0.38, 0)
ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
ToggleTitle.Text = "STREAMING TITLE: ON"
ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTitle.TextSize = 12
ToggleTitle.Font = Enum.Font.SourceSansBold
ToggleTitle.Parent = MainFrame

Instance.new("UICorner", ToggleTitle).CornerRadius = UDim.new(0, 8)

local ToggleSwing = Instance.new("TextButton")
ToggleSwing.Size = UDim2.new(0.88, 0, 0, 34)
ToggleSwing.Position = UDim2.new(0.06, 0, 0.52, 0)
ToggleSwing.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleSwing.Text = "SUPER FAST SWING: OFF"
ToggleSwing.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleSwing.TextSize = 12
ToggleSwing.Font = Enum.Font.SourceSansBold
ToggleSwing.Parent = MainFrame

Instance.new("UICorner", ToggleSwing).CornerRadius = UDim.new(0, 8)

local ToggleGlider = Instance.new("TextButton")
ToggleGlider.Size = UDim2.new(0.88, 0, 0, 34)
ToggleGlider.Position = UDim2.new(0.06, 0, 0.66, 0)
ToggleGlider.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
ToggleGlider.Text = "AUTO GLIDER: OFF"
ToggleGlider.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGlider.TextSize = 12
ToggleGlider.Font = Enum.Font.SourceSansBold
ToggleGlider.Parent = MainFrame

Instance.new("UICorner", ToggleGlider).CornerRadius = UDim.new(0, 8)

-- Update teks title secara langsung ketika mengetik di TextBox
TitleInput:GetPropertyChangedSignal("Text"):Connect(function()
    _G.CustomTitleText = TitleInput.Text
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        local tag = char.Head:FindFirstChild("SyadTitleTag")
        if tag and tag:FindFirstChild("TextLabel") then
            tag.TextLabel.Text = _G.CustomTitleText
        end
    end
end)

-- =============================================
-- 2. LOGIKA AUTO GLIDER KE SAFE ZONE
-- =============================================
ToggleGlider.MouseButton1Click:Connect(function()
    _G.AutoGliderActive = not _G.AutoGliderActive
    if _G.AutoGliderActive then
        ToggleGlider.Text = "AUTO GLIDER: ON"
        ToggleGlider.BackgroundColor3 = Color3.fromRGB(40, 190, 40)
    else
        ToggleGlider.Text = "AUTO GLIDER: OFF"
        ToggleGlider.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
    end
end)

-- Fungsi Glider (Terbang halus dengan kecepatan tinggi menuju Safe Zone)
local function startGlidingToSafeZone()
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        
        local targetPos = SafeZoneVector
        while (hrp.Position - targetPos).Magnitude > 5 and _G.AutoGliderActive do
            local direction = (targetPos - hrp.Position).Unit
            hrp.CFrame = hrp.CFrame + (direction * 3.5)
            RunService.RenderStepped:Wait()
        end
    end)
end

-- Deteksi Tombol "LARI!" / "Jatuhkan" untuk Glider
task.spawn(function()
    while true do
        if _G.AutoGliderActive then
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                            local txt = gui.Name:lower() .. " " .. gui.Text:lower()
                            if (txt:find("jatuhkan") or txt:find("drop") or txt:find("lari")) and gui.Visible then
                                startGlidingToSafeZone()
                                task.wait(1.5)
                                break
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- =============================================
-- 3. LOGIKA STREAMING TITLE & FAST SWING
-- =============================================
local function applyTitle()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        if _G.TitleActive then
            local billboard = head:FindFirstChild("SyadTitleTag")
            if not billboard then
                billboard = Instance.new("BillboardGui")
                billboard.Name = "SyadTitleTag"
                billboard.Adornee = head
                billboard.Size = UDim2.new(0, 300, 0, 70)
                billboard.StudsOffset = Vector3.new(0, 3.2, 0)
                billboard.AlwaysOnTop = true
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = _G.CustomTitleText
                textLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
                textLabel.TextStrokeTransparency = 0.1
                textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                textLabel.TextSize = 22
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.Parent = billboard
                
                billboard.Parent = head
            else
                if billboard:FindFirstChild("TextLabel") then
                    billboard.TextLabel.Text = _G.CustomTitleText
                end
            end
        end
    end)
end

ToggleSwing.MouseButton1Click:Connect(function()
    _G.FastSwingActive = not _G.FastSwingActive
    if _G.FastSwingActive then
        ToggleSwing.Text = "SUPER FAST SWING: ON"
        ToggleSwing.BackgroundColor3 = Color3.fromRGB(40, 190, 40)
    else
        ToggleSwing.Text = "SUPER FAST SWING: OFF"
        ToggleSwing.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

ToggleTitle.MouseButton1Click:Connect(function()
    _G.TitleActive = not _G.TitleActive
    if _G.TitleActive then
        ToggleTitle.Text = "STREAMING TITLE: ON"
        ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
        applyTitle()
    else
        ToggleTitle.Text = "STREAMING TITLE: OFF"
        ToggleTitle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Head") then
            local tag = char.Head:FindFirstChild("SyadTitleTag")
            if tag then tag:Destroy() end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.TitleActive then applyTitle() end
end)

-- Fast Swing Optimization
task.spawn(function()
    while true do
        if _G.FastSwingActive then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end)
            task.wait(0.05)
        else
            task.wait(0.3)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.FastSwingActive then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                            track:AdjustSpeed(3.5)
                        end
                    end
                end
            end
        end)
    end
end)

print("SyadHub Auto Glider & Custom Title Loaded!")
