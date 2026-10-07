```lua
-- SYADZZ AUTO STEAL
-- Untuk game milik sendiri di Roblox Studio

local Players = game:GetService("Players")

local EggsFolder = workspace:WaitForChild("Eggs")
local PensFolder = workspace:WaitForChild("Pens")

local CONFIG = {
    Enabled = true,
    AutoStealEggs = true,
    StealFromPlayers = true,
    AutoPlaceToPen = true,

    ForceSpeedTo = 28,
    AutoStealSpeed = 0.5,
    MaxDistance = 30,

    -- Gunakan "*" untuk menerima semua.
    PetNames = {
        ["*"] = true,
    },

    Areas = {
        ["*"] = true,
    },

    Rarities = {
        ["*"] = true,
    },

    -- Angka lebih kecil = prioritas lebih tinggi.
    Priority = {
        ["Mythic Egg"] = 1,
        ["Legendary Egg"] = 2,
        ["Golden Egg"] = 3,
    },
}

local lastSteal = {}

local function allowed(value, filter)
    return filter["*"] == true or filter[value] == true
end

local function getRoot(player)
    local character = player.Character
    return character
        and character:FindFirstChild("HumanoidRootPart")
end

local function getEggPosition(egg)
    if egg:IsA("BasePart") then
        return egg.Position
    end

    if egg:IsA("Model") then
        local part = egg.PrimaryPart
            or egg:FindFirstChildWhichIsA(
                "BasePart", true
            )

        return part and part.Position
    end

    return nil
end

local function getEggName(egg)
    return egg:GetAttribute("EggName")
        or egg:GetAttribute("PetName")
        or egg.Name
end

local function getPriority(egg)
    return CONFIG.Priority[getEggName(egg)]
        or 999
end

local function getPen(player)
    local pen = PensFolder:FindFirstChild(player.Name)

    if not pen then
        return nil
    end

    return pen:FindFirstChild("DropPoint")
        or pen:FindFirstChildWhichIsA("BasePart", true)
end

local function placeInPen(egg, player)
    if not CONFIG.AutoPlaceToPen then
        return true
    end

    local dropPoint = getPen(player)

    if not dropPoint then
        warn("Pen tidak ditemukan untuk " .. player.Name)
        return false
    end

    local destination =
        dropPoint.CFrame + Vector3.new(0, 2, 0)

    if egg:IsA("Model") then
        egg:PivotTo(destination)
    elseif egg:IsA("BasePart") then
        egg.CFrame = destination
    else
        return false
    end

    egg:SetAttribute("OwnerUserId", player.UserId)
    egg:SetAttribute("PlacedInPen", true)

    return true
end

local function isValidEgg(egg, player)
    local owner = egg:GetAttribute("OwnerUserId") or 0

    if owner == player.UserId then
        return false
    end

    if owner ~= 0 and not CONFIG.StealFromPlayers then
        return false
    end

    if not allowed(
        tostring(getEggName(egg)),
        CONFIG.PetNames
    ) then
        return false
    end

    if not allowed(
        tostring(egg:GetAttribute("Area") or ""),
        CONFIG.Areas
    ) then
        return false
    end

    if not allowed(
        tostring(egg:GetAttribute("Rarity") or ""),
        CONFIG.Rarities
    ) then
        return false
    end

    return true
end

local function findTarget(player)
    local root = getRoot(player)
    if not root then
        return nil
    end

    local bestEgg
    local bestPriority = math.huge
    local bestDistance = math.huge

    for _, egg in ipairs(EggsFolder:GetChildren()) do
        if isValidEgg(egg, player) then
            local position = getEggPosition(egg)

            if position then
                local distance =
                    (root.Position - position).Magnitude

                local priority = getPriority(egg)

                if distance <= CONFIG.MaxDistance then
                    if priority < bestPriority
                        or (
                            priority == bestPriority
                            and distance < bestDistance
                        )
                    then
                        bestEgg = egg
                        bestPriority = priority
                        bestDistance = distance
                    end
                end
            end
        end
    end

    return bestEgg
end

local function processPlayer(player)
    task.spawn(function()
        while player.Parent do
            if CONFIG.Enabled then
                local character = player.Character
                local humanoid = character
                    and character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.WalkSpeed = CONFIG.ForceSpeedTo
                end

                if CONFIG.AutoStealEggs then
                    local now = os.clock()
                    local previous =
                        lastSteal[player.UserId] or 0

                    if now - previous >= CONFIG.AutoStealSpeed then
                        local egg = findTarget(player)

                        if egg then
                            local root = getRoot(player)
                            local position = getEggPosition(egg)

                            -- Validasi ulang sebelum memproses.
                            if root and position
                                and (root.Position - position).Magnitude
                                    <= CONFIG.MaxDistance
                            then
                                lastSteal[player.UserId] = now

                                egg:SetAttribute(
                                    "OwnerUserId",
                                    player.UserId
                                )

                                egg:SetAttribute(
                                    "LastStealAt",
                                    os.time()
                                )

                                if placeInPen(egg, player) then
                                    print(
                                        "[SYADZZ] "
                                        .. player.Name
                                        .. " mengambil "
                                        .. getEggName(egg)
                                    )
                                end
                            end
                        end
                    end
                end
            end

            task.wait(0.1)
        end

        lastSteal[player.UserId] = nil
    end)
end

Players.PlayerAdded:Connect(processPlayer)

Players.PlayerRemoving:Connect(function(player)
    lastSteal[player.UserId] = nil
end)

for _, player in ipairs(Players:GetPlayers()) do
    processPlayer(player)
end

print("[SYADZZ] Auto Steal aktif!")
```
