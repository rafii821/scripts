
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ionlyusegithubformcmods/1-Line-Scripts/main/Mobile%20Friendly%20Orion')))()
local Player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local setclipboard = setclipboard or function(text) -- Compatibility for clipboard
    if syn then
        syn.write_clipboard(text)
    elseif clipboard_set then
        clipboard_set(text)
    else
        print("Clipboard not supported. Link: https://discord.gg/FmMuvkaWvG")
    end
end
-- Copy Discord link and open on script start
setclipboard("https://discord.gg/FmMuvkaWvG")
spawn(function()
    if syn and syn.request then
        syn.request({Url = "http://www.roblox.com/games/place?id=" .. game.PlaceId .. "&linkId=" .. HttpService:GenerateGUID(false), Method = "GET"})
    else
        game:HttpGet("https://discord.gg/FmMuvkaWvG")
    end
end)
OrionLib:MakeNotification({
    Name = "Discord Link",
    Content = "Discord link copied to clipboard and opened!",
    Image = "rbxassetid://4483345998",
    Time = 5
})
local Window = OrionLib:MakeWindow({
    Name = "Steal A BrainRot (beta)",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    IntroText = "Loading Script..."
})
OrionLib:MakeNotification({
    Name = "Logged In!",
    Content = "Enjoy " .. Player.Name .. "!",
    Image = "rbxassetid://4483345998",
    Time = 5
})
-- Visuals Tab Enhancements
local playerHighlights = {}
local playerNameGuis = {}
local espEnabled = false
local nameEnabled = false
local baseLockEnabled = false
local baseLockGui = nil
local function addHighlight(player)
    if player ~= Player and player.Character then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.new(0, 0, 1) -- Blue
        highlight.OutlineColor = Color3.new(0, 0, 1)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
        playerHighlights[player] = highlight
    end
end
local function removeHighlight(player)
    if playerHighlights[player] then
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end
end
local function addNameGui(player)
    if player ~= Player and player.Character then
        local head = player.Character:WaitForChild("Head")
        local billboard = Instance.new("BillboardGui")
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Adornee = head
        local textLabel = Instance.new("TextLabel", billboard)
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextScaled = true
        billboard.Parent = head
        playerNameGuis[player] = billboard
    end
end
local function removeNameGui(player)
    if playerNameGuis[player] then
        playerNameGuis[player]:Destroy()
        playerNameGuis[player] = nil
    end
end
local function findBaseTextLabel()
    local playerName = Player.Name
    local targetText = playerName .. "'s Base"
    
    local function searchForTextLabel(parent)
        for _, descendant in pairs(parent:GetDescendants()) do
            if descendant:IsA("TextLabel") and descendant.Text == targetText then
                return descendant
            end
        end
        return nil
    end
    
    local textLabel = searchForTextLabel(Workspace)
    return textLabel
end
local function updateBaseLockVisual()
    if baseLockEnabled and baseLockGui then
        local textLabel = findBaseTextLabel()
        if textLabel then
            local touchPart = textLabel.Parent.Parent.Parent.Parent:FindFirstChild("Purchases")
            if touchPart then
                touchPart = touchPart:FindFirstChild("PlotBlock")
                if touchPart then
                    touchPart = touchPart:FindFirstChild("Main")
                    if touchPart and touchPart:FindFirstChild("BillboardGui") then
                        local remainingTimeText = touchPart.BillboardGui:FindFirstChild("RemainingTime")
                        if remainingTimeText and remainingTimeText:IsA("TextLabel") then
                            baseLockGui.TextLabel.Text = "Base Unlocks In: " .. remainingTimeText.Text
                        else
                            baseLockGui.TextLabel.Text = "Base Unlocks In: No Remaining Time"
                        end
                    else
                        baseLockGui.TextLabel.Text = "Base Unlocks In: No BillboardGui"
                    end
                else
                    baseLockGui.TextLabel.Text = "Base Unlocks In: No PlotBlock"
                end
            else
                baseLockGui.TextLabel.Text = "Base Unlocks In: No Purchases"
            end
        else
            baseLockGui.TextLabel.Text = "Base Unlocks In: No Base Found"
        end
    end
