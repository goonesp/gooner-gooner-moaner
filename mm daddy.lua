
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera


local function CreateESP(player)
	if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
		local character = player.Character or player.CharacterAdded:Wait()
		if character then
			local highlight = Instance.new("Highlight")
			highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red for enemies
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
			highlight.Parent = character
		end
	end
end

for _, player in pairs(Players:GetPlayers()) do
	CreateESP(player)
end

Players.PlayerAdded:Connect(CreateESP)


local AimbotEnabled = false
local TargetPlayer = nil
local AimPart = "Head"

local function GetTargetFromMouse()
	local mouseTarget = LocalPlayer:GetMouse().Target
	if mouseTarget then
		local targetPlayer = Players:GetPlayerFromCharacter(mouseTarget.Parent)
		if targetPlayer and targetPlayer ~= LocalPlayer and targetPlayer.Team ~= LocalPlayer.Team then
			return targetPlayer.Character and targetPlayer.Character:FindFirstChild(AimPart)
		end
	end
	return nil
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton5 then -- Side button on mouse
		AimbotEnabled = not AimbotEnabled
		print("Aimbot Toggled: " .. tostring(AimbotEnabled))

		if AimbotEnabled then
			TargetPlayer = GetTargetFromMouse()
		else
			TargetPlayer = nil
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if AimbotEnabled and TargetPlayer then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, TargetPlayer.Position)
	end
end)

print("sigma skibidi zyy")


