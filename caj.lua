local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create window
local Window = Rayfield:CreateWindow({
   Name = "🗼 Climb and Jump Tower 🗼",
   Icon = 0,
   LoadingTitle = "Climb And Jump Tower Script",
   LoadingSubtitle = "by 9Suoz",
   Theme = "Amethyst",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "Cloud Hub"
   },
   Discord = {
      Enabled = true,
      Invite = "MaD2P69gSr",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Key System",
      Subtitle = "Enter Key",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- Notification on script load
Rayfield:Notify({
   Title = "Welcome Cloud Hub User!",
   Content = "Your Script Has Loaded",
   Duration = 6.5,
   Image = 4483362458,
})

-- Main Tab Setup
local MainTab = Window:CreateTab("Main🏠", nil)
local Section = MainTab:CreateSection("Main")
local Divider = MainTab:CreateDivider()

-- Teleport Tab Setup
local TeleportTab = Window:CreateTab("Teleport🏝️", nil)
local Section = TeleportTab:CreateSection("Teleport To Other Island (Need Wins)")
local Divider = TeleportTab:CreateDivider()

-- Function to create teleport buttons to different worlds
local function createWorldButton(name, worldID)
   TeleportTab:CreateButton({
      Name = name,
      Callback = function()
         local args = { "\228\188\160\233\128\129\229\136\176\228\184\128\228\184\170\228\184\150\231\149\140", worldID }
         game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
      end,
   })
end

-- Create world buttons for teleporting
createWorldButton("World 1 🗼", 1)
createWorldButton("World 2 🏙️", 2)
createWorldButton("World 3 🌉", 3)
createWorldButton("World 4 🕰️", 4)
createWorldButton("World 5 🌵", 5)

-- Pets Tab Setup
local PetsTab = Window:CreateTab("Pets🐶", nil)
local Section = PetsTab:CreateSection("Pet Section")
local Divider = PetsTab:CreateDivider()

-- Equip Best Pets Button
PetsTab:CreateButton({
   Name = "Equip Best",
   Callback = function()
      local args = { "\232\163\133\229\164\135\230\156\128\228\189\179\229\174\160\231\137\169" }
      game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
   end,
})

-- Auto Eggs Dropdown (Coming Soon)
PetsTab:CreateDropdown({
   Name = "Auto Eggs ( Coming Soon )",
   Options = {"Coming", "Soon"},
   CurrentOption = {"Option 1"},
   Flag = "Dropdown1",
   Callback = function(Options) end,
})

-- Misc Tab Setup
local MiscTab = Window:CreateTab("Misc🎲", nil)
local Section = MiscTab:CreateSection("Misc")
local Divider = MiscTab:CreateDivider()

-- Paragraph for Testing
MainTab:CreateParagraph({
   Title = "Working | Enjoy 💖",
   Content = "Automatically farms wins every second. Player jumps off every 1 minute But You Still Get Wins If You Don't Reach The Top"
})

MiscTab:CreateParagraph({
   Title = "Join Our Community For Future Updates 💪",
   Content = "https://discord.gg/aW8xuu3ukh"
})

-- =======================
-- AUTO FARM & OPEN EGG GUI (INDONESIA)
-- =======================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Parent GUI ke Rayfield window
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Tab & Section untuk AutoFarm di Rayfield
local AutoFarmTab = Window:CreateTab("AutoFarm💰", nil)
local Section = AutoFarmTab:CreateSection("AutoFarm Money & Egg")
local Divider = AutoFarmTab:CreateDivider()

-- Remote references
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")
local drawHeroInvoke = ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero")

-- Status flags and coroutines
local farmMoneyActive = false
local openEggActive = false
local farmMoneyCoroutine
local openEggCoroutine
local autoWinActive = false
local autoWinCoroutine

-- Heights with defaults for farming and auto win
local farmHeight = 14405.45
local autoWinHeight = 14400.85

-- GUI slider for farming height
AutoFarmTab:CreateSlider({
    Name = "Farming Height",
    Min = 14000,
    Max = 14600,
    Increment = 1,
    Suffix = " Height",
    CurrentValue = farmHeight,
    Flag = "FarmHeightSlider",
    Callback = function(Value)
        farmHeight = Value
    end,
})

-- GUI slider for auto win height
AutoFarmTab:CreateSlider({
    Name = "Auto Win Height",
    Min = 14000,
    Max = 14600,
    Increment = 1,
    Suffix = " Height",
    CurrentValue = autoWinHeight,
    Flag = "AutoWinHeightSlider",
    Callback = function(Value)
        autoWinHeight = Value
    end,
})

-- Fungsi farming uang (menggunakan farmHeight dari slider)
local function farmMoney()
    local args1 = {"\232\181\183\232\183\179", farmHeight + 5}
    local args2 = {"\232\181\183\232\183\179", farmHeight}
    local args3 = {"\232\144\189\229\156\176"}

    remoteEvent:FireServer(unpack(args1))
    remoteEvent:FireServer(unpack(args2))
    remoteEvent:FireServer(unpack(args3))
end

-- Fungsi membuka telur
local function openEgg()
    local args1 = {"\230\138\189\232\155\139\229\188\149\229\175\188\231\187\147\230\157\159"}
    remoteEvent:FireServer(unpack(args1))

    local args2 = {7000017, 10}
    local success, err = pcall(function()
        drawHeroInvoke:InvokeServer(unpack(args2))
    end)
    if not success then
        warn("InvokeServer gagal: " .. tostring(err))
    end
end

-- Fungsi auto win (menggunakan autoWinHeight dari slider dan jump setiap 60 detik)
local function autoWin()
    local lastJumpTime = tick()
    while autoWinActive do
        local args2 = {"\232\181\183\232\183\179", autoWinHeight}
        remoteEvent:FireServer(unpack(args2))
        local args3 = {"\233\162\134\229\143\150\230\165\188\233\161\182wins"}
        remoteEvent:FireServer(unpack(args3))
        if tick() - lastJumpTime >= 60 then
            local character = player.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
            lastJumpTime = tick()
        end
        wait(1)
    end
end

-- Start/stop farming uang
local function startFarmMoney()
    if farmMoneyCoroutine then return end
    farmMoneyActive = true
    farmMoneyCoroutine = coroutine.create(function()
        while farmMoneyActive do
            farmMoney()
            wait(0.33)
        end
    end)
    coroutine.resume(farmMoneyCoroutine)
end

local function stopFarmMoney()
    farmMoneyActive = false
    farmMoneyCoroutine = nil
end

-- Start/stop membuka telur
local function startOpenEgg()
    if openEggCoroutine then return end
    openEggActive = true
    openEggCoroutine = coroutine.create(function()
        while openEggActive do
            openEgg()
            wait(1)
        end
    end)
    coroutine.resume(openEggCoroutine)
end

local function stopOpenEgg()
    openEggActive = false
    openEggCoroutine = nil
end

-- Start/stop auto win
local function startAutoWin()
    if autoWinCoroutine then return end
    autoWinActive = true
    autoWinCoroutine = coroutine.create(autoWin)
    coroutine.resume(autoWinCoroutine)
end

local function stopAutoWin()
    autoWinActive = false
    autoWinCoroutine = nil
end

-- Buat toggle Rayfield di Tab AutoFarm
local FarmMoneyToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Farm Uang",
    CurrentValue = false,
    Flag = "FarmMoneyToggle",
    Description = "Otomatis farming uang.",
    Callback = function(Value)
        if Value then
            startFarmMoney()
        else
            stopFarmMoney()
        end
    end,
})

local OpenEggToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Buka Telur",
    CurrentValue = false,
    Flag = "OpenEggToggle",
    Description = "Otomatis membuka telur.",
    Callback = function(Value)
        if Value then
            startOpenEgg()
        else
            stopOpenEgg()
        end
    end,
})

local AutoWinToggle = AutoFarmTab:CreateToggle({
    Name = "Auto Win",
    CurrentValue = false,
    Flag = "AutoWinToggle",
    Description = "Otomatis menang dan loncat setiap 60 detik dengan ketinggian setting.",
    Callback = function(Value)
        if Value then
            startAutoWin()
        else
            stopAutoWin()
        end
    end,
})

AutoFarmTab:CreateParagraph({
    Title = "AutoFarm Instructions",
    Content = "Aktifkan toggle di atas untuk auto farm uang, buka telur, atau auto win."
})

