local GuiSetup = {}

local TweenService = game:GetService("TweenService")

local Guis =  require()
local GuiStructs = Guis.Structs
local Event = Guis.GetDefaultEvent()
GuiSetup.Event = Event

-- DataModel Tree
local Map = {
	Mapping = {
		-- names specific
		["ActionStatus"] = GuiStructs.TGhandler,
	
		-- class specific
		["Frame"] = GuiStructs.FrameBase,
		["ScreenGui"] = GuiStructs.Screen
	},
	Default = GuiStructs.GuiBase
}
local Tree = Guis.GetTree(script.Parent, Event, Map,{"ModuleScript", "Folder"})
local Screen = Tree["MainScreen"] :: Guis.Screen


-- Get All of the GuiStruct
local ActionStatus = Screen:GetDescendanceByPath("ActionStatus") :: Guis.TGhandler
local DeepthMeterText = Screen:GetDescendanceByPath("DeepthMeter/Meter")
local AirMeterInnerFill = Screen:GetDescendanceByPath("AirMeter/InnerFill")


-- Setting up centraized events
local CallBackFns : {[string]:(Guis.Screen, ...any)->any} = {
	["open"] = function(screen:Guis.Screen, guibase, inputobject)
		screen:Open()
	end,
	["close"] = function(screen:Guis.Screen, guibase, inputobject)
		screen:Close()
	end,
	["open_action_status"] = function(screen:Guis.Screen, page:string?)
		ActionStatus:CloseActivePage(page)
		ActionStatus:OpenPage(page)
	end,
	["update_deepth_meter"] = function(screen:Guis.Screen, deepth:number)
		DeepthMeterText.GuiObject.Text = `meters: {deepth} `
	end,
	["update_air_meter"] = function(screen:Guis.Screen, air:number)
		AirMeterInnerFill.GuiObject.Size = UDim2.new(1, 0, air, 0)
	end
}
Screen:SetCallBackFns(CallBackFns)

local ActionStatusTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential)
local function OnOpenActionStatus(self:Guis.TGhandler, Page:Guis.GuiBase)
	self:CloseActivePage()
	self.ActiveGuiBase = Page
	local Tween = TweenService:Create(Page.GuiObject, ActionStatusTweenInfo, {
		BackgroundTransparency = 0
	})
	Tween:Play()
end

local function OnCloseActionStatus(self:Guis.TGhandler, Page:Guis.GuiBase)
	local Tween = TweenService:Create(Page.GuiObject, ActionStatusTweenInfo, {
		BackgroundTransparency = 1
	})
	Tween:Play()
end

ActionStatus.OpenFn = OnOpenActionStatus
ActionStatus.CloseFn = OnCloseActionStatus

return GuiSetup