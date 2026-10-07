-- SYADZZ AUTO STEAL UI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local remote =
	ReplicatedStorage:
	WaitForChild(
		"SYADZZ_AutoSteal_Request"
	)

local gui =
	Instance.new("ScreenGui")

gui.Name =
	"SYADZZ_AutoSteal"

gui.ResetOnSpawn = false

gui.Parent =
	player:WaitForChild(
		"PlayerGui"
	)

--------------------------------------------------
-- OPEN BUTTON
--------------------------------------------------

local open =
	Instance.new("TextButton")

open.Size =
	UDim2.fromOffset(
		120,
		40
	)

open.Position =
	UDim2.new(
		0,
		20,
		0.5,
		-20
	)

open.Text =
	"SYADZZ"

open.TextSize = 16

open.Parent = gui

--------------------------------------------------
-- PANEL
--------------------------------------------------

local panel =
	Instance.new("Frame")

panel.Size =
	UDim2.fromOffset(
		380,
		470
	)

panel.Position =
	UDim2.new(
		0,
		155,
		0.5,
		-235
	)

panel.Visible = false

panel.Parent = gui

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title =
	Instance.new("TextLabel")

title.Size =
	UDim2.new(
		1,
		-45,
		0,
		45
	)

title.Text =
	"SYADZZ • AUTO STEAL"

title.TextSize = 18

title.Parent = panel

--------------------------------------------------
-- CLOSE
--------------------------------------------------

local close =
	Instance.new("TextButton")

close.Size =
	UDim2.fromOffset(
		40,
		40
	)

close.Position =
	UDim2.new(
		1,
		-40,
		0,
		0
	)

close.Text = "X"

close.TextSize = 20

close.Parent = panel

--------------------------------------------------
-- SCROLL
--------------------------------------------------

local list =
	Instance.new(
		"ScrollingFrame"
	)

list.Size =
	UDim2.new(
		1,
		-20,
		1,
		-55
	)

list.Position =
	UDim2.fromOffset(
		10,
		50
	)

list.AutomaticCanvasSize =
	Enum.AutomaticSize.Y

list.CanvasSize =
	UDim2.new()

list.Parent = panel

local layout =
	Instance.new(
		"UIListLayout"
	)

layout.Padding =
	UDim.new(
		0,
		7
	)

layout.Parent = list

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local config = {

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

local running = false

--------------------------------------------------
-- BUTTON
--------------------------------------------------

local function addButton(
	text,
	callback
)

	local button =
		Instance.new(
			"TextButton"
		)

	button.Size =
		UDim2.new(
			1,
			-5,
			0,
			40
		)

	button.Text =
		text

	button.TextSize = 14

	button.Parent = list

	button.MouseButton1Click:
		Connect(
			callback
		)

	return button
end

--------------------------------------------------
-- AUTO STEAL
--------------------------------------------------

local autoButton

autoButton =
	addButton(
		"Auto Steal : OFF",
		function()

			running =
				not running

			if running then

				remote:FireServer(
					"SetConfig",
					config
				)

				remote:FireServer(
					"Start"
				)

				autoButton.Text =
					"Auto Steal : ON"

			else

				remote:FireServer(
					"Stop"
				)

				autoButton.Text =
					"Auto Steal : OFF"
			end
		end
	)

--------------------------------------------------
-- STEAL FROM PLAYERS
--------------------------------------------------

addButton(
	"Steal From Players : ON",
	function(button)

		config.stealFromPlayers =
			not config.stealFromPlayers

		button.Text =
			"Steal From Players : "
			.. tostring(
				config.stealFromPlayers
			)
	end
)

--------------------------------------------------
-- AUTO PLACE
--------------------------------------------------

addButton(
	"Auto Place To Pen : ON",
	function(button)

		config.autoPlaceToPen =
			not config.autoPlaceToPen

		button.Text =
			"Auto Place To Pen : "
			.. tostring(
				config.autoPlaceToPen
			)
	end
)

--------------------------------------------------
-- PRIORITY
--------------------------------------------------

local priorityButton

priorityButton =
	addButton(
		"Priority : Rarity",
		function()

			if config.priority
				== "Rarity" then

				config.priority = "KG"

			elseif config.priority
				== "KG" then

				config.priority =
					"Distance"

			else

				config.priority =
					"Rarity"
			end

			priorityButton.Text =
				"Priority : "
				.. config.priority
		end
	)

--------------------------------------------------
-- MIN KG
--------------------------------------------------

local kgButton

kgButton =
	addButton(
		"Min Egg KG : 0",
		function()

			config.minKG =
				config.minKG + 1

			kgButton.Text =
				"Min Egg KG : "
				.. config.minKG
		end
	)

--------------------------------------------------
-- RARITY
--------------------------------------------------

local rarityButton

rarityButton =
	addButton(
		"Rarities : ALL",
		function()

			if #config.rarities == 0 then

				config.rarities = {
					"Legendary",
					"Mythic",
					"Secret",
				}

				rarityButton.Text =
					"Rarities : LEG/MYTHIC/SECRET"

			else

				config.rarities = {}

				rarityButton.Text =
					"Rarities : ALL"
			end
		end
	)

--------------------------------------------------
-- PET
--------------------------------------------------

local petButton

petButton =
	addButton(
		"Pet Names : ALL",
		function()

			if #config.petNames == 0 then

				config.petNames = {
					"ExamplePet"
				}

				petButton.Text =
					"Pet Names : FILTERED"

			else

				config.petNames = {}

				petButton.Text =
					"Pet Names : ALL"
			end
		end
	)

--------------------------------------------------
-- AREA
--------------------------------------------------

local areaButton

areaButton =
	addButton(
		"Areas : ALL",
		function()

			if #config.areas == 0 then

				config.areas = {
					"Area 1"
				}

				areaButton.Text =
					"Areas : FILTERED"

			else

				config.areas = {}

				areaButton.Text =
					"Areas : ALL"
			end
		end
	)

--------------------------------------------------
-- OPEN / CLOSE
--------------------------------------------------

open.MouseButton1Click:Connect(
	function()

		panel.Visible =
			not panel.Visible
	end
)

close.MouseButton1Click:Connect(
	function()

		panel.Visible = false
	end
)
