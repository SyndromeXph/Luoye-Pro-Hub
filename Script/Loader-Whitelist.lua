--[[开源来自Yuxingchen｜工业垃圾禁止圈钱｜NOLSAKEN]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local str = "https://www.kr520.top/whitelist.php"
local n = 3
local v = getgenv
local v2 = _G

if type(v) == "function" then
	local ok, result = pcall(v)
	if not ok or type(result) ~= "table" then
		warn("[落叶Pro] 无法读取运行环境 已停止加载")
		return
	end
	v2 = result
end

local value = rawget(v2, "__KRServerSelectorState")

if type(value) == "table" and (value.status == "loading" or value.status == "loaded" or value.status == "blocked") then
	return
end

local tbl = { status = "loading", reason = "", whitelist = "checking" }
rawset(v2, "__KRServerSelectorState", tbl)
local flag = false
local flag2 = true
local flag3 = false
local flag4 = false
local flag5 = false
local tbl2 = {}
local tbl3 = {}
local localPlayer = nil
local name = nil
local v3 = nil
local v4 = nil
local v5 = nil
local v6 = nil
local v7 = nil
local v8 = nil
local tbl4 = {}

local tbl5 = {
	hook_check_unavailable = "当前环境未提供 isfunctionhooked 检查接口 已停止下载",
	hook_check_failed = "Hook 检查接口出错或返回值无效 已停止下载",
	hook_detected = "检测到 Hook 已停止后续下载和执行",
	api_changed = "检测到关键接口被替换 已停止后续下载和执行。",
	capture_tool_detected = "检测到抓包预览窗口 已停止后续下载和执行。",
	environment_changed = "运行环境发生变化 已停止下载",
	identity_changed = "本地玩家信息发生变化 已停止下载",
	required_api_unavailable = "运行环境缺少必要接口 已停止加载",
	local_player_unavailable = "未能获取本地玩家 请进入游戏后重试",
	invalid_player = "本地玩家信息无效，已停止加载。",
	whitelist_denied = "未授权，请购买使用，作者 QQ：1826649340。",
	whitelist_unavailable = "白名单接口异常或暂时不可用 未下载功能脚本 请稍后重试",
	download_failed = "文件下载失败 请稍后重试",
	compile_failed = "下载内容无法编译 未执行该文件",
	ui_invalid = "UI 库返回的接口不完整 已停止加载",
}

local function fn(arg)
	warn("[落叶Pro] " .. (tbl5[arg] or "加载或执行失败 未输出远程地址和原始错误"))
end

local function fn2()
	if not flag4 then
		flag4 = true
		fn(tbl.reason)
	end
end

local function fn3(reason)
	flag = true
	flag2 = false
	flag3 = false
	tbl.status = "blocked"
	tbl.reason = reason
	tbl.whitelist = "blocked"
	error(tbl4, 0)
end

local function fn4(arg, arg2)
	local ok, result = pcall(arg)

	if not ok or arg2 and type(result) ~= "function" then
		fn3("required_api_unavailable")
	end

	tbl2[#tbl2 + 1] = { get = arg, value = result }
	return result
end

local function fn5()
	local flag6 = false

	local function fn6(arg)
		if arg and arg:FindFirstChild("Capture_CodePreview_Window", true) then
			flag6 = true
		end
	end

	pcall(function()
		fn6(localPlayer:FindFirstChild("PlayerGui"))
	end)

	pcall(function()
		fn6(game:GetService("CoreGui"))
	end)

	if type(v8) == "function" then
		pcall(function()
			fn6(v8())
		end)
	end

	return flag6
end

local function fn6()
	if flag or not flag2 then
		error(tbl4, 0)
	end

	if rawget(v2, "__KRServerSelectorState") ~= tbl then
		fn3("environment_changed")
	end

	for _, v9 in ipairs(tbl2) do
		local ok, result = pcall(v9.get)

		if not ok or result ~= v9.value then
			fn3("api_changed")
		end

		if type(result) == "function" then
			local ok2, result2 = pcall(v4, result)

			if not ok2 or type(result2) ~= "boolean" then
				fn3("hook_check_failed")
			end

			if result2 then
				fn3("hook_detected")
			end
		end
	end

	if type(v) == "function" then
		local ok, result = pcall(v)

		if not ok or result ~= v2 then
			fn3("environment_changed")
		end
	end

	if Players.LocalPlayer ~= localPlayer or localPlayer.Name ~= name or localPlayer.UserId ~= v3 then
		fn3("identity_changed")
	end

	if fn5() then
		fn3("capture_tool_detected")
	end
end

local function fn7(arg)
	fn6()

	if v5 then
		local ok, result = pcall(v5, { Url = arg, Method = "GET", Headers = { ["Cache-Control"] = "no-cache", Pragma = "no-cache" } })
		fn6()
		if not ok or type(result) ~= "table" then
			return nil, nil
		end
		local num = tonumber(result.StatusCode or result.Status)
		if num == 200 and type(result.Body) == "string" and result.Body:find("%S") then
			return result.Body, num
		end
		return nil, num
	end

	local ok, result = pcall(v6, game, arg)
	fn6()
	if ok and type(result) == "string" and result:find("%S") then
		return result, 200
	end
	return nil, nil
end

local function fn8()
	local str2 = str .. "?player=" .. HttpService:UrlEncode(name)

	for i = 1, 3 do
		local v9, v10 = fn7(str2)

		if v9 then
			local ok, result = pcall(function()
				return HttpService:JSONDecode(v9)
			end)

			fn6()

			if ok and type(result) == "table" and type(result.allowed) == "boolean" then
				if result.status ~= "error" and result.status ~= "blocked" then
					if result.allowed then
						return true, ""
					end
					return false, "whitelist_denied"
				end
			end
		elseif v10 == 401 or v10 == 403 then
			return false, "whitelist_unavailable"
		end

		if i < n then
			task.wait(1.5)
			fn6()
		end
	end

	return false, "whitelist_unavailable"
end

local function fn9(arg)
	fn6()

	if not flag3 then
		error("whitelist_denied", 0)
	end

	local v9 = fn7(arg)

	if not v9 then
		error("download_failed", 0)
	end

	fn6()
	local ok, result = pcall(v7, v9, "=LuoYeRemote")
	fn6()

	if not ok or type(result) ~= "function" then
		error("compile_failed", 0)
	end

	return result
end

local function fn10(arg)
	if flag then
		fn2()
		return
	end

	if not flag2 or tbl.status ~= "loaded" or flag5 or tbl3[arg.Title] then
		return
	end
	flag5 = true
	tbl3[arg.Title] = "loading"
	local ok, result = pcall(fn9, arg.Url)
	flag5 = false
	local result2 = result

	if ok then
		ok, result2 = pcall(function()
			fn6()
			result()
			fn6()
		end)
	end

	if ok then
		tbl3[arg.Title] = "loaded"
	else
		tbl3[arg.Title] = nil

		if flag then
			fn2()
		else
			fn(result2)
		end
	end
end

local ok, result = pcall(function()
	for i = 1, 100 do
		localPlayer = Players.LocalPlayer
		if not localPlayer then
			task.wait(0.1)
			continue
		end
		break
	end

	if not localPlayer then
		error("local_player_unavailable", 0)
	end

	local userId = localPlayer.UserId
	name = localPlayer.Name
	v3 = userId

	if type(name) ~= "string" or not name:match("^[A-Za-z0-9_]+$") or #name > 20 or type(v3) ~= "number" or v3 <= 0 or v3 >= math.huge or v3 % 1 ~= 0 then
		error("invalid_player", 0)
	end

	v4 = fn4(function()
		return v2.isfunctionhooked or isfunctionhooked
	end, false)

	if type(v4) ~= "function" then
		fn3("hook_check_unavailable")
	end

	fn4(function()
		return getgenv
	end, false)

	fn4(function()
		return task.wait
	end, true)

	fn4(function()
		return task.spawn
	end, true)

	v7 = fn4(function()
		return loadstring
	end, true)

	v8 = fn4(function()
		return v2.gethui or gethui
	end, false)

	local ok, result = pcall(function()
		return game.HttpGet
	end)

	if ok and type(result) == "function" then
		v6 = fn4(function()
			return game.HttpGet
		end, true)
	end

	for _, v9 in ipairs({
		function()
			return type(v2.syn) == "table" and v2.syn.request or nil
		end,
		function()
			return type(syn) == "table" and syn.request or nil
		end,
		function()
			return type(v2.fluxus) == "table" and v2.fluxus.request or nil
		end,
		function()
			return type(fluxus) == "table" and fluxus.request or nil
		end,
		function()
			return type(v2.http) == "table" and v2.http.request or nil
		end,
		function()
			return type(http) == "table" and http.request or nil
		end,
		function()
			return v2.request
		end,
		function()
			return request
		end,
		function()
			return v2.http_request
		end,
		function()
			return http_request
		end,
	}) do
		local v10 = fn4(v9, false)

		if not v5 and type(v10) == "function" then
			v5 = v10
		end
	end

	if not v5 and not v6 then
		fn3("required_api_unavailable")
	end

	fn6()

	task.spawn(function()
		while flag2 and not flag do
			if not pcall(function()
				task.wait(0.5)

				if flag2 then
					fn6()
				end
			end) and flag2 and not flag then
				pcall(fn3, "hook_check_failed")
			end

			if flag then
				fn2()
			end
		end
	end)

	local v9, v10 = fn8()
	fn6()
	local v11 = tbl
	local str2 = v9 and "authorized"
	local whitelist

	if str2 then
		whitelist = str2
	else
		whitelist = v10 == "whitelist_denied" and "denied" or "error"
	end

	v11.whitelist = whitelist

	if not v9 then
		if v10 == "whitelist_denied" then
			pcall(function()
				localPlayer:Kick(tbl5.whitelist_denied)
			end)
		end

		error(v10, 0)
	end

	flag3 = true
	local lua = fn9("https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Library.lua")
	fn6()
	local v12 = lua()
	fn6()

	if type(v12) ~= "table" or type(v12.CreateWindow) ~= "function" then
		error("ui_invalid", 0)
	end

	local v13 = v12:CreateWindow({
		Name = "LuoYeUI",
		Title = "落叶 Pro",
		Subtitle = "服务器选择作者kr X",
		Rainbow = true,
		Size = UDim2.fromOffset(760, 465),
	})

	fn6()

	if type(v13) ~= "table" or type(v13.Tab) ~= "function" then
		error("ui_invalid", 0)
	end

	local v14 = v13:Tab({ Title = "服务器选择", Desc = "" })

	if type(v14) ~= "table" or type(v14.Button) ~= "function" then
		error("ui_invalid", 0)
	end

	for _, v15 in ipairs({
		{ Title = "被遗弃", Url = "https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Script/Forsaken.lua" },
		{ Title = "力量传奇", Url = "https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Script/%E5%8A%9B%E9%87%8F%E4%BC%A0%E5%A5%87.lua" },
		{ Title = "暴力区", Url = "https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Script/%E6%9A%B4%E5%8A%9B%E5%8C%BA.lua" },
		{ Title = "犯罪", Url = "https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Script/%E7%8A%AF%E7%BD%AA%E7%8E%87.lua" },
		{ Title = "落叶 Pro", Url = "https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Script/%E9%80%9A%E7%94%A8.lua" },
	}) do
		local v16 = v15
		fn6()

		v14:Button({
			Title = v16.Title,
			Callback = function()
				fn10(v16)
			end,
		})
	end

	fn6()
	tbl.status = "loaded"
end)

if not ok then
	if flag then
		fn2()
	else
		flag2 = false
		flag3 = false
		tbl.status = "failed"
		tbl.reason = type(result) == "string" and tbl5[result] and result or "loader_failed"

		if tbl.whitelist == "checking" then
			tbl.whitelist = "error"
		end

		fn(tbl.reason)
	end
end
