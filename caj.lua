loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/ClimbandJump", true))()
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Membuat jendela utama
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

-- Notifikasi ketika script dimuat
Rayfield:Notify({
   Title = "Selamat Datang Pengguna Makima Hub!",
   Content = "Script Kamu Telah Dimuat",
   Duration = 6.5,
   Image = 4483362458,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Referensi remote
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")
local drawHeroInvoke = ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero")

-- Pengaturan Tab Utama
local MainTab = Window:CreateTab("Utama🏠", nil)
local Section = MainTab:CreateSection("Utama")
local Divider = MainTab:CreateDivider()

-- === FITUR SCRIPT 2 DIMULAI DI SINI ===

-- Flag dan referensi coroutine
local farmMoneyActive = false
local openEggActive = false
local farmMoneyCoroutine
local openEggCoroutine

-- Fungsi farm money (farming uang)
local function farmMoney()
    local args1 = {"\232\181\183\232\183\179", 14405.461171865463}
    local args2 = {"\232\181\183\232\183\179", 14400.405507802963}
    local args3 = {"\232\144\189\229\156\176"}

    remoteEvent:FireServer(unpack(args1))
    remoteEvent:FireServer(unpack(args2))
    remoteEvent:FireServer(unpack(args3))
end

-- Fungsi open egg (membuka telur)
local function openEgg()
    local args1 = {"\230\138\189\232\155\139\229\188\149\229\175\188\231\187\147\230\157\159"}
    remoteEvent:FireServer(unpack(args1))

    local args2 = {7000017, 10}
    local success, err = pcall(function()
        drawHeroInvoke:InvokeServer(unpack(args2))
    end)
    if not success then
        warn("InvokeServer gagal: "..tostring(err))
    end
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

-- Toggle Farm Money
MainTab:CreateToggle({
   Name = "Auto Farm Uang",
   CurrentValue = false,
   Flag = "AutoFarmMoney",
   Description = "Otomatis farming uang setiap 0.33 detik.",
   Callback = function(Value)
      farmMoneyActive = Value
      if farmMoneyActive then
         startFarmMoney()
      else
         stopFarmMoney()
      end
   end,
})

-- Toggle Auto Open Egg
MainTab:CreateToggle({
   Name = "Auto Buka Telur",
   CurrentValue = false,
   Flag = "AutoOpenEgg",
   Description = "Otomatis membuka telur setiap 1 detik.",
   Callback = function(Value)
      openEggActive = Value
      if openEggActive then
         startOpenEgg()
      else
         stopOpenEgg()
      end
   end,
})

-- === AKHIR FITUR SCRIPT 2 ===

-- Pengaturan Tab Teleport
local TeleportTab = Window:CreateTab("Teleport🏝️", nil)
local Section = TeleportTab:CreateSection("Teleport ke Pulau Lain (Butuh Menang)")
local Divider = TeleportTab:CreateDivider()

-- Fungsi membuat tombol teleport ke dunia berbeda
local function createWorldButton(name, worldID)
   TeleportTab:CreateButton({
      Name = name,
      Callback = function()
         local args = { "\228\188\160\233\128\129\229\136\176\228\184\128\228\184\170\228\184\150\231\149\140", worldID }
         game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
      end,
   })
end

-- Membuat tombol untuk teleportasi ke dunia
createWorldButton("Dunia 1 🗼", 1)
createWorldButton("Dunia 2 🏙️", 2)
createWorldButton("Dunia 3 🌉", 3)
createWorldButton("Dunia 4 🕰️", 4)
createWorldButton("Dunia 5 🌵", 5)

-- Pengaturan Tab Hewan
local PetsTab = Window:CreateTab("Hewan🐶", nil)
local Section = PetsTab:CreateSection("Bagian Hewan")
local Divider = PetsTab:CreateDivider()

-- Tombol Equip Best Pets
PetsTab:CreateButton({
   Name = "Pakai Terbaik",
   Callback = function()
      local args = { "\232\163\133\229\164\135\230\156\128\228\189\179\229\174\160\231\137\169" }
      game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
   end,
})

-- Pengaturan Tab Misc
local MiscTab = Window:CreateTab("Lainnya🎲", nil)
local Section = MiscTab:CreateSection("Lainnya")
local Divider = MiscTab:CreateDivider()

-- Paragraf untuk Testing
MainTab:CreateParagraph({
   Title = "Berfungsi | Selamat Menikmati 💖",
   Content = "Otomatis farming kemenangan setiap detik. Pemain akan melompat setiap detik yang kamu atur, tapi kamu tetap mendapat kemenangan jika tidak mencapai puncak."
})

MiscTab:CreateParagraph({
   Title = "Gabung Komunitas Kami Untuk Update Terbaru 💪",
   Content = "https://discord.gg/aW8xuu3ukh"
})

-- === Pengaturan Auto Wins Timer ===
local SettingTab = Window:CreateTab("Settings⚙️", nil)
local Section = SettingTab:CreateSection("Pengaturan Auto Menang")

local jumpInterval = 20 -- default 20 detik
SettingTab:CreateSlider({
   Name = "Interval Lompat (detik)",
   Range = {1, 120},
   Increment = 1,
   Suffix = "detik",
   CurrentValue = jumpInterval,
   Flag = "JumpInterval",
   Callback = function(Value)
      jumpInterval = Value
   end,
})

-- Pengaturan Auto Wins Toggle
local running = false -- Status loop
local lastJumpTime = 0
local autoWinThread

-- Toggle Auto Wins
MainTab:CreateToggle({
   Name = "Auto Menang",
   CurrentValue = false,
   Flag = "Toggle1",
   Description = "Otomatis farming kemenangan setiap detik. Pemain melompat setiap interval yang kamu atur.",
   Callback = function(Value)
      running = Value

      if running then
         lastJumpTime = tick() -- Reset waktu lompat saat diaktifkan
         autoWinThread = task.spawn(function()
            while running do
               -- Pengaturan otomatis
               local args1 = { "isAutoOn", 1 }
               game:GetService("ReplicatedStorage"):WaitForChild("ServerMsg"):WaitForChild("Setting"):InvokeServer(unpack(args1))
               wait()

               -- Kirim event dengan nilai
               local args2 = { "\232\181\183\232\183\179", 14400.854642152786 }
               game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args2))
               wait()

               -- Kirim perintah menang
               local args3 = { "\233\162\134\229\143\150\230\165\188\233\161\182wins" }
               game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args3))
               wait()

               -- Lompat setiap interval detik (dari slider)
               if tick() - lastJumpTime >= jumpInterval then
                  local player = game:GetService("Players").LocalPlayer
                  local character = player.Character
                  if character and character:FindFirstChildOfClass("Humanoid") then
                     character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                     lastJumpTime = tick() -- Update waktu lompat terakhir
                  end
               end

               wait(1)
            end
         end)
      else
         running = false
         -- Berhenti loop
      end
   end,
})
