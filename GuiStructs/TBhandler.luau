local GuiBase = require(script.Parent.Base.GuiBase)
local TBhandler = setmetatable({}, GuiBase)
TBhandler.__index = TBhandler

export type TBhandler = typeof(setmetatable(
    {}::{

    }, TBhandler))

function TBhandler.new(TextBox:TextBox, BindableEvent:BindableEvent)
    local self = setmetatable(GuiBase.new(TextBox,  BindableEvent), TBhandler)

    local FocusedEvent = TextBox.Focused
    self.Items = {}
    self.FocusedEvent = FocusedEvent
    self.FocusedConnection = FocusedEvent:Connect(function()
        
    end)


    return self
end


--[[
    uses a binary search
]]
function TBhandler:Search(string:string)
    
end

return TBhandler