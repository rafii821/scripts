local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🗼 Climb and Jump Tower 🗼",
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
})

-- Membuat Tab AutoFarm
local AutoFarmTab = Window:CreateTab("AutoFarm💰", nil)

-- Membuat Section di dalam tab AutoFarm
AutoFarmTab:CreateSection("AutoFarm Money & Egg")

-- Variable status
local farmMoneyActive = false
local openEggActive = false
local autoWinActive = false

local farmHeight = 14405.45
local autoWinHeight = 14400.85

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")
local drawHeroInvoke = ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero")

-- Fungsi farming uang
local function farmMoney()
    local args1 = {"\232\181\183\232\183\179", farmHeight + 5}
    local args2 = {"\232\181\183\232\183\179", farmHeight}
    local args3 = {"\232\144\189\229\156\176"}

    remoteEvent:FireServer(unpack(args1))
    remoteEvent:FireServer(unpack(args2))
    remoteEvent:FireServer(unpack(args3))
end

-- Fungsi buka telur
local function openEgg()
    local args1 = {"\230\138\189\232\155\139\229\188\149\229\175\188\231\187\147\230\157\159"}
    remoteEvent:FireServer(unpack(args1))

    local args2 = {7000017, 10}
    pcall(function()
        drawHeroInvoke:InvokeServer(unpack(args2))
    end)
end

-- Auto win function
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

-- Coroutines handler
local farmMoneyCoroutine = nil
local openEggCoroutine = nil
local autoWinCoroutine = nil

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

-- Buat Slider ketinggian farm
AutoFarmTab:CreateSlider({
    Name = "Farming Height",
    Min = 14000,
    Max = 14600,
    Increment = 1,
    Suffix = " Height",
    CurrentValue = farmHeight,
    Flag = "FarmHeightSlider",
    Callback = function(value)
        farmHeight = value
    end,
})

-- Buat Slider ketinggian auto win
AutoFarmTab:CreateSlider({
    Name = "Auto Win Height",
    Min = 14000,
    Max = 14600,
    Increment = 1,
    Suffix = " Height",
    CurrentValue = autoWinHeight,
    Flag = "AutoWinHeightSlider",
    Callback = function(value)
        autoWinHeight = value
    end,
})

-- Toggle Auto Farm Uang
AutoFarmTab:CreateToggle({
    Name = "Auto Farm Uang",
    CurrentValue = false,
    Flag = "FarmMoneyToggle",
    Description = "Otomatis farming uang.",
    Callback = function(value)
        if value then
            startFarmMoney()
        else
            stopFarmMoney()
        end
    end,
})

-- Toggle Auto Buka Telur
AutoFarmTab:CreateToggle({
    Name = "Auto Buka Telur",
    CurrentValue = false,
    Flag = "OpenEggToggle",
    Description = "Otomatis membuka telur.",
    Callback = function(value)
        if value then
            startOpenEgg()
        else
            stopOpenEgg()
        end
    end,
})

-- Toggle Auto Win
AutoFarmTab:CreateToggle({
    Name = "Auto Win",
    CurrentValue = false,
    Flag = "AutoWinToggle",
    Description = "Otomatis menang dan loncat setiap 60 detik menggunakan ketinggian setting.",
    Callback = function(value)
        if value then
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
