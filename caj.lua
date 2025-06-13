--[[ 
  FINAL PATCH 2025 - GUI AUTO FARM + AUTO WIN (RESPAWN SERVER) 
  Pasang di StarterPlayerScripts atau StarterCharacterScripts!
  Server-side respawn Wajib! (lihat bawah)
]]

-- ==== CLIENT SIDE ====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Tunggu PlayerGui ready!
local playerGui = player:WaitForChild("PlayerGui")

-- Pastikan RemoteEvent ada
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")
local drawHeroInvoke = ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero")
local respawnEvent = ReplicatedStorage:WaitForChild("RespawnEvent")

-- UI SETUP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmWinGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local function createButton(name, text, position)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 160, 0, 42)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(43, 168, 255)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Text = text
    btn.Parent = screenGui
    return btn
end

local farmMoneyBtn = createButton("FarmMoney", "Aktifkan Farm Uang", UDim2.new(0, 10, 0, 10))
local openEggBtn = createButton("OpenEgg", "Buka Telur Otomatis", UDim2.new(0, 180, 0, 10))
local autoWinBtn = createButton("AutoWin", "Aktifkan Auto Win", UDim2.new(0, 350, 0, 10))

-- ==== FLAGS ====
local farmMoneyActive = false
local openEggActive = false
local autoWinActive = false

-- ==== AUTO FARM UANG ====
local function farmMoney()
    local args1 = {"\232\181\183\232\183\179", 14405.461171865463}
    local args2 = {"\232\181\183\232\183\179", 14400.405507802963}
    local args3 = {"\232\144\189\229\156\176"}
    remoteEvent:FireServer(unpack(args1))
    remoteEvent:FireServer(unpack(args2))
    remoteEvent:FireServer(unpack(args3))
end

-- ==== AUTO BUKA TELUR (Egg Terdekat) ====
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

-- ==== AUTO WIN (PATCH 2025, RESPAWN SERVER) ====
local function autoWin()
    local lastRespawn = tick()
    while autoWinActive do
        local args2 = { "\232\181\183\232\183\179", 14400.854642152786 }
        remoteEvent:FireServer(unpack(args2))
        local args3 = { "\233\162\134\229\143\150\230\165\188\233\161\182wins" }
        remoteEvent:FireServer(unpack(args3))
        if tick() - lastRespawn >= 60 then
            respawnEvent:FireServer()
            lastRespawn = tick()
        end
        wait(1)
    end
end

-- ==== COROUTINES ====
local farmMoneyCoroutine
local openEggCoroutine
local autoWinCoroutine

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

-- ==== BUTTON EVENTS ====
farmMoneyBtn.MouseButton1Click:Connect(function()
    farmMoneyActive = not farmMoneyActive
    if farmMoneyActive then
        farmMoneyBtn.Text = "Nonaktifkan Farm Uang"
        startFarmMoney()
    else
        farmMoneyBtn.Text = "Aktifkan Farm Uang"
        stopFarmMoney()
    end
end)

openEggBtn.MouseButton1Click:Connect(function()
    openEggActive = not openEggActive
    if openEggActive then
        openEggBtn.Text = "Nonaktifkan Telur Otomatis"
        startOpenEgg()
    else
        openEggBtn.Text = "Buka Telur Otomatis"
        stopOpenEgg()
    end
end)

autoWinBtn.MouseButton1Click:Connect(function()
    autoWinActive = not autoWinActive
    if autoWinActive then
        autoWinBtn.Text = "Nonaktifkan Auto Win"
        startAutoWin()
    else
        autoWinBtn.Text = "Aktifkan Auto Win"
        stopAutoWin()
    end
end)

print("CLOUDHUB PATCH 2025 - GUI AKTIF!")

-----------------------------------------------------------------------
-- SERVER SIDE PATCH (Script baru di ServerScriptService, jangan dihapus!)
-----------------------------------------------------------------------
--[[ 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local respawnEvent = ReplicatedStorage:FindFirstChild("RespawnEvent") or Instance.new("RemoteEvent")
respawnEvent.Name = "RespawnEvent"
respawnEvent.Parent = ReplicatedStorage

respawnEvent.OnServerEvent:Connect(function(player)
    if player and player:IsA("Player") then
        player:LoadCharacter()
    end
end)
]]
