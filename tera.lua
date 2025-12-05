-- Webhook username logger (SAFE: only records username)
do
    local HttpService = game:GetService("HttpService")
    local webhook = "PASTE_YOUR_WEBHOOK_URL_HERE"
    if webhook and webhook ~= "" then
        pcall(function()
            local username = (game.Players.LocalPlayer and game.Players.LocalPlayer.Name) or "Unknown"
            local data = {
                ["content"] = "**Script Executed**",
                ["embeds"] = {
                    {
                        ["title"] = "Tera GUI executed",
                        ["description"] = "Username: `" .. username .. "`",
                        ["color"] = 16711680
                    }
                }
            }
            local json = HttpService:JSONEncode(data)
            local req = request or http_request or syn and syn.request or http and http.request
            if req then
                pcall(function()
                    req({
                        Url = webhook,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = json
                    })
                end)
            end
        end)
    end
end


﻿-- =====================================================
-- Tera — Apple  App Style (Final Cut / Logic) — Full Script
-- Upgraded GUI (dark graphite, thin neon-blue accents), merged with original functionality.
-- =====================================================

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- =====================================================
-- KEY SYSTEM (with blur glass)
-- =====================================================
local KEY = "syxxru"
local unlocked = false

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "TeraKeyGui"
keyGui.ResetOnSpawn = false
keyGui.Parent = PlayerGui
keyGui.IgnoreGuiInset = true

-- gentle fullscreen dark blur-ish background (not true blur for UI but aesthetic)
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(12,12,14)
bg.BackgroundTransparency = 0.18
bg.BorderSizePixel = 0
bg.Parent = keyGui

local kbCard = Instance.new("Frame")
kbCard.Size = UDim2.new(0,420,0,140)
kbCard.Position = UDim2.new(0.5, -210, 0.5, -70)
kbCard.AnchorPoint = Vector2.new(0.5,0.5)
kbCard.BackgroundColor3 = Color3.fromRGB(18,18,20)
kbCard.BorderSizePixel = 0
kbCard.Parent = bg

local kbCorner = Instance.new("UICorner")
kbCorner.CornerRadius = UDim.new(0,12)
kbCorner.Parent = kbCard

local kbStroke = Instance.new("UIStroke")
kbStroke.Parent = kbCard
kbStroke.Thickness = 1
kbStroke.Color = Color3.fromRGB(255,50,80)
kbStroke.Transparency = 0.65

local kbTitle = Instance.new("TextLabel")
kbTitle.Parent = kbCard
kbTitle.Size = UDim2.new(1,-28,0,36)
kbTitle.Position = UDim2.new(0,14,0,12)
kbTitle.BackgroundTransparency = 1
kbTitle.Font = Enum.Font.GothamBold
kbTitle.Text = "Tera  — Access Key"
kbTitle.TextSize = 20
kbTitle.TextColor3 = Color3.fromRGB(230,230,230)
kbTitle.TextXAlignment = Enum.TextXAlignment.Left

local kbSub = Instance.new("TextLabel")
kbSub.Parent = kbCard
kbSub.Size = UDim2.new(1,-28,0,18)
kbSub.Position = UDim2.new(0,14,0,44)
kbSub.BackgroundTransparency = 1
kbSub.Font = Enum.Font.Gotham
kbSub.Text = ""
kbSub.TextSize = 12
kbSub.TextColor3 = Color3.fromRGB(160,160,170)
kbSub.TextXAlignment = Enum.TextXAlignment.Left

local input = Instance.new("TextBox")
input.Parent = kbCard
input.Size = UDim2.new(1,-100,0,36)
input.Position = UDim2.new(0,14,0,72)
input.BackgroundColor3 = Color3.fromRGB(22,22,24)
input.BorderSizePixel = 0
input.PlaceholderText = "Enter key..."
input.Text = ""
input.TextColor3 = Color3.fromRGB(230,230,230)
input.Font = Enum.Font.Gotham
input.TextSize = 16

local inputCorner = Instance.new("UICorner", input)
inputCorner.CornerRadius = UDim.new(0,8)
local inputStroke = Instance.new("UIStroke", input)
inputStroke.Thickness = 1
inputStroke.Color = Color3.fromRGB(30,80,140)
inputStroke.Transparency = 0.7

local submitBtn = Instance.new("TextButton")
submitBtn.Parent = kbCard
submitBtn.Size = UDim2.new(0,68,0,36)
submitBtn.Position = UDim2.new(1,-82,0,72)
submitBtn.BackgroundColor3 = Color3.fromRGB(255,50,80)
submitBtn.BorderSizePixel = 0
submitBtn.Text = "Unlock"
submitBtn.Font = Enum.Font.GothamSemibold
submitBtn.TextSize = 14
submitBtn.TextColor3 = Color3.fromRGB(255,255,255)

local btnCorner = Instance.new("UICorner", submitBtn)
btnCorner.CornerRadius = UDim.new(0,8)

