--[[
	the same as framebase but that this inheiriting from
	GIhanlder instead of Guibase
]]
local GIhandler = require(script.Parent.GIhandler)
local FMhandler = setmetatable({}, GIhandler)
FMhandler.__index = FMhandler
FMhandler.__type = "FrameBase"

export type GuiBase = GIhandler.GuiBase

export type FMhandler = typeof(setmetatable({}::{
	Childrens:{GuiBase}	
}, FMhandler)) & GIhandler.GIHandler


function FMhandler.new(GuiObject:GuiObject, BindableEvent:BindableEvent?):FMhandler
	local self = setmetatable(GIhandler.new(GuiObject, BindableEvent), FMhandler)
	
	self.Childrens = {}

	return self
end

local function ParseRawPath(RawPath:string, Seperator:string)
	return string.split(RawPath, Seperator)
end

function FMhandler:GetDescendanceByPath(RawPath:GuiBase, Seperator:string?):GuiBase
	local Path = ParseRawPath(RawPath, Seperator or "/")
	local Child = self
	for i=1, #Path, 1 do
		Child = Child:GetChildren(Path[i])
	end
	return Child
end


function FMhandler:GetChildren(GuiBase:GuiBase):GuiBase
	local Name:string = GuiBase.GuiObject.Name
	local GuiBase = assert(self.Childrens[Name])
	return GuiBase
end

function FMhandler:AddChildren(GuiBase:GuiBase, ParentEvent:boolean?):GuiBase
	local ParentEvent = ParentEvent or true
	if ParentEvent then
		GuiBase.Event = self.Event
	end
	self.Childrens[GuiBase.GuiObject.Name] = GuiBase
	GuiBase.GuiObject.Parent = self.GuiObject
	return GuiBase
end

function FMhandler:RemoveChildren(GuiBase:GuiBase)
	warn("make sure to have distinct name for guis")
	local index = table.find(self.Children, GuiBase.GuiObject.Name)
	local GuiBase:GuiBase = self.Children[index]
	table.remove(self.Children, index)
	GuiBase:Destroy()
end

--[[
-- use rawset when needed
FMhandler.__newindex = function(t, k, v)
	if not(type(k) == "string") then
		warn("can't add have other then string type as key")
	end
	if k == "__index" or k == "__type" then
		rawset(t, k, v)
		return
	end
	print("heleoo", v)
	t:AddChildren(v)
	return
end
]]

return FMhandler
