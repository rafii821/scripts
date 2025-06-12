local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Referensi Remote
local remoteEvent = ReplicatedStorage:WaitForChild("Msg"):WaitForChild("RemoteEvent")
local drawHeroInvoke = ReplicatedStorage:WaitForChild("Tool"):WaitForChild("DrawUp"):WaitForChild("Msg"):WaitForChild("DrawHero")

-- Pengaturan UI
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

local farmMoneyBtn = createButton("FarmMoney", "Aktifkan Auto Farm Uang", UDim2.new(0,10,0,10))
local openEggBtn = createButton("OpenEgg", "Aktifkan Auto Buka Telur", UDim2.new(0,160,0,10))

-- Status
local farmMoneyActive = false
local openEggActive = false

-- Fungsi farming uang (memanggil Remote dengan beberapa argumen)
local function farmMoney()
    local args1 = {"\232\181\183\232\183\179", 14405.461171865463}
    local args2 = {"\232\181\183\232\183\179", 14400.405507802963}
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

local function startFarmMoney()
    if farmMoneyCoroutine then return end
    farmMoneyCoroutine = coroutine.create(function()
        while farmMoneyActive do
            farmMoney()
            wait(0.33) -- 3x lebih cepat
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
    openEggCoroutine = coroutine.create(function()
        while openEggActive do
            openEgg()
            wait(1) -- 3x lebih cepat
        end
    end)
    coroutine.resume(openEggCoroutine)
end

local function stopOpenEgg()
    openEggActive = false
    openEggCoroutine = nil
end

-- Event tombol
farmMoneyBtn.MouseButton1Click:Connect(function()
    farmMoneyActive = not farmMoneyActive
    if farmMoneyActive then
        farmMoneyBtn.Text = "Matikan Auto Farm Uang"
        startFarmMoney()
    else
        farmMoneyBtn.Text = "Aktifkan Auto Farm Uang"
        stopFarmMoney()
    end
end)

openEggBtn.MouseButton1Click:Connect(function()
    openEggActive = not openEggActive
    if openEggActive then
        openEggBtn.Text = "Matikan Auto Buka Telur"
        startOpenEgg()
    else
        openEggBtn.Text = "Aktifkan Auto Buka Telur"
        stopOpenEgg()
    end
end)
