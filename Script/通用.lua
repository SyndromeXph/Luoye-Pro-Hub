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
    Author = "首页/作者kr X",
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

t = Window:Tab({
    Title = "公告",
    Collapsible = true,
    Opened = true,      
    Locked = false,
})

rtr = t:Tab({
    Title = "作者/群",
})

playerTab = t:Tab({
    Title = "更新日志",
})

a = Window:Tab({
    Title = "通用",
    Collapsible = true,
    Opened = true,      
    Locked = false,
})

c = a:Tab({
    Title = "本地/区域",
})

b = a:Tab({
    Title = "娱乐/区域",
})

n = a:Tab({
    Title = "飞行/区域",
})

m = a:Tab({
    Title = "gui/区域",
})

p = a:Tab({
    Title = "ESP/区域",
})

i = a:Tab({
    Title = "重置和保存/区域",
})

u = a:Tab({
    Title = "动态模糊/区域",
})

hh = a:Tab({
    Title = "Ui区域/设置定义",
})

op = a:Tab({
    Title = "外部脚本",
})

r = Window:Tab({
    Title = "火箭发射模拟器",
    Icon = "",
    Locked = false,
})

s = Window:Tab({
    Title = "河北唐县",
    Icon = "",
    Locked = false,
})

AuraTab = Window:Tab({
    Title = "内脏与黑火药",
    Icon = "",
    Locked = false,
})

f = Window:Tab({
    Title = "俄亥俄州",
    Icon = "",
    Locked = false,
})


hy = Window:Tab({
    Title = "金钱点击器增量",
    Icon = "",
    Locked = false,
})

hbh = Window:Tab({
    Title = "每次点击都更快",
    Icon = "",
    Locked = false,
})

yuu = Window:Tab({
    Title = "doors",
    Icon = "",
    Locked = false,
})

xzx = Window:Tab({
    Title = "恶魔学",
    Icon = "",
    Locked = false,
})

awa = Window:Tab({
    Title = "horror",
    Icon = "",
    Locked = false,
})

vb = Window:Tab({
    Title = "最强战场",
    Icon = "",
    Locked = false,
})

rtr:Section({
    Title = "作者kr X",
     Desc = "问题联系qq 1826649340",
    Box = true,
    Opened = true,
})

rtr:Section({
    Title = "落叶Hub官方群 qq:961626866",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "更新日志",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/2/25:付费上架",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/3/4:新增功能和修复",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/3/14:新增功能和修复",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/3/16:修复已知问题和新增功能",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/3/18:修复已知自瞄问题和新增功能",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/3/24:新增功能",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/4/3:修复已知问题和补丁优化",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/4/16:修复已知问题和补丁优化",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/4/18:优化和新增功能",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/5/24:优化和新增功能",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/5/25:优化和新增功能",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/5/29:优化和新增功能",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/6/2:暂无太大改进仅优化使用和体验稳定性提升",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/6/4:针对自瞄区域更新另外也针对",
     Desc = "被遗弃进行大功能更新[被遗弃]当前合作方风御 X",
    Box = true,
    Opened = true,
})

playerTab:Section({
    Title = "2026/6/11:修复了暴力区的功能失效问题另外也进行了UI二改调整 新增自瞄白名单模式",
    Box = true,
    Opened = true,
})


local running = false

hy:Toggle({
    Title = "自动点击",
    Value = false,
    Callback = function(state)
        running = state
        
        if running then
            task.spawn(function()
                while running do
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("Events")
                        :WaitForChild("ClickMoney")
                        :FireServer()
                        
                    task.wait(0.1)
                end
            end)
        end
    end
})

local running = false

hbh:Toggle({
    Title = "自动点击",
    Value = false,
    Callback = function(v)
        running = v
        
        if running then
            task.spawn(function()
                while running do
                    game:GetService("ReplicatedStorage")
                    :WaitForChild("Remotes")
                    :WaitForChild("Click")
                    :FireServer()
                    
                    task.wait(0.1)
                end
            end)
        end
    end
})

yuu:Section({
    Title = "透视区域",
    Box = true,
    Opened = true,
})

local DoorESP = false

yuu:Toggle({
    Title = "门高亮",
    Value = false,
    Callback = function(v)
        DoorESP = v
        
        if v then
            WindUI:Notify({
                Title = "门高亮",
                Content = "开启成功",
                Duration = 2,
                Icon = "crown"
            })
        else
            WindUI:Notify({
                Title = "门高亮",
                Content = "关闭成功",
                Duration = 2,
                Icon = "crown"
            })
        end
        
        if DoorESP then
            task.spawn(function()
                local plr = game.Players.LocalPlayer
                
                while DoorESP do
                    local char = plr.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    
                    for _,obj in pairs(workspace:GetDescendants()) do
                        
                        if obj.Name == "Door" and obj.Parent and obj.Parent.Name == "Door" then
                            
                            if not obj:FindFirstChild("DoorHighlight") then
                                local h = Instance.new("Highlight")
                                h.Name = "DoorHighlight"
                                h.FillColor = Color3.fromRGB(0,0,255)
                                h.FillTransparency = 0.25
                                h.OutlineColor = Color3.fromRGB(0,0,255)
                                h.Adornee = obj
                                h.Parent = obj
                            end
                            
                            if root then
                                local dist = math.floor((root.Position - obj.Position).Magnitude)
                                
                                local gui = obj:FindFirstChild("DoorText")
                                
                                if not gui then
                                    gui = Instance.new("BillboardGui")
                                    gui.Name = "DoorText"
                                    gui.Size = UDim2.new(0,80,0,30)
                                    gui.AlwaysOnTop = true
                                    gui.StudsOffset = Vector3.new(0,2,0)
                                    gui.Parent = obj
                                    
                                    local text = Instance.new("TextLabel")
                                    text.BackgroundTransparency = 1
                                    text.Size = UDim2.new(1,0,1,0)
                                    text.TextColor3 = Color3.fromRGB(0,170,255)
                                    text.TextStrokeTransparency = 0
                                    text.Font = Enum.Font.SourceSansBold
                                    text.TextSize = 14
                                    text.Parent = gui
                                end
                                
                                local text = gui:FindFirstChildOfClass("TextLabel")
                                if text then
                                    text.Text = "门 "..dist.."m"
                                end
                            end
                            
                        end
                        
                    end
                    
                    task.wait(0.3)
                end
            end)
        else
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "DoorHighlight" or v.Name == "DoorText" then
                    v:Destroy()
                end
            end
        end
        
    end
})

local KeyESP = false

