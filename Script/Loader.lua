--[[开源来自Yuxingchen｜工业垃圾禁止圈钱｜NOLSAKEN]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local tbl5 = {
	download_failed = "文件下载失败 请稍后重试",
	compile_failed = "下载内容无法编译 未执行该文件",
	ui_invalid = "UI 库返回的接口不完整 已停止加载",
	local_player_unavailable = "未能获取本地玩家 请进入游戏后重试",
}

local function fn(arg)
	warn("[落叶Pro] " .. (tbl5[arg] or "加载或执行失败 未输出远程地址和原始错误"))
end

local function fn7(arg)
	local ok, result = pcall(function()
		return game:HttpGet(arg)
	end)
	if ok and type(result) == "string" and result:find("%S") then
		return result
	end
	return nil
end

local function fn9(arg)
	local content = fn7(arg)
	if not content then
		error("download_failed", 0)
	end

	local ok, result = pcall(loadstring, content, "=LuoYeRemote")
	if not ok or type(result) ~= "function" then
		error("compile_failed", 0)
	end

	return result
end

local flag5 = false
local tbl3 = {}

local function fn10(arg)
	if flag5 or tbl3[arg.Title] then
		return
	end
	flag5 = true
	tbl3[arg.Title] = "loading"
	local ok, result = pcall(fn9, arg.Url)
	flag5 = false
	local result2 = result

	if ok then
		ok, result2 = pcall(function()
			result()
		end)
	end

	if ok then
		tbl3[arg.Title] = "loaded"
	else
		tbl3[arg.Title] = nil
		fn(result2)
	end
end

local ok, result = pcall(function()
	local localPlayer = Players.LocalPlayer
	if not localPlayer then
		error("local_player_unavailable", 0)
	end

	local lua = fn9("https://raw.githubusercontent.com/SyndromeXph/Luoye-Pro-Hub/refs/heads/main/Library.lua")
	local v12 = lua()

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

		v14:Button({
			Title = v16.Title,
			Callback = function()
				fn10(v16)
			end,
		})
	end
end)

if not ok then
	fn(type(result) == "string" and tbl5[result] and result or "loader_failed")
end
