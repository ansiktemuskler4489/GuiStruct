--[[
	FrameBase

	Gives primitive wrappers around the frameguiobject
]]
local GuiBase = require(script.Parent.GuiBase)
local FrameBase = setmetatable({}, GuiBase)
FrameBase.__index = FrameBase
FrameBase.__type = "FrameBase"


export type GuiBase = GuiBase.GuiBase

export type FrameBase = typeof(setmetatable({}::{
	Childrens:{GuiBase}	
}, FrameBase)) & GuiBase


function FrameBase.new(GuiObject:GuiObject, BindableEvent:BindableEvent?):FrameBase
	local self = setmetatable(GuiBase.new(GuiObject, BindableEvent), FrameBase)
	
	self.Childrens = {}

	return self
end

local function ParseRawPath(RawPath:string, Seperator:string)
	return string.split(RawPath, Seperator)
end

function FrameBase:GetDescendanceByPath(RawPath:GuiBase, Seperator:string?):GuiBase
	local Path = ParseRawPath(RawPath, Seperator or "/")
	local Child = self
	for i=1, #Path, 1 do
		Child = Child.Childrens[Path[i]]
	end
	return Child
end

function FrameBase:GetChildren(GuiBase:GuiBase):GuiBase
	local Name:string = GuiBase.GuiObject.Name
	local GuiBase = assert(self.Childrens[Name])
	return GuiBase
end

function FrameBase:AddChildren(GuiBase:GuiBase, ParentEvent:boolean?):GuiBase
	local ParentEvent = ParentEvent or true
	if ParentEvent then
		GuiBase.Event = self.Event
	end
	self.Childrens[GuiBase.GuiObject.Name] = GuiBase
	GuiBase.GuiObject.Parent = self.GuiObject
	return GuiBase
end

function FrameBase:RemoveChildren(GuiBase:GuiBase)
	warn("make sure to have distinct name for guis")
	local index = table.find(self.Children, GuiBase.GuiObject.Name)
	local GuiBase:GuiBase = self.Children[index]
	table.remove(self.Children, index)
	GuiBase:Destroy()
end

return FrameBase
