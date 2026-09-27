--[[开源来自Yuxingchen｜工业垃圾禁止圈钱｜NOLSAKEN]]
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Library.lua"))()

local Window = UI:CreateWindow({
    Name = "LuoYeUI",
    Title = "落叶 Pro",
    Subtitle = "犯罪bykr X",
    Rainbow = true,
    Size = UDim2.fromOffset(760, 465)
})

local w = Window:Tab({
    Title = "本地玩家",
    Desc = ""
})

local q = Window:Tab({
    Title = "自动功能",
    Desc = ""
})

local a = Window:Tab({
    Title = "ESP区域",
    Desc = ""
})

local s = Window:Tab({
    Title = "自瞄区域",
    Desc = ""
})

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local nightBrightConn
local oldBrightness
local oldAmbient
local oldOutdoorAmbient
local oldExposureCompensation

w:Toggle({
    Title = "提亮",
    Value = false,
    Callback = function(v)
        if v then
            oldBrightness = Lighting.Brightness
            oldAmbient = Lighting.Ambient
            oldOutdoorAmbient = Lighting.OutdoorAmbient
            oldExposureCompensation = Lighting.ExposureCompensation

            if nightBrightConn then
                nightBrightConn:Disconnect()
                nightBrightConn = nil
            end

            nightBrightConn = RunService.RenderStepped:Connect(function()
                local time = Lighting.ClockTime
                local isNight = time >= 18 or time <= 6

                if isNight then
                    Lighting.Brightness = 4
                    Lighting.Ambient = Color3.fromRGB(140, 140, 140)
                    Lighting.OutdoorAmbient = Color3.fromRGB(160, 160, 160)
                    Lighting.ExposureCompensation = 0.8
                else
                    if oldBrightness ~= nil then Lighting.Brightness = oldBrightness end
                    if oldAmbient ~= nil then Lighting.Ambient = oldAmbient end
                    if oldOutdoorAmbient ~= nil then Lighting.OutdoorAmbient = oldOutdoorAmbient end
                    if oldExposureCompensation ~= nil then Lighting.ExposureCompensation = oldExposureCompensation end
                end
            end)
        else
            if nightBrightConn then
                nightBrightConn:Disconnect()
                nightBrightConn = nil
            end

            if oldBrightness ~= nil then Lighting.Brightness = oldBrightness end
            if oldAmbient ~= nil then Lighting.Ambient = oldAmbient end
            if oldOutdoorAmbient ~= nil then Lighting.OutdoorAmbient = oldOutdoorAmbient end
            if oldExposureCompensation ~= nil then Lighting.ExposureCompensation = oldExposureCompensation end
        end
    end
})

local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local fpsGui
local fpsConn

w:Toggle({
    Title = "显示FPS",
    Desc = "点击运行",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        if v then
            if fpsGui then
                fpsGui:Destroy()
                fpsGui = nil
            end

            if fpsConn then
                fpsConn:Disconnect()
                fpsConn = nil
            end

            fpsGui = Instance.new("ScreenGui")
            fpsGui.Name = "FPS"
            fpsGui.ResetOnSpawn = false
            fpsGui.Parent = PlayerGui

            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(0, 100, 0, 50)
            t.Position = UDim2.new(0, 10, 0, 10)
            t.BackgroundTransparency = 1
            t.TextColor3 = Color3.new(1, 1, 1)
            t.TextSize = 20
            t.Font = Enum.Font.SourceSans
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Text = "FPS: ..."
            t.Parent = fpsGui

            local frames = 0
            local elapsed = 0

            fpsConn = RunService.RenderStepped:Connect(function(dt)
                frames = frames + 1
                elapsed = elapsed + dt

                if elapsed >= 0.8 then
                    t.Text = "FPS: " .. math.floor(frames / elapsed + 0.5)
                    frames = 0
                    elapsed = 0
                end
            end)
        else
            if fpsGui then
                fpsGui:Destroy()
                fpsGui = nil
            end

            if fpsConn then
                fpsConn:Disconnect()
                fpsConn = nil
            end
        end
    end
})

local pingGui
local pingConn

