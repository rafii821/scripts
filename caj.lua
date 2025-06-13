loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/ClimbandJump", true))()
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🗼 Climb and Jump Tower 🗼",
   Icon = 0,
   LoadingTitle = "Script Climb And Jump Tower",
   LoadingSubtitle = "oleh MAKIMA",
   Theme = "AmberGlow",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "loler"
   },
   Discord = {
      Enabled = false,
      Invite = "MaD2P69gSr",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Sistem Kunci",
      Subtitle = "Masukkan Kunci",
      Note = "Tidak ada cara untuk mendapatkan kunci",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

Rayfield:Notify({
   Title = "Selamat Datang Pengguna Makima Hub!",
   Content = "Script Kamu Telah Dimuat",
   Duration = 6.5,
   Image = 4483362458,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Remote references
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")
local drawHeroInvoke = ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero")

-- UTAMA TAB
local MainTab = Window:CreateTab("Utama🏠", nil)
MainTab:CreateSection("Utama")
MainTab:CreateDivider()

-- FARM MONEY / OPEN EGG
local farmMoneyActive, openEggActive = false, false
local farmMoneyCoroutine, openEggCoroutine

local function farmMoney()
    pcall(function()
        remoteEvent:FireServer("\232\181\183\232\183\179", 14405.461171865463)
        remoteEvent:FireServer("\232\181\183\232\183\179", 14400.405507802963)
        remoteEvent:FireServer("\232\144\189\229\156\176")
    end)
end

local function openEgg()
    pcall(function()
        remoteEvent:FireServer("\230\138\189\232\155\139\229\188\149\229\175\188\231\187\147\230\157\159")
        drawHeroInvoke:InvokeServer(7000017, 10)
    end)
end

local function startFarmMoney()
    if farmMoneyCoroutine then return end
    farmMoneyCoroutine = task.spawn(function()
        while farmMoneyActive do
            farmMoney()
            wait(0.33)
        end
        farmMoneyCoroutine = nil
    end)
end

local function stopFarmMoney()
    farmMoneyActive = false
end

local function startOpenEgg()
    if openEggCoroutine then return end
    openEggCoroutine = task.spawn(function()
        while openEggActive do
            openEgg()
            wait(1)
        end
        openEggCoroutine = nil
    end)
end

local function stopOpenEgg()
    openEggActive = false
end

MainTab:CreateToggle({
   Name = "Auto Farm Uang",
   CurrentValue = false,
   Flag = "AutoFarmMoney",
   Description = "Otomatis farming uang setiap 0.33 detik.",
   Callback = function(Value)
      farmMoneyActive = Value
      if farmMoneyActive and not farmMoneyCoroutine then
         startFarmMoney()
      else
         stopFarmMoney()
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Buka Telur",
   CurrentValue = false,
   Flag = "AutoOpenEgg",
   Description = "Otomatis membuka telur setiap 1 detik.",
   Callback = function(Value)
      openEggActive = Value
      if openEggActive and not openEggCoroutine then
         startOpenEgg()
      else
         stopOpenEgg()
      end
   end,
})

MainTab:CreateParagraph({
   Title = "Berfungsi | Selamat Menikmati 💖",
   Content = "Otomatis farming kemenangan berdasarkan tinggi. Pemain akan melompat otomatis jika melewati threshold yang ditentukan."
})

-- TELEPORT TAB
local TeleportTab = Window:CreateTab("Teleport🏝️", nil)
TeleportTab:CreateSection("Teleport ke Pulau Lain (Butuh Menang)")
TeleportTab:CreateDivider()

local function createWorldButton(name, worldID)
   TeleportTab:CreateButton({
      Name = name,
      Callback = function()
         pcall(function()
            remoteEvent:FireServer("\228\188\160\233\128\129\229\136\176\228\184\128\228\184\170\228\184\150\231\149\140", worldID)
         end)
      end,
   })
end

createWorldButton("Dunia 1 🗼", 1)
createWorldButton("Dunia 2 🏙️", 2)
createWorldButton("Dunia 3 🌉", 3)
createWorldButton("Dunia 4 🕰️", 4)
createWorldButton("Dunia 5 🌵", 5)

-- PETS TAB
local PetsTab = Window:CreateTab("Hewan🐶", nil)
PetsTab:CreateSection("Bagian Hewan")
PetsTab:CreateDivider()
PetsTab:CreateButton({
   Name = "Pakai Terbaik",
   Callback = function()
      pcall(function()
        remoteEvent:FireServer("\232\163\133\229\164\135\230\156\128\228\189\179\229\174\160\231\137\169")
      end)
   end,
})

-- MISC TAB
local MiscTab = Window:CreateTab("Lainnya🎲", nil)
MiscTab:CreateSection("Lainnya")
MiscTab:CreateDivider()
MiscTab:CreateParagraph({
   Title = "Gabung Komunitas Kami Untuk Update Terbaru 💪",
   Content = "https://discord.gg/aW8xuu3ukh"
})

-- AUTO WIN
local running = false
local autoWinThread
local jumpHeightThreshold = 50 -- Ubah sesuai kebutuhanmu

MainTab:CreateToggle({
   Name = "Auto Menang",
   CurrentValue = false,
   Flag = "Toggle1",
   Description = "Otomatis farming kemenangan berdasarkan tinggi. Pemain melompat otomatis jika melewati threshold.",
   Callback = function(Value)
      running = Value
      if running then
         if autoWinThread then return end
         autoWinThread = task.spawn(function()
            while running do
               local character = player.Character
               local canDo = false
               if character then
                  local hrp = character:FindFirstChild("HumanoidRootPart")
                  local humanoid = character:FindFirstChildOfClass("Humanoid")
                  if hrp and humanoid then
                     local height = hrp.Position.Y
                     if height >= jumpHeightThreshold then
                        canDo = true
                     end
                  end
               end
               if canDo then
                  pcall(function()
                     ReplicatedStorage:WaitForChild("ServerMsg"):WaitForChild("Setting"):InvokeServer("isAutoOn", 1)
                     wait(0.1)
                     remoteEvent:FireServer("\232\181\183\232\183\179", 14400.854642152786)
                     wait(0.1)
                     remoteEvent:FireServer("\233\162\134\229\143\150\230\165\188\233\161\182wins")
                     wait(0.1)
                     character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                  end)
                  wait(1.2)
               else
                  wait(0.2)
               end
            end
            autoWinThread = nil
         end)
      else
         running = false
         autoWinThread = nil
      end
   end,
})
