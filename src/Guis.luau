local Guis = {}

local GuiStructFolder = script.Parent.GuiStructs

local GuiBase = require(GuiStructFolder.Base.GuiBase)
local FrameBase = require(GuiStructFolder.Base.FrameBase)

local FMhandler = require(GuiStructFolder.FMhandler)
local GIhandler = require(GuiStructFolder.GIhandler)
local SChandler = require(GuiStructFolder.SChandler)
local Screen = require(GuiStructFolder.Screen)
local TGhandler = require(GuiStructFolder.TGhandler)
local VPhandler = require(GuiStructFolder.VPhandler)


export type GuiBase = GuiBase.GuiBase
export type FrameBase = FrameBase.FrameBase

export type FMhandler = FMhandler.FMhandler
export type GIHandler = GIhandler.GIHandler
export type SChandler = SChandler.SChandler
export type Screen = Screen.Screen
export type TGhandler = TGhandler.TGhandler
export type VPhandler = VPhandler.VPhandler

local Structs = {
    FrameBase = FrameBase,
    GuiBase = GuiBase,

    FMhandler = FMhandler,
    GIhandler = GIhandler,
    SChandler = SChandler,
    Screen = Screen,
    TGhandler = TGhandler,
    VPhandler = VPhandler
}

table.freeze(Structs)
Guis["Structs"] = Structs

-- MIND: mapping will also have characteristics of chain
export type Map = {
	Mapping : {[string] : GuiBase},
	Default : GuiBase
}

local UIs = {
	"UIAspectRatioConstraint",
	"UICorner",
	"UIGridLayout",
	"UIPadding",
	"UIListLayout",
	"UISizeConstraint",
	"UIStroke"
}

local DEFAULT_MAP:Map = {
	Mapping = {
		["ScreenGui"] = Screen
	},
	Default = GuiBase
}


local function IsInIsAIsName(Targetvalue:Instance, Table:{Instance}):boolean
	for _,value:Instance in Table do
		if Targetvalue:IsA(value) or Targetvalue.Name == value then
			return true
		end
	end
	return false
end

--[[
	-- MIND: mapping will also have characteristics of chain "filter"
]]
local function GetClass(GuiObject:Instance, Event:BindableEvent, Map:Map):GuiBase
	if not GuiObject:IsA("GuiBase") then
		return nil
	end
	for InstanceType, Struct in Map.Mapping do
		if GuiObject.ClassName == InstanceType or GuiObject.Name == InstanceType then
			return Struct.new(GuiObject, Event)
		end
	end
	return Map.Default.new(GuiObject, Event)
end

--[[
	this will be using deep first serach method with recurtion (BuildBranch fn())
	exclude is not totaly done but should still work
]]
function Guis.GetTree(GuiObject:GuiObject, Event:BindableEvent?, Map:Map?, Exclude:{Instance}?):FrameBase
	if Map then
		assert(Map.Mapping and Map.Default, `bad argument map`)
	end

	debug.profilebegin("BuildingGuiTree")
	local Tree = {
        [GuiObject.Name] = Guis.BuildTree(GuiObject, Event, Map or DEFAULT_MAP, Exclude or UIs)
    }
	debug.profileend()
	return Tree
end

function Guis.BuildTree(GuiObject:GuiObject, Event:BindableEvent?, Map:Map?,Exclude:{Instance}?):GuiBase
	local Childres: {GuiObject} = GuiObject:GetChildren()
	local Tree = GetClass(GuiObject, Event, Map)

	if #Childres == 0 then
		if IsInIsAIsName(GuiObject, Exclude) then
			return nil
		end
		return Tree
	end

	for _,Child in Childres do
		if IsInIsAIsName(Child, Exclude) then
			continue
		end

		local Branch = Guis.BuildTree(Child, Event, Map, Exclude)
		if Branch then
			if not(Tree.__index) == "FrameBase" then
				error(`can't add childrens to a non-frame struct`)
			end
			Tree:AddChildren(Branch)
		end
	end
	return Tree
end

local DEFAULT_BINDEVENT = Instance.new("BindableEvent")
DEFAULT_BINDEVENT.Name = "GuiEvent"

function Guis.GetDefaultEvent(Name:string?)
    local Event = DEFAULT_BINDEVENT:Clone()
    if Name then
        Event.Name = Name
    end
    return Event
end

--[[

for _, guistruct:ModuleScript in GuiStructFolder:GetChildren() do
    if not(guistruct:IsA("ModuleScript")) then
        continue
    end
    local module = require(guistruct)
    Guis[guistruct.Name] = module
end

for _, base:ModuleScript in GuiStructFolder.Base:GetChildren() do
    if not(base:IsA("ModuleScript")) then
        continue
    end
    local module = require(base)
    Guis[base.Name] = module
end

table.freeze(Guis)

]]

return Guis