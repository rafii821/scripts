-- CloudHub Script for Climb And Jump Tower (Patch: Auto Open Egg Terdekat & AutoWin toggle fix)
-- Credit Auto Open Egg Terdekat logic: v3rmillion, rbxscript.com, modded for Climb and Jump Tower

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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

Rayfield:Notify({
   Title = "Welcome Cloud Hub User!",
   Content = "Your Script Has Loaded",
   Duration = 6.5,
   Image = 4483362458,
})

local MainTab = Window:CreateTab("Main🏠", nil)
MainTab:CreateSection("Main")
MainTab:CreateDivider()
local TeleportTab = Window:CreateTab("Teleport🏝️", nil)
TeleportTab:CreateSection("Teleport To Other Island (Need Wins)")
TeleportTab:CreateDivider()

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

local PetsTab = Window:CreateTab("Pets🐶", nil)
PetsTab:CreateSection("Pet Section")
PetsTab:CreateDivider()

PetsTab:CreateButton({
   Name = "Equip Best",
   Callback = function()
      local args = { "\232\163\133\229\164\135\230\156\128\228\189\179\229\174\160\231\137\169" }
      game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
   end,
})

PetsTab:CreateDropdown({
   Name = "Auto Eggs ( Coming Soon )",
   Options = {"Coming", "Soon"},
   CurrentOption = {"Option 1"},
   Flag = "Dropdown1",
   Callback = function(Options) end,
})

local MiscTab = Window:CreateTab("Misc🎲", nil)
MiscTab:CreateSection("Misc")
MiscTab:CreateDivider()

MainTab:CreateParagraph({
   Title = "Working | Enjoy 💖",
   Content = "Automatically farms wins every second. Player jumps off every 1 minute But You Still Get Wins If You Don't Reach The Top"
})

MiscTab:CreateParagraph({
   Title = "Join Our Community For Future Updates 💪",
   Content = "https://discord.gg/aW8xuu3ukh"
})

-- ========== PATCHED: AUTO WIN (TOGGLE BENAR-BENAR MATI)
local running = false
local lastJumpTime = 0
local autoWinThread

local function stopAutoWin()
    running = false
end

MainTab:CreateToggle({
   Name = "Auto Wins",
   CurrentValue = false,
   Flag = "Toggle1",
   Description = "Automatically farms wins every second. Player jumps every 1 minute.",
   Callback = function(Value)
      if Value then
         running = true
         lastJumpTime = tick()
         if autoWinThread then
             -- Thread lama akan break sendiri saat running jadi false
         end
         autoWinThread = task.spawn(function()
            while running do
               -- Auto setting
               local args1 = { "isAutoOn", 1 }
               game:GetService("ReplicatedStorage"):WaitForChild("ServerMsg"):WaitForChild("Setting"):InvokeServer(unpack(args1))
               task.wait()

               -- Fire event with value
               local args2 = { "\232\181\183\232\183\179", 14400.854642152786 }
               game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args2))
               task.wait()

               -- Send win command
               local args3 = { "\233\162\134\229\143\150\230\165\188\233\161\182wins" }
               game:GetService("ReplicatedStorage"):WaitForChild("Msg"):WaitForChild("RemoteEvent"):FireServer(unpack(args3))
               task.wait()

               -- Jump every 60 seconds
               if tick() - lastJumpTime >= 60 then
                  local player = game:GetService("Players").LocalPlayer
                  local character = player.Character
                  if character and character:FindFirstChildOfClass("Humanoid") then
                     character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                     lastJumpTime = tick()
                  end
               end
               task.wait(1)
            end
         end)
      else
         stopAutoWin()
      end
   end,
})

-- ========== AUTO FARM & PATCHED AUTO OPEN EGG TERDEKAT ==========

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local AutoFarmTab = Window:CreateTab("AutoFarm💰", nil)
AutoFarmTab:CreateSection("AutoFarm Money & Egg")
AutoFarmTab:CreateDivider()

local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")
local drawHeroInvoke = ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero")

local farmMoneyActive = false
local openEggActive = false
local farmMoneyCoroutine
local openEggCoroutine

local function farmMoney()
    local args1 = {"\232\181\183\232\183\179", 14405.461171865463}
    local args2 = {"\232\181\183\232\183\179", 14400.405507802963}
    local args3 = {"\232\144\189\229\156\176"}
    remoteEvent:FireServer(unpack(args1))
    remoteEvent:FireServer(unpack(args2))
    remoteEvent:FireServer(unpack(args3))
end

-- PATCHED: AUTO OPEN EGG TERDEKAT (KHUSUS CLIMB AND JUMP TOWER)
local function getEggsFolder()
    -- Ganti nama folder sesuai game, default: "Eggs", fallback: "Egg", "EggModel"
    return Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("Egg") or Workspace:FindFirstChild("EggModel")
end

local function getNearestEgg()
    local eggsFolder = getEggsFolder()
    if not eggsFolder then return nil end
    local minDist, nearestEgg = math.huge, nil
    for _, egg in pairs(eggsFolder:GetChildren()) do
        local pos
        if egg:IsA("BasePart") then
            pos = egg.Position
        elseif egg:IsA("Model") and egg.PrimaryPart then
            pos = egg.PrimaryPart.Position
        end
        if pos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (pos - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearestEgg = egg
            end
        end
    end
    return nearestEgg
end

local function getEggId(egg)
    -- Untuk Climb and Jump Tower biasanya egg pakai Name (angka, contoh: "7000017")
    if not egg then return nil end
    if tonumber(egg.Name) then
        return tonumber(egg.Name)
    elseif egg:GetAttribute("EggID") then
        return egg:GetAttribute("EggID")
    elseif egg:FindFirstChild("EggID") and egg.EggID.Value then
        return egg.EggID.Value
    end
    return nil
end

local function openEgg()
    local nearestEgg = getNearestEgg()
    if nearestEgg then
        local eggId = getEggId(nearestEgg)
        if eggId then
            local args1 = {"\230\138\189\232\155\139\229\188\149\229\175\188\231\187\147\230\157\159"}
            remoteEvent:FireServer(unpack(args1))
            local args2 = {eggId, 1}
            local success, err = pcall(function()
                drawHeroInvoke:InvokeServer(unpack(args2))
            end)
            if not success then
                warn("[CloudHub] Gagal buka telur: "..tostring(err))
            end
        else
            warn("[CloudHub] EggID tidak ditemukan pada egg terdekat!")
        end
    else
        warn("[CloudHub] Tidak ada egg terdekat ditemukan!")
    end
end

local function startFarmMoney()
    if farmMoneyCoroutine then return end
    farmMoneyActive = true
    farmMoneyCoroutine = coroutine.create(function()
        while farmMoneyActive do
            farmMoney()
            task.wait(0.33)
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
            task.wait(1)
        end
    end)
    coroutine.resume(openEggCoroutine)
end

local function stopOpenEgg()
    openEggActive = false
    openEggCoroutine = nil
end

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
    Name = "Auto Buka Telur (Egg Terdekat)",
    CurrentValue = false,
    Flag = "OpenEggToggle",
    Description = "Otomatis membuka telur terdekat.",
    Callback = function(Value)
        if Value then
            startOpenEgg()
        else
            stopOpenEgg()
        end
    end,
})

AutoFarmTab:CreateParagraph({
    Title = "AutoFarm Instructions",
    Content = "Aktifkan toggle di atas untuk auto farm uang atau auto buka telur terdekat."
})
