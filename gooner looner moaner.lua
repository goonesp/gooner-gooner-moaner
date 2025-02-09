local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- SETTINGS
local aimStrength = 1  -- How much the aim adjusts (0 = none, 1 = instant lock-on)
local maxAngle = 15  -- Maximum angle difference for aim assist to work
local aimDistance = 10000000  -- Max distance to detect enemies
local aimAssistEnabled = false  -- Starts OFF

-- Function to find closest enemy in aim direction
local function getClosestEnemy()
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

	local rootPart = character.HumanoidRootPart
	local direction = rootPart.CFrame.LookVector

	local closestEnemy = nil
	local closestAngle = maxAngle

	for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
		if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
			local enemyRoot = enemy.HumanoidRootPart
			local directionToEnemy = (enemyRoot.Position - rootPart.Position).unit
			local angle = math.deg(math.acos(direction:Dot(directionToEnemy)))

			if angle < closestAngle and (rootPart.Position - enemyRoot.Position).magnitude < aimDistance then
				closestAngle = angle
				closestEnemy = enemyRoot
			end
		end
	end

	return closestEnemy
end

-- Adjust aim smoothly
local function assistAim()
	if not aimAssistEnabled then return end  -- Only run when enabled

	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	local enemy = getClosestEnemy()
	if enemy then
		local rootPart = character.HumanoidRootPart
		local targetCF = CFrame.lookAt(rootPart.Position, enemy.Position)
		rootPart.CFrame = rootPart.CFrame:Lerp(targetCF, aimStrength)
	end
end

-- Toggle aim assist with MouseButton5
userInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end  -- Ignore UI interactions

	if input.UserInputType == Enum.UserInputType.MouseButton5 then
		aimAssistEnabled = not aimAssistEnabled
		print("Aim Assist: " .. (aimAssistEnabled and "ON" or "OFF"))
	end
end)

-- Run aim assist on RenderStepped
runService.RenderStepped:Connect(function()
	if mouse.Target then
		assistAim()
	end
end)


--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Function to create ESP box
local function CreateESP(player)
	if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then -- Only for enemies
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local highlight = Instance.new("Highlight")
			highlight.Adornee = character
			highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red for enemies
			highlight.FillTransparency = 0.5
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
			highlight.OutlineTransparency = 0
			highlight.Parent = character
		end
	end
end

-- Function to update ESP
local function UpdateESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			CreateESP(player)
		end
	end
end

-- Event to add ESP when a new player joins
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1) -- Wait for character to load
		UpdateESP()
	end)
end)

-- Initial ESP setup
UpdateESP()


