local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Static keys (add/remove as you wish, no expiration)
local VALID_KEYS = {
    ["KEY123"] = true,
    ["VIP999"] = true,
    -- Tambahkan key lain di sini sesuai kebutuhan
}

local scriptURLs = {
    [15900013841] = "https://raw.githubusercontent.com/rafii821/scripts/refs/heads/main/bldb.lua", -- blade ball
    [109983668079237] = "https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/StealaBrainrot", -- steal a brainrot
    [126884695634066] = "https://raw.githubusercontent.com/rafii821/scripts/refs/heads/main/ga.lua",  -- gag
    [15839834917] = "https://pastefy.app/6j0CmXgN/raw", -- Crash Out Simulator
    [129159449618378] = "https://pastefy.app/cxkvygky/raw", -- Cash Incremental
    [87700573492940] = "https://pastefy.app/dL1HWV28/raw", -- untitled drill
    [76381016848158] = "https://pastefy.app/K0zB6dzl/raw", -- Factory RNG
    [137034315542002] = "https://pastefy.app/ismiGrdU/raw", -- Egg Incremental
    [83942919686609] = "https://raw.githubusercontent.com/gumanba/Scripts/ac3206e03df2c4a08d40b558591a70f5d0e280e6/BuildaScamEmpire",

-- ... [rest of your script URLs remain the same]
}

local defaultScriptURL = "https://raw.githubusercontent.com/rafii821/scripts/refs/heads/main/bldb.lua"
local gameId = game.PlaceId

-- Notification helper
local function betterNotify(options)
    Rayfield:Notify({
        Title = options.Title or "Notification",
        Content = options.Content or "",
        Duration = options.Duration or 5,
        Image = options.Image or 4483362458
    })
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = options.Title or "Notification",
            Text = options.Content or "",
            Duration = options.Duration or 5
        })
    end)
    pcall(function()
        local sound = Instance.new("Sound", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
        sound.SoundId = "rbxassetid://9118828567"
        sound.Volume = 0.5
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 3)
    end)
end

-- Validation without expiration
local function validateKey(inputKey)
    if VALID_KEYS[inputKey] then
        return true, "Key valid! Enjoy your access 🎉"
    else
        return false, "Invalid key."
    end
end

local function loadGameScript()
    if gameId == "15900013841" then
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/rafii821/scripts/refs/heads/main/bldb.lua"))()
        end)
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/rafii821/scripts/refs/heads/main/bldb.lua"))()
        end)
    else
        local scriptToLoad = scriptURLs[gameId] or defaultScriptURL
        pcall(function()
            loadstring(game:HttpGet(scriptToLoad))()
        end)
    end
end

local Window = Rayfield:CreateWindow({
    Name = "AmberVault Nexus | Game Loader",
    LoadingTitle = "Loading AmberVault Nexus",
    LoadingSubtitle = "By MAKIMA",
    Theme = "AmberGlow",
    ConfigSaving = true,
    KeySystem = false,
    Discord = {
        Enabled = true,
        Invite = "mwTHaCKzhw",
        RememberJoins = true
    }
})

local KeyTab = Window:CreateTab("Key & Credits")
local timerLabel = KeyTab:CreateLabel("Enter your key below to unlock features!")

KeyTab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Type the key here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(input)
        local isValid, message = validateKey(input)
        if isValid then
            betterNotify({
                Title = "Access Granted",
                Content = message,
                Duration = 5,
            })
            timerLabel.Text = message
            task.wait(1)
            Rayfield:Destroy()
            loadGameScript()
        else
            betterNotify({
                Title = "Invalid Key",
                Content = message .. "\nJoin Discord for a new key!",
                Duration = 5,
            })
        end
    end
})

KeyTab:CreateButton({
    Name = "Copy Key Link",
    Callback = function()
        local links = "https://lootdest.org/s?OguVK5E5"
        setclipboard(links)
        betterNotify({
            Title = "Links Copied",
            Content = "KEY links have been copied to your clipboard!",
            Duration = 5,
        })
    end,
})

KeyTab:CreateParagraph({
    Title = "Credits",
    Content = "Script made by MAKIMA\nTheme: AmberGlow | UI powered by Rayfield\nThank you for using AmberVault Nexus!",
})

Window:CreateNotification({
    Title = "Welcome to AmberVault Nexus!",
    Content = "Enjoy your stay. Join our Discord for updates and support.",
    Duration = 8
})
