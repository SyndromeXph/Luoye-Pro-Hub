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

local WindUI = nil

local success, content = loadRemote("https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Wind.lua")
if success then
    local modified = content:gsub("game%.Players", "game:GetService('Players')")
    local ok, result = compile(modified)
    if not ok then
        ok, result = compile(content)
    end
    if ok then
        WindUI = result
    end
end

if not WindUI then
    pcall(function()
        WindUI = shared.WindUI or getgenv().WindUI
    end)
end

if not WindUI then
    return
end

local Window = WindUI:CreateWindow({
    User = {
        Enabled = false,
        Callback = function() end,
        Anonymous = false,
    },
    Title = "落叶Pro",
    Author = "被遗弃/作者kr X",
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

-- 保持与原始版本一致的初始窗口尺寸：550 x 300
task.defer(function()
    pcall(function()
        Window.Size = UDim2.fromOffset(550, 300)
    end)
    pcall(function()
        if Window.Resize then
            Window:Resize(550, 300)
        end
    end)
end)

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

local fpsTag = Window:Tag({
    Title = "FPS: 0",
    Icon = "",
    Color = Color3.fromRGB(180, 255, 255),
    Radius = 13,
})

local frames, elapsed = 0, 0

RunService.RenderStepped:Connect(function(dt)
    frames = frames + 1
    elapsed = elapsed + dt

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

kingTab = Window:Tab({
    Title = "通用列表",
    Collapsible = true,
    Opened = true,
    Locked = false,
})

PraTab = kingTab:Tab({
    Title = "通用",
})

ImmTab = kingTab:Tab({
    Title = "状态免疫",
})

sceTab = kingTab:Tab({
    Title = "场景设置",
})

killerTab = Window:Tab({
    Title = "杀手",
    Collapsible = true,
    Opened = true,
    Locked = false,
})

hitTab = killerTab:Tab({
    Title = "碰撞箱扩展",
})

aimTab = killerTab:Tab({
    Title = "自瞄",
})

sucTab = killerTab:Tab({
    Title = "超强吸力",
})

skiTab = killerTab:Tab({
    Title = "自动技能",
})

tacTab = killerTab:Tab({
    Title = "冲刺拐弯",
})

antTab = killerTab:Tab({
    Title = "反背刺",
})

survivor = Window:Tab({
    Title = "幸存者",
    Collapsible = true,
    Opened = true,
    Locked = false,
})

autTab = survivor:Tab({
    Title = "访客1337",
})

PgeTab = survivor:Tab({
    Title = "发电机设置",
})

magazine = Window:Tab({
    Title = "杂志",
    Collapsible = true,
    Opened = true,
    Locked = false,
})

phyTab = magazine:Tab({
    Title = "体力设置",
})

espTab = magazine:Tab({
    Title = "透视ESP",
})

artTab = magazine:Tab({
    Title = "物品",
})

amuse = Window:Tab({
    Title = "娱乐项目",
    Collapsible = true,
    Opened = true,
    Locked = false,
})

amuTab = amuse:Tab({
    Title = "主要娱乐项目",
})

perTab = amuse:Tab({
    Title = "权限设置",
})

skin = Window:Tab({
    Title = "角色皮肤",
    Collapsible = true,
    Opened = false,
    Locked = false,
})

slaTab = skin:Tab({
    Title = "斩首者",
})

johTab = skin:Tab({
    Title = "约翰.多",
})

cooTab = skin:Tab({
    Title = "酷小孩",
})

lXlTab = skin:Tab({
    Title = "1X1X1X1",
})

sheTab = skin:Tab({
    Title = "谢德莱茨基",
})

chaTab = skin:Tab({
    Title = "机会",
})

twoTab = skin:Tab({
    Title = "两次",
})

x = Window:Tab({
    Title = "设置",
    Icon = "",
    Locked = false,
})

configTab = Window:Tab({
    Title = "配置",
    Icon = "save",
    Locked = false,
})

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 本地修改
PraTab:Section({
    Title = "本地修改",
    Box = true,
})

PraTab:Button({
    Title = "无敌",
    Callback = function()
        loadstring(game:HttpGet("http://www.kr520.top/xksoamcow.lua"))()
    end
})

PraTab:Button({
    Title = "自杀",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end
})

local jumpPowerValue = 50
PraTab:Slider({
    Title = "跳跃力量值",
    Flag = "LuoyeConfig_001",
    Value = {
        Min = 0,
        Max = 150,
        Default = 50,
    },
    Callback = function(value) 
        jumpPowerValue = value
    end
})

PraTab:Button({
    Title = "设置跳跃力量",
    Callback = function()
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            hum.JumpPower = jumpPowerValue
            hum.UseJumpPower = true
        end
    end
})

local showChatEnabled = false
local chatThread = nil
local antiHiddenStatsEnabled = false
local originalValues = {}
local paths = {
    "HideKillerWins",
    "HidePlaytime",
    "HideSurvivorWins"
}

local function saveOriginals(player)
    if not originalValues[player.UserId] then
        originalValues[player.UserId] = {}
    end
    for _, key in ipairs(paths) do
        local value = player.PlayerData.Settings.Privacy:FindFirstChild(key)
        if value then
            originalValues[player.UserId][key] = value.Value
        end
    end
end

local function reveal(player)
    for _, key in ipairs(paths) do
        local value = player.PlayerData.Settings.Privacy:FindFirstChild(key)
        if value then
            value.Value = false
        end
    end
end

local function restore(player)
    if originalValues[player.UserId] then
        for key, val in pairs(originalValues[player.UserId]) do
            local value = player.PlayerData.Settings.Privacy:FindFirstChild(key)
            if value then
                value.Value = val
            end
        end
    end
end

local function hiddenStatsFunc(disable)
    for _, player in ipairs(Players:GetPlayers()) do
        if disable then
            saveOriginals(player)
            reveal(player)
        else
            restore(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if antiHiddenStatsEnabled then
        saveOriginals(player)
        reveal(player)
    end
end)

local noclipState = false
local cachedParts = {}
local noclipLoop = nil

local function enableNoclip()
    local char = LP.Character
    if char then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then
                cachedParts[v] = v
                v.CanCollide = false
            end
        end
    end
end

local function disableNoclip()
    for _, v in pairs(cachedParts) do
        if v and v.Parent then
            v.CanCollide = true
        end
    end
    cachedParts = {}
end

local loopRunning = false
local loopThread = nil
local currentAnim = nil
local lastAnim = nil
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://75804462760596"

local function setupInvisibility(value)
    if value then
        loopRunning = true
        loopThread = task.spawn(function()
            while loopRunning do
                local char = LP.Character
                if char then
                    enableNoclip()
                    
                    local humanoid = char:FindFirstChild("Humanoid")
                    if humanoid then
                        local loadedAnim = humanoid:LoadAnimation(anim)
                        currentAnim = loadedAnim
                        loadedAnim.Looped = false
                        loadedAnim:Play()
                        loadedAnim:AdjustSpeed(0)
                        task.wait(0.1)
                        
                        if lastAnim then
                            lastAnim:Stop()
                            lastAnim:Destroy()
                        end
                        lastAnim = currentAnim
                    end
                else
                    currentAnim = nil
                end
                task.wait()
            end
        end)
        return true
    else
        loopRunning = false
        if loopThread then
            task.cancel(loopThread)
            loopThread = nil
        end

        if currentAnim then
            currentAnim:Stop()
            currentAnim = nil
        end

        local char = LP.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
            if humanoid then
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    track:AdjustSpeed(1)
                end
            end
            
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end

            local animateScript = char:FindFirstChild("Animate")
            if animateScript then
                animateScript.Disabled = true
                animateScript.Disabled = false
            end
        end
        return true
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if noclipState and LP.Character then
            enableNoclip()
        elseif not noclipState then
            disableNoclip()
        end
    end
end)

local antiBlindConn = nil
PraTab:Toggle({
    Title = "防眩晕",
    Flag = "LuoyeConfig_002",
    Value = false,
    Callback = function(state)
        if state then
            if antiBlindConn then antiBlindConn:Disconnect() end
            antiBlindConn = RunService.RenderStepped:Connect(function()
                for _, effect in pairs(game:GetService("Lighting"):GetChildren()) do
                    if effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                        effect.Enabled = false
                    end
                end
                local cam = workspace.CurrentCamera
                if cam then
                    for _, effect in pairs(cam:GetChildren()) do
                        if effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                            effect.Enabled = false
                        end
                    end
                end
            end)
        else
            if antiBlindConn then
                antiBlindConn:Disconnect()
                antiBlindConn = nil
            end
        end
    end
})

PraTab:Toggle({
    Title = "显示聊天",
    Flag = "LuoyeConfig_003",
    Value = false,
    Callback = function(state)
        showChatEnabled = state
        if chatThread then
            task.cancel(chatThread)
            chatThread = nil
        end
        if state then
            chatThread = task.spawn(function()
                while showChatEnabled and task.wait() do
                    pcall(function()
                        local chatConfig = game:GetService("TextChatService"):FindFirstChildOfClass("ChatWindowConfiguration")
                        if chatConfig then
                            chatConfig.Enabled = true
                        end
                    end)
                end
            end)
        else
            pcall(function()
                local chatConfig = game:GetService("TextChatService"):FindFirstChildOfClass("ChatWindowConfiguration")
                if chatConfig then
                    chatConfig.Enabled = false
                end
            end)
        end
    end
})

PraTab:Toggle({
    Title = "显示被隐藏的统计表",
    Flag = "LuoyeConfig_004",
    Value = false,
    Callback = function(state)
        antiHiddenStatsEnabled = state
        hiddenStatsFunc(state)
    end
})

local flySpeed = 50
local flightConn = nil
local flyBodyGyro = nil
local flyBodyVel = nil

PraTab:Toggle({
    Title = "飞行",
    Flag = "LuoyeConfig_005",
    Value = false,
    Callback = function(value)
        if value then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local root = character:WaitForChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.AutoRotate = false

                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.P = 90000
                flyBodyGyro.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
                flyBodyGyro.CFrame = root.CFrame
                flyBodyGyro.Parent = root

                flyBodyVel = Instance.new("BodyVelocity")
                flyBodyVel.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
                flyBodyVel.Velocity = Vector3.zero
                flyBodyVel.Parent = root

                flightConn = RunService.Heartbeat:Connect(function()
                    local cam = workspace.CurrentCamera
                    local lookVector = cam.CFrame.LookVector
                    local rightVector = cam.CFrame.RightVector
                    local moveDir = humanoid.MoveDirection

                    local forward = moveDir:Dot(Vector3.new(lookVector.X, 0, lookVector.Z).Unit)
                    local right = moveDir:Dot(Vector3.new(rightVector.X, 0, rightVector.Z).Unit)
                    local up = moveDir.Magnitude <= 0 and 0 or lookVector.Y * forward

                    local velocity = lookVector * forward + rightVector * right
                    local finalVelocity = Vector3.new(velocity.X, up, velocity.Z)

                    if finalVelocity.Magnitude > 1 then
                        finalVelocity = finalVelocity.Unit
                    end

                    flyBodyVel.Velocity = finalVelocity * flySpeed
                    flyBodyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + lookVector, cam.CFrame.UpVector)
                end)
            end
        else
            if flightConn then
                flightConn:Disconnect()
                flightConn = nil
            end
            if flyBodyGyro then
                flyBodyGyro:Destroy()
                flyBodyGyro = nil
            end
            if flyBodyVel then
                flyBodyVel:Destroy()
                flyBodyVel = nil
            end

            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.AutoRotate = true
                end
            end
        end
    end
})

PraTab:Toggle({
    Title = "穿墙",
    Flag = "LuoyeConfig_006",
    Value = false,
    Callback = function(state)
        noclipState = state
        if not state then
            disableNoclip()
        end
    end
})

-- 状态免疫
ImmTab:Section({
    Title = "状态免除",
    Box = true,
    Opened = true,
})

do
    local statusGroups = {
        Slowness      = { on = false, paths = { "Modules.StatusEffects.Slowness" } },
        Hallucination = { on = false, paths = { "Modules.StatusEffects.KillerExclusive.Hallucination" } },
        Visual        = { on = false, paths = {
            "Modules.StatusEffects.Blindness",
            "Modules.StatusEffects.KillerExclusive.Glitched",
            "Modules.StatusEffects.SurvivorExclusive.Subspaced"
        } },
    }
    local statusBackup = {}

    local function statusResolve(path)
        local node = game:GetService("ReplicatedStorage")
        for seg in path:gmatch("[^%.]+") do
            node = node:FindFirstChild(seg)
            if not node then return nil end
        end
        return node
    end

    local function statusBlock(path)
        if statusBackup[path] then return end
        local mod = statusResolve(path)
        if mod and mod:IsA("ModuleScript") then
            statusBackup[path] = { clone = mod:Clone(), src = mod.Source }
            mod:Destroy()
        end
    end

    local function statusRestore(path)
        local saved = statusBackup[path]
        if not saved then return end
        local existing = statusResolve(path)
        if existing then existing:Destroy() end
        local parentPath = path:match("^(.-)%.?[^%.]+$")
        local parent = statusResolve(parentPath)
        if parent then
            saved.clone.Source = saved.src
            saved.clone.Parent = parent
        end
        statusBackup[path] = nil
    end

    local statusLoopThread = nil
    local function statusTick()
        if statusLoopThread then return end
        statusLoopThread = task.spawn(function()
            while true do
                local any = false
                for _, g in pairs(statusGroups) do
                    if g.on then
                        any = true
                        for _, p in ipairs(g.paths) do
                            local m = statusResolve(p)
                            if m then m:Destroy() end
                        end
                    end
                end
                if not any then break end
                task.wait(0.8)
            end
            statusLoopThread = nil
        end)
    end

    local function statusToggle(name)
        local g = statusGroups[name]
        if not g then return end
        g.on = not g.on
        for _, p in ipairs(g.paths) do
            if g.on then
                statusBlock(p)
            else
                statusRestore(p)
            end
        end
        local any = false
        for _, sg in pairs(statusGroups) do
            if sg.on then any = true; break end
        end
        if any then
            statusTick()
        elseif statusLoopThread then
            task.cancel(statusLoopThread)
            statusLoopThread = nil
        end
    end

ImmTab:Button({
    Title = "减速免疫",
    Callback = function()
        statusToggle("Slowness") 
    end
})

ImmTab:Button({
    Title = "删除幻觉",
    Callback = function()
        statusToggle("Hallucination") 
    end
})

ImmTab:Button({
    Title = "删除视觉",
    Callback = function()
       statusToggle("Visual") 
    end
})

  LP.CharacterAdded:Connect(function()
        for _, g in pairs(statusGroups) do
            if g.on then
                for _, p in ipairs(g.paths) do
                    statusRestore(p)
                end
            end
            g.on = false
        end
        if statusLoopThread then
            task.cancel(statusLoopThread)
            statusLoopThread = nil
        end
        statusBackup = {}
  end)
end

-- 场景设置
sceTab:Section({
    Title = "场景设置",
    Box = true,
    Opened = true,
})

local sceneEnv = {
    Brightness = 0,
    GlobalShadows = false,
    NoFog = false,
    Fullbright = false
}

if not game.Lighting:GetAttribute("FogStart") then
    game.Lighting:SetAttribute("FogStart", game.Lighting.FogStart)
end
if not game.Lighting:GetAttribute("FogEnd") then
    game.Lighting:SetAttribute("FogEnd", game.Lighting.FogEnd)
end

local originalFogDensity = nil
local fogAtmo = game.Lighting:FindFirstChildOfClass("Atmosphere")
if fogAtmo and not fogAtmo:GetAttribute("Density") then
    fogAtmo:SetAttribute("Density", fogAtmo.Density)
    originalFogDensity = fogAtmo.Density
end

local lightingConnection = nil

local function updateLighting()
    game.Lighting.FogStart = sceneEnv.NoFog and 0 or game.Lighting:GetAttribute("FogStart")
    game.Lighting.FogEnd = sceneEnv.NoFog and math.huge or game.Lighting:GetAttribute("FogEnd")
    
    local fog = game.Lighting:FindFirstChildOfClass("Atmosphere")
    if fog then
        if not fog:GetAttribute("Density") then
            fog:SetAttribute("Density", fog.Density)
        end
        fog.Density = sceneEnv.NoFog and 0 or fog:GetAttribute("Density")
    end
    
    if sceneEnv.Fullbright then
        game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        game.Lighting.Brightness = sceneEnv.Brightness
        game.Lighting.GlobalShadows = not sceneEnv.GlobalShadows
    else
        game.Lighting.OutdoorAmbient = Color3.fromRGB(55, 55, 55)
        game.Lighting.Brightness = 0
        game.Lighting.GlobalShadows = true
    end
end

local function toggleLightingLoop(enabled)
    if enabled then
        if lightingConnection then
            lightingConnection:Disconnect()
        end
        lightingConnection = RunService.RenderStepped:Connect(updateLighting)
    else
        if lightingConnection then
            lightingConnection:Disconnect()
            lightingConnection = nil
        end
        game.Lighting.OutdoorAmbient = Color3.fromRGB(55, 55, 55)
        game.Lighting.Brightness = 0
        game.Lighting.GlobalShadows = true
        game.Lighting.FogStart = game.Lighting:GetAttribute("FogStart") or 0
        game.Lighting.FogEnd = game.Lighting:GetAttribute("FogEnd") or math.huge
        if fogAtmo then
            fogAtmo.Density = fogAtmo:GetAttribute("Density") or originalFogDensity
        end
    end
end

sceTab:Toggle({
    Title = "总开关",
    Flag = "LuoyeConfig_007",
    Value = false,
    Callback = function(state)
        sceneEnv.Fullbright = state
        toggleLightingLoop(state)
    end
})

sceTab:Slider({
    Title = "亮度数值",
    Flag = "LuoyeConfig_008",
    Value = { 
        Min = 0, 
        Max = 15, 
        Default = 0 
    },
    Callback = function(value)
        sceneEnv.Brightness = value
        if sceneEnv.Fullbright then
            game.Lighting.Brightness = value
        end
    end
})

sceTab:Toggle({
    Title = "无阴影",
    Flag = "LuoyeConfig_009",
    Value = false,
    Callback = function(state)
        sceneEnv.GlobalShadows = state
        if sceneEnv.Fullbright then
            game.Lighting.GlobalShadows = not state
        end
    end
})

sceTab:Toggle({
    Title = "除雾",
    Flag = "LuoyeConfig_010",
    Value = false,
    Callback = function(state)
        sceneEnv.NoFog = state
        if sceneEnv.Fullbright then
            updateLighting()
        else
            game.Lighting.FogStart = state and 0 or game.Lighting:GetAttribute("FogStart")
            game.Lighting.FogEnd = state and math.huge or game.Lighting:GetAttribute("FogEnd")
            if fogAtmo then
                fogAtmo.Density = state and 0 or (fogAtmo:GetAttribute("Density") or originalFogDensity)
            end
        end
    end
})

-- 碰撞箱
hitTab:Section({
    Title = "碰撞箱设置",
    Box = true,
    Opened = true,
})

local hitboxExtender = {
    enabled = false,
    range = 10,
}

local function studsToPower(studs)
    return studs * 6
end

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        
        if hitboxExtender.enabled then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            
            local myHitboxDetected = false
            local hitboxesFolder = workspace:FindFirstChild("Hitboxes")
            local myUsername = char:GetAttribute("Username") or LP.Name
            local myHitboxName = myUsername .. "Hitbox"
            
            if hitboxesFolder and char then
                for _, part in ipairs(hitboxesFolder:GetChildren()) do
                    if part.Name == myHitboxName then
                        if hrp and (part.Position - hrp.Position).Magnitude <= 15 then
                            myHitboxDetected = true
                        end
                        break
                    end
                end
            end
            
            if myHitboxDetected and char and hrp and hrp.Parent then
                local velocity = hrp.AssemblyLinearVelocity
                if velocity.Magnitude > 0.5 then
                    local distance = studsToPower(hitboxExtender.range)
                    local moveDir = velocity.Magnitude > 0 and velocity.Unit or hrp.CFrame.LookVector
                    local newVelocity = velocity + (moveDir * distance)
                    hrp.AssemblyLinearVelocity = Vector3.new(newVelocity.X, velocity.Y, newVelocity.Z)
                    
                    RunService.RenderStepped:Wait()
                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        LP.Character.HumanoidRootPart.AssemblyLinearVelocity = velocity
                    end
                end
            end
        end
    end
end)