yuu:Toggle({
    Title = "钥匙高亮",
    Value = false,
    Callback = function(v)
        KeyESP = v
        
        if v then
            WindUI:Notify({
                Title = "钥匙高亮",
                Content = "开启成功",
                Duration = 2,
                Icon = "crown"
            })
        else
            WindUI:Notify({
                Title = "钥匙高亮",
                Content = "关闭成功",
                Duration = 2,
                Icon = "crown"
            })
        end
        
        if KeyESP then
            task.spawn(function()
                while KeyESP do
                    for _,obj in pairs(workspace.CurrentRooms:GetDescendants()) do
                        if obj.Name == "KeyObtain" then
                            
                            if not obj:FindFirstChild("KeyHighlight") then
                                local h = Instance.new("Highlight")
                                h.Name = "KeyHighlight"
                                h.FillColor = Color3.fromRGB(255,0,0)
                                h.FillTransparency = 0.25
                                h.OutlineColor = Color3.fromRGB(255,0,0)
                                h.Parent = obj
                                h.Adornee = obj
                            end
                            
                            if not obj:FindFirstChild("KeyESPText") then
                                
                                local billboard = Instance.new("BillboardGui")
                                billboard.Name = "KeyESPText"
                                billboard.Size = UDim2.new(0,120,0,30)
                                billboard.StudsOffset = Vector3.new(0,1.5,0)
                                billboard.AlwaysOnTop = true
                                billboard.Parent = obj
                                
                                local text = Instance.new("TextLabel")
                                text.Size = UDim2.new(1,0,1,0)
                                text.BackgroundTransparency = 1
                                text.TextColor3 = Color3.fromRGB(255,0,0)
                                text.TextStrokeTransparency = 0
                                text.TextStrokeColor3 = Color3.new(0,0,0)
                                text.Font = Enum.Font.GothamBold
                                text.TextSize = 14
                                text.Text = "钥匙"
                                text.Parent = billboard
                                
                                task.spawn(function()
                                    while KeyESP and obj.Parent do
                                        
                                        local player = game.Players.LocalPlayer
                                        local char = player.Character
                                        
                                        if char and char:FindFirstChild("HumanoidRootPart") then
                                            
                                            local part = obj:FindFirstChildWhichIsA("BasePart")
                                            
                                            if part then
                                                local dist = (char.HumanoidRootPart.Position - part.Position).Magnitude
                                                text.Text = "钥匙 "..math.floor(dist).."m"
                                            end
                                            
                                        end
                                        
                                        task.wait(0.2)
                                    end
                                end)
                                
                            end
                            
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "KeyHighlight" or v.Name == "KeyESPText" then
                    v:Destroy()
                end
            end
        end
        
    end
})

local WardrobeESP = false

yuu:Toggle({
    Title = "柜子高亮",
    Value = false,
    Callback = function(v)
        WardrobeESP = v
        
        if v then
            WindUI:Notify({
                Title = "柜子高亮",
                Content = "开启成功",
                Duration = 2,
                Icon = "crown"
            })
        else
            WindUI:Notify({
                Title = "柜子高亮",
                Content = "关闭成功",
                Duration = 2,
                Icon = "crown"
            })
        end
        
        if WardrobeESP then
            task.spawn(function()
                while WardrobeESP do
                    
                    local player = game.Players.LocalPlayer
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    
                    for _,obj in pairs(workspace:GetDescendants()) do
                        
                        if obj.Name == "Wardrobe" and obj.Parent and obj.Parent.Name == "Assets" then
                            
                            if not obj:FindFirstChild("WardrobeHighlight") then
                                local h = Instance.new("Highlight")
                                h.Name = "WardrobeHighlight"
                                h.FillColor = Color3.fromRGB(0,255,0)
                                h.FillTransparency = 0.25
                                h.OutlineColor = Color3.fromRGB(0,255,0)
                                h.Adornee = obj
                                h.Parent = obj
                            end
                            
                            if not obj:FindFirstChild("WardrobeText") then
                                
                                local gui = Instance.new("BillboardGui")
                                gui.Name = "WardrobeText"
                                gui.Size = UDim2.new(0,90,0,30)
                                gui.StudsOffset = Vector3.new(0,2,0)
                                gui.AlwaysOnTop = true
                                gui.Parent = obj
                                
                                local text = Instance.new("TextLabel")
                                text.Size = UDim2.new(1,0,1,0)
                                text.BackgroundTransparency = 1
                                text.TextColor3 = Color3.fromRGB(0,255,0)
                                text.TextStrokeTransparency = 0
                                text.TextStrokeColor3 = Color3.new(0,0,0)
                                text.Font = Enum.Font.GothamBold
                                text.TextSize = 14
                                text.Text = "柜子"
                                text.Parent = gui
                                
                                task.spawn(function()
                                    while WardrobeESP and obj.Parent do
                                        
                                        if root then
                                            local part = obj:FindFirstChildWhichIsA("BasePart")
                                            
                                            if part then
                                                local dist = (root.Position - part.Position).Magnitude
                                                text.Text = "柜子 "..math.floor(dist).."m"
                                            end
                                        end
                                        
                                        task.wait(0.2)
                                    end
                                end)
                                
                            end
                            
                        end
                        
                    end
                    
                    task.wait(0.5)
                end
            end)
        else
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "WardrobeHighlight" or v.Name == "WardrobeText" then
                    v:Destroy()
                end
            end
        end
        
    end
})

local GoldESP = false

yuu:Toggle({
    Title = "金币高亮",
    Value = false,
    Callback = function(v)
        GoldESP = v
        
        if v then
            WindUI:Notify({
                Title = "金币高亮",
                Content = "开启成功",
                Duration = 2,
                Icon = "crown"
            })
        else
            WindUI:Notify({
                Title = "金币高亮",
                Content = "关闭成功",
                Duration = 2,
                Icon = "crown"
            })
        end
        
        if GoldESP then
            task.spawn(function()
                while GoldESP do
                    
                    local player = game.Players.LocalPlayer
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    
                    for _,obj in pairs(workspace:GetDescendants()) do
                        
                        if obj.Name == "GoldPile" or obj.Name == "GoldVisualHolder" then
                            
                            if not obj:FindFirstChild("GoldHighlight") then
                                
                                local h = Instance.new("Highlight")
                                h.Name = "GoldHighlight"
                                h.FillColor = Color3.fromRGB(255,215,0)
                                h.FillTransparency = 0.2
                                h.OutlineColor = Color3.fromRGB(255,215,0)
                                h.OutlineTransparency = 0
                                h.Adornee = obj
                                h.Parent = obj
                                
                            end
                            
                            if not obj:FindFirstChild("GoldText") then
                                
                                local gui = Instance.new("BillboardGui")
                                gui.Name = "GoldText"
                                gui.Size = UDim2.new(0,90,0,30)
                                gui.StudsOffset = Vector3.new(0,1.5,0)
                                gui.AlwaysOnTop = true
                                gui.Parent = obj
                                
                                local text = Instance.new("TextLabel")
                                text.Size = UDim2.new(1,0,1,0)
                                text.BackgroundTransparency = 1
                                text.TextColor3 = Color3.fromRGB(255,215,0)
                                text.TextStrokeTransparency = 0
                                text.TextStrokeColor3 = Color3.new(0,0,0)
                                text.Font = Enum.Font.GothamBold
                                text.TextSize = 14
                                text.Text = "金币"
                                text.Parent = gui
                                
                                task.spawn(function()
                                    while GoldESP and obj.Parent do
                                        
                                        if root then
                                            
                                            local part = obj:FindFirstChildWhichIsA("BasePart")
                                            
                                            if part then
                                                local dist = (root.Position - part.Position).Magnitude
                                                text.Text = "金币 "..math.floor(dist).."m"
                                            end
                                            
                                        end
                                        
                                        task.wait(0.2)
                                    end
                                end)
                                
                            end
                            
                        end
                        
                    end
                    
                    task.wait(0.5)
                end
            end)
        else
            
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "GoldHighlight" or v.Name == "GoldText" then
                    v:Destroy()
                end
            end
            
        end
    end
})

local LeverESP = false

yuu:Toggle({
    Title = "拉杆高亮",
    Value = false,
    Callback = function(v)
        LeverESP = v
        
        if v then
            WindUI:Notify({
                Title = "拉杆高亮",
                Content = "开启成功",
                Duration = 2,
                Icon = "crown"
            })
        else
            WindUI:Notify({
                Title = "拉杆高亮",
                Content = "关闭成功",
                Duration = 2,
                Icon = "crown"
            })
        end
        
        if LeverESP then
            task.spawn(function()
                while LeverESP do
                    
                    local player = game.Players.LocalPlayer
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    
                    for _,obj in pairs(workspace:GetDescendants()) do
                        
                        if obj.Name == "LeverForGate" or obj.Name == "BackdoorModLevers" then
                            
                            if not obj:FindFirstChild("LeverHighlight") then
                                
                                local h = Instance.new("Highlight")
                                h.Name = "LeverHighlight"
                                h.FillColor = Color3.fromRGB(0,255,200)
                                h.FillTransparency = 0.2
                                h.OutlineColor = Color3.fromRGB(0,255,200)
                                h.OutlineTransparency = 0
                                h.Adornee = obj
                                h.Parent = obj
                                
                            end
                            
                            if not obj:FindFirstChild("LeverText") then
                                
                                local gui = Instance.new("BillboardGui")
                                gui.Name = "LeverText"
                                gui.Size = UDim2.new(0,90,0,30)
                                gui.StudsOffset = Vector3.new(0,1.5,0)
                                gui.AlwaysOnTop = true
                                gui.Parent = obj
                                
                                local text = Instance.new("TextLabel")
                                text.Size = UDim2.new(1,0,1,0)
                                text.BackgroundTransparency = 1
                                text.TextColor3 = Color3.fromRGB(0,255,200)
                                text.TextStrokeTransparency = 0
                                text.TextStrokeColor3 = Color3.new(0,0,0)
                                text.Font = Enum.Font.GothamBold
                                text.TextSize = 14
                                text.Text = "拉杆"
                                text.Parent = gui
                                
                                task.spawn(function()
                                    while LeverESP and obj.Parent do
                                        
                                        if root then
                                            
                                            local part = obj:FindFirstChildWhichIsA("BasePart")
                                            
                                            if part then
                                                local dist = (root.Position - part.Position).Magnitude
                                                text.Text = "拉杆 "..math.floor(dist).."m"
                                            end
                                            
                                        end
                                        
                                        task.wait(0.2)
                                    end
                                end)
                                
                            end
                            
                        end
                        
                    end
                    
                    task.wait(0.5)
                end
            end)
        else
            
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "LeverHighlight" or v.Name == "LeverText" then
                    v:Destroy()
                end
            end
            
        end
    end
})

yuu:Section({
    Title = "怪物提示区域",
    Box = true,
    Opened = true,
})

local RushDetect = false
local RushConnection = nil

yuu:Toggle({
    Title = "Rush检测",
    Value = false,
    Callback = function(v)
        RushDetect = v
        
        if v then
            
            WindUI:Notify({
                Title = "Rush检测",
                Content = "检测已开启",
                Duration = 2,
                Icon = "crown",
            })
            
            RushConnection = workspace.ChildAdded:Connect(function(obj)
                
                if not RushDetect then return end
                
                if string.find(obj.Name:lower(),"rush") then
                    
                    WindUI:Notify({
                        Title = "怪物警告",
                        Content = "Rush 即将到来！",
                        Duration = 3,
                        Icon = "crown",
                    })
                    
                    if not obj:FindFirstChild("RushHighlight") then
                        
                        local h = Instance.new("Highlight")
                        h.Name = "RushHighlight"
                        h.FillColor = Color3.fromRGB(255,0,0)
                        h.FillTransparency = 0.25
                        h.OutlineColor = Color3.fromRGB(255,0,0)
                        h.OutlineTransparency = 0
                        h.Adornee = obj
                        h.Parent = obj
                        
                    end
                    
                    if not obj:FindFirstChild("RushText") then
                        
                        local gui = Instance.new("BillboardGui")
                        gui.Name = "RushText"
                        gui.Size = UDim2.new(0,100,0,30)
                        gui.StudsOffset = Vector3.new(0,3,0)
                        gui.AlwaysOnTop = true
                        gui.Parent = obj
                        
                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1,0,1,0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.fromRGB(255,0,0)
                        text.TextStrokeTransparency = 0
                        text.TextStrokeColor3 = Color3.new(0,0,0)
                        text.Font = Enum.Font.GothamBold
                        text.TextSize = 16
                        text.Text = "Rush"
                        text.Parent = gui
                        
                        task.spawn(function()
                            
                            local player = game.Players.LocalPlayer
                            local char = player.Character
                            local root = char and char:FindFirstChild("HumanoidRootPart")
                            
                            while RushDetect and obj.Parent do
                                
                                if root then
                                    
                                    local part = obj:FindFirstChildWhichIsA("BasePart")
                                    
                                    if part then
                                        local dist = (root.Position - part.Position).Magnitude
                                        text.Text = "Rush "..math.floor(dist).."m"
                                    end
                                    
                                end
                                
                                task.wait(0.1)
                            end
                            
                        end)
                        
                    end
                    
                end
                
            end)
            
        else
            
            WindUI:Notify({
                Title = "Rush检测",
                Content = "检测已关闭",
                Duration = 2,
                Icon = "crown",
            })
            
            if RushConnection then
                RushConnection:Disconnect()
                RushConnection = nil
            end
            
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "RushHighlight" or v.Name == "RushText" then
                    v:Destroy()
                end
            end
            
        end
        
    end
})

local EyesDetect = false
local EyesConnection = nil

yuu:Toggle({
    Title = "Eyes检测",
    Value = false,
    Callback = function(v)
        EyesDetect = v
        
        if v then
            
            WindUI:Notify({
                Title = "Eyes检测",
                Content = "检测已开启",
                Duration = 2,
                Icon = "crown",
            })
            
            EyesConnection = workspace.ChildAdded:Connect(function(obj)
                
                if not EyesDetect then return end
                
                if string.find(obj.Name:lower(),"eyes") then
                    
                    WindUI:Notify({
                        Title = "怪物警告",
                        Content = "Eyes 出现了！不要看它！",
                        Duration = 3,
                        Icon = "crown",
                    })
                    
                    if not obj:FindFirstChild("EyesHighlight") then
                        
                        local h = Instance.new("Highlight")
                        h.Name = "EyesHighlight"
                        h.FillColor = Color3.fromRGB(170,0,255)
                        h.FillTransparency = 0.25
                        h.OutlineColor = Color3.fromRGB(170,0,255)
                        h.OutlineTransparency = 0
                        h.Adornee = obj
                        h.Parent = obj
                        
                    end
                    
                    if not obj:FindFirstChild("EyesText") then
                        
                        local gui = Instance.new("BillboardGui")
                        gui.Name = "EyesText"
                        gui.Size = UDim2.new(0,100,0,30)
                        gui.StudsOffset = Vector3.new(0,3,0)
                        gui.AlwaysOnTop = true
                        gui.Parent = obj
                        
                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1,0,1,0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.fromRGB(170,0,255)
                        text.TextStrokeTransparency = 0
                        text.TextStrokeColor3 = Color3.new(0,0,0)
                        text.Font = Enum.Font.GothamBold
                        text.TextSize = 16
                        text.Text = "Eyes"
                        text.Parent = gui
                        
                        task.spawn(function()
                            
                            local player = game.Players.LocalPlayer
                            local char = player.Character
                            local root = char and char:FindFirstChild("HumanoidRootPart")
                            
                            while EyesDetect and obj.Parent do
                                
                                if root then
                                    
                                    local part = obj:FindFirstChildWhichIsA("BasePart")
                                    
                                    if part then
                                        local dist = (root.Position - part.Position).Magnitude
                                        text.Text = "Eyes "..math.floor(dist).."m"
                                    end
                                    
                                end
                                
                                task.wait(0.1)
                            end
                            
                        end)
                        
                    end
                    
                end
                
            end)
            
        else
            
            WindUI:Notify({
                Title = "Eyes检测",
                Content = "检测已关闭",
                Duration = 2,
                Icon = "crown",
            })
            
            if EyesConnection then
                EyesConnection:Disconnect()
                EyesConnection = nil
            end
            
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "EyesHighlight" or v.Name == "EyesText" then
                    v:Destroy()
                end
            end
            
        end
        
    end
})

local AmbushDetect = false
local AmbushConnection = nil

yuu:Toggle({
    Title = "Ambush检测",
    Value = false,
    Callback = function(v)
        AmbushDetect = v
        
        if v then
            
            WindUI:Notify({
                Title = "Ambush检测",
                Content = "检测已开启",
                Duration = 2,
                Icon = "crown",
            })
            
            AmbushConnection = workspace.ChildAdded:Connect(function(obj)
                
                if not AmbushDetect then return end
                
                if string.find(obj.Name:lower(),"ambush") then
                    
                    WindUI:Notify({
                        Title = "怪物警告",
                        Content = "Ambush 来了！",
                        Duration = 3,
                        Icon = "crown",
                    })
                    
                    if not obj:FindFirstChild("AmbushHighlight") then
                        
                        local h = Instance.new("Highlight")
                        h.Name = "AmbushHighlight"
                        h.FillColor = Color3.fromRGB(0,255,120)
                        h.FillTransparency = 0.25
                        h.OutlineColor = Color3.fromRGB(0,255,120)
                        h.OutlineTransparency = 0
                        h.Adornee = obj
                        h.Parent = obj
                        
                    end
                    
                    if not obj:FindFirstChild("AmbushText") then
                        
                        local gui = Instance.new("BillboardGui")
                        gui.Name = "AmbushText"
                        gui.Size = UDim2.new(0,100,0,30)
                        gui.StudsOffset = Vector3.new(0,3,0)
                        gui.AlwaysOnTop = true
                        gui.Parent = obj
                        
                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.new(1,0,1,0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.fromRGB(0,255,120)
                        text.TextStrokeTransparency = 0
                        text.TextStrokeColor3 = Color3.new(0,0,0)
                        text.Font = Enum.Font.GothamBold
                        text.TextSize = 16
                        text.Text = "Ambush"
                        text.Parent = gui
                        
                        task.spawn(function()
                            
                            local player = game.Players.LocalPlayer
                            local char = player.Character
                            local root = char and char:FindFirstChild("HumanoidRootPart")
                            
                            while AmbushDetect and obj.Parent do
                                
                                if root then
                                    
                                    local part = obj:FindFirstChildWhichIsA("BasePart")
                                    
                                    if part then
                                        local dist = (root.Position - part.Position).Magnitude
                                        text.Text = "Ambush "..math.floor(dist).."m"
                                    end
                                    
                                end
                                
                                task.wait(0.1)
                            end
                            
                        end)
                        
                    end
                    
                end
                
            end)
            
        else
            
            WindUI:Notify({
                Title = "Ambush检测",
                Content = "检测已关闭",
                Duration = 2,
                Icon = "crown",
            })
            
            if AmbushConnection then
                AmbushConnection:Disconnect()
                AmbushConnection = nil
            end
            
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "AmbushHighlight" or v.Name == "AmbushText" then
                    v:Destroy()
                end
            end
            
        end
        
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local ghostEspEnabled = false
local ghostAddConn
local ghostUpdateConn

xzx:Toggle({
    Title = "怪物透视",
    Value = false,
    Callback = function(v)
        ghostEspEnabled = v

        if ghostAddConn then
            ghostAddConn:Disconnect()
            ghostAddConn = nil
        end

        if ghostUpdateConn then
            ghostUpdateConn:Disconnect()
            ghostUpdateConn = nil
        end

        local function clearGhostEsp()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Highlight") and obj.Name == "GhostHighlight" then
                    obj:Destroy()
                elseif obj:IsA("BillboardGui") and obj.Name == "GhostNameTag" then
                    obj:Destroy()
                end
            end
        end

        local function getGhostRoot(ghost)
            return ghost:FindFirstChild("HumanoidRootPart")
                or ghost:FindFirstChild("Head")
                or ghost.PrimaryPart
        end

        local function getCharacterRoot()
            local char = LocalPlayer.Character
            if not char then return nil end
            return char:FindFirstChild("HumanoidRootPart")
        end

        local function addGhostEsp(ghost)
            if not ghost or not ghost.Parent then
                return
            end

            local head = ghost:FindFirstChild("Head")
            if not head then
                return
            end

            if not ghost:FindFirstChild("GhostHighlight") then
                local h = Instance.new("Highlight")
                h.Name = "GhostHighlight"
                h.FillColor = Color3.fromRGB(0, 255, 0)
                h.OutlineColor = Color3.fromRGB(0, 255, 0)
                h.FillTransparency = 0.35
                h.OutlineTransparency = 0
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Adornee = ghost
                h.Parent = ghost
            end

            if not head:FindFirstChild("GhostNameTag") then
                local bill = Instance.new("BillboardGui")
                bill.Name = "GhostNameTag"
                bill.Adornee = head
                bill.Parent = head
                bill.Size = UDim2.new(0, 120, 0, 32)
                bill.StudsOffset = Vector3.new(0, 2.2, 0)
                bill.AlwaysOnTop = true
                bill.MaxDistance = 9999

                local text = Instance.new("TextLabel")
                text.Name = "Label"
                text.Parent = bill
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = "怪物"
                text.TextColor3 = Color3.fromRGB(0, 255, 0)
                text.TextStrokeTransparency = 0
                text.TextScaled = true
                text.Font = Enum.Font.SourceSansBold
            end
        end

        local function updateGhostText()
            local myRoot = getCharacterRoot()
            if not myRoot then return end

            for _, ghost in pairs(workspace:GetDescendants()) do
                if ghost.Name == "Ghost" and ghost:IsA("Model") then
                    local root = getGhostRoot(ghost)
                    local head = ghost:FindFirstChild("Head")

                    if root and head then
                        local bill = head:FindFirstChild("GhostNameTag")
                        if bill and bill:FindFirstChild("Label") then
                            local dist = (myRoot.Position - root.Position).Magnitude
                            bill.Label.Text = "怪物 [" .. math.floor(dist) .. "m]"
                        end
                    end
                end
            end
        end

        if v then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Ghost" and obj:IsA("Model") then
                    addGhostEsp(obj)
                end
            end

            ghostAddConn = workspace.DescendantAdded:Connect(function(obj)
                if ghostEspEnabled and obj.Name == "Ghost" and obj:IsA("Model") then
                    task.wait(0.1)
                    addGhostEsp(obj)
                end
            end)

            ghostUpdateConn = RunService.RenderStepped:Connect(function()
                updateGhostText()
            end)
        else
            clearGhostEsp()
        end
    end
})

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local speedValue = 32
local defaultSpeed = 16

local speedOn = false
local speedCharConn
local speedPropConn

local function clearSpeedConns()
    if speedCharConn then
        speedCharConn:Disconnect()
        speedCharConn = nil
    end
    if speedPropConn then
        speedPropConn:Disconnect()
        speedPropConn = nil
    end
end

local function applySpeed()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    hum.WalkSpeed = speedValue

    if speedPropConn then
        speedPropConn:Disconnect()
        speedPropConn = nil
    end

    speedPropConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if speedOn and hum and hum.Parent and hum.WalkSpeed ~= speedValue then
            hum.WalkSpeed = speedValue
        end
    end)
end

xzx:Toggle({
    Title = "固定加速",
    Value = false,
    Callback = function()
        speedOn = not speedOn
        clearSpeedConns()

        if speedOn then
            applySpeed()

            speedCharConn = player.CharacterAdded:Connect(function()
                task.wait(0.5)
                if speedOn then
                    applySpeed()
                end
            end)
        else
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = defaultSpeed
            end
        end
    end
})

local GhostESP = false
local GhostCache = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function isGhost(obj)
    if obj.Name == "GhostModel" then
        return true
    end

    if obj.Name == "Ghost" then
        return true
    end

    if obj:FindFirstChild("OriginalGhostName") then
        return true
    end

    return false
end

local function getAdornee(obj)
    if obj:IsA("Model") then
        return obj:FindFirstChild("HumanoidRootPart")
            or obj:FindFirstChild("Head")
            or obj:FindFirstChildWhichIsA("BasePart")
    elseif obj:IsA("BasePart") then
        return obj
    end
end

local function addGhostESP(obj)
    if GhostCache[obj] then return end

    local part = getAdornee(obj)
    if not part then return end

    local h = Instance.new("Highlight")
    h.Name = "GhostHighlight"
    h.FillColor = Color3.fromRGB(0, 255, 0)
    h.OutlineColor = Color3.fromRGB(0, 255, 0)
    h.FillTransparency = 0.45
    h.OutlineTransparency = 0
    h.Adornee = obj
    h.Parent = obj

    local gui = Instance.new("BillboardGui")
    gui.Name = "GhostText"
    gui.Adornee = part
    gui.Size = UDim2.fromOffset(150, 35)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.AlwaysOnTop = true
    gui.Parent = obj

    local text = Instance.new("TextLabel")
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(0, 255, 0)
    text.TextStrokeTransparency = 0.35
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.Text = "幽灵 [距离: ?米]"
    text.Parent = gui

    GhostCache[obj] = {
        Highlight = h,
        Gui = gui,
        Text = text,
        Part = part
    }
end

local function clearGhostESP()
    for obj, data in pairs(GhostCache) do
        if data.Highlight then data.Highlight:Destroy() end
        if data.Gui then data.Gui:Destroy() end
        GhostCache[obj] = nil
    end
end

awa:Toggle({
    Title = "怪物透视",
    Value = false,
    Callback = function(v)
        GhostESP = v

        if v then
            task.spawn(function()
                while GhostESP do
                    local root = getRoot()

                    for _, obj in pairs(workspace:GetDescendants()) do
                        if isGhost(obj) then
                            addGhostESP(obj)
                        end
                    end

                    for obj, data in pairs(GhostCache) do
                        if not obj or not obj.Parent then
                            GhostCache[obj] = nil
                        else
                            local part = data.Part
                            if root and part and part.Parent then
                                local dis = math.floor((root.Position - part.Position).Magnitude)
                                data.Text.Text = "幽灵 [距离: " .. dis .. "米]"
                            end
                        end
                    end

                    task.wait(0.3)
                end

                clearGhostESP()
            end)
        else
            clearGhostESP()
        end
    end
})

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local speedValue = 32
local defaultSpeed = 16

local speedOn = false
local speedCharConn
local speedPropConn

local function clearSpeedConns()
    if speedCharConn then
        speedCharConn:Disconnect()
        speedCharConn = nil
    end
    if speedPropConn then
        speedPropConn:Disconnect()
        speedPropConn = nil
    end
end

local function applySpeed()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    hum.WalkSpeed = speedValue

    if speedPropConn then
        speedPropConn:Disconnect()
        speedPropConn = nil
    end

    speedPropConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if speedOn and hum and hum.Parent and hum.WalkSpeed ~= speedValue then
            hum.WalkSpeed = speedValue
        end
    end)
end

awa:Toggle({
    Title = "固定加速",
    Value = false,
    Callback = function()
        speedOn = not speedOn
        clearSpeedConns()

        if speedOn then
            applySpeed()

            speedCharConn = player.CharacterAdded:Connect(function()
                task.wait(0.5)
                if speedOn then
                    applySpeed()
                end
            end)
        else
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = defaultSpeed
            end
        end
    end
})

vb:Toggle({
    Title = "自动攻击附近玩家-Auto Attack",
    Value = false,
    Callback = function(state)
        autoAttackEnabled = state
    end
})

local J = {
    F = false,
    E = 1,
    B = false
}

local C = {
    RT = false,
    C = false,
    S = nil
}

c:Section({
    Title = "本地/区域",
    Box = true,
    Opened = true,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local targetSpeed = 16
local currentSpeed = 16

RunService.RenderStepped:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then
        currentSpeed = currentSpeed + (targetSpeed - currentSpeed) * 0.15
        hum.WalkSpeed = currentSpeed
    end
end)

c:Slider({
    Title = "速度",
    Desc = "滑动调整移动速度",
    Step = 1,
    Value = { Min = 16, Max = 700, Default = 16 },
    Callback = function(v)
        targetSpeed = v
        c:SetInput("速度输入", tostring(v))
    end
})

c:Input({
    Title = "速度输入",
    Desc = "输入移动速度数值",
    Placeholder = "16 - 700",
    Default = "16",
    Callback = function(v)
        local num = tonumber(v)
        if num then
            num = math.clamp(num, 16, 700)
            targetSpeed = num
            c:SetSlider("速度", num)
        end
    end
})

local player = game:GetService("Players").LocalPlayer

c:Slider({
    Title = "跳跃高度",
    Desc = "滑动调整跳跃高度",
    Step = 1,
    Value = { Min = 50, Max = 400, Default = 50 },
    Callback = function(v)
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            hum.JumpPower = v
        end
        c:SetInput("跳跃输入", tostring(v))
    end
})

c:Input({
    Title = "跳跃输入",
    Desc = "输入跳跃高度",
    Placeholder = "50 - 400",
    Default = "50",
    Callback = function(v)
        local num = tonumber(v)
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")

        if num and hum then
            num = math.clamp(num, 50, 400)
            hum.JumpPower = num
            c:SetSlider("跳跃高度", num)
        end
    end
})

local Players = game:GetService("Players")

c:Toggle({
    Title = "无限跳跃",
    Desc = "按空格键无限跳跃",
    Value = false,
    Callback = function(state)

        if state then

            WindUI:Notify({
                Title = "无限跳跃",
                Content = "无限跳跃已开启",
                Duration = 2,
                Icon = "crown",
            })

            if _G.JumpConnection then
                _G.JumpConnection:Disconnect()
            end
            
            _G.JumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                pcall(function()

                    local char = Players.LocalPlayer.Character

                    if char then
                        local humanoid = char:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end

                end)
            end)

        else

            WindUI:Notify({
                Title = "无限跳跃",
                Content = "无限跳跃已关闭",
                Duration = 2,
                Icon = "crown",
            })

            if _G.JumpConnection then
                _G.JumpConnection:Disconnect()
                _G.JumpConnection = nil
            end

        end
    end
})

local Players = game:GetService("Players")

c:Toggle({
    Title = "穿墙模式",
    Desc = "可以穿过墙壁和物体",
    Value = false,
    Callback = function(state)

        if state then

            WindUI:Notify({
                Title = "穿墙模式",
                Content = "穿墙模式已开启",
                Duration = 2,
                Icon = "crown",
            })

            _G.NoClipEnabled = true
            
            if _G.NoClipLoop then
                _G.NoClipLoop:Disconnect()
            end

            _G.NoClipLoop = game:GetService("RunService").Stepped:Connect(function()

                if _G.NoClipEnabled and Players.LocalPlayer.Character then

                    for _,part in pairs(Players.LocalPlayer.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end

                end

            end)

        else

            WindUI:Notify({
                Title = "穿墙模式",
                Content = "穿墙模式已关闭",
                Duration = 2,
                Icon = "crown",
            })

            _G.NoClipEnabled = false

            if _G.NoClipLoop then
                _G.NoClipLoop:Disconnect()
                _G.NoClipLoop = nil
            end
            
            local char = Players.LocalPlayer.Character
            
            if char then
                for _,part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end

        end
    end
})

c:Toggle({
    Title = "无敌模式",
    Value = false,
    Callback = function(state)
        if state then
            pcall(function()
                local speaker = Players.LocalPlayer
                local Char = speaker.Character
                
                if Char then
                    local Human = Char:FindFirstChildWhichIsA("Humanoid")
                    if Human then
                        Human.MaxHealth = math.huge
                        Human.Health = math.huge
                        Human:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        Human.BreakJointsOnDeath = false
                    end
                end
            end)
        else
            pcall(function()
                local Char = Players.LocalPlayer.Character
                if Char then
                    local Human = Char:FindFirstChildWhichIsA("Humanoid")
                    if Human then
                        Human.MaxHealth = 100
                        Human.Health = 100
                        Human:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                        Human.BreakJointsOnDeath = true
                    end
                end
            end)
        end
    end
})

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local nightBrightConn
local oldBrightness
local oldAmbient
local oldOutdoorAmbient
local oldExposureCompensation

c:Toggle({
    Title = "提亮",
    Value = false,
    Callback = function()
        _G.NightBrightEnabled = not _G.NightBrightEnabled

        if _G.NightBrightEnabled then
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
                local isNight = (time >= 18 or time <= 6)

                if isNight then
                    Lighting.Brightness = 4
                    Lighting.Ambient = Color3.fromRGB(140, 140, 140)
                    Lighting.OutdoorAmbient = Color3.fromRGB(160, 160, 160)
                    Lighting.ExposureCompensation = 0.8
                else
                    Lighting.Brightness = oldBrightness
                    Lighting.Ambient = oldAmbient
                    Lighting.OutdoorAmbient = oldOutdoorAmbient
                    Lighting.ExposureCompensation = oldExposureCompensation
                end
            end)
        else
            if nightBrightConn then
                nightBrightConn:Disconnect()
                nightBrightConn = nil
            end

            if oldBrightness then Lighting.Brightness = oldBrightness end
            if oldAmbient then Lighting.Ambient = oldAmbient end
            if oldOutdoorAmbient then Lighting.OutdoorAmbient = oldOutdoorAmbient end
            if oldExposureCompensation then Lighting.ExposureCompensation = oldExposureCompensation end
        end
    end
})

b:Section({
    Title = "娱乐/区域",
    Box = true,
    Opened = true,
})

_G.flrun = false

b:Toggle({
    Title = "甩飞所有人",
    Value = false,
    Callback = function(on)
        _G.flrun = on
        if not on then return end
        
        local lp = Players.LocalPlayer
        local lc = lp.Character
        local lh = lc and lc:FindFirstChildOfClass("Humanoid")
        local lr = lh and lh.RootPart
        if not lc or not lh or not lr then return end
        
        local oldPos = lr.Position
        local ray = Ray.new(oldPos + Vector3.new(0, 3, 0), Vector3.new(0, -200, 0))
        local hit, pos = workspace:FindPartOnRay(ray, lc)
        local safePos = hit and pos or oldPos
        
        lh:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        local ag = 0
        while _G.flrun do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp and p.Character and _G.flrun then
                    local tc = p.Character
                    local th = tc:FindFirstChildOfClass("Humanoid")
                    local tr = th and th.RootPart
                    local hd = tc:FindFirstChild("Head")
                    local bp = tr or hd
                    
                    if bp then
                        ag = ag + 50
                        local bv = Instance.new("BodyVelocity", lr)
                        bv.MaxForce = Vector3.new(1/0, 1/0, 1/0)
                        bv.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                        lr.CFrame = CFrame.new(bp.Position) * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(ag), 0, 0)
                        task.wait()
                        bv:Destroy()
                    end
                end
            end
            task.wait()
        end
        
        lh:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = lh
        lr.CFrame = CFrame.new(safePos + Vector3.new(0, 3, 0))
        lh:ChangeState("GettingUp")
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local speed = 999
local spinning = false
local spinConnection

b:Toggle({
    Title = "无限旋转",
    Desc = "让本地玩家持续旋转",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)

        spinning = state

        if spinning then

            WindUI:Notify({
                Title = "无限旋转",
                Content = "旋转模式已开启",
                Duration = 2,
                Icon = "crown",
            })

            if spinConnection then
                spinConnection:Disconnect()
            end

            spinConnection = RunService.RenderStepped:Connect(function()

                local char = player.Character

                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(speed), 0)
                end

            end)

        else

            WindUI:Notify({
                Title = "无限旋转",
                Content = "旋转模式已关闭",
                Duration = 2,
                Icon = "crown",
            })

            if spinConnection then
                spinConnection:Disconnect()
                spinConnection = nil
            end

        end
    end
})

n:Section({
    Title = "飞行/区域",
    Box = true,
    Opened = true,
})

local sp = 5

n:Input({
    Title = "飞行速度",
    Desc = "输入速度",
    Value = "5",
    Placeholder = "输入数字",
    Callback = function(x)
        sp = tonumber(x) or 5
    end
})

n:Toggle({
    Title = "飞行",
    Value = false,
    Callback = function(en)
        _G.flyon = en
        local pl = Players.LocalPlayer
        local ch = pl.Character
        if not ch then return end
        
        local hu = ch:FindFirstChildOfClass("Humanoid")
        local to = ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso")
        if not hu or not to then return end
        
        if en then
            for i = 1, sp do
                spawn(function()
                    _G.flyhb = game:GetService("RunService").Heartbeat
                    _G.flyrun = true
                    while _G.flyrun and _G.flyhb:Wait() and ch and hu and hu.Parent do
                        if hu.MoveDirection.Magnitude > 0 then
                            ch:TranslateBy(hu.MoveDirection)
                        end
                    end
                end)
            end
            
            ch.Animate.Disabled = true
            for _, v in pairs(hu:GetPlayingAnimationTracks()) do
                v:AdjustSpeed(0)
            end
            
            hu:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.Running, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
            hu:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
            hu:ChangeState(Enum.HumanoidStateType.Swimming)
            
            local bg = Instance.new("BodyGyro", to)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.Name = "FlyGyro"
            
            local bv = Instance.new("BodyVelocity", to)
            bv.velocity = Vector3.new(0, 0.1, 0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Name = "FlyVelocity"
            
            local ctrl = {f = 0, b = 0, l = 0, r = 0}
            local lastctrl = {f = 0, b = 0, l = 0, r = 0}
            local maxspeed = 50
            local speed = 0
            
            _G.flyloop = game:GetService("RunService").RenderStepped:Connect(function()
                if not _G.flyon then return end
                
                local ui = game:GetService("UserInputService")
                ctrl.f = 0
                ctrl.b = 0
                ctrl.l = 0
                ctrl.r = 0
                if ui:IsKeyDown(Enum.KeyCode.W) then ctrl.f = 1 end
                if ui:IsKeyDown(Enum.KeyCode.S) then ctrl.b = -1 end
                if ui:IsKeyDown(Enum.KeyCode.A) then ctrl.l = -1 end
                if ui:IsKeyDown(Enum.KeyCode.D) then ctrl.r = 1 end
                
                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    speed = speed + 0.5 + (speed / maxspeed)
                    if speed > maxspeed then speed = maxspeed end
                elseif speed ~= 0 then
                    speed = speed - 1
                    if speed < 0 then speed = 0 end
                end
                
                local ca = workspace.CurrentCamera
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.velocity = ((ca.CFrame.lookVector * (ctrl.f + ctrl.b)) + ((ca.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - ca.CFrame.p)) * speed
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif speed ~= 0 then
                    bv.velocity = ((ca.CFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((ca.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - ca.CFrame.p)) * speed
                else
                    bv.velocity = Vector3.new(0, 0, 0)
                end
                
                bg.cframe = ca.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
            end)
            
        else
            _G.flyrun = false
            if _G.flyloop then _G.flyloop:Disconnect() end
            
            local bg = to:FindFirstChild("FlyGyro")
            local bv = to:FindFirstChild("FlyVelocity")
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
            
            hu:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
            hu:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            hu:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            
            ch.Animate.Disabled = false
        end
    end
})

n:Button({
    Title = "飞行v3",
     Desc = "传统飞行",
    Callback = function()
    loadstring(game:HttpGet'https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt')()
end
})

m:Section({
    Title = "gui/区域",
    Box = true,
    Opened = true,
})

local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local function makeGui(name, w, h, x, y)
    local gui = Instance.new("ScreenGui")
    gui.Name = name
    gui.ResetOnSpawn = false
    gui.Parent = Players.LocalPlayer.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, w, 0, h + 18)
    frame.Position = UDim2.new(0, x, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 18)
    bar.Position = UDim2.new(0, 0, 0, 0)
    bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    bar.BorderSizePixel = 0
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, h)
    label.Position = UDim2.new(0, 6, 0, 18)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local dragging, dragStart, startPos = false, nil, nil
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and frame and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    return gui, label
end

local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local function makeGui(name, w, h, x, y)
    local gui = Instance.new("ScreenGui")
    gui.Name = name
    gui.ResetOnSpawn = false
    gui.Parent = Players.LocalPlayer.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, w + 16, 0, h)
    frame.Position = UDim2.new(0, x, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, w, 1, 0)
    label.Position = UDim2.new(0, 6, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 10, 1, 0)
    bar.Position = UDim2.new(1, -10, 0, 0)
    bar.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    bar.BackgroundTransparency = 0.1
    bar.BorderSizePixel = 0
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 6)

    local dragging, dragStart, startPos = false, nil, nil
    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and frame and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    return gui, label
end

m:Toggle({
    Title = "显示FPS",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        if v then
            local g, t = makeGui("FPS", 130, 28, 10, 10)
            _G.f = g
            local l = 0
            _G.c = RunService.RenderStepped:Connect(function(d)
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

m:Toggle({
    Title = "网络检测",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        if v then
            local g, t = makeGui("Ping", 150, 28, 10, 46)
            _G.p = g
            t.Text = "延迟: ..."
            local l = 0
            _G.pc = RunService.RenderStepped:Connect(function(d)
                l = l + d
                if l >= 0.5 then
                    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                    t.Text = "延迟: " .. math.floor(ping) .. "ms"
                    l = 0
                end
            end)
        else
            if _G.p then _G.p:Destroy() _G.p = nil end
            if _G.pc then _G.pc:Disconnect() _G.pc = nil end
        end
    end
})

m:Toggle({
    Title = "玩家通知",
    Type = "Checkbox",
    Value = false,
    Callback = function(b)
        _G.nt = b
        local function s(title, msg)
            local g = Instance.new("ScreenGui", game:GetService("CoreGui"))
            local f = Instance.new("Frame", g)
            local t1 = Instance.new("TextLabel", f)
            local t2 = Instance.new("TextLabel", f)
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
            f.Size = UDim2.new(0, 200, 0, 60)
            f.Position = UDim2.new(0, 20, 1, -80)
            f.BackgroundColor3 = Color3.new(0, 0, 0)
            f.BackgroundTransparency = 0.3
            f.BorderSizePixel = 0
            t1.Size = UDim2.new(1, -10, 0, 20)
            t1.Position = UDim2.new(0, 5, 0, 5)
            t1.Text = title
            t1.TextColor3 = Color3.new(1, 1, 1)
            t1.BackgroundTransparency = 1
            t2.Size = UDim2.new(1, -10, 0, 30)
            t2.Position = UDim2.new(0, 5, 0, 25)
            t2.Text = msg
            t2.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            t2.BackgroundTransparency = 1
            task.delay(3, function() g:Destroy() end)
        end
        if _G.nt then
            _G.c1 = Players.PlayerAdded:Connect(function(p)
                if _G.nt then s("加入", p.Name) end
            end)
            _G.c2 = Players.PlayerRemoving:Connect(function(p)
                if _G.nt then s("离开", p.Name) end
            end)
            s("通知查看", "已开启")
        else
            if _G.c1 then _G.c1:Disconnect() end
            if _G.c2 then _G.c2:Disconnect() end
        end
    end
})

m:Toggle({
    Title = "服务器人数",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        if v then
            local g, t = makeGui("PlayerCount", 150, 28, 10, 118)
            _G.plGui = g
            local l = 0
            _G.plConn = RunService.RenderStepped:Connect(function(d)
                l = l + d
                if l >= 1 then
                    t.Text = "人数: " .. #Players:GetPlayers()
                    l = 0
                end
            end)
        else
            if _G.plGui then _G.plGui:Destroy() _G.plGui = nil end
            if _G.plConn then _G.plConn:Disconnect() _G.plConn = nil end
        end
    end
})

m:Toggle({
    Title = "移动速度",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        if v then
            local g, t = makeGui("SpeedDisplay", 150, 28, 10, 154)
            _G.spGui = g
            _G.spConn = RunService.RenderStepped:Connect(function()
                local char = Players.LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    t.Text = "速度: " .. math.floor(hrp.AssemblyLinearVelocity.Magnitude)
                end
            end)
        else
            if _G.spGui then _G.spGui:Destroy() _G.spGui = nil end
            if _G.spConn then _G.spConn:Disconnect() _G.spConn = nil end
        end
    end
})

m:Toggle({
    Title = "内存占用",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        if v then
            local g, t = makeGui("MemDisplay", 170, 28, 10, 190)
            _G.mmGui = g
            local l = 0
            _G.mmConn = RunService.RenderStepped:Connect(function(d)
                l = l + d
                if l >= 1 then
                    t.Text = "内存: " .. math.floor(Stats:GetTotalMemoryUsageMb()) .. "MB"
                    l = 0
                end
            end)
        else
            if _G.mmGui then _G.mmGui:Destroy() _G.mmGui = nil end
            if _G.mmConn then _G.mmConn:Disconnect() _G.mmConn = nil end
        end
    end
})

m:Toggle({
    Title = "在线时长",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        if v then
            local st = tick()
            local g, t = makeGui("Uptime", 170, 28, 10, 226)
            _G.utGui = g
            _G.utConn = RunService.RenderStepped:Connect(function()
                local e = math.floor(tick() - st)
                t.Text = string.format("时长: %02d:%02d", math.floor(e / 60), e % 60)
            end)
        else
            if _G.utGui then _G.utGui:Destroy() _G.utGui = nil end
            if _G.utConn then _G.utConn:Disconnect() _G.utConn = nil end
        end
    end
})

m:Toggle({
    Title = "角色生命",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        if v then
            local g, t = makeGui("HPDisplay", 190, 28, 10, 262)
            _G.hpGui = g
            _G.hpConn = RunService.RenderStepped:Connect(function()
                local char = Players.LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    t.Text = string.format("HP: %d / %d", math.floor(hum.Health), math.floor(hum.MaxHealth))
                end
            end)
        else
            if _G.hpGui then _G.hpGui:Destroy() _G.hpGui = nil end
            if _G.hpConn then _G.hpConn:Disconnect() _G.hpConn = nil end
        end
    end
})

m:Toggle({
    Title = "重力显示",
    Type = "Checkbox",
    Value = false,
    Callback = function(v)
        if v then
            local g, t = makeGui("GravityDisplay", 170, 28, 10, 298)
            _G.gvGui = g
            local l = 0
            _G.gvConn = RunService.RenderStepped:Connect(function(d)
                l = l + d
                if l >= 0.5 then
                    t.Text = "重力: " .. workspace.Gravity
                    l = 0
                end
            end)
        else
            if _G.gvGui then _G.gvGui:Destroy() _G.gvGui = nil end
            if _G.gvConn then _G.gvConn:Disconnect() _G.gvConn = nil end
        end
    end
})

p:Section({
    Title = "ESP/区域",
    Box = true,
    Opened = true,
})

_G.EspEnabled = false

local espDrawings = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function createEsp(player)
    if player == Players.LocalPlayer then return end
    if espDrawings[player] then return end

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
    esp.box.Color = Color3.fromRGB(255,255,255)
    esp.box.Visible = false

    esp.name.Size = 13
    esp.name.Center = true
    esp.name.Outline = true
    esp.name.Color = Color3.fromRGB(255,255,255)
    esp.name.Visible = false

    esp.health.Size = 13
    esp.health.Center = true
    esp.health.Outline = true
    esp.health.Color = Color3.fromRGB(0,255,0)
    esp.health.Visible = false

    esp.distance.Size = 13
    esp.distance.Center = true
    esp.distance.Outline = true
    esp.distance.Color = Color3.fromRGB(200,200,200)
    esp.distance.Visible = false

    esp.healthBar.Thickness = 2
    esp.healthBar.Color = Color3.fromRGB(0,255,0)
    esp.healthBar.Visible = false

    esp.healthBarBg.Thickness = 2
    esp.healthBarBg.Color = Color3.fromRGB(0,0,0)
    esp.healthBarBg.Visible = false

    esp.tracer.Thickness = 1
    esp.tracer.Color = Color3.fromRGB(255,255,255)
    esp.tracer.Transparency = 1
    esp.tracer.Visible = false

    espDrawings[player] = esp
end

local function removeEsp(player)
    if espDrawings[player] then
        for _, drawing in pairs(espDrawings[player]) do
            drawing:Remove()
        end
        espDrawings[player] = nil
    end
end

local function hideEsp(esp)
    for _, drawing in pairs(esp) do
        drawing.Visible = false
    end
end

local function updateEsp()
    local camera = workspace.CurrentCamera
    local lp = Players.LocalPlayer
    local lchr = lp.Character
    local lhrp = lchr and lchr:FindFirstChild("HumanoidRootPart")

    for player, esp in pairs(espDrawings) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if hrp and head and hum and hum.Health > 0 and _G.EspEnabled then
            local hrpPos, onScreen = camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                local legPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))

                local height = math.abs(headPos.Y - legPos.Y)
                local width = height * 0.6
                local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)

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

                esp.healthBar.From = Vector2.new(hrpPos.X - width / 2 - 5, headPos.Y)
                esp.healthBar.To = Vector2.new(hrpPos.X - width / 2 - 5, headPos.Y + (legPos.Y - headPos.Y) * (1 - healthPercent))
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

for _, player in pairs(Players:GetPlayers()) do
    createEsp(player)
end

Players.PlayerAdded:Connect(createEsp)
Players.PlayerRemoving:Connect(removeEsp)

p:Toggle({
    Title = "透视",
    Value = false,
    Callback = function(state)
        _G.EspEnabled = state

        if state then
            WindUI:Notify({
                Title = "玩家透视",
                Content = "透视已开启",
                Duration = 2,
                Icon = "crown",
            })

            if not _G.espLoop then
                _G.espLoop = RunService.RenderStepped:Connect(updateEsp)
            end
        else
            WindUI:Notify({
                Title = "玩家透视",
                Content = "透视已关闭",
                Duration = 2,
                Icon = "crown",
            })

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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Boxes = {}
local BoxColor = Color3.fromRGB(255, 255, 255)
local BoxEnabled = false
local EspLoop = nil

local function setBoxColor(color)
    BoxColor = color

    for _, box in pairs(Boxes) do
        box.Color = BoxColor
    end
end

local function createBox(player)
    if player == LocalPlayer then return end
    if Boxes[player] then return end

    local box = Drawing.new("Square")
    box.Color = BoxColor
    box.Thickness = 1
    box.Filled = false
    box.Visible = false

    Boxes[player] = box
end

local function removeBox(player)
    if Boxes[player] then
        Boxes[player]:Remove()
        Boxes[player] = nil
    end
end

local function hideAllBoxes()
    for _, box in pairs(Boxes) do
        box.Visible = false
    end
end

local function updateBoxes()
    if not BoxEnabled then
        hideAllBoxes()
        return
    end

    Camera = workspace.CurrentCamera
    if not Camera then return end

    for player, box in pairs(Boxes) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not char or not hrp or not head or not hum or hum.Health <= 0 then
            box.Visible = false
            continue
        end

        local rootPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

        if onScreen then
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

            local height = math.abs(headPos.Y - legPos.Y)
            local width = height * 0.6

            box.Color = BoxColor
            box.Size = Vector2.new(width, height)
            box.Position = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2)
            box.Visible = true
        else
            box.Visible = false
        end
    end
end

local function enableBox(color)
    BoxEnabled = true

    if color then
        setBoxColor(color)
    end

    for _, player in ipairs(Players:GetPlayers()) do
        createBox(player)
    end

    if not EspLoop then
        EspLoop = RunService.RenderStepped:Connect(updateBoxes)
    end
end

local function disableBox()
    BoxEnabled = false
    hideAllBoxes()
end

Players.PlayerAdded:Connect(function(player)
    if BoxEnabled then
        createBox(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeBox(player)
end)

p:Dropdown({
    Title = "方框设置",
    Values = {
        {
            Title = "开启",
            Desc = "开启玩家方框",
            Callback = function()
                enableBox(BoxColor)
            end,
        },
        {
            Title = "关闭",
            Desc = "关闭玩家方框",
            Callback = function()
                disableBox()
            end,
        },
        {
            Title = "白色",
            Desc = "切换为白色方框",
            Callback = function()
                enableBox(Color3.fromRGB(255, 255, 255))
            end,
        },
        {
            Title = "红色",
            Desc = "切换为红色方框",
            Callback = function()
                enableBox(Color3.fromRGB(255, 0, 0))
            end,
        },
        {
            Title = "绿色",
            Desc = "切换为绿色方框",
            Callback = function()
                enableBox(Color3.fromRGB(0, 255, 0))
            end,
        },
        {
            Title = "蓝色",
            Desc = "切换为蓝色方框",
            Callback = function()
                enableBox(Color3.fromRGB(0, 120, 255))
            end,
        },
        {
            Title = "黄色",
            Desc = "切换为黄色方框",
            Callback = function()
                enableBox(Color3.fromRGB(255, 255, 0))
            end,
        },
        {
            Title = "紫色",
            Desc = "切换为紫色方框",
            Callback = function()
                enableBox(Color3.fromRGB(180, 0, 255))
            end,
        },
        {
            Title = "青色",
            Desc = "切换为青色方框",
            Callback = function()
                enableBox(Color3.fromRGB(0, 255, 255))
            end,
        },
        {
            Title = "粉色",
            Desc = "切换为粉色方框",
            Callback = function()
                enableBox(Color3.fromRGB(255, 80, 180))
            end,
        },
        {
            Title = "橙色",
            Desc = "切换为橙色方框",
            Callback = function()
                enableBox(Color3.fromRGB(255, 140, 0))
            end,
        },
    }
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Lines = {}
local LineColor = Color3.fromRGB(255, 255, 255)
local LineEnabled = false
local EspLoop = nil

local function setLineColor(color)
    LineColor = color
    for _, line in pairs(Lines) do
        line.Color = LineColor
    end
end

local function createLine(player)
    if player == LocalPlayer then return end
    if Lines[player] then return end

    local line = Drawing.new("Line")
    line.Color = LineColor
    line.Thickness = 1
    line.Visible = false

    Lines[player] = line
end

local function removeLine(player)
    if Lines[player] then
        Lines[player]:Remove()
        Lines[player] = nil
    end
end

local function hideAllLines()
    for _, line in pairs(Lines) do
        line.Visible = false
    end
end

local function updateLines()
    if not LineEnabled then
        hideAllLines()
        return
    end

    Camera = workspace.CurrentCamera
    if not Camera then return end

    local viewportSize = Camera.ViewportSize
    local screenBottom = Vector2.new(viewportSize.X / 2, viewportSize.Y)

    for player, line in pairs(Lines) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not char or not hrp or not hum or hum.Health <= 0 then
            line.Visible = false
            continue
        end

        local rootPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

        if onScreen then
            local targetPos = Vector2.new(rootPos.X, rootPos.Y)
            line.Color = LineColor
            line.From = screenBottom
            line.To = targetPos
            line.Visible = true
        else
            line.Visible = false
        end
    end
end

local function enableLine(color)
    LineEnabled = true

    if color then
        setLineColor(color)
    end

    for _, player in ipairs(Players:GetPlayers()) do
        createLine(player)
    end

    if not EspLoop then
        EspLoop = RunService.RenderStepped:Connect(updateLines)
    end
end

local function disableLine()
    LineEnabled = false
    hideAllLines()
end

Players.PlayerAdded:Connect(function(player)
    if LineEnabled then
        createLine(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeLine(player)
end)

p:Dropdown({
    Title = "线条ESP设置",
    Values = {
        {
            Title = "开启",
            Desc = "开启线条ESP",
            Callback = function()
                enableLine(LineColor)
            end,
        },
        {
            Title = "关闭",
            Desc = "关闭线条ESP",
            Callback = function()
                disableLine()
            end,
        },
        {
            Title = "白色",
            Desc = "切换为白色线条",
            Callback = function()
                enableLine(Color3.fromRGB(255, 255, 255))
            end,
        },
        {
            Title = "红色",
            Desc = "切换为红色线条",
            Callback = function()
                enableLine(Color3.fromRGB(255, 0, 0))
            end,
        },
        {
            Title = "绿色",
            Desc = "切换为绿色线条",
            Callback = function()
                enableLine(Color3.fromRGB(0, 255, 0))
            end,
        },
        {
            Title = "蓝色",
            Desc = "切换为蓝色线条",
            Callback = function()
                enableLine(Color3.fromRGB(0, 120, 255))
            end,
        },
        {
            Title = "黄色",
            Desc = "切换为黄色线条",
            Callback = function()
                enableLine(Color3.fromRGB(255, 255, 0))
            end,
        },
        {
            Title = "紫色",
            Desc = "切换为紫色线条",
            Callback = function()
                enableLine(Color3.fromRGB(180, 0, 255))
            end,
        },
        {
            Title = "青色",
            Desc = "切换为青色线条",
            Callback = function()
                enableLine(Color3.fromRGB(0, 255, 255))
            end,
        },
        {
            Title = "粉色",
            Desc = "切换为粉色线条",
            Callback = function()
                enableLine(Color3.fromRGB(255, 80, 180))
            end,
        },
        {
            Title = "橙色",
            Desc = "切换为橙色线条",
            Callback = function()
                enableLine(Color3.fromRGB(255, 140, 0))
            end,
        },
    }
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local HealthBars = {}
local HealthEnabled = false
local EspLoop = nil

local function createHealthBar(player)
    if player == LocalPlayer then return end
    if HealthBars[player] then return end

    local bar = {
        bg = Drawing.new("Square"),
        fill = Drawing.new("Square"),
        outline = Drawing.new("Square"),
        hpText = Drawing.new("Text"),
        nameText = Drawing.new("Text"),
    }

    bar.bg.Filled = true
    bar.bg.Color = Color3.fromRGB(0, 0, 0)
    bar.bg.Transparency = 0.5
    bar.bg.Visible = false

    bar.outline.Filled = false
    bar.outline.Color = Color3.fromRGB(255, 255, 255)
    bar.outline.Thickness = 1
    bar.outline.Transparency = 0.4
    bar.outline.Visible = false

    bar.fill.Filled = true
    bar.fill.Color = Color3.fromRGB(0, 255, 0)
    bar.fill.Visible = false

    bar.hpText.Size = 11
    bar.hpText.Center = true
    bar.hpText.Outline = true
    bar.hpText.Color = Color3.fromRGB(255, 255, 255)
    bar.hpText.Visible = false

    bar.nameText.Size = 11
    bar.nameText.Center = true
    bar.nameText.Outline = true
    bar.nameText.Color = Color3.fromRGB(255, 255, 255)
    bar.nameText.Visible = false

    HealthBars[player] = bar
end

local function removeHealthBar(player)
    if HealthBars[player] then
        for _, drawing in pairs(HealthBars[player]) do
            drawing:Remove()
        end
        HealthBars[player] = nil
    end
end

local function hideAllBars()
    for _, bar in pairs(HealthBars) do
        for _, drawing in pairs(bar) do
            drawing.Visible = false
        end
    end
end

local function lerpColor(percent)
    local r, g
    if percent > 0.5 then
        r = (1 - percent) * 2 * 255
        g = 255
    else
        r = 255
        g = percent * 2 * 255
    end
    return Color3.fromRGB(math.floor(r), math.floor(g), 0)
end

local function updateHealthBars()
    if not HealthEnabled then
        hideAllBars()
        return
    end

    Camera = workspace.CurrentCamera
    if not Camera then return end

    for player, bar in pairs(HealthBars) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not char or not hrp or not head or not hum or hum.Health <= 0 then
            for _, drawing in pairs(bar) do
                drawing.Visible = false
            end
            continue
        end

        local rootPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

        if onScreen then
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

            local height = math.abs(headPos.Y - legPos.Y)
            local width = height * 0.6
            local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local barWidth = 3
            local barOffsetX = rootPos.X - width / 2 - barWidth - 3
            local barTopY = headPos.Y
            local barHeight = legPos.Y - headPos.Y

            local bgColor = lerpColor(healthPercent)

            bar.bg.Size = Vector2.new(barWidth, barHeight)
            bar.bg.Position = Vector2.new(barOffsetX, barTopY)
            bar.bg.Color = Color3.fromRGB(0, 0, 0)
            bar.bg.Transparency = 0.5
            bar.bg.Visible = true

            bar.outline.Size = Vector2.new(barWidth, barHeight)
            bar.outline.Position = Vector2.new(barOffsetX, barTopY)
            bar.outline.Color = Color3.fromRGB(200, 200, 200)
            bar.outline.Transparency = 0.3
            bar.outline.Visible = true

            local fillHeight = barHeight * healthPercent
            local fillY = barTopY + barHeight - fillHeight

            bar.fill.Size = Vector2.new(barWidth, fillHeight)
            bar.fill.Position = Vector2.new(barOffsetX, fillY)
            bar.fill.Color = bgColor
            bar.fill.Visible = true

            bar.hpText.Text = tostring(math.floor(hum.Health))
            bar.hpText.Position = Vector2.new(barOffsetX + barWidth / 2, fillY - 12)
            bar.hpText.Color = bgColor
            bar.hpText.Visible = true

            bar.nameText.Text = player.DisplayName
            bar.nameText.Position = Vector2.new(rootPos.X, headPos.Y - 14)
            bar.nameText.Visible = true
        else
            for _, drawing in pairs(bar) do
                drawing.Visible = false
            end
        end
    end
end

local function enableHealth()
    HealthEnabled = true

    for _, player in ipairs(Players:GetPlayers()) do
        createHealthBar(player)
    end

    if not EspLoop then
        EspLoop = RunService.RenderStepped:Connect(updateHealthBars)
    end
end

local function disableHealth()
    HealthEnabled = false
    hideAllBars()
end

Players.PlayerAdded:Connect(function(player)
    if HealthEnabled then
        createHealthBar(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeHealthBar(player)
end)

p:Dropdown({
    Title = "血量显示",
    Values = {
        {
            Title = "开启",
            Desc = "开启血量显示",
            Callback = function()
                enableHealth()
            end,
        },
        {
            Title = "关闭",
            Desc = "关闭血量显示",
            Callback = function()
                disableHealth()
            end,
        },
    }
})

p:Toggle({
    Title = "本地视角高亮",
    Value = false,
    Callback = function(v)
        local c = game.Players.LocalPlayer.Character
        if not c then return end
        
        if v then
            if not c:FindFirstChild("LocalHL") then
                local h = Instance.new("Highlight")
                h.Name = "LocalHL"
                h.FillColor = Color3.fromRGB(0,255,0)
                h.OutlineColor = Color3.fromRGB(0,255,0)
                h.Parent = c
            end
        else
            local h = c:FindFirstChild("LocalHL")
            if h then h:Destroy() end
        end
    end
})

p:Toggle({
    Title = "玩家高亮",
    Value = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        if state then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local char = plr.Character
                    if char and not char:FindFirstChild("PlayerHighlight") then
                        local h = Instance.new("Highlight")
                        h.Name = "PlayerHighlight"
                        h.Adornee = char
                        h.FillColor = Color3.fromRGB(0,255,0)
                        h.OutlineColor = Color3.fromRGB(0,255,0)
                        h.FillTransparency = 0.5
                        h.OutlineTransparency = 0
                        h.Parent = char
                    end
                end
            end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local char = plr.Character
                    if char then
                        local h = char:FindFirstChild("PlayerHighlight")
                        if h then
                            h:Destroy()
                        end
                    end
                end
            end
        end
    end
})

p:Section({
    Title = "自瞄/FOV设置",
    Box = true,
    Opened = true,
})

local fovCircle = Drawing.new("Circle")
fovCircle.Radius = 100
fovCircle.Filled = false
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Visible = false

local fovColor = Color3.fromRGB(255, 255, 255)
local rainbowMode = false
local rainbowHue = 0

spawn(function()
    while true do
        local cam = workspace.CurrentCamera
        if cam then
            local vp = cam.ViewportSize
            fovCircle.Position = Vector2.new(vp.X / 2, vp.Y / 2)
        end
        if rainbowMode then
            rainbowHue = (rainbowHue + 0.005) % 1
            fovCircle.Color = Color3.fromHSV(rainbowHue, 1, 1)
        end
        task.wait()
    end
end)

local UIS = game:GetService("UserInputService")
local aimlockConn = nil
local aimSettings = {
    fov = 100,
    smooth = 0.15,
    wallCheck = false,
    enabled = false,
    showFov = false,
    targetPart = "Head",
    teamCheck = false,
    holdKey = false,
    prediction = false,
    predictionValue = 0.1
}

p:Input({
    Title = "自瞄灵敏度",
    Desc = "输入灵敏度 0.01-1",
    Value = "0.15",
    Placeholder = "输入数字",
    Callback = function(v)
        local speed = tonumber(v) or 0.15
        aimSettings.smooth = math.clamp(speed, 0.01, 1)
    end
})

p:Input({
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

p:Slider({
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

p:Dropdown({
    Title = "瞄准部位",
    Desc = "选择瞄准的目标部位",
    Values = {"Head", "UpperTorso", "HumanoidRootPart"},
    Value = "Head",
    Callback = function(value)
        aimSettings.targetPart = value
    end
})

p:Slider({
    Title = "预测强度",
    Desc = "弹道预测偏移量 0-0.5",
    Step = 0.01,
    Value = {
        Min = 0,
        Max = 0.5,
        Default = 0.1,
    },
    Callback = function(value)
        aimSettings.predictionValue = value
    end
})

p:Toggle({
    Title = "显示FOV",
    Value = false,
    Callback = function(state)
        aimSettings.showFov = state
        fovCircle.Visible = state
    end
})

local colorMap = {
    ["白色"]  = Color3.fromRGB(255, 255, 255),
    ["红色"]  = Color3.fromRGB(255,  50,  50),
    ["绿色"]  = Color3.fromRGB( 50, 255, 100),
    ["蓝色"]  = Color3.fromRGB( 50, 150, 255),
    ["黄色"]  = Color3.fromRGB(255, 230,   0),
    ["青色"]  = Color3.fromRGB(  0, 240, 255),
    ["洋红"]  = Color3.fromRGB(255,   0, 200),
    ["橙色"]  = Color3.fromRGB(255, 140,   0),
    ["粉色"]  = Color3.fromRGB(255, 120, 180),
    ["紫色"]  = Color3.fromRGB(160,  60, 255),
    ["黑色"]  = Color3.fromRGB(0,  0, 0),
}

p:Dropdown({
    Title = "光圈颜色",
    Desc = "选择FOV光圈显示颜色",
    Values = {"白色", "红色", "绿色", "蓝色", "黄色", "青色", "洋红", "橙色", "粉色", "紫色", "黑色"},
    Value = "白色",
    Callback = function(value)
        fovColor = colorMap[value] or Color3.fromRGB(255, 255, 255)
        if not rainbowMode then
            fovCircle.Color = fovColor
        end
    end
})

p:Toggle({
    Title = "彩虹光圈",
    Value = false,
    Callback = function(state)
        rainbowMode = state
        if not state then
            fovCircle.Color = fovColor
        end
    end
})

p:Slider({
    Title = "光圈粗细",
    Desc = "调整FOV圆圈线条粗细",
    Step = 1,
    Value = {
        Min = 1,
        Max = 5,
        Default = 1,
    },
    Callback = function(value)
        fovCircle.Thickness = value
    end
})

p:Toggle({
    Title = "墙壁检测",
    Value = false,
    Callback = function(state)
        aimSettings.wallCheck = state
    end
})

p:Toggle({
    Title = "队伍检测",
    Value = false,
    Callback = function(state)
        aimSettings.teamCheck = state
    end
})

p:Toggle({
    Title = "弹道预测",
    Value = false,
    Callback = function(state)
        aimSettings.prediction = state
    end
})

p:Toggle({
    Title = "按键触发 (右键)",
    Value = false,
    Callback = function(state)
        aimSettings.holdKey = state
    end
})
local attackWhitelist  = {}
local whitelistEnabled = false
local showTargetLine   = false
local highlightWL      = false
local currentSelected  = nil

local function isWhitelisted(player)
    return attackWhitelist[player.Name:lower()] ~= nil
end

local function scanPlayers()
    local t = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            table.insert(t, plr.Name)
        end
    end
    return #t > 0 and t or {"(无其他玩家)"}
end

local targetLine      = Drawing.new("Line")
targetLine.Thickness  = 1.5
targetLine.Color      = Color3.fromRGB(255, 80, 80)
targetLine.Visible    = false

local WL_POOL = {}
for i = 1, 20 do
    local d = Drawing.new("Text")
    d.Size    = 13
    d.Color   = Color3.fromRGB(255, 70, 70)
    d.Outline = true
    d.Center  = true
    d.Visible = false
    WL_POOL[i] = d
end

spawn(function()
    while true do
        for _, d in ipairs(WL_POOL) do d.Visible = false end
        local cam = workspace.CurrentCamera
        if cam then
            if highlightWL then
                local idx = 0
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= Players.LocalPlayer and isWhitelisted(plr) then
                        local char = plr.Character
                        local head = char and char:FindFirstChild("Head")
                        if head then
                            local sp, vis = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 1.8, 0))
                            if vis then
                                idx = idx + 1
                                if idx > #WL_POOL then break end
                                local lb     = WL_POOL[idx]
                                lb.Text      = "[ " .. plr.Name .. " ]"
                                lb.Position  = Vector2.new(sp.X, sp.Y)
                                lb.Visible   = true
                            end
                        end
                    end
                end
            end
            if showTargetLine then
                local tgt = getClosestPlayer()
                if tgt then
                    local sp, vis = cam:WorldToViewportPoint(tgt.Position)
                    if vis then
                        targetLine.From    = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                        targetLine.To      = Vector2.new(sp.X, sp.Y)
                        targetLine.Visible = true
                    else
                        targetLine.Visible = false
                    end
                else
                    targetLine.Visible = false
                end
            else
                targetLine.Visible = false
            end
        end
        task.wait(0.05)
    end
end)

local function isSameTeam(player)
    local localPlayer = Players.LocalPlayer
    if localPlayer.Team ~= nil and player.Team ~= nil then
        return localPlayer.Team == player.Team
    end
    return false
end

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
            if aimSettings.teamCheck and isSameTeam(p) then
                continue
            end
            if whitelistEnabled and not isWhitelisted(p) then continue end

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

p:Toggle({
    Title = "自瞄",
    Value = false,
    Callback = function(state)
        aimSettings.enabled = state

        if state then
            aimlockConn = game:GetService("RunService").RenderStepped:Connect(function()
                if aimSettings.holdKey and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    return
                end

                local cam = workspace.CurrentCamera
                local target = getClosestPlayer()

                if cam and target then
                    local camPos = cam.CFrame.Position
                    local targetPos = target.Position

                    if aimSettings.prediction then
                        local targetHRP = target.Parent:FindFirstChild("HumanoidRootPart")
                        if targetHRP then
                            targetPos = targetPos + targetHRP.AssemblyLinearVelocity * aimSettings.predictionValue
                        end
                    end

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

p:Section({
    Title  = "攻击白名单",
    Box    = true,
    Opened = true,
})

p:Toggle({
    Title = "启用白名单模式",
    Desc  = "开启后自瞄只锁定白名单内的玩家",
    Value = false,
    Callback = function(state)
        whitelistEnabled = state
    end,
})

local wlDropdown = p:Dropdown({
    Title  = "选择攻击目标",
    Desc   = "列表自动显示服务器内玩家",
    Values = scanPlayers(),
    Value  = scanPlayers()[1],
    Callback = function(value)
        if value ~= "(无其他玩家)" then
            currentSelected = value
        end
    end,
})

p:Button({
    Title    = "添加选中玩家",
    Desc     = "将下拉框中选中的玩家加入白名单",
    Callback = function()
        if currentSelected and currentSelected ~= "(无其他玩家)" then
            attackWhitelist[currentSelected:lower()] = currentSelected
        end
    end,
})

p:Button({
    Title    = "移除选中玩家",
    Desc     = "将下拉框中选中的玩家从白名单移除",
    Callback = function()
        if currentSelected then
            attackWhitelist[currentSelected:lower()] = nil
        end
    end,
})

p:Button({
    Title    = "刷新玩家列表",
    Desc     = "重新扫描服务器中的玩家",
    Callback = function()
        local names = scanPlayers()
        pcall(function() wlDropdown:Refresh(names, true) end)
        pcall(function() wlDropdown:Set(names[1]) end)
        currentSelected = names[1]
    end,
})

p:Button({
    Title    = "添加当前最近目标",
    Desc     = "将FOV内最近玩家直接加入白名单",
    Callback = function()
        local prev = whitelistEnabled
        whitelistEnabled = false
        local target = getClosestPlayer()
        whitelistEnabled = prev
        if target then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then
                    local part = plr.Character:FindFirstChild(aimSettings.targetPart)
                    if part == target then
                        attackWhitelist[plr.Name:lower()] = plr.Name
                        break
                    end
                end
            end
        end
    end,
})

p:Button({
    Title    = "清空白名单",
    Desc     = "移除所有已添加的目标",
    Callback = function()
        attackWhitelist = {}
    end,
})

p:Toggle({
    Title = "白名单玩家标注",
    Desc  = "在白名单玩家头顶显示红色标记",
    Value = false,
    Callback = function(state)
        highlightWL = state
    end,
})

p:Toggle({
    Title = "目标指示线",
    Desc  = "从准星向当前锁定目标画线",
    Value = false,
    Callback = function(state)
        showTargetLine = state
    end,
})

p:Slider({
    Title = "指示线粗细",
    Desc  = "调整目标指示线线条粗细",
    Step  = 0.5,
    Value = { Min = 0.5, Max = 4, Default = 1.5 },
    Callback = function(value)
        targetLine.Thickness = value
    end,
})

p:Dropdown({
    Title  = "指示线颜色",
    Desc   = "选择目标指示线的颜色",
    Values = {"红色", "白色", "黄色", "青色", "洋红"},
    Value  = "红色",
    Callback = function(value)
        local map = {
            ["红色"] = Color3.fromRGB(255, 80,  80),
            ["白色"] = Color3.fromRGB(255, 255, 255),
            ["黄色"] = Color3.fromRGB(255, 230,   0),
            ["青色"] = Color3.fromRGB(  0, 240, 255),
            ["洋红"] = Color3.fromRGB(255,   0, 200),
        }
        targetLine.Color = map[value] or Color3.fromRGB(255, 80, 80)
    end,
})

i:Section({
    Title = "重置和保存/区域",
    Box = true,
    Opened = true,
})

i:Button({
    Title = "重置人物",
    Locked = false,
    Callback = function()
        Players.LocalPlayer.Character.Humanoid.Health = 0
    end
})

i:Button({
    Title = "保存游戏",
    Locked = false,
    Callback = function()
        saveinstance()
    end
})

i:Button({
    Title = "离开游戏",
    Locked = false,
    Callback = function()
        game:Shutdown()
    end
})

i:Section({
    Title = "光影/区域",
    Box = true,
    Opened = true,
})

i:Button({
    Title = "光影v4",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/szkrx/gjn/refs/heads/main/gdd"))()
    end
})

u:Section({
    Title = "动态模糊/区域",
    Box = true,
    Opened = true,
})

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

if _G.KrXDynamicBlur then
    _G.KrXDynamicBlur:Destroy()
end

local Controller = {}
_G.KrXDynamicBlur = Controller

local camera = Workspace.CurrentCamera
local blur = Lighting:FindFirstChild("KrXDynamicBlur")

if not blur then
    blur = Instance.new("BlurEffect")
    blur.Name = "KrXDynamicBlur"
    blur.Size = 0
    blur.Enabled = false
    blur.Parent = Lighting
end

local settings = {
    Enabled = false,
    RotationBlur = true,
    MovementBlur = true,
    ZoomBlur = true,
    MaxBlur = 14,
    RotationSensitivity = 240,
    MovementSensitivity = 0.035,
    ZoomSensitivity = 0.3,
    SmoothSpeed = 13,
    Deadzone = 0.0005
}

local renderConnection
local cameraConnection

local lastLook
local lastPosition
local lastFOV

local function updateCamera()
    camera = Workspace.CurrentCamera

    if camera then
        lastLook = camera.CFrame.LookVector
        lastPosition = camera.CFrame.Position
        lastFOV = camera.FieldOfView
    end
end

local function startBlur()
    if renderConnection then
        return
    end

    updateCamera()

    if not camera then
        return
    end

    blur.Enabled = true

    cameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        updateCamera()
    end)

    renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not settings.Enabled or not camera then
            return
        end

        local currentCFrame = camera.CFrame
        local currentLook = currentCFrame.LookVector
        local currentPosition = currentCFrame.Position
        local currentFOV = camera.FieldOfView

        local rotationBlur = 0
        local movementBlur = 0
        local zoomBlur = 0

        if settings.RotationBlur and lastLook then
            local dot = math.clamp(lastLook:Dot(currentLook), -1, 1)
            local rotationDelta = math.acos(dot)

            if rotationDelta > settings.Deadzone then
                rotationBlur = rotationDelta * settings.RotationSensitivity
            end
        end

        if settings.MovementBlur and lastPosition then
            local positionDelta = (currentPosition - lastPosition).Magnitude
            local movementSpeed = positionDelta / math.max(deltaTime, 1 / 240)

            movementBlur = movementSpeed * settings.MovementSensitivity
        end

        if settings.ZoomBlur and lastFOV then
            local fovDelta = math.abs(currentFOV - lastFOV)
            local fovSpeed = fovDelta / math.max(deltaTime, 1 / 240)

            zoomBlur = fovSpeed * settings.ZoomSensitivity
        end

        local targetBlur = math.clamp(
            math.max(rotationBlur, movementBlur, zoomBlur),
            0,
            settings.MaxBlur
        )

        local alpha = 1 - math.exp(-settings.SmoothSpeed * deltaTime)

        blur.Size += (targetBlur - blur.Size) * alpha

        if blur.Size < 0.02 and targetBlur == 0 then
            blur.Size = 0
        end

        lastLook = currentLook
        lastPosition = currentPosition
        lastFOV = currentFOV
    end)
end

local function stopBlur()
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end

    if cameraConnection then
        cameraConnection:Disconnect()
        cameraConnection = nil
    end

    settings.Enabled = false
    blur.Size = 0
    blur.Enabled = false
end

function Controller:Destroy()
    stopBlur()

    if blur then
        blur:Destroy()
    end

    if _G.KrXDynamicBlur == self then
        _G.KrXDynamicBlur = nil
    end
end

u:Toggle({
    Title = "动态模糊",
    Desc = "根据视角、移动和缩放产生动态模糊",
    Icon = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        settings.Enabled = state

        if state then
            startBlur()
        else
            stopBlur()
        end
    end
})

u:Slider({
    Title = "模糊强度",
    Desc = "设置动态模糊的最大强度",
    Step = 1,
    Value = {
        Min = 1,
        Max = 30,
        Default = 14
    },
    Callback = function(value)
        settings.MaxBlur = value
    end
})

u:Slider({
    Title = "旋转灵敏度",
    Desc = "视角旋转时产生模糊的灵敏度",
    Step = 10,
    Value = {
        Min = 50,
        Max = 500,
        Default = 240
    },
    Callback = function(value)
        settings.RotationSensitivity = value
    end
})

u:Slider({
    Title = "移动灵敏度",
    Desc = "镜头移动时产生模糊的灵敏度",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = 35
    },
    Callback = function(value)
        settings.MovementSensitivity = value / 1000
    end
})

u:Slider({
    Title = "缩放灵敏度",
    Desc = "视野变化时产生模糊的灵敏度",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = 30
    },
    Callback = function(value)
        settings.ZoomSensitivity = value / 100
    end
})

u:Slider({
    Title = "平滑速度",
    Desc = "数值越高，模糊响应和消退越快",
    Step = 1,
    Value = {
        Min = 1,
        Max = 30,
        Default = 13
    },
    Callback = function(value)
        settings.SmoothSpeed = value
    end
})

u:Toggle({
    Title = "旋转模糊",
    Desc = "转动视角时产生动态模糊",
    Icon = "",
    Type = "Checkbox",
    Value = true,
    Callback = function(state)
        settings.RotationBlur = state
    end
})

u:Toggle({
    Title = "移动模糊",
    Desc = "移动镜头或角色时产生动态模糊",
    Icon = "",
    Type = "Checkbox",
    Value = true,
    Callback = function(state)
        settings.MovementBlur = state
    end
})

u:Toggle({
    Title = "缩放模糊",
    Desc = "改变视野范围时产生动态模糊",
    Icon = "",
    Type = "Checkbox",
    Value = true,
    Callback = function(state)
        settings.ZoomBlur = state
    end
})

hh:Section({
    Title = "Ui区域/设置定义",
    Box = true,
    Opened = true,
})

hh:Toggle({
    Title = "主题颜色",
    Value = true,
    Callback = function(v)
        local theme = v and "Dark" or "Light"

        pcall(function()
            WindUI:SetTheme(theme)
        end)

        pcall(function()
            Window:SetTheme(theme)
        end)

        pcall(function()
            WindUI:Notify({
                Title = "主题切换",
                Content = v and "已切换为黑色主题" or "已切换为白色主题",
                Duration = 2,
                Icon = v and "moon" or "sun"
            })
        end)
    end
})

op:Button({
    Title = "祖国人脚本",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/giobolqv1/homelander-by-GioBolqv1-/refs/heads/main/homelander.lua"))()
    end
})

r:Paragraph({
    Title = "使用方式/站在燃料台",
    Desc = "拿着燃料采集器",
    Thumbnail = "https://www.kr520.top/d62b933846c4fb9f89dff6d591980228.png",
    ThumbnailSize = 200
})

local f1 = 5

r:Input({
    Title = "返回时间",
    Desc = "输入秒",
    Value = "5",
    Placeholder = "输入秒数",
    Callback = function(v)
        f1 = tonumber(v) or 5
    end
})

r:Toggle({
    Title = "全自动收集",
    Desc = "开启前先站仓库位置",
    Value = false,
    Callback = function(s)
        if s then
            _G.a = true
            
            local p = Players.LocalPlayer
            local h = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            local r1 = h and h.CFrame
            
            if not r1 then
                return
            end
            
            task.spawn(function()
                local c = {
                    Vector3.new(-20.32170867919922, 7.0480241775512695, 11.149977684020996),
                    Vector3.new(-20.32170867919922, 7.0480241775512695, 11.149977684020996),
                    Vector3.new(3.9293618202209473, 6.048024654388428, -28.996356964111328),
                    Vector3.new(-5.166738510131836, 6.548024654388428, -20.774232864379883),
                    Vector3.new(-8.097999572753906, -0.949999988079071, -28.711997985839844),
                    Vector3.new(7.901999473571777, -0.949999988079071, -12.711997985839844),
                    Vector3.new(7.901999473571777, -0.949999988079071, -20.711997985839844),
                    Vector3.new(3.9020004272460938, -0.949999988079071, -8.711997985839844),
                }
                
                while _G.a do
                    local i = math.random(1, #c)
                    local s1 = c[i]
                    
                    if Players.LocalPlayer.Character then
                        local h = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if h then
                            h.CFrame = CFrame.new(s1)
                        end
                    end
                    
                    local t1 = tick()
                    while _G.a and (tick() - t1 < f1) do
                        if Players.LocalPlayer.Character then
                            for _, t in pairs(Players.LocalPlayer.Character:GetChildren()) do
                                if t:IsA("Tool") and t.Name == "FuelScoop" then
                                    t:Activate()
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                    
                    if Players.LocalPlayer.Character then
                        local h = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if h then
                            h.CFrame = r1
                        end
                    end
                    
                    task.wait(1)
                end
                
                if Players.LocalPlayer.Character then
                    local h = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if h then
                        h.CFrame = r1
                    end
                end
            end)
            
        else
            _G.a = false
        end
    end
})

r:Section({
    Title = "燃料采集矿商店",
    Desc = "便携购买",
    Box = true,
    Opened = true,
})

r:Dropdown({
    Title = "选择要购买的物品",
    Values = {
        {
            Title = "生锈燃料采集器",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 0 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipFuelScoop"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "标准燃料采集器",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 1 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipFuelScoop"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "新燃料采集器",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 2 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipFuelScoop"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "电动燃料采集器",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 3 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyFuelScoop"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "人工智能采集器",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 5 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyFuelScoop"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "采矿激光",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 6 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyFuelScoop"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "红宝石采矿激光",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 7 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyFuelScoop"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "霓虹采矿激光",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 8 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyFuelScoop"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "太空水晶激光",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 9 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyFuelScoop"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "绿色水晶激光",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 10 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyFuelScoop"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "红色水晶激光",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 11 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyFuelScoop"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "蓝色水晶激光",
            Desc = "点击购买",
            Callback = function()
                local args = { [1] = "FuelScoop", [2] = 12 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyFuelScoop"):InvokeServer(unpack(args))
            end
        },
    }
})

r:Section({
    Title = "便携背包购买",
    Box = true,
    Opened = true,
})

r:Dropdown({
    Title = "选择要购买的背包",
    Values = {
        {
            Title = "新手背包",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 0 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "双重背包",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 1 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "压缩罐",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 2 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "原子压缩罐",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 3 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "大型压缩",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 4 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "大型原子压缩罐",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 5 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "燃料棒",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 6 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "火箭背包",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 7 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "双重火箭背包",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 8 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "胖胖火箭背包",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 9 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "双重胖胖背包",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 10 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "绿色水晶背包",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 11 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "红色水晶背包",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 12 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "蓝色水晶背包",
            Desc = "点击购买",
            Callback = function()
                local args = { "Backpack", 13 }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyItem"):InvokeServer(unpack(args))
            end
        },
    }
})

r:Section({
    Title = "便携火箭购买",
    Box = true,
    Opened = true,
})

r:Dropdown({
    Title = "选择要购买的火箭",
    Values = {
        {
            Title = "新手火箭",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Rocket", 0 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipRocket"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "英勇火箭",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Rocket", 1 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipRocket"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "加成英勇",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Rocket", 2 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipRocket"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "购买火刀",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Rocket", 3 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipRocket"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "加成火刀",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Rocket", 4 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipRocket"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "阿特拉斯",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Rocket", 5 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipRocket"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "普罗米修斯",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Rocket", 6 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipRocket"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "双重阿特拉斯加强版",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Rocket", 7 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipRocket"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "追星者",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Rocket", 8 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipRocket"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "天空龙",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Rocket", 9 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipRocket"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "强化天空龙",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Rocket", 10 }
                game:GetService("ReplicatedStorage"):WaitForChild("EquipRocket"):InvokeServer(unpack(args))
            end
        },
    }
})

r:Section({
    Title = "便携宝石商店购买",
    Box = true,
    Opened = true,
})

r:Dropdown({
    Title = "选择要购买的加成物品",
    Values = {
        {
            Title = "资金加成",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Cash Booster" }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyAccelerant"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "速度加成",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Speed Booster" }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyAccelerant"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "燃料加成",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Fuel Booster" }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyAccelerant"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "暗物质核心",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Dark Matter Core" }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyAccelerant"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "无限背包",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Infinite Backpack" }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyAccelerant"):InvokeServer(unpack(args))
            end
        },
        {
            Title = "暗物质燃料采集",
            Desc = "点击购买",
            Locked = false,
            Callback = function()
                local args = { "Dark Matter FuelScoop" }
                game:GetService("ReplicatedStorage"):WaitForChild("BuyAccelerant"):InvokeServer(unpack(args))
            end
        },
    }
})

r:Section({
    Title = "便携传送",
    Box = true,
    Opened = true,
})

r:Dropdown({
    Title = "选择传送地点",
    Values = {
        {
            Title = "白云岛",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-76.13252258300781, 170.55825805664062, -60.4516716003418)
            end
        },
        {
            Title = "浮漂岛",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-66.51714324951172, 720.4866333007812, -5.391753196716309)
            end
        },
        {
            Title = "卫星岛",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-34.2462043762207, 1429.4990234375, 1.3739361763000488)
            end
        },
        {
            Title = "蜜蜂迷宫岛",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(6.5361199378967285, 3131.249267578125, -29.759048461914062)
            end
        },
        {
            Title = "月球人救援",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-7.212917804718018, 5016.341796875, -19.815933227539062)
            end
        },
        {
            Title = "暗物质岛",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(68.43186950683594, 6851.94091796875, 7.890637397766113)
            end
        },
        {
            Title = "太空岩石岛",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(49.92888641357422, 8942.955078125, 8.674375534057617)
            end
        },
        {
            Title = "零号火星岛",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(54.44503402709961, 11270.0927734375, -1.273137092590332)
            end
        },
        {
            Title = "月球浆果岛",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-14.601255416870117, 18410.9609375, 0.9418511986732483)
            end
        },
        {
            Title = "铺路石岛",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3.272758960723877, 22539.494140625, 63.283935546875)
            end
        },
        {
            Title = "流星岛",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-45.515689849853516, 27961.560546875, -7.358333110809326)
            end
        },
        {
            Title = "升级岛",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2.7595248222351074, 33959.98828125, 53.93095397949219)
            end
        },
    }
})

s:Button({
    Title = "远程买车",
    Desc = "点击",
    Locked = false,
    Callback = function()
        local prompt = workspace["Tang County Map Topography"]["Map Assets #2"]["Autolite Used Car Dealership"].Dealership.ProximityPrompt
        local player = Players.LocalPlayer
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hrp then
            local originalRange = prompt.MaxActivationDistance
            local originalCFrame = hrp.CFrame
    
            prompt.MaxActivationDistance = 99999
            
        hrp.CFrame = prompt.Parent.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.1)
    
        prompt:InputHoldBegin()
        task.wait(0.1)
        prompt:InputHoldEnd()
    
        hrp.CFrame = originalCFrame

        prompt.MaxActivationDistance = originalRange

        end

    end
})

s:Toggle({
    Title = "自动刷钱",
    Desc = "成为咖啡员工",
    Value = false,
    Callback = function(state)
        if state then
            _G.CoffeeActive = true
            
            local function triggerPrompt(prompt)
                if not prompt then return end
                local originalRange = prompt.MaxActivationDistance
                local originalHold = prompt.HoldDuration
                
                prompt.MaxActivationDistance = 999
                prompt.HoldDuration = 0
                task.wait(0.05)
                
                prompt:InputHoldBegin()
                prompt:InputHoldEnd()
                
                prompt.MaxActivationDistance = originalRange
                prompt.HoldDuration = originalHold
            end
            
            local function findCustomers()
                local customers = {}
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name:match("^Customer%d+$") then
                        local prompt = obj:FindFirstChild("ProximityPrompt")
                        if prompt then
                            table.insert(customers, prompt)
                        end
                    end
                end
                return customers
            end
            
            task.spawn(function()
                while _G.CoffeeActive do
                    local cupPrompt = workspace.BaristaJob.Scripted.Prompts.Prompt.ProximityPrompt
                    local fillPrompt = workspace.BaristaJob.Scripted.Prompts.PromptFill.ProximityPrompt
                    local customers = findCustomers()
                    
                    if cupPrompt then triggerPrompt(cupPrompt) end
                    task.wait(0.1)
                    
                    if fillPrompt then triggerPrompt(fillPrompt) end
                    task.wait(0.1)
                    
                    for _, customerPrompt in pairs(customers) do
                        if _G.CoffeeActive then
                            triggerPrompt(customerPrompt)
                            task.wait(0.1)
                        end
                    end
                end
            end)
        else
            _G.CoffeeActive = false
        end
    end
})

s:Section({
    Title = "便携传送",
    Box = true,
    Opened = true,
})

s:Dropdown({
    Title = "选择传送地点",
    Values = {
        {
            Title = "出生点",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3330.769287109375, 12.613265037536621, 3795.054443359375)
            end
        },
        {
            Title = "包子店",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5214.7060546875, 9.604497909545898, 5442.4033203125)
            end
        },
        {
            Title = "火锅店",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5605.80126953125, 9.724273681640625, 4444.5810546875)
            end
        },
        {
            Title = "咖啡店",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5874.34228515625, 10.250776290893555, 3680.686767578125)
            end
        },
        {
            Title = "手机店",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6822.69091796875, 10.349274635314941, 1761.5645751953125)
            end
        },
        {
            Title = "蜜雪冰城",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6980.26025390625, 9.724275588989258, 1742.7923583984375)
            end
        },
        {
            Title = "新一代脆皮烧烤",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-10324.1748046875, 9.492623329162598, 7106.42529296875)
            end
        },
        {
            Title = "学校1",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13877.0361328125, 9.054274559020996, 11073.2822265625)
            end
        },
        {
            Title = "一泽超市",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2984.316162109375, 21.566282272338867, -406.8870544433594)
            end
        },
        {
            Title = "东北烧烤",
            Desc = "点击传送",
            Callback = function()
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3195.267822265625, 20.472211837768555, -536.8143920898438)
            end
        },
    }
})