local function getPing()
    local ok, result = pcall(function()
        local network = Stats:FindFirstChild("Network")
        if not network then return nil end

        local serverStats = network:FindFirstChild("ServerStatsItem")
        if not serverStats then return nil end

        local pingItem = serverStats:FindFirstChild("Data Ping")

        if not pingItem then
            for _, item in ipairs(serverStats:GetChildren()) do
                if string.find(string.lower(item.Name), "ping") then
                    pingItem = item
                    break
                end
            end
        end

        if pingItem then
            return pingItem:GetValue()
        end

        return nil
    end)

    if ok and tonumber(result) then
        return math.floor(result + 0.5)
    end

    return nil
end

w:Toggle({
    Title = "网络检测",
    Desc = "显示Ping",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        if v then
            if pingGui then
                pingGui:Destroy()
                pingGui = nil
            end

            if pingConn then
                pingConn:Disconnect()
                pingConn = nil
            end

            pingGui = Instance.new("ScreenGui")
            pingGui.Name = "Ping"
            pingGui.ResetOnSpawn = false
            pingGui.Parent = PlayerGui

            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(0, 100, 0, 50)
            t.Position = UDim2.new(0, 10, 0, 60)
            t.BackgroundTransparency = 1
            t.TextColor3 = Color3.new(1, 1, 1)
            t.TextSize = 20
            t.Font = Enum.Font.SourceSans
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Text = "延迟: ..."
            t.Parent = pingGui

            local elapsed = 0

            pingConn = RunService.RenderStepped:Connect(function(dt)
                elapsed = elapsed + dt

                if elapsed >= 0.5 then
                    local ping = getPing()
                    if ping then
                        t.Text = "延迟: " .. ping .. "ms"
                    else
                        t.Text = "延迟: N/A"
                    end

                    elapsed = 0
                end
            end)
        else
            if pingGui then
                pingGui:Destroy()
                pingGui = nil
            end

            if pingConn then
                pingConn:Disconnect()
                pingConn = nil
            end
        end
    end
})

local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local AutoOpenDoor = false
local DoorRange = 15
local ClickDelay = 0.45
local working = false

local function getHRP()
    local char = lp.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getPos(obj)
    if not obj then return nil end

    if obj:IsA("BasePart") then
        return obj.Position
    end

    if obj:IsA("Attachment") then
        return obj.WorldPosition
    end

    if obj:IsA("Model") then
        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
        return part and part.Position
    end

    local part = obj:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position
end

local function getDoorsFolder()
    local map = workspace:FindFirstChild("Map")
    return map and map:FindFirstChild("Doors")
end

local function getNearestDoor()
    local hrp = getHRP()
    local doors = getDoorsFolder()
    if not hrp or not doors then return nil end

    local nearest
    local nearestDist = DoorRange

    for _, door in ipairs(doors:GetChildren()) do
        local pos = getPos(door)
        if pos then
            local dist = (hrp.Position - pos).Magnitude
            if dist <= nearestDist then
                nearest = door
                nearestDist = dist
            end
        end
    end

    return nearest
end

local function isDoorOpened(door)
    local values = door and door:FindFirstChild("Values")
    if not values then return false end

    for _, v in ipairs(values:GetChildren()) do
        local name = string.lower(v.Name)

        if (name == "open" or name == "opened" or name == "isopen") and v:IsA("BoolValue") then
            return v.Value == true
        end
    end

    return false
end