hitTab:Toggle({
    Title = "启用碰撞箱扩展",
    Flag = "LuoyeConfig_011",
    Value = false,
    Callback = function(v)
        hitboxExtender.enabled = v
    end
})

hitTab:Slider({
    Title = "碰撞箱长度",
    Flag = "LuoyeConfig_012",
    Value = {
        Min = 0,
        Max = 50,
        Default = 10
    },
    Callback = function(v)
        hitboxExtender.range = math.floor(v)
    end
})

-- 自瞄
local aim = {
    on = false,
    cooldown = 0.3,
    lockTime = 0.4,
    maxDist = 30,
    smooth = 0.35,
    targeting = false,
    target = nil,
    deathConn = nil,
    autoRotate = nil,
    lastFired = 0,
    hum = nil,
    hrp = nil,
    cache = {},
    cacheTime = 0,
    cacheLife = 0.5,
}

local function aimIsKiller()
    local char = LP.Character
    if not char then return false end
    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    return killersFolder and char:IsDescendantOf(killersFolder)
end

local function aimRefreshChar(ch)
    aim.hum = ch and ch:FindFirstChildOfClass("Humanoid")
    aim.hrp = ch and ch:FindFirstChild("HumanoidRootPart")
end

local function aimRefreshTargets()
    local now = tick()
    if now - aim.cacheTime < aim.cacheLife then return end
    aim.cacheTime = now
    aim.cache = {}
    local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
    if not survivorsFolder then return end
    for _, model in ipairs(survivorsFolder:GetChildren()) do
        if model ~= LP.Character and model:IsA("Model") then
            local h = model:FindFirstChildOfClass("Humanoid")
            local r = model:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 then
                table.insert(aim.cache, r)
            end
        end
    end
end

local function aimNearest()
    aimRefreshTargets()
    if not aim.hrp or #aim.cache == 0 then return nil end
    local best, bestDist = nil, math.huge
    for _, r in ipairs(aim.cache) do
        local d = (r.Position - aim.hrp.Position).Magnitude
        if d < bestDist and d <= aim.maxDist then
            bestDist = d
            best = r
        end
    end
    return best
end

local function aimUnlock()
    if not aim.targeting then return end
    if aim.deathConn then aim.deathConn:Disconnect(); aim.deathConn = nil end
    if aim.autoRotate ~= nil and aim.hum then
        aim.hum.AutoRotate = aim.autoRotate
    end
    aim.targeting = false
    aim.target = nil
end

local function aimLock(rootPart)
    if not rootPart or not rootPart.Parent or not aim.hum or not aim.hrp then return end
    if aim.targeting and aim.target == rootPart then return end
    aimUnlock()
    aim.target = rootPart
    aim.targeting = true
    aim.autoRotate = aim.hum.AutoRotate
    aim.hum.AutoRotate = false
    local targetHumanoid = rootPart.Parent:FindFirstChildOfClass("Humanoid")
    if targetHumanoid then
        aim.deathConn = targetHumanoid.Died:Connect(aimUnlock)
    end
    task.delay(aim.lockTime, function()
        if aim.target == rootPart then aimUnlock() end
    end)
end

local function setupAimbotTrigger()
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
        and game.ReplicatedStorage.Modules:FindFirstChild("Network")
        and game.ReplicatedStorage.Modules.Network:FindFirstChild("Network")
        and game.ReplicatedStorage.Modules.Network.Network:FindFirstChild("RemoteEvent")
    if not remote then
        return
    end
    remote.OnClientEvent:Connect(function(...)
        if not aim.on then return end
        local args = {...}
        if type(args[1]) ~= "string" then return end
        local abilityName = args[1]
        if abilityName:match("Ability") or abilityName:match("[QER]") or
           abilityName == "Slash" or abilityName == "Dagger" or abilityName == "Charge" or
           abilityName == "Stab" or abilityName == "Punch" then
            if tick() - aim.lastFired < aim.cooldown then return end
            aim.lastFired = tick()
            if aimIsKiller() then
                local target = aimNearest()
                if target then aimLock(target) end
            end
        end
    end)
end

LP.CharacterAdded:Connect(function(ch)
    task.wait(0.5)
    aimRefreshChar(ch)
end)
if LP.Character then
    aimRefreshChar(LP.Character)
end

RunService.RenderStepped:Connect(function()
    if not aim.on or not aim.targeting or not aim.hrp or not aim.target then return end
    if not aim.target.Parent then aimUnlock(); return end
    local targetHumanoid = aim.target.Parent:FindFirstChildOfClass("Humanoid")
    if not targetHumanoid or targetHumanoid.Health <= 0 then aimUnlock(); return end
    local flat = Vector3.new(
        aim.target.Position.X - aim.hrp.Position.X,
        0,
        aim.target.Position.Z - aim.hrp.Position.Z
    ).Unit
    if flat.Magnitude > 0 then
        aim.hrp.CFrame = aim.hrp.CFrame:Lerp(
            CFrame.new(aim.hrp.Position, aim.hrp.Position + flat),
            aim.smooth
        )
    end
end)

setupAimbotTrigger()

aimTab:Section({
    Title = "自瞄设置",
    Box = true,
    Opened = true,
})

aimTab:Toggle({
    Title = "使用自瞄",
    Flag = "LuoyeConfig_013",
    Value = aim.on,
    Callback = function(state)
        aim.on = state
        if not state then aimUnlock() 
        end
    end
})

aimTab:Slider({
    Title = "冷却时间 (秒)",
    Flag = "LuoyeConfig_014",
    Value = { 
        Min = 0.1, 
        Max = 2.0, 
        Default = aim.cooldown 
    },
    Callback = function(val)
        aim.cooldown = val
    end
})

aimTab:Slider({
    Title = "锁定时间 (秒)",
    Flag = "LuoyeConfig_015",
    Value = { 
        Min = 0.1, 
        Max = 3.0, 
        Default = aim.lockTime 
    },
    Callback = function(val)
        aim.lockTime = val
    end
})

aimTab:Slider({
    Title = "最大距离",
    Flag = "LuoyeConfig_016",
    Value = { 
        Min = 5, 
        Max = 100, 
        Default = aim.maxDist 
    },
    Callback = function(val)
        aim.maxDist = val
    end
})

aimTab:Slider({
    Title = "旋转平滑度",
    Flag = "LuoyeConfig_017",
    Value = { 
        Min = 0.05, 
        Max = 1.0, 
        Default = aim.smooth 
    },
    Callback = function(val)
        aim.smooth = val
    end
})

-- 超强吸力
sucTab:Section({
    Title = "变成磁铁吸在幸存者上",
    Box = true,
    Opened = true,
})

do
    local suction = {
        enabled = false,
        strength = 50,
        maxDist = 100,
        cache = {},
        cacheTime = 0,
        cacheLife = 0.3,
        conn = nil,
    }

    local function isKiller()
        local char = LP.Character
        if not char then return false end
        local killers = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
        return killers and char:IsDescendantOf(killers)
    end

    local function getNearestSurvivor()
        local now = tick()
        if now - suction.cacheTime < suction.cacheLife and suction.cache.target and suction.cache.target.Parent then
            return suction.cache.target
        end
        suction.cacheTime = now
        suction.cache = {}

        local survivors = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if not survivors then return nil end

        local char = LP.Character
        if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end

        local best, bestDist = nil, math.huge
        for _, model in ipairs(survivors:GetChildren()) do
            if model ~= char and model:IsA("Model") then
                local hum = model:FindFirstChildOfClass("Humanoid")
                local root = model:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 then
                    local d = (root.Position - hrp.Position).Magnitude
                    if d < bestDist and d <= suction.maxDist then
                        bestDist = d
                        best = root
                    end
                end
            end
        end
        suction.cache.target = best
        return best
    end

    local function pushToTarget(targetRoot)
        if not targetRoot or not targetRoot.Parent then return end

        local killerChar = LP.Character
        if not killerChar then return end
        local killerHRP = killerChar:FindFirstChild("HumanoidRootPart")
        if not killerHRP then return end

        local direction = (targetRoot.Position - killerHRP.Position)
        if direction.Magnitude < 0.1 then return end
        direction = direction.Unit

        local currentVel = killerHRP.AssemblyLinearVelocity
        local pushForce = direction * suction.strength
        local newVel = currentVel:Lerp(currentVel + pushForce, 0.3)
        killerHRP.AssemblyLinearVelocity = newVel
    end

    local function startSuction()
        if suction.conn then return end
        suction.conn = RunService.RenderStepped:Connect(function()
            if not suction.enabled then return end
            if not isKiller() then return end
            local target = getNearestSurvivor()
            if target then
                pushToTarget(target)
            end
        end)
    end

    local function stopSuction()
        if suction.conn then
            suction.conn:Disconnect()
            suction.conn = nil
        end
        suction.cache = {}
    end

sucTab:Toggle({
    Title = "冲向幸存者",
    Flag = "LuoyeConfig_018",
    Value = false,
    Callback = function(state)
        suction.enabled = state
        if state then startSuction() 
        else stopSuction() 
        end
    end
})

sucTab:Slider({
    Title = "吸力强度",
    Flag = "LuoyeConfig_019",
    Value = { 
        Min = 5, 
        Max = 100, 
        Default = 50 
    },
    Callback = function(v) 
        suction.strength = v 
    end
})

sucTab:Slider({
    Title = "最大搜索距离",
    Flag = "LuoyeConfig_020",
    Value = { 
        Min = 20, 
        Max = 200, 
        Default = 100 
    },
    Callback = function(v) 
        suction.maxDist = v 
    end
})

LP.CharacterAdded:Connect(function()
    if suction.enabled then
        stopSuction()
        startSuction()
    end
end)
end

