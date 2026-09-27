local ApplePureUI = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local LP = Players.LocalPlayer
assert(LP, "[ApplePureUI] 请在客户端 LocalScript 中加载此界面库")
local PG = LP:WaitForChild("PlayerGui")
local function newScope()
	local scope = {Alive = true, Generation = 0, Resources = {}}

	function scope:Give(cleanup)
		if self.Alive then self.Resources[cleanup] = true else pcall(cleanup) end
		return cleanup
	end

	function scope:Clean()
		self.Generation += 1
		local resources = self.Resources
		self.Resources = {}
		for cleanup in pairs(resources) do pcall(cleanup) end
	end

	function scope:Destroy()
		if not self.Alive then return end
		self.Alive = false
		self:Clean()
	end

	function scope:Connect(signal, callback)
		if not self.Alive then return nil end
		local generation = self.Generation
		local connection = signal:Connect(function(...)
			if self.Alive and self.Generation == generation then callback(...) end
		end)
		self:Give(function() connection:Disconnect() end)
		return connection
	end

	function scope:Delay(duration, callback)
		if not self.Alive then return nil end
		local generation = self.Generation
		local thread, cancel
		cancel = function()
			self.Resources[cancel] = nil
			if thread then pcall(task.cancel, thread); thread = nil end
		end
		self:Give(cancel)
		thread = task.delay(duration, function()
			self.Resources[cancel] = nil
			thread = nil
			if self.Alive and self.Generation == generation then callback() end
		end)
		return cancel
	end

	function scope:Tween(object, duration, properties, style, direction)
		if not self.Alive or not object or not object.Parent then return nil end
		local tween = TweenService:Create(object, TweenInfo.new(duration,
			style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), properties)
		local completed, cleanup
		cleanup = function()
			self.Resources[cleanup] = nil
			if completed then completed:Disconnect(); completed = nil end
			tween:Cancel()
		end
		self:Give(cleanup)
		completed = tween.Completed:Connect(function()
			self.Resources[cleanup] = nil
			if completed then completed:Disconnect(); completed = nil end
		end)
		tween:Play()
		return tween
	end

	return scope
end
local function newPointerRouter(scope, onScrollLock)
	local router = {Active = nil}
	function router:Finish(cancelled)
		local active = self.Active
		if not active then return end
		self.Active = nil
		onScrollLock(false)
		if active.Finish then active.Finish(cancelled == true) end
	end
	function router:Begin(input, move, finish, lockScroll)
		if not scope.Alive or self.Active then return false end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch then return false end
		self.Active = {Input = input, Move = move, Finish = finish}
		onScrollLock(lockScroll ~= false)
		return true
	end
	scope:Connect(UIS.InputChanged, function(input)
		local active = router.Active
		if not active then return end
		local touch = active.Input.UserInputType == Enum.UserInputType.Touch
		if (touch and input == active.Input)
			or (not touch and input.UserInputType == Enum.UserInputType.MouseMovement) then
			active.Move(input)
		end
	end)
	scope:Connect(UIS.InputEnded, function(input)
		local active = router.Active
		if not active then return end
		local touch = active.Input.UserInputType == Enum.UserInputType.Touch
		if (touch and input == active.Input)
			or (not touch and input.UserInputType == Enum.UserInputType.MouseButton1) then
			router:Finish(false)
		end
	end)
	scope:Connect(UIS.WindowFocusReleased, function() router:Finish(true) end)
	scope:Give(function() router:Finish(true) end)
	return router
end

local BACKDROP_BLUR_NAME = "ApplePureUI_BackdropBlur"

