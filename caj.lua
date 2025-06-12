local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remote
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")
local drawHeroInvoke = ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero")

-- GUI Sederhana
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmGui"
screenGui.Parent = playerGui

-- Fungsi buat tombol
local function buatTombol(nama, teks, posisi)
    local btn = Instance.new("TextButton")
    btn.Name = nama
    btn.Size = UDim2.new(0, 140, 0, 40)
    btn.Position = posisi
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Text = teks
    btn.Parent = screenGui
    return btn
end

local farmMoneyBtn = buatTombol("FarmMoney", "Mulai Auto Uang", UDim2.new(0,10,0,10))
local openEggBtn = buatTombol("OpenEgg", "Mulai Auto Telur", UDim2.new(0,160,0,10))

-- Flag
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

-- Fungsi auto telur
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

-- Coroutine
local farmMoneyCoroutine
local openEggCoroutine

local function mulaiFarmMoney()
    if farmMoneyCoroutine then return end
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

local function mulaiOpenEgg()
    if openEggCoroutine then return end
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

-- Klik tombol
farmMoneyBtn.MouseButton1Click:Connect(function()
    farmMoneyActive = not farmMoneyActive
    if farmMoneyActive then
        farmMoneyBtn.Text = "Stop Auto Uang"
        mulaiFarmMoney()
    else
        farmMoneyBtn.Text = "Mulai Auto Uang"
        stopFarmMoney()
    end
end)

openEggBtn.MouseButton1Click:Connect(function()
    openEggActive = not openEggActive
    if openEggActive then
        openEggBtn.Text = "Stop Auto Telur"
        mulaiOpenEgg()
    else
        openEggBtn.Text = "Mulai Auto Telur"
        stopOpenEgg()
    end
end)