-- 自动技能
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local function table_find(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then return i end
    end
    return nil
end

local autoBlockTriggerAnims = {
    ["124269076578545"] = true, ["126830014841198"] = true, ["126355327951215"] = true, ["121086746534252"] = true,
    ["18885909645"] = true, ["98456918873918"] = true, ["105458270463374"] = true, ["83829782357897"] = true,
    ["125403313786645"] = true, ["118298475669935"] = true, ["82113744478546"] = true, ["70371667919898"] = true,
    ["99135633258223"] = true, ["97167027849946"] = true, ["109230267448394"] = true, ["139835501033932"] = true,
    ["126896426760253"] = true, ["109667959938617"] = true, ["126681776859538"] = true, ["129976080405072"] = true,
    ["121293883585738"] = true, ["81639435858902"] = true, ["137314737492715"] = true, ["92173139187970"] = true,
    ["122709416391"] = true, ["879895330952"] = true, ["84069821282466"] = true, ["114506382930939"] = true,
    ["88451353906104"] = true, ["133066252175737"] = true, ["99824350842479"] = true, ["132243194360714"] = true,
    ["91341171001824"] = true, ["120307951"] = true, ["124705663396411"] = true, ["139309647473555"] = true,
    ["133363345661032"] = true, ["122709416391891"] = true, ["106131211773069"] = true, ["81299297965542"] = true,
    ["138938529389204"] = true, ["70483423693126"] = true, ["106776364623742"] = true, ["114126519127454"] = true,
    ["130958529065375"] = true, ["126727756047566"] = true, ["81803417290685"] = true, ["90620531468240"] = true,
    ["82691533602949"] = true, ["99829427721752"] = true, ["93366464803829"] = true, ["107032335460679"] = true,
    ["112135252467978"] = true, ["77375846492436"] = true, ["127245564598429"] = true,
    ["73921036900313"] = true, ["111384272984267"] = true, ["90499469533503"] = true, ["133491532453922"] = true,
    ["119434518007321"] = true, ["115194624791339"] = true, ["89448354637442"] = true, ["100725497418533"] = true,
    ["107640065977686"] = true, ["112902284724598"] = true, ["106086955212611"] = true, ["77119710693654"] = true,
}

local autoBlockTriggerSounds = {
    ["89004992452376"] = true, ["80516583309685"] = true, ["102228729296384"] = true, ["140242176732868"] = true,
    ["112809109188560"] = true, ["136323728355613"] = true, ["115026634746636"] = true, ["84116622032112"] = true,
    ["108907358619313"] = true, ["127793641088496"] = true, ["86174610237192"] = true, ["95079963655241"] = true,
    ["101199185291628"] = true, ["119942598489800"] = true, ["84307400688050"] = true, ["113037804008732"] = true,
    ["105200830849301"] = true, ["75330693422988"] = true, ["82221759983649"] = true, ["81702359653578"] = true,
    ["108610718831698"] = true, ["112395455254818"] = true, ["109431876587852"] = true, ["109348678063422"] = true,
    ["85853080745515"] = true, ["12222216"] = true, ["105840448036441"] = true, ["114742322778642"] = true,
    ["119583605486352"] = true, ["79980897195554"] = true, ["71805956520207"] = true, ["79391273191671"] = true,
    ["101553872555606"] = true, ["101698569375359"] = true, ["106300477136129"] = true, ["116581754553533"] = true,
    ["117231507259853"] = true, ["119089145505438"] = true, ["121954639447247"] = true, ["125213046326879"] = true,
    ["131406927389838"] = true, ["71834552297085"] = true, ["805165833096"] = true, ["823363523051"] = true,
    ["120059928759346"] = true, ["82336352305186"] = true, ["104625283622511"] = true, ["126131675979001"] = true,
    ["98675142200448"] = true,
}

local slasherParryAnims = {
    ["121255898612475"] = true, ["105614318732282"] = true, ["116618003477002"] = true,
    ["111918351126361"] = true, ["98031287364865"] = true, ["119462383658044"] = true,
    ["87259391926321"] = true, ["86096387000557"] = true, ["86709774283672"] = true,
    ["140703210927645"] = true, ["136007065400978"] = true, ["129843313690921"] = true,
    ["108807732150251"] = true, ["138040001965654"] = true,
    ["119434518007321"] = true, ["115194624791339"] = true, ["89448354637442"] = true,
    ["100725497418533"] = true, ["107640065977686"] = true, ["112902284724598"] = true,
    ["106086955212611"] = true, ["77119710693654"] = true,
    ["73921036900313"] = true, ["111384272984267"] = true, ["90499469533503"] = true,
    ["133491532453922"] = true,
}

local slasherParrySounds = {
    ["92445809840331"] = true, ["140258770018994"] = true, ["12222225"] = true,
    ["118234760889759"] = true, ["81714228693719"] = true, ["114486446625838"] = true,
    ["5569523548"] = true, ["119675090901934"] = true, ["132596270805754"] = true,
    ["127324570265084"] = true, ["129249459631748"] = true, ["12222208"] = true,
    ["104632327472742"] = true, ["110279274881589"] = true,
}

local localPunchAnims = {"87259391926321", "86096387000557", "86709774283672", "140703210927645", "136007065400978", "129843313690921", "108807732150251", "138040001965654"}
local oneShootAnims = {"73921036900313", "111384272984267", "90499469533503", "133491532453922"}
local twoTimeTriggerAnims = {
    ["119434518007321"] = true, ["115194624791339"] = true, ["89448354637442"] = true,
    ["100725497418533"] = true, ["107640065977686"] = true, ["112902284724598"] = true,
    ["106086955212611"] = true, ["77119710693654"] = true,
}

local function GetSurvivors()
    local survivors = {}
    local playersFolder = Workspace:FindFirstChild("Players")
    local survFolder = playersFolder and playersFolder:FindFirstChild("Survivors")
    if survFolder then
        for _, v in ipairs(survFolder:GetChildren()) do
            if v:IsA("Model") and v:GetAttribute("Username") then
                table.insert(survivors, v)
            end
        end
    end
    return survivors
end

local function GetKillers()
    local killers = {}
    local playersFolder = Workspace:FindFirstChild("Players")
    local killerFolder = playersFolder and playersFolder:FindFirstChild("Killers")
    if killerFolder then
        for _, v in ipairs(killerFolder:GetChildren()) do
            if v:IsA("Model") and v:GetAttribute("Username") then
                table.insert(killers, v)
            end
        end
    end
    return killers
end

local function ShouldParry(myRoot, parryRange)
    if not myRoot then return false end
    local survivors = GetSurvivors()
    for _, survModel in ipairs(survivors) do
        local sHrp = survModel:FindFirstChild("HumanoidRootPart")
        if sHrp then
            local dist = (sHrp.Position - myRoot.Position).Magnitude
            if dist <= (parryRange * 3) then
                local isStandardRange = dist <= parryRange
                local hum = survModel:FindFirstChildOfClass("Humanoid")
                local animator = hum and hum:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        local id = tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+")
                        if id then
                            local isGuestPunch = table_find(localPunchAnims, id) ~= nil
                            local isOneShoot = table_find(oneShootAnims, id) ~= nil
                            local validDist = false
                            if isOneShoot and dist <= (parryRange * 3) then
                                validDist = true
                            elseif (slasherParryAnims[id] or autoBlockTriggerAnims[id] or isGuestPunch or twoTimeTriggerAnims[id]) and isStandardRange then
                                validDist = true
                            end
                            if validDist and track.TimePosition <= 0.45 then
                                return true
                            end
                        end
                    end
                end
                if isStandardRange then
                    for _, desc in ipairs(survModel:GetDescendants()) do
                        if desc:IsA("Sound") and desc.IsPlaying then
                            local soundId = tostring(desc.SoundId):match("%d+")
                            if soundId and (autoBlockTriggerSounds[soundId] or slasherParrySounds[soundId]) then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

skiTab:Section({
    Title = "Slasher",
    Box = true,
    Opened = true,
})

local SlasherSettings = {
    EnragedEnabled = false,
    EnragedMultiplier = 2.111,
    AutoParry = false,
    ParryRange = 15,
}
local lastSlasherParryTime = 0

skiTab:Toggle({
    Title = "狂暴速度",
    Flag = "LuoyeConfig_021",
    Value = false,
    Callback = function(state)
        SlasherSettings.EnragedEnabled = state
    end
})

skiTab:Slider({
    Title = "狂暴速度滑块",
    Flag = "LuoyeConfig_022",
    Value = {
        Min = 2,
        Max = 3,
        Default = 2,
    },
    Callback = function(v)
        SlasherSettings.EnragedMultiplier = v
    end
})

skiTab:Toggle({
    Title = "自动狂暴格挡",
    Flag = "LuoyeConfig_023",
    Value = false,
    Callback = function(state)
        SlasherSettings.AutoParry = state
    end
})

skiTab:Slider({
    Title = "格挡检测范围",
    Flag = "LuoyeConfig_024",
    Value = {
        Min = 5,
        Max = 40,
        Default = 15,
    },
    Callback = function(v)
        SlasherSettings.ParryRange = v
    end
})

skiTab:Section({
    Title = "John Doe",
    Box = true,
    Opened = true,
})

local JohnDoeSettings = {
    AutoParry = false,
    ParryRange = 15,
}
local lastJohnDoeParryTime = 0

skiTab:Toggle({
    Title = "自动错误404格挡",
    Flag = "LuoyeConfig_025",
    Value = false,
    Callback = function(state)
        JohnDoeSettings.AutoParry = state
    end
})

skiTab:Slider({
    Title = "格挡检测范围",
    Flag = "LuoyeConfig_026",
    Value = {
        Min = 5,
        Max = 40,
        Default = 15,
    },
    Callback = function(v)
        JohnDoeSettings.ParryRange = v
    end
})

local function GetRemoteEvent()
    local ok, remote = pcall(function()
        return ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("Network"):WaitForChild("RemoteEvent")
    end)
    if not ok then
        return nil
    end
    return remote
end

local function GetAbilityCooldown(abilityName)
    local cd = 0
    pcall(function()
        local playerGui = LP:FindFirstChild("PlayerGui")
        local mainUI = playerGui and playerGui:FindFirstChild("MainUI")
        local abilityContainer = mainUI and mainUI:FindFirstChild("AbilityContainer")
        if abilityContainer then
            local frame = abilityContainer:FindFirstChild(abilityName)
            if frame then
                local cdTime = frame:FindFirstChild("CooldownTime")
                if cdTime and cdTime.Visible and cdTime.Text ~= "" then
                    cd = tonumber(cdTime.Text) or 0
                end
            end
        end
    end)
    return cd
end

local function UpdateSlasherAndJohnDoe()
    local char = LP.Character
    if not char then return end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local myKillerModel = nil
    local isSlasher = false
    local isJohnDoe = false
    local killers = GetKillers()
    for _, killer in ipairs(killers) do
        if killer:GetAttribute("Username") == LP.Name then
            myKillerModel = killer
            local actorName = killer:GetAttribute("ActorDisplayName") or killer.Name
            if actorName:find("Slasher") or killer.Name:find("Slasher") then
                isSlasher = true
            elseif actorName:find("JohnDoe") or killer.Name:find("JohnDoe") then
                isJohnDoe = true
            end
            break
        end
    end

    if isSlasher and SlasherSettings.EnragedEnabled and myKillerModel then
        local speedMults = myKillerModel:FindFirstChild("SpeedMultipliers")
        if speedMults and speedMults:FindFirstChild("ENRAGED") then
            speedMults.ENRAGED.Value = SlasherSettings.EnragedMultiplier
        end
    end

    if isSlasher and SlasherSettings.AutoParry then
        local cd = GetAbilityCooldown("RagingPace")
        if cd <= 0 and (tick() - lastSlasherParryTime) >= 0.5 then
            if ShouldParry(myRoot, SlasherSettings.ParryRange) then
                lastSlasherParryTime = tick()
                task.spawn(function()
                    local remote = GetRemoteEvent()
                    if not remote then return end
                    local args = {
                        "UseActorAbility",
                        { buffer.fromstring("\003\n\000\000\000RagingPace") }
                    }
                    for i = 1, 3 do
                        pcall(function() remote:FireServer(unpack(args)) end)
                    end
                    task.wait(0.05)
                    for i = 1, 3 do
                        pcall(function() remote:FireServer(unpack(args)) end)
                    end
                end)
            end
        end
    end

    if isJohnDoe and JohnDoeSettings.AutoParry then
        local cd = GetAbilityCooldown("Error404")
        if cd <= 0 and (tick() - lastJohnDoeParryTime) >= 2 then
            if ShouldParry(myRoot, JohnDoeSettings.ParryRange) then
                lastJohnDoeParryTime = tick()
                task.spawn(function()
                    local remote = GetRemoteEvent()
                    if not remote then return end
                    local args = {
                        "UseActorAbility",
                        { buffer.fromstring("\003\b\000\000\000404Error") }
                    }
                    pcall(function() remote:FireServer(unpack(args)) end)
                end)
            end
        end
    end
end

local slasherJohnDoeConn = nil
local function StartLoop()
    if slasherJohnDoeConn then return end
    slasherJohnDoeConn = RunService.Heartbeat:Connect(UpdateSlasherAndJohnDoe)
end
StartLoop()

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if slasherJohnDoeConn then
        slasherJohnDoeConn:Disconnect()
        slasherJohnDoeConn = nil
    end
    StartLoop()
end)

-- 冲刺拐弯
tacTab:Section({
    Title = "撞死他们",
    Box = true,
    Opened = true,
})

local dashTurn = {
    sixer = false,
    coolkid = false,
    noli = false,
    noliActive = false,
    noliOrigWalkSpeed = nil,
    noliConn = nil,
}

local function getCameraInputDir()
    local cam = workspace.CurrentCamera
    local cf = cam.CFrame
    local camFwd = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
    local camRight = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z)
    local x, z = 0, 0
    local input = game:GetService("UserInputService")
    if input:IsKeyDown(Enum.KeyCode.W) or input:IsKeyDown(Enum.KeyCode.Up) then z = z - 1 end
    if input:IsKeyDown(Enum.KeyCode.S) or input:IsKeyDown(Enum.KeyCode.Down) then z = z + 1 end
    if input:IsKeyDown(Enum.KeyCode.A) or input:IsKeyDown(Enum.KeyCode.Left) then x = x - 1 end
    if input:IsKeyDown(Enum.KeyCode.D) or input:IsKeyDown(Enum.KeyCode.Right) then x = x + 1 end
    local dir = camFwd * -z + camRight * x
    if dir.Magnitude > 0.01 then return dir.Unit end
    if camFwd.Magnitude > 0.01 then return camFwd.Unit end
    return Vector3.new(0, 0, -1)
end

local function sixerAirStrafeStep()
    if not dashTurn.sixer then return end
    local char = LP.Character
    if not char then return end
    if char:GetAttribute("PursuitState") ~= "Dashing" then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if hum.FloorMaterial ~= Enum.Material.Air then return end
    local cam = workspace.CurrentCamera
    local flat = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
    if flat.Magnitude < 0.01 then return end
    flat = flat.Unit
    local vel = hrp.AssemblyLinearVelocity
    local hVel = Vector3.new(vel.X, 0, vel.Z)
    local hSpeed = hVel.Magnitude
    if hSpeed < 0.1 then return end
    local newH = hVel:Lerp(flat * hSpeed, 1)
    hrp.AssemblyLinearVelocity = Vector3.new(newH.X, vel.Y, newH.Z)
end

local function coolkidDashTurnStep(dt)
    if not dashTurn.coolkid then return end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hrp then return end
    if char:GetAttribute("FootstepsMuted") ~= true then return end
    local dir = getCameraInputDir()
    local lv = hrp:FindFirstChildWhichIsA("LinearVelocity")
    if lv then lv.LineDirection = dir end
    if dir.Magnitude > 0.01 then
        local targetRot = CFrame.new(hrp.Position, hrp.Position + dir).Rotation
        hrp.CFrame = CFrame.new(hrp.Position) * hrp.CFrame.Rotation:Lerp(targetRot, math.min(dt * 16, 1))
    end
end

local function noliStartOverride()
    if dashTurn.noliActive then return end
    dashTurn.noliActive = true
    dashTurn.noliConn = RunService.RenderStepped:Connect(function()
        if not dashTurn.noli then
            noliStopOverride()
            return
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if not dashTurn.noliOrigWalkSpeed then dashTurn.noliOrigWalkSpeed = hum.WalkSpeed end
        hum.WalkSpeed = 60
        hum.AutoRotate = false
        local horiz = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
        if horiz.Magnitude > 0 then hum:Move(horiz.Unit) end
    end)
end

local function noliStopOverride()
    if not dashTurn.noliActive then return end
    dashTurn.noliActive = false
    if dashTurn.noliConn then
        dashTurn.noliConn:Disconnect()
        dashTurn.noliConn = nil
    end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = dashTurn.noliOrigWalkSpeed or 16
        hum.AutoRotate = true
        pcall(function() hum:Move(Vector3.new(0, 0, 0)) end)
    end
    dashTurn.noliOrigWalkSpeed = nil
end

RunService:BindToRenderStep("SixerAirStrafe", Enum.RenderPriority.Character.Value + 2, sixerAirStrafeStep)

local coolkidConn = nil
local function updateCoolkidDash()
    if coolkidConn then coolkidConn:Disconnect() end
    coolkidConn = RunService.RenderStepped:Connect(function(dt)
        coolkidDashTurnStep(dt)
    end)
end
updateCoolkidDash()

LP.CharacterAdded:Connect(function()
    noliStopOverride()
end)

RunService.RenderStepped:Connect(function()
    if not dashTurn.noli then
        if dashTurn.noliActive then noliStopOverride() end
        return
    end
    local char = LP.Character
    if not char then return end
    if char:GetAttribute("VoidRushState") == "Dashing" then
        noliStartOverride()
    else
        noliStopOverride()
    end
end)

tacTab:Toggle({
    Title = "访客666 - 空中控制",
    Flag = "LuoyeConfig_027",
    Value = false,
    Callback = function(state)
        dashTurn.sixer = state
    end
})

tacTab:Toggle({
    Title = "酷小孩 - 冲刺控制",
    Flag = "LuoyeConfig_028",
    Value = false,
    Callback = function(state)
        dashTurn.coolkid = state
    end
})

tacTab:Toggle({
    Title = "诺利 - 冲刺控制",
    Flag = "LuoyeConfig_029",
    Value = false,
    Callback = function(state)
        dashTurn.noli = state
        if not state then noliStopOverride() end
    end
})

-- 反背刺
antTab:Section({
    Title = "能免疫一些偷袭你的蚊子",
    Box = true,
    Opened = true,
})

local abs = {
    on = false,
    range = 40,
    duration = 1.5,
    locked = false,
    soundConn = nil,
    scanThread = nil,
    rings = {},
}

local absTriggerSounds = {
    ["86710781315432"] = true,
    ["99820161736138"] = true,
}

local function absAddRing(model)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not hrp or abs.rings[model] then return end
    pcall(function()
        local ring = Instance.new("Part")
        ring.Name = "AbsRing"
        ring.Shape = Enum.PartType.Cylinder
        ring.Size = Vector3.new(0.1, abs.range * 2, abs.range * 2)
        ring.Color = Color3.fromRGB(220, 50, 50)
        ring.Material = Enum.Material.ForceField
        ring.Transparency = 0.5
        ring.CanCollide = false
        ring.CanTouch = false
        ring.CFrame = hrp.CFrame * CFrame.Angles(0, 0, math.rad(90))
        ring.Parent = hrp
        local w = Instance.new("WeldConstraint")
        w.Part0 = hrp
        w.Part1 = ring
        w.Parent = ring
        abs.rings[model] = ring
    end)
end

local function absRemoveRing(model)
    local r = abs.rings[model]
    if r then
        pcall(function() r:Destroy() end)
        abs.rings[model] = nil
    end
end

local function absResizeRings()
    for _, r in pairs(abs.rings) do
        if r and r.Parent then
            r.Size = Vector3.new(0.1, abs.range * 2, abs.range * 2)
        end
    end
end

local function absCleanRings()
    for m in pairs(abs.rings) do
        absRemoveRing(m)
    end
end

local function absFindTwoTime()
    local players = workspace:FindFirstChild("Players")
    if not players then return nil end
    for _, folder in ipairs(players:GetChildren()) do
        local tt = folder:FindFirstChild("TwoTime")
        if tt then return tt end
    end
    return nil
end

local function absTrigger()
    if abs.locked then return end
    local ch = LP.Character
    local myRoot = ch and ch:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local ttModel = absFindTwoTime()
    if not ttModel then return end
    local ttRoot = ttModel:FindFirstChild("HumanoidRootPart")
    if not ttRoot then return end
    if (myRoot.Position - ttRoot.Position).Magnitude > abs.range then return end
    abs.locked = true
    task.spawn(function()
        local deadline = tick() + abs.duration
        while tick() < deadline do
            if not abs.on then break end
            local ch2 = LP.Character
            local r2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
            if not r2 or not ttRoot.Parent then break end
            r2.CFrame = CFrame.lookAt(r2.Position, Vector3.new(ttRoot.Position.X, r2.Position.Y, ttRoot.Position.Z))
            RunService.RenderStepped:Wait()
        end
        abs.locked = false
    end)
end

local function absHookSounds()
    if abs.soundConn then abs.soundConn:Disconnect(); abs.soundConn = nil end
    abs.soundConn = workspace.DescendantAdded:Connect(function(obj)
        if not abs.on or not obj:IsA("Sound") then return end
        local id = obj.SoundId:match("%d+")
        if id and absTriggerSounds[id] then absTrigger() end
    end)
end

local function absStartScan()
    if abs.scanThread then return end
    abs.scanThread = task.spawn(function()
        while abs.on do
            local players = workspace:FindFirstChild("Players")
            if players then
                for _, folder in ipairs(players:GetChildren()) do
                    for _, model in ipairs(folder:GetChildren()) do
                        if model.Name == "TwoTime" then absAddRing(model) end
                    end
                end
            end
            for m in pairs(abs.rings) do
                if not m.Parent then absRemoveRing(m) end
            end
            task.wait(1)
        end
        abs.scanThread = nil
    end)
end

local function absStart()
    abs.on = true
    absHookSounds()
    absStartScan()
end

local function absStop()
    abs.on = false
    if abs.soundConn then abs.soundConn:Disconnect(); abs.soundConn = nil end
    if abs.scanThread then task.cancel(abs.scanThread); abs.scanThread = nil end
    absCleanRings()
    abs.locked = false
end

LP.CharacterAdded:Connect(function()
    abs.locked = false
    if abs.on then 
        absStop()
        absStart()
    end
end)

antTab:Toggle({
    Title = "启用反背刺",
    Flag = "LuoyeConfig_030",
    Value = false,
    Callback = function(on)
        if on then
            absStart()
        else
            absStop()
        end
    end
})

antTab:Slider({
    Title = "检测范围",
    Flag = "LuoyeConfig_031",
    Value = { 
        Min = 10, 
        Max = 120, 
        Default = abs.range 
    },
    Callback = function(v)
        abs.range = v
        absResizeRings()
    end
})

