-- SYADZZ AUTO STEAL
-- Taruh di ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:FindFirstChild("SYADZZ_AutoSteal_Request")

if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "SYADZZ_AutoSteal_Request"
	remote.Parent = ReplicatedStorage
end

local eggsFolder = workspace:WaitForChild("Eggs")
local plotsFolder = workspace:WaitForChild("Plots")

local states = {}

local DEFAULT = {
	stealFromPlayers = true,
	autoPlaceToPen = true,
	autoReturnToBase = true,

	minKG = 0,

	rarities = {},
	petNames = {},
	areas = {},

	priority = "Rarity",
	interval = 0.25,
}

local rarityRank = {
	Common = 1,
	Uncommon = 2,
	Rare = 3,
	Epic = 4,
	Legendary = 5,
	Mythic = 6,
	Secret = 7,
	Divine = 8,
}

local function cloneConfig()
	local config = {}

	for key, value in pairs(DEFAULT) do
		if type(value) == "table" then
			config[key] = {}

			for _, item in ipairs(value) do
				table.insert(config[key], item)
			end
		else
			config[key] = value
		end
	end

	return config
end

local function selected(list, value)

	if #list == 0 then
		return true
	end

	value = tostring(value or "")

	for _, item in ipairs(list) do
		if tostring(item) == value then
			return true
		end
	end

	return false
end

local function getRoot(object)

	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then
		return object.PrimaryPart
			or object:FindFirstChildWhichIsA("BasePart", true)
	end

	return nil
end

local function getPosition(object)

	local root = getRoot(object)

	if root then
		return root.Position
	end

	return nil
end

local function validEgg(player, egg, config)

	if not egg or not egg.Parent then
		return false
	end

	local root = getRoot(egg)

	if not root then
		return false
	end

	local owner = egg:GetAttribute("OwnerUserId")

	if owner
		and tonumber(owner) == player.UserId
		and not config.stealFromPlayers then

		return false
	end

	local kg = tonumber(egg:GetAttribute("KG")) or 0

	if kg < tonumber(config.minKG or 0) then
		return false
	end

	if not selected(
		config.rarities,
		egg:GetAttribute("Rarity")
	) then
		return false
	end

	if not selected(
		config.petNames,
		egg:GetAttribute("PetName")
	) then
		return false
	end

	if not selected(
		config.areas,
		egg:GetAttribute("Area")
	) then
		return false
	end

	return true
end

local function findBestEgg(player, config)

	local character = player.Character

	local characterRoot =
		character
		and character:FindFirstChild("HumanoidRootPart")

	local origin =
		characterRoot
		and characterRoot.Position

	local bestEgg = nil
	local bestScore = nil

	for _, egg in ipairs(eggsFolder:GetChildren()) do

		if validEgg(player, egg, config) then

			local position = getPosition(egg)

			if position then

				local kg =
					tonumber(
						egg:GetAttribute("KG")
					) or 0

				local rarity =
					rarityRank[
						tostring(
							egg:GetAttribute("Rarity")
						)
					] or 0

				local distance = math.huge

				if origin then
					distance =
						(origin - position).Magnitude
				end

				local score

				if config.priority == "KG" then

					score =
						kg * 100000
						- distance

				elseif config.priority == "Distance" then

					score = -distance

				else

					score =
						rarity * 1000000
						+ kg * 1000
						- distance
				end

				if bestScore == nil
					or score > bestScore then

					bestScore = score
					bestEgg = egg
				end
			end
		end
	end

	return bestEgg
end

local function getPen(player)

	local plot =
		plotsFolder:FindFirstChild(
			player.Name
		)

	if not plot then
		return nil
	end

	return plot:FindFirstChild(
		"Pen",
		true
	)
end

--------------------------------------------------
-- SERVER-SIDE STEAL
--------------------------------------------------

local function serverSteal(player, egg)

	if not egg or not egg.Parent then
		return false
	end

	-- Prototype ownership system.
	-- Sambungkan bagian ini ke inventory/game
	-- system milik game kamu.

	egg:SetAttribute(
		"OwnerUserId",
		player.UserId
	)

	egg:SetAttribute(
		"CarriedByUserId",
		player.UserId
	)

	return true
end

--------------------------------------------------
-- PLACE TO PEN
--------------------------------------------------

local function placeInPen(player, egg)

	local pen = getPen(player)

	if not pen then
		return false
	end

	local target

	if pen:IsA("BasePart") then
		target = pen
	else
		target =
			pen:FindFirstChildWhichIsA(
				"BasePart",
				true
			)
	end

	if not target then
		return false
	end

	local destination =
		target.CFrame
		+ Vector3.new(0, 3, 0)

	if egg:IsA("Model") then

		egg:PivotTo(
			destination
		)

	elseif egg:IsA("BasePart") then

		egg.CFrame =
			destination
	end

	egg:SetAttribute(
		"CarriedByUserId",
		nil
	)

	egg:SetAttribute(
		"OwnerUserId",
		player.UserId
	)

	return true
end

--------------------------------------------------
-- AUTO FARM LOOP
--------------------------------------------------

local function run(player)

	local state = states[player]

	if not state then
		return
	end

	while state.running
		and player.Parent do

		local config = state.config

		local egg =
			findBestEgg(
				player,
				config
			)

		if egg then

			local success =
				serverSteal(
					player,
					egg
				)

			if success
				and config.autoPlaceToPen then

				placeInPen(
					player,
					egg
				)
			end
		end

		task.wait(
			math.max(
				0.05,
				tonumber(
					config.interval
				) or 0.25
			)
		)
	end
end

--------------------------------------------------
-- REMOTE
--------------------------------------------------

remote.OnServerEvent:Connect(
	function(player, action, payload)

		states[player] =
			states[player]
			or {
				running = false,
				config = cloneConfig()
			}

		local state =
			states[player]

		if action == "SetConfig"
			and type(payload) == "table" then

			local allowed = {
				"stealFromPlayers",
				"autoPlaceToPen",
				"autoReturnToBase",
				"minKG",
				"rarities",
				"petNames",
				"areas",
				"priority",
				"interval",
			}

			for _, key in ipairs(allowed) do

				if payload[key] ~= nil then
					state.config[key] =
						payload[key]
				end

			end

		elseif action == "Start" then

			if not state.running then

				state.running = true

				task.spawn(
					run,
					player
				)
			end

		elseif action == "Stop" then

			state.running = false
		end
	end
)

Players.PlayerRemoving:Connect(
	function(player)
		states[player] = nil
	end
)