local function getPromptFromDoor(door)
    if not door then return nil end

    for _, v in ipairs(door:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled then
            return v
        end
    end

    local hrp = getHRP()
    if not hrp then return nil end

    local doors = getDoorsFolder()
    if not doors then return nil end

    local nearestPrompt
    local nearestDist = DoorRange

    for _, v in ipairs(doors:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled then
            local pos = getPos(v.Parent)
            if pos then
                local dist = (hrp.Position - pos).Magnitude
                if dist <= nearestDist then
                    nearestPrompt = v
                    nearestDist = dist
                end
            end
        end
    end

    return nearestPrompt
end

local function firePrompt(prompt)
    if not prompt then return end

    if fireproximityprompt then
        pcall(function()
            fireproximityprompt(prompt)
        end)
        return
    end

    pcall(function()
        prompt:InputHoldBegin()
    end)

    task.wait((prompt.HoldDuration or 0) + 0.08)

    pcall(function()
        prompt:InputHoldEnd()
    end)
end

task.spawn(function()
    while task.wait(ClickDelay) do
        if AutoOpenDoor and not working then
            working = true

            local door = getNearestDoor()
            if door and not isDoorOpened(door) then
                local prompt = getPromptFromDoor(door)
                if prompt then
                    firePrompt(prompt)
                end
            end

            working = false
        end
    end
end)

q:Toggle({
    Title = "自动开门",
    Value = false,
    Callback = function(v)
        AutoOpenDoor = v
    end
})

local running = false
local loopThread = nil

q:Toggle({
    Title = "无限体力",
    Value = false,
    Callback = function(v)
        running = v
        if v and not loopThread then
            loopThread = task.spawn(function()
                while running do
                    pcall(function()
                        for _, obj in pairs(getgc(true)) do
                            if type(obj) == "table" and rawget(obj, "S") then
                                pcall(function()
                                    obj.S = 100
                                end)
                            end
                        end
                    end)
                    task.wait()
                end
                loopThread = nil
            end)
        end
    end
})

a:Section({
    Title = "ESP区域",
    Desc = "",
    Box = true,
    Opened = true,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

local ATMESP = false
local ATMs = {}

local ATMHolder = CoreGui:FindFirstChild("ATMESP_Holder") or Instance.new("Folder")
ATMHolder.Name = "ATMESP_Holder"
ATMHolder.Parent = CoreGui

local function getFolder()
    local map = workspace:FindFirstChild("Map")
    return map and map:FindFirstChild("ATMz")
end

local function getRealATM(model)
    local parts = model:FindFirstChild("Parts")
    local main = parts and parts:FindFirstChild("Main")
    return main and (main:FindFirstChild("atm") or main)
end

local function getPart(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    return obj:FindFirstChildWhichIsA("BasePart", true)
end

local function getPos(obj)
    if not obj then return nil end
    if obj:IsA("Model") then
        return obj:GetPivot().Position
    end

    local part = getPart(obj)
    return part and part.Position
end

local function addATM(model, atm)
    if ATMs[model] then return end

    local part = getPart(atm) or getPart(model)
    if not part then return end

    local adornee = model:IsA("Model") and model or atm

    local h = Instance.new("Highlight")
    h.Name = "ATM_Highlight"
    h.FillColor = Color3.fromRGB(0, 255, 0)
    h.OutlineColor = Color3.fromRGB(0, 255, 0)
    h.FillTransparency = 0.55
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = adornee
    h.Parent = ATMHolder

    local gui = Instance.new("BillboardGui")
    gui.Name = "ATM_Text"
    gui.Adornee = part
    gui.Size = UDim2.fromOffset(130, 32)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.AlwaysOnTop = true
    gui.MaxDistance = 1000000
    gui.Parent = ATMHolder

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.fromScale(1, 1)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.TextStrokeTransparency = 0.35
    txt.TextSize = 14
    txt.TextScaled = false
    txt.Font = Enum.Font.GothamBold
    txt.Parent = gui

    ATMs[model] = {
        part = part,
        h = h,
        gui = gui,
        txt = txt
    }
end

local function clearATM()
    for model, v in pairs(ATMs) do
        if v.h then v.h:Destroy() end
        if v.gui then v.gui:Destroy() end
        ATMs[model] = nil
    end
end

RunService.RenderStepped:Connect(function()
    if not ATMESP then return end

    local folder = getFolder()
    if not folder then return end

    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, model in ipairs(folder:GetChildren()) do
        if model.Name == "ATM" then
            local atm = getRealATM(model)
            local part = atm and getPart(atm)

            if atm and part then
                addATM(model, atm)

                local data = ATMs[model]
                if data and data.txt and data.part then
                    local dis = math.floor((root.Position - data.part.Position).Magnitude)
                    data.txt.Text = "ATM [" .. dis .. "m]"
                end
            end
        end
    end

    for model, data in pairs(ATMs) do
        if not model or not model.Parent or not data.part or not data.part.Parent then
            if data.h then data.h:Destroy() end
            if data.gui then data.gui:Destroy() end
            ATMs[model] = nil
        end
    end
end)

a:Toggle({
    Title = "ATM透视",
    Value = false,
    Callback = function(v)
        ATMESP = v

        if not v then
            clearATM()
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local ShopESP = false
local ShopLoop
local ShopData

local Holder = CoreGui:FindFirstChild("BarberShopESP_Holder") or Instance.new("Folder")
Holder.Name = "BarberShopESP_Holder"
Holder.Parent = CoreGui

local function getHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getPart(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    return obj:FindFirstChildWhichIsA("BasePart", true)
end

local function getShop()
    local map = workspace:FindFirstChild("Map")
    local shops = map and map:FindFirstChild("ProximityShops")
    return shops and shops:FindFirstChild("BarberShop")
end

local function getShopInfo(shop)
    if not shop then return nil end

    local part = getPart(shop)
    if not part then return nil end

    if shop:IsA("Model") then
        local cf, size = shop:GetBoundingBox()
        return cf.Position, part, math.clamp(size.Y / 2 + 3, 4, 15)
    end

    return part.Position, part, math.clamp(part.Size.Y / 2 + 3, 4, 15)
end

local function makeAnchor(pos)
    local p = Instance.new("Part")
    p.Name = "BarberShop_ESP_Anchor"
    p.Size = Vector3.new(1, 1, 1)
    p.Transparency = 1
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.Position = pos
    p.Parent = workspace
    return p
end

local function clearShopESP()
    if ShopData then
        if ShopData.hl then ShopData.hl:Destroy() end
        if ShopData.bb then ShopData.bb:Destroy() end
        if ShopData.anchor then ShopData.anchor:Destroy() end
        ShopData = nil
    end
end

local function addOrUpdateShopESP(shop)
    local pos, part, offsetY = getShopInfo(shop)
    if not pos then return end

    local anchorPos = pos + Vector3.new(0, offsetY, 0)
    local adornee = shop:IsA("Model") and shop or part

    if not ShopData then
        local anchor = makeAnchor(anchorPos)

        local hl = Instance.new("Highlight")
        hl.Name = "BarberShop_Highlight"
        hl.Adornee = adornee
        hl.FillColor = Color3.fromRGB(0, 255, 80)
        hl.OutlineColor = Color3.fromRGB(0, 255, 80)
        hl.FillTransparency = 0.45
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = Holder

        local bb = Instance.new("BillboardGui")
        bb.Name = "BarberShop_Text"
        bb.Adornee = anchor
        bb.Size = UDim2.fromOffset(160, 34)
        bb.StudsOffset = Vector3.new(0, 0, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 1000000
        bb.Parent = Holder

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.fromScale(1, 1)
        txt.BackgroundTransparency = 1
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.TextStrokeTransparency = 0.25
        txt.TextSize = 14
        txt.TextScaled = false
        txt.Font = Enum.Font.GothamBold
        txt.Text = "理发店"
        txt.Parent = bb

        ShopData = {
            pos = pos,
            anchor = anchor,
            hl = hl,
            bb = bb,
            txt = txt,
        }
    else
        ShopData.pos = pos

        if ShopData.anchor then
            ShopData.anchor.Position = anchorPos
        end

        if ShopData.hl then
            ShopData.hl.Adornee = adornee
        end
    end
end

a:Toggle({
    Title = "理发店透视",
    Value = false,
    Callback = function(v)
        ShopESP = v

        if not v then
            if ShopLoop then
                ShopLoop:Disconnect()
                ShopLoop = nil
            end
            clearShopESP()
            return
        end

        if ShopLoop then
            ShopLoop:Disconnect()
            ShopLoop = nil
        end

        local shop = getShop()
        if shop then
            addOrUpdateShopESP(shop)
        end

        ShopLoop = RunService.RenderStepped:Connect(function()
            if not ShopESP then return end

            local hrp = getHRP()
            local shop = getShop()

            if shop then
                addOrUpdateShopESP(shop)
            end

            if hrp and ShopData and ShopData.txt and ShopData.pos then
                local dist = math.floor((hrp.Position - ShopData.pos).Magnitude)
                ShopData.txt.Text = "理发店 [" .. dist .. "m]"
            end
        end)
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local ShopzESP = false
local ShopzLoop
local ShopzItems = {}

local Holder = CoreGui:FindFirstChild("ShopzESP_Holder") or Instance.new("Folder")
Holder.Name = "ShopzESP_Holder"
Holder.Parent = CoreGui

local function getHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getShopz()
    local map = workspace:FindFirstChild("Map")
    return map and map:FindFirstChild("Shopz")
end

local function getPart(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    return obj:FindFirstChildWhichIsA("BasePart", true)
end

local function isTarget(obj)
    return obj.Name == "Dealer" or obj.Name == "ArmoryDealer"
end

local function getInfo(obj)
    local part = getPart(obj)
    if not part then return end

    if obj:IsA("Model") then
        local cf, size = obj:GetBoundingBox()
        return cf.Position, part, math.clamp(size.Y / 2 + 3, 4, 16)
    end

    return part.Position, part, math.clamp(part.Size.Y / 2 + 3, 4, 16)
end

local function makeKey(name, pos)
    return name .. "_" ..
        math.floor(pos.X + 0.5) .. "_" ..
        math.floor(pos.Y + 0.5) .. "_" ..
        math.floor(pos.Z + 0.5)
end

local function makeAnchor(pos)
    local p = Instance.new("Part")
    p.Name = "Shopz_ESP_Anchor"
    p.Size = Vector3.new(1, 1, 1)
    p.Transparency = 1
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.Position = pos
    p.Parent = workspace
    return p
end

local function clearShopzESP()
    for _, v in pairs(ShopzItems) do
        if v.hl then v.hl:Destroy() end
        if v.bb then v.bb:Destroy() end
        if v.anchor then v.anchor:Destroy() end
    end
    table.clear(ShopzItems)
end

local function addOrUpdate(obj)
    local pos, part, offsetY = getInfo(obj)
    if not pos then return end

    local key = makeKey(obj.Name, pos)
    local anchorPos = pos + Vector3.new(0, offsetY, 0)
    local title = obj.Name == "ArmoryDealer" and "武器商人" or "商人"
    local adornee = obj:IsA("Model") and obj or part

    if not ShopzItems[key] then
        local anchor = makeAnchor(anchorPos)

        local hl = Instance.new("Highlight")
        hl.Name = "Shopz_Highlight"
        hl.Adornee = adornee
        hl.FillColor = Color3.fromRGB(0, 255, 80)
        hl.OutlineColor = Color3.fromRGB(0, 255, 80)
        hl.FillTransparency = 0.45
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = Holder

        local bb = Instance.new("BillboardGui")
        bb.Name = "Shopz_Text"
        bb.Adornee = anchor
        bb.Size = UDim2.fromOffset(170, 34)
        bb.StudsOffset = Vector3.new(0, 0, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 1000000
        bb.Parent = Holder

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.fromScale(1, 1)
        txt.BackgroundTransparency = 1
        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        txt.TextStrokeTransparency = 0.25
        txt.TextSize = 14
        txt.TextScaled = false
        txt.Font = Enum.Font.GothamBold
        txt.Text = title
        txt.Parent = bb

        ShopzItems[key] = {
            name = title,
            pos = pos,
            anchor = anchor,
            hl = hl,
            bb = bb,
            txt = txt,
        }
    else
        local data = ShopzItems[key]
        data.pos = pos
        data.name = title

        if data.anchor then
            data.anchor.Position = anchorPos
        end

        if data.hl then
            data.hl.Adornee = adornee
        end
    end
end

local function scanShopz()
    local folder = getShopz()
    if not folder then return end

    for _, obj in ipairs(folder:GetChildren()) do
        if isTarget(obj) then
            addOrUpdate(obj)
        end
    end
end

a:Toggle({
    Title = "黑商透视",
    Value = false,
    Callback = function(v)
        ShopzESP = v

        if not v then
            if ShopzLoop then
                ShopzLoop:Disconnect()
                ShopzLoop = nil
            end
            clearShopzESP()
            return
        end

        if ShopzLoop then
            ShopzLoop:Disconnect()
            ShopzLoop = nil
        end

        scanShopz()

        ShopzLoop = RunService.RenderStepped:Connect(function()
            if not ShopzESP then return end

            local hrp = getHRP()
            scanShopz()

            if not hrp then return end

            for _, data in pairs(ShopzItems) do
                if data.txt and data.pos then
                    local dist = math.floor((hrp.Position - data.pos).Magnitude)
                    data.txt.Text = data.name .. " [" .. dist .. "m]"
                end
            end
        end)
    end
})

_G.EspEnabled = false

local espDrawings = {}

local function drawingAvailable()
    return Drawing and Drawing.new
end

local function createEsp(player)
    if player == Players.LocalPlayer then return end
    if espDrawings[player] then return end
    if not drawingAvailable() then return end

    local esp = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        health = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        healthBar = Drawing.new("Line"),
        healthBarBg = Drawing.new("Line"),
        tracer = Drawing.new("Line")
    }

    esp.box.Thickness = 1
    esp.box.Filled = false
    esp.box.Color = Color3.fromRGB(255, 255, 255)
    esp.box.Visible = false

    esp.name.Size = 13
    esp.name.Center = true
    esp.name.Outline = true
    esp.name.Color = Color3.fromRGB(255, 255, 255)
    esp.name.Visible = false

    esp.health.Size = 13
    esp.health.Center = true
    esp.health.Outline = true
    esp.health.Color = Color3.fromRGB(0, 255, 0)
    esp.health.Visible = false

    esp.distance.Size = 13
    esp.distance.Center = true
    esp.distance.Outline = true
    esp.distance.Color = Color3.fromRGB(200, 200, 200)
    esp.distance.Visible = false

    esp.healthBar.Thickness = 2
    esp.healthBar.Color = Color3.fromRGB(0, 255, 0)
    esp.healthBar.Visible = false

    esp.healthBarBg.Thickness = 2
    esp.healthBarBg.Color = Color3.fromRGB(0, 0, 0)
    esp.healthBarBg.Visible = false

    esp.tracer.Thickness = 1
    esp.tracer.Color = Color3.fromRGB(255, 255, 255)
    esp.tracer.Transparency = 1
    esp.tracer.Visible = false

    espDrawings[player] = esp
end

local function removeEsp(player)
    local esp = espDrawings[player]
    if not esp then return end

    for _, drawing in pairs(esp) do
        pcall(function()
            drawing:Remove()
        end)
    end

    espDrawings[player] = nil
end

local function hideEsp(esp)
    for _, drawing in pairs(esp) do
        drawing.Visible = false
    end
end

local function updateEsp()
    if not _G.EspEnabled then return end
    if not drawingAvailable() then return end

    camera = workspace.CurrentCamera
    if not camera then return end

    local lchr = lp.Character
    local lhrp = lchr and lchr:FindFirstChild("HumanoidRootPart")

    for _, player in ipairs(Players:GetPlayers()) do
        createEsp(player)
    end

    for player, esp in pairs(espDrawings) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if hrp and head and hum and hum.Health > 0 then
            local hrpPos, onScreen = camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                local height = math.abs(headPos.Y - legPos.Y)
                local width = height * 0.6
                local healthPercent = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)

                esp.box.Size = Vector2.new(width, height)
                esp.box.Position = Vector2.new(hrpPos.X - width / 2, hrpPos.Y - height / 2)
                esp.box.Visible = true

                esp.name.Text = player.Name
                esp.name.Position = Vector2.new(hrpPos.X, headPos.Y - 15)
                esp.name.Visible = true

                esp.health.Text = tostring(math.floor(hum.Health))
                esp.health.Position = Vector2.new(hrpPos.X - width / 2 - 25, hrpPos.Y)
                esp.health.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                esp.health.Visible = true

                if lhrp then
                    local dist = (hrp.Position - lhrp.Position).Magnitude
                    esp.distance.Text = tostring(math.floor(dist)) .. "m"
                    esp.distance.Position = Vector2.new(hrpPos.X, legPos.Y + 5)
                    esp.distance.Visible = true
                else
                    esp.distance.Visible = false
                end

                esp.healthBarBg.From = Vector2.new(hrpPos.X - width / 2 - 5, headPos.Y)
                esp.healthBarBg.To = Vector2.new(hrpPos.X - width / 2 - 5, legPos.Y)
                esp.healthBarBg.Visible = true

                esp.healthBar.From = Vector2.new(hrpPos.X - width / 2 - 5, legPos.Y)
                esp.healthBar.To = Vector2.new(hrpPos.X - width / 2 - 5, legPos.Y - (legPos.Y - headPos.Y) * healthPercent)
                esp.healthBar.Visible = true

                esp.tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                esp.tracer.To = Vector2.new(hrpPos.X, hrpPos.Y)
                esp.tracer.Visible = true
            else
                hideEsp(esp)
            end
        else
            hideEsp(esp)
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    createEsp(player)
end

Players.PlayerAdded:Connect(createEsp)
Players.PlayerRemoving:Connect(removeEsp)

a:Toggle({
    Title = "透视",
    Value = false,
    Callback = function(state)
        _G.EspEnabled = state

        if state then
            if not _G.espLoop then
                _G.espLoop = RunService.RenderStepped:Connect(updateEsp)
            end
        else
            if _G.espLoop then
                _G.espLoop:Disconnect()
                _G.espLoop = nil
            end

            for _, esp in pairs(espDrawings) do
                hideEsp(esp)
            end
        end
    end
})

s:Section({
    Title = "自瞄区域",
    Desc = "",
    Box = true,
    Opened = true,
})

local fovCircle = Drawing.new("Circle")
fovCircle.Radius = 100
fovCircle.Filled = false
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Visible = false

spawn(function()
    while true do
        local cam = workspace.CurrentCamera
        if cam then
            local vp = cam.ViewportSize
            fovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
        end
        task.wait()
    end
end)

local aimlockConn = nil
local aimSettings = {
    fov = 100,
    smooth = 0.15,
    wallCheck = false,
    enabled = false,
    showFov = false,
    targetPart = "Head"
}

s:Input({
    Title = "自瞄灵敏度",
    Desc = "输入灵敏度 0.01-1",
    Value = "0.15",
    Placeholder = "输入数字",
    Callback = function(v)
        local speed = tonumber(v) or 0.15
        aimSettings.smooth = math.clamp(speed, 0.01, 1)
    end
})

s:Input({
    Title = "自瞄范围",
    Desc = "输入范围 50-500",
    Value = "100",
    Placeholder = "输入数字",
    Callback = function(v)
        local range = tonumber(v) or 100
        aimSettings.fov = math.clamp(range, 50, 500)
        fovCircle.Radius = aimSettings.fov
    end
})

s:Slider({
    Title = "FOV大小",
    Desc = "调整FOV圆圈大小",
    Step = 1,
    Value = {
        Min = 30,
        Max = 500,
        Default = 30,
    },
    Callback = function(value)
        aimSettings.fov = value
        fovCircle.Radius = aimSettings.fov
    end
})

s:Toggle({
    Title = "显示FOV",
    Value = false,
    Callback = function(state)
        aimSettings.showFov = state
        fovCircle.Visible = state
    end
})

s:Toggle({
    Title = "墙壁检测",
    Value = false,
    Callback = function(state)
        aimSettings.wallCheck = state
    end
})

local function getClosestPlayer()
    local pl = Players.LocalPlayer
    local cam = workspace.CurrentCamera
    local char = pl.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if not cam or not hrp then return nil end
    
    local closest = nil
    local closestDist = aimSettings.fov
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= pl and p.Character then
            local targetPart = p.Character:FindFirstChild(aimSettings.targetPart)
            local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            
            if targetPart and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local viewportCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (targetPos - viewportCenter).Magnitude
                    
                    if dist < closestDist then
                        if aimSettings.wallCheck then
                            local origin = cam.CFrame.Position
                            local dir = (targetPart.Position - origin)
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {pl.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            
                            local result = workspace:Raycast(origin, dir * 1000, rayParams)
                            
                            if result and result.Instance then
                                if result.Instance:IsDescendantOf(p.Character) then
                                    closest = targetPart
                                    closestDist = dist
                                end
                            end
                        else
                            closest = targetPart
                            closestDist = dist
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

s:Toggle({
    Title = "自瞄",
    Value = false,
    Callback = function(state)
        aimSettings.enabled = state
        
        if state then
            aimlockConn = game:GetService("RunService").RenderStepped:Connect(function()
                local pl = Players.LocalPlayer
                local cam = workspace.CurrentCamera
                local target = getClosestPlayer()
                
                if cam and target then
                    local camPos = cam.CFrame.Position
                    local targetPos = target.Position
                    local direction = (targetPos - camPos).Unit
                    local newCFrame = CFrame.new(camPos, camPos + direction)
                    cam.CFrame = cam.CFrame:Lerp(newCFrame, aimSettings.smooth)
                end
            end)
        else
            if aimlockConn then
                aimlockConn:Disconnect()
                aimlockConn = nil
            end
        end
    end
})

Window:SelectTab(w)
Window:SelectTab(a)
Window:SelectTab(q)
Window:SelectTab(s)