--[[
	VPhandler : ViewportHandler, ViewportFrameHandler

	Gives some basic functionallies for ViewportFrame
]]
local GIhandler = require(script.Parent.GIhandler)
local VPhandler = setmetatable({}, GIhandler)
VPhandler.__index = VPhandler


local RunService = game:GetService("RunService")

export type VPhandler =  typeof(setmetatable(
	{}::{
		Object:Object,
		Camera:Camera,
		CameraDistance:number,
		CameraSpeed:number,
	}, GIhandler)) & GIhandler.GIHandler

function VPhandler.new(GuiObject:ViewportFrame, BindableEvent:BindableEvent, Object:BasePart):VPhandler
	local self = setmetatable(GIhandler.new(GuiObject, BindableEvent), VPhandler)
	
	self.Name = "Viewport"
	self.Object = Object or nil
	self.CameraDistance = nil
	self.Camera = Instance.new("Camera", GuiObject)
	self.CameraSpeed = 40
	self.RenderPriority = Enum.RenderPriority.Last.Value
	self.t = 0
	
	self.Camera.CFrame = CFrame.new(0,0, self.CameraDistance)
	GuiObject.CurrentCamera = self.Camera
	
	if Object then
		Object.Parent = GuiObject
		Object.Anchored = true
		Object.CFrame = CFrame.new()
		self.CameraDistance = math.max(Object.Size.Y, Object.Size.X, Object.Size.Z)
	end
	
	
	return self
end

function VPhandler:SetObject(Object:BasePart)
	if self.Object then
			self.Object:Destroy()
			self.Object = nil
		end
	Object.CFrame = CFrame.new()
	Object.Anchored = true
	Object.Parent = self.GuiObject
	self.Object = Object
	self.CameraDistance = math.max(Object.Size.Y, Object.Size.X, Object.Size.Z)
end

function VPhandler:Rotate(Object:BasePart?, Name:string?)
	if Object then
		self:SetObject(Object)
	end
	
	if Name then
		self.Name = Name
	end
	
	local Name = self.Name
	local Object:BasePart = Object or self.Object
	local Camera:Camera = self.Camera
	local RenderPriority:number = self.RenderPriority
	
	self.t = self.t % (360/self.CameraSpeed)
	RunService:UnbindFromRenderStep(Name)
	RunService:BindToRenderStep(Name, RenderPriority, function(dt)
		debug.profilebegin("ViewportRendering")
		
		self.t += dt
		Camera.CFrame = CFrame.Angles(0, math.rad(self.t*40) ,0) * CFrame.new(0,0, self.CameraDistance)
		
		debug.profileend()
	end)
end

function VPhandler:Stop(destroy:boolean?)
	RunService:UnbindFromRenderStep(self.Name)
	
	if destroy then
		self.Object:Destroy()
		self.Object = nil
	end
end



function VPhandler:Destory()
	
end



return VPhandler