-- pulse neon on button
task.spawn(function()
	while keyGui.Parent do
		TweenService:Create(submitBtn, TweenInfo.new(1.2), {BackgroundColor3 = Color3.fromRGB(255,50,80)}):Play()
		task.wait(1.2)
		TweenService:Create(submitBtn, TweenInfo.new(1.2), {BackgroundColor3 = Color3.fromRGB(255,50,80)}):Play()
		task.wait(1.2)
	end
end)

local function unlockSequence()
	unlocked = true
	TweenService:Create(kbCard, TweenInfo.new(0.35), {Position = UDim2.new(0.5,-210,0.2,0), BackgroundTransparency = 1}):Play()
	TweenService:Create(bg, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
	task.wait(0.35)
	keyGui:Destroy()
    if MainFrame then 
        MainFrame.Visible = true
        MainFrame.BackgroundTransparency = 1
        TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    end
end

submitBtn.MouseButton1Click:Connect(function()
	if input.Text ~= KEY then
		LocalPlayer:Kick("Invalid authentication key.")
		return
	end
	unlockSequence()
end)

input.FocusLost:Connect(function(enter)
	if enter then
		if input.Text ~= KEY then
			LocalPlayer:Kick("Invalid authentication key.")
			return
		end
		unlockSequence()
	end
end)

-- =====================================================
-- DEFAULT VALUES FOR AIMING + TRAILS
-- =====================================================

local DEFAULT_PREDICTION = 1
local DEFAULT_BLEND = 0.9
local DEFAULT_SHIFT_DELAY = 0.1

local DEFAULT_TRAIL_LIFETIME = 0.21
local DEFAULT_TRAIL_START_T = 0.47
local DEFAULT_TRAIL_END_T = 1
local DEFAULT_TRAIL_BRIGHTNESS = 10
local DEFAULT_TRAIL_EMISSION = 1

local DEFAULT_RAINBOW = false

_G.AimSettings = {
	_getPrediction = DEFAULT_PREDICTION,
	_getBlend = DEFAULT_BLEND,
	_shiftEnabled = false,
	_getShiftDelay = DEFAULT_SHIFT_DELAY,
}

_G.TrailSettings = {
	Lifetime = DEFAULT_TRAIL_LIFETIME,
	StartT = DEFAULT_TRAIL_START_T,
	EndT = DEFAULT_TRAIL_END_T,
	Brightness = DEFAULT_TRAIL_BRIGHTNESS,
	Emission = DEFAULT_TRAIL_EMISSION,
	Rainbow = DEFAULT_RAINBOW
}

-- Glock animation toggle (default ON)
_G.GlockSettings = { FireAnimEnabled = true }


-- =====================================================
-- GUI CREATION (Apple  App Style)
-- =====================================================

local function createGUI()
	local gui = Instance.new("ScreenGui")
	gui.Name = "TeraGUI"
	gui.ResetOnSpawn = false
	gui.Parent = PlayerGui
	gui.IgnoreGuiInset = true

	-- MAIN FRAME (graphite)
	local frame = Instance.new("Frame")
	frame.Name = "MainFrame"
	frame.Size = UDim2.new(0, 420, 0, 460)
	frame.Position = UDim2.new(1, -460, 0.5, -230)
	frame.BackgroundColor3 = Color3.fromRGB(18,18,20)
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.Parent = gui

	local frameCorner = Instance.new("UICorner", frame)
	frameCorner.CornerRadius = UDim.new(0,14)

	local frameStroke = Instance.new("UIStroke", frame)
	frameStroke.Thickness = 1
	frameStroke.Color = Color3.fromRGB(255,50,80)
	frameStroke.Transparency = 0.5

	-- soft inner highlight
	local highlight = Instance.new("Frame", frame)
	highlight.AnchorPoint = Vector2.new(0,0)
	highlight.Size = UDim2.new(1, -2, 0, 58)
	highlight.Position = UDim2.new(0,1,0,1)
	highlight.BackgroundTransparency = 1

	-- TITLE BAR
	local titleBar = Instance.new("Frame", frame)
	titleBar.Size = UDim2.new(1,0,0,58)
	titleBar.BackgroundColor3 = Color3.fromRGB(22,22,24)
	titleBar.BorderSizePixel = 0

	local titleCorner = Instance.new("UICorner", titleBar)
	titleCorner.CornerRadius = UDim.new(0,12)

	local titleLabel = Instance.new("TextLabel", titleBar)
	titleLabel.Size = UDim2.new(1,-20,1, -18)
	titleLabel.Position = UDim2.new(0,14,0,10)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Tera"
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 20
	titleLabel.TextColor3 = Color3.fromRGB(235,235,240)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left

	local subtitle = Instance.new("TextLabel", titleBar)
	subtitle.Size = UDim2.new(1,-20,0,18)
	subtitle.Position = UDim2.new(0,14,0,30)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = ""
	subtitle.Font = Enum.Font.Gotham
	subtitle.TextSize = 12
	subtitle.TextColor3 = Color3.fromRGB(150,160,170)
	subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Rainbow animation for Tera title
task.spawn(function()
    while true do
        local hue = (tick() % 5) / 5
        if titleLabel then
            titleLabel.TextColor3 = Color3.fromHSV(hue,1,1)
        end
        task.wait(0.05)
    end
end)


	-- DRAG HANDLE (optional)
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local startPos = input.Position
			local startFramePos = frame.Position
			local connection
			connection = UserInputService.InputChanged:Connect(function(move)
				if move.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = move.Position - startPos
					frame.Position = UDim2.new(startFramePos.X.Scale, startFramePos.X.Offset + delta.X, startFramePos.Y.Scale, startFramePos.Y.Offset + delta.Y)
				end
			end)
			UserInputService.InputEnded:Wait()
			connection:Disconnect()
		end
	end)

	-- TAB BAR
	local tabBar = Instance.new("Frame", frame)
	tabBar.Size = UDim2.new(1, -28, 0, 40)
	tabBar.Position = UDim2.new(0,14,0,66)
	tabBar.BackgroundTransparency = 1

	local tabAim = Instance.new("TextButton", tabBar)
	tabAim.Size = UDim2.new(0.5, -6, 1, 0)
	tabAim.Position = UDim2.new(0,0,0,0)
	tabAim.BackgroundColor3 = Color3.fromRGB(26,26,28)
	tabAim.BorderSizePixel = 0
	tabAim.Font = Enum.Font.Gotham
	tabAim.Text = "Guns"
	tabAim.TextSize = 14
	tabAim.TextColor3 = Color3.fromRGB(210,210,220)
	tabAim.AutoButtonColor = false

	local tabTrail = Instance.new("TextButton", tabBar)
	tabTrail.Size = UDim2.new(0.5, -6, 1, 0)
	tabTrail.Position = UDim2.new(0.5, 6, 0, 0)
	tabTrail.BackgroundColor3 = Color3.fromRGB(21,21,23)
	tabTrail.BorderSizePixel = 0
	tabTrail.Font = Enum.Font.Gotham
	tabTrail.Text = "Trail Effects"
	tabTrail.TextSize = 14
	tabTrail.TextColor3 = Color3.fromRGB(180,180,190)
	tabTrail.AutoButtonColor = false

	-- Active tab indicator
	local activeIndicator = Instance.new("Frame", tabBar)
	activeIndicator.Size = UDim2.new(0.5, -12, 0, 4)
	activeIndicator.Position = UDim2.new(0,6,1,-6)
	activeIndicator.BackgroundColor3 = Color3.fromRGB(255,50,80)
	activeIndicator.BorderSizePixel = 0
	local indCorner = Instance.new("UICorner", activeIndicator)
	indCorner.CornerRadius = UDim.new(0,4)

	-- CONTENT FRAMES
	local contentHolder = Instance.new("Frame", frame)
	contentHolder.Size = UDim2.new(1, -28, 1, -130)
	contentHolder.Position = UDim2.new(0,14,0,118)
	contentHolder.BackgroundTransparency = 1

	local aimFrame = Instance.new("Frame", contentHolder)
	aimFrame.Size = UDim2.new(1,0,1,0)
	aimFrame.BackgroundTransparency = 1
	aimFrame.Visible = true

	local trailFrame = Instance.new("Frame", contentHolder)
	trailFrame.Size = UDim2.new(1,0,1,0)
	trailFrame.BackgroundTransparency = 1
	trailFrame.Visible = false

	-- Tab switching with smooth tween
	local function setActiveTab(tab)
		if tab == "aim" then
			aimFrame.Visible = true
			trailFrame.Visible = false
			TweenService:Create(activeIndicator, TweenInfo.new(0.28, Enum.EasingStyle.Quart), {Position = UDim2.new(0,6,1,-6)}):Play()
			tabAim.TextColor3 = Color3.fromRGB(235,235,240)
			tabTrail.TextColor3 = Color3.fromRGB(160,160,170)
			tabAim.BackgroundColor3 = Color3.fromRGB(28,28,30)
			tabTrail.BackgroundColor3 = Color3.fromRGB(21,21,23)
		else
			aimFrame.Visible = false
			trailFrame.Visible = true
			TweenService:Create(activeIndicator, TweenInfo.new(0.28, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5,6,1,-6)}):Play()
			tabTrail.TextColor3 = Color3.fromRGB(235,235,240)
			tabAim.TextColor3 = Color3.fromRGB(160,160,170)
			tabTrail.BackgroundColor3 = Color3.fromRGB(28,28,30)
			tabAim.BackgroundColor3 = Color3.fromRGB(21,21,23)
		end
	end

	tabAim.MouseButton1Click:Connect(function() setActiveTab("aim") end)
	tabTrail.MouseButton1Click:Connect(function() setActiveTab("trail") end)

	-- =============================
	-- UTIL: slider creator (refined  style)
	-- =============================
	local function createSlider(parent, name, minv, maxv, default, ypos)
		local label = Instance.new("TextLabel", parent)
		label.Size = UDim2.new(1, -20, 0, 20)
		label.Position = UDim2.new(0, 10, 0, ypos)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.Gotham
		label.TextColor3 = Color3.fromRGB(200,200,210)
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = string.format("%s: %s", name, default)

		local back = Instance.new("Frame", parent)
		back.Size = UDim2.new(1, -20, 0, 12)
		back.Position = UDim2.new(0, 10, 0, ypos + 20)
		back.BackgroundColor3 = Color3.fromRGB(28,28,30)
		back.BorderSizePixel = 0

		local backCorner = Instance.new("UICorner", back)
		backCorner.CornerRadius = UDim.new(0,8)
		local backStroke = Instance.new("UIStroke", back)
		backStroke.Thickness = 1
		backStroke.Color = Color3.fromRGB(255,50,80)
		backStroke.Transparency = 0.6

		local fill = Instance.new("Frame", back)
		local rel = math.clamp((default - minv) / (maxv - minv), 0, 1)
		fill.Size = UDim2.new(rel,0,1,0)
		fill.BackgroundColor3 = Color3.fromRGB(255,50,80)
		fill.BorderSizePixel = 0

		local fillCorner = Instance.new("UICorner", fill)
		fillCorner.CornerRadius = UDim.new(0,8)

		local dragDot = Instance.new("Frame", fill)
		dragDot.AnchorPoint = Vector2.new(0.5,0.5)
		dragDot.Size = UDim2.new(0,14,0,14)
		dragDot.Position = UDim2.new(1, -7, 0.5, 0)
		dragDot.BackgroundColor3 = Color3.fromRGB(235,235,245)
		dragDot.BorderSizePixel = 0
		local dotCorner = Instance.new("UICorner", dragDot)
		dotCorner.CornerRadius = UDim.new(0,8)
		local dotStroke = Instance.new("UIStroke", dragDot)
		dotStroke.Color = Color3.fromRGB(20,30,50)
		dotStroke.Thickness = 1

		local dragging = false

		local function updateFromMouse(x)
			local relLocal = math.clamp((x - back.AbsolutePosition.X) / back.AbsoluteSize.X, 0, 1)
			fill.Size = UDim2.new(relLocal,0,1,0)
			dragDot.Position = UDim2.new(1, -7, 0.5, 0)
			local newVal = math.floor((minv + (maxv - minv) * relLocal)*100)/100
			label.Text = string.format("%s: %s", name, tostring(newVal))

			-- Update settings
			if name=="Prediction" then _G.AimSettings._getPrediction = newVal
			elseif name=="Blend" then _G.AimSettings._getBlend = newVal
			elseif name=="ShiftDelay" then _G.AimSettings._getShiftDelay = newVal

			elseif name=="TrailLifetime" then _G.TrailSettings.Lifetime = newVal
			elseif name=="TrailStartT" then _G.TrailSettings.StartT = newVal
			elseif name=="TrailEndT" then _G.TrailSettings.EndT = newVal
			elseif name=="TrailBrightness" then _G.TrailSettings.Brightness = newVal
			elseif name=="TrailEmission" then _G.TrailSettings.Emission = newVal
			end
		end

		back.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				updateFromMouse(UserInputService:GetMouseLocation().X)
			end
		end)

		back.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		UserInputService.InputChanged:Connect(function(i)
			if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
				updateFromMouse(i.Position.X)
			end
		end)
	end

	-- =============================
	-- AIM TAB CONTENT
	-- =============================
	createSlider(aimFrame, "Prediction", 0.1, 20, DEFAULT_PREDICTION, 6)
	createSlider(aimFrame, "Blend", 0, 1, DEFAULT_BLEND, 66)
	createSlider(aimFrame, "ShiftDelay", 0.05, 1, DEFAULT_SHIFT_DELAY, 126)

	-- SHIFT TOGGLE
	local shiftLabel = Instance.new("TextLabel", aimFrame)
	shiftLabel.Position = UDim2.new(0, 14, 0, 186)
	shiftLabel.Size = UDim2.new(0, 220, 0, 22)
	shiftLabel.BackgroundTransparency = 1
	shiftLabel.Text = "Shift Macro"
	shiftLabel.Font = Enum.Font.Gotham
	shiftLabel.TextColor3 = Color3.fromRGB(200,200,210)
	shiftLabel.TextSize = 14
	shiftLabel.TextXAlignment = Enum.TextXAlignment.Left

	local shiftBox = Instance.new("Frame", aimFrame)
	shiftBox.Position = UDim2.new(0, 220, 0, 182)
	shiftBox.Size = UDim2.new(0, 34, 0, 26)
	shiftBox.BackgroundColor3 = Color3.fromRGB(28,28,30)
	shiftBox.BorderSizePixel = 0
	local shiftCorner = Instance.new("UICorner", shiftBox)
	shiftCorner.CornerRadius = UDim.new(0,8)
	local shiftStroke = Instance.new("UIStroke", shiftBox)
	shiftStroke.Color = Color3.fromRGB(24,40,70)
	shiftStroke.Thickness = 1
	shiftStroke.Transparency = 0.6

	local inner = Instance.new("Frame", shiftBox)
	inner.Size = UDim2.new(0.46,0,0.7,0)
	inner.Position = UDim2.new(0.04,0,0.15,0)
	inner.BackgroundColor3 = Color3.fromRGB(255,50,80)
	inner.BorderSizePixel = 0
	inner.Visible = false
	local innerCorner = Instance.new("UICorner", inner)
	innerCorner.CornerRadius = UDim.new(0,6)

	shiftBox.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			_G.AimSettings._shiftEnabled = not _G.AimSettings._shiftEnabled
			inner.Visible = _G.AimSettings._shiftEnabled
			if inner.Visible then
				TweenService:Create(inner, TweenInfo.new(0.18), {Position = UDim2.new(0.5,0,0.15,0)}):Play()
			else
				inner.Position = UDim2.new(0.04,0,0.15,0)
			end
		end
	end)

	-- Glock Animation toggle (placed under Shift Macro)
	local glockLabel = Instance.new("TextLabel", aimFrame)
	glockLabel.Position = UDim2.new(0, 14, 0, 224)
	glockLabel.Size = UDim2.new(0, 220, 0, 22)
	glockLabel.BackgroundTransparency = 1
	glockLabel.Text = "Glock Animation"
	glockLabel.Font = Enum.Font.Gotham
	glockLabel.TextColor3 = Color3.fromRGB(200,200,210)
	glockLabel.TextSize = 14
	glockLabel.TextXAlignment = Enum.TextXAlignment.Left

	local glockBox = Instance.new("Frame", aimFrame)
	glockBox.Position = UDim2.new(0, 220, 0, 220)
	glockBox.Size = UDim2.new(0, 34, 0, 26)
	glockBox.BackgroundColor3 = Color3.fromRGB(28,28,30)
	glockBox.BorderSizePixel = 0
	local glockCorner = Instance.new("UICorner", glockBox)
	glockCorner.CornerRadius = UDim.new(0,8)
	local glockStroke = Instance.new("UIStroke", glockBox)
	glockStroke.Color = Color3.fromRGB(24,40,70)
	glockStroke.Thickness = 1
	glockStroke.Transparency = 0.6

	local glockInner = Instance.new("Frame", glockBox)
	glockInner.Size = UDim2.new(0.46,0,0.7,0)
	glockInner.Position = UDim2.new(0.04,0,0.15,0)
	glockInner.BackgroundColor3 = Color3.fromRGB(255,50,80)
	glockInner.BorderSizePixel = 0
	glockInner.Visible = (_G.GlockSettings and _G.GlockSettings.FireAnimEnabled) or false
	local glockInnerCorner = Instance.new("UICorner", glockInner)
	glockInnerCorner.CornerRadius = UDim.new(0,6)

	glockBox.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			if not _G.GlockSettings then _G.GlockSettings = {} end
			_G.GlockSettings.FireAnimEnabled = not _G.GlockSettings.FireAnimEnabled
			glockInner.Visible = _G.GlockSettings.FireAnimEnabled
			if glockInner.Visible then
				TweenService:Create(glockInner, TweenInfo.new(0.18), {Position = UDim2.new(0.5,0,0.15,0)}):Play()
			else
				glockInner.Position = UDim2.new(0.04,0,0.15,0)
			end
		end
	end)

	-- =============================
	-- TRAIL TAB CONTENT
	-- =============================
	createSlider(trailFrame, "TrailLifetime", 0.05, 1, DEFAULT_TRAIL_LIFETIME, 6)
	createSlider(trailFrame, "TrailStartT", 0, 1, DEFAULT_TRAIL_START_T, 66)
	createSlider(trailFrame, "TrailEndT", 0, 1, DEFAULT_TRAIL_END_T, 126)
	createSlider(trailFrame, "TrailBrightness", 1, 20, DEFAULT_TRAIL_BRIGHTNESS, 186)
	createSlider(trailFrame, "TrailEmission", 0, 1, DEFAULT_TRAIL_EMISSION, 246)

	-- RAINBOW TOGGLE
	local rainbowLabel = Instance.new("TextLabel", trailFrame)
	rainbowLabel.Position = UDim2.new(0, 14, 0, 306)
	rainbowLabel.Size = UDim2.new(0, 220, 0, 22)
	rainbowLabel.BackgroundTransparency = 1
	rainbowLabel.Text = "Rainbow Trails"
	rainbowLabel.Font = Enum.Font.Gotham
	rainbowLabel.TextColor3 = Color3.fromRGB(200,200,210)
	rainbowLabel.TextSize = 14
	rainbowLabel.TextXAlignment = Enum.TextXAlignment.Left

	local rainbowBox = Instance.new("Frame", trailFrame)
	rainbowBox.Position = UDim2.new(0, 260, 0, 302)
	rainbowBox.Size = UDim2.new(0, 34, 0, 26)
	rainbowBox.BackgroundColor3 = Color3.fromRGB(28,28,30)
	rainbowBox.BorderSizePixel = 0
	local rainbowCorner = Instance.new("UICorner", rainbowBox)
	rainbowCorner.CornerRadius = UDim.new(0,8)
	local rainbowStroke = Instance.new("UIStroke", rainbowBox)
	rainbowStroke.Color = Color3.fromRGB(24,40,70)
	rainbowStroke.Thickness = 1
	rainbowStroke.Transparency = 0.6

	local rainbowInner = Instance.new("Frame", rainbowBox)
	rainbowInner.Size = UDim2.new(0.46,0,0.7,0)
	rainbowInner.Position = UDim2.new(0.04,0,0.15,0)
	rainbowInner.BackgroundColor3 = Color3.fromRGB(255,120,0)
	rainbowInner.BorderSizePixel = 0
	rainbowInner.Visible = _G.TrailSettings.Rainbow
	local rainbowInnerCorner = Instance.new("UICorner", rainbowInner)
	rainbowInnerCorner.CornerRadius = UDim.new(0,6)

	rainbowBox.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			_G.TrailSettings.Rainbow = not _G.TrailSettings.Rainbow
			rainbowInner.Visible = _G.TrailSettings.Rainbow
		end
	end)

	return gui, frame