antTab:Slider({
    Title = "注视时间",
    Flag = "LuoyeConfig_032",
    Value = { 
        Min = 0.3, 
        Max = 5.0, 
        Default = abs.duration 
    },
    Callback = function(v)
        abs.duration = v
    end
})

-- 自动格挡
do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local NetworkEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("Network"):WaitForChild("RemoteEvent")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    local Settings = {
        AutoBlock = false,
        AutoPunch = false,
        HitboxDetection = false,
        DetectionRange = 15,
        ShowRangeCircle = false,
    }

    local function FireRemoteAbility(abilityName)
        pcall(function()
            local args
            if abilityName == "Block" then
                args = { "UseActorAbility", { buffer.fromstring("\003\005\000\000\000Block") } }
            else
                args = { "UseActorAbility", { buffer.fromstring("\003\005\000\000\000" .. abilityName) } }
            end
            NetworkEvent:FireServer(unpack(args))
        end)
    end

    local autoBlockTriggerAnims = {
        ["124269076578545"] = true, ["126830014841198"] = true, ["126355327951215"] = true, ["121086746534252"] = true,
        ["18885909645"] = true, ["98456918873918"] = true, ["105458270463374"] = true, ["83829782357897"] = true,
        ["125403313786645"] = true, ["118298475669935"] = true, ["82113744478546"] = true, ["70371667919898"] = true,
        ["99135633258223"] = true, ["97167027849946"] = true, ["109230267448394"] = true, ["139835501033932"] = true,
        ["126896426760253"] = true, ["109667959938617"] = true, ["126681776859538"] = true, ["129976080405072"] = true,
        ["121293883585738"] = true, ["81639435858902"] = true, ["137314737492715"] = true, ["92173139187970"] = true,
        ["122709416391"] = true, ["879895330952"] = true, ["84069821282466"] = true, ["114506382930939"] = true,
        ["88451353906104"] = true, ["133066252175737"] = true, ["99824350842479"] = true, ["132243194360714"] = true,
        ["91341171001824"] = true, ["120307951"] = true, ["124705663396411"] = true, ["139309647473555"] = true,
        ["133363345661032"] = true, ["122709416391891"] = true, ["106131211773069"] = true, ["81299297965542"] = true,
        ["138938529389204"] = true, ["70483423693126"] = true, ["106776364623742"] = true, ["114126519127454"] = true,
        ["130958529065375"] = true, ["126727756047566"] = true, ["81803417290685"] = true, ["90620531468240"] = true,
        ["82691533602949"] = true, ["99829427721752"] = true, ["93366464803829"] = true, ["107032335460679"] = true,
        ["112135252467978"] = true, ["77375846492436"] = true, ["127245564598429"] = true,
        ["73921036900313"] = true, ["111384272984267"] = true, ["90499469533503"] = true, ["133491532453922"] = true,
        ["119434518007321"] = true, ["115194624791339"] = true, ["89448354637442"] = true, ["100725497418533"] = true,
        ["107640065977686"] = true, ["112902284724598"] = true, ["106086955212611"] = true, ["77119710693654"] = true,
    }
    local autoBlockTriggerSounds = {
        ["89004992452376"] = true, ["80516583309685"] = true, ["102228729296384"] = true, ["140242176732868"] = true,
        ["112809109188560"] = true, ["136323728355613"] = true, ["115026634746636"] = true, ["84116622032112"] = true,
        ["108907358619313"] = true, ["127793641088496"] = true, ["86174610237192"] = true, ["95079963655241"] = true,
        ["101199185291628"] = true, ["119942598489800"] = true, ["84307400688050"] = true, ["113037804008732"] = true,
        ["105200830849301"] = true, ["75330693422988"] = true, ["82221759983649"] = true, ["81702359653578"] = true,
        ["108610718831698"] = true, ["112395455254818"] = true, ["109431876587852"] = true, ["109348678063422"] = true,
        ["85853080745515"] = true, ["12222216"] = true, ["105840448036441"] = true, ["114742322778642"] = true,
        ["119583605486352"] = true, ["79980897195554"] = true, ["71805956520207"] = true, ["79391273191671"] = true,
        ["101553872555606"] = true, ["101698569375359"] = true, ["106300477136129"] = true, ["116581754553533"] = true,
        ["117231507259853"] = true, ["119089145505438"] = true, ["121954639447247"] = true, ["125213046326879"] = true,
        ["131406927389838"] = true, ["71834552297085"] = true, ["805165833096"] = true, ["823363523051"] = true,
        ["120059928759346"] = true, ["82336352305186"] = true, ["104625283622511"] = true, ["126131675979001"] = true,
        ["98675142200448"] = true,
    }

    local CachedKillers = {}
    local CachedSurvivors = {}
    local function isFakeKiller(killerModel)
        if not killerModel then return true end
        local name = killerModel.Name
        if name:match("^Fake") or name:match("Fake$") then return true end
        local playersFolder = Workspace:FindFirstChild("Players")
        local killersFolder = playersFolder and playersFolder:FindFirstChild("Killers")
        if not killersFolder or not killerModel:IsDescendantOf(killersFolder) then return true end
        return false
    end

    task.spawn(function()
        while true do
            task.wait(0.25)
            local playersFolder = Workspace:FindFirstChild("Players")
            if playersFolder then
                local kFolder = playersFolder:FindFirstChild("Killers")
                if kFolder then
                    local kList = {}
                    for _, k in ipairs(kFolder:GetChildren()) do
                        if not isFakeKiller(k) and k:GetAttribute("Username") then
                            table.insert(kList, k)
                        end
                    end
                    CachedKillers = kList
                end
                local sFolder = playersFolder:FindFirstChild("Survivors")
                if sFolder then
                    local sList = {}
                    for _, s in ipairs(sFolder:GetChildren()) do
                        if s:GetAttribute("Username") then
                            table.insert(sList, s)
                        end
                    end
                    CachedSurvivors = sList
                end
            end
        end
    end)

    local function isFacing(localRoot, targetRoot)
        if not localRoot or not targetRoot then return true end
        local dx = localRoot.Position.X - targetRoot.Position.X
        local dz = localRoot.Position.Z - targetRoot.Position.Z
        local mag = math.sqrt(dx*dx + dz*dz)
        if mag < 0.01 then return true end
        local ux, uz = dx/mag, dz/mag
        local lv = targetRoot.CFrame.LookVector
        local dot = lv.X * ux + lv.Z * uz
        return dot > 0
    end

    local rangeCircle = nil

    RunService.RenderStepped:Connect(function()
        if not Settings.ShowRangeCircle then
            if rangeCircle then rangeCircle.Visible = false end
            return
        end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if not rangeCircle or not rangeCircle.Parent then
                rangeCircle = Instance.new("CylinderHandleAdornment")
                rangeCircle.Name = "AutoBlockRangeVis"
                rangeCircle.Adornee = hrp
                rangeCircle.Height = 0.05
                rangeCircle.Color3 = Color3.fromRGB(0, 255, 255)
                rangeCircle.Transparency = 0.6
                rangeCircle.ZIndex = 1
                rangeCircle.Parent = hrp
            end
            rangeCircle.Radius = Settings.DetectionRange
            rangeCircle.InnerRadius = math.max(0, Settings.DetectionRange - 0.5)
            rangeCircle.CFrame = CFrame.new(0, -hrp.Size.Y/2, 0) * CFrame.Angles(math.rad(90), 0, 0)
            rangeCircle.Visible = true
        elseif rangeCircle then
            rangeCircle.Visible = false
        end
    end)

    local isSpammingCombat = false
    local function TriggerSpamCombat()
        if isSpammingCombat then return end
        isSpammingCombat = true
        task.spawn(function()
            if Settings.AutoBlock then
                FireRemoteAbility("Block")
                task.wait(0.125)
                FireRemoteAbility("Block")
                task.wait(0.125)
            else
                task.wait(0.25)
            end
            if Settings.AutoPunch then
                local endTime = tick() + 0.65
                while tick() < endTime do
                    FireRemoteAbility("Punch")
                    task.wait(0.05)
                end
            end
            isSpammingCombat = false
        end)
    end

    task.spawn(function()
        while true do
            task.wait(1/15)
            if not (Settings.AutoBlock or Settings.AutoPunch) then continue end
            local myChar = LP.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then continue end

            if Settings.HitboxDetection then
                local hitboxesFolder = Workspace:FindFirstChild("Hitboxes")
                if hitboxesFolder then
                    for _, killerModel in ipairs(CachedKillers) do
                        local username = killerModel:GetAttribute("Username")
                        if not username then continue end
                        local targetHitboxName = username .. "Hitbox"
                        local hrp = killerModel:FindFirstChild("HumanoidRootPart")
                        if not hrp then continue end
                        local distToKiller = (hrp.Position - myRoot.Position).Magnitude
                        if distToKiller > Settings.DetectionRange then continue end
                        for _, part in ipairs(hitboxesFolder:GetChildren()) do
                            if part.Name == targetHitboxName then
                                local hitboxDist = (part.Position - hrp.Position).Magnitude
                                if hitboxDist <= 15 then
                                    local color = part.Color
                                    local r,g,b = math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255)
                                    local isGreen = math.abs(r-127)<=50 and math.abs(g-255)<=50 and math.abs(b-127)<=50
                                    local isNotStandardRed = math.abs(r-255)>5 or math.abs(g-63)>5 or math.abs(b-63)>5
                                    if isGreen or isNotStandardRed then
                                        if isFacing(myRoot, hrp) then
                                            TriggerSpamCombat()
                                        end
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end

            for _, killerModel in ipairs(CachedKillers) do
                if not killerModel:GetAttribute("Username") or isFakeKiller(killerModel) then continue end
                local hrp = killerModel:FindFirstChild("HumanoidRootPart")
                if not hrp then continue end
                local dist = (hrp.Position - myRoot.Position).Magnitude
                if dist > Settings.DetectionRange then continue end
                if not isFacing(myRoot, hrp) then continue end

                local isAttacking = false
                local kNameLower = string.lower(killerModel.Name)
                local maxTime = 0.5
                if kNameLower:find("c00lkid") then maxTime = 0.35
                elseif kNameLower:find("johndoe") then maxTime = 0.55
                elseif kNameLower:find("slasher") then maxTime = 0.4
                elseif kNameLower:find("noli") then maxTime = 0.5
                elseif kNameLower:find("nosferatu") then maxTime = 0.42
                end

                local hum = killerModel:FindFirstChildOfClass("Humanoid")
                local animator = hum and hum:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        local id = tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+")
                        if id and autoBlockTriggerAnims[id] then
                            if track.TimePosition <= maxTime then
                                isAttacking = true
                                break
                            end
                        end
                    end
                end
                if not isAttacking then
                    for _, desc in ipairs(killerModel:GetDescendants()) do
                        if desc:IsA("Sound") and desc.IsPlaying then
                            local soundId = tostring(desc.SoundId):match("%d+")
                            if soundId and autoBlockTriggerSounds[soundId] then
                                if desc.TimePosition <= maxTime then
                                    isAttacking = true
                                    break
                                end
                            end
                        end
                    end
                end

                if isAttacking then
                    TriggerSpamCombat()
                    break
                end
            end
        end
    end)

    local LastWalkspeedOverride = 0
    NetworkEvent.OnClientEvent:Connect(function(...)
        local args = {...}
        local function searchForWalkspeed(tbl)
            for _, v in pairs(tbl) do
                if type(v) == "string" or typeof(v) == "buffer" then
                    if tostring(v):find("WalkspeedOverride") then
                        return true
                    end
                elseif type(v) == "table" and searchForWalkspeed(v) then
                    return true
                end
            end
            return false
        end
        if searchForWalkspeed(args) then
            LastWalkspeedOverride = tick()
        end
    end)

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if rangeCircle then rangeCircle:Destroy(); rangeCircle = nil end
    end)

autTab:Section({
    Title = "自动格挡配置",
    Box = true,
    Opened = true,
})

autTab:Toggle({
    Title = "自动格挡",
    Flag = "LuoyeConfig_033",
    Value = false,
    Callback = function(v) 
        Settings.AutoBlock = v 
    end
})

autTab:Toggle({
    Title = "自动拳击",
    Flag = "LuoyeConfig_034",
    Value = false,
    Callback = function(v) 
        Settings.AutoPunch = v 
    end
})

autTab:Toggle({
    Title = "碰撞箱检测",
    Flag = "LuoyeConfig_035",
    Value = false,
    Callback = function(v) 
        Settings.HitboxDetection = v 
    end
})

autTab:Slider({
    Title = "检测范围",
    Flag = "LuoyeConfig_036",
    Value = { 
        Min = 5, 
        Max = 50, 
        Default = 15 
    },
    Callback = function(v)
        Settings.DetectionRange = math.floor(v)
    end
})

autTab:Toggle({
    Title = "显示范围圈",
    Flag = "LuoyeConfig_037",
    Value = false,
    Callback = function(v)
        Settings.ShowRangeCircle = v
        if not v and rangeCircle then
            rangeCircle.Visible = false
        end
    end
})
end

--发电机
PgeTab:Section({
    Title = "修机列表",
    Box = true,
    Opened = true,
})

do
    local flow = {
        on = false,
        nodeDelay = 0.04,
        lineDelay = 0.60,
    }

    local function flowKey(n) return n.row.."-"..n.col end
    local function flowNeighbour(r1,c1,r2,c2)
        if r2==r1-1 and c2==c1 then return"up" end
        if r2==r1+1 and c2==c1 then return"down" end
        if r2==r1 and c2==c1-1 then return"left" end
        if r2==r1 and c2==c1+1 then return"right" end
        return false
    end

    local function flowOrder(path, endpoints)
        if not path or #path == 0 then return path end
        local lookup = {}
        for _, n in ipairs(path) do lookup[flowKey(n)] = n end
        local start
        for _, ep in ipairs(endpoints or {}) do
            for _, n in ipairs(path) do
                if n.row == ep.row and n.col == ep.col then
                    start = { row = ep.row, col = ep.col }
                    break
                end
            end
            if start then break end
        end
        if not start then
            for _, n in ipairs(path) do
                local nb = 0
                for _, d in ipairs({{-1,0},{1,0},{0,-1},{0,1}}) do
                    if lookup[(n.row+d[1]).."-"..(n.col+d[2])] then nb = nb + 1 end
                end
                if nb == 1 then start = { row = n.row, col = n.col }; break end
            end
        end
        if not start then start = { row = path[1].row, col = path[1].col } end
        local pool, ordered = {}, {}
        for _, n in ipairs(path) do pool[flowKey(n)] = { row = n.row, col = n.col } end
        local cur = start
        table.insert(ordered, { row = cur.row, col = cur.col })
        pool[flowKey(cur)] = nil
        while next(pool) do
            local moved = false
            for k, node in pairs(pool) do
                if flowNeighbour(cur.row, cur.col, node.row, node.col) then
                    table.insert(ordered, { row = node.row, col = node.col })
                    pool[k] = nil; cur = node; moved = true; break
                end
            end
            if not moved then break end
        end
        return ordered
    end

    local function flowSolve(puzzle)
        if not puzzle or not puzzle.Solution then return end
        local indices = {}
        for i = 1, #puzzle.Solution do indices[i] = i end
        for i = #indices, 2, -1 do
            local j = math.random(1, i)
            indices[i], indices[j] = indices[j], indices[i]
        end
        for _, ci in ipairs(indices) do
            local solution = puzzle.Solution[ci]
            if not solution then continue end
            local ordered = flowOrder(solution, puzzle.targetPairs[ci])
            if not ordered or #ordered == 0 then continue end
            puzzle.paths[ci] = {}
            for _, node in ipairs(ordered) do
                table.insert(puzzle.paths[ci], { row = node.row, col = node.col })
                puzzle:updateGui()
                task.wait(flow.nodeDelay)
            end
            task.wait(flow.lineDelay)
            puzzle:checkForWin()
        end
    end

    local hooked = false
    local function setupFlowHook()
        if hooked then return end
        local modFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
        local miniFolder = modFolder and modFolder:FindFirstChild("Minigames")
        local fgFolder = miniFolder and miniFolder:FindFirstChild("FlowGameManager")
        local fgModule = fgFolder and fgFolder:FindFirstChild("FlowGame")
        if fgModule then
            local ok, FG = pcall(require, fgModule)
            if ok and FG and FG.new then
                local orig = FG.new
                FG.new = function(...)
                    local p = orig(...)
                    if flow.on then
                        task.spawn(function()
                            task.wait(0.3)
                            flowSolve(p)
                        end)
                    end
                    return p
                end
                hooked = true
            end
        end
    end

PgeTab:Toggle({
    Title = "绘制修机",
    Flag = "LuoyeConfig_038",
    Value = false,
    Callback = function(on)
        flow.on = on
        if on and not hooked then
            setupFlowHook()
        end
    end
})

PgeTab:Slider({
    Title = "节点速度 (秒)",
    Flag = "LuoyeConfig_039",
    Value = { 
        Min = 0, 
        Max = 1, 
        Default = 0.04 
    },
    Callback = function(v) 
        flow.nodeDelay = v 
    end
})

PgeTab:Slider({
    Title = "线暂停 (秒)",
    Flag = "LuoyeConfig_040",
    Value = { 
        Min = 0, 
        Max = 1, 
        Default = 0.60 
    },
    Callback = function(v) 
        flow.lineDelay = v 
    end
})
end

PgeTab:Section({
    Title = "其他修机列表",
    Box = true,
    Opened = true,
})

local autoRepairActive = false

