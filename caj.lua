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

-- Input untuk Setting Ketinggian AutoFarm
local autofarmHeight = 14405.461171865463 -- default
MainTab:CreateInput({
   Name = "Ketinggian AutoFarm",
   CurrentValue = tostring(autofarmHeight),
   PlaceholderText = "Masukkan angka ketinggian (contoh: 14405)",
   RemoveTextAfterFocusLost = false,
   Flag = "InputAutoFarmHeight",
   Callback = function(Text)
      local num = tonumber(Text)
      if num then
         autofarmHeight = num
         Rayfield:Notify({
            Title = "AutoFarm",
            Content = "Ketinggian diubah ke: " .. tostring(num),
            Duration = 3,
         })
      else
         Rayfield:Notify({
            Title = "AutoFarm",
            Content = "Input tidak valid! Masukkan angka.",
            Duration = 3,
         })
      end
   end,
})

-- === FITUR AUTOFARM + AUTO EGG ===

local farmMoneyActive = false
local openEggActive = false
local farmMoneyCoroutine
local openEggCoroutine

-- Fungsi farm money (farming uang) -- menggunakan autofarmHeight dari input!
local function farmMoney()
    local args1 = {"\232\181\183\232\183\179", autofarmHeight}
    local args2 = {"\232\181\183\232\183\179", 14400.405507802963}
    local args3 = {"\232\144\189\229\156\176"}

    remoteEvent:FireServer(unpack(args1))
    remoteEvent:FireServer(unpack(args2))
    remoteEvent:FireServer(unpack(args3))
end

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
   Description = "Otomatis farming uang setiap 0.33 detik. Ketinggian bisa diatur.",
   Callback = function(Value)
      farmMoneyActive = Value
      if farmMoneyActive then
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
      if openEggActive then
         startOpenEgg()
      else
         stopOpenEgg()
      end
   end,
})

-- === AKHIR FITUR AUTOFARM + AUTO EGG ===

-- Pengaturan Tab Teleport
local TeleportTab = Window:CreateTab("Teleport🏝️", nil)
local Section = TeleportTab:CreateSection("Teleport ke Pulau Lain (Butuh Menang)")
local Divider = TeleportTab:CreateDivider()

local function createWorldButton(name, worldID)
   TeleportTab:CreateButton({
      Name = name,
      Callback = function()
         local args = { "\228\188\160\233\128\129\229\136\176\228\184\128\228\184\170\228\184\150\231\149\140", worldID }
         game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
      end,
   })
end

createWorldButton("Dunia 1 🗼", 1)
createWorldButton("Dunia 2 🏙️", 2)
createWorldButton("Dunia 3 🌉", 3)
createWorldButton("Dunia 4 🕰️", 4)
createWorldButton("Dunia 5 🌵", 5)

-- Pengaturan Tab Hewan
local PetsTab = Window:CreateTab("Hewan🐶", nil)
local Section = PetsTab:CreateSection("Bagian Hewan")
local Divider = PetsTab:CreateDivider()

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

MainTab:CreateParagraph({
   Title = "Berfungsi | Selamat Menikmati 💖",
   Content = "Otomatis farming kemenangan setiap detik. Pemain akan melompat setiap 1 menit, tapi kamu tetap mendapat kemenangan jika tidak mencapai puncak."
})

MiscTab:CreateParagraph({
   Title = "Gabung Komunitas Kami Untuk Update Terbaru 💪",
   Content = "https://discord.gg/aW8xuu3ukh"
})

local running = false
local lastJumpTime = 0
local autoWinThread

MainTab:CreateToggle({
   Name = "Auto Menang",
   CurrentValue = false,
   Flag = "Toggle1",
   Description = "Otomatis farming kemenangan setiap detik. Pemain melompat setiap 1 menit.",
   Callback = function(Value)
      running = Value

      if running then
         lastJumpTime = tick()
         autoWinThread = task.spawn(function()
            while running do
               local args1 = { "isAutoOn", 1 }
               game:GetService("ReplicatedStorage"):WaitForChild("ServerMsg"):WaitForChild("Setting"):InvokeServer(unpack(args1))
               wait()

               local args2 = { "\232\181\183\232\183\179", 14400.854642152786 }
               game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args2))
               wait()

               local args3 = { "\233\162\134\229\143\150\230\165\188\233\161\182wins" }
               game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args3))
               wait()

               if tick() - lastJumpTime >= 20 then
                  local player = game:GetService("Players").LocalPlayer
                  local character = player.Character
                  if character and character:FindFirstChildOfClass("Humanoid") then
                     character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                     lastJumpTime = tick()
                  end
               end

               wait(1)
            end
         end)
      else
         running = false
      end
   end,
})
