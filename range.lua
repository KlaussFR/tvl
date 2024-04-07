-- Library and service loading
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Variable to store the last hovered player name
local lastHoveredPlayerName = nil

-- Function for creating TextLabels
local function createLabel(parent, name, text, position)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Text = text
    label.Position = position
    label.AnchorPoint = Vector2.new(1, 0) -- Anchored to top-right corner
    label.TextXAlignment = Enum.TextXAlignment.Right -- Align text to right
    label.TextColor3 = Color3.fromRGB(255, 255, 255) -- Makes the text white
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- Black text stroke for shadow
    label.TextStrokeTransparency = 0 -- Opaque text stroke
    label.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Dark gray background
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14 -- Adjust text size
    label.Parent = parent
    return label
end

-- Function to create the GUI
local function createGui()
    -- Creating ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "HoveredPlayerInfo"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")

    -- Creating a Frame to hold the labels
    local LabelFrame = Instance.new("Frame")
    LabelFrame.Size = UDim2.new(0, 150, 0, 20) -- Change this as needed
    LabelFrame.Position = UDim2.new(1, -155, 0, 5) -- Adjust position to top right and move slightly down
    LabelFrame.AnchorPoint = Vector2.new(1, 0) -- Anchored to top-right corner
    LabelFrame.BackgroundTransparency = 1 -- Removes the background
    LabelFrame.Parent = ScreenGui

    return LabelFrame
end

-- Function to update GUI with hovered player information
local function updateGUI(hoveredPlayerName)
    local gui = Player.PlayerGui:FindFirstChild("HoveredPlayerInfo")
    local labelFrame = gui and gui:FindFirstChild("Frame")

    if not labelFrame then
        labelFrame = createGui()
    else
        -- Clear existing labels
        for _, label in ipairs(labelFrame:GetChildren()) do
            label:Destroy()
        end
    end

    -- Create label to display hovered player's name
    if hoveredPlayerName then
        createLabel(labelFrame, "HoveredPlayerLabel", "Targeted: " .. hoveredPlayerName, UDim2.new(1, -5, 0, 0))
    end
end

-- Function to activate an ability on a player
local function activateAbilityOnPlayer(playerName)
    local entity = game:GetService("Workspace").Entities:FindFirstChild(playerName)
    if entity then
        -- Assuming there's a remote event to activate abilities on the server
        game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes")
            :WaitForChild("AbilityService")
            :WaitForChild("ToServer")
            :WaitForChild("AbilityActivated")
            :FireServer(entity)
    else
        print("Entity not found for player:", playerName)
    end
end

-- Connect to the mouse move event
UserInputService.InputChanged:Connect(function(input)
    -- Check if the input is mouse movement
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        -- Get the local player's mouse object
        local mouse = Player:GetMouse()
        
        -- Check if the mouse has a target (part under the cursor)
        if mouse.Target then
            -- Check if the target is a part of a player character
            local character = mouse.Target:FindFirstAncestorOfClass("Model")
            if character and character:IsA("Model") and character:FindFirstChildOfClass("Humanoid") then
                local hoveredPlayerName = character.Name
                lastHoveredPlayerName = hoveredPlayerName  -- Update last hovered player
                updateGUI(hoveredPlayerName) -- Update GUI with hovered player's name
            end
        else
            updateGUI(nil) -- Clear GUI if no part found
        end
    end
end)

-- Connect to the key press event
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- Check if the input is associated with typing in chat
    if UserInputService:GetFocusedTextBox() then
        return -- Don't process further if typing in chat
    end

    -- Don't process input if it has been processed already by the game
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.Q then
        if lastHoveredPlayerName then
            -- Perform ability on last hovered player
            print("Performing ability on:", lastHoveredPlayerName)
            activateAbilityOnPlayer(lastHoveredPlayerName)
        else
            print("No player hovered.")
        end
    end
end)