local function findNearestGenerator()
    local character = LP.Character
    if not character then return nil end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local generators = {}
    local map = workspace:FindFirstChild("Map")
    if map then
        local ingame = map:FindFirstChild("Ingame")
        if ingame then
            local mapFolder = ingame:FindFirstChild("Map")
            if mapFolder then
                for _, obj in pairs(mapFolder:GetChildren()) do
                    if obj.Name == "Generator" then
                        table.insert(generators, obj)
                    end
                end
            end
        end
    end

    local nearest, nearestDist = nil, math.huge
    for _, gen in pairs(generators) do
        local part = gen:FindFirstChildWhichIsA("BasePart")
        if part then
            local dist = (root.Position - part.Position).Magnitude
            if dist < nearestDist then
                nearest, nearestDist = gen, dist
            end
        end
    end
    return nearest
end

local function repairGenerator(generator)
    if not generator then return false end
    local remotes = generator:FindFirstChild("Remotes")
    if remotes then
        local re = remotes:FindFirstChild("RE")
        if re and re:IsA("RemoteEvent") then
            re:FireServer()
            return true
        end
    end
    return false
end

local autoRepairThread = nil
local function startAutoRepair()
    if autoRepairThread then return end
    autoRepairThread = task.spawn(function()
        while autoRepairActive do
            local generator = findNearestGenerator()
            if generator then
                repairGenerator(generator)
                task.wait(1.5)
            else
                task.wait(0.5)
            end
        end
        autoRepairThread = nil
    end)
end

PgeTab:Toggle({
    Title = "自动修复发电机",
    Flag = "LuoyeConfig_041",
    Value = false,
    Callback = function(state)
        autoRepairActive = state
        if state then
            startAutoRepair()
        else
            if autoRepairThread then
                task.cancel(autoRepairThread)
                autoRepairThread = nil
            end
        end
    end
})

