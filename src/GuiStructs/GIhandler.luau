--[[
	this was supposed to be the heavyer version of the GuiBase,
	Cause Some dont need to save alot
	And some just used as primitive 
]]
local GuiBase = require(script.Parent.Base.GuiBase)
local GIHandler = setmetatable({}, GuiBase)
GIHandler.__index = GIHandler

--local ReplicatedStorage = game:GetService("ReplicatedStorage")
--local GuiRemote = ReplicatedStorage.Remotes.GuiRemote
--local GuiFunction = ReplicatedStorage.Remotes.GuiFunction

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
		Data:{[string]:any}
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
	
	return self
end


function GIHandler:SetTweens(Tweens:{[string]:Tween})
	-- TODO
	self.Tweens = Tweens
	
	--[[
	
	if type(Name) == "string" then
		self.Tweens[Name] = Tween
	end
	
	]]
end


--- @@@@ tweeens is deprechated
function GIHandler:ConnectTweens(Tweens:Tweens, Event:BindableEvent?)
	local Event = Event or self.Event
	for TweenName,TweenData in Tweens do
		
		if not(Tweens["Tween"] and Tweens["EventName"]) then
			warn("incorrect formating of tweendata")
			continue
		end
		
		self:ConnectTween(Tweens["Tween"], Tweens["EventName"], Event)
	end
	
end

function GIHandler:ConnectTween(Tween:Tween|string, EventName:string, Event:BindableEvent)
	local Tween:Tween = assert(Tween or self.Tweens[Tween])
	local Event:BindableEvent = Event or self.Event
	local connection = Event.Event:Connect(function(name, self, input)
		if name[EventName] then
			Tween:Play()
		end
	end)
	
	table.insert(self.EventConnections, Event)
end

function GIHandler:SetMetaData(data:{[string]:any})
	self.Data = data
end
--[[

function GIHandler:FireServer(data:GuiPacket, remoteevent:RemoteEvent?)
	local remoteevent = remoteevent or GuiRemote
	remoteevent:FireServer(data)
end

function GIHandler:InvokeServer(data:GuiPacket, remotefunction:RemoteFunction?)
	local remotefunction = remotefunction or GuiFunction
	local error, retn = pcall(function()
		local retn = remotefunction:InvokeServer(data)
		return retn
	end)

	if error then
		warn("fail to connect")
		return
	end
	return retn
end

]]


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
	local Cloned:GuiBase = GIHandler.new(GuiObject, self.Event, Parent)
	Cloned.Data = self.Data
	return Cloned
end


return GIHandler
