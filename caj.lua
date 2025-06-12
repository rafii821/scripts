--[[
  Gabungan:
    - Rayfield (Auto Win)
    - GUI Sederhana (Auto Farm Uang & Auto Buka Telur)
    - Keduanya tetap berjalan sendiri-sendiri!
--]]

-- ===[ Rayfield Auto Win ]===
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🗼 Climb and Jump Tower | Auto Win + AutoFarm",
   LoadingTitle = "Climb And Jump Tower Script",
   LoadingSubtitle = "Auto Win & AutoFarm",
   Theme = "Amethyst"
})

local MainTab = Window:CreateTab("Main🏠", nil)
MainTab:CreateSection("Auto Win")

MainTab:CreateParagraph({
   Title = "Auto Wins",
   Content = "Script ini akan otomatis farming wins setiap detik dan melompat tiap 1 menit."
})

local running = false
local lastJumpTime = 0
local autoWinThread

local function stopAutoWin()
    running = false
end

MainTab:CreateToggle({
   Name = "Auto Wins",
   CurrentValue = false,
   Flag = "ToggleAutoWin",
   Description = "Otomatis farming wins setiap detik, lompat tiap 1 menit.",
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

-- ===[ GUI Sederhana (Auto Farm Uang & Telur) ]===
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remote references
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")
local drawHeroInvoke = ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero")

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local function createButton(name, text, position)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 140, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Text = text
    btn.Parent = screenGui
    return btn
end

local farmMoneyBtn = createButton("FarmMoney", "Mulai Auto Uang", UDim2.new(0,10,0,10))
local openEggBtn = createButton("OpenEgg", "Mulai Auto Telur", UDim2.new(0,160,0,10))

-- Flags
local farmMoneyActive = false
local openEggActive = false

-- Fungsi auto uang
local function farmMoney()
    local args1 = {"\232\181\183\232\183\179", 14405.461171865463}
    local args2 = {"\232\181\183\232\183\179", 14400.405507802963}
    local args3 = {"\232\144\189\229\156\176"}

    remoteEvent:FireServer(unpack(args1))
    remoteEvent:FireServer(unpack(args2))
    remoteEvent:FireServer(unpack(args3))
end

-- Fungsi auto telur (terdekat dari player)
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
                warn("[AutoFarmGui] Gagal buka telur: "..tostring(err))
            end
        else
            warn("[AutoFarmGui] EggID tidak ditemukan pada egg terdekat!")
        end
    else
        warn("[AutoFarmGui] Tidak ada egg terdekat ditemukan!")
    end
end

-- Coroutine
local farmMoneyCoroutine
local openEggCoroutine

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

-- Tombol klik
farmMoneyBtn.MouseButton1Click:Connect(function()
    farmMoneyActive = not farmMoneyActive
    if farmMoneyActive then
        farmMoneyBtn.Text = "Stop Auto Uang"
        startFarmMoney()
    else
        farmMoneyBtn.Text = "Mulai Auto Uang"
        stopFarmMoney()
    end
end)

openEggBtn.MouseButton1Click:Connect(function()
    openEggActive = not openEggActive
    if openEggActive then
        openEggBtn.Text = "Stop Auto Telur"
        startOpenEgg()
    else
        openEggBtn.Text = "Mulai Auto Telur"
        stopOpenEgg()
    end
end)