PgeTab:Button({
    Title = "完成所有发电机",
    Callback = function()
        pcall(function()
            local gameMap = workspace:FindFirstChild("Map")

            if not (gameMap and gameMap:FindFirstChild("Ingame") and gameMap.Ingame:FindFirstChild("Map")) then
                return
            end

            for _, v in ipairs(gameMap.Ingame.Map:GetChildren()) do
                if v.Name == "Generator" and v:FindFirstChild("Progress") and v.Progress.Value < 100 then

                    local positions = v:FindFirstChild("Positions")
                    if positions then
                        local center = positions:FindFirstChild("Center")
                        local right = positions:FindFirstChild("Right")
                        local left = positions:FindFirstChild("Left")

                        if center and right and left then

                            local function occupied(pos)
                                local folder = workspace:FindFirstChild("Players")
                                local survivors = folder and folder:FindFirstChild("Survivors")

                                if not survivors then
                                    return false
                                end

                                for _, sv in ipairs(survivors:GetChildren()) do
                                    if sv ~= LP and sv:FindFirstChild("HumanoidRootPart") then
                                        if (sv.HumanoidRootPart.Position - pos).Magnitude <= 6 then
                                            return true
                                        end
                                    end
                                end

                                return false
                            end

                            local centerOccupied = occupied(center.Position)
                            local rightOccupied = occupied(right.Position)
                            local leftOccupied = occupied(left.Position)

                            if not (centerOccupied and rightOccupied and leftOccupied) then

                                local char = LP.Character
                                local hrp = char and char:FindFirstChild("HumanoidRootPart")

                                if hrp then
                                    if not centerOccupied then
                                        hrp.CFrame = center.CFrame
                                    elseif not rightOccupied then
                                        hrp.CFrame = right.CFrame
                                    else
                                        hrp.CFrame = left.CFrame
                                    end
                                end

                                task.wait(0.2)

                                local s2, r2 = pcall(function()
                                    return v.Remotes.RF:InvokeServer("Enter")
                                end)

                                if s2 and r2 == "fixing" then
                                    for _ = 1, 4 do
                                        if v.Progress.Value >= 100 then
                                            break
                                        end

                                        pcall(function()
                                            v.Remotes.RE:FireServer()
                                        end)

                                        task.wait(1.4)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
})

-- 体力
phyTab:Section({
    Title = "体力管理",
    Box = true,
    Opened = true,
})

do
    local originalDefaults = {}
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local SprintingModule = ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
    local function GetModule()
        return require(SprintingModule)
    end

    local function CaptureDefaults()
        local m = GetModule()
        originalDefaults.MaxStamina = m.MaxStamina
        originalDefaults.StaminaGain = m.StaminaGain
        originalDefaults.StaminaLoss = m.StaminaLoss
        originalDefaults.SprintSpeed = m.SprintSpeed
    end
    CaptureDefaults()

    local StaminaSettings = {
        MaxStamina = 100,
        StaminaGain = 25,
        StaminaLoss = 10,
        SprintSpeed = 28,
        InfiniteGain = 9999
    }

    local SettingToggles = {
        MaxStamina = false,
        StaminaGain = false,
        StaminaLoss = false,
        SprintSpeed = false
    }

    local bai = { Spr = false }
    local connection = nil

    task.spawn(function()
        while true do
            local m = GetModule()
            for key, value in pairs(StaminaSettings) do
                if SettingToggles[key] then
                    m[key] = value
                end
            end
            task.wait(0.5)
        end
    end)

phyTab:Toggle({
    Title = "无限体力",
    Flag = "LuoyeConfig_042",
    Value = false,
    Callback = function(state)
        bai.Spr = state
        local Sprinting = GetModule()
        if state then
            Sprinting.StaminaLoss = 0
            Sprinting.StaminaGain = StaminaSettings.InfiniteGain or 9999
            if connection then
                connection:Disconnect() 
            end
            connection = RunService.Heartbeat:Connect(function()
                if not bai.Spr then return end
                Sprinting.StaminaLoss = 0
                Sprinting.StaminaGain = StaminaSettings.InfiniteGain or 9999
            end)
        else
            Sprinting.StaminaLoss = originalDefaults.StaminaLoss
            Sprinting.StaminaGain = originalDefaults.StaminaGain
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})

phyTab:Toggle({
    Title = "启用体力大小",
    Flag = "LuoyeConfig_043",
    Value = false,
    Callback = function(v)
        SettingToggles.MaxStamina = v
        if not v then
            local m = GetModule()
            m.MaxStamina = originalDefaults.MaxStamina
        end
    end
})

phyTab:Slider({
    Title = "体力大小",
    Flag = "LuoyeConfig_044",
    Value = { 
        Min = 0, 
        Max = 99999, 
        Default = 100 
    },
    Callback = function(v)
        StaminaSettings.MaxStamina = v 
    end
})

phyTab:Toggle({
    Title = "启用体力恢复",
    Flag = "LuoyeConfig_045",
    Value = false,
    Callback = function(v)
        SettingToggles.StaminaGain = v
        if not v then
            local m = GetModule()
            m.StaminaGain = originalDefaults.StaminaGain
        end
    end
})

phyTab:Slider({
    Title = "体力恢复",
    Flag = "LuoyeConfig_046",
    Value = { 
        Min = 0, 
        Max = 250, 
        Default = 25 
    },
    Callback = function(v)
        StaminaSettings.StaminaGain = v 
    end
})

phyTab:Toggle({
    Title = "启用体力消耗",
    Flag = "LuoyeConfig_047",
    Value = false,
    Callback = function(v)
        SettingToggles.StaminaLoss = v
        if not v then
            local m = GetModule()
            m.StaminaLoss = originalDefaults.StaminaLoss
        end
    end
})

phyTab:Slider({
    Title = "体力消耗",
    Flag = "LuoyeConfig_048",
    Value = { 
        Min = 0, 
        Max = 100, 
        Default = 10 
    },
    Callback = function(v)
        StaminaSettings.StaminaLoss = v 
    end
})

phyTab:Toggle({
    Title = "启用奔跑速度",
    Flag = "LuoyeConfig_049",
    Value = false,
    Callback = function(v)
        SettingToggles.SprintSpeed = v
        if not v then
            local m = GetModule()
            m.SprintSpeed = originalDefaults.SprintSpeed
        end
    end
})

phyTab:Slider({
    Title = "奔跑速度",
    Flag = "LuoyeConfig_050",
    Value = { 
        Min = 0, 
        Max = 200, 
        Default = 28 
    },
    Callback = function(v)
        StaminaSettings.SprintSpeed = v 
    end
})
end

espTab:Section({
    Title = "透视管理",
    Box = true,
    Opened = true,
})

do
    local generatorsESP = false
    local killersESP = false98
    local survivorsESP = false
    local itemESP = false
    local generatorsRayESP = false
    local killersRayESP = false
    local survivorsRayESP = false
    local itemRayESP = false
    local rayColor = Color3.fromRGB(255, 255, 255)

    local genThread = nil
    local function startGenESP()
        if genThread then return end
        genThread = task.spawn(function()
            while generatorsESP do
                pcall(function()
                    local map = workspace:FindFirstChild("Map")
                    if map and map:FindFirstChild("Ingame") and map.Ingame:FindFirstChild("Map") then
                        for _, v in pairs(map.Ingame.Map:GetChildren()) do
                            if v.Name == "Generator" then
                                if not v:FindFirstChild("gen_esp") then
                                    local hl = Instance.new("Highlight", v)
                                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.Name = "gen_esp"
                                    hl.OutlineTransparency = 0
                                    hl.FillTransparency = 0.3
                                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    hl.FillColor = Color3.fromRGB(255, 255, 51)
                                end
                                if v:FindFirstChild("gen_esp") and v:FindFirstChild("Progress") then
                                    local progressValue = math.floor(v.Progress.Value)
                                    if progressValue >= 100 then
                                        v.gen_esp.FillColor = Color3.fromRGB(0, 255, 0)
                                    else
                                        v.gen_esp.FillColor = Color3.fromRGB(255, 255, 51)
                                    end
                                    if not v:FindFirstChild("nametag") then
                                        local bb = Instance.new("BillboardGui", v)
                                        bb.Size = UDim2.new(4, 0, 1, 0)
                                        bb.AlwaysOnTop = true
                                        bb.Name = "nametag"
                                        local text = Instance.new("TextLabel", bb)
                                        text.TextStrokeTransparency = 0
                                        text.Text = "发电机 (" .. progressValue .. "%)"
                                        text.TextSize = 15
                                        text.BackgroundTransparency = 1
                                        text.Size = UDim2.new(1, 0, 1, 0)
                                        text.TextColor3 = Color3.fromRGB(255, 255, 255)
                                    else
                                        v.nametag.TextLabel.Text = "发电机 (" .. progressValue .. "%)"
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
            pcall(function()
                local map = workspace:FindFirstChild("Map")
                if map and map:FindFirstChild("Ingame") and map.Ingame:FindFirstChild("Map") then
                    for _, v in pairs(map.Ingame.Map:GetChildren()) do
                        if v.Name == "Generator" then
                            if v:FindFirstChild("gen_esp") then v.gen_esp:Destroy() end
                            if v:FindFirstChild("nametag") then v.nametag:Destroy() end
                        end
                    end
                end
            end)
            genThread = nil
        end)
    end
    local function stopGenESP()
        if genThread then
            task.cancel(genThread)
            genThread = nil
        end
        pcall(function()
            local map = workspace:FindFirstChild("Map")
            if map and map:FindFirstChild("Ingame") and map.Ingame:FindFirstChild("Map") then
                for _, v in pairs(map.Ingame.Map:GetChildren()) do
                    if v.Name == "Generator" then
                        if v:FindFirstChild("gen_esp") then v.gen_esp:Destroy() end
                        if v:FindFirstChild("nametag") then v.nametag:Destroy() end
                    end
                end
            end
        end)
    end

    local killersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
    local survivorsFolder = workspace:WaitForChild("Players"):WaitForChild("Survivors")
    local camera = workspace.CurrentCamera
    local players = game:GetService("Players")
    local rayGui = nil
    local rayLines = {}

    local function getRayGui()
        if rayGui and rayGui.Parent then return rayGui end
        rayGui = Instance.new("ScreenGui")
        rayGui.Name = "ESP_RayGui"
        rayGui.IgnoreGuiInset = true
        rayGui.ResetOnSpawn = false
        rayGui.DisplayOrder = 999
        local ok = pcall(function()
            rayGui.Parent = game:GetService("CoreGui")
        end)
        if not ok or not rayGui.Parent then
            local player = players.LocalPlayer
            if player then
                rayGui.Parent = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
            end
        end
        return rayGui
    end

    local function getFolderCharacter(folder, player)
        if not folder or not player then return nil end
        for _, model in ipairs(folder:GetChildren()) do
            if model.Name == player.Name or model:GetAttribute("Username") == player.Name then
                return model
            end
        end
        return nil
    end

    local function getLocalCharacter()
        local player = players.LocalPlayer
        if not player then return nil end
        if player.Character and player.Character.Parent then
            return player.Character
        end
        return getFolderCharacter(survivorsFolder, player) or getFolderCharacter(killersFolder, player)
    end

    local function getModelBottomPosition(model)
        if not model then return nil end
        if model:IsA("BasePart") then
            return model.Position - Vector3.new(0, model.Size.Y / 2, 0)
        end
        if model:IsA("Model") then
            local ok, cf, size = pcall(function()
                return model:GetBoundingBox()
            end)
            if ok and cf and size then
                return cf.Position - Vector3.new(0, size.Y / 2, 0)
            end
            local part = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
            if part then
                return part.Position - Vector3.new(0, part.Size.Y / 2, 0)
            end
        end
        return nil
    end

    local function getTargetPosition(target)
        if not target then return nil end
        if target:IsA("BasePart") then
            return target.Position
        end
        if target:IsA("Model") then
            local humanoid = target:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head") or target.PrimaryPart
                if root then return root.Position end
            end
            local ok, cf, size = pcall(function()
                return target:GetBoundingBox()
            end)
            if ok and cf and size then
                return cf.Position
            end
            local part = target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart", true)
            if part then return part.Position end
        end
        return nil
    end

    local function worldToScreen(position, viewportSize)
        if not camera or not position then return nil end
        local screenPos = camera:WorldToViewportPoint(position)
        if screenPos.Z <= 0 then return nil end
        return Vector2.new(
            math.clamp(screenPos.X, 0, viewportSize.X),
            math.clamp(screenPos.Y, 0, viewportSize.Y)
        )
    end

    local function getRayStart(viewportSize)
        local bottomPosition = getModelBottomPosition(getLocalCharacter())
        local screenPos = worldToScreen(bottomPosition, viewportSize)
        if screenPos then return screenPos end
        return Vector2.new(viewportSize.X / 2, viewportSize.Y)
    end

    local function getRayLine(target)
        local line = rayLines[target]
        if line and line.Parent then return line end
        local gui = getRayGui()
        if not gui then return nil end
        line = Instance.new("Frame")
        line.Name = "ESP_RayLine"
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BorderSizePixel = 0
        line.BackgroundTransparency = 0
        line.BackgroundColor3 = rayColor
        line.Visible = false
        line.ZIndex = 999
        line.Parent = gui
        rayLines[target] = line
        return line
    end

    local function removeRayLine(target)
        local line = rayLines[target]
        if line then
            line:Destroy()
            rayLines[target] = nil
        end
    end

    local function clearRayLines()
        for _, line in pairs(rayLines) do
            if line then line:Destroy() end
        end
        rayLines = {}
    end

    local function drawRay(target, targetPosition, rayStart, viewportSize, used)
        if not camera or not targetPosition or not rayStart then return end
        used[target] = true
        local line = getRayLine(target)
        if not line then return end
        local rayEnd = worldToScreen(targetPosition, viewportSize)
        if not rayEnd then
            line.Visible = false
            return
        end
        local delta = rayEnd - rayStart
        local distance = delta.Magnitude
        if distance < 2 then
            line.Visible = false
            return
        end
        local middle = rayStart + delta / 2
        line.Position = UDim2.fromOffset(middle.X, middle.Y)
        line.Size = UDim2.fromOffset(distance, 2)
        line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
        line.BackgroundColor3 = rayColor
        line.Visible = true
    end

    local function updateRayESP()
        camera = workspace.CurrentCamera
        if not generatorsRayESP and not killersRayESP and not survivorsRayESP and not itemRayESP then
            clearRayLines()
            return
        end
        local used = {}
        local viewportSize = camera.ViewportSize
        local rayStart = getRayStart(viewportSize)
        if generatorsRayESP then
            local map = workspace:FindFirstChild("Map")
            if map and map:FindFirstChild("Ingame") and map.Ingame:FindFirstChild("Map") then
                for _, v in pairs(map.Ingame.Map:GetChildren()) do
                    if v.Name == "Generator" then
                        drawRay(v, getTargetPosition(v), rayStart, viewportSize, used)
                    end
                end
            end
        end
        if killersRayESP then
            for _, model in ipairs(killersFolder:GetChildren()) do
                drawRay(model, getTargetPosition(model), rayStart, viewportSize, used)
            end
        end
        if survivorsRayESP then
            for _, model in ipairs(survivorsFolder:GetChildren()) do
                drawRay(model, getTargetPosition(model), rayStart, viewportSize, used)
            end
        end
        if itemRayESP then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "ItemRoot" then
                    drawRay(v, getTargetPosition(v), rayStart, viewportSize, used)
                end
            end
        end
        local removeTargets = {}
        for target in pairs(rayLines) do
            if not used[target] then
                table.insert(removeTargets, target)
            end
        end
        for _, target in ipairs(removeTargets) do
            removeRayLine(target)
        end
    end

    local function attachBillboard(model, color)
        if model:FindFirstChild("ESP_NameBillboard") then return end
        local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
        if not head then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_NameBillboard"
        billboard.Adornee = head
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.Parent = model

        local label = Instance.new("TextLabel")
        label.Name = "NameLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = color
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.TextScaled = false
        label.TextWrapped = false
        label.ClipsDescendants = true
        label.TextTruncate = Enum.TextTruncate.None
        label.AutomaticSize = Enum.AutomaticSize.X
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextSize = 10
        label.Font = Enum.Font.GothamBold
        label.Text = "加载中..."
        label.Parent = billboard
    end

    local function updateBillboardText(model)
        local billboard = model:FindFirstChild("ESP_NameBillboard")
        if not billboard then return end
        local label = billboard:FindFirstChild("NameLabel")
        if not label then return end

        local actorText = model:GetAttribute("ActorDisplayName") or "???"
        local skinText = model:GetAttribute("SkinNameDisplay")
        if actorText == "Noli" and model:GetAttribute("IsFakeNoli") == true then
            actorText = actorText .. " (假的)"
        end
        local displayText = actorText
        if skinText and tostring(skinText) ~= "" then
            displayText = displayText .. " | " .. skinText
        end
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local hp = math.floor(humanoid.Health)
            local maxhp = math.floor(humanoid.MaxHealth)
            displayText = string.format("%s (生命值: %d/%d)", displayText, hp, maxhp)
        end
        label.Text = displayText
    end

    local noliByUsername = {}
    local function clearFakeTags()
        for _, killer in ipairs(killersFolder:GetChildren()) do
            if killer:GetAttribute("ActorDisplayName") == "Noli" then
                killer:SetAttribute("IsFakeNoli", false)
            end
        end
    end
    local function scanNolis()
        noliByUsername = {}
        for _, killer in ipairs(killersFolder:GetChildren()) do
            if killer:GetAttribute("ActorDisplayName") == "Noli" then
                local username = killer:GetAttribute("Username")
                if username then
                    if not noliByUsername[username] then noliByUsername[username] = {} end
                    table.insert(noliByUsername[username], killer)
                end
            end
        end
        for username, models in pairs(noliByUsername) do
            if #models > 1 then
                for i = 2, #models do models[i]:SetAttribute("IsFakeNoli", true) end
                models[1]:SetAttribute("IsFakeNoli", false)
            else
                models[1]:SetAttribute("IsFakeNoli", false)
            end
        end
    end
    local function updateFakeNolis()
        clearFakeTags()
        scanNolis()
    end

    local function setupModel(model, isKiller)
        if not model:IsA("Model") or not model:FindFirstChildOfClass("Humanoid") then return end
        local color = isKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 0)
        attachBillboard(model, color)
        updateBillboardText(model)
        if not model:FindFirstChild("ESP_Highlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESP_Highlight"
            highlight.FillTransparency = 1
            highlight.OutlineTransparency = 0
            highlight.OutlineColor = color
            highlight.Adornee = model
            highlight.Parent = model
        end
        model:GetAttributeChangedSignal("ActorDisplayName"):Connect(function() updateBillboardText(model) end)
        model:GetAttributeChangedSignal("SkinNameDisplay"):Connect(function() updateBillboardText(model) end)
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:GetPropertyChangedSignal("Health"):Connect(function() updateBillboardText(model) end)
            humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function() updateBillboardText(model) end)
        end
        model.AncestryChanged:Connect(function(_, parent)
            if not parent then
                local bb = model:FindFirstChild("ESP_NameBillboard")
                if bb then bb:Destroy() end
                local hl = model:FindFirstChild("ESP_Highlight")
                if hl then hl:Destroy() end
            end
        end)
    end

    local function scanFolder(folder, isKiller)
        for _, model in ipairs(folder:GetChildren()) do
            setupModel(model, isKiller)
        end
    end

    local function handleChildAdded(folder, isKiller)
        folder.ChildAdded:Connect(function(child)
            task.spawn(function()
                repeat task.wait() until child:IsDescendantOf(folder)
                local timeout = 3
                local timer = 0
                while (not child:FindFirstChild("Head") and not child:FindFirstChildWhichIsA("BasePart")) or not child:FindFirstChildOfClass("Humanoid") do
                    task.wait(0.1)
                    timer += 0.1
                    if timer > timeout then return end
                end
                task.wait(0.2)
                setupModel(child, isKiller)
            end)
        end)
    end

    task.spawn(function()
        while true do
            scanFolder(killersFolder, true)
            scanFolder(survivorsFolder, false)
            task.wait(5)
        end
    end)
    handleChildAdded(killersFolder, true)
    handleChildAdded(survivorsFolder, false)
    updateFakeNolis()

    killersFolder.ChildRemoved:Connect(function(removed)
        if removed:GetAttribute("ActorDisplayName") == "Noli" then updateFakeNolis() end
    end)
    killersFolder.ChildAdded:Connect(function(added)
        if added:GetAttribute("ActorDisplayName") == "Noli" then
            task.defer(function()
                task.wait(0.2)
                updateFakeNolis()
            end)
        end
    end)
    task.spawn(function()
        while true do
            task.wait(10)
            updateFakeNolis()
        end
    end)

    RunService.RenderStepped:Connect(function()
        for _, folderData in pairs({
            {folder = killersFolder, toggle = killersESP},
            {folder = survivorsFolder, toggle = survivorsESP},
        }) do
            for _, model in ipairs(folderData.folder:GetChildren()) do
                local bb = model:FindFirstChild("ESP_NameBillboard")
                local hl = model:FindFirstChild("ESP_Highlight")
                if bb then bb.Enabled = folderData.toggle end
                if hl then hl.Enabled = folderData.toggle end
                if folderData.toggle and bb and bb.Adornee then
                    local dist = (camera.CFrame.Position - bb.Adornee.Position).Magnitude
                    local scale = math.clamp(1 / (dist / 20), 0.5, 2)
                    local label = bb:FindFirstChild("NameLabel")
                    if label then
                        label.TextSize = math.clamp(10 * scale, 12, 20)
                        bb.Size = UDim2.new(0, label.TextBounds.X + 20, 0, 50 * scale)
                    end
                end
            end
        end
        updateRayESP()
    end)

    local colorByName = {
        BloxyCola = Color3.fromRGB(255, 140, 0),
        Medkit = Color3.fromRGB(255, 100, 255),
    }
    local espParts = {}
    local itemPartEspTrigger = nil

    local function createNameTag(part, tagName, color)
        if part:FindFirstChild("ESP_Billboard") then return end
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.Adornee = part
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.Parent = part
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = color
        textLabel.TextStrokeTransparency = 0
        textLabel.Text = tagName
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextScaled = false
        textLabel.TextSize = 10
        textLabel.Parent = billboard
    end

    local function createBoxESP(part)
        if not part or not part:IsA("BasePart") then return end
        if part.Name ~= "ItemRoot" or not part.Parent then return end
        local tagName = part.Parent.Name
        local color = colorByName[tagName] or Color3.fromRGB(255, 255, 255)
        if part:FindFirstChild(tagName.."_PESP") then return end
        local box = Instance.new("BoxHandleAdornment")
        box.Name = tagName.."_PESP"
        box.Adornee = part
        box.Size = part.Size
        box.Transparency = 0.5
        box.Color3 = color
        box.ZIndex = 0
        box.AlwaysOnTop = true
        box.Parent = part
        createNameTag(part, tagName, color)
        table.insert(espParts, tagName)
    end

    local function enableItemESP()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "ItemRoot" then
                createBoxESP(v)
            end
        end
        if not itemPartEspTrigger then
            itemPartEspTrigger = workspace.DescendantAdded:Connect(function(part)
                if part:IsA("BasePart") and part.Name == "ItemRoot" then
                    createBoxESP(part)
                end
            end)
        end
    end

    local function disableItemESP()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "ItemRoot" then
                if v:FindFirstChild("ESP_Billboard") then
                    v:FindFirstChild("ESP_Billboard"):Destroy()
                end
                local tagName = v.Parent and v.Parent.Name
                if tagName and v:FindFirstChild(tagName.."_PESP") then
                    v:FindFirstChild(tagName.."_PESP"):Destroy()
                end
            end
        end
        espParts = {}
        if itemPartEspTrigger then
            itemPartEspTrigger:Disconnect()
            itemPartEspTrigger = nil
        end
    end

    espTab:Toggle({
        Title = "发电机 ESP",
        Flag = "LuoyeConfig_051",
        Value = false,
        Callback = function(state)
            generatorsESP = state
            if state then
                startGenESP()
            else
                stopGenESP()
            end
        end
    })

    espTab:Toggle({
        Title = "杀手 ESP",
        Flag = "LuoyeConfig_052",
        Value = false,
        Callback = function(state)
            killersESP = state
        end
    })

    espTab:Toggle({
        Title = "幸存者 ESP",
        Flag = "LuoyeConfig_053",
        Value = false,
        Callback = function(state)
            survivorsESP = state
        end
    })

    espTab:Toggle({
        Title = "物品 ESP",
        Flag = "LuoyeConfig_054",
        Value = false,
        Callback = function(state)
            itemESP = state
            if state then
                enableItemESP()
            else
                disableItemESP()
            end
        end
    })

    espTab:Toggle({
        Title = "发电机射线 ESP",
        Flag = "LuoyeConfig_055",
        Value = false,
        Callback = function(state)
            generatorsRayESP = state
        end
    })

    espTab:Toggle({
        Title = "杀手射线 ESP",
        Flag = "LuoyeConfig_056",
        Value = false,
        Callback = function(state)
            killersRayESP = state
        end
    })

    espTab:Toggle({
        Title = "幸存者射线 ESP",
        Flag = "LuoyeConfig_057",
        Value = false,
        Callback = function(state)
            survivorsRayESP = state
        end
    })

    espTab:Toggle({
        Title = "物品射线 ESP",
        Flag = "LuoyeConfig_058",
        Value = false,
        Callback = function(state)
            itemRayESP = state
        end
    })

    espTab:Colorpicker({
        Title = "射线颜色",
        Flag = "LuoyeConfig_059",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(color)
            if typeof(color) == "Color3" then
                rayColor = color
            elseif typeof(color) == "table" then
                local value = color.Color or color.Value or color.color or color.value
                if typeof(value) == "Color3" then
                    rayColor = value
                end
            elseif typeof(color) == "string" then
                local ok, value = pcall(function()
                    return Color3.fromHex(color)
                end)
                if ok and typeof(value) == "Color3" then
                    rayColor = value
                end
            end
        end
    })
end


-- 物品
artTab:Section({
    Title = "物品互动",
    Box = true,
    Opened = true,
})

local autoTeleportMedkitEnabled = false
local teleportMedkitThread = nil

artTab:Toggle({
    Title = "医疗包传送并互动",
    Flag = "LuoyeConfig_060",
    Value = false,
    Callback = function(state)
        autoTeleportMedkitEnabled = state

        if autoTeleportMedkitEnabled then
            teleportMedkitThread = task.spawn(function()
                while autoTeleportMedkitEnabled and task.wait(0.5) do
                    local character = game.Players.LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local humanoidRootPart = character.HumanoidRootPart

                        local medkit = workspace:FindFirstChild("Map", true)
                        if medkit then
                            medkit = medkit:FindFirstChild("Ingame", true)
                            if medkit then
                                medkit = medkit:FindFirstChild("Medkit", true)
                                if medkit then
                                    local itemRoot = medkit:FindFirstChild("ItemRoot", true)
                                    if itemRoot then
                                        itemRoot.CFrame = humanoidRootPart.CFrame + humanoidRootPart.CFrame.LookVector * 3

                                        local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                        if prompt then
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        elseif teleportMedkitThread then
            task.cancel(teleportMedkitThread)
            teleportMedkitThread = nil
        end
    end
})

local autoTeleportColaEnabled = false
local teleportColaThread = nil

artTab:Toggle({
    Title = "可乐传送并互动",
    Flag = "LuoyeConfig_061",
    Value = false,
    Callback = function(state)
        autoTeleportColaEnabled = state

        if autoTeleportColaEnabled then
            teleportColaThread = task.spawn(function()
                while autoTeleportColaEnabled and task.wait(0.5) do
                    local character = game.Players.LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local humanoidRootPart = character.HumanoidRootPart

                        local cola = workspace:FindFirstChild("Map", true)
                        if cola then
                            cola = cola:FindFirstChild("Ingame", true)
                            if cola then
                                cola = cola:FindFirstChild("BloxyCola", true)
                                if cola then
                                    local itemRoot = cola:FindFirstChild("ItemRoot", true)
                                    if itemRoot then
                                        itemRoot.CFrame = humanoidRootPart.CFrame + humanoidRootPart.CFrame.LookVector * 3

                                        local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                        if prompt then
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        elseif teleportColaThread then
            task.cancel(teleportColaThread)
            teleportColaThread = nil
        end
    end
})

local autoMedkitEnabled = false
local medkitThread = nil

artTab:Toggle({
    Title = "自动互动医疗包",
    Flag = "LuoyeConfig_062",
    Value = false,
    Callback = function(state)
        autoMedkitEnabled = state

        if autoMedkitEnabled then
            medkitThread = task.spawn(function()
                while autoMedkitEnabled and task.wait(0.5) do
                    local medkit = workspace:FindFirstChild("Map", true)
                    if medkit then
                        medkit = medkit:FindFirstChild("Ingame", true)
                        if medkit then
                            medkit = medkit:FindFirstChild("Medkit", true)
                            if medkit then
                                local itemRoot = medkit:FindFirstChild("ItemRoot", true)
                                if itemRoot then
                                    local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                    if prompt then
                                        fireproximityprompt(prompt)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        elseif medkitThread then
            task.cancel(medkitThread)
            medkitThread = nil
        end
    end
})

local autoColaEnabled = false
local colaThread = nil

artTab:Toggle({
    Title = "自动互动可乐",
    Flag = "LuoyeConfig_063",
    Value = false,
    Callback = function(state)
        autoColaEnabled = state

        if autoColaEnabled then
            colaThread = task.spawn(function()
                while autoColaEnabled and task.wait(0.5) do
                    local cola = workspace:FindFirstChild("Map", true)
                    if cola then
                        cola = cola:FindFirstChild("Ingame", true)
                        if cola then
                            cola = cola:FindFirstChild("BloxyCola", true)
                            if cola then
                                local itemRoot = cola:FindFirstChild("ItemRoot", true)
                                if itemRoot then
                                    local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                    if prompt then
                                        fireproximityprompt(prompt)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        elseif colaThread then
            task.cancel(colaThread)
            colaThread = nil
        end
    end
})

-- 娱乐项目
amuTab:Section({
    Title = "娱乐项目",
    Box = true,
    Opened = true,
})

amuTab:Button({
    Title = "动画播放器",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/FengYu-X/FengYu-ui/refs/heads/mainTab/%E5%8A%A8%E7%94%BB%E6%92%AD%E6%94%BE%E5%99%A8.lua'))()
    end
})

amuTab:Toggle({
    Title = "坐下",
    Flag = "LuoyeConfig_064",
    Value = false,
    Callback = function(state)
        local char = LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Sit = state
            end
        end
    end
})

do
    local refreshEnabled = false
    local deathPosition = nil

    local function onDied()
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            deathPosition = LP.Character.HumanoidRootPart.CFrame
        end
    end

    local function onCharacterAdded(newChar)
        if refreshEnabled and deathPosition then
            local hrp = newChar:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = deathPosition
            end
        end
    end

    LP.CharacterAdded:Connect(onCharacterAdded)
    if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character.Humanoid.Died:Connect(onDied)
    end
    LP.CharacterAdded:Connect(function(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(onDied)
        end
    end)

amuTab:Toggle({
    Title = "刷新 (死亡后原地复活)",
    Flag = "LuoyeConfig_065",
    Value = false,
    Callback = function(state)
        refreshEnabled = state
    end
})
end

amuTab:Button({
    Title = "变成药丸宝宝",
    Callback = function()
        local char = LP.Character or LP.CharacterAdded:Wait()
        if char then
            repeat task.wait() until char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid")
            local limbs = {"Left Arm", "Right Arm", "Left Leg", "Right Leg"}
            for _, limb in ipairs(limbs) do
                local part = char:FindFirstChild(limb)
                if part then
                    part:Destroy()
                end
            end
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            if torso then
                local mesh = torso:FindFirstChildOfClass("SpecialMesh")
                if not mesh then
                    mesh = Instance.new("SpecialMesh", torso)
                end
                mesh.MeshId = "rbxasset://fonts/head.mesh"
                mesh.Scale = Vector3.new(1.4, 1.8, 1.4)
            end
        end
    end
})

amuTab:Button({
    Title = "向前滑铲",
    Callback = function()
        local vu727 = game.Players.LocalPlayer
        local v728 = vu727:WaitForChild("PlayerGui")
        local v729 = v728:FindFirstChild("ScreenGui")
        if not v729 then
            v729 = Instance.new("ScreenGui")
            v729.Name = "ScreenGui"
            v729.Parent = v728
        end
        local v730 = Instance.new("TextButton")
        v730.Size = UDim2.new(0, 100, 0, 40)
        v730.Position = UDim2.new(0.5, -50, 0.5, -20)
        v730.Text = "滑铲"
        v730.BackgroundColor3 = Color3.fromRGB(0, 119, 255)
        v730.TextColor3 = Color3.fromRGB(255, 255, 255)
        v730.Font = Enum.Font.GothamBold
        v730.TextSize = 16
        v730.BorderSizePixel = 0
        v730.Parent = v729
        v730.Draggable = true
    
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = v730
   
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Parent = v730
    
        v730.MouseEnter:Connect(function()
            v730.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end)
    
        v730.MouseLeave:Connect(function()
            v730.BackgroundColor3 = Color3.fromRGB(0, 119, 255)
        end)
    
        v730.MouseButton1Click:Connect(function()
            local v731 = vu727.Character or vu727.CharacterAdded:Wait()
            local v732 = v731:WaitForChild("HumanoidRootPart")
            local v733 = v731:WaitForChild("Humanoid")
            local v734 = Instance.new("Animation")
            v734.AnimationId = "rbxassetid://182749109"
            local vu735 = v733:LoadAnimation(v734)
            local v736 = vu735
            vu735:Play()
            local v737 = game:GetService("TweenService")
            local v738 = v732.CFrame * CFrame.new(0, 0, -20)
            local v739 = v737:Create(v732, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                CFrame = v738
            })
            v739:Play()
            v739.Completed:Connect(function()
                vu735:Stop()
            end)
        end)
    end
})

amuTab:Button({
    Title = "直升机",
    Callback = function()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local rig = hum.RigType
        local animId = (rig == Enum.HumanoidRigType.R6) and "rbxassetid://27432686" or "rbxassetid://507776043"
        local soundId = (rig == Enum.HumanoidRigType.R6) and "" or ""

        task.spawn(function()
            local Anim = Instance.new("Animation")
            Anim.AnimationId = animId
            local track = hum:LoadAnimation(Anim)
            track:Play()
            track:AdjustSpeed(0)

            local animate = char:FindFirstChild("Animate")
            if animate then animate.Disabled = true end

            local hi = Instance.new("Sound")
            hi.Name = "Sound"
            hi.SoundId = soundId
            hi.Volume = 2
            hi.Looped = true
            hi.archivable = false
            hi.Parent = workspace
            hi:Play()

            local spinSpeed = 40
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local Spin = Instance.new("BodyAngularVelocity")
                Spin.Name = "Spinning"
                Spin.Parent = root
                Spin.MaxTorque = Vector3.new(0, math.huge, 0)
                Spin.AngularVelocity = Vector3.new(0, spinSpeed, 0)
            end

            local Mouse = LP:GetMouse()
            if Mouse then
                local qUp, eUp
                qUp = Mouse.KeyUp:Connect(function(KEY)
                    if KEY == 'q' then
                        local hum2 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                        if hum2 then
                            hum2.HipHeight = hum2.HipHeight - 3
                        end
                    end
                end)
                eUp = Mouse.KeyUp:Connect(function(KEY)
                    if KEY == 'e' then
                        local hum2 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                        if hum2 then
                            hum2.HipHeight = hum2.HipHeight + 3
                        end
                    end
                end)
            end
        end)
    end
})

perTab:Section({
    Title = "视觉权限",
    Box = true,
    Opened = true,
})

perTab:Button({
    Title = "解锁全部角色和皮肤",
    Callback = function()
        task.spawn(function()
            local player = LP
            local purchased = player:WaitForChild("PlayerData"):WaitForChild("Purchased")
            
            local killersFolder = purchased:FindFirstChild("Killers") or Instance.new("Folder", purchased)
            killersFolder.Name = "Killers"
            local survivorsFolder = purchased:FindFirstChild("Survivors") or Instance.new("Folder", purchased)
            survivorsFolder.Name = "Survivors"
            local skinsFolder = purchased:FindFirstChild("Skins") or Instance.new("Folder", purchased)
            skinsFolder.Name = "Skins"

            for _, killer in ipairs(game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Killers"):GetChildren()) do
                if not killersFolder:FindFirstChild(killer.Name) then
                    Instance.new("StringValue", killersFolder).Name = killer.Name
                end
            end
            
            for _, survivor in ipairs(game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Survivors"):GetChildren()) do
                if not survivorsFolder:FindFirstChild(survivor.Name) then
                    Instance.new("StringValue", survivorsFolder).Name = survivor.Name
                end
            end
            
            local skinsRoot = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Skins")
            for _, skin in ipairs(skinsRoot:GetDescendants()) do
                if (skin:IsA("Folder") or skin:IsA("Model")) and not skinsFolder:FindFirstChild(skin.Name) then
                    Instance.new("StringValue", skinsFolder).Name = skin.Name
                end
            end
        end)
    end
})

perTab:Button({
    Title = "解锁所有动作",
    Callback = function()
        task.spawn(function()
            local player = LP
            local purchased = player:WaitForChild("PlayerData"):WaitForChild("Purchased")
            
            local emotesFolder = purchased:FindFirstChild("Emotes") or Instance.new("Folder", purchased)
            emotesFolder.Name = "Emotes"
            
            local emotesAssets = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Emotes")
            for _, module in ipairs(emotesAssets:GetDescendants()) do
                if module:IsA("ModuleScript") and not emotesFolder:FindFirstChild(module.Name) then
                    Instance.new("StringValue", emotesFolder).Name = module.Name
                end
            end
        end)
    end
})

perTab:Button({
    Title = "解锁VIP权限",
    Callback = function()
        LP:SetAttribute("VIP", true)
        local pData = LP:WaitForChild("PlayerData")
        local vVal = pData:FindFirstChild("VIP")
        if not vVal then
            vVal = Instance.new("BoolValue")
            vVal.Name = "VIP"
            vVal.Parent = pData
        end
        vVal.Value = true
    end
})

slaTab:Section({
    Title = "斩首者皮肤列表",
    Box = true,
    Opened = true,
})

slaTab:Button({
    Title = "恶魔化",
    Callback = function()
        _G.SkinEnabled = false
        if _G.SkinConnections then
            for _, c in ipairs(_G.SkinConnections) do
                c:Disconnect()
            end
            _G.SkinConnections = {}
        end
        if _G.SkinHornObjects then
            for _, v in ipairs(_G.SkinHornObjects) do
                if v then v:Destroy() end
            end
            _G.SkinHornObjects = {}
        end
        for _, name in ipairs({"OrbitKatana", "DarkHalo", "DemonHorn"}) do
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj.Name == name then
                    obj:Destroy()
                end
            end
        end
        if _G.SkinAuraConnection then
            _G.SkinAuraConnection:Disconnect()
            _G.SkinAuraConnection = nil
        end
        if _G.SkinAuraHolder then
            _G.SkinAuraHolder:Destroy()
            _G.SkinAuraHolder = nil
        end

        _G.SkinEnabled = true
        _G.SkinConnections = _G.SkinConnections or {}
        _G.SkinHornObjects = _G.SkinHornObjects or {}

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local plr = Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        local root = char:WaitForChild("HumanoidRootPart")
        local head = char:WaitForChild("Head")

        for _,v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") then
                v:Destroy()
            end
        end

        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Color = Color3.fromRGB(15,15,15)
                v.Material = Enum.Material.SmoothPlastic
            end
        end

        hum.Died:Connect(function()
            _G.SkinEnabled = false
            if _G.SkinConnections then
                for _, c in ipairs(_G.SkinConnections) do
                    c:Disconnect()
                end
                _G.SkinConnections = {}
            end
            if _G.SkinHornObjects then
                for _, v in ipairs(_G.SkinHornObjects) do
                    if v then v:Destroy() end
                end
                _G.SkinHornObjects = {}
            end
            for _, name in ipairs({"OrbitKatana", "DarkHalo", "DemonHorn"}) do
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj.Name == name then
                        obj:Destroy()
                    end
                end
            end
            if _G.SkinAuraConnection then
                _G.SkinAuraConnection:Disconnect()
                _G.SkinAuraConnection = nil
            end
            if _G.SkinAuraHolder then
                _G.SkinAuraHolder:Destroy()
                _G.SkinAuraHolder = nil
            end
        end)

        local halo = Instance.new("Part")
        halo.Name = "DarkHalo"
        halo.Size = Vector3.new(1,1,1)
        halo.Material = Enum.Material.Neon
        halo.Color = Color3.fromRGB(255,0,0)
        halo.Anchored = true
        halo.CanCollide = false
        halo.CanTouch = false
        halo.CanQuery = false
        halo.Parent = workspace

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://3270017"
        mesh.Scale = Vector3.new(1.5,1.5,0.08)
        mesh.Parent = halo

        local haloSmoke = Instance.new("ParticleEmitter")
        haloSmoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
        haloSmoke.Rate = 8
        haloSmoke.Lifetime = NumberRange.new(0.5,1)
        haloSmoke.Speed = NumberRange.new(0,0.3)
        haloSmoke.Parent = halo

        task.spawn(function()
            while halo.Parent and root.Parent and _G.SkinEnabled do
                local pulse = (math.sin(tick()*4)+1)/2
                halo.Color = Color3.fromRGB(55 + (200*pulse), 0, 0)
                halo.CFrame = CFrame.new(root.Position + Vector3.new(0,3.2,0)) * CFrame.Angles(math.rad(90), 0, tick()*3)
                task.wait()
            end
            if halo then halo:Destroy() end
        end)

        local function CreateHorn(side)
            local horn = Instance.new("Part")
            horn.Name = "DemonHorn"
            horn.Size = Vector3.new(0.15,1.8,0.15)
            horn.Material = Enum.Material.Neon
            horn.Color = Color3.fromRGB(255,0,0)
            horn.Anchored = true
            horn.CanCollide = false
            horn.CanTouch = false
            horn.CanQuery = false
            horn.Parent = workspace

            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = "rbxassetid://1033714"
            mesh.Scale = Vector3.new(0.25,1.8,0.25)
            mesh.Parent = horn

            local smoke = Instance.new("ParticleEmitter")
            smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
            smoke.Color = ColorSequence.new(Color3.fromRGB(0,0,0))
            smoke.Rate = 25
            smoke.Speed = NumberRange.new(0.5,1.5)
            smoke.Lifetime = NumberRange.new(1,2)
            smoke.Size = NumberSequence.new{
                NumberSequenceKeypoint.new(0,0.4),
                NumberSequenceKeypoint.new(1,0)
            }
            smoke.Parent = horn

            local lightning = Instance.new("ParticleEmitter")
            lightning.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
            lightning.LightEmission = 1
            lightning.Rate = 40
            lightning.Speed = NumberRange.new(2,5)
            lightning.Lifetime = NumberRange.new(0.1,0.3)
            lightning.Size = NumberSequence.new(0.15)
            lightning.Parent = horn

            table.insert(_G.SkinHornObjects, horn)

            local offset
            if side == "Left" then
                offset = CFrame.new(-0.35,0.45,-0.05) * CFrame.Angles(math.rad(-15), 0, math.rad(45))
            else
                offset = CFrame.new(0.35,0.45,-0.05) * CFrame.Angles(math.rad(-15), 0, math.rad(-45))
            end

            local conn = RunService.Heartbeat:Connect(function()
                if not _G.SkinEnabled then return end
                if head.Parent and horn.Parent then
                    local pulse = (math.sin(tick()*4)+1)/2
                    horn.Color = Color3.fromRGB(55 + (200*pulse), 0, 0)
                    horn.CFrame = head.CFrame * offset
                end
            end)
            table.insert(_G.SkinConnections, conn)
        end

        CreateHorn("Left")
        CreateHorn("Right")

        for i = 1,6 do
            local model = Instance.new("Model")
            model.Name = "OrbitKatana"
            model.Parent = workspace

            local blade = Instance.new("Part")
            blade.Size = Vector3.new(0.15,4,0.35)
            blade.Material = Enum.Material.Neon
            blade.Color = Color3.fromRGB(255,0,0)
            blade.Anchored = true
            blade.CanCollide = false
            blade.Parent = model

            local att0 = Instance.new("Attachment")
            att0.Position = Vector3.new(0,-1.95,0)
            att0.Parent = blade

            local att1 = Instance.new("Attachment")
            att1.Position = Vector3.new(0,1.95,0)
            att1.Parent = blade

            local trail = Instance.new("Trail")
            trail.Attachment0 = att0
            trail.Attachment1 = att1
            trail.Lifetime = 0.05
            trail.MinLength = 0.001
            trail.FaceCamera = false
            trail.Parent = blade
            trail.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40,0,0))
            })

            local smoke = Instance.new("ParticleEmitter")
            smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
            smoke.Color = ColorSequence.new(Color3.fromRGB(0,0,0))
            smoke.Rate = 10
            smoke.Lifetime = NumberRange.new(0.5,1)
            smoke.Speed = NumberRange.new(0,1)
            smoke.Parent = blade

            local handle = Instance.new("Part")
            handle.Size = Vector3.new(0.25,1,0.25)
            handle.Material = Enum.Material.SmoothPlastic
            handle.Color = Color3.fromRGB(15,15,15)
            handle.Anchored = true
            handle.CanCollide = false
            handle.Parent = model

            local guard = Instance.new("Part")
            guard.Size = Vector3.new(1,0.15,0.15)
            guard.Material = Enum.Material.Neon
            guard.Color = Color3.fromRGB(120,0,0)
            guard.Anchored = true
            guard.CanCollide = false
            guard.Parent = model

            task.spawn(function()
                while model.Parent and root.Parent and _G.SkinEnabled do
                    local t = tick() * 1.8
                    local angle = math.rad((i-1)*60) + t
                    local radius = 5
                    local pos = root.Position + Vector3.new(math.cos(angle)*radius, 2, math.sin(angle)*radius)
                    local pulse = (math.sin(tick()*5)+1)/2
                    blade.Color = Color3.fromRGB(55 + (200*pulse), 0, 0)
                    guard.Color = blade.Color
                    local cf = CFrame.new(pos) * CFrame.Angles(0, angle, math.rad(180))
                    blade.CFrame = cf
                    handle.CFrame = cf * CFrame.new(0,2.5,0)
                    guard.CFrame = cf * CFrame.new(0,2,0)
                    task.wait()
                end
                if model then model:Destroy() end
            end)
        end

        local auraTexts = {
            "must kill",
            "kill all",
            "fool",
            "1x1x1x1",
            "haha",
            "idiot",
            "i will kill you",
            "you will die"
        }

        local auraConnection = nil
        local auraHolder = nil
        local auraAlive = false

        local function splitText(text)
            if math.random() < 0.35 then
                local mid = math.floor(#text/2)
                return text:sub(1, mid) .. " " .. text:sub(mid+1)
            end
            return text
        end

        local function stopAura()
            auraAlive = false
            if auraConnection then
                auraConnection:Disconnect()
                auraConnection = nil
            end
            if auraHolder then
                auraHolder:Destroy()
                auraHolder = nil
            end
        end

        local function startAura(character)
            if not _G.SkinEnabled then return end
            stopAura()
            auraAlive = true

            local hrp = character:WaitForChild("HumanoidRootPart")
            local humanoid = character:WaitForChild("Humanoid")

            auraHolder = Instance.new("Part")
            auraHolder.Size = Vector3.new(1,1,1)
            auraHolder.Anchored = true
            auraHolder.CanCollide = false
            auraHolder.Transparency = 1
            auraHolder.Parent = character

            local labels = {}
            for i = 1, 2 do
                local gui = Instance.new("BillboardGui")
                gui.Size = UDim2.new(0, 100, 0, 35)
                gui.AlwaysOnTop = true
                gui.Parent = auraHolder

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.TextScaled = true
                label.Font = Enum.Font.Arcade
                label.TextSize = 70
                label.TextColor3 = Color3.fromRGB(255,0,0)
                label.TextStrokeTransparency = 0.3
                label.Parent = gui
                table.insert(labels, label)
            end

            local index1, index2 = 1, 2
            local lastSwitch = 0

            humanoid.Died:Connect(function()
                stopAura()
            end)

            auraConnection = RunService.RenderStepped:Connect(function()
                if not auraAlive then return end
                if not hrp or not hrp.Parent then return end

                local t = tick()
                local angle = t * 2
                auraHolder.Position = hrp.Position + Vector3.new(math.cos(angle)*3, 2 + math.sin(t*3)*0.6, math.sin(angle)*3)

                if t - lastSwitch > math.random(3, 6) / 10 then
                    lastSwitch = t
                    index1 = math.random(1, #auraTexts)
                    index2 = math.random(1, #auraTexts)
                end

                local function getText(i)
                    local txt = auraTexts[i]
                    if math.random() < 0.35 then
                        local mid = math.floor(#txt/2)
                        return txt:sub(1, mid) .. " " .. txt:sub(mid+1)
                    end
                    return txt
                end

                local jitter = Vector3.new((math.random()-0.5)*0.9, (math.random()-0.5)*0.9, (math.random()-0.5)*0.9)
                auraHolder.Position = auraHolder.Position + jitter

                labels[1].Text = getText(index1)
                labels[2].Text = getText(index2)

                for _, l in ipairs(labels) do
                    l.Rotation = math.random(-30, 30)
                    l.TextTransparency = (math.random() < 0.2) and 1 or 0
                end

                local c = (math.random() < 0.5) and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,0,0)
                labels[1].TextColor3 = c
                labels[2].TextColor3 = c
            end)
        end

        if char then
            startAura(char)
        end

        _G.SkinAuraConnection = auraConnection
        _G.SkinAuraHolder = auraHolder
    end
})

slaTab:Button({
    Title = "Titan TV Man皮肤",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")

        local plr = Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()

        task.wait(1)

        char = plr.Character or plr.CharacterAdded:Wait()

        local hum = char:WaitForChild("Humanoid")
        local root = char:WaitForChild("HumanoidRootPart")
        local head = char:WaitForChild("Head")

        pcall(function()
            hum.PlatformStand = false
            hum.AutoRotate = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end)
        root.AssemblyAngularVelocity = Vector3.zero

        local TV_SIZE = Vector3.new(1.8, 1.7, 1.7)

        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") then
                v:Destroy()
            end
        end

        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Color = Color3.fromRGB(10, 10, 10)
                v.Material = Enum.Material.SmoothPlastic
                v.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
            end
        end

        local function weldPart(part, parentPart, cf)
            part.Anchored = false
            part.CanCollide = false
            part.Massless = true
            part.CFrame = parentPart.CFrame * cf
            local weld = Instance.new("Motor6D")
            weld.Part0 = parentPart
            weld.Part1 = part
            weld.C0 = cf
            weld.Parent = parentPart
            return weld
        end

        for _, v in pairs(head:GetChildren()) do
            if v:IsA("Decal") then
                v:Destroy()
            end
        end

        local face = Instance.new("Decal")
        face.Name = "face"
        face.Texture = "rbxassetid://7074764"
        face.Face = Enum.NormalId.Front
        face.Parent = head

        head.Transparency = 1

        local tv = Instance.new("Part")
        tv.Name = "TitanTV"
        tv.Size = TV_SIZE
        tv.Color = Color3.fromRGB(20, 20, 20)
        tv.Material = Enum.Material.Metal
        tv.Parent = char
        weldPart(tv, head, CFrame.new(0, 0, 0))

        local screen = Instance.new("Part")
        screen.Name = "Screen"
        screen.Size = Vector3.new(1.45, 1.2, 0.05)
        screen.Material = Enum.Material.Neon
        screen.Color = Color3.fromRGB(255, 0, 0)
        screen.Parent = char
        weldPart(screen, tv, CFrame.new(0, 0, -0.9))

        local gui = Instance.new("SurfaceGui")
        gui.Face = Enum.NormalId.Front
        gui.AlwaysOnTop = true
        gui.Adornee = screen
        gui.Parent = screen

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://7074764"
        img.Parent = gui

        task.spawn(function()
            while task.wait(0.15) do
                if screen and screen.Parent then
                    screen.Color = Color3.fromRGB(
                        math.random(150, 255),
                        0,
                        math.random(0, 120)
                    )
                end
            end
        end)

        local aura = Instance.new("ParticleEmitter")
        aura.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        aura.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 0, 255))
        })
        aura.LightEmission = 1
        aura.Rate = 60
        aura.Speed = NumberRange.new(2, 5)
        aura.Lifetime = NumberRange.new(0.5, 1.5)
        aura.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.5),
            NumberSequenceKeypoint.new(1, 0)
        })
        aura.Parent = root

        local smoke = Instance.new("ParticleEmitter")
        smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
        smoke.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 0, 0))
        })
        smoke.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        })
        smoke.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2),
            NumberSequenceKeypoint.new(1, 5)
        })
        smoke.Lifetime = NumberRange.new(1.5, 3)
        smoke.Rate = 20
        smoke.Speed = NumberRange.new(1, 2)
        smoke.Rotation = NumberRange.new(0, 360)
        smoke.RotSpeed = NumberRange.new(-20, 20)
        smoke.SpreadAngle = Vector2.new(180, 180)
        smoke.Parent = root

        local tvElectric = Instance.new("ParticleEmitter")
        tvElectric.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        tvElectric.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 120))
        })
        tvElectric.LightEmission = 1
        tvElectric.Rate = 80
        tvElectric.Speed = NumberRange.new(3, 6)
        tvElectric.Lifetime = NumberRange.new(0.2, 0.5)
        tvElectric.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 0)
        })
        tvElectric.SpreadAngle = Vector2.new(360, 360)
        tvElectric.Parent = tv

        local a0 = Instance.new("Attachment")
        a0.Position = Vector3.new(0, 1, 0)
        a0.Parent = root

        local a1 = Instance.new("Attachment")
        a1.Position = Vector3.new(0, -1, 0)
        a1.Parent = root

        local trail = Instance.new("Trail")
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Lifetime = 0.2
        trail.MinLength = 0.1
        trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        trail.Parent = root

        hum.WalkSpeed = 16
        hum.JumpPower = 50

        RunService.Heartbeat:Connect(function()
            root.AssemblyAngularVelocity = Vector3.zero
            if hum.MoveDirection.Magnitude > 0 then
                local moveDir = hum.MoveDirection.Unit
                root.AssemblyLinearVelocity = Vector3.new(
                    moveDir.X * hum.WalkSpeed,
                    root.AssemblyLinearVelocity.Y,
                    moveDir.Z * hum.WalkSpeed
                )
            else
                root.AssemblyLinearVelocity = Vector3.new(
                    0,
                    root.AssemblyLinearVelocity.Y,
                    0
                )
            end
            if hum.Health <= hum.MaxHealth * 0.35 then
                if screen then
                    screen.Color = Color3.fromRGB(255, 0, 0)
                end
                aura.Rate = 120
                hum.WalkSpeed = 18
            else
                hum.WalkSpeed = 16
            end
        end)

        print("Titan TV Man BLACK SMOKE Loaded")

        -- 剑阵部分
        local char2 = player.Character or player.CharacterAdded:Wait()
        local root2 = char2:WaitForChild("HumanoidRootPart")
        local swordCount = 6
        local spacing = 1.3
        local offsetBack = 6
        local offsetHeight = 1.8
        local smooth = 0.15
        local pulseSpeed = 2
        local pulseMin = 1.5
        local pulseMax = 2.8
        local swords = {}

        local function createKatana()
            local model = Instance.new("Model")
            local blade = Instance.new("Part")
            blade.Size = Vector3.new(0.2, 0.4, 4)
            blade.Material = Enum.Material.Neon
            blade.Color = Color3.fromRGB(255, 0, 0)
            blade.Anchored = true
            blade.CanCollide = false
            blade.Parent = model

            local tip = Instance.new("Part")
            tip.Size = Vector3.new(0.2, 0.4, 0.8)
            tip.Material = Enum.Material.Neon
            tip.Color = Color3.fromRGB(255, 0, 0)
            tip.Anchored = true
            tip.CanCollide = false
            tip.Parent = model

            local guard = Instance.new("Part")
            guard.Size = Vector3.new(0.8, 0.2, 0.8)
            guard.Material = Enum.Material.Metal
            guard.Color = Color3.fromRGB(80, 0, 0)
            guard.Anchored = true
            guard.CanCollide = false
            guard.Parent = model

            local handle = Instance.new("Part")
            handle.Size = Vector3.new(0.3, 0.3, 1.2)
            handle.Material = Enum.Material.SmoothPlastic
            handle.Color = Color3.fromRGB(30, 0, 0)
            handle.Anchored = true
            handle.CanCollide = false
            handle.Parent = model

            local att0 = Instance.new("Attachment", blade)
            att0.Position = Vector3.new(0, 0, blade.Size.Z / 2)
            local att1 = Instance.new("Attachment", blade)
            att1.Position = Vector3.new(0, 0, -blade.Size.Z / 2)
            local trail = Instance.new("Trail")
            trail.Attachment0 = att0
            trail.Attachment1 = att1
            trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
            trail.Lifetime = 0.25
            trail.Parent = blade

            model.Parent = workspace
            return model, blade, tip, guard, handle
        end

        for i = 1, swordCount do
            local m, b, t, g, h = createKatana()
            table.insert(swords, { model = m, blade = b, tip = t, guard = g, handle = h })
        end

        local aura2 = Instance.new("ParticleEmitter")
        aura2.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        aura2.LightEmission = 1
        aura2.Rate = 80
        aura2.Speed = NumberRange.new(0)
        aura2.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }
        aura2.Parent = root2

        RunService.RenderStepped:Connect(function()
            local time = tick()
            local pulse = (math.sin(time * pulseSpeed) + 1) / 2
            local sizeValue = pulseMin + (pulseMax - pulseMin) * pulse
            aura2.Size = NumberSequence.new{
                NumberSequenceKeypoint.new(0, sizeValue),
                NumberSequenceKeypoint.new(1, 0)
            }

            for i, data in ipairs(swords) do
                local blade = data.blade
                local tip = data.tip
                local guard = data.guard
                local handle = data.handle

                local xOffset = (i - (swordCount + 1) / 2) * spacing
                local pos = root2.Position
                    + root2.CFrame.RightVector * xOffset
                    - root2.CFrame.LookVector * offsetBack
                    + Vector3.new(0, offsetHeight, 0)

                local baseCF = CFrame.lookAt(
                    pos,
                    pos - root2.CFrame.LookVector,
                    root2.CFrame.UpVector
                )

                local velocityY = root2.Velocity.Y
                local tilt = 0
                local currentSmooth = smooth

                if velocityY > 1 then
                    tilt = math.rad(45)
                elseif velocityY < -2 then
                    tilt = math.rad(-60 - math.clamp(-velocityY * 2, 0, 30))
                    currentSmooth = 0.08
                else
                    local sway = math.sin(time * 2 + i * 0.5) * math.rad(15)
                    local shakeX = math.sin(time * 20 + i) * 0.08
                    local shakeY = math.cos(time * 18 + i) * 0.08
                    tilt = sway
                    baseCF = baseCF * CFrame.new(shakeX, shakeY, 0)
                end

                local finalCF = baseCF * CFrame.Angles(tilt, 0, 0)
                local scale = 1 + pulse * 0.15
                blade.Size = Vector3.new(0.2, 0.4, 4 * scale)

                blade.CFrame = blade.CFrame:Lerp(finalCF, currentSmooth)
                tip.CFrame = tip.CFrame:Lerp(
                    finalCF * CFrame.new(0, 0, -(blade.Size.Z / 2 + tip.Size.Z / 2)),
                    currentSmooth
                )
                guard.CFrame = guard.CFrame:Lerp(
                    finalCF * CFrame.new(0, 0, (blade.Size.Z / 2 + guard.Size.Z / 2)),
                    currentSmooth
                )
                handle.CFrame = handle.CFrame:Lerp(
                    finalCF * CFrame.new(0, 0, (blade.Size.Z / 2 + guard.Size.Z + handle.Size.Z / 2)),
                    currentSmooth
                )
            end
        end)
    end
})

