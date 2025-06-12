--[[
  Climb & Jump Tower Script PATCHED (All-in-One GUI)
  - Rayfield UI, semua fitur dalam 1 menu!
  - Auto Win (respawn tiap 60 detik, bukan lompat)
  - Auto Farm Uang
  - Auto Buka Telur (Egg Terdekat)
  - Tidak ada GUI native, semua tombol/toggle di Rayfield!
  - PATCH 2025: Aman untuk patch terbaru (respawn, bukan jump)
  - By: rafii821 & Copilot
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🗼 Climb and Jump Tower | CloudHub Patched",
   LoadingTitle = "Climb And Jump Tower Script",
   LoadingSubtitle = "All-in-One (2025 Patch)",
   Theme = "Amethyst"
})

local MainTab = Window:CreateTab("Main🏠", nil)
MainTab:CreateSection("Auto Win & Farm")
MainTab:CreateDivider()

MainTab:CreateParagraph({
   Title = "Auto Win & Farm",
   Content = "Auto Win: farming wins tiap detik, respawn tiap 1 menit.\nAuto Farm: farming uang & buka telur terdekat otomatis."
})

-- ======== [ VARIABEL DAN REMOTE ] ========
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")
local drawHeroInvoke = ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero")

-- ======== [ AUTO WIN (RESPAWN PATCH) ] ========
local autoWinRunning = false
local lastRespawnTime = 0
local autoWinThread

local function stopAutoWin()
    autoWinRunning = false
end

MainTab:CreateToggle({
   Name = "Auto Wins (Respawn)",
   CurrentValue = false,
   Flag = "ToggleAutoWin",
   Description = "Otomatis farming wins tiap detik, respawn tiap 1 menit.",
   Callback = function(Value)
      if Value then
         autoWinRunning = true
         lastRespawnTime = tick()
         if autoWinThread then
             -- Thread lama auto selesai sendiri
         end
         autoWinThread = task.spawn(function()
            while autoWinRunning do
               -- Auto setting
               local args1 = { "isAutoOn", 1 }
               ReplicatedStorage:WaitForChild("ServerMsg"):WaitForChild("Setting"):InvokeServer(unpack(args1))
               task.wait()

               -- Fire event with value
               local args2 = { "\232\181\183\232\183\179", 14400.854642152786 }
               remoteEvent:FireServer(unpack(args2))
               task.wait()

               -- Send win command
               local args3 = { "\233\162\134\229\143\150\230\165\188\233\161\182wins" }
               remoteEvent:FireServer(unpack(args3))
               task.wait()

               -- Respawn every 60 seconds
               if tick() - lastRespawnTime >= 60 then
                  if player then
                     player:LoadCharacter()
                     lastRespawnTime = tick()
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

-- ======== [ AUTO FARM UANG ] ========
local autoMoneyRunning = false
local autoMoneyThread

local function farmMoney()
    local args1 = {"\232\181\183\232\183\179", 14405.461171865463}
    local args2 = {"\232\181\183\232\183\179", 14400.405507802963}
    local args3 = {"\232\144\189\229\156\176"}
    remoteEvent:FireServer(unpack(args1))
    remoteEvent:FireServer(unpack(args2))
    remoteEvent:FireServer(unpack(args3))
end

MainTab:CreateToggle({
    Name = "Auto Farm Uang",
    CurrentValue = false,
    Flag = "ToggleMoneyFarm",
    Description = "Otomatis farming uang.",
    Callback = function(Value)
        if Value then
            autoMoneyRunning = true
            if autoMoneyThread then
                -- Thread lama auto selesai
            end
            autoMoneyThread = task.spawn(function()
                while autoMoneyRunning do
                    farmMoney()
                    task.wait(0.33)
                end
            end)
        else
            autoMoneyRunning = false
        end
    end,
})

-- ======== [ AUTO BUKA TELUR (EGG TERDEKAT) ] ========
local autoEggRunning = false
local autoEggThread

local function getEggsFolder()
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

MainTab:CreateToggle({
    Name = "Auto Buka Telur (Egg Terdekat)",
    CurrentValue = false,
    Flag = "ToggleEggFarm",
    Description = "Otomatis buka telur terdekat.",
    Callback = function(Value)
        if Value then
            autoEggRunning = true
            if autoEggThread then
                -- Thread lama auto selesai
            end
            autoEggThread = task.spawn(function()
                while autoEggRunning do
                    openEgg()
                    task.wait(1)
                end
            end)
        else
            autoEggRunning = false
        end
    end,
})

MainTab:CreateParagraph({
    Title = "Info & Catatan",
    Content = "Semua fitur bisa diaktifkan bersamaan. Script PATCH aman untuk update 2025 (respawn, bukan jump).\nJoin Discord CloudHub untuk update!"
})
