local FrameBase = require(script.Parent.Base.FrameBase)
local TGhandler = setmetatable({}, FrameBase)
TGhandler.__index = TGhandler

export type StructFn = (TGhandler:TGhandler)->(GuiBase)

export type TGhandler = typeof(setmetatable(
	{}::{
		ActiveGuiBase:FrameBase.GuiBase,
		StructFn:StructFn,
		OpenFn: (TGhandler)->(nil),
		CloseFn: (TGhandler)->(nil)
	}, TGhandler)) & FrameBase.FrameBase

function TGhandler.new(GuiObject:GuiObject, BindableEvent:BindableEvent?)
	local self = setmetatable(FrameBase.new(GuiObject, BindableEvent), TGhandler)
	
	self.ActiveGuiBase = nil
	self.StructFn = nil

	self.OpenFn = nil
	self.CloseFn = nil
	
	return self
end

function TGhandler:SetStructFn(StructFn:StructFn)
	assert(type(StructFn) == "function")
	self.StructFn = StructFn
end

function TGhandler:AddPage(Name:string, StructFn:StructFn?)
	local StructFn = assert(StructFn or self.StructFn, "have to have a structfn")
	local NewGuiBase = assert(StructFn(self), "nothing return on structfn")
	
	NewGuiBase.GuiObject.Name = Name
	self:AddChildren(NewGuiBase)
end

function TGhandler:OpenPage(Name:string, OpenFn:(TGhandler)->nil??)
	self:ClosePage()
	local GuiBase:FrameBase.GuiBase = assert(self:GetChildren(self.Childrens[Name]))
	local GuiObject = GuiBase.GuiObject
	
	self.ActiveGuiBase = GuiBase
	GuiObject.Visible = true

	local OpenFn = OpenFn or self.OpenFn
	if typeof(OpenFn) == "function" then
		OpenFn(self)
	end
end

function TGhandler:ClosePage(CloseFn: (TGhandler)->nil??)
	if not self.ActiveGuiBase then
		--warn("No ActiveGuiBase")
		return
	end
	
	local GuiBase:FrameBase.GuiBase = self.ActiveGuiBase
	local GuiObject = GuiBase.GuiObject
	
	self.ActiveGuiBase:Close()
	self.ActiveGuiBase = nil

	local CloseFn = CloseFn or self.CloseFn
	if typeof(CloseFn) == "function" then
		CloseFn(self)
	end
end

return TGhandler
