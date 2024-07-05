-- Library and service loading
local Player = game:GetService("Players").LocalPlayer

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
    ScreenGui.Name = "AccessoryInfo"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")

    -- Creating a Frame to hold the labels
    local LabelFrame = Instance.new("Frame")
    LabelFrame.Size = UDim2.new(0.5, 0, 0, 20) -- Change this as needed
    LabelFrame.Position = UDim2.new(1, -5, 0, 0) -- Adjust position to top right and move slightly to the left
    LabelFrame.AnchorPoint = Vector2.new(1, 0) -- Anchored to top-right corner
    LabelFrame.BackgroundTransparency = 1 -- Removes the background
    LabelFrame.Parent = ScreenGui

    return LabelFrame
end

-- Function to update GUI with accessory information
local function updateGUI()
    local gui = Player.PlayerGui:FindFirstChild("AccessoryInfo")
    local labelFrame = gui and gui:FindFirstChild("Frame")

    if not labelFrame then
        labelFrame = createGui()
    else
        -- Clear existing labels
        for _, label in ipairs(labelFrame:GetChildren()) do
            label:Destroy()
        end
    end

    local yOffset = 0 -- Vertical offset for labels

    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        local playerName = player.Name
        local entity = game:GetService("Workspace").Entities:FindFirstChild(playerName)
        local hasAccessory = false

        -- Check if the player has an accessory
        if entity then
            for _, accessory in ipairs(entity:GetChildren()) do
                for _, accessoryName in ipairs({"Bonnie", "Qetsiyah", "Hope", "DarkJosie", "Mason"}) do
                    if string.find(accessory.Name, accessoryName) then
                        -- Create label with adjusted vertical position
                        createLabel(labelFrame, playerName, playerName .. " has " .. accessoryName, UDim2.new(1, -5, 0, yOffset))
                        yOffset = yOffset + 20 -- Increase vertical offset
                        hasAccessory = true
                        break
                    end
                end
                if hasAccessory then
                    break
                end
            end
        end
    end
end

-- Update GUI every 0.5 seconds
while true do
    updateGUI()
    wait(0.5)
end