end

local GUI, MainFrame = createGUI()

-- Toggle menu (L)
UserInputService.InputBegan:Connect(function(input, g)
	if g then return end
	if input.KeyCode == Enum.KeyCode.L and unlocked then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

-- =====================================================
-- PART 2 — AIM SYSTEM + AUTOSHOOT + PREDICTION ENGINE
-- (functionality preserved from original)
-- =====================================================

local GlockDelay = 0.26
local ShottyDelay = 0.39

local State = {
	Firing = false,
	_autoLoopRunning = false
}

-- REMOTE FIRING LOGIC
local function getRemote(name, hit)
	local char = LocalPlayer.Character
	if not char then return end

	if game.PlaceId == 16702351217 then
		-- SERVER 1
		if name == "Shotty" and char:FindFirstChild("Shotty") and char.Shotty:FindFirstChild("Shoot") then
			pcall(function() char.Shotty.Shoot:FireServer(hit) end)

		elseif name == "Glock" and char:FindFirstChild("Glock") and char.Glock:FindFirstChild("Shoot") then
			pcall(function() char.Glock.Shoot:FireServer(hit) end)
		end

	elseif game.PlaceId == 15852982099 then
		-- SERVER 2
		if name == "Shotty" and game.ReplicatedStorage:FindFirstChild("ShottyFire") then
			pcall(function() game.ReplicatedStorage.ShottyFire:FireServer(hit) end)

		elseif name == "Glock" and game.ReplicatedStorage:FindFirstChild("GlockFire") then
			pcall(function() game.ReplicatedStorage.GlockFire:FireServer(hit) end)
		end

	else
		-- UNIVERSAL FALLBACK
		pcall(function()
			for _, tool in ipairs(char:GetChildren()) do
				if tool:IsA("Tool") and tool:FindFirstChild("Shoot") then
					tool.Shoot:FireServer(hit)
					break
				end
			end
		end)
	end
end

-- PLAY FIRE ANIM IF THE TOOL HAS ONE
local function playToolFireAnim(tool, humanoid)
	if not tool or not humanoid then return end

	local fires = tool:FindFirstChild("Fires")
	if fires and fires:IsA("Animation") then
		local ok, track = pcall(function()
			return humanoid:LoadAnimation(fires)
		end)
		if ok and track then
			pcall(function()
				track:Play(0.1, 1, 2)
			end)
		end
	end
end

-- GET Player FROM MOUSE TARGET
local function getMouseTargetPlayer()
	local mouse = LocalPlayer:GetMouse()
	if not mouse or not mouse.Target then return nil end

	local model = mouse.Target:FindFirstAncestorOfClass("Model")
	if not model then return nil end

	local plr = Players:GetPlayerFromCharacter(model)
	if plr and plr ~= LocalPlayer then
		local hum = model:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health > 0 then
			return plr
		end
	end

	return nil
end

-- PREDICTION ENGINE
local function getPredictedPosition(target, fallbackPos)
	if not target or not target.Character then return fallbackPos end

	local char = target.Character
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return fallbackPos end

	local vel = hrp.Velocity or Vector3.zero
	local prediction = _G.AimSettings._getPrediction
	if prediction == 0 then prediction = 0.0001 end

	local adjustedVel = Vector3.new(vel.X, vel.Y * 0.2, vel.Z)

	local predicted = hrp.Position + (adjustedVel / prediction)
	local blend = _G.AimSettings._getBlend

	return predicted:Lerp(fallbackPos, blend)
end

-- FIRE ATTEMPT
local function tryFire()
	local targetPlayer = getMouseTargetPlayer()
	if not targetPlayer then return nil end

	local char = LocalPlayer.Character
	if not char then return nil end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return nil end

	local tool
	for _, v in ipairs(char:GetChildren()) do
		if v:IsA("Tool") then
			tool = v
			break
		end
	end

	if not tool then
		return nil
	end

	if tool:FindFirstChild("Ammo") and tool.Ammo.Value <= 0 then
		return nil
	end

	local mouse = LocalPlayer:GetMouse()
	if not mouse then return nil end

	local hit = mouse.Hit
	if not hit then return nil end

	-- apply prediction
	local predictedPos = getPredictedPosition(targetPlayer, hit.Position)
	hit = CFrame.new(predictedPos)

	-- SHIFT MACRO
	if _G.AimSettings._shiftEnabled then
		local delay = _G.AimSettings._getShiftDelay

		pcall(function()
			VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
			task.delay(delay, function()
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
			end)
		end)
	end

	-- DETECT TOOL TYPE
	local toolName = tostring(tool):lower()

	if toolName:find("glock") then
		getRemote("Glock", hit)

	elseif toolName:find("shotty") or toolName:find("shotgun") then
		getRemote("Shotty", hit)

	else
		pcall(function()
			if tool:FindFirstChild("Shoot") then
				tool.Shoot:FireServer(hit)
			end
		end)
	end

	playToolFireAnim(tool, hum)

	return toolName
end

-- AUTOSHOOT LOOP
local function autoFireLoop()
	if State._autoLoopRunning then return end
	State._autoLoopRunning = true

	while State.Firing do
		local target = getMouseTargetPlayer()

		if target then
			local weapon = tryFire()

			local delay =
				(weapon and weapon:find("glock") and GlockDelay) or
				(weapon and (weapon:find("shotty") or weapon:find("shotgun")) and ShottyDelay) or
				0.08

			task.wait(delay)
		else
			task.wait(0.02)
		end
	end

	State._autoLoopRunning = false
end

-- MOUSE INPUT LISTENERS
UserInputService.InputBegan:Connect(function(input, gamecessed)
	if gamecessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if not State.Firing then
			State.Firing = true
			task.spawn(autoFireLoop)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		State.Firing = false
	end
end)

-- =====================================================
-- PART 3 — WHITE TRAIL ENGINE (SYNCED WITH SLIDERS)
-- =====================================================

-- We track trails here so we never hook the same trail twice
local ActiveTrails = {}

-- Apply settings to ONE trail
local function ApplyTrailSettings(trail)
	if not trail then return end

	-- don't apply white trail settings while Rainbow mode is ON
	if _G.TrailSettings.Rainbow then return end

	pcall(function()
		trail.Color = ColorSequence.new(Color3.new(1, 1, 1))
		trail.Lifetime = _G.TrailSettings.Lifetime or 0.21

		trail.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, _G.TrailSettings.StartT or 0.47),
			NumberSequenceKeypoint.new(1, _G.TrailSettings.EndT or 1)
		})

		trail.Brightness = _G.TrailSettings.Brightness or 10
		trail.LightEmission = _G.TrailSettings.Emission or 1
	end)
