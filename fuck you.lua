--// Basic UI for toggling aimbot, ESP, hitbox expander
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Create a Frame (outer box)
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 300, 0, 400)  -- Width: 300px, Height: 400px
frame.Position = UDim2.new(0.5, -150, 0.5, -200)  -- Centered on screen
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  -- Dark background
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)  -- White border

-- Create a Title Text Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = frame
titleLabel.Size = UDim2.new(1, 0, 0, 40)  -- Width: 100%, Height: 40px
titleLabel.Text = "Game Hack Features"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text
titleLabel.TextSize = 24
titleLabel.BackgroundTransparency = 1  -- No background
titleLabel.TextAlign = Enum.TextAlign.Center

-- Create a Toggle Button for Aimbot
local toggleAimbotButton = Instance.new("TextButton")
toggleAimbotButton.Parent = frame
toggleAimbotButton.Size = UDim2.new(0.8, 0, 0, 50)  -- 80% width, 50px height
toggleAimbotButton.Position = UDim2.new(0.1, 0, 0.2, 0)  -- 10% from left, 20% from top
toggleAimbotButton.Text = "Toggle Aimbot"
toggleAimbotButton.TextSize = 20
toggleAimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text
toggleAimbotButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)  -- Green background

-- Aimbot logic
local aimbotEnabled = false
toggleAimbotButton.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	print("Aimbot Enabled:", aimbotEnabled)
	if aimbotEnabled then
		toggleAimbotButton.Text = "Aimbot ON"
	else
		toggleAimbotButton.Text = "Aimbot OFF"
	end
end)

-- Create a TextBox to set color for ESP
local espColorTextBox = Instance.new("TextBox")
espColorTextBox.Parent = frame
espColorTextBox.Size = UDim2.new(0.8, 0, 0, 50)
espColorTextBox.Position = UDim2.new(0.1, 0, 0.4, 0)  -- 10% from left, 40% from top
espColorTextBox.PlaceholderText = "Enter ESP Color (e.g., #FF0000)"
espColorTextBox.TextSize = 20
espColorTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
espColorTextBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

-- ESP logic: Store the ESP Color input
local espColor = Color3.fromRGB(255, 0, 0)  -- Default to red
espColorTextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local inputText = espColorTextBox.Text
		local success, color = pcall(function() return Color3.fromHex(inputText) end)
		if success then
			espColor = color
			print("ESP Color Set:", espColor)
		else
			print("Invalid color code entered!")
		end
	end
end)

-- Create a Toggle Button for Hitbox Expander
local toggleHitboxButton = Instance.new("TextButton")
toggleHitboxButton.Parent = frame
toggleHitboxButton.Size = UDim2.new(0.8, 0, 0, 50)  -- 80% width, 50px height
toggleHitboxButton.Position = UDim2.new(0.1, 0, 0.6, 0)  -- 10% from left, 60% from top
toggleHitboxButton.Text = "Toggle Hitbox Expander"
toggleHitboxButton.TextSize = 20
toggleHitboxButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text
toggleHitboxButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)  -- Green background

-- Hitbox Expander logic
local hitboxExpanded = false
toggleHitboxButton.MouseButton1Click:Connect(function()
	hitboxExpanded = not hitboxExpanded
	print("Hitbox Expander Enabled:", hitboxExpanded)
	if hitboxExpanded then
		toggleHitboxButton.Text = "Hitbox Expander ON"
	else
		toggleHitboxButton.Text = "Hitbox Expander OFF"
	end
end)

-- Add Key Bindings
local UserInputService = game:GetService("UserInputService")
local insertKeybind = Enum.KeyCode.Insert  -- Default key to toggle UI

-- Function to detect key presses for toggling features
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == insertKeybind then
		-- Toggle the visibility of the UI when Insert is pressed
		screenGui.Enabled = not screenGui.Enabled
		print("UI Toggled:", screenGui.Enabled)
	elseif input.KeyCode == Enum.KeyCode.F then
		-- Toggle the aimbot when 'F' is pressed
		aimbotEnabled = not aimbotEnabled
		print("Aimbot Enabled:", aimbotEnabled)
		toggleAimbotButton.Text = aimbotEnabled and "Aimbot ON" or "Aimbot OFF"
	elseif input.KeyCode == Enum.KeyCode.G then
		-- Toggle the hitbox expander when 'G' is pressed
		hitboxExpanded = not hitboxExpanded
		print("Hitbox Expander Enabled:", hitboxExpanded)
		toggleHitboxButton.Text = hitboxExpanded and "Hitbox Expander ON" or "Hitbox Expander OFF"
	elseif input.KeyCode == Enum.KeyCode.H then
		-- Change the ESP color when 'H' is pressed
		espColor = Color3.fromRGB(0, 255, 0)  -- Example: Set color to green
		print("ESP Color Set:", espColor)
	end
end)

-- Make the UI draggable
local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
