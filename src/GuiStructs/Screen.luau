--[[
	Screen : ScreenGui

	Is usually the root of the gui tree and have the
	ability to have a "event spot"
]]
local FrameBase = require(script.Parent.Base.FrameBase)
local Screen = setmetatable({}, FrameBase)
Screen.__index = Screen

export type CallBackFn = (
	Screen:Screen, 
	GuiBase:FrameBase.GuiBase, 
	Input:InputObject)->nil

export type Screen = typeof(setmetatable(
	{}::{
		CallBackFns:{CallBackFn},
		EventConnection:RBXScriptConnection
	}, Screen)) & FrameBase.FrameBase

function Screen.new(ScreenGui:ScreenGui, BindableEvent:BindableEvent?):Screen
	local BindableEvent = BindableEvent or Instance.new("BindableEvent")
	local self = setmetatable(FrameBase.new(ScreenGui, BindableEvent), Screen)
	
	self.CallBackFns = {}
	self.EventConnection = nil
	
	return self
end

function Screen:SetCallBackFns(CallBackFns:{CallBackFn} ,BinableEvent:BindableEvent?)
	assert(type(CallBackFns) == "table", "no table founded")
	self.CallBackFns = CallBackFns
	self:ConnectCallBackFns(BinableEvent)
end

function Screen:ConnectCallBackFns(BinableEvent:BindableEvent?)
	local Event:BindableEvent = BinableEvent or self.Event
	self.EventConnection = Event.Event:Connect(function(
		Name:string, 
		GuiBase:FrameBase.GuiBase,
		--GuiStruct:any, very sad, could maybe use good signal in the future
		Input:InputObject?)

		local Fn = self.CallBackFns[Name]

		if not(type(Fn) == "function" ) then
			warn("the type:", Name, "not founded")
			return
		end
		
		Fn(self, GuiBase, Input)
	end)
end

function Screen:Close()
	self.GuiObject.Enabled = false
end

function Screen:Open()
	self.GuiObject.Enabled = true
end

function Screen:DisconnectCallBackFns()
	local EventConnection:RBXScriptConnection = self.EventConnection
	EventConnection:Disconnect()
end

return Screen