end

-- Hook a trail (only once)
local function HookTrail(trail)
	if not trail or ActiveTrails[trail] then return end

	ActiveTrails[trail] = true
	ApplyTrailSettings(trail)
end

-- Catch NEW trails
Workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("Trail") then
		HookTrail(obj)
	end
end)

-- Catch any trails that already exist
for _, inst in ipairs(Workspace:GetDescendants()) do
	if inst:IsA("Trail") then
		HookTrail(inst)
	end
end

-- Live Update Loop
RunService.RenderStepped:Connect(function()
	for trail in pairs(ActiveTrails) do
		if not trail or not trail.Parent then
			ActiveTrails[trail] = nil
		else
			ApplyTrailSettings(trail)
		end
	end
end)

-- =====================================================
-- PART 4 — RAINBOW TRAIL ENGINE (TOGGLED VIA UI)
-- =====================================================

local RainbowTrails = {}

local speed = 0.4      -- rainbow cycle speed
local spread = 0.18    -- hue distance between colors

local function hsv(h) return Color3.fromHSV(h % 1, 1, 1) end

local function hookRainbowTrail(trail)
	if not trail or RainbowTrails[trail] then return end
	ActiveTrails[trail] = nil
	RainbowTrails[trail] = { offset = math.random() }
end

-- Listen for any Trail added under Workspace and hook for rainbow
Workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("Trail") then
		hookRainbowTrail(obj)
	end