local function syncBackdropBlur(duration)
	local camera = workspace.CurrentCamera
	if not camera then return end

	local targetSize = 0
	local hasRegisteredWindow = false

	for _, child in ipairs(PG:GetChildren()) do
		if child:IsA("ScreenGui") and child:GetAttribute("ApplePureUIUsesBackdropBlur") == true then
			hasRegisteredWindow = true
			if child:GetAttribute("ApplePureUIBlurActive") == true then
				local requested = tonumber(child:GetAttribute("ApplePureUIBlurSize")) or 5
				targetSize = math.max(targetSize, math.clamp(requested, 0, 24))
			end
		end
	end

	local blur = camera:FindFirstChild(BACKDROP_BLUR_NAME)
	if not blur and (targetSize > 0 or hasRegisteredWindow) then
		blur = Instance.new("BlurEffect")
		blur.Name = BACKDROP_BLUR_NAME
		blur.Size = 0
		blur.Enabled = true
		blur.Parent = camera
	end

	if not blur then return end

	blur.Enabled = true
	TweenService:Create(
		blur,
		TweenInfo.new(duration or 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{Size = targetSize}
	):Play()

	if targetSize <= 0 and not hasRegisteredWindow then
		task.delay((duration or 0.28) + 0.08, function()
			local currentCamera = workspace.CurrentCamera
			local currentBlur = currentCamera and currentCamera:FindFirstChild(BACKDROP_BLUR_NAME)
			if not currentBlur or currentBlur.Size > 0.05 then return end

			for _, child in ipairs(PG:GetChildren()) do
				if child:IsA("ScreenGui") and child:GetAttribute("ApplePureUIUsesBackdropBlur") == true then
					return
				end
			end

			currentBlur:Destroy()
		end)
	end
end

local function getFont(name, fallback)
	local ok, font = pcall(function()
		return Enum.Font[name]
	end)
	return ok and font or fallback
end

local IOS_FONT = getFont("BuilderSans", Enum.Font.Gotham)
local IOS_FONT_MEDIUM = getFont("BuilderSansMedium", Enum.Font.GothamMedium)

local function corner(o, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = o
	return c
end

local function stroke(o, tr, col, th)
	local s = Instance.new("UIStroke")
	s.Color = col or Color3.fromRGB(255, 255, 255)
	s.Transparency = tr or 0.82
	s.Thickness = th or 1
	s.Parent = o
	return s
end

local function newLiquidGlass(main, mainStroke, scale, scope, cfg, style, mobile)
	local layers = {}
	local opacity = 1
	local pulse = 0
	local rimRest = 0.18
	local root = Instance.new("Frame")
	root.Name = "LiquidGlass"
	root.Size = UDim2.fromScale(1, 1)
	root.BackgroundTransparency = 1
	root.BorderSizePixel = 0
	root.Active = false
	root.Selectable = false
	root.ZIndex = 0
	root.Parent = main

	local function track(object, property, transparency)
		layers[#layers + 1] = {Object = object, Property = property, Transparency = transparency}
		object[property] = transparency
		return object
	end

	local function sheet(parent, name, inset, color, transparency, radius)
		local frame = Instance.new("Frame")
		frame.Name = name
		frame.Position = UDim2.fromOffset(inset, inset)
		frame.Size = UDim2.new(1, -inset * 2, 1, -inset * 2)
		frame.BackgroundColor3 = color
		frame.BackgroundTransparency = transparency
		frame.BorderSizePixel = 0
		frame.Active = false
		frame.Selectable = false
		frame.ZIndex = 0
		frame.Parent = parent
		corner(frame, math.max(1, radius or style.Radius - inset))
		if transparency < 1 then track(frame, "BackgroundTransparency", transparency) end
		return frame
	end

	local function gradient(parent, rotation, colors, stops)
		local effect = Instance.new("UIGradient")
		effect.Rotation = rotation
		if colors then
			local points = {}
			for _, entry in ipairs(colors) do
				points[#points + 1] = ColorSequenceKeypoint.new(entry[1], entry[2])
			end
			effect.Color = ColorSequence.new(points)
		end
		if stops then
			local points = {}
			for _, entry in ipairs(stops) do
				points[#points + 1] = NumberSequenceKeypoint.new(entry[1], entry[2])
			end
			effect.Transparency = NumberSequence.new(points)
		end
		effect.Parent = parent
		return effect
	end

	local shadow = Instance.new("Frame")
	shadow.Name = "LiquidGlassShadow"
	shadow.AnchorPoint = main.AnchorPoint
	shadow.BackgroundTransparency = 1
	shadow.BorderSizePixel = 0
	shadow.Active = false
	shadow.Selectable = false
	shadow.ZIndex = 0
	shadow.Parent = main.Parent
	local shadowScale = Instance.new("UIScale")
	shadowScale.Scale = scale.Scale
	shadowScale.Parent = shadow
	for _, entry in ipairs({{12, 0.989}, {7, 0.985}, {3, 0.980}, {1, 0.975}}) do
		local spread = entry[1]
		local layer = sheet(shadow, "Penumbra", -spread, Color3.fromRGB(7, 13, 23), entry[2], style.Radius + spread)
		layer.Position = UDim2.fromOffset(-spread, 5 - spread)
	end
	scope:Give(function() shadow:Destroy() end)

	local dimming = sheet(root, "DepthTint", 0, Color3.fromRGB(19, 25, 36), 0.84)
	gradient(dimming, 90, nil, {{0, 0.26}, {0.38, 0.12}, {1, 0}})
	local wash = sheet(root, "SurfaceReflection", 0, Color3.fromRGB(247, 251, 255), 0.90)
	local washGradient = gradient(wash, 112, nil, {{0, 0.08}, {0.22, 0.78}, {0.58, 1}, {1, 0.58}})
	local reflection = sheet(root, "LowerReflection", 0, Color3.fromRGB(186, 217, 237), 0.95)
	local reflectionGradient = gradient(reflection, 86, nil, {{0, 1}, {0.66, 1}, {0.91, 0.68}, {1, 0.12}})

	local depth = sheet(root, "InnerDepth", 3.2, Color3.fromRGB(255, 255, 255), 1)
	local depthStroke = track(stroke(depth, 0.76, Color3.fromRGB(15, 23, 35), 1.35), "Transparency", 0.76)
	gradient(depthStroke, 58, nil, {{0, 0.42}, {0.34, 0.93}, {0.70, 0.86}, {1, 0.12}})
	local prism = sheet(root, "EdgeDispersion", 0.85, Color3.fromRGB(255, 255, 255), 1)
	local prismStroke = track(stroke(prism, 0.78, Color3.fromRGB(255, 255, 255), mobile and 2.0 or 2.4), "Transparency", 0.78)
	local prismGradient = gradient(prismStroke, 34, {
		{0, Color3.fromRGB(161, 207, 252)},
		{0.36, Color3.fromRGB(228, 242, 253)},
		{0.68, Color3.fromRGB(242, 242, 231)},
		{1, Color3.fromRGB(250, 221, 183)},
	}, {{0, 0.18}, {0.31, 0.78}, {0.57, 1}, {0.81, 0.74}, {1, 0.24}})
	local inner = sheet(root, "InnerCaustic", 2.0, Color3.fromRGB(255, 255, 255), 1)
	local innerStroke = track(stroke(inner, 0.54, Color3.fromRGB(232, 245, 255), mobile and 0.75 or 0.90), "Transparency", 0.54)
	local innerGradient = gradient(innerStroke, 42, nil, {{0, 0.70}, {0.22, 0.97}, {0.61, 0.94}, {0.86, 0.30}, {1, 0.08}})
	local highlight = sheet(root, "SpecularHighlight", 0.9, Color3.fromRGB(255, 255, 255), 1)
	local highlightStroke = stroke(highlight, 0.88, Color3.fromRGB(255, 255, 255), mobile and 1.8 or 2.2)
	local highlightGradient = gradient(highlightStroke, 30, nil, {{0, 0}, {0.15, 0.32}, {0.37, 1}, {0.69, 1}, {0.86, 0.58}, {1, 0.10}})

	local rimColors = {
		{0, Color3.fromRGB(250, 254, 255)},
		{0.27, Color3.fromRGB(228, 243, 255)},
		{0.54, Color3.fromRGB(187, 204, 222)},
		{0.76, Color3.fromRGB(230, 235, 232)},
		{1, Color3.fromRGB(253, 248, 233)},
	}
	if cfg.Rainbow == true then
		rimColors = {
			{0, Color3.fromRGB(100, 255, 200)},
			{0.14, Color3.fromRGB(88, 208, 255)},
			{0.28, Color3.fromRGB(140, 118, 255)},
			{0.42, Color3.fromRGB(208, 98, 255)},
			{0.56, Color3.fromRGB(255, 98, 172)},
			{0.70, Color3.fromRGB(255, 182, 88)},
			{0.84, Color3.fromRGB(128, 255, 128)},
			{1, Color3.fromRGB(100, 255, 200)},
		}
	end
	local rimGradient = gradient(mainStroke, 34, rimColors,
		{{0, 0.04}, {0.18, 0.24}, {0.43, 0.76}, {0.59, 0.88}, {0.80, 0.28}, {1, 0.06}})

	local sheen = sheet(root, "MotionSheen", 0, Color3.fromRGB(255, 255, 255), 0.94)
	sheen.Visible = false
	local sheenGradient = gradient(sheen, 18, nil,
		{{0, 1}, {0.40, 1}, {0.47, 0.70}, {0.50, 0.18}, {0.53, 0.70}, {0.60, 1}, {1, 1}})

	local function syncOpacity()
		opacity = main.Visible and math.clamp((1 - mainStroke.Transparency) / (1 - rimRest), 0, 1) or 0
		for _, layer in ipairs(layers) do
			layer.Object[layer.Property] = 1 - (1 - layer.Transparency) * opacity
		end
		highlightStroke.Transparency = 1 - (0.12 + pulse * 0.10) * opacity
	end
	local function syncGeometry()
		shadow.Position = main.Position
		shadow.Size = main.Size
		shadow.Rotation = main.Rotation
		shadow.Visible = main.Visible
		shadowScale.Scale = scale.Scale
	end
	scope:Connect(main:GetPropertyChangedSignal("Position"), syncGeometry)
	scope:Connect(main:GetPropertyChangedSignal("Size"), syncGeometry)
	scope:Connect(main:GetPropertyChangedSignal("Rotation"), syncGeometry)
	scope:Connect(scale:GetPropertyChangedSignal("Scale"), syncGeometry)
	scope:Connect(main:GetPropertyChangedSignal("Visible"), function()
		syncGeometry()
		syncOpacity()
	end)
	scope:Connect(mainStroke:GetPropertyChangedSignal("Transparency"), syncOpacity)
	syncGeometry()
	syncOpacity()

	local targetX, targetY = -0.30, -0.40
	local lightX, lightY = targetX, targetY
	local previous = main.AbsolutePosition
	local accumulator, hue = 0, 0
	local function aim(position)
		local origin, size = main.AbsolutePosition, main.AbsoluteSize
		local x = (position.X - origin.X) / math.max(size.X, 1)
		local y = (position.Y - origin.Y) / math.max(size.Y, 1)
		if x >= 0 and x <= 1 and y >= 0 and y <= 1 then
			targetX, targetY = (x - 0.5) * 1.5, (y - 0.5) * 1.4
		else
			targetX, targetY = -0.30, -0.40
		end
	end
	scope:Connect(main.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			aim(input.Position)
			pulse = 1
		end
	end)
	scope:Connect(main.InputChanged, function(input)
		if input.UserInputType == Enum.UserInputType.Touch then aim(input.Position) end
	end)
	scope:Connect(UIS.WindowFocusReleased, function()
		targetX, targetY, pulse = -0.30, -0.40, 0
	end)
	scope:Connect(RunService.RenderStepped, function(dt)
		if not main.Parent or not main.Visible or main.Parent.Enabled == false then return end
		accumulator += math.min(dt, 0.10)
		if accumulator < (mobile and 1 / 30 or 1 / 45) then return end
		local step = accumulator
		accumulator = 0
		if not mobile then aim(UIS:GetMouseLocation()) end
		local position = main.AbsolutePosition
		local motionX = math.clamp((position.X - previous.X) / math.max(step * 420, 1), -1, 1)
		local motionY = math.clamp((position.Y - previous.Y) / math.max(step * 420, 1), -1, 1)
		previous = position
		local blend = 1 - math.exp(-step * 8)
		lightX += (targetX + motionX * 0.28 - lightX) * blend
		lightY += (targetY + motionY * 0.22 - lightY) * blend
		pulse *= math.exp(-step * 6)
		local angle = 34 + lightX * 18 + lightY * 9
		if cfg.Rainbow == true then
			hue = (hue + step * (cfg.RainbowSpeed or (mobile and 0.12 or 0.14))) % 1
			rimGradient.Rotation = hue * 360
		else
			rimGradient.Rotation = angle
		end
		rimGradient.Offset = Vector2.new(lightX * 0.035, lightY * 0.025)
		innerGradient.Rotation = angle + 8
		prismGradient.Rotation = angle - 6
		highlightGradient.Rotation = angle - 4
		washGradient.Offset = Vector2.new(lightX * 0.055, lightY * 0.035)
		reflectionGradient.Rotation = 86 - lightX * 5
		highlightStroke.Transparency = 1 - (0.12 + pulse * 0.10) * opacity
	end)

	return {Sheen = sheen, SheenGradient = sheenGradient, RimTransparency = rimRest}
end

local function label(p, txt, size, pos, dim, bold)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Position = pos or UDim2.new()
	l.Size = dim or UDim2.new()
	l.Font = bold and IOS_FONT_MEDIUM or IOS_FONT
	l.Text = txt or ""
	l.TextSize = size or 13
	l.TextColor3 = Color3.fromRGB(245, 245, 250)
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Center
	l.TextWrapped = false
	l.TextTruncate = Enum.TextTruncate.AtEnd
	l.ClipsDescendants = true
	l.Parent = p
	return l
end

local function pad(o, l, r, t, b)
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, l or 0)
	p.PaddingRight = UDim.new(0, r or 0)
	p.PaddingTop = UDim.new(0, t or 0)
	p.PaddingBottom = UDim.new(0, b or 0)
	p.Parent = o
	return p
end

local function clamp(v, a, b)
	return math.max(a, math.min(b, v))
end

function ApplePureUI:CreateWindow(cfg)
	cfg = cfg or {}

	local baseGuiName = tostring(cfg.Name or "ApplePureUI")
	local guiName = baseGuiName
	local instanceIndex = 1
	if cfg.ReplaceExisting == true or cfg.AllowMultiple == false then
		for _, child in ipairs(PG:GetChildren()) do
			if child:IsA("ScreenGui") and (child.Name == baseGuiName or child:GetAttribute("ApplePureUIBaseName") == baseGuiName) then
				child:Destroy()
			end
		end
	else
		local index = 1
		while PG:FindFirstChild(guiName) do
			index += 1
			guiName = baseGuiName .. "_" .. tostring(index)
		end
		instanceIndex = index
	end

	local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
	local mobile = UIS.TouchEnabled and math.min(viewport.X, viewport.Y) < 720
	local portrait = viewport.X < viewport.Y

	local mobileW, mobileH
	if portrait then
		mobileW = math.floor(viewport.X * 0.92)
		mobileH = math.floor(viewport.Y * 0.40)
		mobileW = math.min(clamp(mobileW, 340, 560), math.max(320, viewport.X - 18))
		mobileH = math.min(clamp(mobileH, 270, 420), math.max(250, viewport.Y - 42))
	else
		local targetH = math.floor(viewport.Y * 0.53)
		local targetW = math.floor(targetH * 1.60)

		if viewport.X < 1000 then
			targetH = math.floor(viewport.Y * 0.58)
			targetW = math.floor(targetH * 1.58)
		end

		mobileW = math.min(clamp(targetW, 520, 690), math.max(420, viewport.X - 72))
		mobileH = math.min(clamp(targetH, 320, 410), math.max(260, viewport.Y - 72))
	end

	local STYLE = {
		W = mobile and mobileW or 650,
		H = mobile and mobileH or 405,
		MinW = mobile and (portrait and math.min(340, math.max(300, viewport.X - 26)) or math.floor(mobileW * 0.86)) or 520,
		MinH = mobile and (portrait and math.min(255, math.max(230, viewport.Y - 60)) or math.floor(mobileH * 0.84)) or 320,
		MaxW = mobile and math.min(math.max(mobileW, math.floor(mobileW * 1.18)), viewport.X - 12) or 980,
		MaxH = mobile and math.min(math.max(mobileH, math.floor(mobileH * 1.16)), viewport.Y - 30) or 680,

		TopH = mobile and (portrait and 48 or 50) or 64,
		Pad = mobile and (portrait and 8 or 9) or 12,
		Gap = mobile and 9 or 12,
		SideW = mobile and (portrait and 108 or 112) or 148,
		SideMin = mobile and (portrait and 96 or 100) or 128,
		SideMax = mobile and (portrait and 126 or 132) or 168,

		Radius = mobile and 20 or 24,
		PanelRadius = mobile and 17 or 20,
		CardRadius = mobile and 14 or 16,

		TabH = mobile and (portrait and 31 or 32) or 36,
		TabGap = mobile and 6 or 8,
		RowH = mobile and (portrait and 46 or 46) or 56,
		SliderH = mobile and (portrait and 64 or 64) or 76,
		SectionH = mobile and (portrait and 36 or 36) or 42,

		TextX = mobile and 14 or 18,
		TitleSize = mobile and 11 or 13,
		DescSize = mobile and 9 or 11,
		SideSize = mobile and 11 or 13,
		TopTitle = mobile and 13 or 16,
		TopSub = mobile and 9 or 11,

		MainTr = cfg.Transparency or 0.90,
		PanelTr = 1,
		CardTr = 0.82,

		Accent = Color3.fromRGB(175, 255, 255),
		Text = Color3.fromRGB(245, 245, 250),
		Sub = Color3.fromRGB(190, 190, 202),
	}

	local function refreshResponsiveStyle(vp)
		portrait = vp.X < vp.Y
		if not mobile then return end

		local currentW, currentH
		if portrait then
			currentW = math.floor(vp.X * 0.92)
			currentH = math.floor(vp.Y * 0.40)
			currentW = math.min(clamp(currentW, 340, 560), math.max(320, vp.X - 18))
			currentH = math.min(clamp(currentH, 270, 420), math.max(250, vp.Y - 42))
		else
			currentH = math.floor(vp.Y * 0.53)
			currentW = math.floor(currentH * 1.60)
			if vp.X < 1000 then
				currentH = math.floor(vp.Y * 0.58)
				currentW = math.floor(currentH * 1.58)
			end
			currentW = math.min(clamp(currentW, 520, 690), math.max(420, vp.X - 72))
			currentH = math.min(clamp(currentH, 320, 410), math.max(260, vp.Y - 72))
		end

		STYLE.W = currentW
		STYLE.H = currentH
		STYLE.MinW = portrait and math.min(340, math.max(300, vp.X - 26)) or math.floor(currentW * 0.86)
		STYLE.MinH = portrait and math.min(255, math.max(230, vp.Y - 60)) or math.floor(currentH * 0.84)
		STYLE.MaxW = math.min(math.max(currentW, math.floor(currentW * 1.18)), math.max(STYLE.MinW, vp.X - 12))
		STYLE.MaxH = math.min(math.max(currentH, math.floor(currentH * 1.16)), math.max(STYLE.MinH, vp.Y - 30))
		STYLE.Pad = portrait and 8 or 9
		STYLE.Gap = 9
		STYLE.SideMin = portrait and 96 or 100
		STYLE.SideMax = portrait and 126 or 132
		STYLE.TabH = portrait and 31 or 32
		STYLE.RowH = 46
		STYLE.SliderH = 64
		STYLE.SectionH = 36
	end

	refreshResponsiveStyle(viewport)

	local realBlurEnabled = cfg.RealBlur ~= false
	local realBlurSize = math.clamp(tonumber(cfg.BlurSize) or (mobile and 5 or 6), 0, 24)

	local gui = Instance.new("ScreenGui")
	gui.Name = guiName
	gui:SetAttribute("ApplePureUIBaseName", baseGuiName)
	gui:SetAttribute("ApplePureUIUsesBackdropBlur", realBlurEnabled)
	gui:SetAttribute("ApplePureUIBlurSize", realBlurSize)
	gui:SetAttribute("ApplePureUIBlurActive", false)
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = PG

	local windowScope = newScope()
	local pageScope = newScope()
	local cameraScope = newScope()
	local motionScope = newScope()
	local lifecycleCleaning = false
	local main, content, pointer
	local keybinds = {}
	local keyCapture, keyCaptureCancel
	local tabOwner = {}

	local function finishKeyCapture()
		local record = keyCapture
		keyCapture = nil
		if keyCaptureCancel then keyCaptureCancel(); keyCaptureCancel = nil end
		if record and record.Text and record.Text.Parent then
			record.Text.Text = record.Key.Name
		end
	end
	local activeTab = nil
	local introEnabled = cfg.IntroAnimation ~= false
	local state = introEnabled and "closed" or "open"
	local savedPos = cfg.Position or UDim2.fromScale(0.5, 0.5)

	local function connect(sig, fn, pageOnly)
		return (pageOnly and pageScope or windowScope):Connect(sig, fn)
	end

	local function clearPageConns()
		if pointer then pointer:Finish(true) end
		finishKeyCapture()
		pageScope:Clean()
	end

	local function tw(o, t, props, style, dir)
		local scope = content and o and o:IsDescendantOf(content) and pageScope or windowScope
		return scope:Tween(o, t, props, style, dir)
	end

	local function safe(cb, ...)
		if type(cb) ~= "function" then return end
		pcall(cb, ...)
	end

	local function scaleTextSize(base, minSize, maxSize)
		local w = main and (main.Size.X.Scale * viewport.X + main.Size.X.Offset) or STYLE.W
		local ratio = clamp(w / math.max(STYLE.W, 1), 0.82, 1.14)
		return clamp(math.floor((base or 12) * ratio + 0.5), minSize or 9, maxSize or 16)
	end

	local function fitText(obj, base, minSize, maxSize)
		if not obj then return end
		obj.TextSize = scaleTextSize(base, minSize, maxSize)
		obj.TextTruncate = Enum.TextTruncate.AtEnd
		obj.ClipsDescendants = true
	end

	local function setTextBoxFit(obj, base, minSize, maxSize)
		if not obj then return end
		obj.TextSize = scaleTextSize(base, minSize, maxSize)
		obj.ClipsDescendants = true
		obj.TextTruncate = Enum.TextTruncate.AtEnd
	end

	main = Instance.new("Frame")
	main.Name = "Main"
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.Position = savedPos

	local initialSize = cfg.Size or UDim2.fromOffset(STYLE.W, STYLE.H)
	if mobile then
		if cfg.MobileSize then
			initialSize = cfg.MobileSize
		elseif cfg.MobileUseDesktopSize ~= true then
			initialSize = UDim2.fromOffset(STYLE.W, STYLE.H)
		end

		local initW = initialSize.X.Scale * viewport.X + initialSize.X.Offset
		local initH = initialSize.Y.Scale * viewport.Y + initialSize.Y.Offset
		initialSize = UDim2.fromOffset(
			clamp(initW, STYLE.MinW, STYLE.MaxW),
			clamp(initH, STYLE.MinH, STYLE.MaxH)
		)
	end

	main.Size = initialSize
	main.BackgroundColor3 = Color3.fromRGB(221, 231, 242)
	main.BackgroundTransparency = STYLE.MainTr
	main.BorderSizePixel = 0
	main.ZIndex = 1
	main.ClipsDescendants = true
	main.Parent = gui
	main.Visible = not introEnabled
	corner(main, STYLE.Radius)

	local mainStroke = stroke(main, 0.18, Color3.fromRGB(255, 255, 255), mobile and 1.10 or 1.35)
	local scale = Instance.new("UIScale")
	scale.Scale = 1
	scale.Parent = main
	local glass = newLiquidGlass(main, mainStroke, scale, windowScope, cfg, STYLE, mobile)
	local motionSheen = glass.Sheen

	local top = Instance.new("Frame")
	top.Name = "Top"
	top.BackgroundTransparency = 1
	top.Parent = main

	local title = label(top, cfg.Title or "落叶 Pro", STYLE.TopTitle, nil, nil, true)
	title.TextColor3 = STYLE.Text

	local sub = label(top, cfg.Subtitle or "", STYLE.TopSub, nil, nil, false)
	sub.TextColor3 = STYLE.Sub

	local tagHolder = Instance.new("Frame")
	tagHolder.BackgroundTransparency = 1
	tagHolder.Parent = top

	local tagLayout = Instance.new("UIListLayout")
	tagLayout.FillDirection = Enum.FillDirection.Horizontal
	tagLayout.Padding = UDim.new(0, 8)
	tagLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	tagLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tagLayout.Parent = tagHolder

	local mini = Instance.new("TextButton")
	mini.Name = "Minimize"
	mini.Text = "-"
	mini.TextSize = 22
	mini.TextXAlignment = Enum.TextXAlignment.Center
	mini.TextYAlignment = Enum.TextYAlignment.Center
	mini.Font = IOS_FONT_MEDIUM
	mini.TextColor3 = STYLE.Text
	mini.BackgroundTransparency = 1
	mini.AutoButtonColor = false
	mini.Parent = top

	local close = Instance.new("TextButton")
	close.Name = "Close"
	close.Text = "×"
	close.TextSize = 24
	close.Font = IOS_FONT_MEDIUM
	close.TextColor3 = STYLE.Text
	close.BackgroundTransparency = 1
	close.AutoButtonColor = false
	close.Parent = top

	local sideBox = Instance.new("Frame")
	sideBox.Name = "SideBox"
	sideBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sideBox.BackgroundTransparency = STYLE.PanelTr
	sideBox.BorderSizePixel = 0
	sideBox.ClipsDescendants = true
	sideBox.Parent = main
	corner(sideBox, STYLE.PanelRadius)
	stroke(sideBox, 1)

	local side = Instance.new("ScrollingFrame")
	side.Name = "Side"
	side.BackgroundTransparency = 1
	side.BorderSizePixel = 0
	side.ScrollBarThickness = 0
	side.CanvasSize = UDim2.new()
	side.AutomaticCanvasSize = Enum.AutomaticSize.Y
	side.ScrollingDirection = Enum.ScrollingDirection.Y
	side.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
	side.Parent = sideBox

	local sideList = Instance.new("UIListLayout")
	sideList.Padding = UDim.new(0, STYLE.TabGap)
	sideList.SortOrder = Enum.SortOrder.LayoutOrder
	sideList.Parent = side

	local page = Instance.new("Frame")
	page.Name = "Page"
	page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	page.BackgroundTransparency = STYLE.PanelTr
	page.BorderSizePixel = 0
	page.ClipsDescendants = true
	page.Parent = main
	corner(page, STYLE.PanelRadius)
	stroke(page, 1)

	content = Instance.new("ScrollingFrame")
	content.Name = "Content"
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.ScrollBarThickness = 0
	content.CanvasSize = UDim2.new()
	content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	content.ScrollingDirection = Enum.ScrollingDirection.Y
	content.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
	content.Parent = page

	local contentList = Instance.new("UIListLayout")
	contentList.Padding = UDim.new(0, 10)
	contentList.SortOrder = Enum.SortOrder.LayoutOrder
	contentList.Parent = content

	local contentScale = Instance.new("UIScale")
	contentScale.Scale = 1
	contentScale.Parent = content

	local bottomDrag = Instance.new("Frame")
	bottomDrag.Name = "BottomDrag"
	bottomDrag.Size = UDim2.fromOffset(62, 4)
	bottomDrag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	bottomDrag.BackgroundTransparency = 0.42
	bottomDrag.BorderSizePixel = 0
	bottomDrag.ZIndex = 22
	bottomDrag.Parent = main
	corner(bottomDrag, 4)

	local bottomDragHitbox = Instance.new("TextButton")
	bottomDragHitbox.Name = "BottomDragHitbox"
	bottomDragHitbox.Text = ""
	bottomDragHitbox.BackgroundTransparency = 1
	bottomDragHitbox.BorderSizePixel = 0
	bottomDragHitbox.AutoButtonColor = false
	bottomDragHitbox.Active = true
	bottomDragHitbox.ZIndex = 21
	bottomDragHitbox.Parent = main

	local resize = Instance.new("TextButton")
	resize.Name = "Resize"
	resize.Text = ""
	resize.Font = IOS_FONT_MEDIUM
	resize.TextSize = 12
	resize.TextColor3 = STYLE.Text
	resize.BackgroundTransparency = 1
	resize.BorderSizePixel = 0
	resize.AutoButtonColor = false
	resize.ZIndex = 24
	resize.Parent = main

	local resizeGlyphH = Instance.new("Frame")
	resizeGlyphH.Name = "ResizeGlyphH"
	resizeGlyphH.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	resizeGlyphH.BackgroundTransparency = 0.16
	resizeGlyphH.BorderSizePixel = 0
	resizeGlyphH.ZIndex = 25
	resizeGlyphH.Parent = resize
	corner(resizeGlyphH, 2)

	local resizeGlyphDot = Instance.new("Frame")
	resizeGlyphDot.Name = "ResizeGlyphDot"
	resizeGlyphDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	resizeGlyphDot.BackgroundTransparency = 0.08
	resizeGlyphDot.BorderSizePixel = 0
	resizeGlyphDot.ZIndex = 26
	resizeGlyphDot.Parent = resize
	corner(resizeGlyphDot, 100)

	local resizeGlyphV = Instance.new("Frame")
	resizeGlyphV.Name = "ResizeGlyphV"
	resizeGlyphV.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	resizeGlyphV.BackgroundTransparency = 0.16
	resizeGlyphV.BorderSizePixel = 0
	resizeGlyphV.ZIndex = 25
	resizeGlyphV.Parent = resize
	corner(resizeGlyphV, 2)

	local island = Instance.new("TextButton")
	island.Name = "DynamicIsland"
	island.AnchorPoint = Vector2.new(0.5, 0)
	local defaultIslandY = math.min(16 + (instanceIndex - 1) * (mobile and 38 or 44), math.max(8, viewport.Y - (mobile and 42 or 48)))
	island.Position = cfg.IslandPosition or UDim2.new(0.5, 0, 0, defaultIslandY)
	island.Size = UDim2.fromOffset(mobile and 138 or 160, mobile and 32 or 36)
	island.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	island.BackgroundTransparency = 0.06
	island.BorderSizePixel = 0
	island.Text = ""
	island.AutoButtonColor = false
	island.ClipsDescendants = true
	island.Parent = gui
	corner(island, 100)
	stroke(island, 0.76)

	local islandScale = Instance.new("UIScale")
	islandScale.Scale = 1
	islandScale.Parent = island

	local islandDot = Instance.new("Frame")
	islandDot.Size = UDim2.fromOffset(mobile and 7 or 8, mobile and 7 or 8)
	islandDot.Position = UDim2.new(0, mobile and 12 or 14, 0.5, mobile and -3.5 or -4)
	islandDot.BackgroundColor3 = Color3.fromRGB(100, 255, 130)
	islandDot.BorderSizePixel = 0
	islandDot.Parent = island
	corner(islandDot, 100)

	local islandDotScale = Instance.new("UIScale")
	islandDotScale.Scale = 1
	islandDotScale.Parent = islandDot

	local islandText = label(island, cfg.Title or "落叶 Pro", mobile and 11 or 12, UDim2.fromOffset(mobile and 24 or 28, 0), UDim2.new(1, mobile and -34 or -42, 1, 0), true)
	islandText.TextXAlignment = Enum.TextXAlignment.Center

	local statusCancel
	local function islandStatus(text, color, delayTime)
		if lifecycleCleaning then return end
		if statusCancel then statusCancel(); statusCancel = nil end
		islandText.Text = text or (cfg.Title or "落叶 Pro")
		islandDot.BackgroundColor3 = color or Color3.fromRGB(100, 255, 130)
		islandText.TextTransparency = 0.32
		islandDotScale.Scale = 0.68
		tw(islandText, 0.22, {TextTransparency = 0}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		tw(islandDotScale, 0.30, {Scale = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		if delayTime then
			local oldText = islandText.Text
			statusCancel = windowScope:Delay(delayTime, function()
				if islandText and islandText.Parent and islandText.Text == oldText then
					islandText.Text = cfg.Title or "落叶 Pro"
					islandDot.BackgroundColor3 = Color3.fromRGB(100, 255, 130)
				end
			end)
		end
	end

	local function currentViewport()
		return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or viewport
	end

	local function clampGuiPosition(obj, pos, margin)
		local vp = currentViewport()
		local size = obj == main and Vector2.new(
			main.Size.X.Scale * vp.X + main.Size.X.Offset,
			main.Size.Y.Scale * vp.Y + main.Size.Y.Offset) or obj.AbsoluteSize
		local anchor = obj.AnchorPoint
		margin = margin or 6

		local px = pos.X.Scale * vp.X + pos.X.Offset
		local py = pos.Y.Scale * vp.Y + pos.Y.Offset
		local minX = margin + size.X * anchor.X
		local maxX = vp.X - margin - size.X * (1 - anchor.X)
		local minY = margin + size.Y * anchor.Y
		local maxY = vp.Y - margin - size.Y * (1 - anchor.Y)

		if maxX < minX then minX, maxX = vp.X * 0.5, vp.X * 0.5 end
		if maxY < minY then minY, maxY = vp.Y * 0.5, vp.Y * 0.5 end

		local cx = clamp(px, minX, maxX)
		local cy = clamp(py, minY, maxY)
		return UDim2.new(pos.X.Scale, pos.X.Offset + (cx - px), pos.Y.Scale, pos.Y.Offset + (cy - py))
	end

	local function clampMainPosition(pos)
		return clampGuiPosition(main, pos, mobile and 6 or 10)
	end

	local function clampIslandPosition(pos)
		return clampGuiPosition(island, pos, mobile and 6 or 10)
	end

	local function relayout()
		local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or viewport
		if mobile then
			STYLE.MaxW = math.max(STYLE.MinW, vp.X - 12)
			STYLE.MaxH = math.max(STYLE.MinH, vp.Y - 30)
		end

		local w = math.max(main.Size.X.Scale * vp.X + main.Size.X.Offset, STYLE.MinW)
		local h = math.max(main.Size.Y.Scale * vp.Y + main.Size.Y.Offset, STYLE.MinH)

		local sideRatio = mobile and (portrait and 0.22 or 0.18) or 0.24
		local topRatio = mobile and (portrait and 0.145 or 0.13) or 0.16

		local sideW = clamp(math.floor(w * sideRatio), STYLE.SideMin, STYLE.SideMax)
		local topH = clamp(
			math.floor(h * topRatio),
			mobile and (portrait and 46 or 48) or 58,
			mobile and (portrait and 56 or 56) or 72
		)

		top.Position = UDim2.fromOffset(0, 0)
		top.Size = UDim2.new(1, 0, 0, topH)

		title.TextSize = STYLE.TopTitle
		title.Position = UDim2.fromOffset(STYLE.TextX, mobile and (portrait and 8 or 9) or 13)
		title.Size = UDim2.fromOffset(mobile and 140 or 160, mobile and 16 or 18)

		sub.TextSize = STYLE.TopSub
		sub.Position = UDim2.fromOffset(STYLE.TextX, mobile and (portrait and 24 or 25) or 32)
		sub.Size = UDim2.fromOffset(mobile and 150 or 180, mobile and 13 or 16)

		tagHolder.Position = UDim2.fromOffset(mobile and (portrait and 150 or 166) or 200, mobile and (portrait and 10 or 11) or 14)
		tagHolder.Size = UDim2.new(1, mobile and (portrait and -240 or -255) or -330, 0, mobile and 24 or 28)

		local topButtonY = mobile and (portrait and 10 or 11) or 16
		local topButtonSize = mobile and 26 or 32
		local closeOffset = mobile and -40 or -54
		local miniGap = mobile and 1 or 2

		close.Position = UDim2.new(1, closeOffset, 0, topButtonY)
		close.Size = UDim2.fromOffset(topButtonSize, topButtonSize)
		close.TextSize = mobile and 19 or 24

		mini.Position = UDim2.new(1, closeOffset - topButtonSize - miniGap, 0, topButtonY)
		mini.Size = UDim2.fromOffset(topButtonSize, topButtonSize)
		mini.TextSize = mobile and 20 or 24

		local panelTopGap = mobile and (portrait and 2 or 3) or 4
		local bottomKeep = mobile and (portrait and 22 or 24) or 28
		local innerPad = mobile and (portrait and 9 or 10) or 12

		sideBox.Position = UDim2.fromOffset(STYLE.Pad, topH + panelTopGap)
		sideBox.Size = UDim2.new(0, sideW, 1, -(topH + bottomKeep))

		side.Position = UDim2.fromOffset(mobile and 6 or 8, mobile and 6 or 8)
		side.Size = UDim2.new(1, -(mobile and 12 or 16), 1, -(mobile and 12 or 16))

		page.Position = UDim2.fromOffset(STYLE.Pad + sideW + STYLE.Gap, topH + panelTopGap)
		page.Size = UDim2.new(1, -(STYLE.Pad * 2 + sideW + STYLE.Gap), 1, -(topH + bottomKeep))

		content.Position = UDim2.fromOffset(innerPad, innerPad)
		content.Size = UDim2.new(1, -(innerPad * 2), 1, -(innerPad * 2))

		local dragW = clamp(math.floor(w * (mobile and 0.20 or 0.18)), mobile and 66 or 74, mobile and 110 or 132)
		local dragH = clamp(math.floor(h * 0.014), mobile and 5 or 4, mobile and 7 or 6)
		local dragBottom = clamp(math.floor(h * (mobile and 0.032 or 0.029)), mobile and 10 or 11, mobile and 17 or 19)

		bottomDrag.Size = UDim2.fromOffset(dragW, dragH)
		bottomDrag.Position = UDim2.new(0.5, -math.floor(dragW / 2), 1, -(dragBottom + dragH))

		local minHitW = mobile and 156 or 144
		local maxHitW = math.max(minHitW, w - (mobile and 36 or 72))
		local hitW = clamp(math.floor(w * (mobile and 0.46 or 0.38)), minHitW, maxHitW)
		local hitH = mobile and 36 or 28
		local hitY = dragBottom + dragH + math.floor((hitH - dragH) / 2)
		bottomDragHitbox.Size = UDim2.fromOffset(hitW, hitH)
		bottomDragHitbox.Position = UDim2.new(0.5, -math.floor(hitW / 2), 1, -hitY)

		local handleBox = clamp(math.floor(math.min(w, h) * (mobile and 0.078 or 0.068)), mobile and 32 or 34, mobile and 42 or 46)
		local handleInset = mobile and 11 or 12
		resize.Size = UDim2.fromOffset(handleBox, handleBox)
		resize.Position = UDim2.new(1, -(handleInset + handleBox), 1, -(handleInset + handleBox))

		local dotSize = clamp(math.floor(handleBox * 0.28), mobile and 9 or 10, mobile and 13 or 14)
		local barThickness = clamp(math.floor(handleBox * 0.11), 3, 4)
		local segLen = clamp(math.floor(handleBox * 0.24), mobile and 8 or 9, mobile and 11 or 12)
		local gap = clamp(math.floor(handleBox * 0.07), 2, 4)

		local dotCenterX = math.floor(handleBox * 0.64)
		local dotCenterY = math.floor(handleBox * 0.70)
		local dotX = clamp(dotCenterX - math.floor(dotSize / 2), 7, handleBox - dotSize - 5)
		local dotY = clamp(dotCenterY - math.floor(dotSize / 2), 9, handleBox - dotSize - 4)

		local hRight = dotX - gap
		local hX = clamp(hRight - segLen, 3, handleBox - segLen - 3)
		local hY = clamp(dotCenterY - math.floor(barThickness / 2), 10, handleBox - barThickness - 3)

		local vX = clamp(dotCenterX - math.floor(barThickness / 2), 10, handleBox - barThickness - 4)
		local vBottom = dotY - gap
		local vY = clamp(vBottom - segLen, 3, handleBox - segLen - 3)

		resizeGlyphH.Size = UDim2.fromOffset(segLen, barThickness)
		resizeGlyphH.Position = UDim2.fromOffset(hX, hY)

		resizeGlyphDot.Size = UDim2.fromOffset(dotSize, dotSize)
		resizeGlyphDot.Position = UDim2.fromOffset(dotX, dotY)

		resizeGlyphV.Size = UDim2.fromOffset(barThickness, segLen)
		resizeGlyphV.Position = UDim2.fromOffset(vX, vY)
	end

	relayout()
	connect(main:GetPropertyChangedSignal("Size"), relayout)

	pointer = newPointerRouter(windowScope, function(locked)
		if content.Parent then content.ScrollingEnabled = not locked end
	end)

	local function clearContent()
		clearPageConns()
		content.ScrollingEnabled = true
		for _, v in ipairs(content:GetChildren()) do
			if v:IsA("GuiObject") and v ~= contentList and v ~= contentScale then
				v:Destroy()
			end
		end
	end

	local function renderTab(tab)
		if lifecycleCleaning then return end
		clearContent()
		content.CanvasPosition = Vector2.zero
		for _, builder in ipairs(tab.Builders) do
			pcall(builder)
		end

		if state == "open" then
			contentScale.Scale = mobile and 0.985 or 0.975
			tw(contentScale, mobile and 0.20 or 0.24, {Scale = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		else
			contentScale.Scale = 1
		end
	end

	local function setTab(tab, on)
		if not tab then return end
		tw(tab._Button, 0.18, {BackgroundTransparency = on and 0.82 or 1}, Enum.EasingStyle.Sine)
		tw(tab._Bar, 0.18, {
			BackgroundTransparency = on and 0 or 1,
			Size = on and UDim2.fromOffset(3, mobile and 18 or 20) or UDim2.fromOffset(3, mobile and 12 or 14),
		}, Enum.EasingStyle.Quint)

		if tab._Scale then
			if on then
				tab._Scale.Scale = 0.96
				tw(tab._Scale, 0.24, {Scale = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			else
				tw(tab._Scale, 0.14, {Scale = 1}, Enum.EasingStyle.Sine)
			end
		end

		tab._Text.TextColor3 = on and STYLE.Text or Color3.fromRGB(205, 205, 214)
	end

	local function selectTab(tab)
		if lifecycleCleaning or type(tab) ~= "table" or tab._Owner ~= tabOwner or activeTab == tab then return end
		setTab(activeTab, false)
		activeTab = tab
		setTab(tab, true)
		renderTab(tab)
	end

	local boundCamera
	local function updateViewport()
		local camera = workspace.CurrentCamera
		if not camera or lifecycleCleaning then return end
		local oldPortrait = portrait
		viewport = camera.ViewportSize
		refreshResponsiveStyle(viewport)
		if mobile then
			main.Size = UDim2.fromOffset(
				clamp(main.Size.X.Scale * viewport.X + main.Size.X.Offset, STYLE.MinW, STYLE.MaxW),
				clamp(main.Size.Y.Scale * viewport.Y + main.Size.Y.Offset, STYLE.MinH, STYLE.MaxH))
		end
		relayout()
		savedPos = clampMainPosition(savedPos)
		if state == "open" or state == "closed" then main.Position = savedPos end
		island.Position = clampIslandPosition(island.Position)
		if activeTab and oldPortrait ~= portrait then renderTab(activeTab) end
	end

	local function bindViewport()
		cameraScope:Clean()
		local camera = workspace.CurrentCamera
		if boundCamera and boundCamera ~= camera then
			local oldBlur = boundCamera:FindFirstChild(BACKDROP_BLUR_NAME)
			if oldBlur and oldBlur:IsA("BlurEffect") then oldBlur:Destroy() end
		end
		boundCamera = camera
		if not camera then return end
		updateViewport()
		syncBackdropBlur(0.18)
		cameraScope:Connect(camera:GetPropertyChangedSignal("ViewportSize"), updateViewport)
	end

	connect(workspace:GetPropertyChangedSignal("CurrentCamera"), bindViewport)
	bindViewport()

	local islandMoved = false
	local function beginDrag(input)
		if state ~= "open" then return end
		local dragStart, startPos = input.Position, main.Position
		pointer:Begin(input, function(move)
			local d = move.Position - dragStart
			main.Position = clampMainPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y))
			savedPos = main.Position
		end)
	end

	connect(top.InputBegan, function(input)
		for _, button in ipairs({mini, close}) do
			local p, size = button.AbsolutePosition, button.AbsoluteSize
			if input.Position.X >= p.X and input.Position.X <= p.X + size.X
				and input.Position.Y >= p.Y and input.Position.Y <= p.Y + size.Y then return end
		end
		beginDrag(input)
	end)
	connect(bottomDrag.InputBegan, beginDrag)
	connect(bottomDragHitbox.InputBegan, beginDrag)
	connect(resize.InputBegan, function(input)
		if state ~= "open" then return end
		local resizeStart, startSize = input.Position, main.AbsoluteSize
		local startPosition = main.Position
		pointer:Begin(input, function(move)
			local d = move.Position - resizeStart
			local vp = currentViewport()
			local maxW = mobile and math.max(STYLE.MinW, vp.X - 12) or STYLE.MaxW
			local maxH = mobile and math.max(STYLE.MinH, vp.Y - 30) or STYLE.MaxH
			local width = clamp(startSize.X + d.X, STYLE.MinW, maxW)
			local height = clamp(startSize.Y + d.Y, STYLE.MinH, maxH)
			main.Size = UDim2.fromOffset(width, height)
			main.Position = clampMainPosition(UDim2.new(startPosition.X.Scale,
				startPosition.X.Offset + (width - startSize.X) * main.AnchorPoint.X,
				startPosition.Y.Scale, startPosition.Y.Offset + (height - startSize.Y) * main.AnchorPoint.Y))
			savedPos = main.Position
		end)
	end)
	connect(island.InputBegan, function(input)
		if state ~= "open" and state ~= "closed" then return end
		local start, position = input.Position, island.Position
		if pointer:Begin(input, function(move)
			local d = move.Position - start
			if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then islandMoved = true end
			island.Position = clampIslandPosition(UDim2.new(position.X.Scale, position.X.Offset + d.X,
				position.Y.Scale, position.Y.Offset + d.Y))
		end, nil, false) then islandMoved = false end
	end)

	local motionId = 0
	local function clearMotion()
		motionId += 1
		motionScope:Clean()
		motionSheen.Visible = false
	end

	local function cleanupConnections()
		if lifecycleCleaning then return end
		lifecycleCleaning = true
		state = "destroyed"
		gui:SetAttribute("ApplePureUIBlurActive", false)
		clearMotion()
		clearPageConns()
		pageScope:Destroy()
		cameraScope:Destroy()
		motionScope:Destroy()
		windowScope:Destroy()
		table.clear(keybinds)
		task.defer(function() syncBackdropBlur(0.24) end)
	end

	connect(gui.Destroying, cleanupConnections)

	local function playTween(obj, time, props, style, dir)
		return motionScope:Tween(obj, time, props, style, dir)
	end

	local islandBaseW = mobile and 138 or 160
	local islandBaseH = mobile and 32 or 36

	local function setBackdropBlurActive(active, duration)
		if not realBlurEnabled then return end
		if gui and gui.Parent then
			gui:SetAttribute("ApplePureUIBlurActive", active == true)
		end
		syncBackdropBlur(duration)
	end

	local function islandMorphPosition()
		local absolutePosition = island.AbsolutePosition
		local absoluteSize = island.AbsoluteSize
		local x = absolutePosition.X + absoluteSize.X * 0.5
		local y = absolutePosition.Y + absoluteSize.Y * 0.5 + (mobile and 3 or 4)
		return UDim2.fromOffset(math.floor(x + 0.5), math.floor(y + 0.5))
	end

	local function islandReady()
		playTween(islandScale, 0.18, {Scale = 1.018}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		playTween(island, 0.20, {
			Size = UDim2.fromOffset(islandBaseW + (mobile and 12 or 16), islandBaseH + 2),
			BackgroundTransparency = 0.035,
		}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	end

	local function islandNormal()
		playTween(islandScale, 0.24, {Scale = 1}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		playTween(island, 0.26, {
			Size = UDim2.fromOffset(islandBaseW, islandBaseH),
			BackgroundTransparency = 0.06,
		}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	end

	local function playSheen(id, delayTime)
		motionScope:Delay(delayTime or 0, function()
			if motionId ~= id or not motionSheen.Parent then return end
			motionSheen.Visible = true
			glass.SheenGradient.Offset = Vector2.new(-0.65, 0)
			playTween(glass.SheenGradient, mobile and 0.42 or 0.48, {
				Offset = Vector2.new(0.65, 0),
			}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

			motionScope:Delay(mobile and 0.44 or 0.50, function()
				if motionId == id and motionSheen.Parent then
					motionSheen.Visible = false
				end
			end)
		end)
	end

	local function restoreOpenVisual(position)
		main.Visible = true
		main.Position = clampMainPosition(position)
		savedPos = main.Position
		main.Rotation = 0
		main.BackgroundTransparency = STYLE.MainTr
		mainStroke.Transparency = glass.RimTransparency
		contentScale.Scale = 1
		scale.Scale = 1
	end

	local function restoreClosedVisual(position)
		main.Visible = false
		main.Position = clampMainPosition(position)
		savedPos = main.Position
		main.Rotation = 0
		main.BackgroundTransparency = STYLE.MainTr
		mainStroke.Transparency = glass.RimTransparency
		contentScale.Scale = 1
		scale.Scale = 1
	end

	local function closeUI()
		if state ~= "open" or lifecycleCleaning then return end

		pointer:Finish(true)
		finishKeyCapture()
		clearMotion()
		local id = motionId
		state = "closing"

		local restingPos = clampMainPosition(main.Position)
		local morphPos = islandMorphPosition()
		savedPos = restingPos

		main.Visible = true
		main.Position = restingPos
		main.Rotation = 0
		scale.Scale = 1

		setBackdropBlurActive(false, mobile and 0.28 or 0.32)
		islandStatus("正在收起", Color3.fromRGB(255, 190, 80))
		islandReady()

		local duration = mobile and 0.38 or 0.42
		playTween(main, duration, {
			Position = morphPos,
			BackgroundTransparency = 1,
		}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		playTween(scale, duration, {Scale = mobile and 0.16 or 0.14}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		playTween(mainStroke, duration * 0.76, {Transparency = 0.98}, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
		playTween(contentScale, duration * 0.82, {Scale = 0.975}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

		motionScope:Delay(duration * 0.62, function()
			if motionId ~= id then return end
			islandNormal()
		end)

		motionScope:Delay(duration + 0.02, function()
			if motionId ~= id then return end
			restoreClosedVisual(restingPos)
			state = "closed"
			islandStatus("已收起", Color3.fromRGB(255, 190, 80), 0.72)
		end)
	end

	local function openUI(initial)
		if state ~= "closed" or lifecycleCleaning then return end

		clearMotion()
		local id = motionId
		state = "opening"

		local targetPos = clampMainPosition(savedPos)
		local morphPos = islandMorphPosition()
		savedPos = targetPos

		main.Visible = true
		main.Position = morphPos
		main.Rotation = 0
		main.BackgroundTransparency = 1
		mainStroke.Transparency = 0.98
		contentScale.Scale = 0.975
		scale.Scale = initial and (mobile and 0.13 or 0.12) or (mobile and 0.16 or 0.15)

		setBackdropBlurActive(true, initial and (mobile and 0.38 or 0.42) or (mobile and 0.30 or 0.34))
		islandStatus(initial and "正在载入" or "正在打开", Color3.fromRGB(100, 255, 130))
		islandReady()

		local duration = initial and (mobile and 0.50 or 0.56) or (mobile and 0.44 or 0.48)
		playTween(main, duration, {
			Position = targetPos,
			BackgroundTransparency = STYLE.MainTr,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		playTween(scale, duration, {Scale = 1.012}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		playTween(mainStroke, duration * 0.72, {Transparency = glass.RimTransparency}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		playTween(contentScale, duration * 0.86, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		playSheen(id, duration * 0.38)

		motionScope:Delay(duration * 0.70, function()
			if motionId ~= id then return end
			islandNormal()
		end)

		motionScope:Delay(duration * 0.84, function()
			if motionId ~= id then return end
			playTween(scale, 0.12, {Scale = 1}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		end)

		motionScope:Delay(duration + 0.13, function()
			if motionId ~= id then return end
			restoreOpenVisual(targetPos)
			state = "open"
			islandStatus(initial and "已就绪" or "已打开", Color3.fromRGB(100, 255, 130), 0.72)
		end)
	end

	connect(island.MouseButton1Click, function()
		if islandMoved then return end
		if state == "opening" or state == "closing" then return end

		if state == "open" then
			closeUI()
		elseif state == "closed" then
			openUI()
		end
	end)

	connect(mini.MouseButton1Click, closeUI)

	connect(close.MouseButton1Click, function()
		if state == "destroying" or lifecycleCleaning then return end
		pointer:Finish(true)
		finishKeyCapture()
		clearMotion()
		local id = motionId
		state = "destroying"

		local fromPos = clampMainPosition(main.Position)
		local morphPos = islandMorphPosition()
		savedPos = fromPos
		main.Visible = true
		main.Position = fromPos
		main.Rotation = 0

		setBackdropBlurActive(false, mobile and 0.24 or 0.28)
		islandStatus("正在关闭", Color3.fromRGB(255, 120, 120))
		islandReady()

		local duration = mobile and 0.34 or 0.38
		playTween(main, duration, {
			Position = morphPos,
			BackgroundTransparency = 1,
		}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		playTween(scale, duration, {Scale = mobile and 0.14 or 0.12}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		playTween(mainStroke, duration * 0.72, {Transparency = 1}, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

		motionScope:Delay(duration + 0.03, function()
			if motionId ~= id then return end
			if gui and gui.Parent then
				gui:SetAttribute("ApplePureUIBlurActive", false)
				gui:Destroy()
			end
			task.defer(function()
				syncBackdropBlur(0.24)
			end)
		end)
	end)

	local toggleKey
	if cfg.ToggleKey == false then
		toggleKey = nil
	elseif cfg.ToggleKey ~= nil then
		toggleKey = cfg.ToggleKey
	elseif instanceIndex == 1 then
		toggleKey = Enum.KeyCode.RightControl
	end
	connect(UIS.InputBegan, function(input, gp)
		if lifecycleCleaning or state == "destroying" or UIS:GetFocusedTextBox() then return end
		if keyCapture then
			local record = keyCapture
			if input.KeyCode == Enum.KeyCode.Escape then finishKeyCapture(); return end
			if gp or input.UserInputType ~= Enum.UserInputType.Keyboard
				or input.KeyCode == Enum.KeyCode.Unknown then return end
			record.Key = input.KeyCode
			record.Config._Current = record.Key
			record.Config.Key = record.Key
			finishKeyCapture()
			islandStatus("已绑定", Color3.fromRGB(100, 255, 130), 0.7)
			safe(record.Config.Changed, record.Key)
			return
		end
		if gp then return end
		if toggleKey and input.KeyCode == toggleKey then
			if state == "open" then closeUI() elseif state == "closed" then openUI() end
		end
		for _, record in ipairs(keybinds) do
			if lifecycleCleaning then break end
			if input.KeyCode == record.Key then
				islandStatus("快捷键触发", Color3.fromRGB(100, 255, 130), 0.7)
				safe(record.Config.Callback)
			end
		end
	end)

	local Window = {}
	Window.IsMobile = mobile
	Window.DeviceScale = mobile and 0.86 or 1
	Window.Gui = gui
	Window.Name = guiName
	Window.BaseName = baseGuiName

	function Window:Tag(tagCfg)
		if lifecycleCleaning then return nil end
		tagCfg = tagCfg or {}

		local f = Instance.new("Frame")
		f.Size = UDim2.fromOffset(tagCfg.Width or (mobile and 76 or 96), mobile and 24 or 30)
		f.BackgroundColor3 = STYLE.Accent
		f.BackgroundTransparency = 0.05
		f.BorderSizePixel = 0
		f.Parent = tagHolder
		corner(f, mobile and 12 or 15)

		local t = label(f, tagCfg.Title or "Tag", mobile and 11 or 13, UDim2.fromOffset(10, 0), UDim2.new(1, -20, 1, 0), true)
		t.TextColor3 = Color3.fromRGB(15, 20, 22)
		t.TextXAlignment = Enum.TextXAlignment.Center

		local obj = {}
		function obj:Set(v) t.Text = tostring(v) end
		function obj:SetTitle(v) t.Text = tostring(v) end
		return obj
	end

	function Window:Notify(data)
		if type(ApplePureUI.Notify) == "function" then
			ApplePureUI:Notify(data)
		end
	end

	function Window:SelectTab(tab)
		if tab then selectTab(tab) end
		return self
	end

	function Window:Destroy()
		if lifecycleCleaning then return end
		cleanupConnections()
		gui:Destroy()
	end

	local function cardBase(parent, h)
		local c = Instance.new("Frame")
		c.Size = UDim2.new(1, 0, 0, h)
		c.BackgroundColor3 = Color3.fromRGB(228, 235, 245)
		c.BackgroundTransparency = STYLE.CardTr
		c.BorderSizePixel = 0
		c.Parent = parent
		corner(c, STYLE.CardRadius)
		stroke(c, 0.90)
		return c
	end

	local function addBuilder(tab, fn)
		if lifecycleCleaning then return tab end
		table.insert(tab.Builders, fn)
		if activeTab == tab then
			pcall(fn)
		end
		return tab
	end

	function Window:Tab(tabCfg)
		if lifecycleCleaning then return nil end
		tabCfg = tabCfg or {}

		local tab = {
			Name = tabCfg.Title or tabCfg.Name or "Tab",
			Desc = tabCfg.Desc or "",
			Builders = {},
			_Owner = tabOwner,
		}

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, STYLE.TabH)
		btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		btn.BackgroundTransparency = 1
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.Parent = side
		corner(btn, 13)

		local bar = Instance.new("Frame")
		bar.Size = UDim2.fromOffset(3, mobile and 14 or 16)
		bar.Position = UDim2.fromOffset(mobile and 7 or 8, mobile and 8 or 10)
		bar.BackgroundColor3 = STYLE.Accent
		bar.BackgroundTransparency = 1
		bar.BorderSizePixel = 0
		bar.Parent = btn
		corner(bar, 3)

		local txt = label(btn, tab.Name, STYLE.SideSize, UDim2.fromOffset(mobile and 16 or 18, 0), UDim2.new(1, mobile and -20 or -24, 1, 0), false)
		txt.TextColor3 = Color3.fromRGB(205, 205, 214)

		local btnScale = Instance.new("UIScale")
		btnScale.Scale = 1
		btnScale.Parent = btn

		tab._Button = btn
		tab._Bar = bar
		tab._Text = txt
		tab._Scale = btnScale

		connect(btn.MouseButton1Click, function()
			selectTab(tab)
		end)

		function tab:Section(sectionCfg)
			if type(sectionCfg) == "string" then
				sectionCfg = {Title = sectionCfg}
			end
			sectionCfg = sectionCfg or {}

			return addBuilder(tab, function()
				local h = (sectionCfg.Desc and sectionCfg.Desc ~= "") and 58 or STYLE.SectionH
				local box = cardBase(content, h)

				local accent = Instance.new("Frame")
				accent.Size = UDim2.fromOffset(3, 18)
				accent.Position = UDim2.fromOffset(STYLE.TextX, 12)
				accent.BackgroundColor3 = STYLE.Accent
				accent.BorderSizePixel = 0
				accent.Parent = box
				corner(accent, 3)

				local titleText = label(box, sectionCfg.Title or "Section", STYLE.TitleSize, UDim2.fromOffset(STYLE.TextX + 12, 0), UDim2.new(1, -(STYLE.TextX + 24), sectionCfg.Desc and sectionCfg.Desc ~= "" and 0.55 or 1, 0), true)
				titleText.TextColor3 = STYLE.Text
				fitText(titleText, STYLE.TitleSize, mobile and 10 or 11, mobile and 13 or 15)

				if sectionCfg.Desc and sectionCfg.Desc ~= "" then
					local desc = label(box, sectionCfg.Desc, STYLE.DescSize, UDim2.fromOffset(STYLE.TextX + 12, 30), UDim2.new(1, -(STYLE.TextX + 24), 0, 18), false)
					desc.TextColor3 = STYLE.Sub
					fitText(desc, STYLE.DescSize, mobile and 8 or 9, mobile and 11 or 13)
				end
			end)
		end

		function tab:Divider()
			return addBuilder(tab, function()
				local line = Instance.new("Frame")
				line.Size = UDim2.new(1, -16, 0, 1)
				line.Position = UDim2.fromOffset(8, 0)
				line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				line.BackgroundTransparency = 0.94
				line.BorderSizePixel = 0
				line.Parent = content
			end)
		end

		function tab:Label(text)
			return addBuilder(tab, function()
				local holder = Instance.new("Frame")
				holder.Size = UDim2.new(1, 0, 0, 28)
				holder.BackgroundTransparency = 1
				holder.Parent = content
				local textLabel = label(holder, text or "Label", STYLE.TitleSize, UDim2.fromOffset(STYLE.TextX, 0), UDim2.new(1, -STYLE.TextX * 2, 1, 0), false)
				fitText(textLabel, STYLE.TitleSize, mobile and 10 or 11, mobile and 13 or 15)
			end)
		end

		function tab:Button(btnCfg)
			btnCfg = btnCfg or {}

			return addBuilder(tab, function()
				local b = Instance.new("TextButton")
				b.Size = UDim2.new(1, 0, 0, STYLE.RowH)
				b.BackgroundColor3 = Color3.fromRGB(228, 235, 245)
				b.BackgroundTransparency = STYLE.CardTr
				b.BorderSizePixel = 0
				b.Text = ""
				b.AutoButtonColor = false
				b.Parent = content
				corner(b, STYLE.CardRadius)
				stroke(b, 0.90)

				local titleText = label(b, btnCfg.Title or "Button", STYLE.TitleSize, UDim2.fromOffset(STYLE.TextX, 0), UDim2.new(1, -56, 1, 0), true)
				titleText.TextColor3 = STYLE.Text
				fitText(titleText, STYLE.TitleSize, mobile and 10 or 11, mobile and 13 or 15)

				local arrow = label(b, "›", 20, UDim2.new(1, -36, 0, 0), UDim2.fromOffset(20, STYLE.RowH), true)
				arrow.TextColor3 = STYLE.Text
				fitText(arrow, 20, 18, 22)

				connect(b.MouseButton1Down, function()
					tw(b, 0.10, {BackgroundTransparency = math.max(STYLE.CardTr - 0.08, 0)}, Enum.EasingStyle.Sine)
				end, true)

				connect(b.MouseButton1Up, function()
					tw(b, 0.14, {BackgroundTransparency = STYLE.CardTr}, Enum.EasingStyle.Sine)
				end, true)

				connect(b.MouseButton1Click, function()
					islandStatus("已点击", Color3.fromRGB(100, 255, 130), 0.7)
					safe(btnCfg.Callback)
				end, true)
			end)
		end

		function tab:Toggle(togCfg)
			togCfg = togCfg or {}

			return addBuilder(tab, function()
				if togCfg.Value == nil then togCfg.Value = false end
				local on = togCfg.Value == true
				local h = togCfg.Desc and togCfg.Desc ~= "" and 66 or STYLE.RowH

				local b = Instance.new("TextButton")
				b.Size = UDim2.new(1, 0, 0, h)
				b.BackgroundColor3 = Color3.fromRGB(228, 235, 245)
				b.BackgroundTransparency = STYLE.CardTr
				b.BorderSizePixel = 0
				b.Text = ""
				b.AutoButtonColor = false
				b.Parent = content
				corner(b, STYLE.CardRadius)
				stroke(b, 0.90)

				local hasDesc = togCfg.Desc and togCfg.Desc ~= ""
				local swW = mobile and 46 or 52
				local swH = mobile and 27 or 30
				local rightKeep = swW + (mobile and 26 or 34)
				local yTitle = hasDesc and 10 or 0
				local titleText = label(b, togCfg.Title or "Toggle", STYLE.TitleSize, UDim2.fromOffset(STYLE.TextX, yTitle), UDim2.new(1, -rightKeep, hasDesc and 0 or 1, hasDesc and 20 or 0), true)
				titleText.TextColor3 = STYLE.Text
				fitText(titleText, STYLE.TitleSize, mobile and 10 or 11, mobile and 13 or 15)

				if hasDesc then
					local desc = label(b, togCfg.Desc, STYLE.DescSize, UDim2.fromOffset(STYLE.TextX, 32), UDim2.new(1, -rightKeep, 0, 18), false)
					desc.TextColor3 = STYLE.Sub
					fitText(desc, STYLE.DescSize, mobile and 8 or 9, mobile and 11 or 13)
				end

				local sw = Instance.new("Frame")
				sw.Size = UDim2.fromOffset(swW, swH)
				sw.Position = UDim2.new(1, -(swW + 16), 0.5, -math.floor(swH / 2))
				sw.BackgroundColor3 = on and Color3.fromRGB(245, 246, 250) or Color3.fromRGB(96, 100, 112)
				sw.BackgroundTransparency = on and 0.05 or 0.16
				sw.BorderSizePixel = 0
				sw.Parent = b
				corner(sw, 100)

				local knobPad = 3
				local knobSize = swH - knobPad * 2
				local knobOnX = swW - knobSize - knobPad

				local knob = Instance.new("Frame")
				knob.Size = UDim2.fromOffset(knobSize, knobSize)
				knob.Position = on and UDim2.fromOffset(knobOnX, knobPad) or UDim2.fromOffset(knobPad, knobPad)
				knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				knob.BorderSizePixel = 0
				knob.Parent = sw
				corner(knob, 100)

				local function set(v)
					on = v == true
					togCfg.Value = on
					tw(sw, 0.18, {
						BackgroundColor3 = on and Color3.fromRGB(245, 246, 250) or Color3.fromRGB(96, 100, 112),
						BackgroundTransparency = on and 0.05 or 0.16,
					}, Enum.EasingStyle.Sine)

					tw(knob, 0.18, {
						Position = on and UDim2.fromOffset(knobOnX, knobPad) or UDim2.fromOffset(knobPad, knobPad),
					}, Enum.EasingStyle.Quint)

					islandStatus(on and "已开启" or "已关闭", on and Color3.fromRGB(100, 255, 130) or Color3.fromRGB(170, 170, 180), 0.7)
					safe(togCfg.Callback, on)
				end

				connect(b.MouseButton1Click, function()
					set(not on)
				end, true)
			end)
		end

		function tab:Slider(sliderCfg)
			sliderCfg = sliderCfg or {}

			return addBuilder(tab, function()
				local valueCfg = sliderCfg.Value
				local isTable = type(valueCfg) == "table"
				local minValue = tonumber(sliderCfg.Min) or (isTable and tonumber(valueCfg.Min)) or 0
				local maxValue = tonumber(sliderCfg.Max) or (isTable and tonumber(valueCfg.Max)) or 100
				if maxValue < minValue then minValue, maxValue = maxValue, minValue end

				local step = tonumber(sliderCfg.Step or sliderCfg.Increment or sliderCfg.StepSize) or 1
				if step <= 0 then step = 1 end

				local function decimalPlaces(n)
					local s = string.format("%.10f", math.abs(n))
					s = s:gsub("0+$", ""):gsub("%.$", "")
					local dot = string.find(s, ".", 1, true)
					return dot and (#s - dot) or 0
				end

				local precision = math.min(math.max(decimalPlaces(step), decimalPlaces(minValue), decimalPlaces(maxValue)), 6)
				local function quantize(v)
					if v <= minValue then return minValue end
					if v >= maxValue then return maxValue end
					v = minValue + math.floor(((v - minValue) / step) + 0.5) * step
					local factor = 10 ^ precision
					if factor > 1 then v = math.floor(v * factor + 0.5) / factor end
					return clamp(v, minValue, maxValue)
				end

				local function formatValue(v)
					if precision > 0 then
						return string.format("%." .. tostring(precision) .. "f", v)
					end
					return string.format("%.0f", v)
				end

				local default = tonumber(sliderCfg._Current) or tonumber(sliderCfg.Default) or (isTable and tonumber(valueCfg.Default or valueCfg.Value or valueCfg.Current)) or (not isTable and tonumber(valueCfg)) or minValue
				local value = quantize(clamp(default, minValue, maxValue))
				sliderCfg._Current = value

				local h = STYLE.SliderH
				local box = cardBase(content, h)

				local valueW = mobile and 54 or 64
				local titleText = label(box, sliderCfg.Title or "Slider", STYLE.TitleSize, UDim2.fromOffset(STYLE.TextX, 8), UDim2.new(1, -(valueW + STYLE.TextX + 18), 0, 20), true)
				titleText.TextColor3 = STYLE.Text
				fitText(titleText, STYLE.TitleSize, mobile and 10 or 11, mobile and 13 or 15)

				if sliderCfg.Desc and sliderCfg.Desc ~= "" then
					local desc = label(box, sliderCfg.Desc, STYLE.DescSize, UDim2.fromOffset(STYLE.TextX, 28), UDim2.new(1, -(valueW + STYLE.TextX + 18), 0, 16), false)
					desc.TextColor3 = STYLE.Sub
					fitText(desc, STYLE.DescSize, mobile and 8 or 9, mobile and 11 or 13)
				end

				local valueLabel = label(box, formatValue(value), 12, UDim2.new(1, -(valueW + STYLE.TextX), 0, 10), UDim2.fromOffset(valueW, 22), true)
				valueLabel.TextXAlignment = Enum.TextXAlignment.Right
				valueLabel.TextColor3 = STYLE.Accent
				fitText(valueLabel, 12, mobile and 10 or 11, mobile and 12 or 14)

				local bar = Instance.new("Frame")
				bar.Size = UDim2.new(1, -STYLE.TextX * 2, 0, 8)
				bar.Position = UDim2.fromOffset(STYLE.TextX, h - 22)
				bar.BackgroundColor3 = Color3.fromRGB(130, 130, 144)
				bar.BackgroundTransparency = 0.42
				bar.BorderSizePixel = 0
				bar.Parent = box
				corner(bar, 8)

				local fill = Instance.new("Frame")
				fill.BackgroundColor3 = STYLE.Accent
				fill.BackgroundTransparency = 0.06
				fill.BorderSizePixel = 0
				fill.Parent = bar
				corner(fill, 8)

				local knob = Instance.new("Frame")
				knob.Size = UDim2.fromOffset(18, 18)
				knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				knob.BorderSizePixel = 0
				knob.Parent = bar
				corner(knob, 100)

				local knobScale = Instance.new("UIScale")
				knobScale.Scale = 1
				knobScale.Parent = knob

				local hit = Instance.new("TextButton")
				hit.Text = ""
				hit.AutoButtonColor = false
				hit.BackgroundTransparency = 1
				hit.Position = UDim2.fromOffset(-12, -16)
				hit.Size = UDim2.new(1, 24, 0, 40)
				hit.Parent = bar

				local function redraw(animated)
					local range = maxValue - minValue
					local pct = range > 0 and (value - minValue) / range or 0
					local fillTarget = UDim2.new(pct, 0, 1, 0)
					local knobTarget = UDim2.new(pct, -9, 0.5, -9)
					if animated then
						tw(fill, 0.10, {Size = fillTarget}, Enum.EasingStyle.Quart)
						tw(knob, 0.10, {Position = knobTarget}, Enum.EasingStyle.Quart)
					else
						fill.Size = fillTarget
						knob.Position = knobTarget
					end
					valueLabel.Text = formatValue(value)
				end

				local function setFromX(x)
					local pct = clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
					local nextValue = pct <= 1e-9 and minValue
						or (pct >= 1 - 1e-9 and maxValue or quantize(minValue + (maxValue - minValue) * pct))
					if nextValue == value then return end
					value = nextValue
					sliderCfg._Current = value
					redraw(false)
					safe(sliderCfg.Callback, value)
				end

				redraw(false)

				connect(hit.InputBegan, function(input)
					if state ~= "open" then return end
					local began = pointer:Begin(input, function(move)
						setFromX(move.Position.X)
					end, function(cancelled)
						tw(knobScale, 0.18, {Scale = 1}, Enum.EasingStyle.Back)
						if not cancelled then
							islandStatus("数值 " .. formatValue(value), Color3.fromRGB(100, 255, 130), 0.7)
						end
					end)
					if began then
						tw(knobScale, 0.14, {Scale = 1.18}, Enum.EasingStyle.Back)
						setFromX(input.Position.X)
					end
				end, true)
			end)
		end

		function tab:Input(inputCfg)
			inputCfg = inputCfg or {}

			return addBuilder(tab, function()
				local b = cardBase(content, mobile and 64 or 68)
				local titleText = label(b, inputCfg.Title or "Input", STYLE.TitleSize, UDim2.fromOffset(STYLE.TextX, 8), UDim2.new(1, -STYLE.TextX * 2, 0, 20), true)
				titleText.TextColor3 = STYLE.Text
				fitText(titleText, STYLE.TitleSize, mobile and 10 or 11, mobile and 13 or 15)

				local box = Instance.new("TextBox")
				box.Size = UDim2.new(1, -STYLE.TextX * 2, 0, 30)
				box.Position = UDim2.fromOffset(STYLE.TextX, 34)
				box.BackgroundColor3 = Color3.fromRGB(230, 236, 245)
				box.BackgroundTransparency = 0.78
				box.BorderSizePixel = 0
				if inputCfg._Value == nil then inputCfg._Value = inputCfg.Value or "" end
				box.Text = tostring(inputCfg._Value)
				box.PlaceholderText = inputCfg.Placeholder or "Input."
				box.TextColor3 = STYLE.Text
				box.PlaceholderColor3 = Color3.fromRGB(170, 170, 180)
				box.Font = IOS_FONT_MEDIUM
				setTextBoxFit(box, 13, mobile and 11 or 12, mobile and 13 or 15)
				box.ClearTextOnFocus = false
				box.TextXAlignment = Enum.TextXAlignment.Left
				box.Parent = b
				corner(box, 12)
				pad(box, 10, 10, 0, 0)
				pageScope:Give(function() inputCfg._Value = box.Text end)
				connect(box:GetPropertyChangedSignal("Text"), function()
					inputCfg._Value = box.Text
				end, true)

				connect(box.FocusLost, function(enter)
					inputCfg._Value = box.Text
					inputCfg.Value = box.Text
					islandStatus("已输入", Color3.fromRGB(100, 255, 130), 0.7)
					safe(inputCfg.Callback, box.Text, enter)
				end, true)
			end)
		end

		function tab:Dropdown(dropCfg)
			dropCfg = dropCfg or {}

			return addBuilder(tab, function()
				local values = dropCfg.Values or {}
				local function optionText(value)
					if type(value) == "table" then
						return tostring(value.Title or value.Name or value.Value or "Item")
					end
					return tostring(value)
				end

				local function optionHeight(value, fallback)
					return type(value) == "table" and tostring(value.Desc or "") ~= "" and 42 or fallback
				end

				if dropCfg._SelectedText == nil then
					dropCfg._SelectedRaw = dropCfg.Value
					if dropCfg._SelectedRaw == nil then dropCfg._SelectedRaw = values[1] end
					dropCfg._SelectedText = dropCfg._SelectedRaw ~= nil and optionText(dropCfg._SelectedRaw) or "None"
				end

				local selected = tostring(dropCfg._SelectedText)
				local opened = false
				local baseH, itemH, gap = mobile and 50 or 54, 30, mobile and 5 or 6
				local visibleCount = math.min(#values, 5)
				local visibleHeight = 0

				if visibleCount == 0 then
					visibleHeight = itemH
				else
					for i = 1, visibleCount do
						visibleHeight += optionHeight(values[i], itemH)
						if i > 1 then visibleHeight += gap end
					end
				end

				local listBottomPad = 8
				local totalH = baseH + visibleHeight + listBottomPad
				local b = cardBase(content, baseH)
				b.ClipsDescendants = true

				local btnW = mobile and 0.48 or 0.50
				local titleText = label(b, dropCfg.Title or "Dropdown", STYLE.TitleSize, UDim2.fromOffset(STYLE.TextX, 0), UDim2.new(1 - btnW, -STYLE.TextX - 6, 0, baseH), true)
				titleText.TextColor3 = STYLE.Text
				fitText(titleText, STYLE.TitleSize, mobile and 10 or 11, mobile and 13 or 15)

				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(btnW, -STYLE.TextX, 0, mobile and 30 or 32)
				btn.Position = UDim2.new(1 - btnW, 0, 0, mobile and 10 or 11)
				btn.BackgroundColor3 = Color3.fromRGB(230, 236, 245)
				btn.BackgroundTransparency = 0.78
				btn.BorderSizePixel = 0
				btn.Text = selected .. "  ˅"
				btn.TextColor3 = STYLE.Text
				btn.Font = IOS_FONT_MEDIUM
				btn.TextSize = scaleTextSize(12, mobile and 10 or 11, mobile and 12 or 14)
				btn.TextTruncate = Enum.TextTruncate.AtEnd
				btn.ClipsDescendants = true
				btn.AutoButtonColor = false
				btn.Parent = b
				corner(btn, 12)

				local btnScale = Instance.new("UIScale")
				btnScale.Scale = 1
				btnScale.Parent = btn

				local list = Instance.new("ScrollingFrame")
				list.BackgroundTransparency = 1
				list.BorderSizePixel = 0
				list.Position = UDim2.fromOffset(STYLE.TextX, baseH)
				list.Size = UDim2.new(1, -STYLE.TextX * 2, 0, visibleHeight)
				list.CanvasSize = UDim2.new()
				list.AutomaticCanvasSize = Enum.AutomaticSize.Y
				list.ScrollingDirection = Enum.ScrollingDirection.Y
				list.ScrollBarThickness = #values > visibleCount and (mobile and 2 or 3) or 0
				list.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
				list.ScrollingEnabled = #values > visibleCount
				list.Parent = b

				local layout = Instance.new("UIListLayout")
				layout.Padding = UDim.new(0, gap)
				layout.SortOrder = Enum.SortOrder.LayoutOrder
				layout.Parent = list

				local function setOpen(v)
					opened = v == true
					if opened then list.CanvasPosition = Vector2.zero end
					tw(b, 0.24, {Size = UDim2.new(1, 0, 0, opened and totalH or baseH)}, Enum.EasingStyle.Quint)
					tw(btnScale, 0.20, {Scale = opened and 1.025 or 1}, Enum.EasingStyle.Back)
					btn.Text = selected .. (opened and "  ˄" or "  ˅")
				end

				connect(btn.MouseButton1Click, function()
					setOpen(not opened)
				end, true)

				for _, value in ipairs(values) do
					local rawValue = value
					local textValue = optionText(value)
					local itemDesc = ""
					local itemCallback

					if type(value) == "table" then
						itemDesc = tostring(value.Desc or "")
						itemCallback = value.Callback
					end

					local item = Instance.new("TextButton")
					item.Size = UDim2.new(1, -4, 0, optionHeight(value, itemH))
					item.BackgroundColor3 = Color3.fromRGB(230, 236, 245)
					item.BackgroundTransparency = 0.82
					item.BorderSizePixel = 0
					item.Text = ""
					item.AutoButtonColor = false
					item.Parent = list
					corner(item, 12)

					local itemTitle = label(item, textValue, 12, UDim2.fromOffset(12, 0), UDim2.new(1, -24, itemDesc ~= "" and 0.55 or 1, 0), true)
					itemTitle.TextColor3 = STYLE.Text
					fitText(itemTitle, 12, mobile and 10 or 11, mobile and 12 or 14)

					if itemDesc ~= "" then
						local desc = label(item, itemDesc, 10, UDim2.fromOffset(12, 22), UDim2.new(1, -24, 0, 14), false)
						desc.TextColor3 = STYLE.Sub
						fitText(desc, 10, 8, mobile and 10 or 12)
					end

					connect(item.MouseButton1Down, function()
						tw(item, 0.10, {BackgroundTransparency = 0.74}, Enum.EasingStyle.Sine)
					end, true)

					connect(item.MouseButton1Up, function()
						tw(item, 0.14, {BackgroundTransparency = 0.82}, Enum.EasingStyle.Sine)
					end, true)

					connect(item.MouseButton1Click, function()
						selected = textValue
						dropCfg._SelectedText = selected
						dropCfg._SelectedRaw = rawValue
						dropCfg.Value = rawValue
						btn.Text = selected .. "  ˅"
						setOpen(false)
						islandStatus("已选择", Color3.fromRGB(100, 255, 130), 0.7)
						safe(dropCfg.Callback, rawValue, textValue)
						safe(itemCallback, rawValue)
					end, true)
				end
			end)
		end

		function tab:Keybind(keyCfg)
			keyCfg = keyCfg or {}

			if lifecycleCleaning then return tab end
			local current = keyCfg._Current or keyCfg.Key or Enum.KeyCode.RightShift
			keyCfg._Current, keyCfg.Key = current, current
			local record = {Key = current, Config = keyCfg}
			table.insert(keybinds, record)

			return addBuilder(tab, function()
				local b = cardBase(content, STYLE.RowH)

				local keyW = mobile and 86 or 112
				local titleText = label(b, keyCfg.Title or "Keybind", STYLE.TitleSize, UDim2.fromOffset(STYLE.TextX, 0), UDim2.new(1, -(keyW + STYLE.TextX + 20), 1, 0), true)
				titleText.TextColor3 = STYLE.Text
				fitText(titleText, STYLE.TitleSize, mobile and 10 or 11, mobile and 13 or 15)

				local keyText = label(b, record.Key.Name, 12, UDim2.new(1, -(keyW + STYLE.TextX), 0.5, -15), UDim2.fromOffset(keyW, 30), true)
				keyText.TextXAlignment = Enum.TextXAlignment.Center
				keyText.TextColor3 = STYLE.Accent
				fitText(keyText, 12, mobile and 10 or 11, mobile and 12 or 14)

				record.Text = keyText
				pageScope:Give(function() record.Text = nil end)
				b.Active = true
				connect(b.InputBegan, function(input)
					if state ~= "open" then return end
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						finishKeyCapture()
						keyCapture = record
						keyText.Text = "..."
						keyCaptureCancel = pageScope:Delay(6, finishKeyCapture)
					end
				end, true)
			end)
		end

		function tab:Paragraph(pCfg)
			pCfg = pCfg or {}

			return addBuilder(tab, function()
				local descText = tostring(pCfg.Desc or pCfg.Content or "")
				local textSize = scaleTextSize(STYLE.DescSize, mobile and 8 or 9, mobile and 11 or 13)
				local availableWidth = math.max((content.AbsoluteSize.X > 0 and content.AbsoluteSize.X or main.AbsoluteSize.X) - STYLE.TextX * 2, 120)
				local measuredHeight = mobile and 34 or 38
				local ok, bounds = pcall(function()
					return TextService:GetTextSize(descText, textSize, IOS_FONT, Vector2.new(availableWidth, 10000))
				end)
				if ok and bounds then measuredHeight = bounds.Y end
				local ph = math.max(math.ceil(46 + measuredHeight), mobile and 78 or 84)
				local b = cardBase(content, ph)

				local titleText = label(b, pCfg.Title or "Paragraph", STYLE.TitleSize, UDim2.fromOffset(STYLE.TextX, 8), UDim2.new(1, -STYLE.TextX * 2, 0, 22), true)
				titleText.TextColor3 = STYLE.Text
				fitText(titleText, STYLE.TitleSize, mobile and 10 or 11, mobile and 13 or 15)

				local desc = label(b, descText, STYLE.DescSize, UDim2.fromOffset(STYLE.TextX, 32), UDim2.new(1, -STYLE.TextX * 2, 1, -38), false)
				desc.TextColor3 = STYLE.Sub
				desc.TextWrapped = true
				desc.TextTruncate = Enum.TextTruncate.None
				desc.TextYAlignment = Enum.TextYAlignment.Top
				fitText(desc, STYLE.DescSize, mobile and 8 or 9, mobile and 11 or 13)
				desc.TextTruncate = Enum.TextTruncate.None
				local function resizeParagraph()
					local width = math.max(b.AbsoluteSize.X / math.max(scale.Scale * contentScale.Scale, 0.001) - STYLE.TextX * 2, 1)
					local measured, size = pcall(function()
						return TextService:GetTextSize(descText, desc.TextSize, IOS_FONT, Vector2.new(width, 100000))
					end)
					if measured then
						local height = math.max(math.ceil(46 + size.Y), mobile and 78 or 84)
						if b.Size.Y.Offset ~= height then b.Size = UDim2.new(1, 0, 0, height) end
					end
				end
				connect(b:GetPropertyChangedSignal("AbsoluteSize"), resizeParagraph, true)
				resizeParagraph()
			end)
		end

		function tab:Card(t, d)
			return addBuilder(tab, function()
				local descText = tostring(d or "")
				local ch = descText ~= "" and (mobile and 64 or 68) or STYLE.RowH
				local b = cardBase(content, ch)

				local titleText = label(b, t or "Card", STYLE.TitleSize, UDim2.fromOffset(STYLE.TextX, descText ~= "" and 9 or 0), UDim2.new(1, -STYLE.TextX * 2, descText ~= "" and 0 or 1, descText ~= "" and 20 or 0), true)
				titleText.TextColor3 = STYLE.Text
				fitText(titleText, STYLE.TitleSize, mobile and 10 or 11, mobile and 13 or 15)

				if descText ~= "" then
					local desc = label(b, descText, STYLE.DescSize, UDim2.fromOffset(STYLE.TextX, 32), UDim2.new(1, -STYLE.TextX * 2, 0, mobile and 18 or 20), false)
					desc.TextColor3 = STYLE.Sub
					desc.TextTruncate = Enum.TextTruncate.AtEnd
					fitText(desc, STYLE.DescSize, mobile and 8 or 9, mobile and 11 or 13)
				end
			end)
		end

		if not activeTab then
			selectTab(tab)
		end

		return tab
	end

	if introEnabled then
		windowScope:Delay(0, function()
			if gui and gui.Parent and state == "closed" then
				openUI(true)
			end
		end)
	elseif realBlurEnabled then
		gui:SetAttribute("ApplePureUIBlurActive", true)
		windowScope:Delay(0, function()
			syncBackdropBlur(0.30)
		end)
	end

	return Window
end

function ApplePureUI:Notify(data)
	data = data or {}

	local playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not playerGui then return end

	local camera = workspace.CurrentCamera
	local vp = camera and camera.ViewportSize or Vector2.new(1280, 720)
	local notifyW = clamp(math.floor(vp.X * 0.28), 220, 300)
	local notifyH = math.max(220, vp.Y - 100)

	local gui = playerGui:FindFirstChild("ApplePureUI_Notify")
	if not gui then
		gui = Instance.new("ScreenGui")
		gui.Name = "ApplePureUI_Notify"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.DisplayOrder = 1000
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		gui.Parent = playerGui

		local holder = Instance.new("Frame")
		holder.Name = "Holder"
		holder.AnchorPoint = Vector2.new(1, 0)
		holder.BackgroundTransparency = 1
		holder.Size = UDim2.fromOffset(notifyW, notifyH)
		holder.Position = UDim2.new(1, -14, 0, 70)
		holder.Parent = gui

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 8)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = holder
	end

	local holder = gui:FindFirstChild("Holder")
	if not holder then return end
	holder.Size = UDim2.fromOffset(notifyW, notifyH)

	local cards = {}
	for _, child in ipairs(holder:GetChildren()) do
		if child:IsA("Frame") then table.insert(cards, child) end
	end
	while #cards >= 5 do
		local oldest = table.remove(cards, 1)
		if oldest then oldest:Destroy() end
	end

	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 0)
	card.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
	card.BackgroundTransparency = 1
	card.BorderSizePixel = 0
	card.ClipsDescendants = true
	card.Parent = holder
	corner(card, 15)
	stroke(card, 0.82)

	local cardScale = Instance.new("UIScale")
	cardScale.Scale = 0.94
	cardScale.Parent = card

	local titleText = label(card, data.Title or "提示", 13, UDim2.fromOffset(14, 8), UDim2.new(1, -28, 0, 18), true)
	local contentText = label(card, data.Content or "", 11, UDim2.fromOffset(14, 30), UDim2.new(1, -28, 0, 18), false)
	contentText.TextColor3 = Color3.fromRGB(205, 205, 214)
	titleText.TextTransparency = 1
	contentText.TextTransparency = 1

	TweenService:Create(card, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 0, 58),
		BackgroundTransparency = 0.16,
	}):Play()
	TweenService:Create(cardScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
	TweenService:Create(titleText, TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
	TweenService:Create(contentText, TweenInfo.new(0.26, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

	task.delay(data.Duration or 2, function()
		if not card.Parent then return end
		TweenService:Create(titleText, TweenInfo.new(0.14, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
		TweenService:Create(contentText, TweenInfo.new(0.14, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
		TweenService:Create(cardScale, TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.96}):Play()
		local hideTween = TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
		})
		hideTween:Play()

		task.delay(0.24, function()
			if card then card:Destroy() end
		end)
	end)
end

return ApplePureUI
