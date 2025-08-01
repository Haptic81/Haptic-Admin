local UIS = game["GetService"](game, "UserInputService")
local TweenService = game["GetService"](game, "TweenService")
local CoreGui = game["GetService"](game, "CoreGui")

_G["G_"] = _G["G_"] or {}

local gui = Instance.new("ScreenGui")
gui["Name"] = "Haptic-Admin"
gui["ResetOnSpawn"] = false
gui["Parent"] = CoreGui

local frame = Instance.new("Frame")
frame["Size"] = UDim2.new(0, 0, 0, 0)
frame["Position"] = UDim2.new(0.5, 0, 0.1, 0)
frame["AnchorPoint"] = Vector2.new(0.5, 0)
frame["BackgroundColor3"] = Color3.new(0, 0, 0)
frame["BorderSizePixel"] = 0
frame["BackgroundTransparency"] = 1
frame["Draggable"] = true
frame["Active"] = true
frame["Parent"] = gui

local textbox = Instance.new("TextBox")
textbox["Size"] = UDim2.new(0.6, 0, 0, 40)
textbox["Position"] = UDim2.new(0.2, 0, 0, 10)
textbox["BackgroundColor3"] = Color3.fromRGB(40, 40, 40)
textbox["TextColor3"] = Color3.new(1, 1, 1)
textbox["TextXAlignment"] = Enum["TextXAlignment"]["Center"]
textbox["TextYAlignment"] = Enum["TextYAlignment"]["Center"]
textbox["Text"] = ""
textbox["ClearTextOnFocus"] = false
textbox["PlaceholderText"] = ""
textbox["Font"] = Enum["Font"]["Gotham"]
textbox["TextScaled"] = true
textbox["BackgroundTransparency"] = 1
textbox["TextTransparency"] = 1
textbox["BorderSizePixel"] = 0
textbox["Parent"] = frame

local uicorner = Instance.new("UICorner", textbox)
uicorner["CornerRadius"] = UDim.new(0, 4)

local textPadding = Instance.new("UITextSizeConstraint", textbox)
textPadding["MaxTextSize"] = 18

local listFrame = Instance.new("Frame")
listFrame["Size"] = UDim2.new(0.6, 0, 0, 140)
listFrame["Position"] = UDim2.new(0.2, 0, 0, 60)
listFrame["BackgroundColor3"] = Color3.fromRGB(30, 30, 30)
listFrame["BackgroundTransparency"] = 1
listFrame["BorderSizePixel"] = 0
listFrame["Parent"] = frame

local uilist = Instance.new("UIListLayout", listFrame)
uilist["Padding"] = UDim.new(0, 2)
uilist["SortOrder"] = Enum["SortOrder"]["LayoutOrder"]

local function refreshCommandList(filter)
	for _, v in pairs(listFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	for name, cmd in pairs(_G["G_"]) do
		if typeof(name) == "string" and (filter == "" or name:lower():find(filter:lower())) then
			local button = Instance.new("TextButton")
			button["Text"] = name
			button["Size"] = UDim2.new(1, 0, 0, 30)
			button["BackgroundColor3"] = Color3.fromRGB(50, 50, 50)
			button["TextColor3"] = Color3.new(1, 1, 1)
			button["Font"] = Enum["Font"]["Gotham"]
			button["TextSize"] = 16
			button["BackgroundTransparency"] = 0.1
			button["Parent"] = listFrame
			button["MouseButton1Click"]:Connect(function()
				pcall(cmd)
			end)
		end
	end
end

textbox["GetPropertyChangedSignal"](textbox, "Text"):Connect(function()
	refreshCommandList(textbox["Text"])
end)

local expandedSize = UDim2.new(0, 400, 0, 300)
local collapsedSize = UDim2.new(0, 0, 0, 0)
local tweenInfo = TweenInfo.new(0.3, Enum["EasingStyle"]["Quad"], Enum["EasingDirection"]["Out"])
local fadeInfo = TweenInfo.new(0.25, Enum["EasingStyle"]["Quad"], Enum["EasingDirection"]["Out"])

local expanded = false
local function toggle()
	if expanded then
		TweenService["Create"](TweenService, textbox, fadeInfo, {
			["BackgroundTransparency"] = 1,
			["TextTransparency"] = 1
		}):Play()
		TweenService["Create"](TweenService, listFrame, fadeInfo, {
			["BackgroundTransparency"] = 1
		}):Play()
		TweenService["Create"](TweenService, frame, fadeInfo, {
			["BackgroundTransparency"] = 1
		}):Play()
		TweenService["Create"](TweenService, frame, tweenInfo, {
			["Size"] = collapsedSize
		}):Play()
	else
		TweenService["Create"](TweenService, frame, tweenInfo, {
			["Size"] = expandedSize
		}):Play()
		TweenService["Create"](TweenService, frame, fadeInfo, {
			["BackgroundTransparency"] = 0
		}):Play()
		TweenService["Create"](TweenService, textbox, fadeInfo, {
			["BackgroundTransparency"] = 0,
			["TextTransparency"] = 0
		}):Play()
		TweenService["Create"](TweenService, listFrame, fadeInfo, {
			["BackgroundTransparency"] = 0
		}):Play()
		refreshCommandList(textbox["Text"])
	end
	expanded = not expanded
end

UIS["InputBegan"]:Connect(function(input, processed)
	if not processed and input["KeyCode"] == Enum["KeyCode"]["Insert"] then
		toggle()
	end
end)