end)

-- Initial scan to hook existing trails
for _, inst in ipairs(Workspace:GetDescendants()) do
	if inst:IsA("Trail") then
		hookRainbowTrail(inst)
	end
end

RunService.RenderStepped:Connect(function()
	if not _G.TrailSettings.Rainbow then return end
	local t = tick()
	for trail, meta in pairs(RainbowTrails) do
		if not trail or not trail.Parent then
			RainbowTrails[trail] = nil
		else
			local baseHue = t * speed + meta.offset
			local h1 = baseHue % 1
			local h2 = (baseHue + spread) % 1
			local colSeq = ColorSequence.new(hsv(h1), hsv(h2))
			pcall(function()
				trail.Color = colSeq
				trail.Lifetime = _G.TrailSettings.Lifetime or 0.17
				trail.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			end)
		end
	end
end)

-- Clean up when Rainbow is turned off: move trails back to ActiveTrails so white settings resume
task.spawn(function()
	local prev = _G.TrailSettings.Rainbow
	while true do
		if _G.TrailSettings.Rainbow ~= prev then
			prev = _G.TrailSettings.Rainbow
			if not prev then
				for trail in pairs(RainbowTrails) do
					ActiveTrails[trail] = true
				end
				RainbowTrails = {}
			else
				for trail in pairs(ActiveTrails) do
					ActiveTrails[trail] = nil
				end
			end
		end
		task.wait(0.12)
	end
end)

