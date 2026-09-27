--[[开源来自Yuxingchen｜工业垃圾禁止圈钱｜NOLSAKEN]]
local function isValidAnimationId(id)
    local num = tostring(id):match("%d+")
    if not num then return false end
    if tostring(id) ~= num then return false end
    if #num < 6 then return false end
    return true
end

local function setAnimationId(anim, value)
    pcall(function()
        anim.AnimationId = value
    end)
end

local function sanitizeAnimation(anim)
    if not anim or not anim:IsA("Animation") then return end

    local ok, rawId = pcall(function()
        return anim.AnimationId
    end)
    if not ok then return end

    local id = tostring(rawId):match("%d+")
    if not id or not isValidAnimationId(id) then
        setAnimationId(anim, "")
    else
        setAnimationId(anim, "rbxassetid://" .. id)
    end
end

game.DescendantAdded:Connect(function(obj)
    if obj:IsA("Animation") then
        sanitizeAnimation(obj)
    end
end)

for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("Animation") then
        sanitizeAnimation(v)
    end
end

local function loadRemote(url)
    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not result or #result < 10 then
        return false, "HttpGet failed"
    end
    return true, result
end

local function compile(code)
    local func, err = loadstring(code)
    if not func then
        return false, err
    end
    local ok, result = pcall(func)
    if not ok then
        return false, result
    end
    return true, result
end

local success, content = loadRemote("https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Wind.lua")
if not success then
    return
end

local modified = content:gsub("game%.Players", "game:GetService('Players')")
local ok, result = compile(modified)

if not ok then
    ok, result = compile(content)
    if not ok then
        return
    end
end

local WindUI = result

local Window = WindUI:CreateWindow({
    User = {
        Enabled = false,
        Callback = function() end,
        Anonymous = false,
    },
    Title = "落叶Pro",
    Author = "力量传奇/作者kr X",
    IconThemed = false,
    ScrollBarEnabled = true,
    Folder = "wind ui",
    HideSearchBar = true,
    Transparent = true,
    SideBarWidth = 200,
    Theme = "Dark",
    Icon = "crown",
    Size = UDim2.fromOffset(550, 300),
})

local RunService = game:GetService("RunService")

Window:EditOpenButton({
    Title = "落叶Pro",
    Icon = "crown",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
    Active = true,

    Color = ColorSequence.new(
        Color3.fromRGB(120, 170, 255),
        Color3.fromRGB(235, 240, 255)
    )
})

local RunService = game:GetService("RunService")

local fpsTag = Window:Tag({
    Title = "FPS: 0",
    Icon = "",
    Color = Color3.fromRGB(180, 255, 255),
    Radius = 13,
})

local frames, elapsed = 0, 0

RunService.RenderStepped:Connect(function(dt)
    frames += 1
    elapsed += dt

    if elapsed >= 0.5 then
        local fps = math.floor(frames / elapsed + 0.5)

        pcall(function()
            if fpsTag.SetTitle then
                fpsTag:SetTitle("FPS: " .. fps)
            else
                fpsTag.Title = "FPS: " .. fps
            end
        end)

        frames, elapsed = 0, 0
    end
end)

Window:Tag({
    Title = "版本v4.7",
    Icon = "",
    Color = Color3.fromRGB(180, 255, 255),
    Radius = 13,
})

do
    local orig = Window.Tab
    function Window:Tab(cfg)
        if not cfg.Collapsible then
            return orig(self, cfg)
        end
        local sec = self:Section({
            Title = cfg.Title,
            Icon = cfg.Icon,
            Opened = cfg.Opened ~= false,
        })
        local proxy = setmetatable({}, { __index = sec })
        function proxy:Tab(sc)
            return sec:Tab(sc)
        end
        return proxy
    end
