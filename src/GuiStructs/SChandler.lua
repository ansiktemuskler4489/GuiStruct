--[[
	this is used for frams that contains
	more then one item, for example shop
	etc
]]
local FrameBase = require(script.Parent.Base.FrameBase)
local SChandler = setmetatable({}, FrameBase)
SChandler.__index = SChandler

export type StructFn = (TGhandler:TGhandler)->(FrameBase.GuiBase)

export type SChandler = typeof(setmetatable(
	{}::{
		StructFn:StructFn
	}, SChandler)) & FrameBase.FrameBase

function SChandler.new(GuiObject:GuiObject, BinableEvent:BindableEvent?)
	local self = setmetatable(FrameBase.new(GuiObject, BinableEvent), SChandler)
	
	self.StructFn = nil
	
	return self
end

function SChandler:SetStructFn(StructFn:StructFn)
	assert(type(StructFn) == "function")
	self.StructFn = StructFn
end

function SChandler:AddItem(Name:string, StructFn:StructFn)
	local StructFn = assert(StructFn or self.StructFn, "have to have a structfn")
	local NewGuiBase = StructFn(self)
	
	
	NewGuiBase.GuiObject.Name = Name
	self:AddChildren(NewGuiBase)
end


return SChandler
