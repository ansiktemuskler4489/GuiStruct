local GuiBase = {}
GuiBase.__index = GuiBase
GuiBase.__type = "GuiBase"

export type BindableEventFn = (Name:string, self:GuiBase, input:InputObject)->any

export type GuiBase = typeof(setmetatable(
	{}::{
	GuiObject:GuiObject,
	Event:BindableEvent,
	EventConnections:{RBXScriptConnection},
	}, GuiBase))

function GuiBase.new(GuiObject:GuiObject, BinableEvent:BindableEvent?):GuiBase
	assert(GuiObject:IsA("GuiBase"), "no gui object founded")
	
	local self = setmetatable({
		GuiObject = GuiObject,
		Event = BinableEvent or nil,
		EventConnections = {},
	}, GuiBase)
	
	return self
end

function GuiBase:SetEvent(SignalName:string, Name:string?, Fn:(self)->nil?, BinableEvent:BindableEvent?)
	local BinableEvent = assert(BinableEvent or self.Event, "no binable founded")
	local Signal = assert(self.GuiObject[SignalName], "no signal founded")
	local Connection = Signal:Connect(function(input:InputObject)
		if Name then
			BinableEvent:Fire(Name, self, input)
		end
		if type(Fn) == "function" then
			Fn(self, input)
		end
	end)
	self.EventConnections[SignalName] =  Connection
end


function GuiBase:Close()
	self.GuiObject.Visible = false
	self.GuiObject.Active = false
end

function GuiBase:Open()
	self.GuiObject.Visible = true
	self.GuiObject.Active = false
end

function GuiBase:Destroy()
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

function GuiBase:Disconnect()
	for _,connection:RBXScriptConnection in self.EventConnection do
		connection:Disconnect()
	end
end

return GuiBase
