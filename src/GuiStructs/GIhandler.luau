--[[
	GIHandler : GuiHandler
	
	this was supposed to be the heavyer version of the GuiBase,
	Cause Some dont need to save alot
	And some just used as primitive 
]]
local GuiBase = require(script.Parent.Base.GuiBase)
local GIHandler = setmetatable({}, GuiBase)
GIHandler.__index = GIHandler

export type GuiPacket = {
	["action"]:string,
	["data"]:{
		[string]:any
	}
}

export type Tweens = {
	[string]:{
		["Tween"]:Tween|string,
		["EventName"]:string
	}
}

export type GuiBase = GuiBase.GuiBase

export type GIHandler = typeof(setmetatable(
	{}::{
		Tweens:{[string]:Tween},
		Data:{[string]:any},
		RemoteFunction : RemoteFunction?,
		RemoteEvent : RemoteEvent?
	}, GIHandler)) & GuiBase.GuiBase

function GIHandler.new(
	GuiObject:GuiObject, 
	BinableEvent:BindableEvent
)
	local self = setmetatable(GuiBase.new(
		GuiObject,
		BinableEvent
		), GIHandler)
	
	self.Tweens = {}
	self.Data = {}

	self.RemoteEvent = nil
	self.RemoteFunction = nil
	
	return self
end


function GIHandler:SetTweens(Tweens:{[string]:Tween})
	
end

function GIHandler:ConnectTweens(Tweens:Tweens, Event:BindableEvent?)
	
end

function GIHandler:ConnectTween(Tween:Tween|string, EventName:string, Event:BindableEvent?)
	
end

function GIHandler:SetMetaData(data:{[string]:any})
	self.Data = data
end


function GIHandler:FireServer(Data:GuiPacket, RemoteEvent:RemoteEvent?)
	local RemoteEvent = RemoteEvent or self.RemoteEvent
	RemoteEvent:FireServer(Data)
end

function GIHandler:InvokeServer(Data:GuiPacket, RemoteFunction:RemoteFunction?)
	local RemoteEvent = RemoteFunction or self.RemoteFunction
	local error, retn = pcall(function()
		local retn = RemoteEvent:InvokeServer(Data)
		return retn
	end)

	if error then
		warn("fail to connect")
		return
	end
	return retn
end



function GIHandler:ClearTweens()
	for _,tween:Tween in self.Tweens do
		tween:Destroy()
	end
end

function GIHandler:Disconnect()
	for _,connection:RBXScriptConnection in self.EventConnections do
		connection:Disconnect()
	end
end

function GIHandler:Destroy()
	self:ClearTweens()
	self:Disconnect()
	for _,instance in self do
		if typeof(instance) == "Instance" then
			instance:Destroy()
			continue
		end
		if type(instance) == "table" then
			table.clear(instance)
			continue
		end
		instance = nil
	end
end

-- @@@ deprechated, not done
function GIHandler:Clone(GuiObject:GuiObject, Parent:GuiBase?)

end


return GIHandler