end
kk = Window:Tab({
    Title = "力量传奇",
    Icon = "",
    Locked = false,
    Collapsible = true,
    Opened = true,
})
strength_0 = kk:Tab({
    Title = "自动锻炼",
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local autoWeightState = false

strength_0:Toggle({
    Title = "自动哑铃",
    Value = false,
    Callback = function(state)
        autoWeightState = state
        if state then
            task.spawn(function()
                while autoWeightState do
                    local char = LocalPlayer.Character
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    local weight = (char and char:FindFirstChild("Weight")) or (backpack and backpack:FindFirstChild("Weight"))
                    
                    if weight then
                        if weight.Parent == backpack then
                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                            if hum then
                                hum:EquipTool(weight)
                            end
                        end
                        weight:Activate()
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

strength_1 = kk:Tab({
    Title = "自动",
})

strength_1:Toggle({
    Title = "传送肌肉之王",
    Value = false,
    Callback = function(v)
        _G.gomk = v
    end
})

spawn(function()
    while true do
        if _G.gomk then
            local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(-8625.93, 13.57, -5730.47)
            end
        end
        task.wait()
    end
end)

strength_2 = kk:Tab({
    Title = "自动刷石头",
})

local stonelocs = {
    {n = "0石头", p = CFrame.new(15.53, 0.76, 2117.85)},
    {n = "10石头", p = CFrame.new(-151.39, 2.10, 437.53)},
    {n = "100石头", p = CFrame.new(164.47, 1.24, -137.76)},
    {n = "5000石头", p = CFrame.new(313.02, 2.06, -559.59)},
    {n = "150000石头", p = CFrame.new(-2514.23, 1.07, -256.83)},
    {n = "400000石头", p = CFrame.new(2186.48, 8.09, 1290.90)},
    {n = "750000石头", p = CFrame.new(-7262.31, 9.66, -1218.25)},
    {n = "100万石头", p = CFrame.new(4132.50, 991.64, -4035.54)},
    {n = "500万石头", p = CFrame.new(-8985.91, 17.23, -5989.86)},
    {n = "1000万石头", p = CFrame.new(-7639.93, 4.30, 3007.76)},
}

for _, s in pairs(stonelocs) do
    _G["stone_" .. s.n] = false
    strength_2:Toggle({
        Title = s.n,
        Value = false,
        Callback = function(v)
            _G["stone_" .. s.n] = v
        end
    })
end

spawn(function()
    while true do
        for _, s in pairs(stonelocs) do
            if _G["stone_" .. s.n] then
                local pl = Players.LocalPlayer
                if pl and pl.Character then
                    local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                    local hu = pl.Character:FindFirstChildOfClass("Humanoid")
                    local ch = pl.Character
                    if hrp then hrp.CFrame = s.p end
                    local punch = pl.Backpack:FindFirstChild("Punch")
                    if punch and hu then 
                        hu:EquipTool(punch)
                    end
                    if ch then
                        local p = ch:FindFirstChild("Punch")
                        if p then p:Activate() end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

strength_3 = kk:Tab({
    Title = "传送",
})

strength_3:Button({
    Title = "自动宝箱",
    Callback = function()
        spawn(function()
            for c = 1, 2 do
                local tps = {
                    CFrame.new(-138.17, 7.33, -276.85),
                    CFrame.new(4680.29, 1001.05, -3689.63),
                    CFrame.new(2213.03, 7.33, 918.64),
                    CFrame.new(-6713.86, 7.33, -1454.19),
                    CFrame.new(-2572.08, 7.33, -556.94),
                    CFrame.new(40.71, 7.33, 410.27),
                    CFrame.new(-7914.54, 4.30, 3028.47)
                }
                local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, cf in pairs(tps) do
                        hrp.CFrame = cf
                        task.wait(5)
                    end
                end
                local cr = game:GetService("ReplicatedStorage"):FindFirstChild("chestRewards")
                local ch = game:GetService("ReplicatedStorage"):FindFirstChild("rEvents") and game:GetService("ReplicatedStorage").rEvents:FindFirstChild("checkChestRemote")
                if cr and ch then
                    local jk = {}
                    for _, v in pairs(cr:GetDescendants()) do
                        if v.Name ~= "Light Karma Chest" and v.Name ~= "Evil Karma Chest" then
                            table.insert(jk, v.Name)
                        end
                    end
                    for _, n in pairs(jk) do
                        ch:InvokeServer(n)
                        task.wait(2)
                    end
                end
                task.wait(3)
            end
        end)
    end
})

local tps = {
    {n = "沙滩", p = CFrame.new(-42.7, 3.7, 404.2)},
    {n = "小岛(0-1000力量)", p = CFrame.new(-37.64, 3.87, 1879.18)},
    {n = "冰霜健身房(1重生)", p = CFrame.new(-2623.02, 3.72, -409.07)},
    {n = "神话健身房(5重生)", p = CFrame.new(2250.78, 3.72, 1073.23)},
    {n = "永恒健身房(15重生)", p = CFrame.new(-6758.96, 3.72, -1284.92)},
    {n = "传奇健身房(30重生)", p = CFrame.new(4603.28, 987.87, -3897.87)},
    {n = "力量之王健身房(5重生)", p = CFrame.new(-8625.93, 13.57, -5730.47)},
    {n = "狂野健身房(60重生)", p = CFrame.new(-8693.09, 8.94, 2400.66)},
}

for _, tp in pairs(tps) do
    strength_3:Button({
        Title = tp.n,
        Callback = function()
            local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = tp.p end
        end
    })
end

strength_4 = kk:Tab({
    Title = "跑步机",
})

local treadmills = {
    {n = "跑步机海滩10", p = CFrame.new(238.67, 5.40, 387.71), ag = 0},
    {n = "跑步机冰霜2000", p = CFrame.new(-3005.38, 14.32, -464.70), ag = 2000},
    {n = "跑步机神话2000", p = CFrame.new(2571.24, 15.69, 898.65), ag = 2000},
    {n = "跑步机永恒3500", p = CFrame.new(-7077.79, 29.67, -1457.60), ag = 3500},
    {n = "跑步机传奇3000", p = CFrame.new(4370.83, 999.36, -3621.43), ag = 3000},
}

for _, tm in pairs(treadmills) do
    _G["tm_" .. tm.n] = false
    strength_4:Toggle({
        Title = tm.n,
        Value = false,
        Callback = function(v)
            _G["tm_" .. tm.n] = v
        end
    })
end

spawn(function()
    while true do
        for _, tm in pairs(treadmills) do
            if _G["tm_" .. tm.n] then
                local pl = Players.LocalPlayer
                local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
                local hu = pl.Character and pl.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hu then
                    hu.WalkSpeed = 10
                    hrp.CFrame = tm.p
                    hu:Move(Vector3.new(10000, 0, -1), true)
                end
            end
        end
        task.wait()
    end
end)

strength_5 = kk:Tab({
    Title = "自动蹲起",
})

local squats = {
    {n = "沙滩蹲起", p = CFrame.new(232.63, 3.68, 96.30), st = 1000},
}

for _, sq in pairs(squats) do
    _G["sq_" .. sq.n] = false
    strength_5:Toggle({
        Title = sq.n,
        Value = false,
        Callback = function(v)
            _G["sq_" .. sq.n] = v
        end
    })
end

spawn(function()
    while true do
        for _, sq in pairs(squats) do
            if _G["sq_" .. sq.n] then
                local pl = Players.LocalPlayer
                local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
                local miu = pl:FindFirstChild("machineInUse")
                if hrp and miu and miu.Value == nil then
                    hrp.CFrame = sq.p
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                else
                    local me = pl:FindFirstChild("muscleEvent")
                    local ms = game:GetService("Workspace"):FindFirstChild("machinesFolder")
                    if me and ms then
                        local sr = ms:FindFirstChild("Squat Rack")
                        if sr then me:FireServer("rep", sr.interactSeat) end
                    end
                end
            end
        end
        task.wait()
    end
end)

strength_6 = kk:Tab({
    Title = "引体向上",
})

local pullups = {
    {n = "海滩引体", p = CFrame.new(-185.16, 5.81, 104.75), st = 1000},
}

for _, pu in pairs(pullups) do
    _G["pu_" .. pu.n] = false
    strength_6:Toggle({
        Title = pu.n,
        Value = false,
        Callback = function(v)
            _G["pu_" .. pu.n] = v
        end
    })
end

spawn(function()
    while true do
        for _, pu in pairs(pullups) do
            if _G["pu_" .. pu.n] then
                local pl = Players.LocalPlayer
                local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
                local miu = pl:FindFirstChild("machineInUse")
                if hrp and miu and miu.Value == nil then
                    hrp.CFrame = pu.p
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                else
                    local me = pl:FindFirstChild("muscleEvent")
                    local ms = game:GetService("Workspace"):FindFirstChild("machinesFolder")
                    if me and ms then
                        local lp = ms:FindFirstChild("Legends Pullup")
                        if lp then me:FireServer("rep", lp.interactSeat) end
                    end
                end
            end
        end
        task.wait()
    end
end)

strength_7 = kk:Tab({
    Title = "自动举重",
})

local deadlifts = {
    {n = "海滩举重", p = CFrame.new(136.61, 3.68, 97.66), st = 1500},
}

for _, dl in pairs(deadlifts) do
    _G["dl_" .. dl.n] = false
    strength_7:Toggle({
        Title = dl.n,
        Value = false,
        Callback = function(v)
            _G["dl_" .. dl.n] = v
        end
    })
end

spawn(function()
    while true do
        for _, dl in pairs(deadlifts) do
            if _G["dl_" .. dl.n] then
                local pl = Players.LocalPlayer
                local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
                local miu = pl:FindFirstChild("machineInUse")
                if hrp and miu and miu.Value == nil then
                    hrp.CFrame = dl.p
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                else
                    local me = pl:FindFirstChild("muscleEvent")
                    local ms = game:GetService("Workspace"):FindFirstChild("machinesFolder")
                    if me and ms then
                        local df = ms:FindFirstChild("Deadlift")
                        if df then me:FireServer("rep", df.interactSeat) end
                    end
                end
            end
        end
        task.wait()
    end
end)

strength_8 = kk:Tab({
    Title = "自动投石",
})

local throws = {
    {n = "海滩投石", p = CFrame.new(-91.67, 3.68, -292.43), st = 3000},
    {n = "神话投石", p = CFrame.new(2486.02, 3.68, 1237.89), st = 10000},
    {n = "传奇投石", p = CFrame.new(4189.96, 987.83, -3903.02), st = 0},
}

for _, th in pairs(throws) do
    _G["th_" .. th.n] = false
    strength_8:Toggle({
        Title = th.n,
        Value = false,
        Callback = function(v)
            _G["th_" .. th.n] = v
        end
    })
end

spawn(function()
    while true do
        for _, th in pairs(throws) do
            if _G["th_" .. th.n] then
                local pl = Players.LocalPlayer
                local hrp = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
                local miu = pl:FindFirstChild("machineInUse")
                if hrp and miu and miu.Value == nil then
                    hrp.CFrame = th.p
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                else
                    local me = pl:FindFirstChild("muscleEvent")
                    local ms = game:GetService("Workspace"):FindFirstChild("machinesFolder")
                    if me and ms then
                        local df = ms:FindFirstChild("Deadlift")
                        if df then me:FireServer("rep", df.interactSeat) end
                    end
                end
            end
        end
        task.wait()
    end
end)