end
-- ======= MAIN TAB =======
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local WalkSpeedValue = 16
local JumpPowerValue = 50
local GravityScale = 1
local selectedTool = nil
-- WalkSpeed Slider
MainTab:AddSlider({
    Name = "WalkSpeed",
    Min = 0,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(Value)
        WalkSpeedValue = Value
    end
})
-- JumpPower Slider
MainTab:AddSlider({
    Name = "JumpPower",
    Min = 0,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    Callback = function(Value)
        JumpPowerValue = Value
    end
})
-- Gravity Scale Slider
MainTab:AddSlider({
    Name = "Gravity Scale",
    Min = 0,
    Max = 5,
    Default = 1,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    Callback = function(Value)
        GravityScale = Value
    end
})
-- Tools Dropdown
local toolOptions = {}
for _, item in pairs(game.ReplicatedStorage.Items:GetChildren()) do
    if item:IsA("Tool") then
        table.insert(toolOptions, item.Name)
    end
end
MainTab:AddDropdown({
    Name = "Tools",
    Default = toolOptions[1] or "",
    Options = toolOptions,
    Callback = function(Value)
        selectedTool = Value
    end
})
-- Get Selected Tool Button
MainTab:AddButton({
    Name = "Get Selected Tool",
    Callback = function()
        if selectedTool and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            local tool = game.ReplicatedStorage.Items:FindFirstChild(selectedTool)
            if tool and tool:IsA("Tool") then
                local clonedTool = tool:Clone()
                clonedTool.Parent = Player.Backpack
                OrionLib:MakeNotification({
                    Name = "Tool Given",
                    Content = "You received " .. selectedTool .. "!",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "Tool not found in ReplicatedStorage.Items.",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "No tool selected or character not found.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})
-- Give All Tools Button
MainTab:AddButton({
    Name = "Give All Tools",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            local givenTools = {}
            for _, item in pairs(game.ReplicatedStorage.Items:GetChildren()) do
                if item:IsA("Tool") then
                    local clonedTool = item:Clone()
                    clonedTool.Parent = Player.Backpack
                    table.insert(givenTools, item.Name)
                end
            end
            if #givenTools > 0 then
                OrionLib:MakeNotification({
                    Name = "Tools Given",
                    Content = "You received all tools: " .. table.concat(givenTools, ", "),
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "No tools found in ReplicatedStorage.Items.",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Character or Humanoid not found.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})
-- Tween to Base
MainTab:AddButton({
    Name = "Tween to Base",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local textLabel = findBaseTextLabel()
            if textLabel then
                local basePart = textLabel.Parent.Parent.Parent
                if basePart:IsA("BasePart") or basePart:IsA("Model") then
                    local targetCFrame = basePart:IsA("BasePart") and basePart.CFrame + Vector3.new(0, 5, 0) or basePart:GetPrimaryPartCFrame() + Vector3.new(0, 5, 0)
                    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    local tween = TweenService:Create(Player.Character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
                    tween:Play()
                    OrionLib:MakeNotification({
                        Name = "Tweening to Base",
                        Content = "Moving to your base!",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                else
                    OrionLib:MakeNotification({
                        Name = "Base Not Found",
                        Content = "Could not find a valid base part.",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                end
            else
                OrionLib:MakeNotification({
                    Name = "Base Not Found",
                    Content = "Could not find TextLabel with '" .. Player.Name .. "'s Base'.",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Character or HumanoidRootPart not found.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})
-- AutoLockBase Button
MainTab:AddButton({
    Name = "AutoLockBase",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local textLabel = findBaseTextLabel()
            if textLabel then
                local touchPart = textLabel.Parent.Parent.Parent.Parent:FindFirstChild("Purchases")
                if touchPart then
                    touchPart = touchPart:FindFirstChild("PlotBlock")
                    if touchPart then
                        touchPart = touchPart:FindFirstChild("Main")
                        if touchPart and touchPart:IsA("BasePart") then
                            local targetCFrame = touchPart.CFrame + Vector3.new(0, 5, 0)
                            Player.Character.HumanoidRootPart.CFrame = targetCFrame
                            OrionLib:MakeNotification({
                                Name = "Teleported to Lock Part",
                                Content = "Teleported to Main part for base lock.",
                                Image = "rbxassetid://4483345998",
                                Time = 3
                            })
                        else
                            OrionLib:MakeNotification({
                                Name = "Touch Part Not Found",
                                Content = "Main part not found in PlotBlock.",
                                Image = "rbxassetid://4483345998",
                                Time = 3
                            })
                        end
                    else
                        OrionLib:MakeNotification({
                            Name = "PlotBlock Not Found",
                            Content = "PlotBlock not found in Purchases.",
                            Image = "rbxassetid://4483345998",
                            Time = 3
                        })
                    end
                else
                    OrionLib:MakeNotification({
                        Name = "Purchases Not Found",
                        Content = "Purchases not found in base hierarchy.",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                end
            else
                OrionLib:MakeNotification({
                    Name = "Base Not Found",
                    Content = "Could not find TextLabel with '" .. Player.Name .. "'s Base'.",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Character or HumanoidRootPart not found.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})
-- Reset Character Button
MainTab:AddButton({
    Name = "Reset Character",
    Callback = function()
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character:FindFirstChildOfClass("Humanoid").Health = 0
            OrionLib:MakeNotification({
                Name = "Character Reset",
                Content = "Your character has been reset.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Character or Humanoid not found.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})
-- Looped updates: Speed, Jump, Gravity
RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local Humanoid = Player.Character.Humanoid
        Humanoid.WalkSpeed = WalkSpeedValue
        Humanoid.JumpPower = JumpPowerValue
        game.Workspace.Gravity = 196.2 * GravityScale
    end
end)
-- ======= COMBAT TAB =======
local CombatTab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local SlapSpeed = 0.1
local AutoSlap = false
-- Supported slap tools
local slapTools = {
    "Tung Bat",
    "Blackhole Slap",
    "Dark Matter Slap",
    "Dev Slap",
    "Devil Slap",
    "Diamond Slap",
    "Emerald Slap",
    "Flame Slap",
    "Gold Slap",
    "Iron Slap",
    "Nuclear Slap",
    "Ruby Slap",
    "Slap"
}
CombatTab:AddToggle({
    Name = "Auto-Slap",
    Default = false,
    Callback = function(Value)
        AutoSlap = Value
        OrionLib:MakeNotification({
            Name = "Auto-Slap",
            Content = "Auto-Slap " .. (Value and "enabled" or "disabled"),
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})
-- Auto-Slap Logic
task.spawn(function()
    while true do
        if AutoSlap and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChildOfClass("Humanoid") then
            local myRoot = Player.Character.HumanoidRootPart
            local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
            local foundTarget = false
            
            -- Check for nearby players
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local theirRoot = plr.Character.HumanoidRootPart
                    local dist = (myRoot.Position - theirRoot.Position).Magnitude
                    
                    -- Fixed proximity check (10 studs)
                    if dist <= 10 then
                        foundTarget = true
                        local toolFound = false
                        
                        -- Check for any supported slap tool
                        for _, toolName in pairs(slapTools) do
                            local tool = Player.Backpack:FindFirstChild(toolName) or Player.Character:FindFirstChild(toolName)
                            if tool then
                                toolFound = true
                                -- Equip the tool if not already equipped
                                if not Player.Character:FindFirstChild(toolName) then
                                    humanoid:EquipTool(tool)
                                    task.wait(0.1) -- Wait for tool to equip
                                end
                                
                                -- Activate the tool
                                if tool:IsA("Tool") and tool.Parent == Player.Character then
                                    local success, err = pcall(function()
                                        tool:Activate()
                                    end)
                                    if not success then
                                        OrionLib:MakeNotification({
                                            Name = "Tool Activation Failed",
                                            Content = "Error: " .. tostring(err),
                                            Image = "rbxassetid://4483345998",
                                            Time = 3
                                        })
                                    end
                                end
                                break -- Use the first available tool
                            end
                        end
                        
                        if not toolFound then
                            OrionLib:MakeNotification({
                                Name = "Tool Not Found",
                                Content = "No supported slap tool (e.g., Tung Bat, Blackhole Slap) found in Backpack or Character.",
                                Image = "rbxassetid://4483345998",
                                Time = 3
                            })
                        end
                        break -- Exit loop after finding and slapping one target
                    end
                end
            end
            -- No automatic unequip; player must unequip manually
        end
        task.wait(SlapSpeed)
    end
end)
-- ======= VISUAL TAB =======
local VisualTab = Window:MakeTab({
    Name = "Visual",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
VisualTab:AddToggle({
    Name = "Players ESP",
    Default = false,
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    addHighlight(player)
                end
            end
        else
            for player, highlight in pairs(playerHighlights) do
                removeHighlight(player)
            end
        end
    end
})
VisualTab:AddToggle({
    Name = "Players Name",
    Default = false,
    Callback = function(Value)
        nameEnabled = Value
        if nameEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    addNameGui(player)
                end
            end
        else
            for player, gui in pairs(playerNameGuis) do
                removeNameGui(player)
            end
        end
    end
})
VisualTab:AddToggle({
    Name = "BaseLockVisual",
    Default = false,
    Callback = function(Value)
        baseLockEnabled = Value
        if baseLockEnabled and not baseLockGui then
            local screenGui = Instance.new("ScreenGui")
            local textLabel = Instance.new("TextLabel")
            screenGui.Parent = Player:WaitForChild("PlayerGui")
            textLabel.Parent = screenGui
            textLabel.Size = UDim2.new(0, 150, 0, 50)
            textLabel.Position = UDim2.new(1, -160, 1, -60) -- Right side: 10 pixels from right, 60 from bottom
            textLabel.BackgroundTransparency = 0.5
            textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextScaled = true
            textLabel.Text = "Base Unlocks In: Loading..."
            baseLockGui = screenGui
            spawn(function()
                while baseLockEnabled do
                    updateBaseLockVisual()
                    task.wait(0.1)
                end
            end)
        elseif not baseLockEnabled and baseLockGui then
            baseLockGui:Destroy()
            baseLockGui = nil
        end
    end
})
-- Event Handling for Players
for _, player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        if espEnabled then
            addHighlight(player)
        end
        if nameEnabled then
            addNameGui(player)
        end
    end)
    player.CharacterRemoving:Connect(function()
        removeHighlight(player)
        removeNameGui(player)
    end)
end
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            addHighlight(player)
        end
        if nameEnabled then
            addNameGui(player)
        end
    end)
    player.CharacterRemoving:Connect(function()
        removeHighlight(player)
        removeNameGui(player)
    end)
end)
Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
    removeNameGui(player)
end)
-- ======= MISC TAB =======
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
local antiAFK = false
local fpsBoost = false
local spinBot = false
-- Auto Rejoin Button
MiscTab:AddButton({
    Name = "Auto Rejoin",
    Callback = function()
        local success, err = pcall(function()
            TeleportService:Teleport(game.PlaceId, Player)
        end)
        if success then
            OrionLib:MakeNotification({
                Name = "Rejoin",
                Content = "Attempting to rejoin the server...",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Rejoin Failed",
                Content = "Error: " .. tostring(err),
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})
-- Anti-AFK Toggle
MiscTab:AddToggle({
    Name = "Anti-AFK",
    Default = false,
    Callback = function(Value)
        antiAFK = Value
        if antiAFK then
            spawn(function()
                while antiAFK do
                    task.wait(30) -- Simulate input every 30 seconds
                    local virtualUser = game:GetService("VirtualUser")
                    virtualUser:CaptureController()
                    virtualUser:ClickButton2(Vector2.new())
                end
            end)
            OrionLib:MakeNotification({
                Name = "Anti-AFK",
                Content = "Anti-AFK enabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Anti-AFK",
                Content = "Anti-AFK disabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})
-- Server Hop Button
MiscTab:AddButton({
    Name = "Server Hop",
    Callback = function()
        local servers = {}
        local req = HttpService:GetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(req)
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, Player)
            OrionLib:MakeNotification({
                Name = "Server Hop",
                Content = "Hopping to a new server...",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Server Hop Failed",
                Content = "No available tools found.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})
-- FPS Booster Toggle
MiscTab:AddToggle({
    Name = "FPS Booster",
    Default = false,
    Callback = function(Value)
        fpsBoost = Value
        if fpsBoost then
            settings().Rendering.QualityLevel = 1 -- Lowest quality
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").FogEnd = 9e9
            OrionLib:MakeNotification({
                Name = "FPS Booster",
                Content = "FPS Booster enabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            settings().Rendering.QualityLevel = 6 -- Reset to default
            game:GetService("Lighting").GlobalShadows = true
            game:GetService("Lighting").FogEnd = 100000
            OrionLib:MakeNotification({
                Name = "FPS Booster",
                Content = "FPS Booster disabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})
-- Spin Bot Toggle
MiscTab:AddToggle({
    Name = "Spin Bot",
    Default = false,
    Callback = function(Value)
        spinBot = Value
        if spinBot and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            spawn(function()
                while spinBot do
                    local root = Player.Character.HumanoidRootPart
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(5), 0) -- Rotate 5 degrees per frame
                    task.wait(0.01) -- Adjust speed of spin (0.01 seconds per rotation step)
                end
            end)
            OrionLib:MakeNotification({
                Name = "Spin Bot",
                Content = "Spin Bot enabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Spin Bot",
                Content = "Spin Bot disabled",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})
-- ======= SETTINGS TAB =======
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
SettingsTab:AddButton({
    Name = "Save Settings",
    Callback = function()
        OrionLib:SaveConfig()
        OrionLib:MakeNotification({
            Name = "Settings Saved",
            Content = "Settings have been saved successfully!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})
SettingsTab:AddButton({
    Name = "Load Settings",
    Callback = function()
        OrionLib:LoadConfig()
        print("Loaded config:", espEnabled, nameEnabled, baseLockEnabled, AutoSlap, antiAFK, fpsBoost, spinBot, WalkSpeedValue, JumpPowerValue, GravityScale)
        OrionLib:MakeNotification({
            Name = "Settings Loaded",
            Content = "Settings have been loaded successfully!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})
SettingsTab:AddButton({
    Name = "Reset to Default",
    Callback = function()
        -- Reset Toggles
        espEnabled = false
        nameEnabled = false
        baseLockEnabled = false
        AutoSlap = false
        antiAFK = false
        fpsBoost = false
        spinBot = false
        -- Reset Sliders
        WalkSpeedValue = 16
        JumpPowerValue = 50
        GravityScale = 1
        -- Update UI and notify
        OrionLib:MakeNotification({
            Name = "Settings Reset",
            Content = "All settings have been reset to default!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})
-- ======= CREDITS TAB =======
local CreditsTab = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
CreditsTab:AddLabel("Scripted by Javindra.")
CreditsTab:AddLabel("Founded by Crowned.")
CreditsTab:AddButton({
    Name = "Join Discord Server",
    Callback = function()
        setclipboard("https://discord.gg/FmMuvkaWvG")
        OrionLib:MakeNotification({
            Name = "Discord Link",
            Content = "Link copied to clipboard! Opening Discord invite...",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
        spawn(function()
            if syn and syn.request then
                syn.request({Url = "http://www.roblox.com/games/place?id=" .. game.PlaceId .. "&linkId=" .. HttpService:GenerateGUID(false), Method = "GET"})
            else
                game:HttpGet("https://discord.gg/WA2XTGMM")
            end
        end)
    end
})
OrionLib:Init()
