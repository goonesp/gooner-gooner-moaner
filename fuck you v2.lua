-- ESP Script with GUI and Team Check
-- This script will create a box around enemies and display their name above their head.
-- It includes a GUI to toggle ESP on/off and disables ESP for teammates.

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Local Player
local localPlayer = Players.LocalPlayer
local localTeam = localPlayer.Team

-- ESP Settings
local espEnabled = true
local espColor = Color3.new(1, 0, 0) -- Red for enemies
local teamCheck = true -- Enable team check

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 50)
frame.Position = UDim2.new(0.5, -100, 0, 10)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9, 0, 0.8, 0)
toggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
toggleButton.Text = "ESP: ON"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
toggleButton.BorderSizePixel = 0
toggleButton.Parent = frame

-- Function to toggle ESP
toggleButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	toggleButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
	if not espEnabled then
		clearESP()
	else
		updateESP()
	end
end)

-- Function to create ESP for a player
local function createESP(player)
	if not espEnabled or player == localPlayer then return end

	local character = player.Character
	if not character then return end

	-- Team check
	if teamCheck and player.Team == localTeam then return end

	for _, part in pairs(character:GetChildren()) do
		if part:IsA("BasePart") then
			-- Create a box around the part
			local box = Instance.new("BoxHandleAdornment")
			box.Size = part.Size
			box.Adornee = part
			box.AlwaysOnTop = true
			box.ZIndex = 10
			box.Transparency = 0.5
			box.Color3 = espColor
			box.Parent = part

			-- Create a name tag above the part
			local nameTag = Instance.new("BillboardGui")
			nameTag.Adornee = part
			nameTag.Size = UDim2.new(0, 200, 0, 50)
			nameTag.StudsOffset = Vector3.new(0, 2, 0)
			nameTag.AlwaysOnTop = true

			local textLabel = Instance.new("TextLabel")
			textLabel.Text = player.Name
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.TextColor3 = Color3.new(1, 1, 1) -- White color
			textLabel.BackgroundTransparency = 1
			textLabel.Parent = nameTag

			nameTag.Parent = part
		end
	end
end

-- Function to remove ESP for a player
local function removeESP(player)
	local character = player.Character
	if not character then return end

	for _, part in pairs(character:GetChildren()) do
		if part:IsA("BasePart") then
			for _, child in pairs(part:GetChildren()) do
				if child:IsA("BoxHandleAdornment") or child:IsA("BillboardGui") then
					child:Destroy()
				end
			end
		end
	end
end

-- Function to clear all ESP
local function clearESP()
	for _, player in pairs(Players:GetPlayers()) do
		removeESP(player)
	end
end

-- Function to update ESP for all players
local function updateESP()
	clearESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character then
			createESP(player)
		end
	end
end

-- Connect functions to player events
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		if espEnabled then
			createESP(player)
		end
	end)
	player.CharacterRemoving:Connect(function()
		removeESP(player)
	end)
end)

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
	if player.Character then
		createESP(player)
	end
	player.CharacterAdded:Connect(function()
		if espEnabled then
			createESP(player)
		end
	end)
	player.CharacterRemoving:Connect(function()
		removeESP(player)
	end)
end

-- Update ESP when team changes
localPlayer:GetPropertyChangedSignal("Team"):Connect(function()
	localTeam = localPlayer.Team
	if espEnabled then
		updateESP()
	end
end)