slaTab:Button({
    Title = "几何体皮肤",
    Callback = function()
        loadstring(game:HttpGet("https://encrypt-x.pages.dev/Scripts?Id=8726057978642"))("8726057978642")
    end
})

slaTab:Button({
    Title = "Mystic 管理员皮肤",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/Myst"))()
    end
})

slaTab:Button({
    Title = "Sancho 管理员皮肤",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/San"))()
    end
})

slaTab:Button({
    Title = "Noli",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/Noli"))()
    end
})

slaTab:Button({
    Title = "访客 666",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/G666"))()
    end
})

johTab:Section({
    Title = "约翰.多皮肤列表",
    Box = true,
    Opened = true,
})

johTab:Button({
    Title = "歼灭",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/Annihilation"))()
    end
})

johTab:Button({
    Title = "圆规小姐",
    Callback = function()
        loadstring(game:HttpGet("https://protected-roblox-scripts.onrender.com/2eb46abf5cea8f923296a7f4b27fa868"))()
    end
})

cooTab:Section({
    Title = "酷小孩皮肤列表",
    Box = true,
    Opened = true,
})

cooTab:Button({
    Title = "2011 X",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/2011x"))()
    end
})

lXlTab:Section({
    Title = "1X1X1X1皮肤列表",
    Box = true,
    Opened = true,
})

