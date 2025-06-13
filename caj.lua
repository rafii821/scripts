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
MainTab:CreateSection("Main Section")
MainTab:CreateDivider()

-- Teleport Tab Setup
local TeleportTab = Window:CreateTab("Teleport🏝️", nil)
TeleportTab:CreateSection("Teleport To Other Island (Need Wins)")
TeleportTab:CreateDivider()

-- Pets Tab Setup
local PetsTab = Window:CreateTab("Pets🐶", nil)
PetsTab:CreateSection("Pet Section")
PetsTab:CreateDivider()

-- Misc Tab Setup
local MiscTab = Window:CreateTab("Misc🎲", nil)
MiscTab:CreateSection("Miscellaneous")
MiscTab:CreateDivider()

-- Create world teleport buttons
local function createWorldButton(name, worldID)
   TeleportTab:CreateButton({
      Name = name,
      Callback = function()
         local args = { "\228\188\160\233\128\129\229\136\176\228\184\128\228\184\170\228\184\150\231\149\140", worldID }
         game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
      end,
   })
end

createWorldButton("World 1 🗼", 1)
createWorldButton("World 2 🏙️", 2)
createWorldButton("World 3 🌉", 3)
createWorldButton("World 4 🕰️", 4)
createWorldButton("World 5 🌵", 5)

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
   CurrentOption = "Coming",
   Flag = "Dropdown1",
   Callback = function(value) end,
})

-- Paragraphs
MainTab:CreateParagraph({
   Title = "Working | Enjoy",
   Content = "Automatically farms wins every second. Player jumps off every 1 minute but you still get wins if you don't reach the top."
})

MiscTab:CreateParagraph({
   Title = "Join Our Community For Future Updates",
   Content = "https://discord.gg/aW8xuu3ukh"
})

-- Services and player reference
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Remote references
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")
local drawHeroInvoke = ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero")

-- AutoFarm Tab and Section
local AutoFarmTab = Window:CreateTab("AutoFarm💰", nil)
AutoFarmTab:CreateSection("AutoFarm Money & Egg")
AutoFarmTab:CreateDivider()

-- Variables and coroutine handles
local farmMoneyActive = false
local openEggActive = false
local autoWinActive = false

local farmMoneyCoroutine
local openEggCoroutine
local autoWinCoroutine

-- Numeric values for heights with default values
local farmHeight = 14405.45
local autoWinHeight = 14400.85

-- Slider for Farming Height
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

-- Slider for Auto Win Height
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

-- Farming money function uses farmHeight from slider
local function farmMoney()
   local args1 = {"\232\181\183\232\183\179", farmHeight + 5}
   local args2 = {"\232\181\183\232\183\179", farmHeight}
   local args3 = {"\232\144\189\229\156\176"}

   remoteEvent:FireServer(unpack(args1))
   remoteEvent:FireServer(unpack(args2))
   remoteEvent:FireServer(unpack(args3))
end

-- Open egg function
local function openEgg()
   local args1 = {"\230\138\189\232\155\139\229\188\149\229\175\188\231\187\147\230\157\159"}
   remoteEvent:FireServer(unpack(args1))

   local args2 = {7000017, 10}
   local success, err = pcall(function()
      drawHeroInvoke:InvokeServer(unpack(args2))
   end)
   if not success then
      warn("InvokeServer failed: " .. tostring(err))
   end
end

-- Auto Win function uses autoWinHeight from slider and jumps every 60 seconds
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

-- Start / Stop Farm Money coroutine
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

-- Start / Stop Open Egg coroutine
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

-- Start / Stop Auto Win coroutine
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

-- Create toggles in AutoFarm tab for farming, egg, and auto win
AutoFarmTab:CreateToggle({
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

AutoFarmTab:CreateToggle({
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

AutoFarmTab:CreateToggle({
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

-- Instruction paragraph
AutoFarmTab:CreateParagraph({
   Title = "AutoFarm Instructions",
   Content = "Aktifkan toggle di atas untuk auto farm uang, buka telur, atau auto win."
})