AuraTab:Toggle({
    Title = "杀戮光环",
    Value = false,
    Callback = function(state)
    N.D = state
    if state then
        local function AttackZombie(target, weapon, headshot)
            local char = Players.LocalPlayer.Character
            local hitPos = headshot and target.Head.Position or target.PrimaryPart.Position
            hitPos = hitPos + char.Head.CFrame.LookVector * 2.55
            
            if weapon.Parent ~= char then weapon.Parent = char end
            
            weapon.RemoteEvent:FireServer("Swing", "Side")
            local args
            if target:GetAttribute("Type") ~= "barrel" then
                args = {"HitZombie", target, hitPos, true}
            else
                args = {"HitZombie", target, target.L.CFrame.Position + char.Head.CFrame.LookVector * 2.55, false}
            end
            weapon.RemoteEvent:FireServer(unpack(args))
        end

        _G.AuraLoop = game:GetService("RunService").Heartbeat:Connect(function()
            local char = Players.LocalPlayer.Character
            if N.D and char and char:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    local currentTime = tick()
                    if currentTime - LastAttackTime >= AttackCooldown then
                        for _, zombie in pairs(workspace.Zombies:GetChildren()) do
                            if zombie and zombie.PrimaryPart and zombie:FindFirstChildOfClass("Humanoid") and zombie.State.Value ~= "Spawn" and char.Humanoid.Health > 0 then
                                local dist = Z(zombie)
                                if dist <= N.V then
                                    local isBarrel = zombie:GetAttribute("Type") == "Barrel"
                                    if N.B or not isBarrel then
                                        local weapon = X() or K()
                                        if weapon then
                                            local range = weapon.Name == "Pike" and N.C or (weapon.Name == "Axe" and N.X or N.Z)
                                            if dist <= range then
                                                local headshot = N.B
                                                if headshot then headshot = not isBarrel end
                                                AttackZombie(zombie, weapon, headshot)
                                                LastAttackTime = currentTime
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    else
        if _G.AuraLoop then _G.AuraLoop:Disconnect() end
    end
end
})

f:Section({
    Title = "进入游戏显示完整",
    Box = true,
    Opened = true,
})

f:Toggle({
    Title = "瞬移印钞机",
    Value = false,
    Callback = function(state)
        _G.MoneyPrintEnabled = state
        
        if state then
            task.spawn(function()
                while _G.MoneyPrintEnabled do
                    task.wait(0.1)
                    
                    for _, folder in pairs(game:GetService("Workspace").Game.Entities.ItemPickup:GetChildren()) do
                        for _, obj in pairs(folder:GetChildren()) do
                            if obj.ClassName == "MeshPart" or obj.ClassName == "Part" then
                                for _, prompt in pairs(obj:GetChildren()) do
                                    if prompt.ClassName == "ProximityPrompt" and prompt.ObjectText == "Money Printer" then
                                        local hrp = Players.LocalPlayer.Character.HumanoidRootPart
                                        hrp.CFrame = obj.CFrame
                                    end
                                end
                            end
                        end
                    end
                    
                    task.wait(0.1)
                    
                    for _, folder in pairs(game:GetService("Workspace").Game.Entities.ItemPickup:GetChildren()) do
                        for _, obj in pairs(folder:GetChildren()) do
                            for _, child in pairs(obj:GetChildren()) do
                                if child.ClassName == "BillboardGui" then
                                    child:Destroy()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

f:Toggle({
    Title = "飞标光环",
    Value = false,
    Callback = function(state)
        _G.NinjaStarActive = state
        
        if _G.NinjaStarConnections then
            for _, conn in ipairs(_G.NinjaStarConnections) do
                pcall(function() conn:Disconnect() end)
            end
        end
        _G.NinjaStarConnections = {}
        
        if state then
            local plrs = game:GetService("Players")
            local rs = game:GetService("ReplicatedStorage")
            local runService = game:GetService("RunService")
            local lp = plrs.LocalPlayer
            
            local dvv = require(rs.devv)
            local sig = dvv.load("Signal")
            local guid = dvv.load("GUID")
            local inv = dvv.load("v3item").inventory
            
            local dartCachedHitId = nil
            
            local function createBeautifulTrail(origin, targetPos)
                local trailContainer = Instance.new("Folder")
                trailContainer.Name = "MagicTrail"
                trailContainer.Parent = workspace
                
                local midPoint = (origin + targetPos) / 2
                local direction = (targetPos - origin).Unit
                local perpendicular = Vector3.new(-direction.Z, direction.Y, direction.X) * 3
                local controlPoint = midPoint + perpendicular + Vector3.new(0, math.random(-3, 3), 0)
                
                local function createBezierCurve(p0, p1, p2, t)
                    return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2
                end
                
                local curvePoints = {}
                local numSegments = 20
                
                for i = 0, numSegments do
                    local t = i / numSegments
                    local point = createBezierCurve(origin, controlPoint, targetPos, t)
                    table.insert(curvePoints, point)
                end
                
                for i = 1, #curvePoints - 1 do
                    local startPoint = curvePoints[i]
                    local endPoint = curvePoints[i + 1]
                    local distance = (endPoint - startPoint).Magnitude
                    
                    local beamPart = Instance.new("Part")
                    beamPart.Size = Vector3.new(0.15, 0.15, distance)
                    beamPart.Anchored = true
                    beamPart.CanCollide = false
                    beamPart.Material = Enum.Material.Neon
                    beamPart.Transparency = 0.3
                    beamPart.CFrame = CFrame.new(startPoint, endPoint) * CFrame.new(0, 0, -distance / 2)
                    beamPart.Parent = trailContainer
                    
                    local t = i / (#curvePoints - 1)
                    local color
                    if t < 0.3 then
                        color = Color3.fromRGB(200, 180, 255)
                    elseif t < 0.6 then
                        color = Color3.fromRGB(180, 150, 240)
                    elseif t < 0.9 then
                        color = Color3.fromRGB(160, 130, 230)
                    else
                        color = Color3.fromRGB(140, 100, 220)
                    end
                    
                    beamPart.Color = color
                    
                    local pointLight = Instance.new("PointLight")
                    pointLight.Brightness = 5
                    pointLight.Range = 3
                    pointLight.Color = color
                    pointLight.Parent = beamPart
                    
                    local particles = Instance.new("ParticleEmitter")
                    particles.Size = NumberSequence.new(0.1, 0.3)
                    particles.Transparency = NumberSequence.new(0.3, 0.8)
                    particles.Lifetime = NumberRange.new(0.5, 1)
                    particles.Rate = 50
                    particles.Speed = NumberRange.new(1, 2)
                    particles.VelocitySpread = 180
                    particles.Color = ColorSequence.new(color)
                    particles.Parent = beamPart
                end
                
                task.delay(1.5, function()
                    if trailContainer and trailContainer.Parent then
                        trailContainer:Destroy()
                    end
                end)
                
                return trailContainer
            end
            
            local function dartEquipNinjaStar()
                local itm = inv.getItems and inv.getItems() or inv.items or {}
                for _, v in next, itm do
                    if v.name == "Ninja Star" then
                        sig.FireServer("equip", v.guid)
                        return v.guid
                    end
                end
                return nil
            end
            
            local function dartInitThrow()
                local sg = dartEquipNinjaStar()
                if not sg then return end
                
                local c = lp.Character
                if not c then return end
                
                local rh = c:FindFirstChild("RightHand")
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if not rh or not hrp then return end
                
                local mp = rh.Position + Vector3.new(0, 0.5, 0)
                local tp = mp + Vector3.new(50, 0, 0)
                local vel = (tp - mp).Unit * 150
                
                createBeautifulTrail(mp, tp)
                
                local ok, r1, hid = pcall(function()
                    return sig.InvokeServer("throwSticky", guid(), "Ninja Star", sg, vel, tp)
                end)
                
                if ok and r1 and hid then
                    dartCachedHitId = hid
                end
            end
            
            local function dartHasShield(targetPlayer)
                if not targetPlayer or not targetPlayer.Character then return false end
                
                local char = targetPlayer.Character
                for _, desc in pairs(char:GetDescendants()) do
                    if desc:IsA("ForceField") then
                        return true
                    end
                end
                return false
            end
            
            local function dartFindValidTarget()
                local closest = nil
                local minDist = math.huge
                local myPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
                
                if not myPos then return nil end
                
                for _, player in ipairs(plrs:GetPlayers()) do
                    if player ~= lp and player.Character then
                        local char = player.Character
                        local humanoid = char:FindFirstChild("Humanoid")
                        local head = char:FindFirstChild("Head")
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        
                        if humanoid and head and hrp and humanoid.Health > 0 and not dartHasShield(player) then
                            local dist = (hrp.Position - myPos).Magnitude
                            if dist < minDist and dist <= 50 then
                                minDist = dist
                                closest = {player = player, head = head}
                            end
                        end
                    end
                end
                return closest
            end
            
            local function dartRapidThrowAttack()
                if not _G.NinjaStarActive or not dartCachedHitId then return end
                
                local targetData = dartFindValidTarget()
                if not targetData then return end
                
                local head = targetData.head 
                local tp = head.Position
                local wcf = CFrame.new(tp, tp + Vector3.new(0, 1, 0))
                local rcf = CFrame.new(0, 0, 0)
                
                local c = lp.Character
                if c and c:FindFirstChild("RightHand") then
                    local rh = c:FindFirstChild("RightHand")
                    createBeautifulTrail(rh.Position, tp)
                end
                
                for i = 1, 15 do 
                    sig.InvokeServer("hitSticky", dartCachedHitId, head, rcf, wcf)
                end
            end
            
            dartEquipNinjaStar()
            task.wait(0.1)
            dartInitThrow()
            
            local attackConn = runService.RenderStepped:Connect(function()
                if _G.NinjaStarActive then
                    dartRapidThrowAttack()
                end
            end)
            
            _G.NinjaStarConnections = {attackConn}
        end
    end
})