lXlTab:Button({
    Title = "Gabriel",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/Gabriel"))()
    end
})

sheTab:Section({
    Title = "谢德莱茨基皮肤列表",
    Box = true,
    Opened = true,
})

sheTab:Button({
    Title = "心碎之人",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/HeartBroken%20Boohoo"))()
    end
})

chaTab:Section({
    Title = "机会皮肤列表",
    Box = true,
    Opened = true,
})

chaTab:Button({
    Title = "lsaac",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/heC1USQ1"))()
    end
})

twoTab:Section({
    Title = "两次皮肤列表",
    Box = true,
    Opened = true,
})

twoTab:Button({
    Title = "小宝宝",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/BTT"))()
    end
})

game:GetObjects("rbxassetid://115662197522885")[1].Parent = game.ReplicatedStorage

-- UI设置
x:Section({
    Title = "FPS/通知区域",
    Box = true,
    Opened = true,
})

x:Toggle({
    Title = "显示FPS",
    Flag = "LuoyeConfig_066",
    Desc = "点击运行",
    Icon = "",
    Type = "Checkbox",
    Value = false, 
    Callback = function(v)
        if v then
            _G.f = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
            local t = Instance.new("TextLabel", _G.f)
            _G.f.Name = "FPS"
            t.Size = UDim2.new(0, 100, 0, 50)
            t.Position = UDim2.new(0, 10, 0, 10)
            t.BackgroundTransparency = 1
            t.TextColor3 = Color3.new(1, 1, 1)
            t.TextSize = 20
            local l = 0
            _G.c = game:GetService("RunService").RenderStepped:Connect(function(d)
                l = l + d
                if l >= 0.8 then
                    t.Text = "FPS: " .. math.floor(1 / d)
                    l = 0
                end
            end)
        else
            if _G.f then _G.f:Destroy() _G.f = nil end
            if _G.c then _G.c:Disconnect() _G.c = nil end
        end
    end
})

local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")

x:Toggle({
    Title = "网络检测",
    Flag = "LuoyeConfig_067",
    Desc = "显示Ping",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        if v then
            _G.p = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
            local t = Instance.new("TextLabel", _G.p)
            _G.p.Name = "Ping"
            t.Size = UDim2.new(0, 100, 0, 50)
            t.Position = UDim2.new(0, 10, 0, 60)
            t.BackgroundTransparency = 1
            t.TextColor3 = Color3.new(1,1,1)
            t.TextSize = 20
            t.Font = Enum.Font.SourceSans
            t.Text = "延迟: ..."
            local l = 0
            _G.pc = RunService.RenderStepped:Connect(function(d)
                l = l + d
                if l >= 0.5 then
                    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                    t.Text = "延迟: "..math.floor(ping).."ms"
                    l = 0
                end
            end)
        else
            if _G.p then _G.p:Destroy() _G.p = nil end
            if _G.pc then _G.pc:Disconnect() _G.pc = nil end
        end
    end
})


-- =========================================================
-- 配置系统（新增）
-- =========================================================
do
    local ConfigManager = Window.ConfigManager

    if ConfigManager then
        pcall(function()
            ConfigManager:Init(Window)
        end)

        local configName = "default"
        local currentConfig = nil

        configTab:Section({
            Title = "配置管理",
            Box = true,
            Opened = true,
        })

        configTab:Paragraph({
            Title = "保存当前设置",
            Desc = "保存带有 Flag 的 Toggle / Slider / Colorpicker 设置。",
            Image = "save",
            ImageSize = 20,
        })

        local configNameInput = configTab:Input({
            Title = "配置名称",
            Value = configName,
            Placeholder = "例如：默认配置",
            Callback = function(value)
                value = tostring(value or "")
                value = value:gsub("[\\/:*?\"<>|]", "_")
                if value == "" then
                    value = "default"
                end
                configName = value
            end
        })

        local configList = configTab:Paragraph({
            Title = "已有配置",
            Desc = "正在读取...",
            Image = "folder",
            ImageSize = 20,
        })

        local function notify(title, content, icon)
            pcall(function()
                WindUI:Notify({
                    Title = title,
                    Content = content,
                    Icon = icon or "info",
                    Duration = 3,
                })
            end)
        end

        local function getConfigNames()
            local ok, result = pcall(function()
                return ConfigManager:AllConfigs()
            end)

            if not ok or type(result) ~= "table" then
                return {}
            end

            local names = {}
            for _, name in ipairs(result) do
                name = tostring(name)
                name = name:gsub("%.json$", "")
                table.insert(names, name)
            end

            table.sort(names)
            return names
        end

        local function refreshConfigList()
            local names = getConfigNames()

            if #names == 0 then
                pcall(function()
                    configList:SetDesc("暂无已保存配置")
                end)
                return
            end

            pcall(function()
                configList:SetDesc(table.concat(names, "\n"))
            end)
        end

        configTab:Button({
            Title = "保存配置",
            Icon = "save",
            Variant = "Primary",
            Callback = function()
                if configName == "" then
                    configName = "default"
                end

                local ok, cfg = pcall(function()
                    return ConfigManager:CreateConfig(configName)
                end)

                if not ok or not cfg then
                    notify("保存失败", "无法创建配置：" .. tostring(configName), "x")
                    return
                end

                currentConfig = cfg

                local saved, result = pcall(function()
                    return cfg:Save()
                end)

                if saved and result ~= false then
                    refreshConfigList()
                    notify("保存成功", "配置「" .. configName .. "」已保存", "check")
                else
                    notify("保存失败", "配置「" .. configName .. "」保存失败", "x")
                end
            end
        })

        configTab:Button({
            Title = "加载配置",
            Icon = "folder-open",
            Callback = function()
                if configName == "" then
                    configName = "default"
                end

                local ok, cfg = pcall(function()
                    return ConfigManager:CreateConfig(configName)
                end)

                if not ok or not cfg then
                    notify("加载失败", "无法打开配置：" .. tostring(configName), "x")
                    return
                end

                currentConfig = cfg

                local loaded, result = pcall(function()
                    return cfg:Load()
                end)

                if loaded and result ~= false then
                    notify("加载成功", "配置「" .. configName .. "」已加载", "check")
                else
                    notify("加载失败", "配置「" .. configName .. "」不存在或加载失败", "x")
                end
            end
        })

        configTab:Button({
            Title = "删除配置",
            Icon = "trash-2",
            Callback = function()
                if configName == "" then
                    configName = "default"
                end

                local ok, cfg = pcall(function()
                    return ConfigManager:CreateConfig(configName)
                end)

                if not ok or not cfg then
                    notify("删除失败", "无法打开配置：" .. tostring(configName), "x")
                    return
                end

                local deleted, result = pcall(function()
                    return cfg:Delete()
                end)

                if deleted and result ~= false then
                    currentConfig = nil
                    refreshConfigList()
                    notify("删除成功", "配置「" .. configName .. "」已删除", "check")
                else
                    notify("删除失败", "配置「" .. configName .. "」不存在或删除失败", "x")
                end
            end
        })

        configTab:Button({
            Title = "刷新配置列表",
            Icon = "refresh-cw",
            Callback = function()
                refreshConfigList()
            end
        })

        configTab:Paragraph({
            Title = "说明",
            Desc = "只保存带有 Flag 的设置项；按钮类操作不会被保存。",
            Image = "info",
            ImageSize = 20,
        })

        refreshConfigList()
    else
        configTab:Section({
            Title = "配置管理",
            Box = true,
            Opened = true,
        })

        configTab:Paragraph({
            Title = "ConfigManager 不可用",
            Desc = "当前 WindUI 版本没有提供 ConfigManager，其他功能未被修改。",
            Image = "alert-triangle",
            ImageSize = 20,
        })
    end
end