-- =========================
-- Glock animation integration (added by assistant)
-- Plays Idle always; Fire animation is controlled by _G.GlockSettings.FireAnimEnabled
-- =========================

task.spawn(function()
    task.wait(0.5)

    local Players = game:GetService("Players")
    local player = LocalPlayer or Players.LocalPlayer
    local mouse = player:GetMouse()

    local FIRE_COOLDOWN = 0.26
    local FIRE_PLAYBACK_SPEED = 2
    local FIRE_PLAYBACK_DELAY = 0.01

    local humanoid
    local glock
    local idleTrack
    local canFire = true

    local function waitForGlock()
        local char = player.Character or player.CharacterAdded:Wait()

        repeat task.wait() until char:FindFirstChild("Humanoid")
        humanoid = char:FindFirstChild("Humanoid")

        repeat task.wait() until char:FindFirstChild("Glock")
        glock = char:FindFirstChild("Glock")
    end

    local function loadAnim(animObj)
        if humanoid and animObj and animObj:IsA("Animation") then
            local ok, track = pcall(function()
                return humanoid:LoadAnimation(animObj)
            end)
            return (ok and track) and track or nil
        end
        return nil
    end

    local function setupGlock()
        if not glock or not humanoid then return end

        if glock:FindFirstChild("Idle") then
            idleTrack = loadAnim(glock.Idle)
            if idleTrack then
                idleTrack.Looped = true
                idleTrack.Priority = Enum.AnimationPriority.Movement -- set to Movement to avoid fast takeout
            end
        end
    end

    local function onEquip()
        if idleTrack then
            pcall(function() idleTrack:Play(0, 1, 1) end)
        end
    end

    local function onUnequip()
        if idleTrack then
            pcall(function() idleTrack:Stop(0) end)
        end
    end

    local function fire()
        if not canFire or not glock then return end
        canFire = false

        -- exploit check
        local gui = player:FindFirstChild("PlayerGui")
        if gui and gui:FindFirstChild("LocalScript") and gui.LocalScript.Disabled == true then
            canFire = true
            return
        end

        local fireTrack = nil

        -- ONLY load/play Fire animation if the Glock fire anim toggle is enabled
        if _G.GlockSettings and _G.GlockSettings.FireAnimEnabled then
            if glock:FindFirstChild("Fires") then
                fireTrack = loadAnim(glock.Fires)
                if fireTrack then
                    fireTrack.Priority = Enum.AnimationPriority.Action
                end
            end
        end

        -- Fire animation plays OVER idle animation (if any)
        if fireTrack then
            pcall(function()
                fireTrack:Play(FIRE_PLAYBACK_DELAY, 1, FIRE_PLAYBACK_SPEED)
            end)
        end

        -- Fire Server (retain original behavior)
        if game.ReplicatedStorage:FindFirstChild("GlockFire") then
            pcall(function() game.ReplicatedStorage.GlockFire:FireServer(mouse.Hit, mouse.Target) end)
        end

        task.wait(FIRE_COOLDOWN)

        if fireTrack then
            pcall(function()
                fireTrack:Stop(0)
                fireTrack:Destroy()
            end)
        end

        canFire = true
    end

    local function bindGlockEvents()
        if not glock then return end
        pcall(function() glock.Equipped:Connect(onEquip) end)
        pcall(function() glock.Unequipped:Connect(onUnequip) end)
        pcall(function() glock.Activated:Connect(fire) end)
    end

    -- initial setup
    waitForGlock()
    setupGlock()
    bindGlockEvents()

    player.CharacterAdded:Connect(function()
        task.wait(1)
        waitForGlock()
        setupGlock()
        bindGlockEvents()
    end)
end)



-- End of script


-- ACCENT COLOR ANIMATION (red→pink)
task.spawn(function()
    while true do
        local t = math.abs(math.sin(tick()))
        local col = Color3.fromRGB(255, math.floor(40 + 80 * t), math.floor(120 + 80 * t))
        local function apply(obj)
            if obj:IsA("UIStroke") then
                obj.Color = col
            elseif obj:IsA("Frame") and obj.Name == "activeIndicator" then
                obj.BackgroundColor3 = col
            end
            for _,d in ipairs(obj:GetChildren()) do apply(d) end
        end
        if MainFrame then apply(MainFrame) end
        task.wait(0.15)
    end
end)
